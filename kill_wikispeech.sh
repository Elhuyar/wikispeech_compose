processNames="pronlex|wikispeech|marytts|mishkal"
cmd=`basename $0`

pids=`ps --sort pid -o pid -o command -A | egrep "$processNames" | sed 's/-cp .*//' | egrep -v "grep .E" | egrep -v "$cmd" | sed 's/  */\t/g' | cut -f1 | tr '\012' ' '`
nPids="`echo $pids | tr ' ' '\012' | egrep -v "^$" | wc -l`"
if [ $nPids -ne 0 ]; then
    ps -Af --sort pid | egrep "PID|$processNames" | sed 's/-cp .*//' | egrep -v "grep .E" | egrep -v "$cmd" 2>&1
    echo ""
    echo "Kill all $nPids proccesses? $pids"
    echo -n " [y/N] "
    read reply
    isYes=`echo $reply|egrep -ic "^[y]$"`
    
    if [ $isYes == 1 ]; then
	echo -n "killing processes ..." 2>&1
	kill $pids
	echo " done" 2>&1
    fi
else
    echo "no wikispeech processes running" 2>&1
fi

