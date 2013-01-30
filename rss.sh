#!/opt/bin/bash
# SynoCatch - Torrent downloading by RSS (hacked by h0me5k1n)
#
# Script based on http://linc.homeunix.org:8080/scripts/bashpodder
# discussion on http://forum.synology.com/enu/viewtopic.php?f=38&t=18039

#need bash and xsltproc installed by ipkg

# UNIX timestamp concatenated with nanoseconds
T="$(date +%s)"

###CONFIGURATION PARAMETERS
## directory to put the downloaded torrents,with trailing slash
torrentdir="/volume1/watchfolder/"

# User Vars
CONFG="bc.conf"

# Debug Log (set to /dev/null to turn off)
	DEBUG="/dev/null"
#	DEBUG="/volume1/log/rss_debug.log"
	FAILURE="/dev/null"
#	FAILURE="/volume1/log/rss_fail.log"
	TIMEUSAGE="/volume1/log/rss_timeusage.csv"

# Make script crontab friendly:
cd $(dirname $0)
echo -e "\nExecuting $0 on $(date)" >> $DEBUG

# feed dump reset
# rm -f rssdata

# Read the bp.conf file and wget any url not already in the catch.log file:
while read subscription
do
	xmldata=$(/opt/bin/wget $subscription  -q -O - | gzip -c -d)
	# Parsing xml depending on where the torrent url is located inside <link> tags or as the value for the attribute enclosure
	#	xmldata=${xmldata//windows-1251/UTF-8};
#	echo "XMLDATA: $xmldata" >> $DEBUG
#	if  fgrep -iq enclosure <<< "$xmldata"
#		then
#			file=$(echo "$xmldata" | /opt/bin/xsltproc /volume1/script/parse_enclosure.xsl - 2> /dev/null)
#		else
			file=$(echo "$xmldata" | /opt/bin/xsltproc /volume1/script/parse_link.xsl - 2> /dev/null)
#	fi
	
  # Protect against the white space gotchas
   file=${file//\ /_}
   file=${file//\\/}
   file=${file//\[/}
   file=${file//\]/}
 
echo "FILE: $file" >> $DEBUG

expression="(("

# Get the series I want.
MYSERIES=$(ls /volume1/script/series)

for regex_series in $MYSERIES
	do
	expression="$expression$regex_series|"
	done
		
#trim the last pipe
expression=${expression%?}
expression="$expression).*720p.?HDTV)|(("

# Get the list of movies I want.
MYMOVIE=$(ls /volume1/script/movie_wishlist)

for regex_movie in $MYMOVIE
	do
	expression="$expression$regex_movie|"
	done

#trim the last pipe
expression=${expression%?}
expression="$expression).*1080p)"

 echo "EXPRESSION: $expression" >> $DEBUG
	 
	for url in $file
	do
	#	echo "url is $url" >> $DEBUG
		if  echo "$url" | egrep -i $expression &> /dev/null
			then
			torrent=$(sed 's/\([^#]*\)#.*/\1/' <<< "$url")
			if ! fgrep -i "$torrent" catch.log > /dev/null
				then
				# URL and Mininova fixer
#				torrent=$(echo "$torrent" | sed -e "s/mininova.org\/tor/mininova.org\/get/g")
				## parse the filename from the end of the $url variable (after the #)
				torrentname=$( echo $url | sed 's/^.*\#//' )
				# append .torrent on the end
				down=".downloaded"
				torr=".torrent"
				torrentname=$torrentname$down
				# Get the torrent, name it correctly and put it in the right directory
				# if fgrep -i $series $torrentname >> $DEBUG
					# then
					if /opt/bin/wget --connect-timeout=10 --tries=2 -qncH -O $torrentdir$torrentname$down $torrent
						then
							echo "$torrentname downloaded from $torrent" >> $DEBUG
						else
							echo "failed to get $torrentname from $torrent" >> $DEBUG
					fi
				# fi
				# Delete the torrent file if it's an empty file
				if [ -s "$torrentdir$torrentname$down" ]
					then
						NOW="$(date +%m-%d-%Y)"
						echo "$NOW - $url" >> catch.log
						mv $torrentdir$torrentname$down $torrentdir$torrentname$torr
					else
						echo "$torrentname is 0kb... deleting...\n" >> $FAILURE
#						rm $torrentdir$torrentname
				fi
				for regex_movies in $MYMOVIE
				do
					if egrep -i "$regex_movies" catch.log
						then
							rm /volume1/script/movie_wishlist/$regex_movies
							if [ -f "/volume1/script/movie_wishlist/$regex_movies" ]
								then
									echo "Deleting failed.... $regex_movies \n" >> $FAILURE
								else
									echo "Deleting /volume1/script/movie_wishlist/$regex_movies fra movie wishlist \n" >> $DEBUG
							fi
						else
							echo "Did not find $regex_movies \n" >> $FAILURE
					fi
				done
			fi
		fi
		# rssdata is for test matching
		# echo "$url" >> rssdata
	done
#	echo -e "\nEnding $0 on $(date)" >> $DEBUG

	T="$(($(date +%s)-T))"
	echo -e "$(date +%Y-%m-%d) $(date +%T)\t${T}" >> $TIMEUSAGE
done < $CONFG
