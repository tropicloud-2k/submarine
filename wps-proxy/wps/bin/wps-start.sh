
# START
# ---------------------------------------------------------------------------------

wps_start() { 

	wps_header "Start"
	wps_mount
	wps_reload

	exec s6-svscan $run
}
