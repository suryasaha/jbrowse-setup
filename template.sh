#!/bin/sh

# Surya Saha
# Purpose: setup ????? in sftp://surya@hlbws.sgn.cornell.edu/var/www/html/jbrowse/JBrowse-1.11.4/data/json/?????

set -u #exit if uninit var
set -o nounset
set -o errexit

# vars
PRED_COLOR 	= "orange"
GENE_COLOR 	= "yellow"
CDS_COLOR 	= "blue"
REPEAT_COLOR 	= "green"


# cleanup
if [ -d data/json/??? ]
then
	rm -rf data/json/????
fi

# load refs and data source

printf "[general]\ndataset_id = ???????\n" > data/json/???/tracks.conf

# create annotation tracks


# create assembly tracks


# index names


#######
