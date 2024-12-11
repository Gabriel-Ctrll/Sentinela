📋 Visão Geral

O Sentinela é uma automação desenvolvida para gerenciar a tabela de conexões Wi-Fi de um roteador, garantindo que apenas dispositivos autorizados permaneçam conectados. Ele realiza o acesso às configurações do roteador, verifica os dispositivos conectados e exclui aqueles que não constam em uma lista pré-definida de dispositivos permitidos.

✨ Funcionalidades

🔐 Acesso automático ao roteador: O Sentinela autentica e navega pelas configurações do roteador.

📊 Verificação da tabela de conexões Wi-Fi: Identifica os dispositivos conectados.

✅ Validação de dispositivos: Compara os dispositivos conectados com uma lista autorizada.

🚫 Gerenciamento de conexões: Remove automaticamente dispositivos não autorizados da rede.

🛠️ Tecnologias Utilizadas

Linguagem de Programação: Python

Bibliotecas:

Selenium (ou outra biblioteca para navegação automatizada)

Requests (se necessário para chamadas à API do roteador)

ConfigParser (para gerenciamento de arquivos de configuração)

Arquivos de Configuração: Lista de dispositivos autorizados armazenada em um formato como JSON ou CSV.

📋 Pré-Requisitos

Acesso administrativo ao roteador.

Endereço IP do roteador.

Lista de dispositivos autorizados (com identificadores como MAC Address).

Ambiente configurado com Python e as bibliotecas necessárias instaladas.

Configure o arquivo config.json com as informações do roteador e a lista de dispositivos autorizados:

{
    "router_ip": "192.168.0.1",
    "username": "admin",
    "password": "senha",
    "authorized_devices": [
        {"name": "Laptop", "mac_address": "00:11:22:33:44:55"},
        {"name": "Smartphone", "mac_address": "66:77:88:99:AA:BB"}
    ]
}


O Sentinela acessará o roteador, verificará a tabela de conexões e removerá dispositivos não autorizados.

Verifique o log gerado para detalhes das ações realizadas.

🔒 Considerações de Segurança

Certifique-se de que as credenciais do roteador estejam protegidas.

Execute o Sentinela em um ambiente seguro, preferencialmente dentro de sua rede local.

Não compartilhe o arquivo config.json com informações sensíveis.

🌟 Próximos Passos

Implementação de notificações para alertar quando dispositivos não autorizados forem detectados.

Adaptação para suportar múltiplos modelos de roteadores.

Interface gráfica para facilitar a configuração e o uso.

🤝 Contribuição

Contribuições são bem-vindas! Sinta-se à vontade para abrir issues ou enviar pull requests com melhorias.


👤 Mantenedor: Gabriel Araujo da Silva
