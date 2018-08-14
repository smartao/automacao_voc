#!/bin/bash

# destino
DEST=/home/smartao/voc/
ARQT=inventario.tmp
ARQS=inventario
ARQF=inventario-full
PORTA=2222

# Carregando keystone
source /home/smartao/voc/keystone_sergei_brq

# Gerando lista de ips
openstack server list | grep -i srv |cut -d"|" -f 3,5 | cut -c58-70 | cut -d, -f1 | sort -n -t . -k 1,1 -k 2,2 -k 3,3 -k 4,4 > $DEST/$ARQT

# Adicionando port 2222 para acesso aos servidores
echo "" > $DEST/$ARQS
for i in `cat $DEST/$ARQS`;do echo $i:$PORTA >> $DEST/$ARQS; done

# Gerando lista com hostname e ips
openstack server list | grep -i srv |cut -d"|" -f 3,5 | cut -c2-9,57-69 | cut -d, -f1 | sort > $DEST/$ARQF

