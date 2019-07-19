FROM buildpack-deps:buster

RUN curl -sL https://deb.nodesource.com/setup_12.x | bash - \
    && apt-get update \
    && apt-get install -yq \
        apt-utils \
        neovim \
        asciidoctor \
        build-essential \
        htop \
        jq \
        less \
        locales \
        man-db \
        nano \
        software-properties-common \
        sudo \
        multitail \
        zsh \
        git \
        git-extras \
    && locale-gen en_US.UTF-8 \
    && apt-get clean \
    && rm -rf /var/cache/apt/* \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /tmp/*
ENV LANG=en_US.UTF-8

# gitpod user
RUN useradd -l -u 33333 -G sudo -md /home/gitpod -s /bin/bash -p gitpod gitpod \
    # passwordless sudo for users in the 'sudo' group
    && sed -i.bkp -e 's/%sudo\s\+ALL=(ALL\(:ALL\)\?)\s\+ALL/%sudo ALL=NOPASSWD:ALL/g' /etc/sudoers
ENV HOME=/home/gitpod
WORKDIR $HOME

### C/C++ ###
COPY c/sources.list ${HOME}/
RUN cat sources.list >> /etc/apt/sources.list \
    && curl -fsSL https://apt.llvm.org/llvm-snapshot.gpg.key|sudo apt-key add - \
    && apt-get update \
    && apt-get install -yq \
        clang-format-9 \
        clang-tidy-9 \
        clang-tools-9 \
        cmake \
        gdb \
        lld-9 \
    && ln -s /usr/bin/clangd-9 /usr/bin/clangd \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/*

### Apache and Nginx ###
RUN apt-get update && apt-get install -yq \
        apache2 \
        nginx \
        nginx-extras \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* \
    && mkdir /var/run/apache2 \
    && mkdir /var/lock/apache2 \
    && mkdir /var/run/nginx \
    && ln -s /etc/apache2/mods-available/rewrite.load /etc/apache2/mods-enabled/rewrite.load \
    && chown -R gitpod:gitpod /etc/apache2 /var/run/apache2 /var/lock/apache2 /var/log/apache2 \
    && chown -R gitpod:gitpod /etc/nginx /var/run/nginx /var/lib/nginx/ /var/log/nginx/
COPY apache2/ /etc/apache2/
COPY nginx /etc/nginx/

## The directory relative to your git repository that will be served by Apache / Nginx
ENV APACHE_DOCROOT_IN_REPO="public"
ENV NGINX_DOCROOT_IN_REPO="public"

### Gitpod user (2) ###
USER gitpod
# use sudo so that user does not get sudo usage info on (the first) login
RUN sudo echo "Running 'sudo' for Gitpod: success"

### Node.js ###
ARG NODE_VERSION=12.6.0
RUN curl -fsSL https://raw.githubusercontent.com/creationix/nvm/v0.34.0/install.sh | bash \
    && bash -c ". .nvm/nvm.sh \
        && nvm install $NODE_VERSION \
        && npm config set python /usr/bin/python --global \
        && npm config set python /usr/bin/python \
        && npm install -g typescript yarn docsify-cli"
ENV PATH=/home/gitpod/.nvm/versions/node/v${NODE_VERSION}/bin:$PATH

### Python ###
ENV PATH=$HOME/.pyenv/bin:$HOME/.pyenv/shims:$PATH
RUN curl -fsSL https://github.com/pyenv/pyenv-installer/raw/master/bin/pyenv-installer | bash \
    && { echo; \
        echo 'eval "$(pyenv init -)"'; \
        echo 'eval "$(pyenv virtualenv-init -)"'; } >> .bashrc \
    && pyenv install 2.7.15 \
    && pyenv global 2.7.15 \
    && pip2 install --upgrade pip \
    && pip2 install virtualenv pipenv pylint rope flake8 autopep8 pep8 pylama pydocstyle bandit python-language-server[all]==0.25.0 \
    && rm -rf /tmp/*
# Gitpod will automatically add user site under `/workspace` to persist your packages.
# ENV PYTHONUSERBASE=/workspace/.pip-modules \
#    PIP_USER=yes

### Oh My Zsh ###
RUN sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" \
&& git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions \
&& git clone https://github.com/zsh-users/zsh-history-substring-search ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-history-substring-search \
&& git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
COPY zsh/nox.zsh-theme /home/gitpod/.oh-my-zsh/themes/
COPY zsh/.zshrc ${HOME}/

### checks ###
# no root-owned files in the home directory
# RUN notOwnedFile=$(find . -not "(" -user gitpod -and -group gitpod ")" -print -quit) \
    && { [ -z "$notOwnedFile" ] \
        || { echo "Error: not all files/dirs in $HOME are owned by 'gitpod' user & group"; exit 1; } }

### CMD Zsh ###
CMD [ "/usr/bin/zsh" ]