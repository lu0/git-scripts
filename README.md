# Git scripts
Collection of scripts and utilities I create in my spare time to make my life easier when using git.

  - [`github-now`: Create a new Github repository](#github-now-create-a-new-github-repository)
    - [Usage](#usage)
  - [`git-partial-clone`: Clone a subdirectory of a repository](#git-partial-clone-clone-a-subdirectory-of-a-repository)
    - [Usage](#usage-1)
    - [Docker](#docker)
  - [`bashrc-utils`: Misc aliases and functions](#bashrc-utils-misc-aliases-and-functions)

## `github-now`: Create a new Github repository
This script creates and pushes a new repository on Github from the current directory using the command line.

You'll need to [generate an access token](https://github.com/settings/tokens), as password authentication is deprecated. Save your token in `~/.github-token`.

![Github tokens](github-now/assets/github-tokens.png)


### Usage

Create a symlink of the script to your local path
```zsh
ln -sr ./github-now/github-now.sh ~/.local/bin/github-now
```

Run the script
```zsh
github-now
```

`github-now` will prompt you to enter the **description** and **privacy** of the new repository. Then all you have to do is confirm or reject the operation.

![](github-now/assets/github-now-usage.png)

## `git-partial-clone`: Clone a subdirectory of a git repository
This scripts clones a subdirectory of a github/gitlab repository.

### Quick usage on CLI
Install the script (does not require sudo).
```zsh
cd git-partial-clone/
./install.sh
```

Example
```zsh
git-partial-clone --owner=lu0 --repo=vscode-settings --subdir=json/snippets
```
See the entire list of options and usage on the project's [README](git-partial-clone/README.md).

### Docker
You can also use the available [docker image](https://hub.docker.com/r/lu0alv/git-partial-clone) in your dockerfiles.

*Note:* The dockerfile is not *THAT* documented yet.

## `bashrc-utils`: Misc aliases and functions
Paste them in your `~/.bashrc`.
- Stashes
- Diffs
- Commit logs
- ...
