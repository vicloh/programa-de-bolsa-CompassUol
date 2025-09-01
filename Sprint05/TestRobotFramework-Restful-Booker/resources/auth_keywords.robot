*** Settings ***
Library    RequestsLibrary
Library    Collections

*** Variables ***
${BASE_URL}      https://restful-booker.herokuapp.com
${USERNAME}      admin
${PASSWORD}      password123

*** Keywords ***
Get Authentication Token
    [Documentation]    Autentica na API e retorna o token de acesso.

    ${headers}=    Create Dictionary    Content-Type=application/json
    ${body}=       Create Dictionary    username=${USERNAME}    password=${PASSWORD}

    Create Session    api    ${BASE_URL}    verify=${False}  # Adicionado verify=False para remover os Warnings
    ${response}=      POST On Session    api    /auth    json=${body}    headers=${headers}

    Status Should Be    200
    ${token}=           Set Variable    ${response.json()}[token]
    Log To Console      Token obtido pela Keyword: ${token}

    [Return]    ${token}