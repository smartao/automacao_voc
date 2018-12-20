#!/bin/bash

# Carregando arquivo de variaveis
source /usr/local/bin/automacao_voc/gera_invetario/variaveis

# Criando diretorio  de destino
mkdir $DEST > /dev/null 2>&1

# Carregando keystone
source $KEYSTONE

# Gerando lista de ips
openstack server list | grep -i $PREFIXO |cut -d"|" -f 3,5 | cut -d\= -f 2 | cut -d, -f1 | sort -n -t . -k 1,1 -k 2,2 -k 3,3 -k 4,4 > $DEST/$ARQT

# Adicionando porta da variavel PORTA para acesso aos servidores
echo "[all]"> $DEST/$ARQS
for i in `cat $DEST/$ARQT`;do echo $i:$PORTA >> $DEST/$ARQS; done

# Filtrando para o hostname instancias
openstack server list | grep -i $PREFIXO | cut -d"|" -f 3 | sed 's/ //g' > $TEMP/vochostname

# Filtrando o primeiro IP de todas as intancias
openstack server list | grep -i $PREFIXO | cut -d"|" -f 5 | cut -d\= -f 2 | cut -d, -f1 | sed 's/ //g' > $TEMP/vocip

# Filtro para status
openstack server list | grep -i $PREFIXO | cut -d"|" -f 3,4 | cut -d"|" -f2 | sed 's/ //g' > $TEMP/vocstatus

# Justando os arquivos
paste -d";" $TEMP/vochostname $TEMP/vocip $TEMP/vocstatus > $DEST/${ARQF}.csv

# Deletando arquivo temporario
rm $DEST/$ARQT >/dev/null 1>&2
