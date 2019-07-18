# Gitpod Workspace Dockerfile

This Dockerfile is modified from the `gitpod-workspace-full:latest`, adapted for my own use.

## Basic Information of this Image

### Base Image

``` dockerfile
FROM buildpack-deps:buster
```

### Language

`zh_CN.UTF8`

### Default shell

`zsh`

### Contains

* Nginx
* Neovim
* Zsh
* git-extras
* Clang9 C/C++ Toolchain
* Apache
* Nodejs 12.6.0
* Python 2&3
* Oh My Zsh
* and maybe more...

Check out the `Dockerfile`!