#!/usr/bin/python

import urllib
import os


urllib.urlretrive('http://www.torrentday.com/torrents/rss?download;11;7;u=428237;tp=887f3b1d10049f24d6fddf65d2139b22' , 'temp_rss.file')

if os.path.isfile(temp_rss.file): try: open(temp_rss.file)

urllib.urlcleanup()