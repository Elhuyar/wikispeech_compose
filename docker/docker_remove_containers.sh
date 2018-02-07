#!/bash

CMD=`basename $0`

SWITCHES=""
ERR=0

while getopts "a" opt; do
    case $opt in
    a) SWITCHES="-a" ;; # Handle -a
    \?) ERR=1 && echo "" 2>&1
    esac
done

shift $(( OPTIND - 1 ))

nDashOptions=`echo "$*" | egrep -c "(^| )-"`

if [ $nDashOptions -ne 0 ]; then
    echo "Switches should be before other arguments. Found: $*" 2>&1
    echo "" 2>&1
fi

if [ $ERR -eq 1 ] || [ $# -eq 0 ] || [ $nDashOptions -ne 0 ]; then
    echo "Usage:" 2>&1
    echo "  $ $CMD <container-name(s)> - remove named containers (matching substrings)" 2>&1
    echo "  $ $CMD all - remove all containers" 2>&1
    echo "  $ $CMD l(ist) - list containers" 2>&1
    echo "  $ $CMD i(d) - list container ids" 2>&1
    echo "  $ $CMD n(ames) - list container names" 2>&1
    echo "" 2>&1
    echo "Optional switches:" 2>&1
    echo " -a Show all images (default hides intermediate images)" 2>&1
    exit 0
elif [ $# -eq 1 ] && [ \( $1 == "list" \) -o \( $1 == "l" \) ]; then
    echo "[$CMD] Available containers:" 2>&1
    docker ps $SWITCHES 2>&1
elif [ $# -eq 1 ] && [ \( $1 == "ids" \) -o  \( $1 == "id" \) -o \( $1 == "i" \) ]; then
    docker ps $SWITCHES | sed 's/   */\t/'g | cut -f1 | egrep -v "^CONTAINER ID$" 2>&1
elif [ $# -eq 1 ] && [ \( $1 == "names" \) -o \( $1 == "n" \) ]; then
    docker ps $SWITCHES | sed 's/   */\t/'g | cut -f7 | egrep -v "^NAMES$" 2>&1
else
    echo $1
    for arg in $* ; do
	if [ "$arg" == "all" ]; then
	    nFound=`docker ps $SWITCHES |egrep -cv "^CONTAINER ID"`
	    if [ $nFound -eq 0 ]; then
		echo "[$CMD] No containers available for removal!" 2>&1
		exit 1    
	    fi
	    found=`docker ps $SWITCHES | sed 's/   */\t/'g | cut -f1,2,6 | egrep -v "CONTAINER ID" | sed 's/\t/\//g'`
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
	elif [ ${#arg} -lt 4 ]; then
	    echo "[$CMD] Container name/substring needs be specified with three or more characters"
	    exit 1
	else
	    nFound=`docker ps $SWITCHES | egrep -c "$arg"`
	    if [ $nFound -eq 0 ]; then
		echo "[$CMD] Found no containers matching '$arg'" 2>&1
		#echo "[$CMD] Available containers:" 2>&1
		#docker ps $SWITCHES 2>&1
		exit 1    
	    fi
	    found=`docker ps $SWITCHES | sed 's/   */\t/'g | cut -f1,2,6 | egrep "$arg" | sed 's/\t/\//g'`
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
