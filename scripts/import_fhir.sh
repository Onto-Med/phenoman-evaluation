#!/bin/sh

cd output/fhir

for f in *.json; do
  echo @$f;
  curl -X POST -sS -H "Content-Type: application/json" -d @$f http://localhost:8080/fhir > /dev/null;
done
