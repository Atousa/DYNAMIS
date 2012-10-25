TICKERS = $(subst Tickers/DJI-hist.csv,,$(wildcard Tickers/*.csv)) # Skip DJI
STATS = $(sort $(subst Tickers,bytick/stats,$(TICKERS:-hist.csv=.csv)))
SCORES = $(sort $(subst Tickers,bytick/scores/basic,$(TICKERS:-hist.csv=.csv)))
SKYSNAPSCORES = $(sort $(subst Tickers,bytick/scores/skyline/snapshot,$(TICKERS:-hist.csv=.csv)))
SKYHISTOSCORES = $(sort $(subst Tickers,bytick/scores/skyline/histogram,$(TICKERS:-hist.csv=.csv)))

.PHONY: all
all: .alldone

.PHONY: allstats
allstats: $(STATS)

bytick/stats:
	@mkdir -p bytick/stats

bytick/stats/%.csv: Tickers/%-hist.csv python/DailyChange.py bytick/stats
	python python/DailyChange.py $< > $@

.PHONY: allscores
allscores: $(SCORES)

bytick/scores/basic:
	@mkdir -p bytick/scores/basic

bytick/scores/basic/%.csv: bytick/stats/%.csv python/Score.py bytick/scores/basic bytick/stats/DJI.csv
	python python/Score.py $< bytick/stats/DJI.csv > $@

bydate/scores/basic:
	mkdir -p bydate/scores/basic

bydate/.split: $(SCORES) bydate/scores/basic
	cat bytick/scores/basic/*.csv | sort -t, > bydate/scores/all_basic.csv
	python python/SplitByDate.py bydate/scores/basic bydate/scores/all_basic.csv
# remove the first 60 day's worth of data (In 2009, the first 60 trading days cover all of Jan, Feb and Mar)
	rm -fr  bydate/scores/basic/2009-01-* bydate/scores/basic/2009-02-* bydate/scores/basic/2009-03-*
	touch bydate/.split

bydate/ranks/snapshot:
	mkdir -p bydate/ranks/snapshot

bydate/ranks/snapshot/%.csv: bydate/scores/basic/%.csv python/Rank.py bydate/ranks/snapshot
	sort -r -g -t, -k 6 $< | python python/Rank.py $@

# This should always be called in a sub-process, so that the wildcard is evaluated after bydate/.split
bydate/ranks/..snapshot: $(sort $(subst bydate/scores/basic,bydate/ranks/snapshot,$(wildcard bydate/scores/basic/*.csv))) 
	touch bydate/ranks/..snapshot

bydate/ranks/.snapshot: bydate/.split
	$(MAKE) bydate/ranks/..snapshot
	touch bydate/ranks/.snapshot

bydate/ranks/histogram:
	mkdir -p bydate/ranks/histogram

bydate/ranks/histogram/%.csv: bydate/scores/basic/%.csv python/Rank.py bydate/ranks/histogram
	sort -r -g -t, -k 10 $< | python python/Rank.py $@

# This should always be called in a sub-process, so that the wildcard is evaluated after .date_split
bydate/ranks/..histogram: $(sort $(subst bydate/scores/basic,bydate/ranks/histogram,$(wildcard bydate/scores/basic/*.csv)))
	touch bydate/ranks/..histogram

bydate/ranks/.histogram: bydate/.split
	$(MAKE) bydate/ranks/..histogram
	touch bydate/ranks/.histogram

bydate/ranks/RSD1:
	mkdir -p bydate/ranks/RSD1

bydate/ranks/RSD1/%.csv: bydate/scores/basic/%.csv python/Rank.py bydate/ranks/RSD1
	sort -r -g -t, -k 3 $< | python python/Rank.py $@

# This should always be called in a sub-process, so that the wildcard is evaluated after .date_split
bydate/ranks/..RSD1: $(sort $(subst bydate/scores/basic,bydate/ranks/RSD1,$(wildcard bydate/scores/basic/*.csv)))
	touch bydate/ranks/..RSD1

bydate/ranks/.RSD1: bydate/.split
	$(MAKE) bydate/ranks/..RSD1
	touch bydate/ranks/.RSD1

bydate/ranks/DPC1:
	mkdir -p bydate/ranks/DPC1

bydate/ranks/DPC1/%.csv: bydate/scores/basic/%.csv python/Rank.py bydate/ranks/DPC1
	sort -r -g -t, -k 4 $< | python python/Rank.py $@

# This should always be called in a sub-process, so that the wildcard is evaluated after .date_split
bydate/ranks/..DPC1: $(sort $(subst bydate/scores/basic,bydate/ranks/DPC1,$(wildcard bydate/scores/basic/*.csv)))
	touch bydate/ranks/..DPC1

bydate/ranks/.DPC1: bydate/.split
	$(MAKE) bydate/ranks/..DPC1
	touch bydate/ranks/.DPC1

bydate/ranks/DVC1:
	mkdir -p bydate/ranks/DVC1

bydate/ranks/DVC1/%.csv: bydate/scores/basic/%.csv python/Rank.py bydate/ranks/DVC1
	sort -r -g -t, -k 5 $< | python python/Rank.py $@

# This should always be called in a sub-process, so that the wildcard is evaluated after .date_split
bydate/ranks/..DVC1: $(sort $(subst bydate/scores/basic,bydate/ranks/DVC1,$(wildcard bydate/scores/basic/*.csv)))
	touch bydate/ranks/..DVC1

bydate/ranks/.DVC1: bydate/.split
	$(MAKE) bydate/ranks/..DVC1
	touch bydate/ranks/.DVC1

bydate/ranks/RSD60:
	mkdir -p bydate/ranks/RSD60

bydate/ranks/RSD60/%.csv: bydate/scores/basic/%.csv python/Rank.py bydate/ranks/RSD60
	sort -r -g -t, -k 9 $< | python python/Rank.py $@

# This should always be called in a sub-process, so that the wildcard is evaluated after .date_split
bydate/ranks/..RSD60: $(sort $(subst bydate/scores/basic,bydate/ranks/RSD60,$(wildcard bydate/scores/basic/*.csv)))
	touch bydate/ranks/..RSD60

bydate/ranks/.RSD60: bydate/.split
	$(MAKE) bydate/ranks/..RSD60
	touch bydate/ranks/.RSD60

bydate/ranks/DPC60:
	mkdir -p bydate/ranks/DPC60

bydate/ranks/DPC60/%.csv: bydate/scores/basic/%.csv python/Rank.py bydate/ranks/DPC60
	sort -r -g -t, -k 7 $< | python python/Rank.py $@

# This should always be called in a sub-process, so that the wildcard is evaluated after .date_split
bydate/ranks/..DPC60: $(sort $(subst bydate/scores/basic,bydate/ranks/DPC60,$(wildcard bydate/scores/basic/*.csv)))
	touch bydate/ranks/..DPC60

bydate/ranks/.DPC60: bydate/.split
	$(MAKE) bydate/ranks/..DPC60
	touch bydate/ranks/.DPC60

bydate/ranks/DVC60:
	mkdir -p bydate/ranks/DVC60

bydate/ranks/DVC60/%.csv: bydate/scores/basic/%.csv python/Rank.py bydate/ranks/DVC60
	sort -r -g -t, -k 8 $< | python python/Rank.py $@

# This should always be called in a sub-process, so that the wildcard is evaluated after .date_split
bydate/ranks/..DVC60: $(sort $(subst bydate/scores/basic,bydate/ranks/DVC60,$(wildcard bydate/scores/basic/*.csv)))
	touch bydate/ranks/..DVC60

bydate/ranks/.DVC60: bydate/.split
	$(MAKE) bydate/ranks/..DVC60
	touch bydate/ranks/.DVC60

.PHONY: allranks
allranks: bydate/ranks/.allranks

bydate/ranks/.allranks: bydate/ranks/.snapshot bydate/ranks/.histogram bydate/ranks/.RSD1 bydate/ranks/.DPC1 bydate/ranks/.DVC1 bydate/ranks/.RSD60 bydate/ranks/.DPC60 bydate/ranks/.DVC60
	touch bydate/ranks/.allranks

bytick/ranks/snapshot:
	mkdir -p bytick/ranks/snapshot

bytick/ranks/.snapshot: bydate/ranks/.snapshot bytick/ranks/snapshot
	cat bydate/ranks/snapshot/*.csv | sort -t, -k 2 > bytick/ranks/all_snapshots.csv
	python python/SplitByTickAndSort.py bytick/ranks/snapshot bytick/ranks/all_snapshots.csv
	touch bytick/ranks/.snapshot

bytick/ranks/histogram:
	mkdir -p bytick/ranks/histogram

bytick/ranks/.histogram: bydate/ranks/.histogram bytick/ranks/histogram
	cat bydate/ranks/histogram/*.csv | sort -t, -k 2 > bytick/ranks/all_histograms.csv
	python python/SplitByTickAndSort.py bytick/ranks/histogram bytick/ranks/all_histograms.csv
	touch bytick/ranks/.histogram

bytick/ranks/RSD1:
	mkdir -p bytick/ranks/RSD1

bytick/ranks/.RSD1: bydate/ranks/.RSD1 bytick/ranks/RSD1
	cat bydate/ranks/RSD1/*.csv | sort -t, -k 2 > bytick/ranks/all_RSD1.csv
	python python/SplitByTickAndSort.py bytick/ranks/RSD1 bytick/ranks/all_RSD1.csv
	touch bytick/ranks/.RSD1

bytick/ranks/DPC1:
	mkdir -p bytick/ranks/DPC1

bytick/ranks/.DPC1: bydate/ranks/.DPC1 bytick/ranks/DPC1
	cat bydate/ranks/DPC1/*.csv | sort -t, -k 2 > bytick/ranks/all_DPC1.csv
	python python/SplitByTickAndSort.py bytick/ranks/DPC1 bytick/ranks/all_DPC1.csv
	touch bytick/ranks/.DPC1

bytick/ranks/DVC1:
	mkdir -p bytick/ranks/DVC1

bytick/ranks/.DVC1: bydate/ranks/.DVC1 bytick/ranks/DVC1
	cat bydate/ranks/DVC1/*.csv | sort -t, -k 2 > bytick/ranks/all_DVC1.csv
	python python/SplitByTickAndSort.py bytick/ranks/DVC1 bytick/ranks/all_DVC1.csv
	touch bytick/ranks/.DVC1

bytick/ranks/RSD60:
	mkdir -p bytick/ranks/RSD60

bytick/ranks/.RSD60: bydate/ranks/.RSD60 bytick/ranks/RSD60
	cat bydate/ranks/RSD60/*.csv | sort -t, -k 2 > bytick/ranks/all_RSD60.csv
	python python/SplitByTickAndSort.py bytick/ranks/RSD60 bytick/ranks/all_RSD60.csv
	touch bytick/ranks/.RSD60

bytick/ranks/DPC60:
	mkdir -p bytick/ranks/DPC60

bytick/ranks/.DPC60: bydate/ranks/.DPC60 bytick/ranks/DPC60
	cat bydate/ranks/DPC60/*.csv | sort -t, -k 2 > bytick/ranks/all_DPC60.csv
	python python/SplitByTickAndSort.py bytick/ranks/DPC60 bytick/ranks/all_DPC60.csv
	touch bytick/ranks/.DPC60

bytick/ranks/DVC60:
	mkdir -p bytick/ranks/DVC60

bytick/ranks/.DVC60: bydate/ranks/.DVC60 bytick/ranks/DVC60
	cat bydate/ranks/DVC60/*.csv | sort -t, -k 2 > bytick/ranks/all_DVC60.csv
	python python/SplitByTickAndSort.py bytick/ranks/DVC60 bytick/ranks/all_DVC60.csv
	touch bytick/ranks/.DVC60

bytick/scores/skyline/snapshot:
	@mkdir -p bytick/scores/skyline/snapshot

bytick/scores/skyline/snapshot/%.csv: bytick/ranks/.RSD1 bytick/ranks/.DPC1 bytick/ranks/.DVC1 python/Skyline.py bytick/scores/skyline/snapshot
	python python/Skyline.py $(subst .csv,,$(subst bytick/scores/skyline/snapshot/,,$@)) 1 > $@

bydate/scores/skyline/snapshot:
	@mkdir -p bydate/scores/skyline/snapshot

bydate/.skylinesnapsplit: $(SKYSNAPSCORES) bydate/scores/skyline/snapshot
	cat bytick/scores/skyline/snapshot/*.csv | sort -t, > bydate/scores/all_skyline_snap.csv
	python python/SplitByDate.py bydate/scores/skyline/snapshot bydate/scores/all_skyline_snap.csv
	touch bydate/.skylinesnapsplit

bydate/ranks/skyline/snapshot:
	mkdir -p bydate/ranks/skyline/snapshot

bydate/ranks/skyline/snapshot/%.csv: bydate/scores/skyline/snapshot/%.csv python/Rank.py bydate/ranks/skyline/snapshot
	sort -g -t, -k 3 $< | python python/Rank.py $@

# This should always be called in a sub-process, so that the wildcard is evaluated after bydate/.skylinesnapsplit
bydate/ranks/..skylinesnap: $(sort $(subst bydate/scores/skyline/snapshot,bydate/ranks/skyline/snapshot,$(wildcard bydate/scores/skyline/snapshot/*.csv))) 
	touch bydate/ranks/..skylinesnap

bydate/ranks/.skylinesnap: bydate/.skylinesnapsplit
	$(MAKE) bydate/ranks/..skylinesnap
	touch bydate/ranks/.skylinesnap

bytick/ranks/skyline/snapshot:
	mkdir -p bytick/ranks/skyline/snapshot

bytick/ranks/.skylinesnap: bydate/ranks/.skylinesnap bytick/ranks/skyline/snapshot
	cat bydate/ranks/skyline/snapshot/*.csv | sort -t, -k 2 > bytick/ranks/all_skyline_snap.csv
	python python/SplitByTickAndSort.py bytick/ranks/skyline/snapshot bytick/ranks/all_skyline_snap.csv
	touch bytick/ranks/.skylinesnap

bytick/scores/skyline/histogram:
	@mkdir -p bytick/scores/skyline/histogram

bytick/scores/skyline/histogram/%.csv: bytick/ranks/.RSD60 bytick/ranks/.DPC60 bytick/ranks/.DVC60 python/Skyline.py bytick/scores/skyline/histogram
	python python/Skyline.py $(subst .csv,,$(subst bytick/scores/skyline/histogram/,,$@)) 60 > $@

bydate/scores/skyline/histogram:
	@mkdir -p bydate/scores/skyline/histogram

bydate/.skylinehistosplit: $(SKYHISTOSCORES) bydate/scores/skyline/histogram
	cat bytick/scores/skyline/histogram/*.csv | sort -t, > bydate/scores/all_skyline_histo.csv
	python python/SplitByDate.py bydate/scores/skyline/histogram bydate/scores/all_skyline_histo.csv
	touch bydate/.skylinehistosplit

bydate/ranks/skyline/histogram:
	mkdir -p bydate/ranks/skyline/histogram

bydate/ranks/skyline/histogram/%.csv: bydate/scores/skyline/histogram/%.csv python/Rank.py bydate/ranks/skyline/histogram
	sort -g -t, -k 3 $< | python python/Rank.py $@

# This should always be called in a sub-process, so that the wildcard is evaluated after bydate/.skylinehistosplit
bydate/ranks/..skylinehisto: $(sort $(subst bydate/scores/skyline/histogram,bydate/ranks/skyline/histogram,$(wildcard bydate/scores/skyline/histogram/*.csv))) 
	touch bydate/ranks/..skylinehisto

bydate/ranks/.skylinehisto: bydate/.skylinehistosplit
	$(MAKE) bydate/ranks/..skylinehisto
	touch bydate/ranks/.skylinehisto

bytick/ranks/skyline/histogram:
	mkdir -p bytick/ranks/skyline/histogram

bytick/ranks/.skylinehisto: bydate/ranks/.skylinehisto bytick/ranks/skyline/histogram
	cat bydate/ranks/skyline/histogram/*.csv | sort -t, -k 2 > bytick/ranks/all_skyline_histo.csv
	python python/SplitByTickAndSort.py bytick/ranks/skyline/histogram bytick/ranks/all_skyline_histo.csv
	touch bytick/ranks/.skylinehisto

.alldone: bytick/ranks/.snapshot bytick/ranks/.histogram bytick/ranks/.skylinesnap bytick/ranks/.skylinehisto
	touch .alldone

.PHONY: evaluation
evaluation: evaluationW20 evaluationK10

.PHONY: evaluationW20
evaluationW20:
	cat /dev/null > Eval_W20.m
	for k in 10 20 30 60 120 180; do \
	  /Applications/Mathematica.app/Contents/MacOS/MathKernel -script Evaluation.m $$k 20 >> Eval_W20.m ; \
	done

.PHONY: evaluationK10
evaluationK10:
	cat /dev/null > Eval_K10.m
	for w in 10 20 30 40 60 75 90 105 120 180; do \
	  /Applications/Mathematica.app/Contents/MacOS/MathKernel -script Evaluation.m 10 $$w >> Eval_K10.m ; \
	done
clean:
	rm -fr bytick bydate .alldone ._* .DS_Store 

.SECONDARY:

