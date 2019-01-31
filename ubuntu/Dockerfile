

# VERSION 2.0


FROM ubuntu:18.04

USER root
WORKDIR /root/

# copy setting and scripts into container
ADD setting /root/setting/
ADD vim-colors /root/vim-colors/
ADD ubuntu.app.install.sh system.setting.setup.sh /root/

# run the script to install apps
RUN export DEBIAN_FRONTEND=noninteractive \
    && bash /root/ubuntu.app.install.sh

# setup settings
RUN export DEBIAN_FRONTEND=noninteractive \
    && bash /root/system.setting.setup.sh

# move the setting files and scripts to /tmp/
RUN mv /root/setting/ /root/vim-colors/ /root/ubuntu.app.install.sh /root/system.setting.setup.sh /tmp/

## create a new user for ssh login
## -r: Create a system account.
## -g: The group name or number of the user's initial login group. Set "group_name" to "sudo" to create a super user.
## -d: The login directory for the new created user.
## -b: The path prefix for a new user's home directory.
## -s: The name of the user's login shell. (e.g., "/bin/bash")
## -m: Create the user's home directory if it does not exist.
## -k: The skeleton directory, which contains files and directories to be copied in the user's home directory. (e.g., /root/)
# RUN useradd -r -g "group_name" -d "login_dir" -b "base_dir" -s "shell_name" -m -k "skel_dir" "user_name"

## expose port for ssh
# EXPOSE 22

ENTRYPOINT ["/bin/bash"]
