#!/bin/bash

# Execute with "sh vmCurl <mapping>" e.g. "sh vmCurl getImages"

mapping=$1
username="user"
password="password"
cookie_path=$PWD/cookies

# Perform GET, extract csrf token and  save session id in cookie jar
token_line=$(curl --request GET xx.xx.xx.81:8080/login -b $cookie_path -c $cookie_path -s | grep csrf)
token=$( echo "$token_line" | cut -d '"' -f6)

#echo; echo The CSRF token is: $token; echo

# POST username and password as url parameters to 'login', also use cookies
post_url=xx.xx.xx.81:8080login?_csrf=$token\&password\=$password\&username\=$username
curl -c $cookie_path -b $cookie_path --request POST $post_url

# GET from requested site
curl -c $cookie_path -b $cookie_path --request GET xx.xx.xx.81:8080/$mapping
echo
