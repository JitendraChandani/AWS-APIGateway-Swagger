#! /bin/bash

mkdir docs | true
echo "[" > docs-list.json
aws apigateway get-rest-apis | jq -c -r '.items[]' | while read i;
do 
	id=`echo $i | jq -r '.id'`
	name=`echo $i | jq -r '.name'`
	
	for stage in `aws apigateway get-stages --rest-api-id $id | jq -r '.item[].stageName'`;
	do
		aws apigateway get-export --rest-api-id $id --stage-name "$stage" --export-type swagger docs/${stage}-${name}.json
		echo "{\"url\": \"docs/"${stage}"-"${name}".json\", \"name\": \""${stage}"-"${name}"\"}," >> docs-list.json
	done

done
truncate -s-2  docs-list.json
echo "]" >> docs-list.json
