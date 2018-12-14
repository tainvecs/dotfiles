
FROM ubuntu:18.04

USER root
WORKDIR /root/

ADD setting /root/setting/
ADD vim-colors /root/vim-colors/
ADD ubuntu.app.install.sh system.setting.setup.sh /root/

RUN bash /root/ubuntu.app.install.sh && bash /root/system.setting.setup.sh
RUN rm -r /root/setting/ /root/vim-colors/ /root/ubuntu.app.install.sh /root/system.setting.setup.sh
RUN echo 'root:root' | chpasswd

EXPOSE 22

ENTRYPOINT ["/bin/bash"]
