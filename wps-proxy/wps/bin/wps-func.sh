
# HEADER
# ---------------------------------------------------------------------------------

wps_header() {
	echo -e "\033[0;30m
-----------------------------------------------------
\033[0;34m  Submarine\033[0;37m - $1\033[0;30m
-----------------------------------------------------
\033[0m"
}

# MOUNT
# ---------------------------------------------------------------------------------

wps_mount() { 

	echo "" > /tmp/events.json
	echo "" > /tmp/domains.json
	echo "" > /tmp/domains.txt
	
	rm -rf /etc/nginx/conf.d/*
	
	cat $etc/nginx.conf > /etc/nginx/nginx.conf
	cat $etc/default.conf > /etc/nginx/conf.d/default.conf

	ln -sf /dev/stdout /var/log/nginx/access.log
	ln -sf /dev/stderr /var/log/nginx/error.log
	
	find $run -type f -exec chmod +x {} \;
}

# LISTEN
# ---------------------------------------------------------------------------------	

wps_listen() {

	curl -X GET http:/events \
	--unix-socket /tmp/docker.sock  \
	--no-buffer \
	--silent \
	> /tmp/events.json

}

# EVENTS
# ---------------------------------------------------------------------------------	

wps_events() {

	while inotifywait -e modify /tmp/events.json; do
	
		status="`tail -n1 /tmp/events.json | jq -r '.status'`"
		
		if [[  $status = 'start' || $status = 'die'  ]];
		then wps_reload &
		fi
		
	done	
}

# START
# ---------------------------------------------------------------------------------

wps_start() { 

	wps_header "Start"
	wps_mount
	wps_load

	exec s6-svscan $run
}

# RELOAD
# ---------------------------------------------------------------------------------

wps_reload() { 

	wps_header "Reload"
	wps_mount
	wps_load
	
	nginx -s reload
}
