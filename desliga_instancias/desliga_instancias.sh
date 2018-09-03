#!/bin/bash

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
        openstack server list | cut -d'|' -f 1-4 | grep -i ${STATUS[$s]} | grep ${PESQUISA[$s]} | awk '{print $2}' > $ARQ
        # Executuando a ação correspondente do horario programado naquele instancia
        for i in `cat $ARQ`; do openstack server ${PARAMETRO[$s]} $i; done
done  
