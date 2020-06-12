SELECT count(DISTINCT id)
FROM (
		SELECT id
		FROM patients
			JOIN allergies a ON (a.patient = id)
		WHERE
			-- inclusion: female subjects
			gender = 'F'

			-- inclusion: age >= 18 and < 40 years
			AND extract(year FROM age(birthdate)) BETWEEN 18 AND 39

			-- inclusion: allergy to grass pollen
			AND a.code = '418689008'

		-- exclusion: asthma or acute bronchitis
		EXCEPT (
			SELECT patient AS id
			FROM conditions
			WHERE code IN ('195967001', '10509002')
		)
	) q;
