from variables import config
import os
import traceback
from pathlib import Path, PurePath
from robot.api import logger


#logging.getLogger('googleapiclient.discovery_cache').setLevel(logging.ERROR)

class GsuiteConnection:
    """Classe que cria os arquivos de autenticaçao do Gsuite
    """
    def __init__(self):
        self.gsecret_path = os.path.join(config.ROOT, 'google_secret.json')
        self.gcreds_path = os.path.join(config.ROOT, 'creds')
        
        self.build_auth_files(config.GOOGLE_SECRET,
                              config.GOOGLE_CREDS,
                              self.gsecret_path,
                              self.gcreds_path)

    def build_auth_files(self, gsecret, gcreds, gsecret_path, gcreds_path):
        self.create_gsecret_json(gsecret_path, gsecret)
        creds_file = Path(PurePath(gcreds_path, "default"))
        if not creds_file.is_file():
            creds_file.parent.mkdir(parents=True, exist_ok=True)
            try:
                with open(creds_file, 'w') as default_file:
                    default_file.write(gcreds)
            except Exception:
                raise f'{traceback.format_exc()}'
    
    def create_gsecret_json(self, gsecret_json_path, gsecret):
        secret_file_path = Path(gsecret_json_path)
        if not secret_file_path.is_file():
            logger.info(f'json com id e secret da aplicação não encontrado. '
                        f'Criando no local: {gsecret_json_path}.')
            secret_file_path.parent.mkdir(parents=True, exist_ok=True)
            with open(secret_file_path, 'w') as secrets_json:
                secrets_json.write(gsecret)
            logger.info('Arquivo criado.')