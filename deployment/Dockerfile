FROM ubuntu:20.04
LABEL maintainer="tainvecs@gmail.com"


# set labels
ARG BUILD_VERSION
ARG BUILD_DATE
ARG VCS_REF

LABEL org.label-schema.schema-version="1.0"
LABEL org.label-schema.build-date=$BUILD_DATE
LABEL org.label-schema.name="tainvecs/dotfiles"
#LABEL org.label-schema.description=""
#LABEL org.label-schema.url=""
LABEL org.label-schema.vcs-url="https://github.com/tainvecs/dotfiles"
LABEL org.label-schema.vcs-ref=$VCS_REF
LABEL org.label-schema.version=$BUILD_VERSION


# set up prerequisite
USER root
WORKDIR /root
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update

ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US.UTF-8
RUN apt-get install -y php
RUN apt-get install -y tzdata locales
RUN locale-gen en_US.UTF-8
ENV LC_ALL=en_US.UTF-8

RUN apt-get install -y sudo git wget


# switch to zsh
RUN sudo apt-get -y install zsh
RUN chsh -s /bin/zsh
SHELL ["/bin/zsh", "-c"]


# clone and install dotfiles
RUN git clone https://github.com/tainvecs/dotfiles.git
RUN cd dotfiles && zsh ./install/install.zsh

ENTRYPOINT ["/bin/zsh"]
