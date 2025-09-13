*** Settings ***
Library    RequestsLibrary
Library    Collections
Library    FakerLibrary    locale=pt_BR  
Variables  ../variables/common_variables.py

*** Keywords ***
Iniciar Sessão da API
    Create Session    serverest    ${BASE_URL}

Cadastrar Novo Usuário via API
    [Arguments]    ${user_data}
    ${response}=    POST On Session    serverest    /usuarios    json=${user_data}
    RETURN    ${response}  

Realizar Login e Armazenar Token
    [Arguments]    ${credentials}
    ${response}=    POST On Session    serverest    /login    json=${credentials}
    Should Be Equal As Integers    ${response.status_code}    200
    ${token}=    Get From Dictionary    ${response.json()}    authorization
    Set Suite Variable    ${AUTH_TOKEN}    ${token}

Cadastrar Novo Produto via API
    [Arguments]    ${product_data}    ${token}
    ${headers}=    Create Dictionary    Authorization=${token}
    ${response}=    POST On Session    serverest    /produtos    json=${product_data}    headers=${headers}
    RETURN    ${response} 

Deletar Usuário Por ID via API
    [Arguments]    ${user_id}
    ${response}=    DELETE On Session    serverest    /usuarios/${user_id}
    RETURN    ${response}  

Setup de Login para Suite de Testes
    Iniciar Sessão da API
    # Criamos um usuário admin para garantir o acesso
    ${random_name}=       FakerLibrary.Name
    ${random_email}=      FakerLibrary.Email
    ${random_password}=   FakerLibrary.Password
    &{user}=    Create Dictionary    nome=${random_name}    email=${random_email}    password=${random_password}    administrador=true
    ${response}=    Cadastrar Novo Usuário via API    ${user}
    Should Be Equal As Integers    ${response.status_code}    201

    # Fazemos login com este usuário
    ${credentials}=    Create Dictionary    email=${user}[email]    password=${user}[password]
    Realizar Login e Armazenar Token    ${credentials}

