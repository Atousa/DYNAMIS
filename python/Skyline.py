#!/usr/bin/python 
   
import sys
import csv
import glob
import os
import time 
import csv 
import datetime as dt

TICK = sys.argv[1]
Window = sys.argv[2]

RSD = open('bytick/ranks/RSD'+Window+'/'+TICK+'.csv', "r")
DPC = open('bytick/ranks/DPC'+Window+'/'+TICK+'.csv', "r")
DVC = open('bytick/ranks/DVC'+Window+'/'+TICK+'.csv', "r")

for line in RSD:
    (year, month, day, rsd) = line.split(',')
    (y1, m1, d1, dpc) = DPC.readline().split(',')
    (y2, m2, d2, dvc) = DVC.readline().split(',')

    if(year != y1 or year != y2):
        sys.stderr.write("Year OUT OF SYNC\n");
        sys.exit(2)
    if(month != m1 or month != m2):
        sys.stderr.write("Month OUT OF SYNC\n");
        sys.exit(2)
    if(day != d1 or day != d2):
        sys.stderr.write("Day OUT OF SYNC\n");
        sys.exit(2)

    print year.lstrip().rstrip()+"-"+month.lstrip().rstrip()+"-"+day.lstrip().rstrip()+", "+TICK+", "+str(int(rsd)+int(dpc)+int(dvc))

