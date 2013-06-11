#!/usr/bin/python

import feedparser
import zlib

f = open('http://www.torrentday.com/torrents/rss?download;7;u=428237;tp=887f3b1d10049f24d6fddf65d2139b22', 'rb')

decompressed_data=zlib.decompress(f.read(), 16+zlib.MAX_WBITS)

print decompressed_data

#feed = feedparser.parse( decompressed_data )
