
# BUILD
# ---------------------------------------------------------------------------------	

wps_build() {

	wps_header "Building image"

	echo "http://nl.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories
	echo "http://nl.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories
		
	apk add --update \
	bash curl jq nano s6 sudo \
	netcat-openbsd \
	inotify-tools \
	nginx-naxsi \
	openssl
	
	rm -rf /var/cache/apk/*
	rm -rf /var/lib/apt/lists/*
	
	cat /wps/etc/nginx.conf > /etc/nginx/nginx.conf
	mkdir -p /tmp/nginx/client-body
	mkdir -p /etc/nginx/conf.d
	
# 	sed -i 's|#!/bin/sh|#!/bin/bash|g' /wps/wps.sh
	ln -sf /wps/wps.sh /usr/bin/wps
	chmod +x /usr/bin/wps

	wps_header "Done!"
}
