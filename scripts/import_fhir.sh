#!/bin/sh

cd /fhir

for f in *.json;
  do curl -X POST -H "Content-Type: application/json" -d @$f http://127.0.0.1/fhir > /dev/null;
done
