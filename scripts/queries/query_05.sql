-- Patient?_elements=id&birthdate=gt1960-06-17T14:55:32&birthdate=le1980-06-17T14:55:32&gender=male
-- Observation?_elements=subject&code=http://loinc.org|39156-5&value-quantity=ge26&value-quantity=lt35
-- Condition?_elements=subject&code=http://snomed.info/sct|44054006
-- Condition?_elements=subject&code=http://snomed.info/sct|49436004,http://snomed.info/sct|271737000,http://snomed.info/sct|22298006,http://snomed.info/sct|230690007

SELECT count(DISTINCT id)
FROM (
		SELECT id
		FROM patients
			JOIN conditions c ON (c.patient = id)
			JOIN observations o ON (o.patient = id)
		WHERE
			-- inclusion: male subjects
			gender = 'M'

			-- inclusion: age >= 40 and < 60 years
			AND extract(year FROM age(birthdate)) BETWEEN 40 AND 59

			-- inclusion: condition diabetes mellitus type 2
			AND c.code = '44054006'

			-- inclusion: at least one observation of body mass index >= 26 and < 35 kg/m^2
			AND o.code = '39156-5'
			AND value::double precision >= 26
			AND value::double precision < 35

		-- exclusion: myocardial infarction, stroke, anemia or atrial fibrillation
		EXCEPT (
			SELECT patient AS id
			FROM conditions
			WHERE code IN ('22298006', '230690007', '271737000', '49436004')
		)
	) q;
