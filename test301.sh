#!/bin/bash
 
#This script aims at checking if 301 redirects are properly implemented
#according to a simple csv file with two columns

function help {
	echo "test301";
	echo "usage: test301.sh myfile.csv";
	echo "where myfile.csv is a csv file with two columns separated by semi-colon (;) with target and source url, each beginning by /";
	echo "/my/source/folder/index.html;/my/target/folder/indexe.html"
	echo "root domain name can be customized using the ROOT variable";
	echo "there's a sleep period of 1 second between each curl that can be removed (caution)";
}

ROOT="http://preprod1.uk.thenorthface.com"
 
#Temporary file I am using to store non 301 redirected URLs.
REDIRECTKO=301koreport.txt
LOCATIONKO=locationkoreport.txt
REDIRECT404=redirect404report.txt
 
#Here I make sure these files does not exist before processing the URLs.
rm -f $REDIRECTKO
rm -f $LOCATIONKO
rm -f $REDIRECT404

if [ $1 ]
then
    INPUT=$1 
else
    help
fi

START=`date +%s.%N`

# change IFS=';' to the good column separator
cat $INPUT | while IFS=';' read source target; do
CURL=`curl -I -s $ROOT$source`
CURL_T=`curl -I -s $ROOT$target`
echo "testing redirect from $ROOT$source to $ROOT$target...";
RESULT=`echo "$CURL"`
R=`echo "$RESULT" | egrep '^HTTP\/1\.1 301'`
L=`echo "$RESULT" | grep "^Location: $ROOT$target"`
E=`echo "$CURL_T" | egrep '^HTTP\/1\.1 404'`
#sleep 1
 if [ -z "$R" ]
    then
         echo $ROOT$source >> $REDIRECTKO
		 echo "No 301 code redirect for this URL"
 elif [ -z "$L" ]
    then
        echo "$ROOT$source doesn't redirect to $ROOT$target" >> $LOCATIONKO
		 echo "This URL is not redirected to the good target"
 elif [ -n "$E" ]
    then
        echo "$ROOT$target leads to a 404" >> $REDIRECT404
            echo "This URL is redirected to a 404"
 else
 	 	echo "it seems ok"
	fi
	echo ""
 done

END=`date +%s.%N`

ELAPSED=$(echo "$END - $START" | bc)
echo "time elapsed : $ELAPSED"
 
#EOF
