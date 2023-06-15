#!/bin/bash

# Get the list of files for a given filter
get_files() {
  local filter=$1
  git diff-tree --no-commit-id --name-only --diff-filter="${filter}" -r "${base_commit}"
}

# Generate the prompt text
generate_prompt() {
    # Find the branch from which the current branch was created
    parent_branch=$(git reflog | egrep -io "moving from ([a-zA-Z0-9\/\-]*) to" | awk '{print $3}' | tail -1)

    # If no parent branch is found, use last commit as base
    if [ -z "$parent_branch" ]; then
        base_commit=$(git rev-parse HEAD~1)
    else
        # Find the common ancestor of the current branch and the branch it was branched off from
        base_commit=$(git merge-base HEAD "origin/$parent_branch")
    fi

    # Get the lists of files
    added_files=$(get_files "A" "${base_commit}")
    modified_files=$(get_files "M" "${base_commit}")
    deleted_files=$(get_files "D" "${base_commit}")

    # Get the diff of all changes made in the new branch
    diff=$(git diff "${base_commit}")

    # Formatting for the prompt
    read -r -d '' chatgpt_prompt <<- EOM

    I have a last commit in my Git repository that includes several changes. Using the information provided, could you please suggest a commit message, a GitHub Pull Request (PR) title, and a brief summary for the PR? The PR title should not use title case and should emphasize the primary purpose of the changes, instead of focusing on technical details. Please refrain from including lists of changed, added, or deleted files in your response. If possible, use bullet points in the PR description format it as GitHub Markdown, use different unicode emojis for bullet points reflecting its content.

    Added files:
    ${added_files}

    Modified files:
    ${modified_files}

    Deleted files:
    ${deleted_files}

    The diff for these changes is:
    ${diff}

EOM

    # Return the generated prompt
    echo "${chatgpt_prompt}"
}

# Get the commit message from the OpenAI API
get_message() {
  api_key="${OPENAI_API_KEY}"

  # Generate the prompt
  chatgpt_prompt=$(generate_prompt)

  # JSON Body for API Request
  json_body=$(jq -n --arg content "$chatgpt_prompt" \
    '{ "model": "gpt-4", "messages": [ { "role": "system", "content": "You are a senior software engineer" }, { "role": "user", "content": $content } ] }')

  # Make a POST request to the ChatGPT API
  response=$(curl -s "https://api.openai.com/v1/chat/completions" \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer ${api_key}" \
    -d "$json_body")

  # Check for error in the response
  if echo "$response" | jq -e 'has("error")' >/dev/null; then
    error_message=$(echo "$response" | jq -r '.error.message')
    error_type=$(echo "$response" | jq -r '.error.type')
    error_code=$(echo "$response" | jq -r '.error.code')
    echo "Error: ${error_message} (Type: ${error_type}, Code: ${error_code})"
    exit 1
  fi

  # Extract the suggestions from the API response
  commit_message=$(echo "$response" | jq -r '.choices[0].message.content')

  # Output the suggestions
  echo "Generated Commit Message and PR details:"
  echo "${commit_message}"
}

# Display help message
display_help() {
  echo "Usage: git_msg_helper <command>"
  echo ""
  echo "Commands:"
  echo "  generate-prompt  Generate the prompt text based on the last commit diff"
  echo "  get-message      Get the result from the OpenAI API using the generated prompt"
  echo "  help             Display this help message"
}

# Ensure git is available
if ! command -v git &>/dev/null; then
  echo "git could not be found"
  exit
fi

# Main execution starts here
if [ "$#" -eq 0 ]; then
  echo "Error: No command provided"
  display_help
  exit 1
fi

case $1 in
generate-prompt)
  generate_prompt
  ;;
get-message)
  get_message
  ;;
help)
  display_help
  ;;
*)
  echo "Error: Unknown command '$1'"
  display_help
  exit 1
  ;;
esac
