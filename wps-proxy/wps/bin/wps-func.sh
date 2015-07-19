
# HEADER
# ---------------------------------------------------------------------------------

wps_header() {
	echo -e "\033[0;30m
-----------------------------------------------------
\033[0;34m  Submarine\033[0;37m - $1\033[0;30m
-----------------------------------------------------
\033[0m"
}

# MOUNT
# ---------------------------------------------------------------------------------

wps_mount() { 

	ln -sf /dev/stdout /var/log/nginx/access.log
	ln -sf /dev/stderr /var/log/nginx/error.log
	
	mkdir -p /tmp/nginx/client-body
	mkdir -p /etc/nginx/conf.d
	touch /tmp/nginx.pid
	
	
	find $run -type f -exec chmod +x {} \;
}
