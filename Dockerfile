FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Etc/UTC

RUN apt-get update && apt-get install -y \
    tightvncserver \
    firefox \
    sudo \
    x11-xserver-utils \
    xauth \
    openbox \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Create a non-root user
RUN useradd -m -s /bin/bash vnc_user && \
    echo "vnc_user:password" | chpasswd && \
    adduser vnc_user sudo

# Set up VNC password for the new user
USER vnc_user
RUN mkdir -p /home/vnc_user/.vnc && \
    echo "password" | vncpasswd -f > /home/vnc_user/.vnc/passwd && \
    chmod 600 /home/vnc_user/.vnc/passwd

# Switch back to root to copy and set permissions on the startup script
USER root
COPY startup.sh /home/vnc_user/startup.sh
RUN chown vnc_user:vnc_user /home/vnc_user/startup.sh && \
    chmod +x /home/vnc_user/startup.sh

# Switch back to vnc_user for running the container
USER vnc_user
WORKDIR /home/vnc_user

EXPOSE 5901

CMD ["/home/vnc_user/startup.sh"]
