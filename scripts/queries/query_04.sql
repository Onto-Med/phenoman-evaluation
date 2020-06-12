SELECT count(DISTINCT id)
FROM (
		SELECT id
		FROM patients
			JOIN conditions c ON (c.patient = id)
			JOIN observations o ON (o.patient = id)
		WHERE
			-- inclusion: female subjects
			gender = 'F'

			-- inclusion: age >= 40 and < 60 years
			AND extract(year FROM age(birthdate)) BETWEEN 40 AND 59

			-- inclusion: condition diabetes mellitus type 2
			AND c.code = '44054006'

			-- inclusion: at least one observation of hemoglobin A1c/hemoglobin.total in blood >= 6 %
			AND o.code = '4548-4'
			AND value::double precision >= 6
	) q;
