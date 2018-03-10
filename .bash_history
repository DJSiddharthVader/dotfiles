curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/order/id/12111523/rel/families/rel/genera/rel/species/rel/strains" -g -X GET | jq
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/order/id/12111523/rel/families/rel/genera/rel/species/rel/strains/rel" -g -X GET | jq
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/order/rel/families/rel/genera/rel/species/rel/strains/rel" -g -X GET | jq
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/strains/rel" -g -X GET | jq
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model" -g -X GET | jq
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/sample" -g -X GET | jq
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/sample/to" -g -X GET | jq
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/samples/rel -g -X GET | jq
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/samples/rel" -g -X GET | jq
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/sample/rel" -g -X GET | jq
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/sample/rel/sequences/count" -g -X GET | jq
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/sample/rel" -g -X GET | jq
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/sample/rel/sequences/rel" -g -X GET | jq
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/sample/rel/sequences/rel/clusters/count" -g -X GET | jq
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/sample/properties" -g -X GET | jq
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/sample/properties/location" -g -X GET | jq
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/strains/properties" -g -X GET | jq
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model" -g -X GET | jq
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/strain/properies" -g -X GET | jq
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/strain/properties" -g -X GET | jq
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/strain/properties/tax_id" -g -X GET | jq
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/strain/properties/tax_id/count" -g -X GET | jq
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/strain/count" -g -X GET | jq
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/strain/properties/tax_id?limit=99999" -g -X GET > strainIDs_240118SR.json
ipython
ls
\rm srainNoPerOrderw 
head strainIDs_240118SR.json 
ls
ipython
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/strain/properties/tax_id?limit=999999" -g -X GET > strainIDs_240118SR.json
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/strain/count" -g -X GET > strainIDs_240118SR.json
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/species/sproperties" -g -X GET > strainIDs_240118SR.json
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model" -g -X GET | jq
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/strain/document" -g -X GET | jq
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model" -g -X GET | jq
ls
wc -l strainIDs_240118SR.json 
wc strainIDs_240118SR.json 
cat strainIDs_240118SR.json 
\rm strainIDs_240118SR.json
ls
head order
head orderKingdom.tsv 
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/order/filter/to/all_strains[min]=1" -g -X GET | jq
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/order/filter/all_strains[min]=1" -g -X GET | jq
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/order/filter/" -g -X GET | jq
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/order/filter/related_samples[min]=1" -g -X GET | jq
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/order/filter/related_samples" -g -X GET | jq
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/order/filter/related_samples/count" -g -X GET | jq
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/order/filter/related_samples[min]=1" -g -X GET | jq
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/order/filter/related_samples?[min]=1" -g -X GET | jq
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/order/filter/related_samples?[min]=1/count" -g -X GET | jq
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/order/filter/related_samples/count?[min]=1" -g -X GET | jq
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/strain/rel" -g -X GET | jq
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/strain/properties/id" -g -X GET | jq
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/strain/properties/tax_id?limit=100000" -g -X GET > strainIDs_240118SR.json
ls
ipython
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/strain/id/264426460/rel" -g -X GET > strainIDs_240118SR.json
cat strainIDs_240118SR.json 
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/strain/properties/tax_id?limit=100001" -g -X GET > strainIDs_240118SR.json
wc strainIDs_240118SR.json 
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/strain/id/264426460/rel" -g -X GET | jq .
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/strain/id/264426460/rel/samples" -g -X GET | jq .
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/strain/id/264426460/rel/samples/count" -g -X GET | jq .
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/strain/id/264426460/rel/samples/rel" -g -X GET | jq .
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/strain/id/264426460/rel/samples/rel/sequences/rel" -g -X GET | jq .
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/strain/id/264426460/rel/samples/rel/sequences/rel/clusters/count" -g -X GET | jq .
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/strain/id/264426460/rel/samples/rel/sequences/rel/clusters/rel" -g -X GET | jq .
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/strain/id/264426460/rel/samples/rel/sequences/rel/clusters/to" -g -X GET | jq .
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/strain/id/264426460/rel/samples/rel/sequences/rel/clusters/to/domains/count" -g -X GET | jq .
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/strain/id/264426460/rel/samples/rel/sequences/rel/clusters/properties" -g -X GET | jq .
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/strain/id/264426460/rel/samples/rel/sequences/rel/clusters/properties/contig" -g -X GET | jq .
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model" -g -X GET | jq .
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model" -g -X GET | jless
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/strain/id/264426460/rel/samples/rel/sequences/rel/clusters/properties/name" -g -X GET | jq .
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/clusters/name/383937350" -g -X GET | jq .
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/cluster/name/383937350" -g -X GET | jq .
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model" -g -X GET 
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/cluster" -g -X GET 
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/cluster/name/383937350" -g -X GET 
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/cluster/properties" -g -X GET 
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/cluster/name?limit=2" -g -X GET 
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/cluster/properties/name?limit=2" -g -X GET 
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/cluster/properties/name/253310609" -g -X GET 
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/cluster/id/253310609" -g -X GET 
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/cluster/id/253310609" -g -X GET | jless
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/cluster/id/253310609/rel" -g -X GET | jless
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/cluster/id/253310609/to" -g -X GET | jless
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/cluster/id/253310609/to/domains/count" -g -X GET | jless
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/cluster/id/253310609/to" -g -X GET | jq
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/strain/id/264426460/rel/" -g -X GET | jq .
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/strain/id/264426460/rel/genus/rel" -g -X GET | jq .
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/strain/id/264426460/rel/genus/rel/species/rel" -g -X GET | jq .
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/strain/id/264426460/rel/genus/rel" -g -X GET | jq .
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/strain/id/264426460/rel/genus/rel/family" -g -X GET | jq .
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/strain/id/264426460/rel/genus/rel" -g -X GET | jq .
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/strain/id/264426460/rel/genus/rel/family/rel" -g -X GET | jq .
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/strain/id/264426460/rel/genus/rel/family/rel/order" -g -X GET | jq .
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/strain/id/397452118/rel/genus/rel/family/rel/order" -g -X GET | jq .
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/strain/id/264426460/rel/genus/rel/family/rel/order" -g -X GET | jq .
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/strain/id/264466890/rel/genus/rel/family/rel/order" -g -X GET | jq .
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/strain/id/2644668/rel/genus/rel/family/rel/order" -g -X GET | jq .
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/strain/id/264466890/rel/genus" -g -X GET | jq .
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/strain/id/264466890/rel" -g -X GET | jq .
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/strain/id/264466890" -g -X GET | jq .
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/strain/id/264466890/rel" -g -X GET | jq .
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/strain/id/264466890/rel/genus" -g -X GET | jq .
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/strain/id/264466890/rel/species" -g -X GET | jq .
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/strain/id/264466890/rel/species/rel" -g -X GET | jq .
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/strain/id/264466890/rel/species/rel/genus" -g -X GET | jq .
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/strain/id/264466890/rel/species/rel/genus/rel/family/rel/order" -g -X GET | jq .
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/strain/id/264466890/rel/species/rel/genus/rel/family/rel/order/properties" -g -X GET | jq .
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/strain/id/264466890/rel/species/rel/genus/rel/family/rel/order/properties/name" -g -X GET | jq .
ls
head order
head orderTaxIDs.json 
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/order/id/12076925/to" -g -X GET | jq .
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/order/id/12076925/to/all_strains/count" -g -X GET | jq .
ls
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/order/id/12076925/to/all_strains" -g -X GET | jq .
mkdir orderStrains
ls
mv orderStrains/ orderStrains_240118/
ls
head orderTaxIDs.json 
python scripts/getorderStrains.py 
ls
python scripts/getorderStrains.py 
ls orderStrains_240118/
cat orderStrains_240118/O12076925Strains24118SR.json 
python scripts/getorderStrains.py 
ls
head order
head orderKingdom.tsv 
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/order/filter" -g -X GET | jq .
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/order/filter/name=bacteriodes" -g -X GET | jq .
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/bio_class/filter/name" -g -X GET | jq .
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/bio_class/filter" -g -X GET | jq .
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/bio_class" -g -X GET | jq .
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/bio_class/properties" -g -X GET | jq .
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/name" -g -X GET | jq .
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model" -g -X GET | jq .
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model" -g -X GET | jless
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/class/properties" -g -X GET | jless
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/class/filter" -g -X GET | jless
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/class/filter/name" -g -X GET | jless
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/class/id/12076929/properties" -g -X GET | jless
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/class/id/12076929/properties/rel" -g -X GET | jless
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/class/id/12076929/rel" -g -X GET | jq
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/class/id/12076929/to" -g -X GET | jq
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/class/id/12076929/to/all_strains/count" -g -X GET | jq
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/class/id/12076929/to/all_strains/rel" -g -X GET | jq
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/class/id/12076929/to/all_strains/to" -g -X GET | jq
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/class/id/12076929/to/all_samples/rel" -g -X GET | jq
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/class/id/12076929/to/all_samples/to" -g -X GET | jq
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/class/id/12076929/to/all_samples/to/clusters/count" -g -X GET | jq
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/class/id/12076929/properties/name" -g -X GET | jq
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/class/id/12076929/to/all_samples/to/clusters" -g -X GET > shingoClusters.json
ipython
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/class/id/12076929/to/all_samples/to/clusters?limit=99999" -g -X GET > shingoClusters.json
ipython
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/class/id/12076929/to/all_samples/document" -g -X GET > shingoClusters.json
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/class/id/12076929/to" -g -X GET > shingoClusters.json
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/class/id/12076929/to/all_samples/to/clusters?limit=99999" -g -X GET > shingoClusters.json
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/class/id/12076929/to/all_samples/to" -g -X GET | jq
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/class/id/12076929/to/all_samples/rel" -g -X GET | jq
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/class/id/12076929/to/all_samples/document" -g -X GET | jq
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/class/id/12076929/to/all_samples/properties" -g -X GET | jq
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/class/id/12076929/to/all_samples" -g -X GET > shingoSamples.json
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/class/id/12076929/to/all_samples/properties" -g -X GET | jq
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/class/id/12076929/ro" -g -X GET | jq
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/class/id/12076929/to" -g -X GET | jq
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/class/id/12076929/to/all_families" -g -X GET > sphingoFamilies.json
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/class/id/12076929/to/all_families?limit=99999" -g -X GET > sphingoFamilies.json
ipython 
ls
ipython
ls
ls orderStrains_240118/ | head
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/strain/id/180060696/to" -g -X GET | jq
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/order/to" -g -X GET | jq
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/order/to/all_samples/count" -g -X GET | jq
mkdir orderSamples_240118
python scripts/getorderStrains.py 
ls orderSamples_240118/
ipython
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/sample/id/242796023/properties" -g -X GET | jq
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/sample/id/242796023/to" -g -X GET | jq
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/sample/id/242796023/to/clusters/count" -g -X GET | jq
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/sample/id/184393106/to/clusters/count" -g -X GET | jq
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/sample/id/184393106/to/clusters" -g -X GET | jq
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/cluster/id/184393107/to/domains/count" -g -X GET | jq
python scripts/getOrderData.py 
python scripts/getKingdomForOrder.py 
ls orderSamples_240118/O12081065Samples24118SR.json 
python scripts/getKingdomForOrder.py 
cat orderKingdom_25118SR.tsv 
vi orderKingdom_25118SR.tsv
python scripts/getKingdomForOrder.py 
vi orderKingdom_25118SR.tsv
python scripts/getKingdomForOrder.py 
vi orderKingdom_25118SR.tsv
python scripts/getKingdomForOrder.py 
vi orderKingdom_25118SR.tsv
ls
cd ../../../
cd diversityRanking/
ls
ls moleculeData/
ls
ls clusterData/
ls
ls scripts/
cd scripts/
ls
\rm cluster-tc-matrix.R getSmiles.py make-tc-matrix.R 
cd ../
ls
cd smilesData/
ls
cd ..
\rm -rf smilesData/
ls
cd clusterData/
cat * | wc -l
ls | wc -l
cd ..
ls
mkdir oldData
mv moleculeData/ clusterData/ oldData/
ls
cd oldData/
ls
cd ..
ls
cd scripts/
ls
ls ../
scp reeds@magarveylab-gw.mcmaster.ca:~/strain_ordering/sidStuff/diversityRanking/orderMolsDict.json ./
man scp
man sftp
sftp reeds@magarveylab-gw.mcmaster.ca:~/strain_ordering/sidStuff/diversityRanking/orderMolsDict.json ./
scp -p 2207 reeds@magarveylab-gw.mcmaster.ca:~/strain_ordering/sidStuff/diversityRanking/orderMolsDict.json ./
scp -P 2207 reeds@magarveylab-gw.mcmaster.ca:~/strain_ordering/sidStuff/diversityRanking/orderMolsDict.json ./
ls
vi getKingdomForOrder.py
ls
cd //
cd ~/adapsyn/strain_ordering/sidStuff/diversityRanking/
ls
ls scripts/
vi scripts/getorderStrains.py 
cd ../../../
;s
ls
cd diversityRanking/
ls
scp -r orderSrmples_240118/ orderMolsDict.jso│  4 
scp -P 2207-r orderSrmples_240118/ orderMolsDict.json reeds@magarveylab-gw.mcmaster.ca:~/
scp -P 2207 -r orderSrmples_240118/ orderMolsDict.json reeds@magarveylab-gw.mcmaster.ca:~/
scp -P 2207 -r orderSamples_240118/ reeds@magarveylab-gw.mcmaster.ca:~/
ls
\rm orderKingdom_25118SR.tsv 
ls
cd ../../
ls
cd ../
cd diversityRanking/
ls
python scripts/getKingdomForOrder.py 
python scripts/getKingdomForOrder.py > orderStrainInfo_250118SR.tsv
python scripts/getKingdomForOrder.py 
ls
python scripts/3dPlotOfOrderInfo.py 
vi orderKingdom_25118SR.tsv 
\rm *.sw*
\rm *.swp

\rm .orderKingdom_25118SR.tsv.swp 
python scripts/3dPlotOfOrderInfo.py 
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/order/id/12076925/to" -g -X GET | jq .
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/order/id/12076925/document" -g -X GET | jq .
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/order/id/12076925/report" -g -X GET | jq .
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/order/id/12076925/report/taxonomy_information" -g -X GET | jq .
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/order/id/12076925/rel" -g -X GET | jq .
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/order/id/12076925/to" -g -X GET | jq .
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/order/id/12076925/properties" -g -X GET | jq .
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/order/id/12076925/parts" -g -X GET | jq .
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/order/id/12076925/traversal" -g -X GET | jq .
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/order/id/12076925/to" -g -X GET | jq .
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/order/id/12076925/to/small_molecules/to" -g -X GET | jq .
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/order/id/12076925/to/small_molecules/rel" -g -X GET | jq .
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/order/id/12076925/to/small_molecules/document" -g -X GET | jq .
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/order/id/12076925/to/small_molecules/document/tanimoto_similarity_scores" -g -X GET | jq .
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/order/id/12076925/to/small_molecules/document/similarity_scores" -g -X GET | jq .
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/order/id/12076925/to/small_molecules/document" -g -X GET | jq .
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/order/id/12076925/to/small_molecules" -g -X GET | jq .
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/order/id/12076925/to/small_molecules/count" -g -X GET | jq .
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/order/id/12076925/to/small_molecules/report" -g -X GET | jq .
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/order/id/12081065/to/small_molecules/report" -g -X GET | jq .
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/order/id/12081065/to/small_molecules/document/tanimoto_similarity_scores" -g -X GET | jq .
python scripts/getOrderData.py > tanimotoScores.json
python scripts/getOrderSi > tanimotoScores.json
python scripts/getOrderSimilarityData.py > tanimotoScores.json
cat tanimotoScores.json | sort -u
cat tanimotoScores.json | grep -c 'not_found'
vi tanimotoScores.json 
\rm tanimotoScores.json 
ls
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/order/id/12081065/to/small_molecules/rel -g -X GET | jq .
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/order/id/12081065/to/small_molecules/rel" -g -X GET | jq .
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/order/id/12081065/to/small_molecules/rel/similarity_values" -g -X GET | jq .
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/order/id/12081065/to/small_molecules/rel/similarity_values/count" -g -X GET | jq .
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/order/id/12081065/to/small_molecules/rel/similarity_values/count" -g -X GET > testSim.json
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/order/id/12081065/to/small_molecules/rel/similarity_values" -g -X GET > testSim.json
ipython
ls
head orderMolsDict.json 
\rm orderMolsDict.json
ls
\rm orderKingdom.tsv 
ls
\rm testSim.json 
ls
mkdir orderMols_250118
python scripts/getOrderMolData.py 
ls
ls orderMols_250118/ | wc -l
mkdir orderTanimotos_250118
python scripts/getOrderMolData.py 
ls scripts/
\rm scripts/getOrderSimilarityData.py 
python scripts/getOrderMolData.py 
ls
cd ..
ls
cd taxStuff/
ls
cd ../../
ls
\rm traceBackTaxonomy.py 
cd taxStuff/
ls
\rm missingKings.tsv 
\rm fiii 
\rm duppedIDS.txt 
\rm taxOnlyRows.tsv 
ls
ls scripts/
vi scripts/allSmallMolTaxTsv.py 
cd ..
ls
cd taxStuff/
ls
ls jsons/
wc -l jsons/EVERYidToTaxNameDict.json 
ipython
ls
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/small_molecule/filter/related_produces_molecules/count?related_produces_molecules[min]=1" -g -X GET | jq .
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/small_molecule/filter/related_produces_molecules?related_produces_molecules[min]=1" -g -X GET > allMolsWithProducers.json
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/small_molecule/filter/related_produces_molecules?related_produces_molecules[min]=1&limit=99999" -g -X GET > allMolsWithProducers.json
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/small_molecule/to
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/small_molecule/to" -g -X GET | jq
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/small_molecule/document" -g -X GET | jq
ls
cd jsons/
ls
\rls
ls
cd ..
ls
\rm allMolsWithProducers.json 
ls
ls jsons/
wc -l jsons/spjsfullSmallMolTaxReports.json 
vi jsons/spjsfullSmallMolTaxReports.json
ls
\rm reeds@mserv.magarveylab.ca
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/small_molecule/properties/id/count" -g -X GET | jq
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/small_molecule/properties/id" -g -X GET | jq
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/small_molecule/properties" -g -X GET | jq
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/small_molecule/properties" -g -X GET | jless
grid
mserc
mserv
ls
cd cytoscape/
ls
cd sidStuff/
ls
cd diversityRanking/
ls
vi orderPickingTsv_260118SR.tsv 
cd adapsyn/strain_ordering/sidStuff/
ls
cd diversityRanking/
gis
git add bacteriaCluster.csv interestingOrderCluster.csv orderDistanceMatrix.tsv scripts/kMeansOrderClustering.py 
gis
git add orderCosDistanceMatrix.tsv scripts/makeOrderSimScoreMatrix.py 
ls
cd adapsyn/strain_ordering/
ls
cd sidStuff/
ls
cd lackingFullTaxonomyMolecules/
ls
cd taxStuff/
ls
cd jsons/
ls
wc -l spjsfullSmallMolTaxReports.json 
head EVERYidToTaxNameDict.json 
ls
ipython
ls
tail molsWithProducersspjs.json 
tail -1 molsWithProducersspjs.json 
vi molsWithProducersspjs.json
ipython
vi molsWithProducersspjs.json
tail -1 molsWithProducersspjs.json | jless
ipython
ls
wc -l spjsfullSmallMolTaxReports.json 
cd ../../../
cd massDiff/
ls
mkdir old
mv * old
ls
mv ~/Downloads/frag-pairs_tani0.6_same-genus_mass-diff_290118.zip ./
ls
gzip -d frag-pairs_tani0.6_same-genus_mass-diff_290118.zip
unzip frag-pairs_tani0.6_same-genus_mass-diff_290118.zip
wc -l frag-pairs_tani0.6_same-genus_mass-diff_290118.
wc -l frag-pairs_tani0.6_same-genus_mass-diff_290118.tsv 
head -1 frag-pairs_tani0.6_same-genus_mass-diff_290118.
head -1 frag-pairs_tani0.6_same-genus_mass-diff_290118.tsv
cd cytoscape/
vi cytoscape.py 
cd cytoscape/
ls
vi sample_network.
vi sample_network.txt 
cd sidStuff/diversityRanking/
ls
vi interestingNames.txt
ls
\rm names.txt 
libreoffice csvs/bacteriaClusteri_300118SR.csv 
ls
cd orderMols_250118/
ls
head O12099289Mols.json 
ipython 
ls
ipython 
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/small_molecule/id/18639635/properties" -g -X GET | jless
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/small_molecule/id/18639635/properties" -g -X GET > moldata
grep internal moldata
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/strain/properties" -g -X GET > moldata
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/strain/properties" -g -X GET | jless
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/strain/filter/internal_usage/count?internal_usage=True" -g -X GET | jless
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/strain/filter/internal_usage/count?internal_usage=True" -g -X GET > ../internalStrains.json
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/strain/filter/internal_usage?internal_usage=True&limit=9999" -g -X GET > ../internalStrains.json
cd ..
cd ~/Documents/
cd coop/
ls
cd adapsyn/strain_ordering/sidStuff/diversityRanking/
ls
\rm interestingNames.txt 
gis
git checkout -- scripts/3dPlotOfOrderInfo.py
gis
git commit bacteriaCluster.csv interestingOrderCluster.csv -m "clustering results on the order data"
git commit orderCosDistanceMatrix.tsv orderDistanceMatrix.tsv -m "cos distance had issues, switched to euc distance"
git commit scripts/makeOrderSimScoreMatrix.py  -m "changed cos distance to euclidian distance, still room for debate, but lots of 0's"
git commit scripts/kMeansOrderClustering.py -m 'kmeans clustering of the order data from scikitlearn'
gis
git push
ls
cd ..
cd lackingFullTaxonomyMolecules/
ls
ipython
ls
cat fullSmallMolTaxReportsspjs.json 
sudo apt-get install docker
sudo apt-get install -y nodejs
vi ~/.bashrc
rs
cd sidStuff/diversityRanking/
ls
vi scripts/makeOrderSimScoreMatrix.py 
ls
vi scripts/kMeansOrderClustering.py 
ls
mkdir orderDataDirs
mv orderMols_250118/ orderSamples_240118/ orderTanimotos_250118/ orderStrains_240118/ orderDataDirs/
ls
mv boc_300118SR.csv  csvs/
ls
mv familyIDs.json jsons/
ls
ls oldData/
\rm -rf oldData/
ls
head internalStrains.json 
ls
ipython
ls
mkdir resolveInternalStrains
mv internalStrains.json resolveInternalStrains/
cd resolveInternalStrains/
ls
mkdir sc
\rm -rf sc
mkdir scripts
vi scripts/getTaxInfo.py
cd sidStuff/
ls
cd diversityRanking/
ls
cd resolveInternalStrains/
ls
python scripts/getTaxInfo.py 
rs
cd sidStuff/
ls
cd diversityRanking/
ls
python scripts/makeOrderSimScoreMatrix.py 
ls
head ../lackingFullTaxonomyMolecules/taxStuff/jsons/spjsfullSmallMolTaxReports.json 
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/small_molecule/filter/activity_clean/count?activity_clean=GROWTH_PROMOTER" -g -X GET | jq
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/small_molecule/filter/action/count?activity_effect=''" -g -X GET | jq
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/small_molecule/filter" -g -X GET | jq
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/small_molecule/filter" -g -X GET | jless
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/small_molecule/filter/related_actions/count" -g -X GET | jless
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/small_molecule/filter/related_actions/count?activity_effect=''" -g -X GET | jq
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/small_molecule/filter/related_actions/count?activity_effect='PROMOTES BIOLOGICAL ACTIVITY'" -g -X GET | jq
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/small_molecule/filter/related_actions/count?activity_effect='PROMOTES\ BIOLOGICAL\ ACTIVITY'" -g -X GET | jq
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/small_molecule/filter/related_actions/count?activity_effect='PROMOTES_BIOLOGICAL_ACTIVITY'" -g -X GET | jq
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/small_molecule/filter/related_actions?activity_effect='PROMOTES_BIOLOGICAL_ACTIVITY'/count" -g -X GET | jq
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/small_molecule/filter" -g -X GET | jq
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/small_molecule/filter/activity" -g -X GET | jq
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model" -g -X GET | jq
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model" -g -X GET | jless
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/action/filter" -g -X GET | jless
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/action/filter/activity_effect" -g -X GET | jless
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/action/filter/activity_effect/count" -g -X GET | jless
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/action/filter/activity_effect/count?activity_effect=promotes biological activity" -g -X GET | jq
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/action/filter/activity_effect/count?activity_effect=promotes_biological_activity" -g -X GET | jq
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/action/filter/activity_effect/count?activity_effect=PROMOTES_BIOLOGICAL_ACTIVITY" -g -X GET | jq
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/action/filter/activity_effect/count?activity_effect='PROMOTES_BIOLOGICAL_ACTIVITY'" -g -X GET | jq
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/action/filter/activity_effect/count?activity_effect=null" -g -X GET | jq
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/action/filter/activity_effect/count?activity_effect!=null" -g -X GET | jq
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/action/filter/activity_effect/" -g -X GET | jq
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/action/filter/activity_effect/INHIBITS BIOLOGICAL ACTIVITY" -g -X GET | jq
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/action/filter/activity_effect/'INHIBITS BIOLOGICAL ACTIVITY'" -g -X GET | jq
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/action/filter/activity_effect/'INHIBITS_BIOLOGICA_ACTIVITY" -g -X GET | jq
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/action/filter/activity_effect/count?activity_effect='INHIBITS_BIOLOGICA_ACTIVITY" -g -X GET | jq
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/action/filter/activity_effect/count?activity_effect=='INHIBITS_BIOLOGICA_ACTIVITY" -g -X GET | jq
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/action/filter/activity_effect/count" -g -X GET | jq
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/action/filter/activity_effect/count?activity_effect!='INHIBITS_BIOLOGICA_ACTIVITY" -g -X GET | jq
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/action/filter/activity_effect/count?activity_effect[max]=0 -g -X GET | jq
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/action/filter/activity_effect/count?activity_effect[max]=0" -g -X GET | jq
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/action/filter/activity_effect/count?activity_effect[val]=0" -g -X GET | jq
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/action/filter/activity_effect/count?activity_effect" -g -X GET | jq
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/action/filter/activity_effect/count?activity_effect=" -g -X GET | jq
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/action/filter/activity_effect/count?activity_effect=""" -g -X GET | jq
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/action/filter/activity_effect/count?activity_effect="INHIBITS_BIOLOGICA_ACTIVITY"" -g -X GET | jq
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/action/filter/activity_effect/count?activity_effect="INHIBITS BIOLOGICAL ACTIVITY"" -g -X GET | jq
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/action/filter/activity_effect/count?activity_effect="INHIBITS_BIOLOGICAL_ACTIVITY"" -g -X GET | jq
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/action/filter/activity_effect/count?activity_effect="INHIBITS\ BIOLOGICAL\ ACTIVITY"" -g -X GET | jq
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/action/filter/activity_effect/count?activity_effect="INHIBITS BIOLOGICAL ACTIVITY"" -g -X GET | jq
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/action/filter/activity_effect/count?ACTIVITY_EFFECT="INHIBITS BIOLOGICAL ACTIVITY"" -g -X GET | jq
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/action/filter/ACTIVITY_EFFECT/count?ACTIVITY_EFFECT="INHIBITS BIOLOGICAL ACTIVITY"" -g -X GET | jq
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/action/filter/activity_effect/count?activity_effect="PROMOTES BIOLOGICAL ACTIVITY"" -g -X GET | jq
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/small_molecules/count/pull/{"to.activities":["name"]"} -g -X GET | jq
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/small_molecule/count/pull/{"to.activities":["name"]"} -g -X GET | jq
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/small_molecule/pull/{"to.activities":["name"]"} -g -X GET | jq
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/small_molecule/pull/"to.activities":["name"]" -g -X GET | jq
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/activity/filter/ -g -X GET | jq
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/activity/filter/"-g -X GET | jq
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/activity/filter/count" -g -X GET | jq
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/activity/filter/" -g -X GET | jq
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/activity/filter/name/count?name='null'" -g -X GET | jq
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/activity/properties/name" -g -X GET | jq
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/activity/filter/name/count?name=Algea" -g -X GET | jq
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/activity/filter/name?ame=Algea" -g -X GET | jq
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/activity/filter/name?name=Algea" -g -X GET | jq
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/activity/filter/name?name=Algea/rel" -g -X GET | jq
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/activity/filter/name?name=Euaryote/rel" -g -X GET | jq
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/activity/filter/name/count?name=Euaryote" -g -X GET | jq
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/activity/count" -g -X GET | jq
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/activity" -g -X GET | jq
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/activity/properties/name" -g -X GET | jless
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/activity/filter/name/count?name=Bacteria" -g -X GET | jless
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/activity/filter/name/count?name=Bacteria/rel" -g -X GET | jless
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/activity/rel" -g -X GET | jless
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/small_molecule/filter" -g -X GET | jless
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/small_molecule/filter/activity" -g -X GET | jless
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/small_molecule/pull" -g -X GET | jless
python scripts/makeOrderSimScoreMatrix.py 

libreoffice orderCosDistanceMatrix.tsv
python scripts/makeOrderSimScoreMatrix.py 
libreoffice orderCosDistanceMatrix.tsv
python scripts/makeOrderSimScoreMatrix.py 
libreoffice orderCosDistanceMatrix.tsv
python scripts/makeOrderSimScoreMatrix.py 
libreoffice orderCosDistanceMatrix.tsv
python scripts/makeOrderSimScoreMatrix.py 
libreoffice orderCosDistanceMatrix.tsv
python scripts/makeOrderSimScoreMatrix.py 
libreoffice orderCosDistanceMatrix.tsv
python scripts/makeOrderSimScoreMatrix.py 
libreoffice orderCosDistanceMatrix.tsv
python scripts/makeOrderSimScoreMatrix.py 
libreoffice orderCosDistanceMatrix.tsv
python scripts/makeOrderSimScoreMatrix.py 
libreoffice orderCosDistanceMatrix.tsv
python scripts/makeOrderSimScoreMatrix.py 
libreoffice orderCosDistanceMatrix.tsv
python scripts/makeOrderSimScoreMatrix.py 
\rm orderCosDistanceMatrix.tsv 
ls
\rm orderCosDistanceMatrix.tsv 
python scripts/makeOrderSimScoreMatrix.py 
ls
python orderClusterHeatMap.py 
sudo pip install hclust
sudo pip install hcluster
ls
libreoffice orderDistanceMatrix.tsv
ls
\rm orderClusterHeatMap.py 
python scripts/kMeansOrderClustering.py 
ipython
python scripts/kMeansOrderClustering.py 
ls
head orderDistanceMatrix.tsv 
python scripts/kMeansOrderClustering.py 
ls
python scripts/kMeansOrderClustering.py 
libreoffice orderCluster.csv 
python scripts/kMeansOrderClustering.py 
libreoffice orderCluster.csv 
python scripts/kMeansOrderClustering.py 
libreoffice orderCluster.csv 
python scripts/kMeansOrderClustering.py 
libreoffice orderCluster.csv 
python scripts/kMeansOrderClustering.py 
libreoffice orderCluster.csv 
python scripts/kMeansOrderClustering.py 
libreoffice orderCluster.csv 
mv orderCluster.csv fungiBacetriaClusters.csv
python scripts/kMeansOrderClustering.py 
ls
\rm fungiBacetriaClusters.csv 
python scripts/kMeansOrderClustering.py 
libreoffice bacteriaCluster.csv 
vi interestingNames.txt
libreoffice bacteriaCluster.csv 
vi interestingNames.txt
libreoffice bacteriaCluster.csv 
grep -f interestingNames.txt orderPickingTsv_260118SR.tsv 
grep -f interestingNames.txt orderPickingTsv_260118SR.tsv > interestingCluster.csv
libreoffice interestingCluster.csv 
\rm interestingCluster.csv 
cat interestingNames.txt 
grep -cf interestingNames.txt orderPickingTsv_260118SR.tsv 
cat orderPickingTsv_260118SR.tsv | cut -f2 | head
cat orderPickingTsv_260118SR.tsv | cut -f1 | head
cat orderPickingTsv_260118SR.tsv | cut -f3 | head
cat orderPickingTsv_260118SR.tsv | cut -f1 | grep -f interestingNames.txt 
cat orderPickingTsv_260118SR.tsv | cut -f1 | grep -f interestingNames.txt | wc -l
cat interestingNames.txt 
grep Pasteurellales orderPickingTsv_260118SR.tsv 
grep NoNameWasFound5  orderPickingTsv_260118SR.tsv 
grep NoNameWasFound5\t  orderPickingTsv_260118SR.tsv 
grep -P NoNameWasFound5\t  orderPickingTsv_260118SR.tsv 
grep -P 'NoNameWasFound5\t'  orderPickingTsv_260118SR.tsv 
cat orderPickingTsv_260118SR.tsv | cut -f1 | grep -f interestingNames.txt | wc -l
grep -f interestingNames.txt orderPickingTsv_260118SR.tsv 
grep -f interestingNames.txt orderPickingTsv_260118SR.tsv | wc -l
vi interestingNames.txt 
grep -f interestingNames.txt orderPickingTsv_260118SR.tsv | wc -l
grep -f interestingNames.txt orderPickingTsv_260118SR.tsv > interestingOrderCluster.csv
libreoffice bacteriaCluster.csv 
ls
mv orderDistanceMatrix.tsv orderDistanceMatrix.csv 
ls
mv orderKingdom_25118SR.tsv orderKingdom_25118SR.csv
mv bacteriaCluster.csv bacteriaOrderCluster_300118SR.csv 
mv interestingOrderCluster.csv interestingOrderCluster_300118SR.csv 
ls
mv orderPickingTsv_260118SR.tsv orderPickingTsv_260118SR.csv 
mkdir csvs
mv *.csv csvs
ls
python scripts/kMeansOrderClustering.py 
python scripts/kMeansOrderClustering.py >names.txt
vi names.txt 
grep -f names.txt csvs/orderPickingTsv_260118SR.csv > onlyclustered.csv
wc -l onlyclustered.csv 
vi onlyclustered.csv 
libreoffice csvs/interestingOrderCluster_300118SR.csv 
cd csvs/
ls
\rm bacteria*
cd ..
python scripts/kMeansOrderClustering.py 
python scripts/kMeansOrderClustering.py > names.txt
grep -f names.txt csvs/orderPickingTsv_260118SR.csv > orders.csv
libreoffice 
libreoffice orders.csv 
sudo pip install rdkit
sudo apt-get install rdkit
sudo apt-get install python-rdkit librdkit1 rdkit-data
ls
head -1 csvs/orderPickingTsv_260118SR.csv > boc_300118SR.csv
cat csvs/interestingOrderCluster_300118SR.csv >> boc_300118SR.csv 
cat boc_300118SR.csv 
head -1 boc_300118SR.csv 
libreoffice boc_300118SR.csv 
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/strains/to -X GET | jless
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/strains/to" -X GET | jless
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/strain/to" -X GET | jq
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/strain/report" -X GET | jq
ls
cd resolveInternalStrains/
ls
python scripts/getTaxInfo.py 
ls 
python scripts/getTaxInfo.py 
ipython 
python scripts/getTaxInfo.py 
cat inHouseTaxReports.json 
python scripts/getTaxInfo.py > taxreports.json
cat taxreports.json 
python scripts/getTaxInfo.py 
ls
\rm taxreports.json 
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/strain/report/taxonomy_information/count" -X GET | jq
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/strain/count" -X GET | jq
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/strain/report/" -X GET | jq
python scripts/getTaxInfo.py 
acti
python scripts/getTaxInfo.py 
deac
ls
python scripts/getTaxInfo.py 
sudo pip install nmutils
python scripts/getTaxInfo.py 
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/strain/id/318833104" -X GET | jq
python scripts/getTaxInfo.py 
vi inHouseTaxReports.json 
python scripts/getTaxInfo.py 
vi inHouseTaxReports.json 
python scripts/getTaxInfo.py 
vi inHouseTaxReports.json 
python scripts/getTaxInfo.py 
ipython
ls
head inHouseStrainsWOTax.json 
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/strain/id/590379560" -X GET | jq
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/strain/id/590379560/report" -X GET | jq
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/strain/id/590379560/report/taxonomy_information" -X GET | jq
ls
python scripts/getTaxInfo.py 
ls
python scripts/getTaxInfo.py 
head inHouseTaxReports.json 
python scripts/getTaxInfo.py 
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/strain/id/590379560/report/taxonomy_information" -X GET | jq
python scripts/getTaxInfo.py 
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/strain/ids/590379560,590379562,590379613,590379615,590456663,590456629,590379595,590456626,590456622,590379603,590379609,590379598,590379606,590379600,590379611,590519139,590519136,590519142,590519185,590519177,590519179,590519182,590519187,590519175,590520630,590519119,590520279,590528268,590528264,590528261,590528266,590528271,590519159,590519169,590519166,590528275,590528283,590528299/pull" -X POST -d '["id", "report.taxonomy_information"]' | jq
vi scripts/getTaxInfo.py 
cd Downloads/
ls
mv sequence.txt Nostoc_sp._UHCC_0450_swinholide_gene_cluster.fna
mv sequence.gb Anabaena_sp._UHCC_0451_scytopycin_gene_cluster.gbk
\rm Anabaena_sp._UHCC_0451_scytopycin_gene_cluster.gbk 
mv sequence.fasta Anabaena_sp._UHCC_0451_scytopycin_gene_cluster.fna
cd ../nmutils/
ls
cd nmutils/
ls
vi oliveutils.py 
cd Downloads/
ls
pdf Preview_Yonggang_Ke,_Pengfei_Wang_eds._3D_DNA_Nanostructure_Methods_and_Protocols.pdf 
\rm Preview_Yonggang_Ke,_Pengfei_Wang_eds._3D_DNA_Nanostructure_Methods_and_Protocols.pdf
grid
ls
tmux ls
cd adapsyn/
ls
tmux ls
cd strain_ordering/
cd sidStuff/
cd ..
tmux -2 
tmux ls
tmux -2
cd sidStuff/diversityRanking/
ls
cd resolveInternalStrains/
ls
ipython
ls
ipython
ls
\rm inHouseStrainsWOTax.json 
mkdir jsons
mv *.json jsons/
ls
ipython
ls
cd ..
ls
cd orderDataDirs/orderStrains_240118/
ipython 
ls
cd ..
ls
cd ..
ls
cd getGoldStrains/
ls
cd ../weightedTaxonomyMatching/
ls
ipython
cd adapsyn/strain_ordering/sidStuff/diversityRanking/
ls
ipython
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/kingdom/count" -g -X GET | jless
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/kingdom/count" -g -X GET | jq
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model" -g -X GET | jq
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/strain/id/264426460" -g -X GET | jq .
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/kingdom/count" -g -X GET | jq .
cd adapsyn/
ls
cd strain_ordering/
ls
cd sidStuff/diversityRanking/
ls
libreoffice csvs/orderPickingTsv_260118SR.csv 
ls
ls orderDataDirs/
ls orderDataDirs/orderStrains_240118/ | head
vi scrap
ls
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/strain" -g -X GET | jq .
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/strain/tp" -g -X GET | jq .
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/strain/to" -g -X GET | jq .
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/strain/ids//to/small_molecules/count" -g -X GETw | jq .
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/strain/ids/233638518,51390054/to/small_molecules/count" -g -X GET | jq .
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/strain/id/233638518/to/small_molecules/count" -g -X GET | jq .
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/strain/ids/166543571,148361503,250298193/to/small_molecules/count" -g -X GET | jq .
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/strain/ids/167335039,309404953,165072128/to/small_molecules/count" -g -X GET | jq .
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/strain/ids/167335039,309404953,165072128/rel/small_molecules -g -X GET | jq .
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/strain/ids/167335039,309404953,165072128/rel/small_molecules" -g -X GET | jq .
cd adapsyn/strain_ordering/sidStuff/lackingFullTaxonomyMolecules/
ls
ls oldStuff/
wc -l oldStuff/fullSmallMolTaxReports.json 
spjs oldStuff/fullSmallMolTaxReports.json 
ls
wc -l fullSmallMolTaxReportsspjs.json 
head fullSmallMolTaxReportsspjs.json 
vi fullSmallMolTaxReportsspjs.json 
ls
cd ..
ls
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/small_molecule/properties" -g -X GET | jless
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/small_molecule/to" -g -X GET | jq
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/small_molecule/report" -g -X GET | jq
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/small_molecule/document" -g -X GET | jq
ls
cd lackingFullTaxonomyMolecules/
ls
mv familyIDs.json ../diversityRanking/
ls
cd ..
cd sidStuff/massDiff/
gis
git add frag-pairs_tani0.6_same-genus_mass-diff_290118.zip old/ -m 'mass differece data from chris'
gic frag-pairs_tani0.6_same-genus_mass-diff_290118.zip old/ -m 'mass differece data from chris'
gis
git commit clusterByTanimoto.py graphBasedClustering/* -m 'moved to old folder'
gis
gi reset HEAD frag-pairs_tani0.6_same-genus_mass-diff_290118.tsv
git reset HEAD frag-pairs_tani0.6_same-genus_mass-diff_290118.tsv
gis
lls
ls
ls
cd sidStuff/
ls
cd diversityRanking/
ls
gis
git commit add -a
git commit add -A
git add -A
gis
git reset HEAD ../strainLib/*
gis
ls
\rm ../orderKingdom_25118SR.tsv 
gis
git add ../orderKingdom_25118SR.tsv 
gis
git commit orderKingdom_25118SR.tsv orderPickingTsv_260118SR.tsv orderCosDistanceMatrix.tsv -m "various tsv with strain picking information"
gis
git commit 3dPlot.png -m "3d plot of all orders on the axes # molecules. # strains and # cluster with >10 domains" 
gis
git commit orderTaxIDs.json scripts/getMoleculesPerOrder.py  scripts/getOrderData.py -m "got rid of some old files"
gis
git commit scripts/getKingdomForOrder.py scripts/getorderStrains.py -m "renamed files to better indicate what they do"
gis
\rm scripts/.*.swp
\rm scripts/.addTanimotoToTsv.py.swo scripts/.getKingdomForOrder.py.swn 
gis
git add scripts/.getKingdomForOrder.py.swn 
gis
git commit scripts/3dPlotOfOrderInfo.py -m "script to generate 3d plot of order data"
gis
git commit scripts/addTanimotoToTsv.py -m "adds avg tanimoto data to orderInfo tsv"
git commit scripts/calcAvgTanimotoOrderScores.py -m "calculates avg tanimoto scores for all molecule pairs in an order" 
git commit scripts/generateOrderInfoTsv.py -m "builds the tsv with relevant info for each order"
gis
git commit scripts/getorderSamples.py 
git commit scripts/getorderSamples.py -m 'get the data for each sample in an order"
'
git commit scripts/getOrderTanimotoData.py -m 'get raw tanimoto data for each order' 
git commit scripts/makeOrderSimScoreMatrix.py  -m 'calcualte cosine distance between each order, to be used for clustering'
gis
git commit -m scripts/buildOrderNetworkGraph.py -m 'creates network graph of how similar the orders are to eachother, not finished' 
git commit ../lackingFullTaxonomyMolecules/taxStuff/scripts/allSmallMolTaxTsv.py -m 'trying out some new things to make it more efficient/better' 
gis
git push
gis
gi add csvs/
git add csvs/
gis
git add scripts/kMeansOrderClustering.py 
git add -a
git add -A
gis
ls 
\rm names.txt orders.csv onlyclustered.csv 
git add -A
gis
git reset HEAD ../strainLib/*
gis
git gis
gis
git commit *.sv -m 'reorganized the csv/tsv data'
git commit *sv -m 'reorganized the csv/tsv data'
gis
git commit scripts/kMeansOrderClustering.py -m 'minor changes to output file names'
gis
git push
gis
git add weightedTaxonomyMatching/ resolveInternalStrains/
gis
git add ../lackingFullTaxonomyMolecules/taxStuff/scripts/getFullTaxReports.py 
gis
git add getGoldStrains/
gis
git commit weightedTaxonomyMatching/scripts/matchScoring.py -m "script to score strains based on how related taxonomically they are to 'good' (for novel product discovery) strains"
gis
git commit ../lackingFullTaxonomyMolecules/taxStuff/scripts/getFullTaxReports.py -m 'minor rewirtting to try and make the code cleaner'
gis
git add resolveInternalStrains/*
gis
git add resolveInternalStrains/missedstrains.csv  resolveInternalStrains/outrows.csv resolveInternalStrains/rowpairs.csv 
gis
git commit resolveInternalStrains/scripts/getTaxInfo.py resolveInternalStrains/scripts/strainToTsv.py -m 'scripts to make a tsv of all taxonomy for inhouse strains, for easy correction'
gis
git commit resolveInternalStrains/csvs/inHouseStrainTaxonomy_300118SR.csv -m 'tsv with all the taxonomy for inhouse strains'
gis
git commit getGoldStrains/scripts/*.py -m 'copied over here, to try and get strain level data for all strains in interesting orders from orderPicking'
gis
git checkout -- ../massDiff/frag-pairs_tani0.6_same-genus_mass-diff_290118.zip
gis
git push
cd sidStuff/diversityRanking/resolveInternalStrains/
ls
python scripts/getTaxInfo.py 
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/strain/ids/590379560,590379562,590379613,590379615,590456663,590456629,590379595,590456626,590456622,590379603,590379609,590379598,590379606,590379600,590379611,590519139,590519136,590519142,590519185,590519177,590519179,590519182,590519187,590519175,590520630,590519119,590520279,590528268,590528264,590528261,590528266,590528271,590519159,590519169,590519166,590528275,590528283,590528299/pull" -X POST -d '["id", "report.taxonomy_information"]' > missinTaxInfo.json
python scripts/getTaxInfo.py 
ls
ls jsons/
\rm jsons/missinTaxInfo.json jsons/inHouseTaxReports.json 
ls jsons/
mkdir csvs
python scripts/strainToTsv.py 
ls jsons/
python scripts/strainToTsv.py 
ls jsons/
python scripts/strainToTsv.py 
libreoffice csvs/inHouseStrainTaxonomy.csv 
python scripts/strainToTsv.py 
libreoffice csvs/inHouseStrainTaxonomy.csv 
python scripts/strainToTsv.py 
libreoffice csvs/inHouseStrainTaxonomy.csv 
python scripts/strainToTsv.py 
libreoffice csvs/inHouseStrainTaxonomy.csv 
python scripts/strainToTsv.py 
libreoffice csvs/inHouseStrainTaxonomy.csv 
python scripts/strainToTsv.py 
libreoffice csvs/inHouseStrainTaxonomy.csv 
python scripts/strainToTsv.py 
libreoffice csvs/inHouseStrainTaxonomy.csv 
python scripts/strainToTsv.py 
libreoffice csvs/inHouseStrainTaxonomy.csv 
python scripts/strainToTsv.py 
head csvs/inHouseStrainTaxonomy
head csvs/inHouseStrainTaxonomy_300118SR.csv 
grep MISSING csvs/inHouseStrainTaxonomy_300118SR.csv 
python scripts/strainToTsv.py 
grep MISSING csvs/inHouseStrainTaxonomy_300118SR.csv 
python scripts/strainToTsv.py 
grep MISSING csvs/inHouseStrainTaxonomy_300118SR.csv 
grep -c MISSING csvs/inHouseStrainTaxonomy_300118SR.csv 
wc -l csvs/inHouseStrainTaxonomy_300118SR.csv 
\rm csvs/inHouseStrainTaxonomy.csv 
ls
libreoffice csvs/inHouseStrainTaxonomy_300118SR.csv 
cut -f7 csvs/inHouseStrainTaxonomy_300118SR.csv | head
cut -f7 csvs/inHouseStrainTaxonomy_300118SR.csv | grep -c MISSING
grep -c MISSING csvs/inHouseStrainTaxonomy_300118SR.csv 
libreoffice csvs/inHouseStrainTaxonomy_300118SR.csv 
python scripts/strainToTsv.py 
libreoffice csvs/inHouseStrainTaxonomy_300118SR.csv 
grep -v MISSING csvs/inHouseStrainTaxonomy_300118SR.csv 
tail csvs/inHouseStrainTaxonomy_300118SR.csv 
cut -f7 csvs/inHouseStrainTaxonomy_300118SR.csv | head
cut -f7 csvs/inHouseStrainTaxonomy_300118SR.csv | grep -c MISSING
python scripts/strainToTsv.py 
tail csvs/inHouseStrainTaxonomy_300118SR.csv 
libreoffice csvs/inHouseStrainTaxonomy_300118SR.csv 
python scripts/strainToTsv.py 
libreoffice csvs/inHouseStrainTaxonomy_300118SR.csv 
wc -l csvs/inHouseStrainTaxonomy_300118SR.csv 
python scripts/strainToTsv.py 
wc -l csvs/inHouseStrainTaxonomy_300118SR.csv 
python scripts/strainToTsv.py 
wc -l csvs/inHouseStrainTaxonomy_300118SR.csv 
python scripts/strainToTsv.py 
wc -l csvs/inHouseStrainTaxonomy_300118SR.csv ~
python scripts/strainToTsv.py 
cut -f9 csvs/inHouseStrainTaxonomy_300118SR.csv 
python scripts/strainToTsv.py 
wc -l csvs/inHouseStrainTaxonomy_300118SR.csv 
python scripts/strainToTsv.py 
wc -l csvs/inHouseStrainTaxonomy_300118SR.csv 
grep -cv MISSING csvs/inHouseStrainTaxonomy_300118SR.csv 
python scripts/strainToTsv.py 
sudo pip install hashlib
python scripts/strainToTsv.py 
wc -l csvs/inHouseStrainTaxonomy_300118SR.csv 
python scripts/strainToTsv.py 
python scripts/strainToTsv.py > missedstrains.csv
vi missedstrains.csv
cut -f1 missedstrains.csv | sort -u > rowpairs.csv
cut -f2 missedstrains.csv | sort -u > outrows.csv
man paste
paste rowpairs.csv outrows.csv 
paste rowpairs.csv outrows.csv > missedstrains.csv 
vi missedstrains.csv 
ls
\rm rowpairs.csv  outrows.csv 
python scripts/strainToTsv.py > missedstrains.csv
python scripts/strainToTsv.py 
python scripts/strainToTsv.py > missedstrains.csv
cut -f1 missedstrains.csv | sort > rowpairs.csv
cut -f2 missedstrains.csv | sort > outrows.csv
paste rowpairs.csv outrows.csv > missedstrains.csv 
vi missedstrains.csv 
libreoffice missedstrains.csv 
python scripts/strainToTsv.py > missedstrains.csv
python scripts/strainToTsv.py 
libreoffice csvs/inHouseStrainTaxonomy_300118SR.csv 
cut -f7 csvs/inHouseStrainTaxonomy_300118SR.csv | head
cut -f7 csvs/inHouseStrainTaxonomy_300118SR.csv | uniq -c >checkDups.txt
vi checkDups.txt
cut -f8 csvs/inHouseStrainTaxonomy_300118SR.csv | head
cut -f8 csvs/inHouseStrainTaxonomy_300118SR.csv | uniq -c >checkDups.txt
vi checkDups.txt
python scripts/strainToTsv.py 
libreoffice csvs/inHouseStrainTaxonomy_300118SR.csv 
python scripts/strainToTsv.py 
libreoffice csvs/inHouseStrainTaxonomy_300118SR.csv 
cd ..
ls
ls orderDataDirs/
ls
ls csvs/
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/kingdom/count" -X GET | jq
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/phylum/count" -X GET | jq
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model" -X GET | jq
ls
cd weightedTaxonomyMatching/
ls
python scripts/matchScoring.py 
ls
ls ../resolveInternalStrains/csvs/inHouseStrainTaxonomy_300118SR.csv 
python scripts/matchScoring.py 
ls ~/Downloads/
mv ~/Downloads/INteresting_orders.js ./
ls
mv INteresting_orders.js goldStrains.csv
ls
cut -f1 goldStrains.csv > goldIDs.txt
cat goldIDs.txt
python scripts/matchScoring.py 
ls
\rm goldStrains.csv 
ls
python scripts/matchScoring.py 
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/phylum/count" -X GET | jq
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/class/count" -X GET | jq
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/order/count" -X GET | jq
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/family/count" -X GET | jq
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/genus/count" -X GET | jq
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/species/count" -X GET | jq
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/strain/count" -X GET | jq
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/strain/count?limit=9999999" -X GET | jq
12077017BacteriaChromatiales
12076930BacteriaSphingobacteriales
12078498BacteriaAeromonadales
12077139BacteriaOceanospirillales
12077177BacteriaPropionibacteriales
vi scrap
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/strain/rel" -X GET | jq
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/strain/ids/167335039,309404953,165072128,167195160,105796972,155896064,105796976,173443237,143533241,29754073/rel/small_molecules" -X GET | jq
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/strain/ids/167335039,309404953,165072128,167195160,105796972,155896064,105796976,173443237,143533241,29754073,105796978,247593978,105796974,190162384,165072480,179320385,105796970,167075225,143522995,148810561,573042602,573042922,105796980,105797057,143533166,105796984,155864179,105796852,253462931,105796850,105796968,105796848,16829871,102687833,165072483,573042602,204801240,105797059,19847185,105796988,167335127,105796832,246954789,179320508,21963930,247601757,240684665,223485852,174634365,155664090,31832129,31836883,54853753,179157728,157257345,105796846,199741065,156450297,221433367,29141604,242669251,238811192,248371897,163838771,201035691,15424898,185645824,206112718,208453605,166887625,238414631,159523317,244434853,244103214,243065187,238612054,236191723,173806898,149446825,217730301,206812241,187943701,186157143,102991682,35681075,28660145,28668517,35330108,28161978,40342791,13439534,251500539,251450327,246396774,245696533,242960147,236402375,159323006/rel/small_molecules" -X GET | jq
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/strain/ids/167335039,309404953,165072128,167195160,105796972,155896064,105796976,173443237,143533241,29754073,105796978,247593978,105796974,190162384,165072480,179320385,105796970,167075225,143522995,148810561,573042602,573042922,105796980,105797057,143533166,105796984,155864179,105796852,253462931,105796850,105796968,105796848,16829871,102687833,165072483,573042602,204801240,105797059,19847185,105796988,167335127,105796832,246954789,179320508,21963930,247601757,240684665,223485852,174634365,155664090,31832129,31836883,54853753,179157728,157257345,105796846,199741065,156450297,221433367,29141604,242669251,238811192,248371897,163838771,201035691,15424898,185645824,206112718,208453605,166887625,238414631,159523317,244434853,244103214,243065187,238612054,236191723,173806898,149446825,217730301,206812241,187943701,186157143,102991682,35681075,28660145,28668517,35330108,28161978,40342791,13439534,251500539,251450327,246396774,245696533,242960147,236402375,159323006/rel/small_molecules" -X GET > strainMols.json
ls
\rm strainMols.json goldIDs.txt 
ls
cd ..
ls
ls resolveInternalStrains/
cd resolveInternalStrains/
ls
\rm outrows.csv rowpairs.csv missedstrains.csv checkDups.txt 
ls
ls 
vi scripts/getTaxInfo.py 
ls
vi scripts/getTaxInfo.py 
cd ..
ls
mkdir weightedTaxonomyMatching
cd weightedTaxonomyMatching
ls
mkdir scripts
vi scripts/matchScoring.py
cd adapsyn/strain_ordering/sidStuff/
ls
cd massDiff/
ls
\rm frag-pairs_tani0.6_same-genus_mass-diff_290118.zip
mkdir scripts
vi scripts/calcMassDiffData.py
cd ..
;s
ls
cd diversityRanking/
ls
mkdir getGoldStrains
ls scripts/
cp -r scripts/ getGoldStrains/
cd getGoldStrains/
ls
ls scripts/
ls
cd sc
ls
ls scripts/
vi -p scripts/getorderSamples.py scripts/getOrderTanimotoData.py scripts/calcAvgTanimotoOrderScores.py scripts/generateOrderInfoTsv.py scripts/addTanimotoToTsv.py 
gis
git add buildOrderTsv/ resolveInternalStrains/csvs/inHouseStrainTaxonomy_300118SR_RMedits.csv
gis
git add csvs/ scripts/ weightedTaxonomyMatching/matchScoring.py
gis
git add -a
git add -A
gis
git reset HEAD ../strainLib/ ../massDiff/frag-pairs_tani0.6_same-genus_mass-diff_290118.tsv 
giss
gis
git add buildOrderTsv/csvs/.~lock.orderPickingTsv_260118SR.csv# buildOrderTsv/
gis
git commit scripts/* csvs/* buildOrderTsv/* -m 'reorganized some directories'
gis
git commit *.csv -m 'reorganized some directories'
gis
git commit buildOrderTsv/csvs/orderPickingTsv_020118SR.tsv  -m 'new tsv with more data for order picking'
gis
git commit buildOrderTsv/scripts/addInHouseToTsv.py -m 'adding # of inhouse strains for each order to csv'
gis
git commit weightedTaxonomyMatching/scripts/matchScoring.py -m 'fixing the script, realizing need tax data for all strains'
gis
git commit *.py -m 'moved to relevant directory'
gis
git reset HEAD orderDataDirs/orderMols_250118/moldata resolveInternalStrains/csvs/inHouseStrainTaxonomy_300118SR_RMedits.xlsx
gis
git push
ls
ls orderDataDirs/
ls
ls orderDataDirs/
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/strain//pull" -X POST -d '["id"]' > taxInfo.json
cat taxInfo.json 
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/strain//pull" -X POST -d '["id", "report.taxonomy_information"]' > taxInfo.json
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/strain/pull" -X POST -d '["id", "report.taxonomy_information"]' > taxInfo.json
cat taxInfo.json 
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/strain/pull?limit=100000" -X POST -d '["id"]' > taxInfo.json
cat taxInfo.json 
sed 's/},{/}\n{/g' taxInfo.json 
sed 's/},{/}\n{/g' taxInfo.json | grep -c id
cd ..
ls
cd nm
cd ..
cd nmutils/
ls
cd nmutils/
ls
cat *.py | less
cat *.py > allstuff
mv allstuff allstuff.py
vi allstuff.py
\rm allstuff.py 
ls
ls databases/
vi databases/__init__.py.example 
ls
ls unicycler/
ls csvs/
head csvs/boc_300118SR.csv 
wc -l csvs/boc_300118SR.csv
ls
ls csvs/
wc -l csvs/interestingOrderCluster_300118SR.csv 
head csvs/interestingOrderCluster_300118SR.csv
head csvs/boc_300118SR.csv 
ls
ls csvs/
\rm csvs/interestingOrderCluster_300118SR.csv 
ls
ls csvs/
ls
ls csvs/
head csvs/inHouseStrainTaxonomy_300118SR_RMedits.csv 
python scripts/addInHouseToTsv.py 
ls
python scripts/addInHouseToTsv.py 
head csvs/orderPickingTsv_020118SR.tsv 
python scripts/addInHouseToTsv.py 
ls
vi -p scripts/addTanimotoToTsv.py scripts/addInHouseToTsv.py
grid
ls
tmux -2
ls
cd adapsyn/strain_ordering/sidStuff/malariaMols/
ls
ls ../diversityRanking/buildOrderTsv/
mv ../diversityRanking/buildOrderTsv/alltargetOrganisms_020218SR.json ./
ls
ipython 
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/small_molecule/to" -X GET -g | jq .
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/small_molecule/rel/activities/" -X GET -g | jq .
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/small_molecule/rel" -X GET -g | jq .
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/small_molecule/rel/actions/properties" -X GET -g | jq .
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/small_molecule/id/21364732/rel/actions/properties/target_organism" -X GET -g | jq .
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/small_molecule/rel/actions/rel" -X GET -g | jq .
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/target_organism" -X GET -g | jq .
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/target_organism?limit=2" -X GET -g | jq .
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/actions/rel" -X GET -g | jq .
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/action/rel" -X GET -g | jq .
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/action/properties" -X GET -g | jq .
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/action/rel/" -X GET -g | jq .
ls
cat alltargetOrganisms_020218SR.json 
ls
mkdir scripts
vi scripts/getTargetSmallMolData.py
cd adapsyn/strain_ordering/sidStuff/
ls
cd diversityRanking/
ls
cd buildOrderTsv/
;s
ls
ls csvs/
grep Herpetosiphonales csvs/orderPickingTsv_020118SR.tsv 
grep Herpetosiphonales csvs/orderPickingTsv_260118SR.tsv 
grep Herpetosiphonales csvs/orderPickingTsv_260118SR.csv 
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/order/properties/name" -X GET -g | grep Herpetosiphonales
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/order/properties/name?limit=99999" -X GET -g | grep
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/order/properties/name?limit=99999" -X GET -g | grep Herpetosiphonales
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/order/properties/name?limit=99999" -X GET -g | grep -o Herpetosiphonales
ld
ls
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/activity/rel/actions/properties/target_organisms -X GET -g >  alltargetOrganisms_020218SR.json
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/activity/rel/actions/properties/target_organisms" -X GET -g >  alltargetOrganisms_020218SR.json
head alltargetOrganisms_020218SR.json 
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/activity/rel/actions/properties/target_organism" -X GET -g >  alltargetOrganisms_020218SR.json
head alltargetOrganisms_020218SR.json 
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/activity/rel/actions/properties/target_organism/count" -X GET -g >  alltargetOrganisms_020218SR.json
head alltargetOrganisms_020218SR.json 
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/activity/rel/actions/properties/target_organism?limit=99999" -X GET -g >  alltargetOrganisms_020218SR.json
head alltargetOrganisms_020218SR.json 
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/small_molecule/id/574283551" -X GET -g | jq.
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/small_molecule/id/574283551" -X GET -g | jq .
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/species/id/574281800" -X GET -g | jq .
ls
cd ..
cd ma
cd malariaMols/
ls
grep TUBERCULOSIS alltargetOrganisms_020218SR.json 
grep '"TUBERCULOSIS*" alltargetOrganisms_020218SR.json 
grep '"TUBERCULOSIS*"' alltargetOrganisms_020218SR.json 
grep '"TUBERCULOSIS.*"' alltargetOrganisms_020218SR.json 
grep 'TUBERCULOSIS.*"' alltargetOrganisms_020218SR.json 
grep -o 'TUBERCULOSIS.*"' alltargetOrganisms_020218SR.json 
grep -o 'TUBERCULOSIS.*?"' alltargetOrganisms_020218SR.json 
grep -o 'TUBERCULOSIS.*\?"' alltargetOrganisms_020218SR.json 
grep -P 'TUBERCULOSIS.*\?"' alltargetOrganisms_020218SR.json 
grep -P 'TUBERCULOSIS.*?"' alltargetOrganisms_020218SR.json 
grep -oP 'TUBERCULOSIS.*?"' alltargetOrganisms_020218SR.json 
grep -oP 'TUBERCULOSIS.*?"]' alltargetOrganisms_020218SR.json 
grep -oP 'TUBERCULOSIS.*?"], ' alltargetOrganisms_020218SR.json 
grep -oP 'TUBERCULOSIS.*?"],' alltargetOrganisms_020218SR.json 
grep -oP 'TUBERCULOSIS.*?"],[' alltargetOrganisms_020218SR.json 
grep -oP 'TUBERCULOSIS.*?"],\[' alltargetOrganisms_020218SR.json 
grep -oP 'CRYPTOSPORIDIUM.*?"],\[' alltargetOrganisms_020218SR.json 
grep -oP 'PLASMODIUM.*?"],\[' alltargetOrganisms_020218SR.json 
grep -oP 'PLASMODIUM.*?"],\[' alltargetOrganisms_020218SR.json | sort -u
ls
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/small_molecule/to" -X GET -g >  alltargetOrganisms_020218SR.json
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/small_molecule/to" -X GET -g 
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/small_molecule/to" -X GET -g | jq . 
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/small_molecule/to/activity_and_target/" -X GET -g | jq . 
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/small_molecule/to/activity_and_target" -X GET -g | jq . 
cat alltargetOrganisms_020218SR.json 
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/activity/rel/actions/properties/target_organism?limit=99999" -X GET -g >  alltargetOrganisms_020218SR.json
cat alltargetOrganisms_020218SR.json
ls
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/small_molecule/rel" -X GET -g | jq . 
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/small_molecule/rel/actions/rel" -X GET -g | jq . 
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/small_molecule/rel/actions/rel/targets/filter" -X GET -g | jq . 
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/small_molecule/rel/actions/rel/targets/filter/name?name=TUBERCULOSIS" -X GET -g | jq . 
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/small_molecule/rel/actions/rel/targets/filter/name?name=" -X GET -g | jq . 
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/small_molecule/rel/actions/rel/" -X GET -g | jq . 
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/small_molecule/rel/actions/properties" -X GET -g | jq . 
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/small_molecule/rel/actions/properties/target_organism/filter" -X GET -g | jq . 
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/small_molecule/rel/actions/properties/filter" -X GET -g | jq . 
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/small_molecule/rel/actions/filter" -X GET -g | jq . 
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/small_molecule/properties" -X GET -g | jq . 
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/small_molecule/properties/filter" -X GET -g | jq . 
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/small_molecule/filter" -X GET -g | jq . 
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/small_molecule/filter/target_organism?target_organism=TUBERCULOSIS" -X GET -g | jq . 
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/small_molecule/filter" -X GET -g | jless
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/small_molecule/filter/activity/rel/actions/" -X GET -g | jless
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/small_molecule/filter/activity/rel/actions/properties/target_organism?target_organism=TUBERCULOSIS" -X GET -g | jless
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/small_molecule/filter/target_organism?target_organism=TUBERCULOSIS" -X GET -g | jless
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/small_molecule/filter/action" -X GET -g | jless
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/small_molecule/pull?limit=2" -X POST -d '["id", "rel.actions.properties.target_organism"]' 
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/small_molecule/pull?limit=2" -X POST -d '["id", "rel.actions.target_organism"]' 
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/small_molecule/pull?limit=2" -X POST -d '["id", "rel.actions"]' 
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/small_molecule/pull?limit=2" -X POST -d '["id", "rel.actions.properties"]' 
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/small_molecule/pull?limit=2" -X POST -d '["id", "rel.actions.rel"]' 
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/action/pull?limit=2" -X POST -d '["target_organism", "rel.small_molecules"]' | jless 
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/action/pull?limit=99999" -X POST -d '["target_organism", "rel.small_molecules"]' > targetOrganismSmallMols_020218SR.json
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/action/count" -X GET -d | jless
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/action/count" -X GET -g | jq .
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/action/id?limit=2" -X GET -g | jq .
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/action/pull?limit=2" -X POST -d "['id']" | jq .
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/action/pull?limit=2" -X POST -d '['id']' | jq .
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/action/pull?limit=2" -X POST -d '["id"]' | jq .
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/action/pull?limit=99999" -X POST -d '["target_organism", "rel.small_molecules"]' > targetOrganismSmallMols_020218SR.json
lls
ls
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/action/pull?limit=2" -X POST -d '["id"]' > allActionIDs_020218SR.json
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/action/pull?limit=99999" -X POST -d '["id"]' > allActionIDs_020218SR.json
head allActionIDs_020218SR.json
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/action/pull?limit=99999" -X POST -d '["target_organism", "rel.small_molecule"]' > targetOrganismSmallMols_020218SR.json
cat targetOrganismSmallMols_020218SR.json 
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/action/pull?limit=99999" -X POST -d '["target_organism", "rel.small_molecules"]' > targetOrganismSmallMols_020218SR.json
python scripts/getTargetSmallMolData.py 
python scripts/getTargetSmallMolData.py | less
python scripts/getTargetSmallMolData.py 
s\ls
ls
scp allActionIDs_020218SR.json reeds@mserv.magarveylab.ca:~/strain_ordering/sidStuff/malariaMols/
alias grid
scp -P 2207 allActionIDs_020218SR.json reeds@magarveylab-gw.mcmaster.ca:~/strain_ordering/sidStuff/malariaMols/
mserv
ls
tmux -2
ls
cd adapsyn/strain_ordering/sidStuff/
ls
cd malariaMols/
mserv
ls
cd weightedTaxonomyMatching/
ls
vi scripts/matchScoring.py 
vi scripts/getTaxInfo.py 
ls
cd weightedTaxonomyMatching/
cp ../../lackingFullTaxonomyMolecules/getMolTaxData/strainTaxonomy_020218SR.csv ./
ls
python scripts/matchScoring.py 
head allStrainsTaxReports.json 
head allStrainsTaxReports.json | less
ls
python scripts/matchScoring.py 
ls
cd buildOrderTsv/
;s
ls
ls scripts/
ls
vi scripts/getOrderStrains.py 
cd buildOrderTsv/
ls
ls scripts/
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/order/to" -X GET -g | jq .
head orderTasxIDs.json
ls
head jsons/orderIDs.json 
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/order/ids/11892023,12115191/to" -X GET -g | jq .
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/order/ids/11892023,12115191/to/all_strains" -X GET -g | jq .
ls
mkdir ../orderDataDirs/orderStrains_020218
python scripts/getOrderStrains.py 
ls jsons/
python scripts/getOrderStrains.py 
ls
ls scripts/
python scripts/getOrderStrains.py 
ls
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/order/id?limit=2" -X GET -g | jq .
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/order//properties/id?limit=2" -X GET -g | jq .
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/order/properties/id?limit=2" -X GET -g | jq .
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/order/pull?limit=2" -X POST -d '["id"]' | jq .
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/order/pull?limit=99999999" -X POST -d '["id"]' > jsons/orderIDs.json
cat jsons/orderIDs.json
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/order/count" -X GET -g | jq .
python scripts/getOrderStrains.py 
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/order/to" -X GET -g | jq .
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/order/properties/id?limit=2" -X GET -g | jq .
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/order/properties/" -X GET -g | jq .
python scripts/getOrderStrains.py 
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/order/pull?limit=2" -X POST -d '["tax_id", "to.all_strains"]' | jq .
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/order/properties/" -X GET -g | jq .
python scripts/getOrderStrains.py 
gis
cd adapsyn/strain_ordering/sidStuff/
gis
git add diversityRanking/buildOrderTsv/scripts/getOrderStrains.py diversityRanking/weightedTaxonomyMatching/orderPickingWithTaxonomy_010218SR.csv diversityRanking/weightedTaxonomyMatching/strainTaxonomy_020218SR.csv lackingFullTaxonomyMolecules/getMolTaxData/* malariaMols/*
gis
git add diversityRanking/weightedTaxonomyMatching/scripts/matchScoring.py 
gis
git checkout -- -A
git checkout -- *
gis
git checkout -- lackingFullTaxonomyMolecules/**
git rm -A
git rm -r lackingFullTaxonomyMolecules/
gis
git checkout -r lackingFullTaxonomyMolecules/
git checkout -f lackingFullTaxonomyMolecules/
gis
git commit lackingFullTaxonomyMolecules/getMolTaxData/* -m 'scripts and csv for all taxonomy for strians and molecule producers
'
gis
git commit lackingFullTaxonomyMolecules/getMolTaxData/scripts/*.py -m 'scripts and csv for all taxonomy for strians and molecule producers
'
gis
git commit diversityRanking/buildOrderTsv/scripts/getOrderStrains.py -m 'script to get strains updated strains in each order'
gis
git commit diversityRanking/weightedTaxonomyMatching/scripts/matchScoring.py -m 'will score orders based on how taxonomically similar they are to "good" strains (for novel chemistry)'
gis
git commit malariaMols/scripts/getTargetSmallMolData.py -m 'get targets and related molecules for all actions'
gis
git commit diversityRanking/weightedTaxonomyMatching/*.csv -m 'updated orderPicking csv and now strain taxonomy csv, used in the scoring'
gis
git commit lackingFullTaxonomyMolecules/getMolTaxData/*.csv -m 'csvs with relevant data for molecule and strain taxonomy'
gis
git push
cd adapsyn/strain_ordering/sidStuff/malariaMols/
l;s
ls
ls
cd adapsyn/
cd si
cd strain_ordering/sidStuff/
ls
mkdir malariaMols
cd malariaMols
ls
cd adapsyn/strain_ordering/sidStuff/malariaMols/
ls
vi scripts/getTargetSmallMolData.py 
grid
ls
cd Documents/
ls
cd papers/
ld
cd igem/
ls
cd ..
ls
cd strain_ordering/
ls
cd natural_product_
cd natural_product_producers/
ls
vi -p *.py
ls
cd ..
cd sidStuff/
ls
cd diversityRanking/
ls
cd buildOrderTsv/
ls
ls scripts/
cd scripts/
vi generateOrderInfoTsv.py 
ls
cd Misc
ls
cd septikCompetition2018/
ls
tmux ls
vi ~/.tmux.conf
rs
ls
cd adapsyn/strain_ordering/sidStuff/
ls
cat pieChart/
ls pieChart/
\rm -rf pieChart/
ls
gis
git add pieChart 
gis
git commit pieChart -m 'removed old files'
gis
ls -a
cd ..
ls -a
vi .gitignore
gis
git add .gitignore 
ls
gis 
git commit .gitignore -m 'added .xlsx and some dirs with json files'
gis
git add -a
git add -A
gis
git reset HEAD
gis
ls 
cd sidStuff/
s
ls
cd diversityRanking/familyBarChart/
ls
python scripts/stackedBarPlot.py 
vi scripts/stackedBarPlot.py 
cd ~/adapsyn/strain_ordering/sidStuff/diversityRanking/familyBarChart/
ls
python scripts/betterStackedBarPlot.py 
ls
vi jsons/moleculeExample.json 
vi jsons/clusterExamply.json 
mserv
cd ~/adapsyn/strain_ordering/sidStuff/diversityRanking/
ls
cd familyBarChart/
ls
python scripts/betterStackedBarPlot.py 
python scripts/getFamilyData.py 
python scripts/betterStackedBarPlot.py 
cd ~
vi .bashrc
rs
ffile *.py get
ffile *.py 'get'
sudo apt-get cmus
sudo apt-get build-dep cmus
ls
cd Music/
ls
mkdir songs
mv * songs
ls
mv ~/Downloads/cmus-v2.3.3.tar.bz2 ./
ls
tar -xjf cmus-v2.3.3.tar.bz2
ls
cd cmus-v2.3.3/
ls
./configure
make
make install
sudo make install
cd ..
cmus 
man cmus
ls
ls songs/
ls
cmus 
mkdir /usr/local/lib/cmus/op
sudo mkdir /usr/local/lib/cmus/op
cd cmus-v2.3.3/
sudo make uninstall
./configure && make
sudo make install
cmus
sudo make uninstall
sudo make install | less
./configure && make | less
ls
cd ..
ls
cd cmus-v2.3.3/
sudo make uninstall 
sudo apt-get install cmus
ls
cd ..
ls
\rm cmus-v2.3.3
\rm -rf cmus-v2.3.3
ls
\rm cmus-v2.3.3.tar.bz2 
ls
cmus
sudo cmus
cmus --plugins
cmus --plugins pulse
ls
cd ~
ls
ls -a
cd .config
ls
mkdir cmus
ls
cd cmus
ls
vi rc
rs
cmus
cd ~
cmus
man cmus-tutorial
man cmus
cmus
man cmus
cmus
sudo apt-get install libao-ocaml-dev
ls
cd restsites/
ls
cd ~
ls
cd ..
ls
cd adapsyn/
ls 
cd strain_ordering/
ls
cd sidStuff/
ls
cd lackingFullTaxonomyMolecules/
ls
cd getMolTaxData/
ls
cd csvs/
ls
cd ..
ls
cd ..
ls 
cd taxStuff/
ls
cd tsvs/
ls
ls 
cd ..
ls *
cd .
cd ..
ls
cd old
ls
cd oldStuff/
ls
ls jsons/
cd taxStuff/
ls
cd oldStuff/
ls
cd ..
ls
cd ..
ls
cd ..
ls
cd taxStuff/
ls
ls *
cd ..
ls
cd oldd
ls
ls taxStuff/
ls taxStuff/*
ls
ls oldStuff/
ls
cd ..
ls
cd getMolTaxData/
ls
cd csvs/
ls
cd ..
ls
cd ..
ls
cd ..
ls
cd diversityRanking/
ls
cd weightedTaxonomyMatching/
ls
ls oldScheme/
wc -l oldScheme/*.csv
ls
cd ..
ls
cd resolveInternalStrains/
ls
cd csvs/
ls
wc -l inHouseStrainTaxonomy_300118SR_RMedits.csv
head inHouseStrainTaxonomy_300118SR_RMedits.csv
cut -f5 inHouseStrainTaxonomy_300118SR_RMedits.csv | uniq -c
cut -f5 -d',' inHouseStrainTaxonomy_300118SR_RMedits.csv | uniq -c
cut -f5 -d',' inHouseStrainTaxonomy_300118SR_RMedits.csv | uniq -c | wc -l
cut -f5 -d',' inHouseStrainTaxonomy_300118SR_RMedits.csv | head
cut -f6 -d',' inHouseStrainTaxonomy_300118SR_RMedits.csv | head
cut -f6 -d',' inHouseStrainTaxonomy_300118SR_RMedits.csv | head | sort -u
cut -f6 -d',' inHouseStrainTaxonomy_300118SR_RMedits.csv | sort -u
cut -f6 -d',' inHouseStrainTaxonomy_300118SR_RMedits.csv | sort -u | wc -
vi ~/.vimrc
rs
ls
cd lackingFullTaxonomyMolecules/
ls
cd ..
ls 
cd diversityRanking/
ls
cd resolveInternalStrains/
ls
ls csvs/
cd csvs/
ls
cut -f8 inHouseStrainTaxonomy_300118SR_RMedits.csv | head
cut -f8 -d',' inHouseStrainTaxonomy_300118SR_RMedits.csv | head
cut -f7 -d',' inHouseStrainTaxonomy_300118SR_RMedits.csv | head
cut -f7 -d',' inHouseStrainTaxonomy_300118SR_RMedits.csv | uniq -c
cut -f7 -d',' inHouseStrainTaxonomy_300118SR_RMedits.csv | uniq -c | less
cut -f7 -d',' inHouseStrainTaxonomy_300118SR_RMedits.csv | uniq -c | sort -n
cut -f7 -d',' inHouseStrainTaxonomy_300118SR_RMedits.csv | uniq -c | sort -n | less
cut -f7 -d',' inHouseStrainTaxonomy_300118SR_RMedits.csv | sort -un
cut -f7 -d',' inHouseStrainTaxonomy_300118SR_RMedits.csv | sort -u
cut -f7 -d',' inHouseStrainTaxonomy_300118SR_RMedits.csv | uniq -c
cut -f7 -d',' inHouseStrainTaxonomy_300118SR_RMedits.csv | less
cut -f7 -d',' inHouseStrainTaxonomy_300118SR_RMedits.csv | wc -l
cut -f7 -d',' inHouseStrainTaxonomy_300118SR_RMedits.csv | sort -u
cut -f7 -d',' inHouseStrainTaxonomy_300118SR_RMedits.csv | sort -u | wc -l
cut -f7 -d',' inHouseStrainTaxonomy_300118SR_RMedits.csv | uniq -c | less
cut -f7 -d',' inHouseStrainTaxonomy_300118SR_RMedits.csv | uniq -c | sort -n | less
ls
head inHouseStrainTaxonomy_300118SR_RMedits.csv
\rm inHouseStrainTaxonomy_300118SR_RMedits.xlsx 
ls
head inHouseStrainTaxonomy_300118SR_RMedits.csv
cut -f7 -d',' inHouseStrainTaxonomy_300118SR_RMedits.csv | head
cut -f7 -d',' inHouseStrainTaxonomy_300118SR_RMedits.csv | wc -l
cut -f7 -d',' inHouseStrainTaxonomy_300118SR_RMedits.csv | uniq -c
cut -f7 -d',' inHouseStrainTaxonomy_300118SR_RMedits.csv | uniq -c | wc -l
cut -f7 -d',' inHouseStrainTaxonomy_300118SR_RMedits.csv | uniq -c | sort 
sudo cmus
sudo cmus --plugins
sudo cmus --plugins | grep device
sudo cmus --plugins | less
sudo cmus
ls
cmus
rs
cmus
cd ~
ls
ls -a
cd .cmus
ls
vi autosave 
sudo autosave
sudo vi autosave
rs
ipython
ls
vi ~/.cmus/autosave 
rs
cmus
vi ~/.cmus/autosave 
sudo vi ~/.cmus/autosave
rs
sudo vi ~/.cmus/autosave
cmus
sudo vi ~/.cmus/autosave
ls
cd ~
ls
cd .cmus
ls
ls socket 
head socket 
vi socket 
sudo vi socket
ls
cd ..
ls -a
cd .config
ls
cd cmus/
ls
cat rc 
cd ..
\rm cmus
\rm -rf cmus
ls
ls -a
cd ..
ls
ls -a
cd .cmus
ls
head lib.pl 
ls
ls command-history 
head command-history
head search-history 
head cache 
ls
man cmus
ls
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/strain/properties" -X GET -g | jq .
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/strain/properties/internal_usage?limit=2" -X GET -g | jq .
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/strain/filter" -X GET -g | jq .
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/strain/filter/internal_usage?internal_usage=true" -X GET -g > allInternalStrains_120218SR.json
head allInternalStrains_120218SR.json
ls
mv allInternalStrains_120218SR.json  diversityRanking/resolveInternalStrains/
cd diversityRanking/resolveInternalStrains/
ls
mv allInternalStrains_120218SR.json jsons/
ls
ls scripts/
vi scripts/getTaxInfo.py 
vi internalGeneraWithMoreThan5Striains.txt
vi internalStrainsOnlySpecies_120218SR.txt
touch intenalNoTax_120218SR.csv
cat intenalNoTax_120218SR.csv 
ls
cat intenalNoTax_120218SR.csv 
vi scripts/strainToTsv.py 
ls
cd diversityRanking/resolveInternalStrains/
ls
python scripts/getTaxInfo.py 
ls
ls jsons/
python scripts/getTaxInfo.py 
ipython
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/strain/filter/internal_usage?internal_usage=true?&limit=99999" -X GET -g > jsons/allInternalStrains_120218SR.json 
python scripts/getTaxInfo.py 
ipython
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/genus/filter/name?name=Pseudoalteromonas&limit=99999" -X POST -d '["id", "{to.all_strains":["id"]}]' > pseudomeultStrainIDs.json
head pseudomeultStrainIDs.json 
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/genus/filter/name?name=Pseudoalteromonas&limit=99999/pull" -X POST -d '["id", "{to.all_strains":["id"]}]' > pseudomeultStrainIDs.json
head pseudomeultStrainIDs.json 
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/genus/filter/name?name=Pseudoalteromonas/pull" -X GET -g > pseudomeultStrainIDs.json
head pseudomeultStrainIDs.json 
curl -H "Authorization: db_prod zE4127iPdZsqWGpAdrC5"  "https://magarveylab-db.mcmaster.ca/v1/model/genus/filter/name?name=Pseudoalteromonas/to/all_strains" -X GET -g > pseudomeultStrainIDs.json
head pseudomeultStrainIDs.json 
ls
\rm pseudomeultStrainIDs.json 
ls
ls jsons/
ipython 
ls
python scripts/strainToTsv.py 
ls jsons/
python scripts/strainToTsv.py 
head csvs/inHouseStrainTaxonomy_120218SR.csv 
head -14 csvs/inHouseStrainTaxonomy_120218SR.csv 
head -15 csvs/inHouseStrainTaxonomy_120218SR.csv 
libreoffice csvs/inHouseStrainTaxonomy_120218SR.csv
ls
\rm intenalNoTax_120218SR.csv 
ls
ls csvs/
head -14 csvs/inHouseStrainTaxonomy_120218SR.csv 
head -13 csvs/inHouseStrainTaxonomy_120218SR.csv > csv/inHouseStrainsMissingGenera_120218SR.tsv
touch csv/inHouseStrainsMissingGenera_120218SR.tsv
head -13 csvs/inHouseStrainTaxonomy_120218SR.csv > csvs/inHouseStrainsMissingGenera_120218SR.tsv
ls
cd diversityRanking/
ls
cd req
ls
cd resolveInternalStrains/
ls
ls jsons/
ipython 
ls
cd ~
ls
cd .cmus
ls
man cmus
cd ..
ls
rs
cmus
ls
cd ~
ls
cd .config
ls
mkdir cmus
cd cmus
ls
mkdir rc
vi rc
ls
\rmdir rc
vi rc
ls
cd //
cd ..
ls
cd ~
;s
ls
cd .config
ls
cd cmus
ls
cd //
cd ~/.config/cmus
ls
cd ..
\rm -rf cmus/
ls
cd ..
ls
man cmus
cd ~
cmus
