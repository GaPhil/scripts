#!/bin/bash

# Execute with "sh springCurl <mapping> [<IP>]" e.g. "sh springCurl getImages  123.45.67.81"
# If no IP is specified then default is localhost.

ip="localhost"
if [ -n "$2" ]; then
  ip="$2"
fi

mapping=$1
username="user"
password="password"
cookie_path=$PWD/cookies

# Perform GET, extract csrf token and  save session id in cookie jar
token_line=$(curl --request GET $ip:8081/login -b $cookie_path -c $cookie_path -s | grep csrf)
token=$( echo "$token_line" | cut -d '"' -f6)

# POST username and password as url parameters to 'login', also use cookies
post_url=$ip:8081/login?_csrf=$token\&password\=$password\&username\=$username
curl -c $cookie_path -b $cookie_path --request POST $post_url

# GET from requested site
curl -c $cookie_path -b $cookie_path --request GET $ip:8081/$mapping
echo
