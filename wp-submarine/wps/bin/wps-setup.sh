
# SETUP
# -----------------------------------------------------------------------------

wps_setup() {

	wps_domain
	wps_env
	wps_ssl
	wps_mysql
	wps_chmod

	wps_header "Installing WordPress"
	
	su -l $user -c "git clone $WP_REPO $www" && wps_wp_version
	su -l $user -c "cd $www && composer install"
	ln -s $home/.env $www/.env
	
	wps_wp_install		

	# fix "The mysql extension is deprecated"
	sed -i "s/define('WP_DEBUG'.*/define('WP_DEBUG', false);/g" $www/config/environments/development.php
}
