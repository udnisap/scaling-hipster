#!/bin/bash
OPTIONS="Deploy Run"



# run (uri, parameters) 
function run {
	URI=$1
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
	echo "deploy script"	
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



