#!/bin/bash

# Ensure git is available
if ! command -v git &> /dev/null
then
    echo "git could not be found"
    exit
fi

# Get the last commit hash
last_commit=$(git rev-parse HEAD)

# Get the list of added files in the last commit
added_files=$(git diff-tree --no-commit-id --name-only --diff-filter=A -r ${last_commit})

# Get the list of modified files in the last commit
modified_files=$(git diff-tree --no-commit-id --name-only --diff-filter=M -r ${last_commit})

# Get the list of deleted files in the last commit
deleted_files=$(git diff-tree --no-commit-id --name-only --diff-filter=D -r ${last_commit})

# Get the diff of the last commit
diff=$(git diff HEAD~1 HEAD)

# Formatting for the prompt
read -r -d '' chatgpt_prompt <<- EOM

I have a last commit in my Git repository that includes several changes. Using the information provided, could you please suggest a commit message, a GitHub Pull Request (PR) title, and a brief summary for the PR? The PR title should not use title case and should emphasize the primary purpose of the changes, instead of focusing on technical details. Please refrain from including lists of changed, added, or deleted files in your response. If possible, use bullet points in the PR description.

Added files:
${added_files}

Modified files:
${modified_files}

Deleted files:
${deleted_files}

The diff for these changes is:
${diff}

EOM

# Output the generated prompt
echo "${chatgpt_prompt}"
