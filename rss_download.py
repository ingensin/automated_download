#!/usr/bin/python

rss_server_url = 'http://www.torrentday.com/torrents/rss?download;11;7;u=428237;tp=887f3b1d10049f24d6fddf65d2139b22'

rss = urllib.urlretrive(rss_server_url , 'temp_rss.file')
	print rss

urllib.urlcleanup()