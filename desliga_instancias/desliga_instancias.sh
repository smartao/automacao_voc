#!/bin/bash

#$1 parametro1 tag do nome da maquina, ex srvxpto-AUTOT1
#$2 parametro2 acao que sera executado, ex STOP ou START
ARQ=/tmp/instancias1     # Arquivo temporario para armazenar instancias

KEYSTONE=/etc/scripts/vivo_cloud/keystone_vivo_cloud # Localizacao do arquivo keystone

source $KEYSTONE # Carregando as variaveis do keystone

# Coletando todos os ID das instancias que corresponde a acao e a tag no nome
openstack server list | cut -d'|' -f 1-4 | grep -i $1 | awk '{print $2}' > $ARQ

for i in `cat $ARQ`; do  # Loop que executara as acoes de ativar/destivar e logar 
	openstack server $2 $i; # Executuando a ação correspondente do horario programado naquele instancia
    TESTE=$? # Armazenando status do comando anterior (0/1, sucesso/falha)
    HNAME=`openstack server show $i | grep " name " | awk {'print $4'}` # Coletando o hostname para adicionar no log
    if [ $TESTE -eq 0 ]; then # Verificar se comando foi executado corretamente
    	STATUS="OK"
	else # se ocorreu algum erro
    	STATUS="FALHA"
	fi
	logger -i -t voc "executando [$STATUS]: openstack server $2 $i ($HNAME);" # Logando falha ao executar a acao
done
