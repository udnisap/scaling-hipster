#!/bin/bash
OPTIONS="Deploy Run"
openShiftGitRepo="git://github.com/isururanawaka/Openshift.git"
herokuGitRepo="git://github.com/heroku/ruby-sample.git"
herokuAppFolder="ruby-sample"
openShiftNewAppURL=""
OpenShiftNewAppGitRepo=""
herokuNewAppURL=""
herokuNewGitRepo=""

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
		echo $response
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
else
  if [ "$1" = "delete" ]; then
	delete $2 $3
  else 
   if [ "$1" = "create" ]; then
        create $2 $3
    fi
   if [ "$1" = "status" ]; then
        status $2 $3
    fi
  fi
 fi
 


