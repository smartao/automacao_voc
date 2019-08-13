#!/bin/bash

ARQ=/tmp/instancias     # Arquivo temporario para armazenar instancias
STATUS[0]=ACTIVE        # Status das instancias ativas, sera usando quando corresponder ao horario das instancias serem desligadas
STATUS[1]=SHUTOFF       # Status das instancias desalocadas, sera usando quando corresponder ao horario das instancias serem ligadas
DOW="\-D.+`date "+%w"`" # Day of Week      Dia da Semana de 0 a 6
PESQUISAH[0]=ST`date "+%H"`h # ST = Stop    Desligando as instancias
PESQUISAH[1]=WA`date "+%H"`h # WA = Walkup  Ligando as instancias
PESQUISAM=h`date "+%M"`m   # Minuto para ativar e destivar o host
PARAMETRO[0]=stop       # Comando para parar as instancias
PARAMETRO[1]=start      # Comando para iniciar as instancias

KEYSTONE=/etc/scripts/vivo_cloud/keystone_vivo_cloud # Localizacao do arquivo keystone

source $KEYSTONE # Carregando as variaveis do keystone

for ((s=0;s<${#STATUS[@]};s++)); # For que corre os dois status disponveis ACTIVE e SHUTOFF
do
        # Coletando todos os ID das instancias que corresponde a acao e horario atual
        openstack server list | cut -d'|' -f 1-4 | grep -i ${STATUS[$s]} | grep -E $DOW | grep ${PESQUISAH[$s]} | grep $PESQUISAM | awk '{print $2}' > $ARQ
        for i in `cat $ARQ`; do  # Loop que executara as acoes de ativar/destivar e logar 
            openstack server ${PARAMETRO[$s]} $i; # Executuando a ação correspondente do horario programado naquele instancia
            TESTE=$? # Armazenando status do comando anterior (0/1, sucesso/falha)
            HNAME=`openstack server show $i | grep " name " | awk {'print $4'}` # Coletando o hostname para adicionar no log
            if [ $? -eq 0 ]; then # Verificar se comando foi executado corretamente
                logger -i -t voc "executando [OK]: openstack server ${PARAMETRO[$s]} $i ($HNAME);" # Logando sucesso ao executar acao
            else # se ocorreu algum erro
                logger -i -t voc "executando [OK]: openstack server ${PARAMETRO[$s]} $i ($HNAME);" # Logando falha ao executar a acao
            fi
        done
done  
