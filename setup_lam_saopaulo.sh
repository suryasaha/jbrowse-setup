#!/bin/sh

# Surya Saha
# Purpose: setup LAM Sao Paulo in sftp://surya@hlbws.sgn.cornell.edu/var/www/html/jbrowse/JBrowse-1.11.4/data/json/lam_saopaulo

set -u #exit if uninit var
set -o nounset
set -o errexit

# cleanup
rm -rf data/json/lam_saopaulo

# load refs and data source
bin/prepare-refseqs.pl --fasta ~/work/jbrowse_setup/lam_saopaulo/NC_022793.1.fa --out data/json/lam_saopaulo      
printf "[general]\ndataset_id = lam_saopaulo\n" > data/json/lam_saopaulo/tracks.conf                                 

# create annotation tracks
bin/flatfile-to-json.pl --gff ~/work/jbrowse_setup/lam_saopaulo/NC_022793.gbrowse.gff3 --type gene  --trackLabel gene --key "Genes" --trackType CanvasFeatures --out data/json/lam_saopaulo/ --clientConfig '{ "label" : "name,id", "color" : "yellow" }' --metadata '{"description": "Genes from NCBI Refseq with links to NCBI Protein", "category": "General" }' --urltemplate "http://www.ncbi.nlm.nih.gov/protein?term={name}" --config '{"menuTemplate" : [{"label" : "View details",}, {"label" : "Highlight this gene"}, {"label" : "Ask NCBI about {name}", "iconClass" : "dijitIconDatabase", "action" : "newWindow", "url" : "http://www.ncbi.nlm.nih.gov/protein?term={name}"}, {"label" : "Ask EMBL about {name}", "iconClass" : "dijitIconDatabase", "action" : "newWindow", "url" : "http://www.ebi.ac.uk/ebisearch/search.ebi?db=proteinSequences&t={name}"}, {"label" : "Ask Google about {name}", "action" : "newWindow", "iconClass" : "dijitIconDatabase", "url" : "http://www.google.com/search?q={name}"}] }'

bin/flatfile-to-json.pl --gff ~/work/jbrowse_setup/lam_saopaulo/NC_022793.gbrowse.gff3 --type CDS --trackLabel CDS  --key "CDS" --trackType CanvasFeatures --out data/json/lam_saopaulo/ --clientConfig '{"description" : "note", "label" : "name,id", "color" : "blue" }' --metadata '{"description": "CDS from NCBI Refseq with links to NCBI Blink", "category": "General" }' --urltemplate "http://www.ncbi.nlm.nih.gov/sutils/blink.cgi?pid={name}"

# create assembly tracks
# NA

# index names
bin/generate-names.pl --out data/json/lam_saopaulo/ -v

