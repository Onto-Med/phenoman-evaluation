# Patientendaten für Evaluation

## Population mit Synthea erzeugen:

1. Synthea hier herunterladen: https://synthetichealth.github.io/synthea/build/libs/synthea-with-dependencies.jar
2. Folgendes in der Konsole ausführen:
  `java -jar .\synthea-with-dependencies.jar -s 43627 -p 1000 -m Cardiovascular* -c synthea.properties`
3. Ergebnis ist ein Ordner „output“ mit 1000 FHIR Bundles als JSON-Dateien, die wir in den FHIR Server importieren können.

Erläuterung:
* `-s 43627` -> Legt einen Seed fest, sodass immer eine identische Population erzeugt wird.
* `-p 1000` -> Es soll eine Population mit 1000 Patienten erzeugt werden.
* `-m Cardiovascular*` -> Nur Module verwenden, deren Namen dem Filter Cardiovascular* entsprechen.
* `--export.fhir.use_us_core true` -> Erzeugt eine Population die FHIR entsprechend R4 Implementation exportiert.

## Import der FHIR Resourcen in lha-dev FHIR Testserver

```bash
for f in *.json; \
  do curl -X POST -H "Content-Type: application/json" -d @$f http://lha-dev.imise.uni-leipzig.de:8091/hapi-fhir-jpaserver/fhr; \
done
```