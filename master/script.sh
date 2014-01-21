#!/bin/bash
OPTIONS="Deploy Run"



# run (uri, parameters) 
function run {
	URI=$1"?method=run"
	params=$2
	if [ -z "$params" ]; then 
		echo Running $URI
		curl $URI
	else
		echo Running $URI with $params
	 	curl $URI -d $params
	fi

}


function deploy {
	file_name =$1
	URL = $2"?method=deploy"
	echo "deploy script"
	curl -T $file_name $URL	
}

#status URI
function status {
	URI=$1"?method=status"
	if [ -z "$URI" ]; then 
		echo Enter host name
		exit
	else
		response=$(curl -s $URI 2>&1);
		#echo $response
	fi
}

function init {
	echo Welcome to Scaling-Hipster!
	echo Select an option below
	select opt in $OPTIONS; do
	    if [ "$opt" = "Deploy" ]; then
	     echo This will deploy tar files to a target server
	     deploy
	    elif [ "$opt" = "Run" ]; then
	     echo This will run a script file on a target server
	     run
	    else
	     echo bad option
	    fi
	done
}



if [ -z "$1" ]; then 
      echo Enter Either run or deploy
      exit
fi

if [ "$1" = "run" ]; then
	run $2 $3		
fi



