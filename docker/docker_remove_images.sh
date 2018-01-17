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
    echo "  $ $CMD <image-name(s)> - remove named images (matching substrings)" 2>&1
    echo "  $ $CMD all - remove all images" 2>&1
    echo "  $ $CMD l(ist) - list images" 2>&1
    echo "  $ $CMD i(d) - list image ids" 2>&1
    echo "  $ $CMD n(ames) - list image names" 2>&1
    echo "" 2>&1
    echo "Optional switches:" 2>&1
    echo " -a Show all images (default hides intermediate images)" 2>&1
    exit 0
elif [ $# -eq 1 ] && [ \( $1 == "list" \) -o \( $1 == "l" \) ]; then
    echo "[$CMD] Available images:" 2>&1
    docker images "$SWITCHES" 2>&1
elif [ $# -eq 1 ] && [ \( $1 == "ids" \) -o  \( $1 == "id" \) -o \( $1 == "i" \) ]; then
    docker images "$SWITCHES" | sed 's/   */\t/'g | cut -f3 | egrep -v "^IMAGE ID$" 2>&1
elif [ $# -eq 1 ] && [ \( $1 == "names" \) -o \( $1 == "n" \) ]; then
    docker images "$SWITCHES" | sed 's/   */\t/'g | cut -f1 | egrep -v "^REPOSITORY$" 2>&1
else
    for arg in $* ; do
	if [ "$arg" == "all" ]; then
	    nFound=`docker images "$SWITCHES" |egrep -cv "^REPOSITORY"`
	    if [ $nFound -eq 0 ]; then
		echo "[$CMD] No images available for removal!" 2>&1
		exit 1    
	    fi
	    found=`docker images "$SWITCHES" | sed 's/   */\t/'g | cut -f1,2,3 | egrep -v "REPOSITORY" | sed 's/\t/%/g'`
	    for match in $found ; do
		id=`echo $match | cut -f3 -d %`
		pretty=`echo $match | sed 's/%/\//g'`
		echo "[$CMD] Stopping and removing $pretty ... "
		if docker rmi $id; then		
		    echo "[$CMD] $match removed "
		else
		    echo "[$CMD] Couldn't stop&remove $pretty " 2>&1
		    exit 1
		fi
	    done
	elif [ ${#arg} -lt 4 ]; then
	    echo "[$CMD] Container name/substring needs be specified with three or more characters"
	    exit 1
	else    
	    nFound=`docker images "$SWITCHES" | egrep -c "$arg"`
	    if [ $nFound -eq 0 ]; then
		echo "[$CMD] Found no images '$arg'" 2>&1
		#echo "[$CMD] Available images:" 2>&1
		#docker images "$SWITCHES" 2>&1
		exit 1    
	    fi
	    found=`docker images "$SWITCHES" | sed 's/   */\t/'g | cut -f1,2,3 | egrep "$arg" | sed 's/\t/%/g'`
	    for match in $found ; do
		id=`echo $match | cut -f3 -d %`
		pretty=`echo $match | sed 's/%/\//g'`
		echo "[$CMD] Stopping and removing $pretty ... "
		if docker rmi $id ; then		
		    echo "[$CMD] $match removed "
		else
		    echo "[$CMD] Couldn't stop&remove $pretty " 2>&1
		    exit 1
		fi
	    done
	fi
    done
fi
