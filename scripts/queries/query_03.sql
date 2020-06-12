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
