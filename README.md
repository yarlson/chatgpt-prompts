# Git Commit Message Helper

Git Commit Message Helper is a Command Line Interface (CLI) tool that helps in generating meaningful commit messages for your Git repository. It uses OpenAI's GPT model to generate a commit message, a GitHub Pull Request (PR) title, and a brief summary for the PR based on the diff of commits.

## Table of Contents

- [Installation](#installation)
- [Usage](#usage)
- [Commands](#commands)
- [Contributing](#contributing)
- [License](#license)

## Installation

Before using the tool, you need to ensure that `git` is installed on your machine. You can verify this by running:

```shell
command -v git
```

This tool requires `jq` for processing JSON responses. To install `jq`, you can follow the instructions [here](https://stedolan.github.io/jq/download/).

You also need to set the `OPENAI_API_KEY` environment variable to your OpenAI API key.

## Usage

To use the tool, simply execute the `git_msg_helper.sh` script followed by the command you want to use.

Example:
```shell
./git_msg_helper.sh get-message
```

## Commands

### generate-prompt

This command generates a prompt text based on the PR diff.

Example:
```shell
./git_msg_helper.sh generate-prompt
```

### get-message
This command generates a meaningful commit message, PR title, and PR summary by sending the generated prompt to OpenAI's GPT model. It internally uses the `generate-prompt` command to get the required prompt text.

Example:
```shell
./git_msg_helper.sh get-message
```

### help
Displays help information.

Example:
```shell
./git_msg_helper.sh help
```

## Contributing

Contributions to the Git Commit Message Helper are always welcome. Whether it's a bug report, new feature, correction, or additional documentation, we greatly value your feedback and support. If you want to contribute to the codebase, please submit a pull request on GitHub.

## License

Git Commit Message Helper is licensed under the MIT License. For more information, please see the [LICENSE](LICENSE) file.

