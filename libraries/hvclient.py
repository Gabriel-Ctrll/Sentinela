import os
import hvac
from hvac.exceptions import InvalidPath
from requests.exceptions import ConnectionError
import traceback

class Hvclient:
    """ Classe para conectar o Vault e obter os dados
    para execução do robô
    """

    def __init__(self):
        self.client = self.__client()

    def get_credentials(self, secrets_path: str) -> dict:
        """Obtem as credenciais do Vault

        :param secrets_path: Especifica o caminho dos dados no Vault
        que serão utilizados
        :type secrets_path: str
        :return: Retorna os dados das secrets
        :rtype: dict
        """
        return self.__get_secrets(secrets_path)

    def __client(self) -> hvac.Client:
        """Obtem o cliente conectado no Vault

        :return: Retorna o cliente conectado no Vault
        :rtype: hvac.Client
        """
        try:
            client = hvac.Client(
                token=os.environ.get('HCV_TOKEN')
            )
            assert client.is_authenticated(), Exception(
                'Verifique o token configurado na variável de ambiente'
            )
            return client
        except ConnectionError:
            msg = 'Verifique se o Vault está em execução e se as variáveis de ' \
                  'ambiente, descritas na documentação dessa ' \
                  'Lib, estão configuradas.'
            raise Exception(f'{traceback.format_exc()}\n\n{msg}')

    def __get_secrets(self, path: str) -> dict:
        """Obtem as secrets do Vault

        :param path: Específica o caminho do token
        :type path: str
        :raises InvalidPath: Lança uma exceção caso o Path for inválido
        :raises KeyError: Lança uma exceção caso a chave esteja incorreta
        :return: Retorna o Json com as informações do Vault
        :rtype: dict
        """
        try:
            hv_response = self.client.secrets.kv.read_secret_version(path=path)
            return hv_response['data']['data']
        except InvalidPath:
            raise InvalidPath(f'{traceback.format_exc()}')
        except KeyError:
            raise KeyError(f'{traceback.format_exc()}')