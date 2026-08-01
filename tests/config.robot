*** Settings ***
Resource    ./resources/common.robot
Library    Cumulocity
Library    DeviceLibrary    bootstrap_script=bootstrap.sh

Test Setup    Test Setup

*** Test Cases ***

Config Types Should Be Registered
    Cumulocity.Should Contain Supported Configuration Types    monitrc::monit    tedge.conf::monit    tedge-monitoring.conf::monit

Get Configuration
    ${operation}=    Cumulocity.Get Configuration    typename=tedge-monitoring.conf
    Operation Should Be SUCCESSFUL    ${operation}

Fail on Unexpected Configuration Type
    ${operation}=    Cumulocity.Get Configuration    typename=unknown.conf
    Operation Should Be FAILED    ${operation}

Set Invalid Configuration
    ${config_url}=    Cumulocity.Create Inventory Binary
    ...    dup-port.tedge.conf
    ...    dup-port.tedge.conf
    ...    file=${CURDIR}/testfiles/dup-port.tedge.conf
    ${operation}=    Cumulocity.Set Configuration    typename=tedge.conf    url=${config_url}
    Operation Should Be FAILED    ${operation}

    # monit should still work
    Check Monit HTTP Endpoint

Change Port via Configuration
    ${config_url}=    Cumulocity.Create Inventory Binary
    ...    other-port.tedge.conf
    ...    other-port.tedge.conf
    ...    file=${CURDIR}/testfiles/other-port.tedge.conf
    ${operation}=    Cumulocity.Set Configuration    typename=tedge.conf    url=${config_url}
    Operation Should Be SUCCESSFUL    ${operation}

    # monit should still work
    Check Monit HTTP Endpoint    port=2813

*** Keywords ***

Test Setup
    ${DEVICE_SN}=    Setup
    Set Suite Variable    $DEVICE_SN

Check Monit HTTP Endpoint
    [Arguments]    ${port}=2812
    Execute Command    cmd=monit status
    Execute Command    cmd=curl http://127.0.0.1:${port} --max-time 10
