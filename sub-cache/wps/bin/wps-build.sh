
# BUILD
# ---------------------------------------------------------------------------------	

wps_build() {

	wps_header "Building image"

	echo "vm.overcommit_memory = 1" >> /etc/sysctl.conf
	echo "http://nl.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories
	echo "http://nl.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories
		
	apk add --update \
	libmemcached \
	memcached \
	redis \
	s6
	
	rm -rf /var/cache/apk/*
	rm -rf /var/lib/apt/lists/*
	
	cat /wps/etc/memcached.conf > /etc/conf.d/memcached
	cat /wps/etc/redis.conf > /etc/conf.d/redis
	
	mkdir /data
	
	ln -sf /wps/wps.sh /usr/bin/wps
	chmod +x /usr/bin/wps

	wps_header "Done!"
}
