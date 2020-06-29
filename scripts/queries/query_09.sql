-- Patient?_elements=id&birthdate=gt1960-06-17T15:08:54&birthdate=le2002-06-17T15:08:54&gender=male
-- Condition?_elements=subject&code=http://snomed.info/sct|10509002
-- AllergyIntolerance?_elements=patient&code=http://snomed.info/sct|418689008

WITH patients AS (
		-- inclusion: male subjects
		-- inclusion: age >= 18 and < 60 years
		SELECT DISTINCT res_id
		FROM hfj_spidx_token t
			JOIN hfj_spidx_date d USING (res_id, res_type)
		WHERE res_type = 'Patient'
			AND t.sp_name = 'gender'
			AND sp_value = 'male'
			AND d.sp_name = 'birthdate'
			AND extract(year FROM age(sp_value_high)) BETWEEN 18 AND 59
	), conditions AS (
		-- inclusion: condition acute bronchitis
		SELECT DISTINCT res_id
		FROM hfj_spidx_token t
		WHERE res_type = 'Condition'
			AND t.sp_value = '10509002'
	), allergy_intolerances AS (
		-- inclusion: allergy to grass pollen
		SELECT DISTINCT res_id
		FROM hfj_spidx_token t
		WHERE res_type = 'AllergyIntolerance'
			AND t.sp_value = '418689008'
	), exclusions AS (
		-- exclusion: myocardial infarction or stroke
		SELECT DISTINCT res_id
		FROM hfj_spidx_token t
		WHERE res_type = 'Condition'
			AND t.sp_value IN ('22298006', '230690007')
	)
SELECT DISTINCT res_id
FROM (
		SELECT p.res_id
		FROM conditions c
			JOIN hfj_res_link l1 ON (c.res_id = l1.src_resource_id)
			JOIN patients p ON (p.res_id = l1.target_resource_id)
			JOIN hfj_res_link l2 ON (p.res_id = l2.target_resource_id)
			JOIN allergy_intolerances a ON (a.res_id = l2.src_resource_id)
		EXCEPT
		SELECT target_resource_id
		FROM exclusions
			JOIN hfj_res_link ON (res_id = src_resource_id)
		WHERE target_resource_type = 'Patient'
	) q;
