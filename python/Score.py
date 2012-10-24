#!user/bin/python 
   
import sys
import csv
import glob
import os
import time 
import csv 
import datetime as dt

DPCthreshold = 2
DVCthreshold = 10
RSDthreshold = 1

DPC = []
DVC = []
RSD = []

DPCwindow = 60
DVCwindow = 60
RSDwindow = 60

DPC60 = 0
DVC60 = 0
RSD60 = 0

if sys.argv[1] == sys.argv[2]:
    sys.exit(0)
    
s1 = open(sys.argv[1], "r") # Stock
ticker = sys.argv[1].split('/')[-1][:-4]

s1.readline()

s2 = open(sys.argv[2], "r") # Reference Index (DJI)
s2.readline()

#print "date, ticker, RSD1, DPC1, DVC1, SScore, DPC60, DVC60, RSD60, HScore"

while 1:
    line2 = s2.readline()
    if not line2: break
    data2 = line2.split(',')
    DJIdate = time.strptime(data2[0],"%Y-%m-%d")
    DJIpricechange = data2[1]
    #print "LDJI: "+line2
    #print "DJI1:  "+str(DJIdate)

    line1 = s1.readline()
    if not line1: break
    data1 = line1.split(',')
    TICKdate = time.strptime(data1[0],"%d-%b-%y")
    TICKpricechange = float(data1[1])
    TICKvolchange = float(data1[2])
    
    itemP = TICKpricechange>=DPCthreshold and 1 or 0
    DPC.insert(0, itemP)
    DPC60 += itemP
    if(len(DPC)>DPCwindow):
        DPC60 -= DPC.pop()
    itemV = TICKvolchange>=DVCthreshold and 1 or 0
    DVC.insert(0, itemV)
    DVC60 += itemV
    if(len(DVC)>DVCwindow):
        DVC60 -= DVC.pop()
    #print "LTICK: "+line1
    #print "TICK1: "+str(TICKdate)

    while DJIdate > TICKdate:
        SScore = str(2*TICKpricechange+0.1*TICKvolchange) # no DJI Today
        HScore = str(3.*RSD60+2.*DPC60+0.1*DVC60)

        #print "date, ticker, RSD1, DPC1, DVC1, SScore, DPC60, DVC60, RSD60, HScore"
        print time.strftime("%Y-%m-%d", TICKdate)+", "+ticker+", 0, "+str(TICKpricechange)+", "+str(TICKvolchange)+", "+SScore+", "+str(DPC60)+", "+str(DVC60)+", "+str(RSD60)+", "+HScore

        line1 = s1.readline()
        if not line1: break
        data1 = line1.split(',')
        TICKdate = time.strptime(data1[0],"%d-%b-%y")
        TICKpricechange = float(data1[1])
        TICKvolchange = float(data1[2])
        itemP = TICKpricechange>=DPCthreshold and 1 or 0
        DPC.insert(0, itemP)
        DPC60 += itemP
        if(len(DPC)>DPCwindow):
            DPC60 -= DPC.pop()
        itemV = TICKvolchange>=DVCthreshold and 1 or 0
        DVC.insert(0, itemV)
        DVC60 += itemV
        if(len(DVC)>DVCwindow):
            DVC60 -= DVC.pop()
        #print "LTICK: "+line1
        #print "TICK2: "+str(TICKdate)

    while DJIdate < TICKdate:
        line2 = s2.readline()
        if not line2: break
        data2 = line2.split(',')
        DJIdate = time.strptime(data2[0],"%Y-%m-%d")
        DJIpricechange = data2[1]
        #print "LDJI: "+line2
        #print "DJI2:  "+str(DJIdate)

    if(DJIdate == TICKdate):
        RSDvalue = (float(TICKpricechange)-float(DJIpricechange))
        itemR = RSDvalue>=RSDthreshold and 1 or 0 
        RSD.insert(0,itemR)
        RSD60 += itemR
        if len(RSD)> RSDwindow:
            RSD60 -= RSD.pop()

        SScore = str(3*RSDvalue+2*TICKpricechange+0.1*TICKvolchange)
        HScore = str(3.*RSD60+2.*DPC60+0.1*DVC60)
        #wDPC1 = 2
        #if TICKpricechange < 0: wDPC1 = 0
        #wRSD1 = 3
        #if RSDvalue < 0: wRSD1 = 0
        #SScore = str(wRSD1*RSDvalue+wDPC1*TICKpricechange+0.1*TICKvolchange)
        #wDPC60 = 3.
        #if itemP == 0: wDPC60 = 0.3
        #wRSD60 = 2.
        #if itemR == 0: wRSD60 = 0.2
        #HScore = str(wRSD60*RSD60+wDPC60*DPC60+0.1*DVC60)

        #print "date, ticker, RSD1, DPC1, DVC1, SScore, DPC60, DVC60, RSD60, HScore"
        print time.strftime("%Y-%m-%d", TICKdate)+", "+ticker+", "+str(RSDvalue)+", "+str(TICKpricechange)+", "+str(TICKvolchange)+", "+SScore+", "+str(DPC60)+", "+str(DVC60)+", "+str(RSD60)+", "+HScore

