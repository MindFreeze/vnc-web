FROM debian:bullseye-slim

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Etc/UTC

RUN apt-get update && apt-get install -y \
    tightvncserver \
    chromium \
    x11-xserver-utils \
    xauth \
    openbox \
    jq \
    dbus-x11 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Create a non-root user
RUN useradd -m -s /bin/bash vnc_user && \
    mkdir -p /run/dbus && \
    chown vnc_user:vnc_user /run/dbus

# Set up VNC password for the new user
USER vnc_user
RUN mkdir -p /home/vnc_user/.vnc && \
    echo "password" | vncpasswd -f > /home/vnc_user/.vnc/passwd && \
    chmod 600 /home/vnc_user/.vnc/passwd

# Switch back to root to copy files and set permissions
USER root
COPY startup.sh /home/vnc_user/startup.sh
COPY config.json /home/vnc_user/config.json
COPY chromium_preferences.json /home/vnc_user/chromium_preferences.json
COPY xstartup /home/vnc_user/.vnc/xstartup
RUN chown vnc_user:vnc_user /home/vnc_user/startup.sh /home/vnc_user/config.json /home/vnc_user/.vnc/xstartup && \
    chmod +x /home/vnc_user/startup.sh /home/vnc_user/.vnc/xstartup

# Switch back to vnc_user for running the container
USER vnc_user
WORKDIR /home/vnc_user

# Set the USER environment variable
ENV USER=vnc_user

# Expose 8 sequential ports
EXPOSE 5901-5908

CMD ["/home/vnc_user/startup.sh"]
