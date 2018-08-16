#!/bin/bash
# Versao: 2018.05.28
# Descricao: Script de automacao de ativacao e desativacao de Instancias alocadas no OpenStack.
# Regra: Criar o nome da instancia com a descrição do horário que deseja ligar e desligar.
#        Lembrando que o nome da instancia nao pode ultrapassar 64 caracteres.
# Parametros 
#       WA = Walkup Ligando as instancias
#       ST = Stop   Desligando as instancias
#       Horario de 0 a 23 segundo de h (hora)
# Exemplos de nomes
#       srvxpto-WA8h-ST18h  (Para ligar as 8 da manha e desligar as 18h)
#       srvacme-WA10h-ST20h (Para ligar as 10h da manhã e desligar as 20h)     
#       servidor123ab-ST23h       (Apenas desligar as instancias todo dia as 23h)
# Observações
#       O script não difere dias da semana, isso fica de responsabilidade do CRON!
# Exemplo crontab 
#       0 * * * 1-5 /usr/local/bin/openstack-automacao.sh > /dev/null
#       1-5 = sera executado apenas de segunda a sexta

ARQ=/tmp/instancias     # Arquivo temporario para armazenar instancias
PESQUISA[0]=ST`date "+%H"`h # ST = Stop   Desligando as instancias
PESQUISA[1]=WA`date "+%H"`h # WA = Walkup Ligando as instancias
PARAMETRO[0]=stop       # Comando para parar as instancias
PARAMETRO[1]=start      # Comando para iniciar as instancias
STATUS[0]=ACTIVE        # Status das instancias ativas, sera usando quando corresponder ao horario das instancias serem desligadas
STATUS[1]=SHUTOFF       # Status das instancias desalocadas, sera usando quando corresponder ao horario das instancias serem ligadas
KEYSTONE=/etc/scripts/keystone_vivo_cloud # Logalizazao do arquivo de keystone 

source $KEYSTONE # Carregando as variaveis do keystone

for ((s=0;s<${#STATUS[@]};s++)); # For que corre os dois status disponveis ACTIVE e SHUTOFF
do
        # Coletando todos os ID das instancias que corresponde a acao e horario atual
        openstack server list | cut -d'|' -f 1-4 | grep -i ${STATUS[$s]} | grep ${PESQUISA[$s]} | cut -d'|' -f 2 |  cut -d" " -f 2 > $ARQ
        # Executuando a ação correspondente do horario programado naquele instancia
        for i in `cat $ARQ`; do openstack server ${PARAMETRO[$s]} $i; done
done  
