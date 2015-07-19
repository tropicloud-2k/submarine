
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

	events="/tmp/events.json"
	
	while inotifywait -e modify $events; do
	    if tail -n1 $events | grep ':"exec_start'; then wps_reload 2>&1 &
	  elif tail -n1 $events | grep ':"restart'; then wps_reload 2>&1 &
	  elif tail -n1 $events | grep ':"start'; then wps_reload 2>&1 &
	  elif tail -n1 $events | grep ':"stop'; then wps_reload 2>&1 &
	  fi
	done
}

# SSL
# ---------------------------------------------------------------------------------	

wps_ssl() {

	cd /wps/ssl && curl -sL http://git.io/vmgTS | bash -s $1
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

	sleep 5
	
	wps_header "Reload"
	wps_load
		
	nginx -s reload
}
