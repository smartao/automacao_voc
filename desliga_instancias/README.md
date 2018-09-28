 #### Descricao:  
 Script de automacao de ativacao e desativacao de Instancias alocadas no OpenStack.
 
 #### Regra:   
 Criar o nome da instancia com a descrição do horário que deseja ligar e desligar.
 Lembrando que o nome da instancia nao pode ultrapassar 64 caracteres.
 Caso o parâmetro de dia seja omitido o agendamento não funcionará.
 
#### Parametros:
   
    WA = Walkup Ligando as instancias
    ST = Stop   Desligando as instancias
    Horario de 0 a 23 segundo de h (hora)
    D- = Dias da semana de 0 (Domingo) a 6 (Sabado)
 
#### Exemplos:
 
    srvxpto-WA8h-ST18h-D-0123456 (Ligando as 8 da manha e desligando as 18h todos os dias)
    srvacme-WA10h-ST20h-D-12345 (Ligando as 10h da manhã e desligando as 20h, de segunda a sexta)
    servidor123ab-ST23h-D-5 (Apenas desligar as instancias as 23h de sexta-feira)
  
#### Crontab 
Exemplo de configuração do cron
    `0 * * * * /usr/local/bin/openstack-automacao.sh > /dev/null`
