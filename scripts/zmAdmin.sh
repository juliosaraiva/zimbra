#!/bin/bash
#
# Date: 01/07/2016
# Author: Julio Saraiva - contato@juliosaraiva.com.br
# Web: www.juliosaraiva.com.br
#
#

clear

Menu(){
	echo "------------------------------------------"
	echo "			Zimbra Command Admin				 "
	echo "------------------------------------------"
	echo
	echo "[ 1 ] Create dkim"
	echo "[ 2 ] Query dkim"
	echo "[ 3 ] Change User Password"
	echo "[ 0 ] Exit"
	echo

	echo -n "Choose an option"
	read option

	case "$option" in
		1) AddDkim ;;
		2) QueryDkim ;;
		3) ChPasswd ;;
		0) Exit ;;
		*) echo "Invalid Option!" ; echo ; Menu ;;
	esac
}

AddDkim(){
			echo "Enter the domain name:"
			read DOMAIN

				zmprov gd "$DOMAIN"	> /dev/null 2>&1

				if [ $? -eq 0 ]; then
						/opt/zimbra/libexec/zmdkimkeyutil -a -d "$DOMAIN"
				else
						echo "Domain not found!"
	fi

}

QueryDkim(){
				echo "Enter the domain name:"
				read DOMAIN

				zmprov gd "$DOMAIN"	> /dev/null 2>&1

				if [ $? -eq 0 ]; then
						/opt/zimbra/libexec/zmdkimkeyutil -q -d "$DOMAIN"
				else
						echo "Domain not found!"
	fi
}

ChPasswd(){
	echo "Enter the account to change the password:"
	read ACCOUNT

	zmprov ga "$ACCOUNT" > /dev/null 2>&1

	if [ $? -ne 0 ]; then
			echo
		echo "404 Not found!"
				ChPasswd
	else
		echo "Enter the new password"
		read -s CHPASSWD

		zmprov sp "$ACCOUNT" "$CHPASSWD"

		if [ $? -eq 0 ]; then
			echo
			echo "Password changed successfully!"
		else
			echo
			echo "Unable to change the password! Try again!"
		fi
	fi

return

}


Exit(){

exit

}

Menu
