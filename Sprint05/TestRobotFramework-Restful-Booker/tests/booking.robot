*** Settings ***
Library           RequestsLibrary
Library           Collections
Resource          ../resources/auth_keywords.robot

*** Variables ***
&{BOOKING_DATA}=    firstname=Jim    lastname=Brown    totalprice=111
...                 depositpaid=true
&{BOOKING_DATES}=   checkin=2024-01-01    checkout=2025-01-01
&{UPDATED_DATA}=    firstname=James    lastname=Green

*** Test Cases ***
Get All Booking Ids
    [Tags]    Booking    GET
    Create Session    api    https://restful-booker.herokuapp.com    verify=${False}
    ${response}=      GET On Session    api    /booking
    Status Should Be    200
    Should Not Be Empty    ${response.json()}

Get Specific Booking Details
    [Documentation]    Testa o endpoint GET /booking/{id} para buscar detalhes de uma reserva.
    [Tags]    Booking    GET    Specific
    # --- Setup: Criar uma nova reserva para termos um ID válido ---
    ${headers}=         Create Dictionary    Content-Type=application/json    Accept=application/json
    ${body}=            Create Dictionary    &{BOOKING_DATA}    bookingdates=&{BOOKING_DATES}
    Create Session      api    https://restful-booker.herokuapp.com    verify=${False}
    ${response_post}=   POST On Session    api    /booking    json=${body}    headers=${headers}
    Status Should Be    200
    ${booking_id}=      Set Variable    ${response_post.json()}[bookingid]

    # --- Teste: Fazer a requisição GET para o ID específico ---
    ${response_get}=    GET On Session    api    /booking/${booking_id}
    Status Should Be    200

    # --- Verificação: Conferir se os dados retornados são os mesmos que foram criados ---
    ${retorned_data}=    Set Variable    ${response_get.json()}
    Should Be Equal As Strings    ${retorned_data}[firstname]      ${BOOKING_DATA}[firstname]
    Should Be Equal As Strings    ${retorned_data}[lastname]       ${BOOKING_DATA}[lastname]
    Should Be Equal As Numbers    ${retorned_data}[totalprice]    ${BOOKING_DATA}[totalprice]

Partially Update Booking Details
    [Documentation]    Testa o endpoint PATCH /booking/{id} para atualização parcial.
    [Tags]    Booking    PATCH
    # --- Setup: Criar uma nova reserva e obter o token de autenticação ---
    ${booking_id}=      Create a New Booking
    ${token}=           Get Authentication Token

    # --- Teste: Preparar e enviar a requisição PATCH ---
    ${patch_headers}=   Create Dictionary    Content-Type=application/json    Accept=application/json    Cookie=token=${token}
    ${patch_body}=      Create Dictionary    firstname=Joao    lastname=Silva
    ${response_patch}=  PATCH On Session    api    /booking/${booking_id}    json=${patch_body}    headers=${patch_headers}
    Status Should Be    200

    # --- Verificação: Conferir se os dados foram parcialmente atualizados ---
    ${updated_data}=    Set Variable    ${response_patch.json()}
    Should Be Equal As Strings    ${updated_data}[firstname]      Joao
    Should Be Equal As Strings    ${updated_data}[lastname]       Silva
    # Verificar se os dados originais que não foram alterados permanecem os mesmos
    Should Be Equal As Numbers    ${updated_data}[totalprice]    ${BOOKING_DATA}[totalprice]
    Should Be True                ${updated_data}[depositpaid]

Create, Update And Delete Booking
    [Documentation]    Testa o fluxo completo de CRUD com POST, PUT e DELETE.
    [Tags]    Booking    CRUD
    # --- Parte 1: Criar a reserva (POST) ---
    ${booking_id}=      Create a New Booking
    Log To Console      \nBooking ID criado para o teste CRUD: ${booking_id}

    # --- Parte 2: Obter o Token de Autenticação ---
    ${token}=           Get Authentication Token

    # --- Parte 3: Atualizar a reserva (PUT) ---
    ${put_headers}=     Create Dictionary    Content-Type=application/json    Accept=application/json    Cookie=token=${token}
    ${update_body}=     Create Dictionary    &{BOOKING_DATA}    bookingdates=&{BOOKING_DATES}    &{UPDATED_DATA}
    ${response_put}=    PUT On Session    api    /booking/${booking_id}    json=${update_body}    headers=${put_headers}
    Status Should Be    200
    Should Be Equal As Strings    ${response_put.json()}[firstname]    James

    # --- Parte 4: Deletar a reserva (DELETE) ---
    ${del_headers}=     Create Dictionary    Content-Type=application/json    Cookie=token=${token}
    ${response_del}=    DELETE On Session    api    /booking/${booking_id}    headers=${del_headers}
    Status Should Be    201

*** Keywords ***
Create a New Booking
    [Documentation]    Keyword para criar uma nova reserva e retornar o ID.
    ${headers}=         Create Dictionary    Content-Type=application/json    Accept=application/json
    ${body}=            Create Dictionary    &{BOOKING_DATA}    bookingdates=&{BOOKING_DATES}
    Create Session      api    https://restful-booker.herokuapp.com    verify=${False}
    ${response_post}=   POST On Session    api    /booking    json=${body}    headers=${headers}
    Status Should Be    200
    ${booking_id}=      Set Variable    ${response_post.json()}[bookingid]
    RETURN    ${booking_id}