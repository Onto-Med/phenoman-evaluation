-- Patient?_elements=id&birthdate=gt1954-06-17T14:34:35&birthdate=le1980-06-17T14:34:35&gender=male
-- Observation?_elements=subject&component-code-value-quantity=http://loinc.org|8480-6$ge130|http://unitsofmeasure.org|mm[Hg]&date=ge2019-06-17T14:35:03
-- Condition?_elements=subject&code=http://snomed.info/sct|22298006,http://snomed.info/sct|230690007

SELECT count(DISTINCT id)
FROM (
		SELECT id
		FROM patients
			JOIN observations ON (patient = id)
		WHERE
			-- inclusion: male subjects
			gender = 'M'

			-- inclusion: age >= 40 and <= 65 years
			AND extract(year FROM age(birthdate)) BETWEEN 40 AND 65

			-- inclusion: at least one observation of systolic blood pressure >= 130 mmHg in the last year
			AND code = '8480-6'
			AND value::double precision >= 130
			AND date >= CURRENT_DATE - interval '1 years'

		-- exclusion: myocardial infarction or stroke
		EXCEPT (
			SELECT patient AS id
			FROM conditions
			WHERE code IN ('22298006', '230690007')
		)
	) q;
