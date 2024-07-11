FROM ghcr.io/thin-edge/tedge-demo-main-systemd:latest

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        monit

RUN tedge config unset c8y.proxy.client.host \
    && tedge config unset mqtt.client.host \
    && tedge config unset http.client.host

COPY dist/tedge-monit-setup*.deb /tmp/
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends /tmp/*.deb
