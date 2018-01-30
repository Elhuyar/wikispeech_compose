ps -Af | egrep "PID|pronlex|wikispeech|marytts|mishkal" | sed 's/-cp .*//' | egrep -v "grep .E" | egrep -v "ps_wikispeech"

echo ""
ps -f -o pid -o command | egrep "pronlex|wikispeech|marytts|mishkal" | sed 's/-cp .*//' | egrep -v "grep .E" | egrep -v "ps_wikispeech" | sed 's/  */\t/g' | cut -f1 | tr '\012' ' ' | sed 's/^/ALL PIDS\t/'
echo ""
