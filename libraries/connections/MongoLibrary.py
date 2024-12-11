from variables import config
from mongoengine import connect, disconnect
      
class MongoLibrary:

    def __init__(self):
        self.alias_robo = config.AREA_NAME
        self.db_robo = config.AREA_NAME
        self.alias_geral = config.DB_GERAL
        self.db_geral = config.DB_GERAL
        self.username = config.MONGO_USER
        self.password = config.MONGO_PWD
        self.host = config.MONGO_URI

    def open_connections(self):
        connect(
            alias = self.alias_robo,
            db = self.db_robo,
            username = self.username,
            password = self.password,
            host = self.host
        )

        connect(
            alias = self.alias_geral,
            db = self.db_geral,
            username = self.username,
            password = self.password,
            host = self.host
        )

    def close_connections(self):
        disconnect(alias = self.alias_robo)
        disconnect(alias = self.alias_geral)