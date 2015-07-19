
# EVENTS
# ---------------------------------------------------------------------------------	

wps_events() {

	while inotifywait -e modify $events; do
	
		status="`tail -n1 $events | jq -r '.status'`"
		
		if [[  $status = 'start' || $status = 'die'  ]];
		then wps_reload &
		fi
		
	done	
}
