
# SSL
# ---------------------------------------------------------------------------------

wps_ssl() {

	DOMAIN="$2"

	wps_header "Creating SSL cert."

	ln -sf $conf/nginx/https.conf $conf/nginx/conf.d

	cd $conf/ssl
	
	if [[  ! -f $conf/ssl/${DOMAIN}.crt  ]]; then
	
		cat $conf/nginx/openssl.conf | sed -e "s/example.com/$DOMAIN/g" > openssl.conf
		openssl req -nodes -sha256 -newkey rsa:2048 -keyout $DOMAIN.key -out $DOMAIN.csr -config openssl.conf -batch
		openssl rsa -in $DOMAIN.key -out $DOMAIN.key
		openssl x509 -req -days 365 -sha256 -in $DOMAIN.csr -signkey $DOMAIN.key -out $DOMAIN.crt	
		rm -f openssl.conf

	else echo -e "Certificate already exists.\nSkipping..."
	fi
}
