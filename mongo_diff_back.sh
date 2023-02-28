#!/bin/bash
yesterday=$(date -d "yesterday" +%Y-%m-%d)
start_timestamp=$(date -d "$yesterday 00:00:00"  +%s%N | cut -b1-13)
stop_timestamp=$(date -d "$yesterday 23:59:59" +%s%N | cut -b1-13)
# set variables
db_name="armax_radiatics_prod_o2power"
host_db_name="armax_radiatics_prod_demo"
collection_list="devicerawdatafifteenminutes devicerawdatafiveminutes devicerawdatalatests devicerawdataonehours devicerawdatas kpidailydatas kpihourlydatas kpimonthlydatas kpitotaldatas kpiweeklydatas kpiyearlydatas"
#echo $start_timestamp
#echo $stop_timestamp
# devicerawdatalatests devicerawdataonehours devicerawdatas kpidailydatas kpihourlydatas kpimonthlydatas kpitotaldatas kpiweeklydatas kpiyearlydatas"
# perform mongodump and pipe output to mongorestore
out_prefix="/root/mongo_diff_back"
for collection in $collection_list; do
        echo $collection
mongodump --host "sgridsreplica/10.7.10.27:8030,10.7.10.43:8030,10.7.10.8:8030" --username="jShMGpYf" --password="bzOQDpoYs4T24ISdEFqeRORjHFqWZ7XO" --authenticationDatabase="admin" --db "$db_name" --collection $collection  -q '{"planttimestamp" : {"$gte" : {"$numberDouble" :"'$start_timestamp'"}},"timestamp" :{"$lte" : {"$numberDouble" : "'$stop_timestamp'"}}}' --gzip --archive  | mongorestore --host  "sgridsreplica/10.7.10.33:8030,10.7.10.19:8030,10.7.10.6:8030" --username="NayOrqFX" --password="PgBbXfddKpjtxXYWfNfPHInleZbaUBmK" --authenticationDatabase="admin" --nsFrom "$db_name.*" --nsTo "$host_db_name.*" --drop --archive --gzip

done
