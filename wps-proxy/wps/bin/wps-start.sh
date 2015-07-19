
# START
# ---------------------------------------------------------------------------------

wps_start() { 

	wps_header "Start"
	wps_reload

	exec s6-svscan $run
}
