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
