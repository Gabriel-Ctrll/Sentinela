*** Settings ***
Documentation       Arquivo de recursos
Resource            ${ROOT}/resources/main.resource

Suite Setup         Inicializando O Processo Da Estrutura Base
Suite Teardown      Finalizando O Processo Da Estrutura Base

*** Tasks ***
Realizar Login
    [Documentation]    Task que  abre o browser e tenta realizar o login, se bem sucedido,
    ...    incrementa a variável Step, se falhar, encerra a execução para não bloquear acesso.
    ...    Atualiza o Banco de dados e a planilha de atenção operacional
    Abrir Navegador    ${URL}    ${DOWNLOAD_DIRECTORY}
    ${login_realizado}    Autenticar Usuario    ${USER}    ${PWD}
    IF    not ${login_realizado}
        Fail    Erro ao realizar o login
    ELSE
        Set Next Task   Acessar Home Page
    END
    [Teardown]    Teardown Realizar Login

Acessar Home Page
    [Documentation]    Esta keyword realiza o fluxo para acessar a home page e validar a navegação até a tabela de dispositivos.
    ...                - Navega até a página inicial utilizando a keyword `Navegar Home Page`.
    ...                - Verifica se a tabela de dispositivos está visível ao acessar a página de dispositivos.
    ...                - Configura a próxima tarefa como `Manipular Tabela`, caso a tabela seja acessível.
    ...                - Retorna erro e falha no fluxo caso a tabela não esteja visível.
    Navegar Home Page
    ${tabela_visivel}    Acessar Devices
    IF    ${tabela_visivel}
        Set Next Task    Manipular Tabela
    ELSE
        Fail    Erro ao realizar a navegação da tabela!
    END
    [Teardown]    Teardown Acessar Home Page

Manipular Tabela
    [Documentation]    Esta task deve ser configurada como a próxima tarefa após acessar a tabela de dispositivos.
    ...                - Contém a lógica de manipulação ou consulta dos dados na tabela, como exclusão ou captura de registros.
    ${lista_consulta}    Capturar Tabela Devices
    Validar Mac    ${lista_consulta}
    ${itens}    Get Length    ${lista_consulta}
    IF     ${itens} > 0
        Set Next Task    Excluir Macs
    ELSE
        Fail    Erro ao manipular a tabela de Mac Address
    END
    [Teardown]    Teardown Manipular Tabela

Excluir Macs
    [Documentation]    Esta keyword realiza a exclusão de endereços MAC da tabela e define os próximos passos com base no resultado.
    ...                - Chama a keyword `Deletar Mac Da Tabela` para executar a exclusão dos MACs.
    ...                - Verifica o status retornado para decidir o próximo fluxo:
    ...                  - Caso a exclusão seja bem-sucedida, define a próxima tarefa como `Finalizar Processo`.
    ...                  - Caso contrário, encerra o processo com falha.
    ...                - Inclui uma etapa de limpeza com o Teardown associado.
    ${status}    Deletar Mac Da Tabela
    IF    ${status}
        Log    Finalizando varredura...    console=True
        Set Next Task    Finalizar Processo
    ELSE
        Fail    Erro ao excluir os macs
    END
    [Teardown]    Teardown Excluir Macs
    
Finalizar Processo
    [Documentation]    Task de finalização do robô
    Log    Finalizando Processo!    level=INFO
    Fechar Navegador