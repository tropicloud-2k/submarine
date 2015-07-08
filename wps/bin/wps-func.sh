
# HEADER
# ---------------------------------------------------------------------------------

wps_header() {
	echo -e "\033[0;30m
-----------------------------------------------------
\033[0;34m  Submarine\033[0;37m - $1\033[0;30m
-----------------------------------------------------"
	if [[ -n $2  ]];
	then echo -e "\033[0m$2\n"
	else echo -e "\033[0m"
	fi
}

# CHECK
# ---------------------------------------------------------------------------------

wps_check() {
  	if [[  -d $www  ]];
  	then /bin/true
  	else wps_domain && wps_setup
  	fi
}

wps_domain() {
	if [[  -z $WP_DOMAIN  ]];
	then wps_error '401'
  	else /bin/true
	fi
}

# ADMINER
# ---------------------------------------------------------------------------------

wps_adminer() { 

	wps_header "Adminer (mysql admin)"

	echo -e "  Password: \033[0;37m$DB_PASSWORD\033[0m\n"
	php -S 0.0.0.0:8888 -t /usr/local/adminer
}

# CHMOD
# ---------------------------------------------------------------------------------

wps_chmod() { 

	sudo chown -R $user:nginx $home
	
	sudo find $home -type f -exec chmod 644 {} \;
	sudo find $home -type d -exec chmod 755 {} \;
}

# MOUNT
# ---------------------------------------------------------------------------------

wps_mount() { 

	sudo ln -sf /dev/stdout /var/log/nginx/access.log
	sudo ln -sf /dev/stderr /var/log/nginx/error.log
	
	sudo rm -rf /wps/run
	sudo cp -R $conf/s6 /wps/run

	if [[  ! $WP_SQL == 'local'  ]];
	then sudo rm -rf /wps/run/mysql
	fi
	
	sudo find /wps/run -type f -exec chmod +x {} \;
}

# LINKS
# ---------------------------------------------------------------------------------

wps_links() {

	if [[  ! $WPS_MYSQL == '127.0.0.1:3306'  ]];
	then echo -e "\033[1;32m  •\033[0;37m MySQL\033[0m -> $WPS_MYSQL"
	else echo -e "\033[1;33m  •\033[0;37m MySQL\033[0m -> $WPS_MYSQL (localhost)"
	fi	
	
	if [[  ! -z $WPS_REDIS  ]];
	then echo -e "\033[1;32m  •\033[0;37m Redis\033[0m -> $WPS_REDIS"		
	else echo -e "\033[1;31m  •\033[0;37m Redis\033[0m [not connected]"
	fi		
	
	if [[  ! -z $WPS_MEMCACHED  ]];
	then echo -e "\033[1;32m  •\033[0;37m Memcached\033[0m -> $WPS_MEMCACHED"
	else echo -e "\033[1;31m  •\033[0;37m Memcached\033[0m [not connected]"
	fi
	echo ""
}
