#!user/bin/python 
   
import sys
import csv
import glob
import os
import time 
import csv 
import datetime as dt

s2 = open(sys.argv[1], "w")
num = 1

for line in sys.stdin:
    data = line.split(',')
    date = data[0]
    ticker = data[1]

    s2.write(date+", "+ticker+", "+str(num)+"\n")
    num += 1


