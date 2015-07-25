
# HEADER
# ---------------------------------------------------------------------------------

wps_header() {
	echo -e "\033[0;30m
-----------------------------------------------------
\033[0;34m  wp-proxy\033[0;37m - $1\033[0;30m
-----------------------------------------------------
\033[0m"
}

# LISTEN
# ---------------------------------------------------------------------------------	

wps_listen() {

	. /wps/inc/martin.sh
	
	get "/" root_handler
	root_handler () {
	    header "Content-Type" "text/html"
	    cat "/wps/inc/index.html"
	}
	get "/reload" root_handler
	root_handler () {
	    header "Content-Type" "text/html"
	    nginx -s reload
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

	wps_header "Reload"
	wps_load
		
	nginx -s reload
}

# ROOT
# ---------------------------------------------------------------------------------

wps_root() { 
	
	wps_header "Logged in as \033[1;37mroot\033[0m"

	su -l root
}
