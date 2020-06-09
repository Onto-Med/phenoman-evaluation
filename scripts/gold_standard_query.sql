SELECT count(DISTINCT id)
FROM (
		SELECT p.id
		FROM patients p
			JOIN observations ON (patient = p.id)
		WHERE
			-- inclusion: male subjects
			gender = 'M'

			-- inclusion: age between 40 and 65
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