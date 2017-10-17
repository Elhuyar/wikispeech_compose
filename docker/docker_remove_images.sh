CMD=`basename $0`

if [ $# -eq 0 ]; then
    echo "Usage:" 2>&1
    echo "  $ $CMD <image-name(s)> - remove named images (matching substrings)" 2>&1
    echo "  $ $CMD l(ist) - list images" 2>&1
    echo "  $ $CMD i(d) - list image ids" 2>&1
    echo "  $ $CMD n(ames) - list image names" 2>&1
    exit 0
elif [ $# -eq 1 ] && [ \( $1 == "list" \) -o \( $1 == "l" \) ]; then
    echo "[$CMD] Available images:" 2>&1
    docker images 2>&1
elif [ $# -eq 1 ] && [ \( $1 == "ids" \) -o  \( $1 == "id" \) -o \( $1 == "i" \) ]; then
    docker images | sed 's/   */\t/'g | cut -f3 | egrep -v "^IMAGE ID$" 2>&1
elif [ $# -eq 1 ] && [ \( $1 == "names" \) -o \( $1 == "n" \) ]; then
    docker images | sed 's/   */\t/'g | cut -f1 | egrep -v "^REPOSITORY$" 2>&1
else 
    for arg in $* ; do
	if [ ${#arg} -lt 4 ]; then
	    echo "[$CMD] Image name/substring needs be specified with three or more characters"
	    exit 1
	else    
	    nFound=`docker images | egrep -c "$arg"`
	    if [ $nFound -eq 0 ]; then
		echo "[$CMD] Found no images '$arg'" 2>&1
		#echo "[$CMD] Available images:" 2>&1
		#docker images 2>&1
		exit 1    
	    fi
	    found=`docker images | sed 's/   */\t/'g | cut -f1,2,3 | egrep "$arg" | sed 's/\t/%/g'`
	    for match in $found ; do
		id=`echo $match | cut -f3 -d %`
		pretty=`echo $match | sed 's/%/\//g'`
		echo "[$CMD] Stopping and removing $match ... "
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
