*** Settings ***
Documentation    Arquivo de recursos (bibliotecas)

Library    String
Library    Collections
Library    OperatingSystem
Library    DateTime
Library    RPA.Tasks    execution_limit=10000
Library    RPA.Archive
Library    SeleniumLibrary    run_on_failure=NOTHING
Library    RequestsLibrary
Library    DebugLibrary

#### Custom libraries ####
Library    ${ROOT}/libraries/hvclient.py

#### Keywords ####
Resource    ${ROOT}/modules/browser.robot
Resource    ${ROOT}/modules/setup_teardown.robot
Resource    ${ROOT}/modules/utils.robot
Resource    ${ROOT}/modules/navegacao.robot

#### Locators ####
Resource    ${ROOT}/resources/navegacao.resource

#### Constantes ####
Variables    ${ROOT}/variables/config.py