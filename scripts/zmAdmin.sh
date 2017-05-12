#!/bin/bash
#
# Date: 01/07/2016
# Autor: Julio Saraiva - contato@juliosaraiva.com.br
# Web: www.juliosaraiva.com.br
#
#

clear

Menu(){
	echo "------------------------------------------"
	echo "    			Zimbra Admin	 		    "
	echo "------------------------------------------"
	echo
	echo "[ 1 ] Create domain"
	echo "[ 2 ] Gerar DKIM"
	echo "[ 3 ] Consultar DKIM"
	echo "[ 4 ] Alterar senha do usuário"
	echo "[ 5 ] Delegar conta para um domínio"
	echo "[ 6 ] Remover Delegação de conta"
	echo "[ 7 ] Migra Email-s"
	echo "[ 0 ] Sair"
	echo

	echo -n "Qual a opcao desejada ? "
	read opcao

	case $opcao in
		1) CreateDomain ;;
		2) AddDkim ;;
		3) QueryDkim ;;
		4) ChPasswd ;;
		5) DelegaAcc ;;
		6) RemDelegate ;;
		7) MigraMail ;;
		0) sair ;;
		*) echo "Invalid Option!" ; echo ; Menu ;;
	esac
}

CreateDomain(){
	echo "Informe o dominio: "
	read DOMAIN

	if [ -n "$DOMAIN" ]; then
		zmprov cd "$DOMAIN"
	else
		echo "Invalid Domain!"
		CreateDomain
	fi
}

AddDkim(){
    	echo "Enter the domain name:"
    	read DOMINIO

        zmprov gd $DOMINIO  > /dev/null 2>&1

        if [ $? -eq 0 ]; then
            /opt/zimbra/libexec/zmdkimkeyutil -a -d $DOMINIO
        else
            echo "Domain not found!"
	fi

}

QueryDkim(){
        echo "Enter the domain name:"
        read DOMINIO

        zmprov gd $DOMINIO  > /dev/null 2>&1

        if [ $? -eq 0 ]; then
            /opt/zimbra/libexec/zmdkimkeyutil -q -d $DOMINIO
        else
            echo "Domain not found!"
	fi
}

ChPasswd(){
	echo "Enter the account to change the password:"
	read ACCOUNT

	zmprov ga "$ACCOUNT" > /dev/null 2>&1

	if [ $? -ne 0 ]; then
		echo "404 Not found!"
        ChPasswd
	else
		echo "Enter the new password"
		read -s CHPASSWD

		zmprov sp "$ACCOUNT" "$CHPASSWD"

		if [ $? -eq 0 ]; then
			echo "Password changed successfully!"
		else
			echo "Unable to change the password! Try again!"
		fi
	fi

return

}

DelegaAcc(){
	echo "Digite o nome do usuario que deseja delegar"
	read USER

	zmprov ga $USER > /dev/null 2>&1

		if [ $? -ne 0 ]; then
			echo "Usuario não cadastrado!"
			echo
			Verifica
		else
			echo "Digite o dominio que deseja delegar"
			read DOMAIN
		fi

	if [ -n $USER ] && [ -n $DOMAIN ]; then

		zmprov ma $USER zimbraIsDelegatedAdminAccount TRUE
		zmprov ma $USER +zimbraAdminConsoleUIComponents accountListView
		zmprov ma $USER +zimbraAdminConsoleUIComponents aliasListView
		zmprov ma $USER +zimbraAdminConsoleUIComponents DLListView
		zmprov ma $USER +zimbraAdminConsoleUIComponents rightListView
		zmprov ma $USER +zimbraAdminConsoleUIComponents domainAdminRights

		# alias ACL
		zmprov grr domain $DOMAIN usr $USER +deleteAlias
		zmprov grr domain $DOMAIN usr $USER +listAlias
		zmprov grr domain $DOMAIN usr $USER createAlias
		zmprov grr domain $DOMAIN usr $USER listAlias

		# account ACL
		zmprov grr domain $DOMAIN usr $USER +domainAdminRights
		zmprov grr domain $DOMAIN usr $USER +adminConsoleAccountRights
		zmprov grr domain $DOMAIN usr $USER +listAccount
		zmprov grr domain $DOMAIN usr $USER +deleteAccount
		zmprov grr domain $DOMAIN usr $USER +renameAccount
		zmprov grr domain $DOMAIN usr $USER +createAccount
		zmprov grr domain $DOMAIN usr $USER +setAccountPassword
		zmprov grr domain $DOMAIN usr $USER set.account.zimbraAccountStatus
		zmprov grr domain $DOMAIN usr $USER set.account.sn
		zmprov grr domain $DOMAIN usr $USER set.account.displayName
		zmprov grr domain $DOMAIN usr $USER set.account.zimbraPasswordMustChange

		# distribution list ACL
		zmprov grr domain $DOMAIN usr $USER createDistributionList
		zmprov grr domain $DOMAIN usr $USER addDistributionListMember
		zmprov grr domain $DOMAIN usr $USER removeDistributionListMember
		zmprov grr domain $DOMAIN usr $USER getDistributionList
		zmprov grr domain $DOMAIN usr $USER modifyDistributionList
		zmprov grr domain $DOMAIN usr $USER deleteDistributionList
		zmprov grr domain $DOMAIN usr $USER renameDistributionList
		zmprov grr domain $DOMAIN usr $USER listDistributionList

		zmprov grr domain $DOMAIN usr $USER set.account.zimbraAccountStatus
		zmprov grr domain $DOMAIN usr $USER set.account.sn
		zmprov grr domain $DOMAIN usr $USER set.account.displayName
		zmprov grr domain $DOMAIN usr $USER set.account.zimbraPasswordMustChange
	else
		echo "Não foi possível delegar o usuário!"
	fi

}

RemDelegate(){
	echo "Informe o usuario para remover delegacao"
	read USER

	zmprov ga $USER > /dev/null 2>&1

	if [ $? -ne 0 ]; then
		echo "Usuario não cadastrado!"
		echo
	fi

	if [ -n $USER ]; then
		zmprov ma $USER zimbraIsDelegatedAdminAccount FALSE
                zmprov ma $USER -zimbraAdminConsoleUIComponents accountListView
                zmprov ma $USER -zimbraAdminConsoleUIComponents aliasListView
                zmprov ma $USER -zimbraAdminConsoleUIComponents DLListView
                zmprov ma $USER -zimbraAdminConsoleUIComponents rightListView
                zmprov ma $USER -zimbraAdminConsoleUIComponents domainAdminRights
	else
		echo "Nao foi possivel remover delegacao do usuario!"
	fi

}

MigraMail(){
	/usr/local/sysnetpro/zmmigrate
}

#CriaBackup(){
#	read -p "Informe o dominio que deseja realizar o backup: " DOMAIN
#	zmprov gd "$DOMAIN" > /dev/null 2>&1
#	if [ $? -ne 0 ]; then
#		echo "Domínio não cadastrado!"
#	else
#
#	fi
#}

sair(){

exit

}

Menu
