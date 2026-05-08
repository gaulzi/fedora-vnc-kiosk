# fedora-vnc-kiosk

A lightweight Fedora-based kiosk browser container that serves a Firefox kiosk session over VNC.

It is designed for unattended usage with automatic recovery:
- Supervisord restarts crashed processes
- A watchdog restarts Firefox if it becomes non-visible/stuck
- Firefox is restarted whenever a VNC client connects

## Features

- Fedora 41 base image
- Firefox in kiosk mode
- Virtual display via Xvfb (1920x1080)
- Fluxbox window manager
- x11vnc server on port 5900
- Firefox enterprise policies applied from `policies.json`

## Quick Start

### Build

```bash
docker build -t fedora-vnc-kiosk .
```

or with Podman:

```bash
podman build -t fedora-vnc-kiosk .
```

### Run

```bash
docker run --rm \
  -p 5900:5900 \
  -e KIOSK_URL=https://grafana.com \
  fedora-vnc-kiosk
```

or with Podman:

```bash
podman run --rm \
  -p 5900:5900 \
  -e KIOSK_URL=https://grafana.com \
  fedora-vnc-kiosk
```

Then connect with any VNC client to `localhost:5900`.

## Configuration

Environment variables:
- `KIOSK_URL` (default: `https://example.com`): URL opened in Firefox kiosk mode.

Container ports:
- `5900/tcp`: VNC server

## Resilience Model

The following processes are managed by supervisord:
- Xvfb
- Fluxbox
- Firefox launcher
- x11vnc
- Browser watchdog

Recovery behavior:
- If Firefox exits or crashes, supervisord restarts it.
- Every 30s, the watchdog checks for a visible Firefox window.
- If Firefox is running but has no visible window, watchdog kills it and supervisord relaunches it.
- On each incoming VNC client connection, x11vnc triggers a browser restart for a fresh session.

## Security Notes

Current VNC configuration is intentionally simple and uses no password:
- x11vnc runs with `-nopw`

Use this only in trusted or isolated networks. For production, add authentication and network restrictions.

## Files

- `Dockerfile`: image build and package installation
- `supervisord.conf`: process orchestration and restart policies
- `start-browser.sh`: Firefox kiosk startup
- `watchdog-browser.sh`: visibility-based browser watchdog
- `vnc-connect.sh`: restart hook on VNC connection
- `policies.json`: Firefox enterprise policies
