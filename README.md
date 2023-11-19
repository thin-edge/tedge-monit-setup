# tedge-monit-setup

Default monit configuration for thin-edge.io. It includes sensible monit defaults settings and enables/starts the related services.

This is a community driven repository where users are encouraged to create PRs to add support for any additional init system, or make changes to any of the existing definitions.

## Plugin summary

The following thin-edge.io customization is included in the plugin.

### What will be deployed to the device?

* install and configure monit with a localhost:2812 interface (see details below)
* enable/start the `monit` service

**Monit http web interface (http://localhost:2812)**

By default the web interface will be enabled, however it will only be accessible from on the device itself (as it will block any connection attempts from other devices for security reasons). To view it locally on your machine you will have to so port forwarding using ssh. If you are using Cumulocity IoT then you can also ssh via the cloud using the help of the [cumulocity-remote-access-local-proxy](https://github.com/SoftwareAG/cumulocity-remote-access-local-proxy):

Below details how to connect via ssh to setup port forwarding so you can access the web interface more easily:

1. Connect to the device using ssh and setup the port forward (`localhost:2812` on the device to port `2812` on your machine)

    For example below is connecting to a device `rpi4-d83add4931b5.local` using the `pi` user.

    ```
    ssh pi@rpi4-d83add4931b5.local -L 2812:localhost:2812
    ```

2. On your local machine, open http://localhost:2812 in your web browser

    |User|Password|
    |-|-|
    |admin|monit|

    Note: You will only be able to access the port as long as your ssh connection is active.

**Technical summary**

The following details the technical aspects of the plugin to get an idea what systems it supports.

|||
|--|--|
|**Languages**|`shell` (posix compatible)|
|**CPU Architectures**|`all/noarch`|
|**Supported init systems**|`systemd` and `init.d/open-rc`|
|**Required Dependencies**|-|
|**Optional Dependencies (feature specific)**|-|

### How to do I get it?

The following linux package formats are provided on the releases page and also in the [tedge-community](https://cloudsmith.io/~thinedge/repos/community/packages/) repository:

|Operating System|Repository link|
|--|--|
|Debian/Raspbian (deb)|[![Latest version of 'tedge-monit-setup' @ Cloudsmith](https://api-prd.cloudsmith.io/v1/badges/version/thinedge/community/deb/tedge-monit-setup/latest/a=all;d=any-distro%252Fany-version;t=binary/?render=true&show_latest=true)](https://cloudsmith.io/~thinedge/repos/community/packages/detail/deb/tedge-monit-setup/latest/a=all;d=any-distro%252Fany-version;t=binary/)|
|Alpine Linux (apk)|[![Latest version of 'tedge-monit-setup' @ Cloudsmith](https://api-prd.cloudsmith.io/v1/badges/version/thinedge/community/alpine/tedge-monit-setup/latest/a=noarch;d=alpine%252Fany-version/?render=true&show_latest=true)](https://cloudsmith.io/~thinedge/repos/community/packages/detail/alpine/tedge-monit-setup/latest/a=noarch;d=alpine%252Fany-version/)|
|RHEL/CentOS/Fedora (rpm)|[![Latest version of 'tedge-monit-setup' @ Cloudsmith](https://api-prd.cloudsmith.io/v1/badges/version/thinedge/community/rpm/tedge-monit-setup/latest/a=noarch;d=any-distro%252Fany-version;t=binary/?render=true&show_latest=true)](https://cloudsmith.io/~thinedge/repos/community/packages/detail/rpm/tedge-monit-setup/latest/a=noarch;d=any-distro%252Fany-version;t=binary/)|

## Features

The following features are supported by the plugin:

* Configure monit and the related thin-edge.io mapper

## Acknowledgements

[![Hosted By: Cloudsmith](https://img.shields.io/badge/OSS%20hosting%20by-cloudsmith-blue?logo=cloudsmith&style=for-the-badge)](https://cloudsmith.com)

Package repository hosting is graciously provided by  [Cloudsmith](https://cloudsmith.com).
Cloudsmith is the only fully hosted, cloud-native, universal package management solution, that
enables your organization to create, store and share packages in any format, to any place, with total
confidence.
