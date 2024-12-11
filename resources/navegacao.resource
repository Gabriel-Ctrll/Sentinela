*** Settings ***
Documentation    Locators comuns presentes no SAGE


*** Variables ***
# Resouce utilizado para guardar locators utilizados em todas as partes da aplicação #
&{LOGIN}    usuario= id:txt_Username
...         senha= id:txt_Password
...         entrar_btn= xpath:(//input[contains(@type,'button')])[3]
...         toast= id:ctl00_Head1
...         span_acesso= id:textoMensagem

&{FRAMES}    frame_menu= id:menuIframe
...          frame_pagesrc= xpath://iframe[contains(@id,'ContectdevmngtPageSrc')]

&{HOME_PAGE}      bnt_home= xpath://div[@class='menuContTitle menuContTitleActive'][contains(@id,'MainPage')][contains(.,'Home Page')]

&{TABELA}    tabela_mac= xpath://table[@class='DevNameTitle'][contains(.,'Wi-Fi devices | Refresh')]
...          item_tabela= xpath:/html[1]/body[1]/table[2]/tbody[1]/tr[1]/td[3]