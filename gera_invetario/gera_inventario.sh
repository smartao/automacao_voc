#!/bin/bash

# Carregando arquivo de variaveis
source /usr/local/bin/automacao_voc/gera_invetario/variaveis

# Carregando keystone
source $KEYSTONE

# Gerando lista de ips
openstack server list | grep -i $PREFIXO |cut -d"|" -f 3,5 | cut -d\= -f 2 | cut -d, -f1 | sort -n -t . -k 1,1 -k 2,2 -k 3,3 -k 4,4 > $DEST/$ARQT

# Adicionando porta da variavel PORTA para acesso aos servidores
echo "[all]"> $DEST/$ARQS
for i in `cat $DEST/$ARQT`;do echo $i:$PORTA >> $DEST/$ARQS; done

# Coletando o ID de todas as instancias
openstack server list | grep -i $PREFIXO | awk {'print $2'} > $DEST/$ARQT

# Limpar arquivo de inventario full
> $DEST/$ARQF

# Gerando lista com hostname e ips
for i in `cat $DEST/$ARQT`;do
    # Coletando hostname e IP
    HNAME=`openstack server show $i | grep " name " | awk {'print $4'}`
       IP=`openstack server show $i | grep -i address | awk {'print $4'} | cut -d\= -f 2 | cut -d, -f1`
    # Gerando arquivo com HOSTNAME = IP
    echo "$HNAME=$IP:$PORTA" >> $DEST/$ARQF
done

# Deletando arquivo temporario
rm $DEST/$ARQT >/dev/null 1>&2
