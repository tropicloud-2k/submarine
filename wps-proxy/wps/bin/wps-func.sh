
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

	echo "" > /tmp/domains.json
	echo "" > /tpm/domains.txt
	
	rm -rf /etc/nginx/conf.d/*
	
	cat $etc/nginx.conf > /etc/nginx/nginx.conf
	cat $etc/default.conf > /etc/nginx/conf.d/default.conf

	ln -sf /dev/stdout /var/log/nginx/access.log
	ln -sf /dev/stderr /var/log/nginx/error.log
	
	find $run -type f -exec chmod +x {} \;
}
