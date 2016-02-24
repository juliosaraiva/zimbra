#!/bin/bash
#
# Script para realizar hot-backup do servidor zimbra junto com a ferramenta zmbkpose- versão 1.0
#
### ATENÇÃO - Este script utiliza a ferramenta zmbkpose para realizar o backup
### antes de configurá-lo é necessário instalar a ferramenta zmbkpose disponível no link abaixo.
#
# Link para download do zmbkpose: https://github.com/bggo/Zmbkpose
#

LOG=/opt/zimbra/log/backup.log
RUN=/var/run/zimbra/backup.pid

exec 1>${LOG}
exec 2>&1

function backup {
DIR=/srv/backup/zmbkpose	# Informe aqui o diretório que deseja realizar o backup

if [ -e $DIR  ]	&& [ -w $DIR ]	# Testa se o diretório informado está acessível
then 
	cd $DIR
else
	exit 1
fi

DAT=`date +%w`			# Verifica o dia da semana

if [ $DAT -eq 0 ]		# Se o dia da semana for domingo - o script executa o then ; senão executa o else
then
	/usr/local/bin/zmbkpose -f		# Faz backup full de todas as contas
	/usr/local/bin/zmbkpose -d 4 weeks	# Deleta os backups das últimas 4 semanas
else
	/usr/local/bin/zmbkpose -i		# Faz backup incremental de todas as contas
fi
}

	email() {

if [ $1 -eq 0 ] 		# Testa se o backup foi realizado com sucesso ou se obteve falha
then 
	SUB="Sucesso"   # Se o backup for realizado com sucesso o subject do email informa sucesso
else 
	SUB="Falha"	# Se o backup falhar o subject do email informa falha
fi

# Cria um arquivo com o nome reports com as informações do backup para encaminhar ao administrador.
	
echo "to:suporte@dominio.com.br" > /usr/local/empresa/reports.txt
echo "from:admin@dominio.com.br" >> /usr/local/empresa/reports.txt
echo "subject:"$SUB" Backup contas Zimbra" >> /usr/local/empresa/reports.txt
cat /opt/zimbra/log/backup.log >> /usr/local/empresa/reports.txt
ls -l /srv/backup/zmbkpose >> /usr/local/empresa/reports.txt
/opt/zimbra/postfix/sbin/sendmail -t < /usr/local/empresa/reports.txt

}

# Testa se o backup ainda está em execução
if [ -e $RUN ]
then
	echo "erro: processo em execucao "
	exit 1
fi

PID=$$
echo $PID > $RUN
backup
email $?
rm -f $RUN

exit 2

