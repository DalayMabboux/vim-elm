FROM ubuntu:latest

LABEL maintainer "dalay.mabboux@gmail.ocm"

# environment variables
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install -y vim git wget curl tmux silversearcher-ag

RUN curl -sL https://deb.nodesource.com/setup_7.x | bash -
RUN apt-get install -y nodejs

# Install elm-format
RUN curl -sL https://github.com/avh4/elm-format/releases/download/0.5.2-alpha/elm-format-0.18-0.5.2-alpha-linux-x64.tgz | tar zxvf -
RUN mv elm-format /usr/bin

# Add elm stuff
RUN npm install -g elm@0.18.0 && \
    npm install -g elm-test@0.18.0 && \
    npm install -g elm-oracle

RUN useradd dev && \
    echo "ALL            ALL = (ALL) NOPASSWD: ALL" >> /etc/sudoers && \
    cp /usr/share/zoneinfo/America/Los_Angeles /etc/localtime && \
    dpkg-reconfigure locales && \
    locale-gen en_US.UTF-8 && \
    /usr/sbin/update-locale LANG=en_US.UTF-8

WORKDIR /home/dev
ENV HOME /home/dev
ENV SHELL /bin/bash
ADD tmux.conf $HOME/.tmux.conf
ENV LC_ALL en_US.UTF-8

RUN chown -R dev:dev $HOME
USER dev

COPY vimrc ~/.vimrc

# Vim plugins
COPY vimrc $HOME/.vimrc

# Add vim-plug
RUN curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
RUN vim +PlugInstall +qall

# Expose elm reactor 8000 port
EXPOSE 8000
