*** Settings ***
Documentation    Keywords gerais que podem ser úteis
Resource    ${ROOT}/resources/main.resource


*** Keywords ***
Enviar Requisição API
    [Documentation]    Keyword que realiza a requisição para API e retorna o response recebido.
    ...                Recebe como parâmetro:
    ...                $method = Método a ser utilizado;
    ...                $url_api = URL da API;
    ...                $body = Corpo da requisição contendo as informações;
    ...                $header = Cabeçalho da requisição;
    ...                $expected_status = Status de retorno esperado da requisição.
    ...                Envia a requisição de acordo com o método fornecido.
    ...                e retorna o response recebido da API.
    [Arguments]    ${method}    ${url_api}    ${body}    ${header}
    ...            ${expected_status}=${None}
    ${method}     Convert To Uppercase    ${method}
    ${resp}    Run Keyword    ${method}    ${url_api}    headers=${header}    json=${body}    expected_status=${expected_status}
    RETURN    ${resp}

Criar Diretorio
    [Documentation]    Keyword que recebe um path como argumento e procede com a criação desse diretório.
    ...                Retorna True se teve êxito ou False caso contrário.
    [Arguments]    ${path_diretorio}
    TRY
        Log    Criando o diretório -> ${path_diretorio}    console=True
        Create Directory    ${path_diretorio}
        RETURN    ${True}
    EXCEPT
        RETURN    ${False}
    END

Limpar Diretorio
    [Documentation]    Keyword que recebe um path como argumento e procede com a limpeza desse diretório.
    ...                Retorna True se teve êxito ou False caso contrário.
    [Arguments]    ${path_diretorio}
    TRY
        Log    Limpando o diretório -> ${path_diretorio}    console=True
        Empty Directory    ${path_diretorio}
        RETURN    ${True}
    EXCEPT
        RETURN    ${False}
    END

Excluir Arquivo
    [Documentation]    Keyword que recebe um path como argumento e procede com a limpeza desse diretório.
    ...                Retorna True se teve êxito ou False caso contrário.
    [Arguments]    ${path_arquivo}
    TRY
        Log    Excluindo o arquivo -> ${path_arquivo}    console=True
        Remove File    ${path_arquivo}
        RETURN    ${True}
    EXCEPT
        RETURN    ${False}
    END

Aguardar Criacao Do Arquivo
    [Documentation]    Keyword que recebe um path de um arquivo como argumento e aguarda a criação desse arquivo.
    ...                Retorna True se teve êxito (arquivo criado) ou False caso o timeout tenha sido excedido.
    [Arguments]    ${path_arquivo}    ${timeout}=${DEFAULT_DOWNLOAD_TIMEOUT}
    TRY
        Log    Aguardando ${timeout} até o arquivo ser criado -> ${path_arquivo}    console=True
        Wait Until Created    ${path_arquivo}    ${timeout}
        RETURN    ${True}
    EXCEPT
        RETURN    ${False}
    END

Listar Arquivos De Um Diretorio
    [Documentation]    Keyword que recebe um path como argumento e o tipo de arquivo (opcional) e
    ...                procede com a listagem dos arquivos desse diretório.
    ...                Retorna a lista dos paths dos arquivos do diretório se teve êxito ou uma lista vazia caso contrário.
    [Arguments]    ${pasta}    ${tipo_arquivo}=${EMPTY}
    TRY
        IF    "${tipo_arquivo}" == "${EMPTY}"
            Log    Listando arquivos do diretório -> ${pasta}    console=True
            ${arquivos}    List Files In Directory    ${pasta}    *    absolute
        ELSE
            Log    Listando arquivos ${tipo_arquivo} do diretório -> ${pasta}    console=True
            ${arquivos}    List Files In Directory    ${pasta}    *.${tipo_arquivo}    absolute
        END
    EXCEPT
        @{arquivos}    Create List
    END
    RETURN    ${arquivos}

Obter Informações do Arquivo Zip
    [Documentation]    Keyword que recebe um path de um arquivo como argumento e retorna um dicionário com os atributos do arquivo
    ...                Retorna um dict com as informações caso tenha êxito ou retorna um dict vazio caso contrário.
    [Arguments]    ${path_arquivo_zip}
    TRY
        Log    Obtendo informações do arquivo zip -> ${path_arquivo_zip}    console=True
        ${dict_info}    Get Archive Info    ${path_arquivo_zip}
    EXCEPT
        &{dict_info}    Create Dictionary
    END
    RETURN    ${dict_info}

Listar O Conteudo Do Arquivo Zip
    [Documentation]    Keyword que recebe um path de um arquivo como argumento e retorna uma lista de dicionários contendo informações
    ...                dos arquivos dentro do zip. Retorna uma lista com dicts dos arquivos se teve êxito ou uma lista vazia caso contrário.
    [Arguments]    ${path_arquivo_zip}
    TRY
        Log    Listando o conteúdo do arquivo zip -> ${path_arquivo_zip}    console=True
        ${arquivos}    List Archive    ${path_arquivo_zip}
    EXCEPT
        @{arquivos}    Create List
    END
    RETURN    ${arquivos}

Descompactar O Arquivo Zip
    [Documentation]    Keyword que recebe um path de um arquivo como argumento e procede com a descompactação desse arquivo.
    ...                Retorna True se teve êxito ou False caso contrário.
    [Arguments]    ${path_arquivo_zip}    ${path_diretorio_destino}
    TRY
        Log    Descompactando o arquivo -> ${path_arquivo_zip}    console=True
        Extract Archive    ${path_arquivo_zip}    ${DOWNLOAD_DIRECTORY}
        RETURN    ${True}
    EXCEPT
        RETURN    ${False}
    END

Mover Arquivos
    [Documentation]    Keyword que recebe uma lista de paths de arquivos e move estes arquivos para um diretório de destino.
    ...                Retorna True se teve êxito ou False caso contrário.
    [Arguments]    ${lista_de_arquivos}    ${path_diretorio_destino}
    TRY
        FOR    ${arquivo}    IN    @{lista_de_arquivos}
            Log    Movendo o arquivo ${arquivo} -> ${path_diretorio_destino}    console=True
            Move File    ${arquivo}    ${path_diretorio_destino}
        END
        RETURN    ${True}
    EXCEPT
        RETURN    ${False}
    END

Criar Lista Com Nome Variavel Dinamica
    [Documentation]    Keyword que recebe um nome como variavel e cria uma lista (global) com esse nome.
    [Arguments]    ${nome_variavel}
    TRY
        @{lista}    Create List
        Set Global Variable    @{${nome_variavel}}    @{lista}
        RETURN    ${True}
    EXCEPT
        RETURN    ${False}
    END
