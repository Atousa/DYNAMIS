#!user/bin/python 
   
import sys
import csv
import glob
import os 
 

SMA5 = []
closep = 0
vol = 0

s = open(sys.argv[1], "r")
s.readline()
print "date, pricechange%, volumechange%"
count = 0;
for line in s:

    prev_closep = closep
    prev_vol = vol

    data = line.split(',')   
    date = data[0]
    closep = data[4]
    vol = data[5]  
    skip = 0
    count+=1
    
    if count < 2:
        continue

    if float(prev_closep) != 0:
        pricechange = (float(closep)-float(prev_closep))/float(prev_closep)*100
    else:
        skip = 1

    if float(prev_vol) != 0:
        volumechange = (float(vol)-float(prev_vol))/float(prev_vol)*100
    else:
        volumechange = 0
    if float(vol) == 0:
        volumechange = 0

    #SMA5.insert(0,closep)
    #if len(SMA5) == 6:
    #    SMA5.pop() 
    #if len(SMA5) == 5:
    #    sma5_value = float(reduce(lambda x, y: float(x)+float(y), SMA5)) / 5.0    
    #else :
    #    skip = 1

    if skip != 1:
        print str(date)+", "+str(pricechange)+", "+str(volumechange)
    



