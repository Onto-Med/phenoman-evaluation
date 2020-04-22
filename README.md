# Evaluating the PhenoMan

## Createing a Population with Synthea(TM):

1. Download Synthea(TM) from https://synthetichealth.github.io/synthea/build/libs/synthea-with-dependencies.jar
   and place it inside the `synthea` folder.
2. Open a terminal and execute the following commands:
```bash
cd synthea
java -jar synthea-with-dependencies.jar -s 43627 -p 1000 -c synthea.properties
```

Detailed description of the arguments:
* `-s 43627` -> set a seed "43627", so that the generated patient data is reproducible
* `-p 1000` -> number of patients the population will consist of
* `-c synthea.properties` -> path to a configurationfile with additional configurations for Synthea(TM)

Resulting patient data will be placed inside the folders `synthea/output/fhir` and `synthea/output/csv`.

## Importing the FHIR Resources into the LHA-Dev FHIR Testserver

The following commands contain Linux Bash syntax.
```bash
cd synthea/output/fhir
for f in *.json; \
  do curl -X POST -H "Content-Type: application/json" -d @$f http://lha-dev.imise.uni-leipzig.de:8091/hapi-fhir-jpaserver/fhir; \
done
```

## Importing the CSV files into a PostgreSQL database

Use the SQL file `csv_schema.sql` to create the required tables and import the CSV files (e.g., with pgAdmin's import functionality).

## Executing the PhenoMan Test Script

Place a release of the PhenoMan inside the `phenoman_test` folder (Version 0.3.3 is used here as an example).

```bash
cd phenoman_test
javac -cp phenoman-0.3.3.jar MIBE.java
java -cp phenoman-0.3.3.jar;. MIBE
```

## Gold Standard SQL

```sql
SELECT p.id
FROM patients p
WHERE
  p.gender = 'M'
  AND p.birthdate <= CURRENT_DATE - interval '40 years'
  AND p.birthdate >= CURRENT_DATE - interval '65 years'
  AND EXISTS (
    SELECT 1
    FROM observations
      WHERE patient = p.id
        AND code = '8480-6'
        AND value::double precision >= 130
        AND date >= CURRENT_DATE - interval '1 years'
  )
  AND NOT EXISTS (
    SELECT 1
    FROM conditions
      WHERE patient = p.id
        AND code IN ('22298006', '230690007')
  );
```
