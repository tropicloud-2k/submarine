env='/home/wordpress/.env'

if [[  -f $env  ]]; then
	
	for var in `cat $env`; do 
	
	key=`echo $var | cut -d= -f1`
	val=`echo $var | cut -d= -f2`
	
	  if [[  $key == *'-'*  ]]; then /bin/true
	elif [[  $key == *'.'*  ]]; then /bin/true
	elif [[  $key == *':'*  ]]; then /bin/true
	else export "$key"="$val"
	fi
	
	done
fi
