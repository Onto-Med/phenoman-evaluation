-- Patient?_elements=id&birthdate=gt1960-06-17T14:50:18&birthdate=le1980-06-17T14:50:18&gender=female
-- Condition?_elements=subject&code=http://snomed.info/sct|44054006
-- Observation?_elements=subject&code=http://loinc.org|4548-4&value-quantity=ge6|http://unitsofmeasure.org|%

SWITH patients AS (
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
		-- inclusion: observation of hemoglobin A1c/hemoglobin.total in blood >= 6 %
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
			AND t.sp_value = '4548-4'
			AND q.sp_value >= 6
	), conditions AS (
		-- diabetes mellitus type 2
		SELECT DISTINCT res_id
		FROM hfj_spidx_token t
		WHERE res_type = 'Condition'
			AND t.sp_value = '44054006'
	)
SELECT DISTINCT p.res_id
FROM observations o
	JOIN hfj_res_link l1 ON (o.res_id = l1.src_resource_id)
	JOIN patients p ON (p.res_id = l1.target_resource_id)
	JOIN hfj_res_link l2 ON (p.res_id = l2.target_resource_id)
	JOIN conditions c ON (c.res_id = l2.src_resource_id);
