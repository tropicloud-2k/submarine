
# BUILD
# ---------------------------------------------------------------------------------

wps_build() {

	wps_header "Building image"

	echo "@edge http://nl.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories
	echo "@testing http://nl.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories

	apk add --update bash curl git nano sudo zip \
		libmemcached \
		mariadb-client \
		msmtp \
		nginx-naxsi@testing \
		openssl \
		php-cli \
		php-curl \
		php-ctype \
		php-dom \
		php-fpm \
		php-gd \
		php-gettext \
		php-iconv \
		php-json \
		php-mcrypt \
		php-memcache \
		php-mysql \
		php-opcache \
		php-openssl \
		php-phar \
		php-pear \
		php-pdo \
		php-pdo_mysql \
		php-pdo_pgsql \
		php-pdo_sqlite \
		php-soap \
		php-xml \
		php-zlib \
		php-zip \
		s6@edge

	rm -rf /var/cache/apk/*
	rm -rf /var/lib/apt/lists/*

	# ADMINER
	mkdir -p /usr/local/adminer
	curl -sL http://www.adminer.org/latest-en.php > /usr/local/adminer/index.php

	# COMPOSER
	curl -sS https://getcomposer.org/installer | php
	mv composer.phar /usr/local/bin/composer

	# MSMTP
	cat /wps/usr/.msmtprc > /etc/msmtprc
	echo "sendmail_path = /usr/bin/msmtp -t" > /etc/php/conf.d/sendmail.ini

	# PREDIS
	pear channel-discover pear.nrk.io
	pear install nrk/Predis

	# WP-CLI
	curl -sL https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar > /usr/local/bin/wp
	chmod +x /usr/local/bin/wp

	# WP-SUBMARINE
	adduser -D -G nginx -s /bin/sh -u 1000 -h $home $user
	echo "$user ALL = NOPASSWD : ALL" >> /etc/sudoers

	cat /wps/usr/.profile > /root/.profile
	echo "export HOME=/root" >> /root/.profile

	ln -s /wps/wps.sh /usr/bin/wps
	chmod +x /usr/bin/wps

	wps_header "Done!"
}
