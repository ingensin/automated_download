#!/usr/bin/python
import os
count = 0
files = os.listdir("/volume1/transmission/")
for file in files:
	print file
	count = count+1

print count