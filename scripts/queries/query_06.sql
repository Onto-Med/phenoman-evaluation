-- Patient?_elements=id&birthdate=gt1980-06-17T14:59:28&birthdate=le2002-06-17T14:59:28&gender=female
-- Condition?_elements=subject&code=http://snomed.info/sct|195967001
-- Observation?_elements=subject&code=http://loinc.org|72166-2&value-concept=http://snomed.info/sct|449868002

WITH patients AS (
		-- inclusion: female subjects
		-- inclusion: age >= 18 and < 40 years
		SELECT DISTINCT res_id
		FROM hfj_spidx_token t
			JOIN hfj_spidx_date d USING (res_id, res_type)
		WHERE res_type = 'Patient'
			AND t.sp_name = 'gender'
			AND sp_value = 'female'
			AND d.sp_name = 'birthdate'
			AND extract(year FROM age(sp_value_high)) BETWEEN 18 AND 39
	), conditions AS (
		-- inclusion: asthma
		SELECT DISTINCT res_id
		FROM hfj_spidx_token t
		WHERE res_type = 'Condition'
			AND t.sp_value = '195967001'
	), exclusions AS (
		-- exclusion: tobacco smoking status = current every day smoker
		SELECT DISTINCT res_id
		FROM hfj_spidx_token
		WHERE res_type = 'Observation'
			AND sp_name = 'value-concept'
			AND sp_value = '449868002'
	)
SELECT DISTINCT res_id
FROM (
		SELECT p.res_id
		FROM conditions c
			JOIN hfj_res_link ON (c.res_id = src_resource_id)
			JOIN patients p ON (p.res_id = target_resource_id)
		EXCEPT
		SELECT target_resource_id
		FROM exclusions
			JOIN hfj_res_link ON (res_id = src_resource_id)
		WHERE target_resource_type = 'Patient'
	) q;
