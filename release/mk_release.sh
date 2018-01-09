TAG="0.3.0beta2"

GOHOME="$HOME/go/src/github.com/stts-se"
GITHOME="$HOME/git_repos"

declare -a repos=("$GOHOME/pronlex" "$GITHOME/wikispeech_mockup" "$GITHOME/wikispeech_compose" "$GITHOME/marytts" "$GITHOME/ws-lexdata")

shorttag="v$TAG"
longtag="version $TAG"
cmd="git tag -a \"$shorttag\" -m \"$longtag\""

echo $cmd

for repo in "${repos[@]}"; do
    echo $repo
    echo $cmd
    cd $repo
    pwd
    # exec $cmd
    # git push origin $shorttag
done

