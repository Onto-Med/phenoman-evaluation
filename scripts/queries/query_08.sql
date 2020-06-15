SELECT count(DISTINCT id)
FROM (
		SELECT id
		FROM patients
			JOIN allergies a ON (a.patient = id)
			JOIN conditions c ON (c.patient = id)
		WHERE
			-- inclusion: female subjects
			gender = 'F'

			-- inclusion: age >= 18 and < 60 years
			AND extract(year FROM age(birthdate)) BETWEEN 18 AND 59

			-- inclusion: allergy to animal dander
			AND a.code = '232347008'

			-- inclusion: codition acute bronchitis
			AND c.code = '10509002'

		-- exclusion: tobacco smoking status = current every day smoker
		EXCEPT (
			SELECT patient AS id
			FROM observations
			WHERE code = '72166-2'
				AND value = 'Current every day smoker'
		)
	) q;
