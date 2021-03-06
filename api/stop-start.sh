#!/bin/bash

# Carregando arquivo de variaveis
source /usr/local/bin/automacao_voc/variaveis

PASTA[0]="start"       # Pasta que conterá as instancias que deverao ser ligadas
PASTA[1]="stop"        # Pasta que conterá as instancias que deverao ser desligadas
PARAMETRO[0]="start"    # Comando para iniciar as instancias
PARAMETRO[1]="stop"     # Comando para parar as instancias

KEYSTONE=/etc/scripts/vivo_cloud/keystone_vivo_cloud # Localizacao do arquivo keystone
source $KEYSTONE # Carregando as variaveis do keystone

for ((s=0;s<${#PASTA[@]};s++)); # For que corre pesquisando por host para desligar e ligar
do
    mkdir $DEST/${PASTA[$s]} 2>/dev/null # Criando pastas para armazenar os arquivos
    chown $USUARIO:$USUARIO $DEST/${PASTA[$s]} 2>/dev/null # Fornecendo permissos a pasta de gravacao
    for i in `ls $DEST/${PASTA[$s]}`; do
        openstack server ${PARAMETRO[$s]} $i 2>/dev/null # Ligando/desligando instancias que estao na pasta
        if [ $? -eq 0 ]; then # Verificar se comando foi executado corretamente
            logger -i -t voc "executando [OK]: openstack server ${PARAMETRO[$s]} $i" # Logando sucesso ao executar acao
        else # Caso ocorra algum erro
            logger -i -t voc "executando [FAIL]: openstack server ${PARAMETRO[$s]} $i" # Logando falha ao executar acao
        fi
        rm "$DEST/${PASTA[$s]}/$i" 2>/dev/null # Deletando arquivos das instancias para nao ser executado novamente
        logger -i -t voc "deletado o arquivo $DEST/${PASTA[$s]}/$i" # Logando a delecao do arquivo 
    done
done
