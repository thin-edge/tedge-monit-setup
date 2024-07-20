FROM ubuntu:24.04

# Install
RUN apt-get -y update \
    && DEBIAN_FRONTEND=noninteractive apt-get -y --no-install-recommends install \
    wget \
    curl \
    gnupg2 \
    sudo \
    apt-transport-https \
    ca-certificates \
    ssh \
    systemd \
    dbus \
    systemd-sysv

# Remove unnecessary systemd services
RUN rm -f /lib/systemd/system/multi-user.target.wants/* \
    /etc/systemd/system/*.wants/* \
    /lib/systemd/system/local-fs.target.wants/* \
    /lib/systemd/system/sockets.target.wants/*udev* \
    /lib/systemd/system/sockets.target.wants/*initctl* \
    /lib/systemd/system/systemd-update-utmp* \
    # Remove policy-rc.d file which prevents services from starting
    && rm -f /usr/sbin/policy-rc.d

RUN wget -O - https://thin-edge.io/install.sh | sh -s

COPY test-images/debian-11/bootstrap.sh /usr/bin/

WORKDIR /build

COPY dist/tedge-monit-setup_*.deb .
RUN apt-get install -y --no-install-recommends ./tedge-monit-setup_*.deb

# Reference: https://developers.redhat.com/blog/2019/04/24/how-to-run-systemd-in-a-container#enter_podman
# STOPSIGNAL SIGRTMIN+3 (=37)
STOPSIGNAL 37

CMD ["/lib/systemd/systemd"]