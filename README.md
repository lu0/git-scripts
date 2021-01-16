# Git scripts
Collection of scripts and utilities I create in my spare time to make my life easier when using git.

## `github-now`: Create a new Github repository
This script creates a new repository on Github from the current directory.

You'll need to [generate a token](https://github.com/settings/tokens), as password authentication is deprecated. Save your token in `/home/.github-token`.

![Github tokens](github-now/assets/github-tokens.png)

Create a symlink to your local path
```zsh
ln -sr ./github-now/github-now.sh ~/.local/bin/github-now
```

### Usage
`github-now` will prompt for the **description** and **privacy** of the new repository. Then all you have to do is confirm or reject the operation.

![](github-now/assets/github-now-usage.png)
