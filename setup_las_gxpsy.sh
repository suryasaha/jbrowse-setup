#!/bin/sh

# Surya Saha
# Purpose: setup LAS gxpsy in sftp://surya@hlbws.sgn.cornell.edu/var/www/html/jbrowse/JBrowse-1.11.4/data/json/las_gxpsy

set -u #exit if uninit var
set -o nounset
set -o errexit

# cleanup
rm -rf data/json/las_gxpsy

# load refs and data source
bin/prepare-refseqs.pl --fasta ~/work/jbrowse_setup/las_gxpsy/NC_020549.1.fa --out data/json/las_gxpsy
printf "[general]\ndataset_id = las_gxpsy\n" > data/json/las_gxpsy/tracks.conf

# create annotation tracks
bin/flatfile-to-json.pl --gff ~/work/jbrowse_setup/las_gxpsy/NC_020549.gbrowse.gff3  --type gene  --trackLabel gene --key "Genes" --trackType CanvasFeatures --out data/json/las_gxpsy/ --clientConfig '{"label" : "name,id", "color" : "yellow" }' --metadata '{"description": "Genes from NCBI Refseq", "category": "General" }' --urltemplate "http://www.ncbi.nlm.nih.gov/protein?term={name}" 

bin/flatfile-to-json.pl --gff ~/work/jbrowse_setup/las_gxpsy/NC_020549.gbrowse.gff3 --type CDS --trackLabel CDS  --key "CDS" --trackType CanvasFeatures --out data/json/las_gxpsy/ --clientConfig '{"description" : "note", "label" : "name,id", "color" : "blue " }' --metadata '{"description": "CDS from NCBI Refseq", "category": "General" }' --urltemplate "http://www.ncbi.nlm.nih.gov/sutils/blink.cgi?pid={name}"

# create assembly tracks
# NA

# index names
bin/generate-names.pl -v --out data/json/las_gxpsy/

