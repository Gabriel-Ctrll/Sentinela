*** Settings ***
Documentation    Biblioteca responsável por toda navegação do menu lateral
Resource    ${ROOT}/resources/main.resource


*** Keywords ***
Abrir Navegador
    [Documentation]    Recebe como parâmetro a URL e o diretório de download dos arquivos (se necessário).
    ...    Abre o navegador maximizado.
    ...    Retorna em booleano o sucesso da abertura do browser.
    [Arguments]    ${URL}    ${download_dir}=${None}
    ${prefs}    Create Dictionary    download.default_directory=${download_dir}
    ...    plugins.always_open_pdf_externally=${True}
    ${options}    Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    sys
    Call Method    ${options}    add_experimental_option    prefs    ${prefs}
    Call Method    ${options}    add_argument    start-maximized
    Call Method    ${options}    add_argument    disable-web-security
    Call Method    ${options}    add_argument    disable-notifications
    Call Method    ${options}    add_argument    disable-logging
    ${options.binary_location}    Set Variable    ${BROWSER_DIRECTORY}
    ${BrowserOpened}    Run Keyword And Return Status    Open Browser    ${URL}    Chrome    options=${options}
    ...    executable_path=${CHROMEDRIVER_DIRECTORY}
    Set Selenium Timeout    ${DEFAULT_SELENIUM_TIMEOUT}
    RETURN    ${BrowserOpened}

Fechar Navegador
    [Documentation]    Fecha todos os browsers.
    Close All Browsers