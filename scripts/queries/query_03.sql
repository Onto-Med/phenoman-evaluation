-- Patient?_elements=id&birthdate=gt1960-06-17T14:45:24&birthdate=le1980-06-17T14:45:24&gender=male
-- Condition?_elements=subject&code=http://snomed.info/sct|44054006
-- Observation?_elements=subject&code=http://loinc.org|39156-5&value-quantity=ge35&value-quantity=lt70
-- Observation?_elements=subject&code=http://loinc.org|72166-2&value-concept=http://snomed.info/sct|449868002

SELECT count(DISTINCT id)
FROM (
		SELECT id
		FROM patients
			JOIN observations o ON (o.patient = id)
			JOIN conditions c ON (c.patient = id)
		WHERE
			-- inclusion: male subjects
			gender = 'M'

			-- inclusion: age >= 40 and < 60 years
			AND extract(year FROM age(birthdate)) BETWEEN 40 AND 59

			-- inclusion: at least one observation of body mass index >= 35 and < 70 kg/m^2
			AND o.code = '39156-5'
			AND value::double precision >= 35
			AND value::double precision < 70

			-- inclusion: condition diabetes mellitus type 2
			AND c.code = '44054006'

		-- exclusion: tobacco smoking status = current every day smoker
		EXCEPT (
			SELECT patient AS id
			FROM observations
			WHERE code = '72166-2'
				AND value = 'Current every day smoker'
		)
	) q;
