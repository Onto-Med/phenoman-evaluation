# Evaluating the PhenoMan

## Creating a population with Synthea(TM):

1. Download Synthea(TM) from https://synthetichealth.github.io/synthea/build/libs/synthea-with-dependencies.jar
   and place it inside the `synthea` folder. We used version `v2.5.0` for this evaluation.
2. Open a terminal and execute the following commands (Java JRE or JDK required, replace ":" with ";" on a Windows machine):
```sh
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

After the server has started (check `docker-compose logs -f hapi-jpa` to verify the startup has finished) you can run the Shell script `scripts/import_fhir.sh`, which uses [cURL](https://curl.haxx.se) to send the FHIR bundles to the FHIR server (localhost:8080).

## Executing the PhenoMan test scripts

The example queries are located in the package `care.smith.phep.phenoman.core.examples.queries` of [phenoman-core](https://github.com/Onto-Med/phenoman-core).
Each of the query classes has a static `main()` method, which can be called with the additional Java VM option `-Dhds-url=http://localhost:8080/fhir`.

The numbers of matching patients as well as execution times will be printed to STDOUT.

## Executing test SQL queries and comparing results with PhenoMan

Execute the SQL queries in `scripts/queries`. The queries will return numbers of matching patients. The numbers should match the result of PhenoMan.
Use the connection string `postgresql://admin:admin@localhost:5432/hapi` to establish a connection to the HAPI FHIR JPA database (PostgreSQL).

## Results

We imported **66,018 subjects** into the HAPI FHIR JPA Server and compared the results of the PhenoMan with the results of the SQL queries.
The following table contains the number of matching subjects and the execution times. The results of each query pair were identical.

* **Number of subjects:** 66,018
* **Execution Date:** 2020-06-28
* **FHIR Page Size:** 200

|Query No.|Count|PhenoMan [s]|SQL [s]|Difference [%]|
|---------|-----|------------|-------|--------------|
|1        |113  |309.035     |51.109 |83.46         |
|2        |119  |301.635     |49.930 |83.45         |
|3        |  6  |429.378     |157    |63.44         |
|4        |684  |360.949     |153    |57.61         |
|5        |  8  |525.922     |257    |51.13         |
|6        | 10  | 98.322     |39.905 |59.42         |
|7        | 18  | 14.980     | 7.652 |48.92         |
|8        | 11  |173.534     |14.397 |91.70         |
|9        |  4  |265.080     |31.404 |88.15         |
|10       |  6  |327.277     |28.345 |91.34         |
