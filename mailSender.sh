#!/bin/sh

# send individual mails to multiple recepients from csv file "<emailAddress>,<firstName>"

function send () {

	# change from address
	from=exmaple@gmail.com
	toEmailAddress=$1
	firstName=$2
	firstName="$(echo "${firstName}" | sed -e 's/[[:space:]]*$//')"		# remove trailing white space from firstName

	(
	echo "From: Someone <$from>";
	echo "To: $toEmailAddress";
	echo "Subject: The Subject of the mail";
	echo "Content-Type: text/html";
	echo "MIME-Version: 1.0";
	echo "";
	# email content
	# change email content as desired
	echo "
		<html>
			<head>
				<title>HTML E-mail</title>
			</head>
			<body>
				Hi $firstName,
				<br>
				Check out this cool stuff <a href='http://www.google.com'>here</a>.
			</body>
		</html>
	"
	) | sendmail $toEmailAddress
}

# read mail addresses and firs names from .csv file
# last row of csv is not read --> insert twice
cat listOfEmailAddresses.csv | while read line
do
	emailAddress=`echo $line | cut -d ',' -f1` 	#get emailAddress

	firstName=`echo $line | cut -d ',' -f2` 	#get firstName

	send $emailAddress $firstName
done
