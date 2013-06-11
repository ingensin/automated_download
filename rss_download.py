#!/usr/bin/python

import urllib2
 
#size of each block we want to read. since we are unable to read all data at once, we will
#read this many bytes at once and write it to a local file then go back again fetch another block
#write to local file and keep doing this till there is data left to read
READ_BLOCK_SIZE = 1024*8
 
#use a url that will indeed send compressed data when asked for, some servers choose not to
#even if you are willing to accept compressed data
url = 'http://www.torrentday.com/torrents/rss?download;11;7;u=428237;tp=887f3b1d10049f24d6fddf65d2139b22'
 
request = urllib2.Request(url)
 
#let the server know you are ready to accept compressed data
request.add_header('Accept-encoding', 'gzip,deflate')
 
response = urllib2.urlopen(request)
 
#make sure the response is compressed
isGZipped = response.headers.get('content-encoding', '').find('gzip') >= 0
 
#file to write data to
outFile = open("rss.temp", "w")
 
while True:
  data = response.read(READ_BLOCK_SIZE)
  if not data: break
  if isGZipped:
    #make a file like thing of the read bytes
    data = cStringIO.StringIO(data)
    #open the file-like-thing as a gzipped file
    data = gzip.GzipFile(fileobj=data).read()
  outFile.write(data)