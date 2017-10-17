CMD=`basename $0`

if [ $# -eq 0 ]; then
    echo "Usage:" 2>&1
    echo "  $ $CMD <container-name(s)> - remove named containers (matching substrings)" 2>&1
    echo "  $ $CMD all - removed all containers" 2>&1
    echo "  $ $CMD l(ist) - list containers" 2>&1
    echo "  $ $CMD i(d) - list container ids" 2>&1
    echo "  $ $CMD n(ames) - list container names" 2>&1
    exit 0
elif [ $# -eq 1 ] && [ \( $1 == "list" \) -o \( $1 == "l" \) ]; then
    echo "[$CMD] Available containers:" 2>&1
    docker ps -a 2>&1
elif [ $# -eq 1 ] && [ \( $1 == "ids" \) -o  \( $1 == "id" \) -o \( $1 == "i" \) ]; then
    docker ps -a | sed 's/   */\t/'g | cut -f1 | egrep -v "^CONTAINER ID$" 2>&1
elif [ $# -eq 1 ] && [ \( $1 == "names" \) -o \( $1 == "n" \) ]; then
    docker ps -a | sed 's/   */\t/'g | cut -f7 | egrep -v "^NAMES$" 2>&1
else
    for arg in $* ; do
	if [ "$arg" == "all" ]; then
	    nFound=`docker ps -a |egrep -c "^CONTAINER ID"`
	    if [ $nFound -eq 0 ]; then
		echo "[$CMD] No containers available for removal!" 2>&1
		exit 1    
	    fi
	    found=`docker ps -a | sed 's/   */\t/'g | cut -f1,2,6 | egrep -v "CONTAINER ID" | sed 's/\t/\//g'`
	    for match in $found ; do
		cid=`echo $match | cut -f1 -d /`
		echo "[$CMD] Stopping and removing $match ... "
		if docker stop $cid && docker rm $cid ; then		
		    echo "[$CMD] $match removed "
		else
		    echo "[$CMD] Couldn't stop&remove $match " 2>&1
		    exit 1
		fi
	    done
	else
	    nFound=`docker ps -a | egrep -c "$arg"`
	    if [ $nFound -eq 0 ]; then
		echo "[$CMD] Found no containers matching '$arg'" 2>&1
		#echo "[$CMD] Available containers:" 2>&1
		#docker ps -a 2>&1
		exit 1    
	    fi
	    found=`docker ps -a | sed 's/   */\t/'g | cut -f1,2,6 | egrep "$arg" | sed 's/\t/\//g'`
	    for match in $found ; do
		cid=`echo $match | cut -f1 -d /`
		echo "[$CMD] Stopping and removing $match ... "
		if docker stop $cid && docker rm $cid ; then		
		    echo "[$CMD] $match removed "
		else
		    echo "[$CMD] Couldn't stop&remove $match " 2>&1
		    exit 1
		fi
	    done
	fi
    done
fi
