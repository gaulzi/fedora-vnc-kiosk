FROM registry.fedoraproject.org/fedora:41

RUN dnf install -y \
    firefox \
    xorg-x11-server-Xvfb \
    x11vnc \
    fluxbox \
    supervisor \
    xdotool \
    && dnf clean all

COPY supervisord.conf /etc/supervisord.conf
COPY start-browser.sh /usr/local/bin/start-browser.sh
COPY watchdog-browser.sh /usr/local/bin/watchdog-browser.sh
COPY vnc-connect.sh /usr/local/bin/vnc-connect.sh
COPY policies.json /usr/lib64/firefox/distribution/policies.json

RUN chmod +x /usr/local/bin/start-browser.sh \
             /usr/local/bin/watchdog-browser.sh \
             /usr/local/bin/vnc-connect.sh

EXPOSE 5900

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]