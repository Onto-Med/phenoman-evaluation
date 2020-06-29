-- Patient?_elements=id&birthdate=gt1980-06-17T15:11:29&birthdate=le2002-06-17T15:11:29
-- AllergyIntolerance?_elements=patient&code=http://snomed.info/sct|418689008
-- Condition?_elements=subject&code=http://snomed.info/sct|195967001,http://snomed.info/sct|10509002

WITH patients AS (
		-- inclusion: age >= 18 and < 40 years
		SELECT DISTINCT res_id
		FROM hfj_spidx_date
		WHERE res_type = 'Patient'
			AND sp_name = 'birthdate'
			AND extract(year FROM age(sp_value_high)) BETWEEN 18 AND 39
	), allergy_intolerances AS (
		-- inclusion: allergy to grass pollen
		SELECT DISTINCT res_id
		FROM hfj_spidx_token t
		WHERE res_type = 'AllergyIntolerance'
			AND t.sp_value = '418689008'
	), exclusions AS (
		-- exclusion: asthma or acute bronchitis
		SELECT DISTINCT res_id
		FROM hfj_spidx_token t
		WHERE res_type = 'Condition'
			AND t.sp_value IN ('195967001', '10509002')
	)
SELECT DISTINCT res_id
FROM (
		SELECT p.res_id
		FROM allergy_intolerances a
			JOIN hfj_res_link ON (a.res_id = src_resource_id)
			JOIN patients p ON (p.res_id = target_resource_id)
		EXCEPT
		SELECT target_resource_id
		FROM exclusions
			JOIN hfj_res_link ON (res_id = src_resource_id)
		WHERE target_resource_type = 'Patient'
	) q;
