
if [ $# -ne 1 ]; then
    echo "USAGE: mk_release.sh <release-tag>"
    exit 1
fi

#TAG="0.3.0beta4"
TAG=`echo $1 | sed 's/^\([^v]\)/v\1/'`
shorttag=$TAG
longtag=$shorttag

createReleaseTag() {
    echo ""
    echo "(1) COMMANDS FOR RELEASE TAGS - COPY AND RUN!"
    GOHOME="$HOME/go/src/github.com/stts-se"
    GITHOME="$HOME/git_repos"
    
    declare -a repos=("$GOHOME/pronlex" "$GITHOME/wikispeech_mockup" "$GITHOME/wikispeech_compose" "$GITHOME/marytts" "$GITHOME/ws-lexdata")
    
    tagcmd="git tag -a $shorttag -m \"$longtag\""
    pushcmd="git push origin $shorttag"

    for repo in "${repos[@]}"; do
	cmd="cd $repo && $tagcmd && $pushcmd"
	if [ $repo != ${repos[-1]} ]; then
	    cmd="$cmd && "
	fi
	echo "    $cmd"
    done
    echo ""
}

buildDockerImages() {
    cache="--no-cache"
    #cache=""
    echo "(2) COMMANDS FOR GENERATING AND PUBLISHING DOCKER IMAGES"
    
    echo "    cd ~/git_repos/wikispeech_compose/docker/wikispeech_base &&
    docker build $cache . -t sttsse/wikispeech_base &&
    docker build $cache . -t sttsse/wikispeech_base:$shorttag &&
    
    cd ~/git_repos/marytts &&
    docker build $cache . -t sttsse/marytts:$shorttag &&
    
    cd ~/git_repos/wikispeech_mockup && 
    docker build $cache . -t sttsse/wikispeech:$shorttag &&
    
    cd ~/go/src/github.com/stts-se/pronlex/ &&
    docker build $cache . -t sttsse/pronlex:$shorttag

    ### PAUSE ###
    
    docker push sttsse/wikispeech_base &&
    docker push sttsse/wikispeech_base:$shorttag &&
    docker push sttsse/marytts:$shorttag &&
    docker push sttsse/wikispeech:$shorttag &&
    docker push sttsse/pronlex:$shorttag"

    echo "" && echo ""
}

echo "RELEASE TAG: $TAG"

createReleaseTag
buildDockerImages

echo "(3) CREATE RELEASE NOTES"
echo " >> Add release notes to stts-se.github.io/wikispeech/release_notes.html"
echo ""

echo "(4) LINK RELEASE NOTES: Link release notes for all five repos on github.com"
echo " >> http://stts-se.github.io/wikispeech/release_notes.html#v$TAG"
echo ""

echo "(5) RESTART MORF SERVERS"
echo " >> Restart, retrieve docker updates and make sure all servers start without errors"
echo ""
