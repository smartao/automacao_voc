#!/bin/bash

# Carregando arquivo de variaveis
source /usr/local/bin/automacao_voc/variaveis

# Criando diretorio  de destino
mkdir $DEST > /dev/null 2>&1

# Carregando keystone
source $KEYSTONE

# Gerando lista de ips
openstack server list | grep -i $PREFIXO |cut -d"|" -f 3,5 | cut -d\= -f 2 | cut -d, -f1 | sort -n -t . -k 1,1 -k 2,2 -k 3,3 -k 4,4 > $DEST/$ARQT

# Adicionando porta da variavel PORTA para acesso aos servidores
echo "[all]"> $DEST/$ARQS
for i in `cat $DEST/$ARQT`;do echo $i:$PORTA >> $DEST/$ARQS; done

# Filtrando o hostname das instancias e armazenando em arquivo temporario
openstack server list | grep -i $PREFIXO | cut -d"|" -f 3 | sed 's/ //g' > $TEMP/vochostname

# Filtrando o primeiro IP de todas as intancias e armazenando em arquivo temporario
openstack server list | grep -i $PREFIXO | cut -d"|" -f 5 | cut -d\= -f 2 | cut -d, -f1 | sed 's/ //g' > $TEMP/vocip

# Filtro para status das instancias e armazenado em arquivo temporario
openstack server list | grep -i $PREFIXO | cut -d"|" -f 3,4 | cut -d"|" -f2 | sed 's/ //g' > $TEMP/vocstatus

# Justando os arquivos e separando itens por ponto e virgula
paste -d";" $TEMP/vochostname $TEMP/vocip $TEMP/vocstatus > $DEST/${ARQF}

# Deletando arquivo temporario
rm $DEST/$ARQT >/dev/null 1>&2
