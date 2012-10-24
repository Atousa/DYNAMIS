#!user/bin/python 
   
import sys
import csv
import glob
import os
import time 
import csv 
import datetime as dt

outdir = sys.argv[1]
s1 = open(sys.argv[2], "r")

cur = ""
out = ""

for line in s1:
    data = line.split(',')
    date = data[0]
    if date != cur:
        #print date
        cur = date
        if out: out.close()
        out = open(outdir+"/"+date+".csv", "w")
    out.write(line)


