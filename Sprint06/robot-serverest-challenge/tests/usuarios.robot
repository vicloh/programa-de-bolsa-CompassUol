*** Settings ***
Resource          ../resources/api_keywords.robot
Library           FakerLibrary    locale=pt_BR  
Suite Setup       Iniciar Sessão da API

*** Test Cases ***
CT-001: Cadastrar um novo usuário com dados válidos
    [Tags]    US-001    Usuarios
    ${email}=   FakerLibrary.Email
    &{user}=    Create Dictionary    nome=Robot Framework User    email=${email}    password=teste    administrador=true
    ${response}=    Cadastrar Novo Usuário via API    ${user}
    Should Be Equal As Integers    ${response.status_code}    201
    Dictionary Should Contain Key    ${response.json()}    _id

CT-002: Tentar cadastrar um usuário com um e-mail já existente
    [Tags]    US-001    Usuarios
    # Primeiro, criamos um usuário para garantir que o e-mail exista
    ${email}=   FakerLibrary.Email
    &{user}=    Create Dictionary    nome=Teste Duplicado    email=${email}    password=teste    administrador=true
    ${response1}=    Cadastrar Novo Usuário via API    ${user}
    Should Be Equal As Integers    ${response1.status_code}    201

    # Agora, tentamos cadastrar de novo com o mesmo e-mail
    ${response2}=    POST On Session    serverest    /usuarios    json=${user}    expected_status=400
    Should Be Equal As Integers    ${response2.status_code}    400
    Should Be Equal As Strings    ${response2.json()}[message]    Este email já está sendo usado

CT-003: Listar todos os usuários cadastrados
    [Tags]    US-001    Usuarios
    ${response}=    GET On Session    serverest    /usuarios
    Should Be Equal As Integers    ${response.status_code}    200
    Dictionary Should Contain Key    ${response.json()}    usuarios
    ${users_list}=    Get From Dictionary    ${response.json()}    usuarios
    Log To Console    Total de usuários encontrados: ${response.json()}[quantidade]
    Log To Console    Lista de usuários: ${users_list}

CT-007: Deletar um usuário existente com sucesso
    [Tags]    US-001    Usuarios
    # Criamos um usuário para poder deletá-lo
    ${email}=   FakerLibrary.Email
    &{user}=    Create Dictionary    nome=Usuario a Deletar    email=${email}    password=teste    administrador=true
    ${response_create}=    Cadastrar Novo Usuário via API    ${user}
    Should Be Equal As Integers    ${response_create.status_code}    201
    ${user_id}=    Get From Dictionary    ${response_create.json()}    _id

    # Deletamos o usuário recém-criado
    ${response_delete}=    Deletar Usuário Por ID via API    ${user_id}
    Should Be Equal As Integers    ${response_delete.status_code}    200
    Should Be Equal As Strings    ${response_delete.json()}[message]    Registro excluído com sucesso

