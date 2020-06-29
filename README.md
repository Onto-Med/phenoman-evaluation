# Evaluating the PhenoMan

## Creating a population with Synthea(TM):

1. Download Synthea(TM) from https://synthetichealth.github.io/synthea/build/libs/synthea-with-dependencies.jar
   and place it inside the `synthea` folder. We used version `v2.5.0` for this evaluation.
2. Open a terminal and execute the following commands (Java JRE or JDK required, replace ":" with ";" on a Windows machine):
```bash
cd synthea
java -jar synthea-with-dependencies.jar -s 43627 -p 100000 -m hypertension:metabolic*:wellness*:asthma:bronchitis:allerg* -c synthea.properties
```
Output in STDOUT should be: `{alive=99997, dead=2589}`

Detailed description of the arguments:
* `-s 43627` -> set a seed "43627", so that the generated patient data is reproducible
* `-p 100000` -> number of patients the population will consist of
* `-m ...` -> Synthea modules filter
* `-c synthea.properties` -> path to configuration file with additional configurations for Synthea(TM)

Resulting patient data will be placed inside the folder `synthea/output/fhir`.

## Importing the FHIR resources into a FHIR Server

We used [HAPI FHIR JPA-Server Starter](https://github.com/hapifhir/hapi-fhir-jpaserver-starter) for this evaluation.
There is a Docker image available: [knoppiks/hapi-jpa](https://hub.docker.com/r/knoppiks/hapi-jpa)

Start the HAPI FHIR JPA server:

```sh
docker volume create --name=hapi-db
docker-compose up -d
```

After the server has started (check `docker-compose logs -f hapi-jpa` to verify the startup has finished) you can run the Shell script `scripty/import_fhir.sh`, which uses [cURL](https://curl.haxx.se) to send the FHIR bundles to the FHIR server (localhost).

## Executing the PhenoMan test scripts

-- TODO --

The number of matching patients will be printed to STDOUT.

## Executing test SQL queries and comparing results with PhenoMan

Execute the SQL queries in `scripts/queries`. The queries will return numbers of matching patients. The numbers should match the result of PhenoMan.
Use the connection string `postgresql://admin:admin@localhost:5432/hapi` to establish a connection to the HAPI FHIR JPA database (PostgreSQL).
