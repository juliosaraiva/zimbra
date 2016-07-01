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
	echo "    	Zimbra Admin         "
	echo "------------------------------------------"
	echo
	echo "[ 1 ] Create dkim"
	echo "[ 2 ] Query dkim"
	echo "[ 3 ] Change User Password" 
	echo "[ 0 ] Sair"
	echo

	echo -n "Qual a opcao desejada ? "
	read opcao

	case $opcao in
		1) AddDkim ;;
		2) QueryDkim ;;
		3) ChPasswd ;;
		0) sair ;;
		*) echo "Invalid Option!" ; echo ; Menu ;;
	esac
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


sair(){

exit

}

Menu
