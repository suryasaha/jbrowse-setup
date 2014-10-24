#!/bin/sh

# Surya Saha
# Purpose: setup LAS PW_SP in sftp://surya@hlbws.sgn.cornell.edu/var/www/html/jbrowse/JBrowse-1.11.4/data/json/las_PW_SP

set -u #exit if uninit var
set -e #exit if non-zero return value (error), use command || {echo 'command failed'; exit 1;}
set -o nounset
set -o errexit

#cleanup
rm -rf data/json/las_PW_SP

# load refs
bin/prepare-refseqs.pl --fasta ~/work/jbrowse_setup/las_PW_SP/LamPW_SP.fa --out data/json/las_PW_SP/
printf "[general]\ndataset_id = las_PW_SP\n" > data/json/las_PW_SP/tracks.conf                                 
bin/flatfile-to-json.pl --gff ~/work/jbrowse_setup/las_PW_SP/LAM_PW_SP.gbrowse.gff3 --type gene  --trackLabel gene --key "Genes" --trackType CanvasFeatures --out data/json/las_PW_SP/ --clientConfig '{"description" : "note,description", "label" : "id", "color" : "yellow" }' --metadata '{"description": "Genes from RAST annotation.", "category": "General" }'
