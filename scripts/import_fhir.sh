#!/bin/sh

cd synthea/output/fhir

for f in *.json;
  echo @$f;
  do curl -X POST -sS -H "Content-Type: application/json" -d @$f http://localhost:8080/fhir > /dev/null;
done
