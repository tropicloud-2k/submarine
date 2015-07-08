
# ERROR
# ---------------------------------------------------------------------------------

wps_error_header() {
	echo -e "\033[0;30m
-----------------------------------------------------
\033[1;31m  Error $T1\033[0m -\033[1;37m $T2\033[0;30m
-----------------------------------------------------"
}

wps_error() {

	if [[  $1 == '401'  ]]; then
	
		T1='401'
		T2='WP_DOMAIN not found'
		
		wps_error_header && echo -e "\033[0m
The environment variable WP_DOMAIN do not exists.
Pleae define WP_DOMAIN in your 'docker run' command.

Ex: docker run -p 80:80 -e WP_DOMAIN=\"example.com\" -d tropicloud/submarine
\033[0m"
	fi












echo -e "Aborting...\n"
exit 1;
}