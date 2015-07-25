
# BUILD
# ---------------------------------------------------------------------------------	

wps_build() {

	wps_header "Building image"

	echo "http://nl.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories
	echo "http://nl.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories
		
	apk add --update \
	bash curl jq nano s6 \
	netcat-openbsd \
	inotify-tools \
	nginx-naxsi
	
	rm -rf /var/cache/apk/*
	rm -rf /var/lib/apt/lists/*
	
	cat /wps/etc/nginx.conf > /etc/nginx/nginx.conf
	ln -sf /dev/stdout /var/log/nginx/access.log
	ln -sf /dev/stderr /var/log/nginx/error.log
	mkdir -p /tmp/nginx/client-body
	mkdir -p /etc/nginx/conf.d
	
	sed -i 's|#!/bin/sh|#!/bin/bash|g' /wps/wps.sh
	ln -sf /wps/wps.sh /usr/bin/wps
	chmod +x /usr/bin/wps

	wps_header "Done!"
}
