SELECT count(DISTINCT id)
FROM patients
	JOIN observations ON (patient = id)
WHERE
	-- inclusion: female subjects
	gender = 'F'

	-- inclusion: age >= 40 and < 60 years
	AND extract(year FROM age(birthdate)) BETWEEN 40 AND 59

	-- inclusion: at least one observation of body mass index >= 34 and < 70 kg/m^2
	AND code = '39156-5'
	AND value::double precision >= 34
	AND value::double precision < 70;
