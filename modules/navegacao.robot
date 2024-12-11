*** Settings ***
Documentation    Keywords de setup e teardown
Resource    ${ROOT}/resources/main.resource


*** Keywords ***
Autenticar Usuario
    [Documentation]    Responsavel por autenticar o usuario na plataforma anhanguera
    [Arguments]    ${USER}    ${PWD}    ${timeout}=60
    Wait Until Element Is Visible    ${LOGIN.usuario}    timeout=${timeout}
    Input Text    ${LOGIN.usuario}    ${USER}
    Input Password    ${LOGIN.senha}    ${PWD}
    Click Button    ${LOGIN.entrar_btn}
    ${error_autenticacao}    Run Keyword And Return Status    Element Should Not Be Visible    ${HOME_PAGE.bnt_home}  timeout=5
    ${error_login}    Run Keyword And Return Status    Wait Until Page Contains Element    ${HOME_PAGE.bnt_home}   timeout=5
    [Return]    ${error_login}    ${error_autenticacao}

Navegar Home Page
    [Documentation]    Esta keyword navega até a Home Page da aplicação.
    ...                - Aguarda até que o botão da Home Page esteja visível.
    ...                - Realiza o clique no botão da Home Page para garantir que ela seja acessada.
    ...                - Loga uma mensagem indicando que a página foi acessada com sucesso.
    Wait Until Element Is Visible    ${HOME_PAGE.bnt_home}
    Click Element    ${HOME_PAGE.bnt_home}
    Log    Home page acessada com sucesso     console=True

Acessar Devices
    [Documentation]    Esta keyword acessa a página de dispositivos (Devices) na aplicação.
    ...                - Seleciona o frame correto no menu.
    ...                - Aguarda até que o ícone de dispositivos esteja visível.
    ...                - Tenta clicar no ícone de dispositivos e verifica se a ação foi bem-sucedida.
    ...                - Caso o clique seja bem-sucedido, loga uma mensagem de sucesso no console.
    ...                - Retorna o status da operação (True/False).
    Selecionar Frame Menu
    Wait Until Element Is Visible   xpath://div[contains(@id,'wifidevIcon')]
    ${status}    Run keyword And Return Status    Click Element   xpath://div[contains(@id,'wifidevIcon')]
    IF    ${status}
        Log    Devices acessado com sucesso     console=True
    END
    RETURN    ${status}

Capturar Tabela Devices
    [Documentation]    Esta keyword captura informações de uma tabela de dispositivos (Devices) visíveis na página.
    ...                - Realiza as etapas necessárias para selecionar os frames corretos e acessar a tabela.
    ...                - Itera pelas linhas da tabela para verificar dispositivos visíveis.
    ...                - Captura os endereços MAC e seus identificadores de ação, armazenando-os em uma lista e em um dicionário.
    ...                - Finaliza a captura após encontrar 3 elementos não visíveis consecutivos ou completar a iteração.
    Unselect Frame
    Selecionar Frame Menu
    Selecionar Frame Page
    Wait Until Element Is Visible   ${TABELA.tabela_mac}
    Wait Until Element Is Visible   ${TABELA.item_tabela}
    ${break}    Set Variable    0
    @{lista_consulta}   Create List
    &{lista_id}    Create Dictionary
    Set Global Variable    &{LISTA_ID}
    FOR    ${row}    IN RANGE    2    16
        IF    ${break} <= 3
            ${xpath}     Set Variable    xpath:/html[1]/body[1]/table[2]/tbody[1]/tr[${row}]/td[3]
            ${xpath_id}    Set Variable    xpath:/html[1]/body[1]/table[2]/tbody[1]/tr[${row}]/td[6]/button[2]
            ${visivel}    Run Keyword And Return Status    Wait Until Element Is Visible    ${xpath}    timeout=2
            IF    ${visivel}
                Log    Esta visivel para consulta    console=True
                ${mac}    Get Text    ${xpath}
                Set To Dictionary    ${LISTA_ID}    ${mac}   ${xpath_id}
                Append To List    ${lista_consulta}    ${mac}
            ELSE
                Log    Não esta visivel na tabela    console=True
                ${Break}    Evaluate    ${Break} + 1
            END
        ELSE
            Log    Finalizando captura dos Macs...    console=True
            BREAK
        END
    END
    RETURN    @{lista_consulta}

Validar Mac
    [Documentation]    Esta keyword valida uma lista de endereços MAC consultados.
    ...                - Remove barras ou caracteres indesejados da lista de endereços MAC.
    ...                - Verifica se cada endereço MAC está na lista de permissões (`LISTA`).
    ...                - Remove da lista global (`LISTA_ID`) e da lista de consulta os MACs permitidos.
    ...                - Loga mensagens indicando quais MACs foram permitidos ou bloqueados.
    [Arguments]    ${lista_consulta}
    ${lista_consulta}    Remover Barras Lista    @{lista_consulta}
    FOR    ${element}    IN    @{lista_consulta}
        ${mac_permitido}    Run Keyword And Return Status    Should Contain    ${LISTA}    ${element}
        IF    '${mac_permitido}' == 'False'
            Log    MAC não permitido: ${element}
        ELSE
            Remove From Dictionary    ${LISTA_ID}    ${element}
            Remove Values From List    ${lista_consulta}    ${element}
            Log    MAC permitido: ${element}    console=True
        END
    END
    RETURN    ${lista_consulta}

Remover Barras Lista
    [Documentation]    Esta keyword remove barras ou caracteres indesejados (como quebras de linha) de cada item em uma lista fornecida.
    ...                - Recebe uma lista de strings como argumento.
    ...                - Substitui o caractere de quebra de linha (`\n`) por uma string vazia em cada item.
    ...                - Retorna uma nova lista com os itens corrigidos.
    [Arguments]    @{lista_consulta}
    ${lista_corrigida}   Create List
    FOR    ${item}    IN    @{lista_consulta}
        Log    ${item}
        ${item_corrigido}    Replace String    ${item}    \n    ${EMPTY}
        Append To List    ${lista_corrigida}    ${item_corrigido}
    END
    RETURN    ${lista_corrigida}

Deletar Mac Da Tabela
    [Documentation]    Esta keyword remove os dispositivos listados no dicionário global `LISTA_ID` da tabela na interface.
    ...                - Itera sobre todas as chaves (MACs) e valores (elementos de ação) do dicionário `LISTA_ID`.
    ...                - Garante que o botão associado ao MAC esteja visível antes de clicar.
    ...                - Trata alertas que aparecem após a ação de exclusão.
    FOR    ${chave}    ${valor}    IN    &{LISTA_ID}
        Log    Chave: ${chave}, Valor: ${valor}
        Wait Until Element Is Visible     ${valor}
        Click Element     ${valor}
        Handle Alert
    END
    RETURN    ${True}


Selecionar Frame Menu
    [Documentation]    Esta keyword seleciona o frame do menu da página.
    ...                - Aguarda até que o frame do menu esteja visível.
    ...                - Seleciona o frame correspondente utilizando o seletor `FRAMES.frame_menu`.

    Wait Until Element Is Visible   ${FRAMES.frame_menu}
    Select Frame    ${FRAMES.frame_menu}

Selecionar Frame Page
    [Documentation]    Esta keyword seleciona o frame da página principal.
    ...                - Aguarda até que o frame da página principal esteja visível.
    ...                - Seleciona o frame correspondente utilizando o seletor `FRAMES.frame_pagesrc`.
    Wait Until Element Is Visible   ${FRAMES.frame_pagesrc}
    Select Frame    ${FRAMES.frame_pagesrc}