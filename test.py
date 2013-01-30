#!/usr/bin/python
import os

import httplib2

import xml.etree.ElementTree as ET

http = httplib2.http()

resp, content = http.request("http://www.torrentday.com/torrents/rss?download;11;7;u=428237;tp=887f3b1d10049f24d6fddf65d2139b22")

#print content



#count = 0
#files = os.listdir("/volume1/transmission/")
#for file in files:
#	print file
#	count = count+1
#
#print count