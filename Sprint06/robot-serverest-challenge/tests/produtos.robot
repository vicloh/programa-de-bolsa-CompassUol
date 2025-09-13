*** Settings ***
Resource          ../resources/api_keywords.robot
Library           FakerLibrary    locale=pt_BR
Suite Setup       Setup de Login para Suite de Testes

*** Test Cases ***
CT-011: Cadastrar um novo produto com sucesso (autenticado)
    [Tags]    US-003    Produtos
    # Gerar nome único para evitar conflitos
    ${unique_id}=    FakerLibrary.Random Number    digits=6
    &{product}=    Create Dictionary    nome=Mouse Gamer ${unique_id}    preco=500    descricao=Mouse para jogos    quantidade=100
    
    # Debug: verificar se o token existe
    Log To Console    Token: ${AUTH_TOKEN}
    
    ${response}=    Cadastrar Novo Produto via API    ${product}    ${AUTH_TOKEN}
    Should Be Equal As Integers    ${response.status_code}    201
    Should Be Equal As Strings    ${response.json()}[message]    Cadastro realizado com sucesso

CT-012: Tentar cadastrar um produto sem token de autenticação
    [Tags]    US-003    Produtos
    &{product}=    Create Dictionary    nome=Produto Sem Token    preco=100    descricao=Teste    quantidade=10
    
    # Precisamos de uma keyword que não use o token, ou fazer a requisição manualmente
    # Para este exemplo, vamos fazer manualmente para não precisar do token
    ${response}=    POST On Session    serverest    /produtos    json=${product}    expected_status=401
    Should Be Equal As Integers    ${response.status_code}    401
    Should Be Equal As Strings    ${response.json()}[message]    Token de acesso ausente, inválido, expirado ou usuário do token não existe mais