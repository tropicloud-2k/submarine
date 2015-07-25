
# HEADER
# ---------------------------------------------------------------------------------

wps_header() {
	echo -e "\033[0;30m
-----------------------------------------------------
\033[0;32m  (wp-proxy)\033[0;37m - $1\033[0;30m
-----------------------------------------------------
\033[0m"
}

# HTTP
# ---------------------------------------------------------------------------------	

wps_http() {

	. /wps/inc/martin.sh
	
	get "/" root_handler
	root_handler () {
	    header "Content-Type" "text/html"
	    cat "/wps/inc/index.html"
	}
	
	get "/sites" sites_handler
	sites_handler () {
	    header "Content-Type" "text/plain"
	    cat "/tmp/domains.json"
	}
	
	get "/events" events_handler
	events_handler () {
	    header "Content-Type" "text/plain"
	    cat "/tmp/events.json"
	}
	
	get "/reload" reload_handler
	reload_handler () {
	    header "Content-Type" "text/plain"
	    wps_reload
	    echo "nginx reloaded"
	}
	
	wwwoosh_run martin_dispatch 8080
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

	wps_load		
	nginx -s reload
}

# ROOT
# ---------------------------------------------------------------------------------

wps_root() { 
	
	wps_header "Logged in as \033[1;37mroot\033[0m"
	su -l root
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
	  if tail -n1 $events | grep ':"start'; then wps_reload 2>&1 &
	  elif tail -n1 $events | grep ':"stop'; then wps_reload 2>&1 &
	  fi
	done
}

