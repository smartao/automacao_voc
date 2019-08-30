### Descricao

 Script de automacao de ativacao e desativacao de Instancias alocadas no OpenStack.  
 
#### Regras   
 Criar o nome da instancia com a TAG que corresponde a um horario.
 Exemplos de tags: AUTOT1, AUTOT2

 Nesse caso a tag AUTOT1 é um periodo de tempo e a tag AUTOT2 é outro periodo de tempo.
 Com isso podemos definir que servidores com
 tag AUTOT1, serao desligado de segunda a sexta as 8h e ligados de segunda a sexta as 20h
 tag AUTOT2, serao desligado de segunda a sexta as 10h e ligados de segunda a sexta as 22h

#### Exemplos
 
    srvxpto-AUTOT1 
    srvacme-AUTOT1
    servidor123ab-AUTOT2  

 
#### Crontab 
Exemplo de configuração para executar o cron

TAG AUTOT1
Ligando de segunda a sexta as 8h e desligando de segunda a sexta as 20h
    0 8 * * 1-5 /usr/local/bin/openstack-automacao.sh AUTOT1 start > /dev/null
    0 20 * * 1-5 /usr/local/bin/openstack-automacao.sh AUTOT1 stop > /dev/null

TAG AUTOT2
Ligando de segunda a sexta as 10h e Desligando de segunda a sexta as 22h
   
    0 10 * * 1-5 /usr/local/bin/openstack-automacao.sh AUTOT2 start > /dev/null
    0 22 * * 1-5 /usr/local/bin/openstack-automacao.sh AUTOT2 stop > /dev/null
 

