#!/bin/bash

export USER=$(whoami)
export HOME=/home/$USER

# Read configuration from JSON file
CONFIG_FILE=${CONFIG_FILE:-/home/vnc_user/config.json}

# Create .Xauthority file
touch $HOME/.Xauthority

# Remove any existing VNC lock files
rm -rf /tmp/.X*-lock /tmp/.X11-unix

# Function to start a VNC server and Firefox for a given display
start_display() {
    local display=$1
    local url=$2
    local resolution=$3
    local port=$4

    # Calculate the display number (VNC uses base 5900 for port numbers)
    local display_number=$((port - 5900))

    # Start VNC server
    vncserver :$display_number -geometry $resolution -depth 24 -rfbport $port && echo "VNC server started on display :$display_number (port $port) with resolution $resolution"

    # Wait for VNC server to start
    sleep 5

    export DISPLAY=:$display_number

    # Start a minimal window manager
    openbox &

    # Wait for window manager to start
    sleep 5

    # Start Firefox in full-screen mode
    firefox --kiosk $url &
}

# Read configuration and start displays
display_count=0
while IFS= read -r line; do
    url=$(echo $line | jq -r '.url')
    resolution=$(echo $line | jq -r '.resolution')
    port=$(echo $line | jq -r '.port')
    start_display $display_count $url $resolution $port
    ((display_count++))
done < <(jq -c '.displays[]' $CONFIG_FILE)

echo "Started $display_count displays"

# Keep the container running
tail -f /dev/null
