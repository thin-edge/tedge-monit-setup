*** Settings ***
Resource    ./resources/common.robot
Library    Cumulocity
Library    DeviceLibrary    image=tedge-monit-setup-debian-11    bootstrap_script=bootstrap.sh

Suite Setup    Suite Setup

*** Test Cases ***

monit configuration is valid
    Execute Command    monit -t

Reconnect on cloud connection loss (by stopping mosquitto)
    Execute Command    sudo systemctl stop mosquitto
    Sleep    2s    reason=Wait for mosquitto service to be shutdown
    Execute Command    tedge connect c8y --test    timeout=600


*** Keywords ***

Suite Setup
    ${DEVICE_SN}=    DeviceLibrary.Setup
    Set Suite Variable    $DEVICE_SN
