#!/usr/bin/python

import re
import feedparser
import urllib

<<<<<<< HEAD
import xml.etree.ElementTree as ET

http = httplib2.http()
=======
>>>>>>> !

url = 'http://www.torrentday.com/torrents/rss?download;11;7;u=428237;tp=887f3b1d10049f24d6fddf65d2139b22' 

<<<<<<< HEAD
#print content

=======
feed = feedparser.parse(url)
for post in feed.entries:
	title = post.title
	link = post.link
#	for series in title:
#		match = re.match('Face', series, re.I)
#		search = re.search()
#		print match
		
>>>>>>> !

#p = re.compile( ... )
#m = p.match( 'string goes here' )
#if m:
#    print 'Match found: ', m.group()
#else:
#    print 'No match'
	

	
urllib.urlretrieve ("http://www.example.com/sometorrent.torrent", "torrentname.torrent")

urllib.urlcleanup()
