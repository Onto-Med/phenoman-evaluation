# Evaluating the PhenoMan

## Creating a population with Synthea(TM):

1. Download Synthea(TM) from https://synthetichealth.github.io/synthea/build/libs/synthea-with-dependencies.jar
   and place it inside the `synthea` folder.
2. Open a terminal and execute the following commands (Java JRE or JDK required, replace ":" with ";" on a Windows machine):
```bash
cd synthea
java -jar synthea-with-dependencies.jar -s 43627 -p 1000000 -m hypertension:metabolic*:wellness*:asthma:bronchitis:allerg* -c synthea.properties
```

Detailed description of the arguments:
* `-s 43627` -> set a seed "43627", so that the generated patient data is reproducible
* `-p 1000` -> number of patients the population will consist of
* `-c synthea.properties` -> path to a configurationfile with additional configurations for Synthea(TM)

Resulting patient data will be placed inside the folders `synthea/output/fhir` and `synthea/output/csv`.

## Importing the FHIR resources into a FHIR Server

We used [HAPI FHIR JPA-Server Starter](https://github.com/hapifhir/hapi-fhir-jpaserver-starter) for this evaluation (http://lha-dev.imise.uni-leipzig.de:8091/hapi-fhir-jpaserver/fhir). There is a Docker image available: [knoppiks/hapi-jpa](https://hub.docker.com/r/knoppiks/hapi-jpa)

The following Linux Shell script will use [cURL](https://curl.haxx.se) to send the FHIR bundles to the FHIR server (replace "<SERVER\_URL>" with the actual URL):
```bash
#!/bin/sh

cd synthea/output/fhir

for f in *.json;
  do curl -X POST -H "Content-Type: application/json" -d @$f <SERVER_URL>/fhir > /dev/null;
done
```

## Importing the CSV files into a PostgreSQL database

Use the SQL file `csv_schema.sql` to create the required tables and import the CSV files (e.g., with pgAdmin's import functionality).

## Executing the PhenoMan test script

Place a release of the PhenoMan inside the `phenoman_test` folder (Version 0.3.3 is used here as an example) and execute the following CLI lines (Java JDK required):

```bash
cd phenoman_test
javac -cp phenoman-0.3.3.jar MIBE.java
java -cp "phenoman-0.3.3.jar;." MIBE
```

The number of matching patients will be printed to STDOUT.

## Executing Gold Standard SQL and comparing results with PhenoMan

Execute the SQL query within `gold_standard_script.sql`. The Script will return the number of matching patients. The number should match the result of PhenoMan.
