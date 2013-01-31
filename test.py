#!/usr/bin/python

import re
import feedparser
import urllib


def download_torrent(link, title):
	urllib.urlretrieve (link, title.replace(" ", ".") + ".torrent")

list_of_stuff_i_want = ["Life.on.fire", "Austin.City.Limits", "Moving.On"]


url = 'http://www.torrentday.com/torrents/rss?download;11;7;u=428237;tp=887f3b1d10049f24d6fddf65d2139b22' 

feed = feedparser.parse(url)
for post in feed.entries:
	title = post.title
	link = post.link
	for stuff_i_like in list_of_stuff_i_want:
		if re.match(stuff_i_like, title, re.I):
			download_torrent(link, title)
			print "Found " + stuff_i_like + " !\n"
			
#	for series in title:
#		match = re.match('Face', series, re.I)
#		search = re.search()
#		print match
		

#p = re.compile( ... )
#m = p.match( 'string goes here' )
#if m:
#    print 'Match found: ', m.group()
#else:
#    print 'No match'
	

	
#urllib.urlretrieve ("http://www.example.com/sometorrent.torrent", "torrentname.torrent")

#urllib.urlcleanup()
