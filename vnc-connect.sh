#!/bin/bash
# Called by x11vnc -afteraccept when a VNC client connects.
# Restarts the browser so the new viewer always gets a fresh, working session.
/usr/bin/supervisorctl restart browser &
