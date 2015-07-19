
# HEADER
# ---------------------------------------------------------------------------------

wps_header() {
	echo -e "\033[0;30m
-----------------------------------------------------
\033[0;34m  Submarine\033[0;37m - $1\033[0;30m
-----------------------------------------------------
\033[0m"
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
	wps_load

	exec s6-svscan $run
}

# RELOAD
# ---------------------------------------------------------------------------------

wps_reload() { 

	wps_header "Reload"
	wps_load
	
	exec /usr/sbin/nginx -s reload
}
