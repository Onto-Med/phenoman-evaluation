SELECT count(DISTINCT id)
FROM (
		SELECT id
		FROM patients
			JOIN allergies a ON (a.patient = id)
			JOIN conditions c ON (c.patient = id)
		WHERE
			-- inclusion: male subjects
			gender = 'M'

			-- inclusion: age >= 18 and < 40 years
			AND extract(year FROM age(birthdate)) BETWEEN 18 AND 39

			-- inclusion: allergy to grass pollen
			AND a.code = '418689008'

			-- inclusion: codition asthma
			AND c.code = '195967001'

		-- exclusion: myocardial infarction or stroke
		EXCEPT (
			SELECT patient AS id
			FROM conditions
			WHERE code IN ('22298006', '230690007')
		)
	) q;