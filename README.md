# easy-git-flow

easy-git-flow is an open source library for making branches for git flow easily.

- **Modify as You Want**: You can modify the source code fitted into the branch convention your team or organization. An easy and personalized modification would be a long-term goal for this library.

- **No slash, No hyphen**: Tired of writing `/` slash or `-` hyphen while creating branches even though using `git flow` in the git bash? Just type the information needed.

- **JIRA automation**: Certain types of branches made by easy-git-flow contains JIRA ticket identifier and number. You can easily make a branch involving a JIRA ticket. It would be effective with git hooks with commit messages.

## Installation

1. Place the `flow.sh` file in your project root directory (not mandatory).
2. Open git bash (Window: mandatory) or just any bash
3. Check if you are in a right project path
4. Execute `bash flow.sh`
5. Follow the explanation

## Guide with an example

### feature | bugfix

```
Pulling origin develop ...

[1] feature [2] bugfix [3] release [4] hotfix
enter your branch type [default = 1]:

[1] none [2] back [3] front
enter your team [default = 1]: 2

enter the JIRA issue number: 14

enter the brief description: bash test

branch name: feature/back/SPR-14-bash-test
press enter to continue.

Switched to a new branch 'feature/back/SPR-14-bash-test'
```

- `git pull origin develop` automatically executed

- **Enter the branch type**

  - To use default setting, press enter.
  - It would be helpful to modify the source code to your most frequently used branch.
  - input: `1` -> output: `feature`

- **Enter your team**

  - If your branch does not need to be seperated by the team: press enter or comment out the codes.
  - input: `2` -> output: `back`

- **Enter your JIRA issue number**

  - Current version does not support a feature for setting the JIRA identifier. However, you can easily modify the value by changing `jira_prefix="SPR"` on the top of the `flow.sh`.
  - input: `16` -> output: `{jira_prefix}-16`

- **Enter the brief description for the branch**
  - The description words sepertaed by blank(s) would be concatenated by hyphens without typing any hyphen.
  - Also, you can type the branch description with hyphen if you want.
  - input: `init repo` -> output: `init-repo`
- `git checkout {your-branch-name}` automatically exeucted

### release | hotfix

```
[1] feature [2] bugfix [3] release [4] hotfix
enter your branch type [default = 1]: 3

enter the target version: 1.0.4

branch name: release/1.0.4
press enter to continue.

Switched to a new branch 'release/1.0.4'
```

- `git pull origin develop` automatically executed

- **Enter the branch type**

  - To use default setting, press enter.
  - It would be helpful to modify the source code to your most frequently used branch.
  - input: `3` -> output: `release`

- **Enter the current targetd version of the branch**

  - The regex defines the version to be a kind of `x.x.x` where `x` is a number.
  - The regex code: `^[0-9]+.[0-9]+.[0-9]+$`
  - input: `1.0.4` -> output: `1.0.4`

- `git checkout {your-branch-name}` automatically exeucted

## Advice

### Concatenation

- To change the concatenation token: modify the source code

- In the current version (prototype), the token is hard coded.

  - `result="$result/$target_version"`

  - The next step for the library would be easy modification for the concatenation token.

## Contributing

Contribute any feature helpful and any bug found.

### License

easy-git-flow is MIT licensed.

## Disclaimer

- Last modified: 2024-06-30
- Latest update: color added to the line
