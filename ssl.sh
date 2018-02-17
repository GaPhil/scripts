#!/bin/bash

#Encrypt/decrypt file using 256-bit Advanced Encryption Standard-Cipher Block Chaining with help of the openSSL library
#Make script executable using <chmod +x ssl.sh>
#Execute script using <./ssl.sh e | d in_file out_file>

if [ $1 == "e" ]
then
	openssl aes-256-cbc -in $2 -out $3
fi

if [ $1 == "d" ]
then
	openssl aes-256-cbc -d -in $2 -out $3
fi
