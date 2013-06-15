#!/usr/bin/python

from StringIO import StringIO
import xml.etree.ElementTree as xml
import re
import feedparser
import urllib2
import MySQLdb
import sys
import gzip


db = MySQLdb.connect(host="localhost", port=3306, user="script", passwd="PfSQL412", db="script")
# cursor = db.cursor()

# count = cursor.execute("SELECT * FROM wishlist")

# items = cursor.fetchall()
# for item in items:
	# print item




def get_list_of_rss_servers():
	cursor = db.cursor()
	rss_server = cursor.execute("SELECT id, url FROM rss_server")
	all_servers = cursor.fetchall()
	cursor.close()
	return all_rss_servers

all_rss_servers = get_list_of_rss_servers()

# for row in rss_servers:
	# print row
	
def get_wishlist():
	cursor = db.cursor()
	wishlist = cursor.execute("SELECT id, name, rss_server_id, created FROM wishlist")
	all_wishlists = cursor.fetchall()
	cursor.close()
	return all_wishlists
	
	
def download_rss():
	request = urllib2.Request('http://www.torrentday.com/torrents/rss?download;11;7;u=428237;tp=887f3b1d10049f24d6fddf65d2139b22')
	request.add_header('Accept-encoding', 'gzip')
	response = urllib2.urlopen(request)
	if response.info().get('Content-Encoding') == 'gzip':
		buf = StringIO( response.read())
		f = gzip.GzipFile(fileobj=buf)
		data = f.read()
		print data
		
rss = download_rss()

def get_wanted_torrents_from_rss()
	root = xml.fromstring(StringFor__RSS__GoesHere)


	
db.close()		
sys.exit()
		


watch_folder = '/volume1/script/test_watchfolder'
url = 'http://www.torrentday.com/torrents/rss?download;11;7;u=428237;tp=887f3b1d10049f24d6fddf65d2139b22'
list_of_stuff_i_want = ["Life.on.fire", "Austin.City.Limits", "Moving.On"]


def download_torrent(link, title, torrent_folder):
	filename = torrent_folder + "/" + title.replace(" ", ".") + ".torrent"
	urllib.urlretrieve ( link, filename)




feed = feedparser.parse(url)
for post in feed.entries:
	title = post.title
	link = post.link
	for stuff_i_like in list_of_stuff_i_want:
		if re.match(stuff_i_like, title, re.I):
			download_torrent(link, title, watch_folder)
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
db.close()