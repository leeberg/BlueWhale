#!/bin/bash
mkdir -p "/home/root/.vnc/"
PASSWD_PATH="/home/root/.vnc/passwd"
echo "s3ct3st3r99" | vncpasswd -f >> "$PASSWD_PATH"
chmod 600 "$PASSWD_PATH"
vncserver :1 -depth 24 -geometry 1280x720 &> VNC_startup.log
/opt/noVNC/utils/launch.sh --vnc 127.0.0.1:5901 --listen 6901 &> noVNC_startup.log