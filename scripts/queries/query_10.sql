-- Patient?_elements=id&birthdate=gt1980-06-17T15:11:29&birthdate=le2002-06-17T15:11:29
-- AllergyIntolerance?_elements=patient&code=http://snomed.info/sct|418689008
-- Condition?_elements=subject&code=http://snomed.info/sct|195967001,http://snomed.info/sct|10509002

SELECT count(DISTINCT id)
FROM (
		SELECT id
		FROM patients
			JOIN allergies a ON (a.patient = id)
		WHERE
			-- inclusion: age >= 18 and < 40 years
			extract(year FROM age(birthdate)) BETWEEN 18 AND 39

			-- inclusion: allergy to grass pollen
			AND a.code = '418689008'

		-- exclusion: asthma or acute bronchitis
		EXCEPT (
			SELECT patient AS id
			FROM conditions
			WHERE code IN ('195967001', '10509002')
		)
	) q;
