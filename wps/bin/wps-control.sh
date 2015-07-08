
# START
# ---------------------------------------------------------------------------------

wps_start() { 

	wps_check
	wps_header "Starting"
	wps_links
	wps_chmod
	wps_mount

	exec s6-svscan /wps/run
}

# STOP
# ---------------------------------------------------------------------------------

wps_stop() { 
	
	wps_header "Stopping"

	export WPS_RESTART="false"
	exec s6-svscanctl -t /wps/run	
}

# RESTART
# ---------------------------------------------------------------------------------

wps_restart() { 
	
	wps_header "Restarting..."
	
	export WPS_RESTART="true"
	exec s6-svscanctl -t /wps/run
}

# STATUS
# ---------------------------------------------------------------------------------

wps_status() { 
	
	wps_header "$2 status"
	
	exec s6-svstat -n /wps/run/$2
	echo ""
}

# PS
# ---------------------------------------------------------------------------------

wps_ps() { 
	
	wps_header "Container processes"

	ps auxf
	echo ""
}


# LOGIN
# ---------------------------------------------------------------------------------

wps_login() { 
	
	wps_header "Logged in as \033[1;37m$user\033[0m"

	su -l $user
}


# ROOT
# ---------------------------------------------------------------------------------

wps_root() { 
	
	wps_header "Logged in as \033[1;37mroot\033[0m"

	su -l root
}
