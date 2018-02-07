TAG="0.3.0beta4"

createReleaseTag() {
    echo ""
    echo "(1) COMMANDS FOR RELEASE TAGS - COPY AND RUN!"
    GOHOME="$HOME/go/src/github.com/stts-se"
    GITHOME="$HOME/git_repos"
    
    declare -a repos=("$GOHOME/pronlex" "$GITHOME/wikispeech_mockup" "$GITHOME/wikispeech_compose" "$GITHOME/marytts" "$GITHOME/ws-lexdata")
    
    shorttag="v$TAG"
    longtag="version $TAG"
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
    #cache="--no-cache"
    cache=""
    echo "(2) COMMANDS FOR GENERATING AND PUBLISHING DOCKER IMAGES"
    
    echo "    cd ~/git_repos/wikispeech_compose/docker/wikispeech_base &&
    docker build $cache . -t sttsse/wikispeech_base &&
    docker build $cache . -t sttsse/wikispeech_base:version-$TAG &&
    
    cd ~/git_repos/marytts &&
    docker build $cache . -t sttsse/marytts:version-$TAG &&
    
    cd ~/git_repos/wikispeech_mockup && 
    docker build $cache . -t sttsse/wikispeech:version-$TAG &&
    
    cd ~/go/src/github.com/stts-se/pronlex/ &&
    docker build $cache . -t sttsse/pronlex:version-$TAG

    ### PAUSE ###
    
    docker push sttsse/wikispeech_base &&
    docker push sttsse/wikispeech_base:version-$TAG &&
    docker push sttsse/marytts:version-$TAG &&
    docker push sttsse/wikispeech:version-$TAG &&
    docker push sttsse/pronlex:version-$TAG"

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
