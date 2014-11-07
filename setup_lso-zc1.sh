#!/bin/sh

# Surya Saha
# Purpose: setup LSO ZC1 phage in sftp://surya@hlbws.sgn.cornell.edu/var/www/html/jbrowse/JBrowse-1.11.4/data/json/lso_zc1

set -u #exit if uninit var
set -o nounset
set -o errexit

# cleanup
rm -rf data/json/lso_zc1

# load refs and data source
bin/prepare-refseqs.pl --fasta ~/work/jbrowse_setup/lso/NC_014774.1.fa --out data/json/lso_zc1
printf "[general]\ndataset_id = lso_zc1\n" > data/json/lso_zc1/tracks.conf

# create annotation tracks
bin/flatfile-to-json.pl --gff ~/work/jbrowse_setup/lso/NC_014774.gbrowse.gff3  --type gene  --trackLabel gene --key "Genes" --trackType CanvasFeatures --out data/json/lso_zc1/ --clientConfig '{"label" : "name,id", "color" : "yellow" }' --metadata '{"description": "Genes from NCBI Refseq with links to NCBI Protein DB", "category": "General" }' --urltemplate "http://www.ncbi.nlm.nih.gov/protein?term={name}" --config '{"menuTemplate" : [{"label" : "View details",}, {"label" : "Highlight this gene"}, {"label" : "Ask NCBI about {name}", "iconClass" : "dijitIconDatabase", "action" : "newWindow", "url" : "http://www.ncbi.nlm.nih.gov/protein?term={name}"}, {"label" : "Ask EMBL about {name}", "iconClass" : "dijitIconDatabase", "action" : "newWindow", "url" : "http://www.ebi.ac.uk/ebisearch/search.ebi?db=proteinSequences&t={name}"}, {"label" : "Ask Google about {name}", "action" : "newWindow", "iconClass" : "dijitIconDatabase", "url" : "http://www.google.com/search?q={name}"}] }'

bin/flatfile-to-json.pl --gff ~/work/jbrowse_setup/lso/NC_014774.gbrowse.gff3 --type CDS --trackLabel CDS  --key "CDS" --trackType CanvasFeatures --out data/json/lso_zc1/ --clientConfig '{"description" : "note", "label" : "name,id", "color" : "blue" }' --metadata '{"description": "CDS from NCBI Refseq with links to NCBI Blast", "category": "General" }' --urltemplate "http://www.ncbi.nlm.nih.gov/sutils/blink.cgi?pid={name}"

bin/flatfile-to-json.pl --gff ~/work/jbrowse_setup/lso/NC_014774.gbrowse.gff3 --type COG --trackLabel COG  --key "COG" --trackType CanvasFeatures --out data/json/lso_zc1/ --clientConfig '{"description" : "note", "label" : "name,id", "color" : "orange" }' --metadata '{"description": "COGS from NCBI with links to NCBI CDD", "category": "Prediction" }' --urltemplate "http://www.ncbi.nlm.nih.gov/cdd/?term={name}"

bin/flatfile-to-json.pl --gff ~/work/jbrowse_setup/lso/NC_014774.gbrowse.gff3 --type LAS_BlastHit --trackLabel LAS_BlastHit  --key "LAS BlastHit" --trackType CanvasFeatures --out data/json/lso_zc1/ --clientConfig '{"label" : "note", "color" : "orange" }' --metadata '{"description": "Unique regions in LSO when compared to LAS with NCBI Blast Eval 1e-5", "category": "Prediction" }'

bin/flatfile-to-json.pl --gff ~/work/jbrowse_setup/lso/NC_014774.gbrowse.gff3 --type Loc_PSORTb --trackLabel Loc_PSORTb  --key "PSORTb subcellular localization" --trackType CanvasFeatures --out data/json/lso_zc1/ --clientConfig '{"description" : "note", "label" : "name,id", "color" : "orange" }' --metadata '{"description": "Subcellular localization predictions with links to PSORTb website", "category": "Prediction" }' --urltemplate "http://db.psort.org/browse/genome/sequence?version=3.00&dataset=c&refseq={name}"

bin/flatfile-to-json.pl --gff ~/work/jbrowse_setup/lso/NC_014774.gbrowse.gff3 --type MetPathway --trackLabel MetPathway  --key "Metabolic Pathways" --trackType CanvasFeatures --out data/json/lso_zc1/ --clientConfig '{"label" : "name,id", "color" : "orange" }' --metadata '{"description": "Metabolic pathway predictions with links to KEGG", "category": "Prediction" }' --urltemplate "http://www.genome.jp/dbget-bin/www_bget?lso:{name}" --config '{"menuTemplate" : [{"label" : "View details",}, {"label" : "Highlight this gene"}, {"label" : "Ask KEGG about {name}", "iconClass" : "dijitIconDatabase", "action" : "newWindow", "url" : "http://www.genome.jp/dbget-bin/www_bget?lso:{name}"}, {"label" : "Ask BioCyc about {name}", "iconClass" : "dijitIconDatabase", "action" : "newWindow", "url" : "http://biocyc.org/LSOL658172/NEW-IMAGE?type=GENE-IN-PWY&object={name}"}] }'

bin/flatfile-to-json.pl --gff ~/work/jbrowse_setup/lso/NC_014774.gbrowse.gff3 --type repeat:RepeatMasker --trackLabel RepeatMasker  --key "RepeatMasker repeats" --trackType CanvasFeatures --out data/json/lso_zc1/ --clientConfig '{"description" : "note", "label" : "name", "color" : "green" }' --metadata '{"description": "Repeats from RepeatMasker", "category": "Prediction" }'

bin/flatfile-to-json.pl --gff ~/work/jbrowse_setup/lso/NC_014774.gbrowse.gff3 --type repeat:RepeatScout --trackLabel RepeatScout  --key "RepeatScout repeats" --trackType CanvasFeatures --out data/json/lso_zc1/ --clientConfig '{"description" : "note", "label" : "name", "color" : "green" }' --metadata '{"description": "Ab-initio repeats from RepeatDcout", "category": "Prediction" }'

# create assembly tracks
# NA

# index names
bin/generate-names.pl -v --out data/json/lso_zc1/


