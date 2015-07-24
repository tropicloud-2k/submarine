#!/bin/bash

HTTP_PORT="8080"
HTTP_OUTPUT="/tmp/stdout"
HTTP_LOCATION="Location:"
HTTP_200="HTTP/1.1 200 OK"
HTTP_404="HTTP/1.1 404 Not Found"

rm -f $HTTP_OUTPUT
mkfifo $HTTP_OUTPUT

trap "rm -f $HTTP_OUTPUT" EXIT
echo "Starting HTTP server"
echo "Listening on port $HTTP_PORT"

while true
do cat $HTTP_OUTPUT | nc -l $HTTP_PORT > >(
	export REQUEST=
	while read LINE
	do LINE=$(echo "$LINE" | tr -d '[\r\n]')

		# GET
		if echo "$LINE" | grep -qE '^GET /'           
		then REQUEST=$(echo "$LINE" | cut -d ' ' -f2)
			
			# location ^/reload
			if echo $REQUEST | grep -qE '^/reload'
			then /usr/bin/wps reload > $HTTP_OUTPUT
			
			# location /
			else printf "%s\n%s %s\n\n%s\n" "$HTTP_404" "$HTTP_LOCATION" $REQUEST "Resource $REQUEST NOT FOUND!" > $HTTP_OUTPUT
			fi
		fi
	done)
done