# automacao_voc
Repositório focado para criar automação de tarefas na plataforma de Openstack do VivoOpenCloud

  
![license](https://img.shields.io/aur/license/yaourt.svg?longCache=true&style=popout-square)
![distro](https://img.shields.io/badge/ubuntu-16.04-805AFF.svg?longCache=true&style=popout-square)

## Pré requisitos

```
Ter uma conta no VivoOpenCloud
Ter permissões de administrador a um projeto do VivoOpenCloud
Um servidor Linux com Ubuntu 16.04
```

### Overview

1. Instalando
   1. Baixando repositório
   1. Instalando o Openstack CLI 
   1. Configurando o keystone 
1. Principais funcoes
   1. desliga_instancias
   1. gera_inventario
   1. api
   1. playbooks

### Instalando

#### Baixando repositório

O servidor Ubuntu 16.04 será o responsável por fazer a comunicação com a plataforma VivoOpenCloud.

Execute os comando para baixar os repositórios:

```
$ cd /usr/local/bin/ 
$ git clone https://github.com/smartao/automacao_voc.git
```

Recomendo que seja baixado no diretório /usr/local/bin/ pois já existe algumas configurações apontando para ele.

#### Instalando o Openstack CLI 

Toda a comunicação é realizada usando os pacotes do OpenStack CLI por isso é obrigatório a instalação.  
Na pasta **scripts_instalacao** existe o arquivo **instalando-openstackcli.sh** com todos os comandos de instalação bastando apenas executar o script.

Execute:

```
$ cd scripts_instalacao
$ ./instalando-openstackcli.sh
```

#### Configurando o keystone 

Para a comunicação funcionar entre o servidor Ubuntu e a plataforma VivoOpenCloud é necessário criar um arquivo de keystone que conterá as credenciais para autenticação da plataforma.

Na pasta **scripts_instalacao** existe o arquivo **keystone-modelo** contendo todas as principais configurações.  
Recomendo que seja copiado para a pasta do usuário do linux e renomeado para o nome do login do VivoOpenCloud.

```
$ cp keystone-modelo ~/
$ mv keystone-modelo keystone-NOMEDOSUARIO
```

Para conectar é necessário alterar apenas as 3 primeiras linhas do arquivo.

```
export OS_USERNAME="NOMEDOUSUARIO"
export OS_USER_DOMAIN_NAME="NOMEDOPROJETO"
export OS_PASSWORD="SENHA"
```
 
Para carregar as credenciais execute o comando:  
`$ source keystone-NOMEDOSUARIO`

Para validar o funcionamento execute:  
`$ openstack server list`

### Principais funções

#### desliga_instancias

Contém o script e as instruções de como configurar para as instâncias desligar e ligar em horários predeterminados.

#### gera_inventario

Script que gera relatório de todos os IPs e portas das instâncias criadas na plataforma e assim facilitar na utilização de ferramentas de orquestração como o Ansible.

Composto por dois arquivos:

*variaveis*  
Contém todas as principais configurações do script.

*gera_inventario.sh*  
Script que fará todo o trabalho de gerar o relatório.

Exemplo de configuração no crontab para executar todo os dias a 1h da manhã.  
`0 1 * * * /usr/local/bin/automacao_voc/gera_invetario/gera_inventario.sh > /dev/null`

#### api

Pasta que contém a API para desligamento/ligamento das instancias do VOC.

#### playbooks

Vários playbook em Ansible que utilizo no dia a dia.  
Existe um arquivo chamado **exemplo** demonstrando a utilização básica.

