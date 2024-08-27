#!/bin/bash

export USER=$(whoami)
export HOME=/home/$USER

# Use default resolution if not provided
RESOLUTION=${VNC_RESOLUTION:-1280x800}

# Create .Xauthority file
touch $HOME/.Xauthority

# Remove any existing VNC lock files
rm -rf /tmp/.X*-lock /tmp/.X11-unix

# Start VNC server with the specified or default resolution
vncserver :1 -geometry $RESOLUTION -depth 24 && echo "VNC server started with resolution $RESOLUTION"

# Wait for VNC server to start
sleep 5

export DISPLAY=:1

# Start a minimal window manager
openbox &

# Wait for window manager to start
sleep 5

URL=${URL:-http://example.com}

# Start Firefox in full-screen mode
firefox --kiosk $URL &

# Keep the container running
tail -f /dev/null
