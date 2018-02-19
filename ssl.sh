#!/bin/bash

#Encrypt/decrypt file using 256-bit Advanced Encryption Standard-Cipher Block Chaining with help of the openSSL library
#Make script executable using <chmod +x ssl.sh>
#Execute script using <./ssl.sh e | d in_file out_file>

#Parse filename and fileextensions
function parse {
    fullfile=$2
    filename=$(basename "$fullfile")
    extension="${filename##*.}"
    filename="${filename%.*}"
}

if [ $1 == "e" ]	# encrypt specify input and output
then
	openssl aes-256-cbc -in "$2" -out "$3"
fi

if [ $1 == "d" ]	# decrypt specify input and output
then
	openssl aes-256-cbc -d -in "$2" -out "$3"
fi

if [ $1 == "fe" ]       # encrypt folder into .enc format
then
        tar -c "$2" > ssl_temp;
        openssl aes-256-cbc -in ssl_temp -out "$3";
        rm ssl_temp
fi

if [ $1 == "fd" ]       # decrypt .enc folder to plain
then
        openssl aes-256-cbc -d -in "$2" -out ssl_temp;
        tar -xf ssl_temp;
        rm ssl_temp
fi
