#!/usr/bin/python 
   
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

lines=[]
for line in s1:
    data = line.split(',')
    date = data[0]
    (year, month, day) = date.split("-")
    tick = data[1].lstrip().rstrip()
    #print tick
    rank = data[2].rstrip()
    if tick != cur:
        cur = tick
        if out:
            lines.sort()
            for l in lines: out.write(l)
            out.close()
            lines=[]
        filename = outdir+"/"+tick+".csv"
        #print filename
        out = open(filename, "w")
    lines.append(""+year+", "+month+", "+day+", "+rank+"\n")

if out:
    lines.sort()
    for l in lines: out.write(l)
    out.close()

