import os
from robot.api import logger
from libraries import hvclient
from pathlib import Path, PurePath
from datetime import datetime, timedelta



AMBIENTE = os.environ.get('AMBIENTE', 'HML')
AREA_NAME = 'sentinela'
DATA_EXECUCAO = datetime.now().strftime('%d-%m-%Y %H:%M:%S.%f')


ROOT = Path(os.path.dirname(os.path.abspath(__file__))).parent

############  CHROME  ###############################
CHROME_VERSION = 102
BROWSER_DIRECTORY = os.environ.get('CHROME').format(CHROME_VERSION)
CHROMEDRIVER_DIRECTORY = os.environ.get('CHROMEDRIVER').format(CHROME_VERSION)

############  CHECKA A EXISTÊNCIA DO CHROMEDRIVER  ####################
if not Path(CHROMEDRIVER_DIRECTORY).is_file():
    logger.error(f'O chromedriver.exe para a versão especificada no '
                 f'projeto não está no local {CHROMEDRIVER_DIRECTORY}')
    raise Exception(f'O chromedriver.exe não está no local: {CHROMEDRIVER_DIRECTORY}')

############  CHECKA A EXISTÊNCIA DO GOOGLE PORTABLE  ####################
if not Path(BROWSER_DIRECTORY).is_file():
    logger.error(f'O Browser para a versão especificada no '
                 f'projeto não está no local {BROWSER_DIRECTORY}')
    raise Exception(f'O Browser especificado não está no local: {BROWSER_DIRECTORY}')

############  TIMEOUT  ####################
DEFAULT_SELENIUM_TIMEOUT = '40 seconds'
DEFAULT_DOWNLOAD_TIMEOUT = '60 seconds'
DEFAULT_KEYWORD_TIMEOUT  = '60 seconds'

############  DIRETÓRIOS LOCAIS   ###################
DOWNLOAD_DIRECTORY = os.path.join(ROOT, "downloads")

############  INSTANCIA HVCLIENT OBJ ###################
HVCLIENT_OBJ = hvclient.Hvclient()

############  VAULT ROBÔ ###################
try:
    CREDENTIALS = HVCLIENT_OBJ.get_credentials(AREA_NAME)
except Exception as e:
    logger.error(f'Não foi possível obter as credenciais do [{AREA_NAME}] no VAULT! \n DETALHES DO ERRO: {e}\n')
    raise

URL = CREDENTIALS.get('HML_URL')
USER = CREDENTIALS.get('HML_USER')
PWD = CREDENTIALS.get('HML_PWD')
LISTA = CREDENTIALS.get('LISTA')
