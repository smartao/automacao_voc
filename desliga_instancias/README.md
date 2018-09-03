 #### Descricao:  
 Script de automacao de ativacao e desativacao de Instancias alocadas no OpenStack.
 
 #### Regra:   
 Criar o nome da instancia com a descrição do horário que deseja ligar e desligar.
 Lembrando que o nome da instancia nao pode ultrapassar 64 caracteres.
 
#### Parametros:
   
    WA = Walkup Ligando as instancias
    ST = Stop   Desligando as instancias
    Horario de 0 a 23 segundo de h (hora)
 
#### Exemplos:
 
    srvxpto-WA8h-ST18h  (Para ligar as 8 da manha e desligar as 18h)
    srvacme-WA10h-ST20h (Para ligar as 10h da manhã e desligar as 20h)     
    servidor123ab-ST23h (Apenas desligar as instancias todo dia as 23h)
 
#### Observações:  
O script não difere dias da semana, isso fica de responsabilidade do CRON!
  
#### Crontab 
Exemplo para ligar e desligar de segunda a sexta
    `0 * * * 1-5 /usr/local/bin/openstack-automacao.sh > /dev/null`
 
#### Sendo:  
 1-5 = sera executado apenas de segunda a sexta.

