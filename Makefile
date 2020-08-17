## This is the Makefile for Geetha's test positivity

current: target
-include target.mk

# -include makestuff/perl.def

vim_session:
	bash -cl "vmt"

######################################################################

Sources += $(wildcard *.R *.md *.Rmd)

## Writeup.Rmd.html: Writeup.Rmd

######################################################################

## Geetha's big global script

## Datasets.R

## Use a phony target so I can control when owid.csv gets made
update_owid:
	wget -O owid.csv "https://covid.ourworldindata.org/data/owid-covid-data.csv"
Ignore += owid.csv
owid.csv:
	$(MAKE) update_owid

update_delve:
	wget -O delve.csv "https://raw.githubusercontent.com/rs-delve/covid19_datasets/master/dataset/combined_dataset_latest.csv"
Ignore += delve.csv
delve.csv:
	$(MAKE) update_delve
	
update_Rt: 
	wget -O Rt.csv "https://storage.googleapis.com/static-covid/static/v4/main/r_estimates.csv"
Ignore += Rt.csv
Rt.csv:
	$(MAKE) update_Rt

update_odb: 
	wget -O odb.csv "https://opendatabarometer.org/assets/data/ODB-2014-Rankings.csv"
Ignore += odb.csv
odb.csv: 
	$(MAKE) update_odb

## US Datasets

update_USstatedata:
	wget -O USstatedata.csv "https://covidtracking.com/api/v1/states/daily.csv"
Ignore += USstatedata.csv
USstatedata.csv: 
	$(MAKE) update_USstatedata

update_USmobility: 
	wget -O USmobility.csv "https://www.gstatic.com/covid19/mobility/Global_Mobility_Report.csv?cachebust=94537edba4db1128"
Ignore += USmobility.csv
USmobility.csv: 
	$(MAKE) update_USmobility
	

update_ghs:
	wget -O ghs.zip "https://www.ghsindex.org/wp-content/uploads/2019/10/Global-Health-Security-Index-2019-Final-October-2019.zip"
ghs.zip:
	$(MAKE) update_ghs
	
## Canada Datasets
update_goc:
	wget -O goc.csv "https://health-infobase.canada.ca/src/data/covidLive/covid19.csv"
goc.csv:
	$(MAKE) update_goc

update_goc_metadata: 
	wget -O goc_metadata.csv "https://health-infobase.canada.ca/src/data/covidLive/covid19-data-dictionary.csv"
goc_metadata.csv
	$(MAKE) update_goc_metadata
	
## This is not working yet, but we will fix it
ghs.xlsm: ghs.zip
	unzip $< 

######################################################################

## Combine the data sets
combine.Rout: combine.R owid.csv delve.csv Rt.csv odb.csv USstatedata.csv USmobility.csv goc.csv goc_metadata.csv
        $(makeR)

######################################################################

Writeup.html: Writeup.Rmd

######################################################################

## Not currently in use
Regression.Rout: Regression.R
	$(run-R)

######################################################################

### Makestuff

## Sources += $(wildcard *.mk)
## include $(wildcard *.mk)

Sources += Makefile
Ignore += makestuff
msrepo = https://github.com/dushoff
Makefile: makestuff/Makefile
makestuff/Makefile:
	git clone $(msrepo)/makestuff
	ls makestuff/Makefile

-include makestuff/os.mk

-include makestuff/makeR.mk

-include makestuff/rmd.mk
-include makestuff/git.mk
-include makestuff/visual.mk
-include makestuff/projdir.mk
