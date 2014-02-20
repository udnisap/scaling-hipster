#!/bin/bash
source config.cfg

declare -A NODE_LIST
declare -A TOTAL_MEM
declare -A USED_MEME
declare -A FREE_MEM

declare -A USER_CPU
declare -A SYSTEM_CPU

declare -A SCORE

declare mem_multiplyer=1
declare cpu_multiplyer=1000

#update the server details
function update {
	#get the server list
	i=0
	while read line
	do
		NODE_LIST[$i]=$line
		((i++))
	done <servers.list
	
	j=0
	for node in "${NODE_LIST[@]}"
	do
		#echo $node
		status $node $j
		((j++))
	done
}

function select_node {
	update		#get the updates of servers
	
	id=0
	max_score=0
	
	for (( i = 0; i < ${#NODE_LIST[@]}; i++ ));
	do
		score_mem=$((${FREE_MEM[$i]} * $mem_multiplyer))
		score_cpu=$(((100 - ${SYSTEM_CPU[$i]}) * $cpu_multiplyer))
		
		SCORE[$i]=$(($score_mem + $score_cpu))
		
		if [ ${SCORE[$i]} -gt $max_score ] ; then
			max_score=${SCORE[$i]}
			id=$i
		fi
	done
	
	echo ${NODE_LIST[$id]}
	
}

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

#create(type,name)
function create {
	typed=$1
	name=$2
	if [ -z "$typed" ]; then 
		echo please give Paas e.g heroku, openshift
		
	elif [ -z "$name" ]; then
		echo please give application name
        
        elif [ "$typed" = "openshift" ]; then
                 rhc setup
		 rhc app create -a $name -t php-5.3 
                 cd $name
                 git remote add upstream -m master $openShiftGitRepo
                 git pull -s recursive -X theirs upstream master
                 git push
                 cd ..
                 response=$(rhc app-show $name)
                 javac AppInfoParser.java
                 openShiftNewAppURL=$(java AppInfoParser "$response" openshift appurl)
                 OpenShiftNewAppGitRepo=$(java AppInfoParser "$response" openshift gitrepo)
                 echo URL of App: $openShiftNewAppURL
                 echo Git Repo :$OpenShiftNewAppGitRepo
        elif [ "$typed" = "heroku" ]; then
 
                 git clone $herokuGitRepo
                 cd $herokuAppFolder
                 heroku create $name
                 git push heroku master 
                 responseheroku=$(heroku apps:info)
                 cd ..
                 javac AppInfoParser.java
                 herokuNewAppURL=$(java AppInfoParser "$responseheroku" heroku appurl)
                 herokuNewGitRepo=$(java AppInfoParser "$responseheroku" heroku gitrepo)
                 echo URL of App: $herokuNewAppURL
                 echo Git Repo :$herokuNewGitRepo
                # heroku open
       
        else
            echo cannot create  
             getAppData
        fi
}

#getAppData(appname,apptype,type)
function getAppData {
  response=$(rhc app-show testingapp)
  javac AppInfoParser.java
  java AppInfoParser "$response" openshift gitrepo	
 # echo $response			
}



# delete (type, name)
function delete {
    delapptype=$1
    delapp=$2
    if [ -z "$delapptype" ]; then 
		echo please give paas 
     elif [ -z "$delapp" ]; then
                echo please give app name
     elif [ "$delapptype" = "openshift" ]; then
          
          rhc app delete $delapp
          rm -rf $delapp
          echo successfully deleted $delapp
      elif [ "$delapptype" = "heroku" ]; then
          
          heroku apps:delete $delapp --confirm $delapp
          rm -rf $herokuAppFolder
          echo successfully deleted $delapp
     else
          echo cannot delete
     fi
				
}


# read Password
function readpassword {
    echo $(sed -n 's/.*password *= *\([^ ]*.*\)/\1/p' < parameters.ini)
}

# read UserName
function readusername {
    echo $(sed -n 's/.*username *= *\([^ ]*.*\)/\1/p' < parameters.ini)
}


function deploy {
	file_name=$1
	if [ -z "$2" ]; then
		local URL=$(select_node)"?method=deploy"
		echo $URL
	else
		local URL=$2"?method=deploy"
	fi

	echo "deploy script"
	#curl -T $file_name $URL	
	curl -F file=@$file_name $URL
}

#status URI index
function status {

	index=$2

	URI=$1"?method=status"
	if [ -z "$URI" ]; then 
		echo Enter host name
		exit
	else
		response=$(curl -s $URI 2>&1);
		
		readarray -t y <<<"$response"
		
		cpu=${y[2]}
		mem=${y[3]}
					
		IFS=':' read -a mem_arr <<< "$mem"
		IFS=':' read -a cpu_arr <<< "$cpu"

		cpu_temp=${cpu_arr[1]}
		mem_temp=${mem_arr[1]}
		
		IFS=',' read -a mem_vals <<< "$mem_temp"
		IFS=',' read -a cpu_vals <<< "$cpu_temp"
		
		for (( i = 0; i < ${#mem_vals[@]}; i++ ));
		do
			IFS=' ' read -a temp <<< "${mem_vals[$i]}"
			mem_final[$i]=${temp[0]%?}
		done
		
		mem_total=${mem_final[0]}
		mem_used=${mem_final[1]}
		mem_free=${mem_final[2]}
		
		for (( i = 0; i < ${#cpu_vals[@]}; i++ ));
		do
			IFS=' ' read -a temp <<< "${cpu_vals[$i]}"
			cpu_final[$i]=${temp[0]:0:-5}
		done
	
		cpu_user=${cpu_final[0]}		
		cpu_system=${cpu_final[1]}
		cpu_nice=${cpu_final[2]}
		cpu_io_wait=${cpu_final[4]}
		
		if [ -z "$index" ]; then 
			echo $response
		else
			#add memory details to the global variables
			TOTAL_MEM[$index]=$mem_total
			USED_MEME[$index]=$mem_used
			FREE_MEM[$index]=$mem_free
			#add cpu details to the global variables
			USER_CPU[$index]=$cpu_user
			SYSTEM_CPU[$index]=$cpu_system
		fi
		
		#echo Total memory	: $mem_total
		#echo Memory used	: $mem_used
		#echo Free memory	: $mem_free
		#echo CPU user		: $cpu_user
		#echo CPU system		: $cpu_system
		#echo CPU nice		: $cpu_nice
		#echo CPU IO wait	: $cpu_io_wait
		echo $response	
	fi
}

function init {
	echo Welcome to Scaling-Hipster!
		
	#select option "Deploy" or "Run"
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
else
  if [ "$1" = "delete" ]; then
	delete $2 $3
  else 
   if [ "$1" = "deploy" ]; then
        deploy $2 $3
    fi
   if [ "$1" = "create" ]; then
        create $2 $3
    fi
   if [ "$1" = "status" ]; then
        status $2 $3
    fi
    if [ "$1" = "update" ]; then
        update
    fi
    if [ "$1" = "select_node" ]; then
        select_node
    fi
  fi
 fi
 


