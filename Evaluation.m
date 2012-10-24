topK = ToExpression[$CommandLine[[-2]]] 
window = ToExpression[$CommandLine[[-1]]]
dates = Import["bytick/scores/basic/INTC.csv"][[61 ;;, 1]];

WriteString[$Output, "(* topK: ", topK, " window: ", window, " *)\n"]

(* Snapshpot Aggregation *)

pricesSA = Table[
   tickers = StringDrop[Import["bydate/ranks/snapshot/" <> dates[[date]] <> ".csv"][[1 ;; topK, 2]], 2];
   files = Map["bytick/stats/" <> #1 <> ".csv" &, tickers];
   prices = Map[Import[#1][[date + 1 ;; date + window, 2]] &, files];
   prices, {date, 1, Length[dates] - window - 2}];

perfSA = Apply[Times, 1 + pricesSA/100, {2}];
roiSA =  Apply[Plus, perfSA, {1}]/topK; 
yieldSA = GeometricMean[roiSA]

WriteString[$Output, "perfSAK", topK, "W", window," = ", perfSA, ";\n"]   
WriteString[$Output, "roiSAK", topK, "W", window," = ", roiSA, ";\n"]   
WriteString[$Output, "yieldSAK", topK, "W", window," = ", yieldSA, ";\n"] 

(* Histogram Aggregation *)

pricesHA = Table[
   tickers = StringDrop[Import["bydate/ranks/histogram/" <> dates[[date]] <> ".csv"][[1 ;; topK, 2]], 2];
   files = Map["bytick/stats/" <> #1 <> ".csv" &, tickers];
   prices = Map[Import[#1][[date + 1 ;; date + window, 2]] &, files];
   prices, {date, 1, Length[dates] - window - 2}];

perfHA = Apply[Times, 1 + pricesHA/100, {2}];
roiHA = Apply[Plus, perfHA, {1}]/topK; 
yieldHA = GeometricMean[roiHA]

WriteString[$Output, "perfHAK", topK, "W", window," = ", perfHA, ";\n"]   
WriteString[$Output, "roiHAK", topK, "W", window," = ", roiHA, ";\n"]   
WriteString[$Output, "yieldHAK", topK, "W", window, " = ", yieldHA, ";\n"] 

(* Snapshot Skyline *)

pricesSS = Table[
   tickers = StringDrop[Import["bydate/ranks/skyline/snapshot/" <> dates[[date]] <> ".csv"][[1 ;; topK, 2]], 2];
   files = Map["bytick/stats/" <> #1 <> ".csv" &, tickers];
   prices = Map[Import[#1][[date + 1 ;; date + window, 2]] &, files];
   prices, {date, 1, Length[dates] - window - 2}];

perfSS = Apply[Times, 1 + pricesSS/100, {2}];
roiSS = Apply[Plus, perfSS, {1}]/topK;
yieldSS = GeometricMean[roiSS]

WriteString[$Output, "perfSSK", topK, "W", window," = ", perfSS, ";\n"]   
WriteString[$Output, "roiSSK", topK, "W", window," = ", roiSS, ";\n"]   
WriteString[$Output, "yieldSSK", topK, "W", window," = ", yieldSS, ";\n"] 

(* Histogram Skyline *)

pricesHS = Table[
   tickers = StringDrop[Import["bydate/ranks/skyline/histogram/" <> dates[[date]] <> ".csv"][[1 ;; topK, 2]], 2];
   files = Map["bytick/stats/" <> #1 <> ".csv" &, tickers];
   prices = Map[Import[#1][[date + 1 ;; date + window, 2]] &, files];
   prices, {date, 1, Length[dates] - window - 2}];

perfHS = Apply[Times, 1 + pricesHS/100, {2}];
roiHS = Apply[Plus, perfHS, {1}]/topK;
yieldHS = GeometricMean[roiHS]

WriteString[$Output, "perfHSK", topK, "W", window," = ", perfHS, ";\n"]   
WriteString[$Output, "roiHSK", topK, "W", window," = ", roiHS, ";\n"]   
WriteString[$Output, "yieldHSK", topK,"W", window," = ", yieldHS, ";\n"] 

WriteString["\n"]
