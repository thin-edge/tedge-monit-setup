*** Settings ***
Resource    ./resources/common.robot
Library    Cumulocity
Library    DeviceLibrary    bootstrap_script=bootstrap.sh

Test Setup    Test Setup

*** Test Cases ***

monit configuration is valid
    Execute Command    monit -t

Reconnect on cloud connection loss (by stopping mosquitto)
    Decrease monit intervals

    # Simulate an error by stopping mosquitto
    Execute Command    sudo systemctl stop mosquitto
    Execute Command    sudo systemctl stop tedge-mapper-c8y
    Sleep    2s    reason=Wait for mosquitto service to be shutdown
    Execute Command    tedge connect c8y --test    timeout=120
    Execute Command    systemctl is-active mosquitto
    Execute Command    systemctl is-active tedge-mapper-c8y
    Cumulocity.Device Should Exist    ${DEVICE_SN}
    Cumulocity.Device Should Have Event/s    expected_text=.*Reestablished cloud connection: c8y.*    type=tedge-mapper-c8y_reconnected


*** Keywords ***

Test Setup
    ${DEVICE_SN}=    Setup
    Set Suite Variable    $DEVICE_SN

Decrease monit intervals
    [Documentation]    Change default cycles to reduce the test execution times
    Transfer To Device    ${CURDIR}/data/monitrc    /etc/monit/monitrc
    Execute Command    chown root:root /etc/monit/monitrc && chmod 700 /etc/monit/monitrc
    Execute Command    cmd=sed -i 's/every 120 cycles/every 5 cycles/g' /etc/monit/conf.d/tedge-monitoring.conf
    Execute Command    cmd=sed -i 's/if status != 0 for 10 cycles/if status != 0 for 2 cycles/g' /etc/monit/conf.d/tedge-monitoring.conf
    Execute Command    systemctl restart monit
