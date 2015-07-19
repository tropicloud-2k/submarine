
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

	while inotifywait -m -e modify /tmp/events.json; do
	
		status="`tail -n1 /tmp/events.json | jq -r '.status'`"
		
		  if [[  $status = 'start'  ]]; then wps_reload &
		elif [[  $status = 'die'  ]]; then wps_reload &
		  fi
		
	done
}

# SSL
# ---------------------------------------------------------------------------------	

wps_ssl() {

	inotifywait -m /wps/ssl --format '%w%f' -e create | wps_reload

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
