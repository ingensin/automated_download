#!/usr/bin/python

import feedparser

python_wiki_rss_url = "http://www.torrentday.com/torrents/" \
                      "rss?download;7;u=428237;tp=887f3b1d10049f24d6fddf65d2139b22"
decompressed_data=zlib.decompress(f.read( python_wiki_rss_url ), 16+zlib.MAX_WBITS)

print decompressed_data

feed = feedparser.parse( decompressed_data )


   
   
   