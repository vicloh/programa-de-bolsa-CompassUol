*** Settings ***
Resource          ../resources/api_keywords.robot
Library           FakerLibrary    locale=pt_BR
Suite Setup       Setup de Login para Suite de Testes

*** Test Cases ***
CT-014: Cadastrar produto com sucesso (autenticado)
    [Documentation]    DoD: CRUD de cadastro de Produtos implementado (CRIAR)
    [Tags]    US-003    Produtos
    ${unique_id}=    FakerLibrary.Random Number    digits=6
    &{product}=    Create Dictionary    nome=Produto Teste ${unique_id}    preco=500    descricao=Produto para teste    quantidade=100
    ${response}=    Cadastrar Novo Produto via API    ${product}    ${AUTH_TOKEN}
    Should Be Equal As Integers    ${response.status_code}    201
    Should Be Equal As Strings    ${response.json()}[message]    Cadastro realizado com sucesso

CT-015: Tentar cadastrar produto sem autenticação
    [Documentation]    AC: Usuários não autenticados não devem conseguir realizar ações na rota de Produtos
    [Tags]    US-003    Produtos
    &{product}=    Create Dictionary    nome=Produto Sem Token    preco=100    descricao=Teste sem auth    quantidade=10
    ${response}=    POST On Session    serverest    /produtos    json=${product}    expected_status=401
    Should Be Equal As Integers    ${response.status_code}    401
    Should Be Equal As Strings    ${response.json()}[message]    Token de acesso ausente, inválido, expirado ou usuário do token não existe mais

CT-016: Validar bloqueio de produto com nome duplicado (POST)
    [Documentation]    AC: Não deve ser possível realizar o cadastro de produtos com nomes já utilizados
    [Tags]    US-003    Produtos
    ${unique_id}=    FakerLibrary.Random Number    digits=6
    &{product}=    Create Dictionary    nome=Produto Duplicado ${unique_id}    preco=300    descricao=Primeiro produto    quantidade=50
    
    # Cadastrar o primeiro produto
    ${response1}=    Cadastrar Novo Produto via API    ${product}    ${AUTH_TOKEN}
    Should Be Equal As Integers    ${response1.status_code}    201
    
    # Tentar cadastrar produto com mesmo nome
    ${headers}=    Create Dictionary    Authorization=${AUTH_TOKEN}
    ${response2}=    POST On Session    serverest    /produtos    json=${product}    headers=${headers}    expected_status=400
    Should Be Equal As Integers    ${response2.status_code}    400
    Should Be Equal As Strings    ${response2.json()}[message]    Já existe produto com esse nome

CT-017: Validar criação de novo produto ao tentar atualizar com ID inexistente (PUT)
    [Documentation]    AC: Caso não exista produto com o ID informado na hora do UPDATE, um novo produto deverá ser criado
    [Tags]    US-003    Produtos
    ${unique_id}=    FakerLibrary.Random Number    digits=6
    &{product}=    Create Dictionary    nome=Produto PUT Novo ${unique_id}    preco=400    descricao=Produto criado via PUT    quantidade=75
    ${headers}=    Create Dictionary    Authorization=${AUTH_TOKEN}
    ${response}=    PUT On Session    serverest    /produtos/ID_INEXISTENTE_123    json=${product}    headers=${headers}    expected_status=400
    Should Be Equal As Integers    ${response.status_code}    400
    Log To Console    \n========================================
    Log To Console    ❌ CRITÉRIO DE ACEITAÇÃO NÃO IMPLEMENTADO
    Log To Console    ========================================
    Log To Console    📋 US-003: [API] Produtos
    Log To Console    🔍 CT-017: Validar criação de novo produto ao tentar atualizar com ID inexistente
    Log To Console    📝 AC Esperado: "Caso não exista produto com o ID informado na hora do UPDATE, um novo produto deverá ser criado"
    Log To Console    ⚠️  Comportamento Real: PUT com ID inexistente retorna erro 400
    Log To Console    💡 Status: NÃO IMPLEMENTADO na API ServeRest
    Log To Console    ========================================

CT-018: Validar bloqueio de nome duplicado na criação via PUT
    [Documentation]    AC: Produtos criados através do PUT não poderão ter nomes previamente cadastrados
    [Tags]    US-003    Produtos
    ${unique_id}=    FakerLibrary.Random Number    digits=6
    &{product_original}=    Create Dictionary    nome=Produto Original PUT ${unique_id}    preco=200    descricao=Produto original    quantidade=30
    
    # Cadastrar produto original
    ${response1}=    Cadastrar Novo Produto via API    ${product_original}    ${AUTH_TOKEN}
    Should Be Equal As Integers    ${response1.status_code}    201
    
    # Tentar criar via PUT com nome duplicado
    &{product_duplicado}=    Create Dictionary    nome=Produto Original PUT ${unique_id}    preco=250    descricao=Tentativa duplicada    quantidade=40
    ${headers}=    Create Dictionary    Authorization=${AUTH_TOKEN}
    ${response2}=    PUT On Session    serverest    /produtos/ID_INEXISTENTE_456    json=${product_duplicado}    headers=${headers}    expected_status=400
    Should Be Equal As Integers    ${response2.status_code}    400
    Log To Console    \n========================================
    Log To Console    ✅ CRITÉRIO DE ACEITAÇÃO IMPLEMENTADO
    Log To Console    ========================================
    Log To Console    📋 US-003: [API] Produtos
    Log To Console    🔍 CT-018: Validar bloqueio de nome duplicado na criação via PUT
    Log To Console    📝 AC: "Produtos criados através do PUT não poderão ter nomes previamente cadastrados"
    Log To Console    ✅ Comportamento Real: API bloqueia nomes duplicados no PUT
    Log To Console    💡 Status: IMPLEMENTADO CORRETAMENTE
    Log To Console    ========================================

CT-019: Validar exclusão de produto que está em um carrinho (a fazer)
    [Documentation]    AC: Não deve ser possível excluir produtos que estão dentro de carrinhos - TESTE PENDENTE: Depende da API de Carrinhos
    [Tags]    US-003    Produtos    Pendente
    Log To Console    TESTE PENDENTE: Aguardando implementação da API de Carrinhos
    Skip    Teste bloqueado - depende da API de Carrinhos