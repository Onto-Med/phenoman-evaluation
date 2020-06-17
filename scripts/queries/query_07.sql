-- Patient?_elements=id&birthdate=gt1980-06-17T15:02:33&birthdate=le2002-06-17T15:02:33&gender=male
-- AllergyIntolerance?_elements=patient&code=http://snomed.info/sct|232347008

SELECT count(DISTINCT id)
FROM patients
	JOIN allergies ON (patient = id)
WHERE
	-- inclusion: male subjects
	gender = 'M'

	-- inclusion: age >= 18 and < 40 years
	AND extract(year FROM age(birthdate)) BETWEEN 18 AND 39

	-- inclusion: allergy to animal dander
	AND code = '232347008';
