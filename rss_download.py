#!/usr/bin/python

import urllib
import os

distantfile = 'http://www.torrentday.com/torrents/rss?download;11;7;u=428237;tp=887f3b1d10049f24d6fddf65d2139b22'
localfile = './rss.temp'
urllib.urlretrieve(distantfile, localfile)


if os.path.isfile('rss.temp'):
	print "file found";

urllib.urlcleanup()