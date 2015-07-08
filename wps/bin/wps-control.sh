
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

	exec s6-svscanctl -t /wps/run	
}

# RESTART
# ---------------------------------------------------------------------------------

wps_restart() { 
	
	wps_header "Restarting $2"
	
	exec s6-svc -t /wps/run/$2
}

# RELOAD
# ---------------------------------------------------------------------------------

wps_reload() { 
	
	wps_header "Reloading $2"

	exec s6-svc -h /wps/run/$2
}

# STATUS
# ---------------------------------------------------------------------------------

wps_status() { 
	
	wps_header "$2 status"
	
	exec s6-svstat -n /wps/run/$2
}

# PS
# ---------------------------------------------------------------------------------

wps_ps() { 
	
	wps_header "Container processes"

	ps auxf && echo ""
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
