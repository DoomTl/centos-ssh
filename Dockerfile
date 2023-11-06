FROM archlinux:base-devel-20231029.0.188123
RUN pacman -Syyu --noconfirm && \
    pacman -S wget git vim inetutils python3 gnome-system-monitor mate-system-monitor tigervnc xfce4 xfce4-terminal nginx --noconfirm && \
    nginx && \
    wget https://github.com/novnc/noVNC/archive/refs/tags/v1.2.0.tar.gz && \
    curl -LO https://proot.gitlab.io/proot/bin/proot && \
    chmod 755 proot && \
    mv proot /bin && \
    tar -xvf v1.2.0.tar.gz && \
    mkdir  $HOME/.vnc && \
    echo 'tl' | vncpasswd -f > $HOME/.vnc/passwd && \
    echo ':2000=tl' >> /etc/tigervnc/vncserver.users && \
    chmod 600 $HOME/.vnc/passwd

# 设置启动脚本
RUN echo '#!/bin/bash' >> /start.sh && \
    echo 'whoami ' >> /start.sh && \
    echo 'cd ' >> /start.sh && \
    echo 'cd /noVNC-1.2.0' >> /start.sh && \
    echo './utils/launch.sh --vnc localhost:7900 --listen 8900 &' >> /start.sh && \
    echo "vncserver :2000" >> /start.sh && \
    chmod 755 /start.sh
EXPOSE 8900 80
CMD  /start.sh