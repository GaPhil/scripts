
#!/bin/sh

# rsa encryption algorithm implementation as shell scripts by PKG

# generate random number
function generate {
	local random=$(awk -v min=3 -v max=25 'BEGIN{srand(); print int(min+rand()*(max-min+1))}')
	echo $random
}

# check for prime number
function isPrime () {
	n="$1"				# n = first argument
	if [ "$n" -le 1 ]; then 	# n <= 1
		echo 0 && return 0
	elif [ "$n" -le 3 ]; then	# n <= 3
		echo 1 && return 1
					# n mod 2 = 0 or n mod 3 = 0
	elif [[ $(( n % 2 )) == 0 ]] || [[ $(( n % 3 )) == 0 ]]; then
		echo 0 && return 0
	fi
	let i=5
	while (( $i * $i <= $n ))	# i * i <= n
	do
					# n mod i = 0 or n mod (i + 2) = 0
		if (( $n % $i == 0 )) || (( $n % (( $i + 2)) == 0 )) ; then
			echo 0 && return 0
		fi
		i=i+6
	done
	echo 1 && return 1
}

# generate numbers until a prime is generated
function randomPrime() {
	randPri=`generate`
	while [ `isPrime $randPri` -ne 1 ]
	do
		randPri=`generate`
	sleep 1
	done
	echo $randPri
}

p=`randomPrime`; echo prime p = "$p"
q=`randomPrime`; echo prime q = "$q"
n=$(( $p * $q )); echo n is used as the modulus for both the public and private keys = "$n"
totient=$(( ($p-1) * ($q-1) )); echo totient = "$totient"

# find greatest common denominator of two numbers
function gcd () {
dividend=$1
divisor=$2
remainder=1
if [ $divisor -eq 0 ]; then
	echo "GCD of $dividend and $divisor = $dividend"
	exit 0
fi

until [ "$remainder" -eq 0 ]
do
	let "remainder = $dividend % $divisor"
	dividend=$divisor
	divisor=$remainder
done
echo The GCD is: "$dividend"
}
gcd 5435 3141

# generate e
function genE() {
e=`randomPrime`
while [ $e -gt $totient ]
do
	e=`genPrime`
done
echo "$e"
}
e=`genE`; echo The public key e = $e

# compute the multiplicative inverse
function multInv() {
e=$1
m=$2
e=$((e%$m))
for ((i = 1 ; i < $m ; i++ ));
do
	if (( ($e * $i) % $m == 1 )); then
		echo "$i" 		# final i = d
	fi
done
}
d=`multInv $e $totient`; echo The private key d = $d

# encrypt
#echo Enter plain text:
#read plainText
#cipherText=$(($plainText**$e))
#cipherText=$(($cipherText%$n))
#echo cipher text = $cipherText

# decrypt
#echo Enter cipher text:
#read cipherTexti
#plainTexti=$(($cipherTexti**$d))
#plainTexti=$(($plainTexti%$n))
#echo plain text = $plainTexti

max=max=$((p * q)) # calc max for flattening

read msg
#i=$msg
#for x in $(seq 2 $e); do
#	msg=$((msg*i))			# multiply
#	msg=$((msg%max))		# flatten
#done
#echo "encr msg: $msg"

# decrypt message
#i=$msg2
#for x in $(seq 2 $d); do
#	msg2=$((msg2*i))		# multiply
#	msg2=$((msg2%max))		# flatten
#done
#echo "decr msg: $msg2
