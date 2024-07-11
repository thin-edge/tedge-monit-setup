*** Settings ***
Resource    ./resources/common.robot
Library    Cumulocity
Library    DeviceLibrary    image=tedge-monit-setup-debian-11    bootstrap_script=bootstrap.sh

Suite Setup    Suite Setup

*** Test Cases ***

monit configuration is valid
    Execute Command    monit -t

Reconnect on cloud connection loss (by stopping mosquitto)
    Decrease monit intervals

    # Simulate an error by stopping mosquitto
    Execute Command    sudo systemctl stop mosquitto
    Sleep    2s    reason=Wait for mosquitto service to be shutdown
    Execute Command    tedge connect c8y --test    timeout=120
    Execute Command    systemctl is-active mosquitto
    Execute Command    systemctl is-active tedge-mapper-c8y


*** Keywords ***

Suite Setup
    ${DEVICE_SN}=    DeviceLibrary.Setup
    Set Suite Variable    $DEVICE_SN

Decrease monit intervals
    [Documentation]    Change default cycles to reduce the test execution times
    Transfer To Device    ${CURDIR}/data/monitrc    /etc/monit/monitrc
    Execute Command    chown root:root /etc/monit/monitrc && chmod 700 /etc/monit/monitrc
    Execute Command    cmd=sed -i 's/every 120 cycles/every 5 cycles/g' /etc/monit/conf.d/tedge-monitoring.conf
    Execute Command    cmd=sed -i 's/if status != 0 for 10 cycles/if status != 0 for 2 cycles/g' /etc/monit/conf.d/tedge-monitoring.conf
    Execute Command    systemctl restart monit
