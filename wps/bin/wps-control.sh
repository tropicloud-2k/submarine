
# START
# ---------------------------------------------------------------------------------

np_start() { np_env && exec /usr/bin/s6-svscan $conf/s6; }

wps_start() { 

	wps_check
	wps_header "Starting $PROG"
	wps_links && echo ""
	
# 	if [[  -z $2  ]];
# 	then PROG="all"
# 	else PROG="$2"
# 	fi
# 	
# 	if [[  -f /tmp/supervisord.pid  ]];
# 	then wps_chmod && supervisorctl -u $user -p $WPS_PASS -c $WPS_CTL start $PROG
# 	else wps_chmod && exec supervisord -n -c $WPS_CTL
# 	fi

	wps_chmod && exec /usr/bin/s6-svscan $conf/s6;
}

# STOP
# ---------------------------------------------------------------------------------

wps_stop() { 
	
	wps_header "Stopping $PROG"

	if [[  -z $2  ]];
	then PROG="all"
	else PROG="$2"
	fi
	
	if [[  -f /tmp/supervisord.pid  ]];
	then supervisorctl -u $user -p $WPS_PASS -c $WPS_CTL stop $PROG		
	fi
	echo ""
}


# RESTART
# ---------------------------------------------------------------------------------

wps_restart() { 
	
	wps_header "Restarting $PROG"

	if [[  -z $2  ]];
	then PROG="all"
	else PROG="$2"
	fi
	
	if [[  -f /tmp/supervisord.pid  ]]; 
	then wps_chmod && supervisorctl -u $user -p $WPS_PASS -c $WPS_CTL restart $PROG
	else wps_chmod && exec supervisord -n -c $WPS_CTL
	fi
	echo ""
}


# RELOAD
# ---------------------------------------------------------------------------------

wps_reload() { 
	
	wps_header "Reloading supervisord"

	if [[  -f /tmp/supervisord.pid  ]];
	then supervisorctl -u $user -p $WPS_PASS -c $WPS_CTL reload
	fi
	echo ""
}


# SHUTDOWN
# ---------------------------------------------------------------------------------

wps_shutdown() { 
	
	wps_header "Shutting down!"

	if [[  -f /tmp/supervisord.pid  ]];
	then supervisorctl -u $user -p $WPS_PASS -c $WPS_CTL shutdown
	fi
	echo ""
}


# STATUS
# ---------------------------------------------------------------------------------

wps_status() { 
	
	wps_header "Status"

	if [[  -z $2  ]];
	then PROG="all"
	else PROG="$2"
	fi
	
	if [[  -f /tmp/supervisord.pid  ]];
	then supervisorctl -u $user -p $WPS_PASS -c $WPS_CTL status $PROG
	fi
	echo ""
}


# LOG
# ---------------------------------------------------------------------------------

wps_log() { 
	
	wps_header "Log"
	
	if [[  -f /tmp/supervisord.pid  ]];
	then supervisorctl -u $user -p $WPS_PASS -c $WPS_CTL maintail
	fi
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
