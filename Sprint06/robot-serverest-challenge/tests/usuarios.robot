*** Settings ***
Resource          ../resources/api_keywords.robot
Library           FakerLibrary    locale=pt_BR  
Suite Setup       Iniciar Sessão da API

*** Test Cases ***
CT-001: Cadastrar usuário com sucesso
    [Documentation]    AC: Os vendedores (usuários) deverão possuir os campos NOME, E-MAIL, PASSWORD e ADMINISTRADOR
    [Tags]    US-001    Usuarios
    ${email}=    FakerLibrary.Email
    &{user}=    Create Dictionary    nome=Robot Framework User    email=${email}    password=teste123    administrador=true
    ${response}=    Cadastrar Novo Usuário via API    ${user}
    Should Be Equal As Integers    ${response.status_code}    201
    Should Be Equal As Strings    ${response.json()}[message]    Cadastro realizado com sucesso

CT-002: Validar bloqueio de e-mail duplicado no cadastro (POST)
    [Documentation]    AC: Não deve ser possível criar um usuário com e-mail já utilizado
    [Tags]    US-001    Usuarios
    ${email}=    FakerLibrary.Email
    &{user}=    Create Dictionary    nome=Usuario Original    email=${email}    password=teste123    administrador=true
    ${response1}=    Cadastrar Novo Usuário via API    ${user}
    Should Be Equal As Integers    ${response1.status_code}    201
    
    ${response2}=    POST On Session    serverest    /usuarios    json=${user}    expected_status=400
    Should Be Equal As Integers    ${response2.status_code}    400
    Should Be Equal As Strings    ${response2.json()}[message]    Este email já está sendo usado

CT-003: Validar bloqueio de provedores de e-mail não permitidos
    [Documentation]    AC: Não deverá ser possível cadastrar usuários com e-mails de provedor gmail e hotmail
    [Tags]    US-001    Usuarios
    &{user_gmail}=    Create Dictionary    nome=Usuario Gmail    email=teste@gmail.com    password=teste123    administrador=true
    ${response1}=    POST On Session    serverest    /usuarios    json=${user_gmail}    expected_status=400
    Should Be Equal As Integers    ${response1.status_code}    400
    
    &{user_hotmail}=    Create Dictionary    nome=Usuario Hotmail    email=teste@hotmail.com    password=teste123    administrador=true
    ${response2}=    POST On Session    serverest    /usuarios    json=${user_hotmail}    expected_status=400
    Should Be Equal As Integers    ${response2.status_code}    400

CT-004: Validar criação de novo usuário ao tentar atualizar com ID inexistente (PUT)
    [Documentation]    AC: Caso não seja encontrado usuário com o ID informado no PUT, um novo usuário deverá ser criado
    [Tags]    US-001    Usuarios
    ${email}=    FakerLibrary.Email
    &{user}=    Create Dictionary    nome=Usuario Novo PUT    email=${email}    password=teste123    administrador=true
    ${response}=    Atualizar Usuário Por ID via API    ID_INEXISTENTE_123    ${user}
    Should Be Equal As Integers    ${response.status_code}    201
    Should Be Equal As Strings    ${response.json()}[message]    Cadastro realizado com sucesso

CT-005: Validar bloqueio de e-mail duplicado na atualização (PUT)
    [Documentation]    AC: Não deve ser possível cadastrar usuário com e-mail já utilizado utilizando PUT
    [Tags]    US-001    Usuarios
    ${email1}=    FakerLibrary.Email
    ${email2}=    FakerLibrary.Email
    &{user_a}=    Create Dictionary    nome=Usuario A    email=${email1}    password=teste123    administrador=true
    &{user_b}=    Create Dictionary    nome=Usuario B    email=${email2}    password=teste123    administrador=true
    
    ${response_a}=    Cadastrar Novo Usuário via API    ${user_a}
    ${response_b}=    Cadastrar Novo Usuário via API    ${user_b}
    ${user_a_id}=    Get From Dictionary    ${response_a.json()}    _id
    
    Set To Dictionary    ${user_a}    email=${email2}
    ${response}=    PUT On Session    serverest    /usuarios/${user_a_id}    json=${user_a}    expected_status=400
    Should Be Equal As Integers    ${response.status_code}    400

CT-006: Validar regra de senha (mínimo de 5 caracteres)
    [Documentation]    AC: As senhas devem possuír no mínimo 5 caracteres e no máximo 10 caracteres
    [Tags]    US-001    Usuarios
    ${email}=    FakerLibrary.Email
    &{user}=    Create Dictionary    nome=Usuario Senha Curta    email=${email}    password=1234    administrador=true
    ${response}=    POST On Session    serverest    /usuarios    json=${user}    expected_status=400
    Should Be Equal As Integers    ${response.status_code}    400

CT-007: Validar regra de senha (máximo de 10 caracteres)
    [Documentation]    AC: As senhas devem possuír no mínimo 5 caracteres e no máximo 10 caracteres
    [Tags]    US-001    Usuarios
    ${email}=    FakerLibrary.Email
    &{user}=    Create Dictionary    nome=Usuario Senha Longa    email=${email}    password=12345678901    administrador=true
    ${response}=    POST On Session    serverest    /usuarios    json=${user}    expected_status=400
    Should Be Equal As Integers    ${response.status_code}    400

CT-008: Validar ações em usuários inexistentes
    [Documentation]    AC: Não deverá ser possível fazer ações e chamadas para usuários inexistentes
    [Tags]    US-001    Usuarios
    ${response_get}=    GET On Session    serverest    /usuarios/ID_INEXISTENTE_123    expected_status=400
    Should Be Equal As Integers    ${response_get.status_code}    400
    Should Be Equal As Strings    ${response_get.json()}[message]    Usuário não encontrado
    
    ${response_delete}=    DELETE On Session    serverest    /usuarios/ID_INEXISTENTE_123    expected_status=400
    Should Be Equal As Integers    ${response_delete.status_code}    400
    Should Be Equal As Strings    ${response_delete.json()}[message]    Nenhum registro excluído

CT-009: Listar todos os usuários
    [Documentation]    DoD: CRUD de cadastro de vendedores (usuários) implementado (LISTAR)
    [Tags]    US-001    Usuarios
    ${response}=    GET On Session    serverest    /usuarios
    Should Be Equal As Integers    ${response.status_code}    200
    Dictionary Should Contain Key    ${response.json()}    usuarios
    Dictionary Should Contain Key    ${response.json()}    quantidade

