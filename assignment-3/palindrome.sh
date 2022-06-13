#!/bin/bash

len=0
i=1

if [ -z $1 ]; then
	echo "Nothing entered. Exiting now..."
	exit
fi

len=`echo $1 | wc -c`
len=`expr $len - 1`
halfLen=`expr $len / 2`

while [ $i -le $halfLen ]
do
	c1=`echo $1 | cut -c $i`
	c2=`echo $1 | cut -c $len`
	
	#echo $c1
	#echo $c2
	#echo $halfLen

	if [ $c1 != $c2 ] ; then
		echo "Provided string '$1' is not a palindrome"
		exit
	fi

	i=`expr $i + 1`
	len=`expr $len - 1`

	#echo $i
	#echo $len

done

echo "Provided string '$1' is palindrome"
