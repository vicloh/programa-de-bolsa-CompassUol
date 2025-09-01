*** Settings ***
Library    RequestsLibrary

*** Test Cases ***
Health Check Should Be Successful
    [Documentation]    Verifica se a API está online e respondendo ao endpoint /ping.
    [Tags]    HealthCheck

    Create Session    api    https://restful-booker.herokuapp.com    verify=${False}
    ${response}=      GET On Session    api    /ping

    # Conforme a documentação, a resposta esperada para o Health Check é 201 Created.
    Status Should Be    201