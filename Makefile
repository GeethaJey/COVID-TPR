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
	
## JD's version of Datasets; may never be finished but is pedagogical
combine.Rout: combine.R owid.csv delve.csv
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
