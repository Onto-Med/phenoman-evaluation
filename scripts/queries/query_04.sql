-- Patient?_elements=id&birthdate=gt1960-06-17T14:50:18&birthdate=le1980-06-17T14:50:18&gender=female
-- Condition?_elements=subject&code=http://snomed.info/sct|44054006
-- Observation?_elements=subject&code=http://loinc.org|4548-4&value-quantity=ge6|http://unitsofmeasure.org|%

SELECT count(DISTINCT id)
FROM patients
	JOIN conditions c ON (c.patient = id)
	JOIN observations o ON (o.patient = id)
WHERE
	-- inclusion: female subjects
	gender = 'F'

	-- inclusion: age >= 40 and < 60 years
	AND extract(year FROM age(birthdate)) BETWEEN 40 AND 59

	-- inclusion: condition diabetes mellitus type 2
	AND c.code = '44054006'

	-- inclusion: at least one observation of hemoglobin A1c/hemoglobin.total in blood >= 6 %
	AND o.code = '4548-4'
	AND value::double precision >= 6;
