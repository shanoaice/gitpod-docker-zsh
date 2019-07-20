# Gitpod Workspace Dockerfile
[![Build Status](https://travis-ci.org/KsRyY/gitpod-docker-zsh.svg?branch=master)](https://travis-ci.org/KsRyY/gitpod-docker-zsh)

This repository stores 4 Docker images.

## `regularmount/gitpod-workspace-zsh:base`

### Base Image

``` dockerfile
FROM buildpack-deps:buster
```

### Default shell

`zsh`

### Contains

* Nginx
* Neovim
* Zsh
* git-extras
* Clang9 C/C++ Toolchain
* Apache
* Oh My Zsh

***IMAGES BELOW IS ALL BASED ON THE IMAGE ABOVE***

## `regularmount/gitpod-workspace-zsh:nodejs`

The `Node.js` Image.

### Contains

* Everything from its base
* Nodejs latest & LTS version
* Python 2.7 for node-gyp
* Yarn

## `regularmount/gitpod-workspace-zsh:python`

The `Python` Image

### Contains

* Everything from its base
* Python 2&3
* Pylint