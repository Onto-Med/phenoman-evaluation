-- Patient?_elements=id&birthdate=gt1960-06-17T14:43:04&birthdate=le1980-06-17T14:43:04&gender=female
-- Observation?_elements=subject&code=http://loinc.org|39156-5&value-quantity=ge34&value-quantity=lt70

WITH patients AS (
		-- inclusion: female subjects
		-- inclusion: age >= 40 and < 60 years
		SELECT DISTINCT res_id
		FROM hfj_spidx_token t
			JOIN hfj_spidx_date d USING (res_id, res_type)
		WHERE res_type = 'Patient'
			AND t.sp_name = 'gender'
			AND sp_value = 'female'
			AND d.sp_name = 'birthdate'
			AND extract(year FROM age(sp_value_high)) BETWEEN 40 AND 59
	), observations AS (
		-- inclusion: observation of body mass index >= 34 and < 70 kg/m^2
		SELECT DISTINCT res_id
		FROM (
				SELECT res_id, res_type, sp_name, sp_value
				FROM hfj_spidx_token
				WHERE sp_name = 'code'
			) t
			JOIN (
				SELECT res_id, sp_name, sp_value
				FROM hfj_spidx_quantity
				WHERE sp_name = 'value-quantity'
			) q USING (res_id)
		WHERE res_type = 'Observation'
			AND t.sp_value = '39156-5'
			AND q.sp_value >= 34
			AND q.sp_value < 70
	)
SELECT DISTINCT p.res_id
FROM observations o
	JOIN hfj_res_link ON (o.res_id = src_resource_id)
	JOIN patients p ON (p.res_id = target_resource_id);
