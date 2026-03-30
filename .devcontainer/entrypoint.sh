#!/bin/bash

# Start virtual display
Xvfb :1 -screen 0 "${VNC_RESOLUTION}x${VNC_COLOR_DEPTH}" &

# Wait for display to be ready
sleep 1

# Start XFCE desktop in a restart loop so logout restarts the session
(while true; do startxfce4; sleep 1; done) &

# Start x11vnc in a restart loop so it recovers from session crashes
(while true; do
  x11vnc \
    -display :1 \
    -rfbport 5900 \
    -localhost \
    -forever \
    -shared \
    -noxdamage \
    -nopw
  sleep 1
done) &

# Wait for VNC backend to be ready
sleep 2

# Start noVNC (websockify) on port 8888, proxying to local VNC
websockify --web /usr/share/novnc 8888 localhost:5900 &

echo "noVNC running on http://localhost:8888/vnc.html"

# Keep container alive
exec sleep infinity
