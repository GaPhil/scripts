#!/bin/bash
echo
echo Bash Addressbook! Welcome to the bash addressbook and thanks for trying it out!
echo

while [ "$operation" != "q" ]; do

	echo What operation would you like to do?
	echo Choose between $(tput setaf 2)ADD$(tput sgr0), $(tput setaf 7)DISPLAY$(tput sgr0), FIND, $(tput setaf 1)REMOVE$(tput sgr0) and Q:

	read operation

	case $operation in
#	echo ======================================================================================

	"add")
		echo $(tput setaf 2)ADD$(tput sgr0) has been selected.
		echo Please enter the first name:
		read firstName
		echo Please enter the last name:
		read lastName
		echo $firstName $lastName >> contacts.txt
		echo $firstName $lastName has been added to the addressbook.
	;;

	"display")
		echo $(tput setaf 7)DISPLAY$(tput sgr0) has been selected.
		echo
		if [ -f ${PWD}/contacts.txt ]; then
			cat contacts.txt
		else
			echo Addressbook empty or not found.
		fi
	;;

	"find")
		echo FIND has been selected
		echo Enter first or last name:
		read firstLast
		if grep -qR "$firstLast" contacts.txt ; then
			echo "$firstLast" was found in the address book.
		else
			echo "$firstLast" could not be found in the address book.
		fi
	;;

	"remove")
		echo $(tput setaf 1)REMOVE$(tput sgr0) has been selected:
		echo Please enter the first and last name of the contact that you wish to remove:
		read firstLast2
		if grep -qR "$firstLast2" contacts.txt ; then
			echo "$firstLast2" was found in the address book.;
			sed "/$firstLast2/d" < contacts.txt > contacts.txt
		#	sed "/$firstLast2/d" contacts.txt
			echo "$firstLast2" has been removed.
		else
			echo "$firstLast2" could not be found in the address book.
		fi

	;;

	"q")
		echo Thanks for using Addressbook
	;;

	*)
		echo Not a valid command
	;;
esac
	echo ======================================================================================
done
