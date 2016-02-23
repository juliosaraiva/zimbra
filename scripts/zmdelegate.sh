#!/bin/bash
echo "Digite o nome do usuario que deseja delegar"
read USER
sleep 2
#DOMAINS=$(cat domains > /dev/null)
echo "Digite o dominio que deseja delegar"
read DOMAIN


		zmprov ma ${USER} zimbraIsDelegatedAdminAccount TRUE
		zmprov ma ${USER} +zimbraAdminConsoleUIComponents accountListView
		zmprov ma ${USER} +zimbraAdminConsoleUIComponents aliasListView
		zmprov ma ${USER} +zimbraAdminConsoleUIComponents DLListView
		zmprov ma ${USER} +zimbraAdminConsoleUIComponents rightListView
		zmprov ma ${USER} +zimbraAdminConsoleUIComponents domainAdminRights

#for DOMAIN in ${DOMAINS}; do
#	echo ${DOMAIN}

		# alias ACL
		zmprov grr domain ${DOMAIN} usr ${USER} +deleteAlias
		zmprov grr domain ${DOMAIN} usr ${USER} +listAlias
		zmprov grr domain ${DOMAIN} usr ${USER} createAlias
		zmprov grr domain ${DOMAIN} usr ${USER} listAlias

		# account ACL
		zmprov grr domain ${DOMAIN} usr ${USER} +domainAdminRights
		zmprov grr domain ${DOMAIN} usr ${USER} +adminConsoleAccountRights
		zmprov grr domain ${DOMAIN} usr ${USER} +listAccount
		zmprov grr domain ${DOMAIN} usr ${USER} +deleteAccount
		zmprov grr domain ${DOMAIN} usr ${USER} +renameAccount
		zmprov grr domain ${DOMAIN} usr ${USER} +createAccount
		zmprov grr domain ${DOMAIN} usr ${USER} +setAccountPassword
		zmprov grr domain ${DOMAIN} usr ${USER} set.account.zimbraAccountStatus
		zmprov grr domain ${DOMAIN} usr ${USER} set.account.sn                 
		zmprov grr domain ${DOMAIN} usr ${USER} set.account.displayName
		zmprov grr domain ${DOMAIN} usr ${USER} set.account.zimbraPasswordMustChange

		# distribution list ACL
		zmprov grr domain ${DOMAIN} usr ${USER} createDistributionList
		zmprov grr domain ${DOMAIN} usr ${USER} addDistributionListMember
		zmprov grr domain ${DOMAIN} usr ${USER} removeDistributionListMember
		zmprov grr domain ${DOMAIN} usr ${USER} getDistributionList
		zmprov grr domain ${DOMAIN} usr ${USER} modifyDistributionList
		zmprov grr domain ${DOMAIN} usr ${USER} deleteDistributionList
		zmprov grr domain ${DOMAIN} usr ${USER} renameDistributionList
		zmprov grr domain ${DOMAIN} usr ${USER} listDistributionList

		zmprov grr domain ${DOMAIN} usr ${USER} set.account.zimbraAccountStatus
		zmprov grr domain ${DOMAIN} usr ${USER} set.account.sn
		zmprov grr domain ${DOMAIN} usr ${USER} set.account.displayName
		zmprov grr domain ${DOMAIN} usr ${USER} set.account.zimbraPasswordMustChange
	#done
