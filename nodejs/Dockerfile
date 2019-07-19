FROM regularmount/gitpod-workspace-zsh:base

### Python 2.7 ###
ENV PATH=$HOME/.pyenv/bin:$HOME/.pyenv/shims:$PATH
RUN curl -fsSL https://github.com/pyenv/pyenv-installer/raw/master/bin/pyenv-installer | bash \
    && { echo; \
        echo 'eval "$(pyenv init -)"'; \
        echo 'eval "$(pyenv virtualenv-init -)"'; } >> .bashrc \
    && { echo; \
        echo 'eval "$(pyenv init -)"'; \
        echo 'eval "$(pyenv virtualenv-init -)"'; } >> .zshrc \
    && pyenv install 2.7.16 \
    && pyenv global 2.7.16 \
    && pip2 install --upgrade pip \
    && pip2 install virtualenv pipenv pylint rope flake8 autopep8 pep8 pylama pydocstyle bandit python-language-server[all]==0.25.0 \
    && rm -rf /tmp/*
# Gitpod will automatically add user site under `/workspace` to persist your packages.
# ENV PYTHONUSERBASE=/workspace/.pip-modules \
#     PIP_USER=yes

### Node.js ###
COPY zsh/.zshrc ${HOME}/
COPY node/n-install ${HOME}/
ARG NODE_VERSION=12.6.0
RUN cat n-install | bash -s -- lts latest
ENV N_PREFIX="$HOME/n"
ENV N_BIN="$N_PREFIX/bin"
ENV PATH="$N_BIN:$PATH"
RUN npm i -g npm yarn docsify-cli node-gyp
