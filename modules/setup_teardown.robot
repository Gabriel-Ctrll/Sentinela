*** Settings ***
Documentation    Keywords de setup e teardown
Resource    ${ROOT}/resources/main.resource


*** Keywords ***
Inicializando O Processo Da Estrutura Base
    [Documentation]     Inicia as variavies globais utilizadas para metricas do Projeto.
    Log    Iniciando o processo... Modo de execução -> ${AMBIENTE}     console=True
    # Inserir Execucao Bd
    # Create Directory    ${DOWNLOAD_DIRECTORY}
    # Empty Directory    ${DOWNLOAD_DIRECTORY}
    Set Global Variable    ${RETRIES}    ${0}
    Set Global Variable    ${RETRIES_LOGIN}    ${0}
    # ${inicio_execucao}    Get Current Date    result_format=datetime    exclude_millis=False
    # Set Global Variable    ${inicio_execucao}
    # ${data_processamento}    Get Current Date    time_zone=local    result_format=%Y/%m/%d    exclude_millis=True
    # Set Global Variable    ${data_processamento}
    # Definir Novo Valor Metrica    metrica_1    ${0}
    # Definir Novo Valor Metrica    metrica_2    ${0}
    # Definir Novo Valor Metrica    metrica_3    ${0}
    # Definir Novo Valor Metrica    metrica_4    ${0}
    # Definir Novo Valor Metrica    metrica_5    ${0}
    # Definir Novo Valor Metrica    metrica_6    ${0}
    # Definir Novo Valor Metrica    metrica_7    ${0}
    # Definir Novo Valor Metrica    total    ${0}
    # Definir Novo Valor Metrica    tempo_execucao    ${0}
    # Definir Novo Valor Metrica    arquivos_baixados    ${0}
    # Definir Novo Valor Metrica    resultados_importados    ${0}
    # Definir Novo Valor Metrica    analise_manual    ${0}


# Teardown Entrar no Menu Estudar
#     [Documentation]
    

Finalizando O Processo Da Estrutura Base
    [Documentation]    Garante que encerrará os processos
    Fechar Navegador
    # Contar Tempo De Execução
    # Contar Metrica Total Execucao
    # Atualizar Relatorio Atencao Operacional Gsheets
    # Atualizar Relatorio Metricas Gsheets

Teardown Realizar Login
    [Documentation]    Keyword que roda após a task de Entrar no Menu Cadastro De Perfis
        ...                caso apresente algum problema envia para Realizar Login novamente.
        IF    '${TEST_STATUS}' == 'FAIL'
            ${task_name}    Obter Nome Da Task
            Log    Não foi possível ${task_name}.    level=ERROR
            Set Global Variable    ${RETRIES_LOGIN}    ${RETRIES_LOGIN+1}
            IF    ${RETRIES_LOGIN} <= ${3}
                Log    Tentando novamente ${task_name}. Tentativa: ${RETRIES_LOGIN} \n\n    console=True
                Jump To Task    Realizar Login
            ELSE
                ${mensagem}    Set Variable    Falha ao tentar realizar o login
                Set Next Task    Finalizar Processo
            END
        ELSE
            Set Global Variable    ${RETRIES_LOGIN}    ${0}
        END

Teardown Acessar Home Page
    [Documentation]    Keyword que roda após a task de Entrar no Menu Cadastro De Perfis
        ...                caso apresente algum problema envia para Realizar Login novamente.
        IF    '${TEST_STATUS}' == 'FAIL'
            ${task_name}    Obter Nome Da Task
            Log    Não foi possível ${task_name}.    level=ERROR
            Set Global Variable    ${RETRIES_NAVEGAR}    ${RETRIES_NAVEGAR+1}
            IF    ${RETRIES_NAVEGAR} <= ${3}
                Log    Tentando novamente ${task_name}. Tentativa: ${RETRIES_NAVEGAR} \n\n    console=True
                Jump To Task    Acessar Home Page
            ELSE
                ${mensagem}    Set Variable    Falha ao tentar navegar a tela de home page.
                Set Next Task    Finalizar Processo
            END
        ELSE
            Set Global Variable    ${RETRIES_NAVEGAR}    ${0}
        END

Teardown Manipular Tabela
    [Documentation]    Keyword que roda após a task de Entrar no Menu Cadastro De Perfis
    ...                caso apresente algum problema envia para Realizar Login novamente.
    IF    '${TEST_STATUS}' == 'FAIL'
        ${task_name}    Obter Nome Da Task
        Log    Não foi possível ${task_name}.    level=ERROR
        Set Global Variable    ${RETRIES_MANIPULAR}    ${RETRIES_MANIPULAR+1}
        IF    ${RETRIES_MANIPULAR} <= ${3}
            Log    Tentando novamente ${task_name}. Tentativa: ${RETRIES_MANIPULAR} \n\n    console=True
            Jump To Task    Manipular Tabela
        ELSE
            ${mensagem}    Set Variable    Falha ao tentar manipular a tabela de macAddress.
            Set Next Task    Finalizar Processo
        END
    ELSE
        Set Global Variable    ${RETRIES_MANIPULAR}    ${0}
    END

Teardown Excluir Macs
    [Documentation]    Keyword que roda após a task de Entrar no Menu Cadastro De Perfis
    ...                caso apresente algum problema envia para Realizar Login novamente.
    IF    '${TEST_STATUS}' == 'FAIL'
        ${task_name}    Obter Nome Da Task
        Log    Não foi possível ${task_name}.    level=ERROR
        Set Global Variable    ${RETRIES_EXCLUIR}    ${RETRIES_EXCLUIR+1}
        IF    ${RETRIES_EXCLUIR} <= ${3}
            Log    Tentando novamente ${task_name}. Tentativa: ${RETRIES_EXCLUIR} \n\n    console=True
            Jump To Task    Excluir Macs
        ELSE
            ${mensagem}    Set Variable    Falha ao tentar excluir os macAddress não cadastrados.
            Set Next Task    Finalizar Processo
        END
    ELSE
        Set Global Variable    ${RETRIES_EXCLUIR}    ${0}
    END

