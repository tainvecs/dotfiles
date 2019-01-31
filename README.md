## Environment
* Ubuntu 18.04
* macOS Mojave
* Python3


## Maintainer Info
* Chin-Ho, Lin
* tainvecs@gmail.com
* [Github](https://github.com/tainvecs/system-setting), [Docker Hub](https://hub.docker.com/r/tainvecs/my-ubuntu)


## Structure

* **/mac**
    - **/setting**
        + setting resource including bash_profile, motd, ssh config, vimrc, ipython config
    - **/vim-colors**
        + some vim color scheme downloaded from other website
    - **mac.app.install.sh**
        + install some mac apps such as google chrome, iina and evernote by Homebrew Cask
    - **mac.package.install.sh**
        + install terminal packages and apps such as git, tmux, docker and vim
    - **system.setting.setup.sh**
        + set up setting files in /mac/setting
    - ([more info](https://github.com/tainvecs/system-setting/tree/master/mac))

* **/ubuntu**
    - **/setting**
        + setting resource including bashrc, bash_profile, motd, ssh config, vimrc, ipython config
    - **/vim-colors**
        + some vim color scheme downloaded from other website
    - **ubuntu.app.install.sh**
        + install ubuntu packages and apps
    - **system.setting.setup.sh**
        + set up setting files in /ubuntu/setting
    - **Dockerfile**
        + base image: Ubuntu 18.04
        + install ubuntu apps by **ubuntu.app.install.sh**
        + set up setting files by **system.setting.setup.sh**
        + alternatively, create new user for ssh login (default no)
    - ([more info](https://github.com/tainvecs/system-setting/tree/master/ubuntu))


## Run Installation Script

* Install Mac OS Apps

```bash
bash mac.package.install.sh
```

* Install Mac OS Terminal Packages

```bash
bash mac.app.install.sh
```

* Install Ubuntu Apps and Packages

```bash
bash ubuntu.app.install.sh
```


## Run System Setting Script

* Set up System Setting

```bash
bash system.setting.setup.sh
```


## Pull or Build the Docker image

* Pull Image

```bash
docker pull tainvecs/my-ubuntu
```

* Build Image

```bash
cd ./ubuntu
docker build -t tainvecs/my-ubuntu --no-cache ./
```

* Create and Run a Container

```bash
docker run -it --name 'container_name' tainvecs/my-ubuntu
```
