#!/bin/sh

# Surya Saha
# Purpose: setup LAS psy62 in sftp://surya@hlbws.sgn.cornell.edu/var/www/html/jbrowse/JBrowse-1.11.4/data/json/las_psy62

set -u #exit if uninit var
set -o nounset
set -o errexit

# cleanup
rm -rf data/json/las_psy62

# load refs and data source
bin/prepare-refseqs.pl --fasta ~/work/jbrowse_setup/las_psy62/NC_012985.3.fa --out data/json/las_psy62/

# create annotation tracks
bin/flatfile-to-json.pl --gff ~/work/jbrowse_setup/las_psy62/NC_012985.gbrowse.gff3 --type gene  --trackLabel gene --urltemplate "http://www.ncbi.nlm.nih.gov/protein?term={name}" --key "Genes from NCBI RefSeq" --trackType CanvasFeatures --out data/json/las_psy62/ --clientConfig '{"description" : "note", "label" : "name,id", "color" : "yellow" }'
bin/flatfile-to-json.pl --gff ~/work/jbrowse_setup/las_psy62/NC_012985.gbrowse.gff3 --type CDS  --trackLabel CDS --urltemplate "http://www.ncbi.nlm.nih.gov/sutils/blink.cgi?pid={name}" --key "CDS reading frames from NCBI RefSeq with links to top BLAST hits using NCBI Blink" --trackType CanvasFeatures --out data/json/las_psy62/ --clientConfig '{"description" : "note", "label" : "parent", "color" : "blue" }'

bin/flatfile-to-json.pl --gff ~/work/jbrowse_setup/las_psy62/NC_012985.gbrowse.gff3 --type MetPathway  --trackLabel MetPathway --urltemplate "http://www.genome.jp/dbget-bin/www_bget?las:{name}" --key "Metabolic Pathway predictions with links to KEGG" --trackType CanvasFeatures --out data/json/las_psy62/ --clientConfig '{ "label" : "name,id", "color" : "orange" }'
bin/flatfile-to-json.pl --gff ~/work/jbrowse_setup/las_psy62/NC_012985.gbrowse.gff3 --type mat_peptide  --trackLabel mat_peptide --urltemplate "http://citrusgreening.org/HLB-genome-resources.html#SignalPeptides" --key "SignalP 4.1 and LipoP 1.0 predictions of cleaved mature peptides for a protein" --trackType CanvasFeatures --out data/json/las_psy62/ --clientConfig '{"description" : "note", "label" : "name,id", "color" : "orange" }'
bin/flatfile-to-json.pl --gff ~/work/jbrowse_setup/las_psy62/NC_012985.gbrowse.gff3 --type Loc_PSORTb  --trackLabel Loc_PSORTb --urltemplate "http://db.psort.org/browse/genome/sequence?version=3.00&dataset=c&refseq={name}" --key "PSORTb subcellular localization predictions with links to PSORTb website" --trackType CanvasFeatures --out data/json/las_psy62/ --clientConfig '{"description" : "note", "label" : "name,id", "color" : "orange" }'
bin/flatfile-to-json.pl --gff ~/work/jbrowse_setup/las_psy62/NC_012985.gbrowse.gff3 --type repeat  --trackLabel repeat --key "RepeatMasker and RepeatScout predictions" --trackType CanvasFeatures --out data/json/las_psy62/ --clientConfig '{"description" : "description", "label" : "name,id", "color" : "green" }'
bin/flatfile-to-json.pl --gff ~/work/jbrowse_setup/las_psy62/NC_012985.gbrowse.gff3 --type Nick_Grishin  --trackLabel Nick_Grishin --urltemplate "http://prodata.swmed.edu/congqian/{name}.html" --key "Protein annotations from Nick Grishin's lab" --trackType CanvasFeatures --out data/json/las_psy62/ --clientConfig '{"label" : "name,id", "color" : "orange" }'
bin/flatfile-to-json.pl --gff ~/work/jbrowse_setup/las_psy62/NC_012985.gbrowse.gff3 --type LSO_BlastHit  --trackLabel LSO_BlastHit --key "Unique regions in LAS when compared to LSO" --trackType CanvasFeatures --out data/json/las_psy62/ --clientConfig '{"label" : "note", "color" : "orange" }' 
bin/flatfile-to-json.pl --gff ~/work/jbrowse_setup/las_psy62/NC_012985.gbrowse.gff3 --type GeneExpr  --trackLabel GeneExpr --urltemplate "http://onlinelibrary.wiley.com/doi/10.1111/mpp.12015/abstract" --key "Gene expression data from Yan et al. 2013" --trackType CanvasFeatures --out data/json/las_psy62/ --clientConfig '{"description" : "note", "label" : "name,id", "color" : "violet" }'

# create assembly tracks
# NA

# index names
bin/generate-names.pl --out data/json/las_psy62/ -v


