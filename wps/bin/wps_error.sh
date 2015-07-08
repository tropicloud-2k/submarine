
# ERROR
# ---------------------------------------------------------------------------------

wps_error() {

	if [[  $1 == '401'  ]];
	then wps_header "\033[1;31m[Error 401]:\033[0m Empty domain name" "
The environment variable WP_DOMAIN do not exists.
Pleae define WP_DOMAIN in your 'docker run' command.

Ex: docker run -p 80:80 -e WP_DOMAIN=\"example.com\" -d tropicloud/submarine

Aborting...
";  fi

exit 1;
}