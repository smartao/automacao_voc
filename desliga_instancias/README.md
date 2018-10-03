 #### Descricao:  
 Script de automacao de ativacao e desativacao de Instancias alocadas no OpenStack.  
 
 #### Regras:   
 Criar o nome da instancia com a descrição do horário que deseja ligar e desligar.  
 Lembrando que o nome da instancia nao pode ultrapassar 64 caracteres.  
 Caso o parâmetro de dia seja omitido o agendamento não funcionará.  
 
#### Parametros:
   
    WA = Walkup Ligando as instancias.
    ST = Stop   Desligando as instancias.
    Horario de 0 a 23 seguido do h (hora).
        Deve ser sempre 2 digitos ex: 01, 02 ate 22 e 23.
    Minuto de 0 a 55 seguido do m (minuto).
        Deve ser sempre 2 digitos ex: 00, 05 ate 50 e 55.
    D- = Dias da semana de 0 (Domingo) a 6 (Sabado).
 
#### Exemplos:
 
    srvxpto-WA08h10m-ST18h30m-D-0123456 (Ligando as 8:10 da manha e desligando as 18:30 todos os dias)
    srvacme-WA10h00m-ST20h00m-D-12345 (Ligando as 10h da manhã e desligando as 20h, de segunda a sexta)
    servidor123ab-ST23h45h-D-5 (Apenas desligar as instancias as 23:45 de sexta-feira)
  
#### Crontab 
Exemplo de configuração para executar o cron a cada 5 minutos
    `*/5 * * * * /usr/local/bin/openstack-automacao.sh > /dev/null`
