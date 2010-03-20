#!/bin/bash
clear

OPTIONS="Download Skip SkipAll Abort"
db="podcast.log"
scriptdir=`pwd`
podsdir=~/Podcasts
xsltempl="$scriptdir/rss.xsl"
rssconf="$scriptdir/rss.conf"

mkdir -p "$podsdir"

for podcast in $( cat $rssconf )
do
    poddir=$(echo $podcast | sed 's/\/.*//')
    mkdir -p "$podsdir/$poddir"
    cd "$podsdir/$poddir"
    for url in $(curl $podcast | uniq --unique | xsltproc $xsltempl -)
    do
        if ! grep $url $db 2> /dev/null
        then
            clear
            echo "Select action for $url "
            PS3="action? "
            select opt in $OPTIONS
            do
                case $REPLY in
                    1) echo "Downloading $url ..."; wget -c "$url"; echo $url >> $db;;
                    2) echo "Skipping $url ..."; echo $url >> $db; continue 2;;
                    3) echo "Skipping all podcasts from $podcast"; break 2;;
                    4) echo "Exiting program..."; exit;;
                    *) echo "Bad option";;
                esac
                break
            done
        fi
    done
done
