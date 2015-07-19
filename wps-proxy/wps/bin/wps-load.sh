
# LOAD
# ---------------------------------------------------------------------------------

wps_load() { 

	event="`tail -n1 /tmp/events.json`"

	  if [[  $event == *'status":"exec_start'*  ]]; then /bin/true
	elif [[  $event == *'status":"restart'*  ]];    then /bin/true
	elif [[  $event == *'status":"exec_start'*  ]]; then /bin/true
	elif [[  $event == *'status":"stop'*  ]];       then /bin/true
	else exit
	fi
	
	rm -rf /etc/nginx/conf.d/*

	cat $etc/nginx.conf > /etc/nginx/nginx.conf
	cat $etc/default.conf > /etc/nginx/conf.d/default.conf
	
	find $run -type f -exec chmod +x {} \;

	cd /tmp
	
	echo "" > events.json
	echo "" > domains.json
	echo "" > domains.txt
	
	docker="curl -sN --unix-socket docker.sock -X GET http:"
	containers="`$docker/containers/json | jq -r '.[].Id'`"
	
	for id in $containers; do

		domain="`$docker/containers/$id/json | jq -r '.Config.Env[]?' | grep WP_DOMAIN | cut -d= -f2`"
		ssl="`$docker/containers/$id/json | jq -r '.Config.Env[]?' | grep WP_SSL | cut -d= -f2`"
		ip="`$docker/containers/$id/json | jq -r '.NetworkSettings.IPAddress'`"

		if [[  ! -z $domain  ]]; 
		then echo -e "{\"domain\":\"$domain\",\"ip\":\"$ip\",\"ssl\":\"$ssl\"}" >> domains.json
		fi

	done
	
	domains="`cat domains.json | jq -r '.domain' | awk '!a[$0]++'`"

	for domain in $domains; do
		
		upstream="`jq -r '. | select(.domain == "'$domain'") | .ip' < domains.json`"
		ssl="`jq -r '. | select(.domain == "'$domain'") | .ssl' < domains.json | awk '!a[$0]++'`"
		
		if [[  $ssl == 'true'  ]];
		then port='443' && if [[  ! -f ${ssl}/${domain}.crt  ]]; then wps_ssl $domain;fi
		else port='80'
		fi
		
		servers="`for server in $upstream; do echo "server $server:$port;"; done`"
				
		if [[  $ssl == 'true'  ]];
		then cat $etc/proxy443.conf | sed "s|SERVERS|$servers|g;s|DOMAIN|$domain|g" >> /etc/nginx/conf.d/default.conf
		else cat $etc/proxy80.conf  | sed "s|SERVERS|$servers|g;s|DOMAIN|$domain|g" >> /etc/nginx/conf.d/default.conf
		fi
	done
}
