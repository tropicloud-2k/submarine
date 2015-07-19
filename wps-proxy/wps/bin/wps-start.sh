
# START
# ---------------------------------------------------------------------------------

wps_start() { 

	wps_header "Start"
	wps_reload
	wps_mount

	exec s6-svscan $run
}
