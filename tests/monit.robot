*** Settings ***
Resource    ./resources/common.robot
Library    Cumulocity
Library    DeviceLibrary    bootstrap_script=bootstrap.sh

Test Setup    Test Setup

*** Test Cases ***

monit configuration is valid
    Execute Command    monit -c /etc/monit/monitrc -t

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
    Cumulocity.Device Should Have Event/s    expected_text=.*Reconnected to cloud .*c8y.*    type=c8y_reconnected
    Assert File Count    /var/log/tedge-monit-setup/*.tar.gz    1
    Assert File Count    /var/log/tedge-monit-setup/*.log    1


Use custom log path
    Decrease monit intervals
    Execute Command    cmd=echo "LOG_DIR=/opt/tedge-monit" | sudo tee /etc/tedge-monit-setup/env

    # Simulate an error by stopping mosquitto
    Execute Command    sudo systemctl stop mosquitto
    Sleep    2s    reason=Wait for mosquitto service to be shutdown
    Execute Command    tedge connect c8y --test    timeout=120
    Cumulocity.Device Should Exist    ${DEVICE_SN}
    Cumulocity.Device Should Have Event/s    expected_text=.*Reconnected to cloud .*c8y.*    type=c8y_reconnected
    Assert File Count    /opt/tedge-monit/*.tar.gz    1
    Assert File Count    /opt/tedge-monit/*.log    1


*** Keywords ***

Test Setup
    ${DEVICE_SN}=    Setup
    Set Suite Variable    $DEVICE_SN

Decrease monit intervals
    [Documentation]    Change default cycles to reduce the test execution times
    Execute Command    cmd=sed -i 's/set daemon .*/set daemon 5/g' /etc/monit/monitrc
    Execute Command    cmd=sed -i 's/every 120 cycles/every 5 cycles/g' /etc/monit/conf.d/tedge-monitoring.conf
    Execute Command    cmd=sed -i 's/if status != 0 for 10 cycles/if status != 0 for 2 cycles/g' /etc/monit/conf.d/tedge-monitoring.conf
    Execute Command    cmd=systemctl restart monit

Assert File Count
    [Arguments]    ${path}    ${count}
    DeviceLibrary.Execute Command    cmd=[ $(ls -l ${path} | wc -l | xargs) = ${count} ]
