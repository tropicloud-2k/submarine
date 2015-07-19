
# EVENTS
# ---------------------------------------------------------------------------------	

wps_events() {

	while inotifywait -e modify /tmp/events.json; do
	
		status="`tail -n1 /tmp/events.json | jq -r '.status'`"
		
		if [[  $status = 'start' || $status = 'die'  ]];
		then wps_reload &
		fi
		
	done	
}
