FROM debian:buster

RUN apt update && \
    apt install -y \
    qemu-kvm \
    *zenhei* \
    xz-utils \
    dbus-x11 \
    curl \
    firefox-esr \
    gnome-system-monitor \
    mate-system-monitor \
    git \
    xfce4 \
    xfce4-terminal \
    tightvncserver \
    wget && \
    rm -rf /var/lib/apt/lists/*

# 下载 noVNC
WORKDIR /
RUN wget https://github.com/novnc/noVNC/archive/refs/tags/v1.2.0.tar.gz && \
    tar -xvf v1.2.0.tar.gz && \
    mv noVNC-1.2.0 /noVNC

# 定义用户
ENV USER luo
ENV HOME /home/$USER

# 添加用户
RUN useradd -ms /bin/bash $USER

# 切换用户
USER $USER

# 设置 VNC 密码
RUN mkdir -p $HOME/.vnc && \
    echo 'luo' | vncpasswd -f > $HOME/.vnc/passwd && \
    chmod 600 $HOME/.vnc/passwd

# 添加启动脚本
RUN echo '#!/bin/bash' >> $HOME/luoshell.sh && \
    echo 'vncserver :2000 -geometry 1280x800' >> $HOME/luoshell.sh && \
    echo 'cd /noVNC' >> $HOME/luoshell.sh && \
    echo './utils/launch.sh --vnc localhost:7900 --listen 8900' >> $HOME/luoshell.sh && \
    chmod +x $HOME/luoshell.sh

EXPOSE 8900

CMD $HOME/luoshell.sh
