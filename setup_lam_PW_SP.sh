#!/bin/sh

# Surya Saha
# Purpose: setup LAS PW_SP in sftp://surya@hlbws.sgn.cornell.edu/var/www/html/jbrowse/JBrowse-1.11.4/data/json/las_PW_SP

set -u #exit if uninit var
set -o nounset
set -o errexit

# cleanup
rm -rf data/json/las_PW_SP

# load refs and data source
bin/prepare-refseqs.pl --fasta ~/work/jbrowse_setup/las_PW_SP/LamPW_SP.fa --out data/json/las_PW_SP/
printf "[general]\ndataset_id = las_PW_SP\n" > data/json/las_PW_SP/tracks.conf                                 

# create annotation tracks
bin/flatfile-to-json.pl --gff ~/work/jbrowse_setup/las_PW_SP/LAM_PW_SP.gbrowse.gff3 --type gene  --trackLabel gene --key "Genes" --trackType CanvasFeatures --out data/json/las_PW_SP/ --clientConfig '{"description" : "note,description", "label" : "id", "color" : "yellow" }' --metadata '{"description": "Genes from RAST annotation.", "category": "General" }'
bin/flatfile-to-json.pl --gff ~/work/jbrowse_setup/las_PW_SP/LAM_PW_SP.gbrowse.gff3 --type CDS  --trackLabel CDS  --key "CDS" --trackType CanvasFeatures --out data/json/las_PW_SP/ --clientConfig '{"description" : "note,description", "label" : "name,id", "color" : "blue" }' --metadata '{"description": "CDS from RAST annotation.", "category": "General" }'
bin/flatfile-to-json.pl --gff ~/work/jbrowse_setup/las_PW_SP/LAM_PW_SP.gbrowse.gff3 --type mat_peptide  --trackLabel mat_peptide --key "Mature peptides" --trackType CanvasFeatures --out data/json/las_PW_SP/ --clientConfig '{"description" : "note", "label" : "name,id", "color" : "orange" }' --metadata '{"description": "SignalP 4.1 and LipoP 1.0 predictions of cleaved mature peptides for a protein", "category": "Predictions" }'

# create assembly tracks
bin/flatfile-to-json.pl --gff ~/work/jbrowse_setup/las_PW_SP/LAM_PW_SP.gbrowse.gff3 --type contig  --trackLabel contig --key "Contigs" --trackType CanvasFeatures --out data/json/las_PW_SP/ --clientConfig '{"description" : "note,description", "label" : "name,id" }' --metadata '{"description": "Contigs from Genbank in the pseudomolecule", "category": "General" }' --config '{ "glyph": "JBrowse/View/FeatureGlyph/ProcessedTranscript" }' 
bin/flatfile-to-json.pl --gff ~/work/jbrowse_setup/las_PW_SP/LAM_PW_SP.gbrowse.gff3 --type gap  --trackLabel gap --key "TIGR linker" --trackType CanvasFeatures --out data/json/las_PW_SP/ --clientConfig '{"description" : "note,description", "label" : "name,id" }' --metadata '{"description": "TIGR linker joining contigs from Genbank in the pseudomolecule", "category": "General" }' --config '{ "glyph": "JBrowse/View/FeatureGlyph/ProcessedTranscript" }'

# index names
bin/generate-names.pl -v --out data/json/las_PW_SP/


