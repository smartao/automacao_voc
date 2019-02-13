### Descrição

Para utilização da API é necessário:
1. Criar um usuário no servidor de automação.
1. Gerar chave SSH para permitir acesso sem senha. (opcional)
1. Configurar crontab para:
   1. Gerar relatório das instâncias que o usuário tera acesso.
   1. Executar a api.

Observações:  
É necessário que o script de geração de relatório estar funcionando.  
No momento o script funciona apenas com um tenant.    

### Funcionamento básico

Será gerado periodicamente *inventario-full.csv* no home do usuário configurado.  
Contendo todos os servidores relacionado ao projeto que o usuário pertence.  
Padrão desse arquivo: hostname;IP;status  

Para desligar/ligar criei um arquivo com o nome do servidor na pasta */tmp/voc/start* e */tmp/voc/start*.  

Exemplo ligando servidor  
`$ touch /tmp/voc/start/srv1234-devops`

Exemplo desligando servidor  
`$ touch /tmp/voc/stop/srv1234-devops`

Com a configuração da chave SSH é possível fazer esse procedimento remotamente.    

Exemplo ligando remotamente  
`$ ssh devopsdeploy@10.2.1.120 touch /tmp/voc/start/srv1234-devops`

Exemplo desligadmento remotamente  
`$ ssh devopsdeploy@10.2.1.120 touch /tmp/voc/stop/srv1234-devops`

#### Criando usuário no servidor  

Será criado um usuário chamado *devopsdeploy*.  
Servidor de automação tem o IP *10.2.1.120*.  

Criando usuário *devopsdeploy*.  
`# useradd -m -s /bin/bash devopsdeploy`

Configurando para trocar a senha no primeiro logon.  
`# passwd -e devopsdeploy`

Configurar sudo para visualizar os logs do sistema.  
`# echo "devopsdeploy ALL=(ALL) /bin/journalctl" >> /etc/sudoers`

#### Criando chave SSH

Em um host Linux cliente, que acessará o servidor que tem a API em funcionamento gere uma chave SSH.
`$ ssh-keygen`

Copiar chave para o servidor de automação.  
`$ ssh-copy-id devopsdeploy@10.2.1.120`

Obs: Com isso o usuário conseguirá logar no servidor de automação sem precisar utilizar senha.

#### Configurando crontab

Abrir o crontab.  
`# crontab -e`

Adicionar as linhas para gerar o relatório no home do usuário devops deploy.  
```
# Relatorio VOC das instancias do projeto devops, API
* * * * * /bin/cat /tmp/voc/inventario-full.csv | /bin/grep -i devops >/home/devopsdeploy/inventario-full.csv 2>/dev/null
```

Adicione as linhas que faz a execução da API.  
```
# API para desligar/ligar instancias do projeto DevOps, API
* * * * * /usr/local/bin/automacao_voc/api/stop-start.sh >/dev/null 2>&1 
```

O script lerá todos os arquivos da pasta */tmp/voc/stop* e */tmp/voc/start*.

#### Utilizando a API

A ideia é que no host Linux cliente (que teve a chave SSH configurado no servidor automação).
Copie ou acesse a lista completa de servidores.  
`$scp devopsdeploy@10.2.1.120:/home/desvopsdeploy/inventario-full.csv .`
 
E apatir dessa lista encontre o host que deseja ligar ou desligar.  

Exemplo de utilização manual.  

Ligando o servidor srv1234-devops remotamente.  
`$ ssh devopsdeploy@10.2.1.120 touch /tmp/voc/start/srv1234-devops`

Desligadno servidor srv1234-devops remotamente.  
`$ ssh devopsdeploy@10.2.1.120 touch /tmp/voc/stop/srv1234-devops`

Observações:
Todas as ações realizadas pela API são logadas no syslog do sistema.

Para visualizar os logs execute:  
`$ sudo journalctl -b -x --no-pager | grep "voc\["`
