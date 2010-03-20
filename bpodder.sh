#!/bin/bash
clear

OPTIONS="Download Skip Abort"
db="podcast.log"
podsdir=~/Podcasts

mkdir -p "$podsdir"

for podcast in $(cat rss.conf)
do
    for url in $(curl $podcast | uniq --unique | xsltproc rss.xsl -)
    do
        if ! grep $url $db 2> /dev/null
        then
            echo "Select action for $url "
            PS3="action?"
            select opt in $OPTIONS
            do
                case $REPLY in
                    1) echo "Downloading $url ..."
                    poddir=$(echo $podcast | sed 's/\/.*//')
                    mkdir -p "$podsdir/$poddir"
                    cd "$podsdir/$poddir"
                    wget -c "$url"
                    echo $url >> $db;;
                    2) echo "Skipping $url ..."; echo $url >> $db;;
                    3) echo "Exiting program..."; exit;;
                    *) echo "Bad option";;
                esac
            done
        fi
    done
done
