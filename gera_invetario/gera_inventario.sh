#!/bin/bash

#### Carregando variaveis necessárias ####
# Definicao do keystone
KEYSTONE="/home/smartao/voc/keystone_sergei" 

# Diretorio de destino dos arquivos
DEST=/home/smartao/voc/

# Arquivo temporario para gerar relatorio
ARQT=inventario.tmp

# Arquivo de hosts simples com apenas IPs
ARQS=inventario

# Arquivo de hosts com hostname e IPs
ARQF=inventario-full

# Porta de acesso ssh dos servidores
PORTA=2222
############################################

# Carregando keystone
source $KEYSTONE

# Gerando lista de ips
openstack server list | grep -i srv |cut -d"|" -f 3,5 | cut -c58-70 | cut -d, -f1 | sort -n -t . -k 1,1 -k 2,2 -k 3,3 -k 4,4 > $DEST/$ARQT

# Adicionando porta da variavel PORTA para acesso aos servidores
echo "[all]"> $DEST/$ARQS
for i in `cat $DEST/$ARQT`;do echo $i:$PORTA >> $DEST/$ARQS; done

# Deletando arquivo temporario
rm $DEST/$ARQT

# Gerando lista com hostname e ips
openstack server list | grep -i srv |cut -d"|" -f 3,5 | cut -c2-9,57-69 | cut -d, -f1 | sort > $DEST/$ARQF

