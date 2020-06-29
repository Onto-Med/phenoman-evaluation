-- Patient?_elements=id&birthdate=gt1980-06-17T15:02:33&birthdate=le2002-06-17T15:02:33&gender=male
-- AllergyIntolerance?_elements=patient&code=http://snomed.info/sct|232347008

WITH patients AS (
		-- inclusion: male subjects
		-- inclusion: age >= 18 and < 40 years
		SELECT DISTINCT res_id
		FROM hfj_spidx_token t
			JOIN hfj_spidx_date d USING (res_id, res_type)
		WHERE res_type = 'Patient'
			AND t.sp_name = 'gender'
			AND sp_value = 'male'
			AND d.sp_name = 'birthdate'
			AND extract(year FROM age(sp_value_high)) BETWEEN 18 AND 39
	), allergy_intolerances AS (
		-- inclusion: allergy to animal dander
		SELECT DISTINCT res_id
		FROM hfj_spidx_token t
		WHERE res_type = 'AllergyIntolerance'
			AND t.sp_value = '232347008'
	)
SELECT DISTINCT p.res_id
FROM allergy_intolerances a
	JOIN hfj_res_link ON (a.res_id = src_resource_id)
	JOIN patients p ON (p.res_id = target_resource_id);
