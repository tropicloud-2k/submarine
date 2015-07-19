
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

	inotifywait -m -e modify /tmp/events.json | wps_reload 2>&1 
}

# SSL
# ---------------------------------------------------------------------------------	

wps_ssl() {

	cd $ssl && curl -sL http://git.io/vmgTS | bash -s $1
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
	
	event="`tail -n1 /tmp/events.json`"

	  if [[  $event == *'status":"exec_start'*  ]]; then wps_load
	elif [[  $event == *'status":"restart'*  ]];    then wps_load
	elif [[  $event == *'status":"exec_start'*  ]]; then wps_load
	elif [[  $event == *'status":"stop'*  ]];       then wps_load
	else exit
	  fi
		
	nginx -s reload
}
