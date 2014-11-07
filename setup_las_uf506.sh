#!/bin/sh

# Surya Saha
# Purpose: setup LAS UF506 phage in sftp://surya@hlbws.sgn.cornell.edu/var/www/html/jbrowse/JBrowse-1.11.4/data/json/las_uf506

set -u #exit if uninit var
set -o nounset
set -o errexit

# cleanup
rm -rf data/json/las_uf506

# load refs and data source
bin/prepare-refseqs.pl --fasta ~/work/jbrowse_setup/las_uf506/HQ377374.fa --out data/json/las_uf506
printf "[general]\ndataset_id = las_uf506\n" > data/json/las_uf506/tracks.conf                                 

# create annotation tracks
bin/flatfile-to-json.pl --gff ~/work/jbrowse_setup/las_uf506/HQ377374.gbrowse.gff3  --type gene  --trackLabel gene --key "Genes" --trackType CanvasFeatures --out data/json/las_uf506/ --clientConfig '{"label" : "name,id", "color" : "yellow" }' --metadata '{"description": "Genes from NCBI Refseq with links to NCBI Protein DB", "category": "General" }' --urltemplate "http://www.ncbi.nlm.nih.gov/protein?term={name}" --config '{"menuTemplate" : [{"label" : "View details",}, {"label" : "Highlight this gene"}, {"label" : "Ask NCBI about {name}", "iconClass" : "dijitIconDatabase", "action" : "newWindow", "url" : "http://www.ncbi.nlm.nih.gov/protein?term={name}"}, {"label" : "Ask EMBL about {name}", "iconClass" : "dijitIconDatabase", "action" : "newWindow", "url" : "http://www.ebi.ac.uk/ebisearch/search.ebi?db=proteinSequences&t={name}"}, {"label" : "Ask Google about {name}", "action" : "newWindow", "iconClass" : "dijitIconDatabase", "url" : "http://www.google.com/search?q={name}"}] }'

bin/flatfile-to-json.pl --gff ~/work/jbrowse_setup/las_uf506/HQ377374.gbrowse.gff3 --type CDS --trackLabel CDS  --key "CDS" --trackType CanvasFeatures --out data/json/las_uf506/ --clientConfig '{"description" : "note", "label" : "name,id", "color" : "blue" }' --metadata '{"description": "CDS from NCBI Refseq with links to NCBI Blast", "category": "General" }' --urltemplate "http://www.ncbi.nlm.nih.gov/sutils/blink.cgi?pid={name}"

bin/flatfile-to-json.pl --gff ~/work/jbrowse_setup/las_uf506/HQ377374.gbrowse.gff3 --type repeat:RepeatScout --trackLabel RepeatScout  --key "RepeatScout repeats" --trackType CanvasFeatures --out data/json/las_uf506/ --clientConfig '{"description" : "note", "label" : "name,id", "color" : "green" }' --metadata '{"description": "ab-initio repeats predicted by RepeatScout", "category": "Prediction" }'

bin/flatfile-to-json.pl --gff ~/work/jbrowse_setup/las_uf506/HQ377374.gbrowse.gff3 --type repeat:RepeatMasker --trackLabel RepeatMasker  --key "RepeatMasker repeats" --trackType CanvasFeatures --out data/json/las_uf506/ --clientConfig '{"description" : "note", "label" : "name,id", "color" : "green" }' --metadata '{"description": "RepeatMasker matches to known repeats in RepBase", "category": "Prediction" }'


# create assembly tracks
# NA

# index names
bin/generate-names.pl --out data/json/las_uf506/ -v


