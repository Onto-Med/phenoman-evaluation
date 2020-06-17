-- Patient?_elements=id&birthdate=gt1980-06-17T14:59:28&birthdate=le2002-06-17T14:59:28&gender=female
-- Condition?_elements=subject&code=http://snomed.info/sct|195967001
-- Observation?_elements=subject&code=http://loinc.org|72166-2&value-concept=http://snomed.info/sct|449868002

SELECT count(DISTINCT id)
FROM (
		SELECT id
		FROM patients
			JOIN conditions ON (patient = id)
		WHERE
			-- inclusion: female subjects
			gender = 'F'

			-- inclusion: age >= 18 and < 40 years
			AND extract(year FROM age(birthdate)) BETWEEN 18 AND 39

			-- inclusion: condition asthma
			AND code = '195967001'

		-- exclusion: tobacco smoking status = current every day smoker
		EXCEPT (
			SELECT patient AS id
			FROM observations
			WHERE code = '72166-2'
				AND value = 'Current every day smoker'
		)
	) q;
