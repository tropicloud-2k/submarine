
# START
# ---------------------------------------------------------------------------------

wps_start() { 

	wps_check
	wps_header "Start"
	wps_links
	wps_chmod
	wps_mount

	exec s6-svscan /wps/run
}

# RESTART
# ---------------------------------------------------------------------------------

wps_restart() { 
	
	wps_header "Restart"
	
	nginx -t -c $conf/nginx/nginx.conf
	echo -ne "\nRestarting..."

	sudo kill $(echo `pgrep 'master'`)
	sudo kill $(echo `pgrep 'supervise'`)
	sleep 1
	
	echo -ne " done!\n`pgrep -l 'master'`"
	echo -e "`pgrep -l 'master'`\n"
}

# STOP
# ---------------------------------------------------------------------------------

wps_stop() { 
	
	wps_header "Stop"

	exec s6-svscanctl -q /wps/run
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
	
	wps_header "Processes"

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
