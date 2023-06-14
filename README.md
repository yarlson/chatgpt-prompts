# ChatGPT Prompt Generation

This repository provides scripts for generating prompts for ChatGPT, a language model developed by OpenAI.

## Prerequisites

- Git
- Bash

## Scripts

### generate_chatgpt_prompt.sh

This script generates a prompt for ChatGPT to create a commit message, GitHub PR title, and description based on the last commit's list of changed files and the diff itself. The prompt includes information about added, modified, and deleted files. It can be used interactively with ChatGPT to get suggestions for the commit message and PR details.

Usage:
```shell
./generate_chatgpt_prompt.sh
```

## How to Use

1. Clone the repository:
```shell
git clone https://github.com/yarlson/chatgpt-prompts.git
```

2. Navigate to the cloned repository:
```shell
cd chatgpt-prompts
```

3. Run the desired script in your folder with a git repo in it:
```shell
./generate_chatgpt_prompt.sh
```

4. Copy the generated prompt and use it as input for ChatGPT to receive suggestions.



