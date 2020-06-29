-- Patient?_elements=id&birthdate=gt1960-06-17T14:55:32&birthdate=le1980-06-17T14:55:32&gender=male
-- Observation?_elements=subject&code=http://loinc.org|39156-5&value-quantity=ge26&value-quantity=lt35&date=ge2020-05-17T14:56:01
-- Condition?_elements=subject&code=http://snomed.info/sct|44054006
-- Condition?_elements=subject&code=http://snomed.info/sct|49436004,http://snomed.info/sct|271737000,http://snomed.info/sct|22298006,http://snomed.info/sct|230690007

WITH patients AS (
		-- inclusion: male subjects
		-- inclusion: age >= 40 and < 60 years
		SELECT DISTINCT res_id
		FROM hfj_spidx_token t
			JOIN hfj_spidx_date d USING (res_id, res_type)
		WHERE res_type = 'Patient'
			AND t.sp_name = 'gender'
			AND sp_value = 'male'
			AND d.sp_name = 'birthdate'
			AND extract(year FROM age(sp_value_high)) BETWEEN 40 AND 59
	), observations AS (
		-- inclusion: observation of body mass index >= 26 and < 35 kg/m^2
		SELECT DISTINCT res_id
		FROM hfj_spidx_date d
			JOIN (
				SELECT res_id, sp_name, sp_value
				FROM hfj_spidx_token
				WHERE sp_name = 'code'
			) t USING (res_id)
			JOIN (
				SELECT res_id, sp_name, sp_value
				FROM hfj_spidx_quantity
				WHERE sp_name = 'value-quantity'
			) q USING (res_id)
		WHERE res_type = 'Observation'
			AND d.sp_name = 'date'
			AND d.sp_value_high >= CURRENT_DATE - interval '1 months'
			AND t.sp_value = '39156-5'
			AND q.sp_value >= 26
			AND q.sp_value < 35
	), conditions AS (
		-- inclusion: diabetes mellitus type 2
		SELECT DISTINCT res_id
		FROM hfj_spidx_token t
		WHERE res_type = 'Condition'
			AND t.sp_value = '44054006'
	), exclusions AS (
		-- exclusion: myocardial infarction, stroke, anemia or atrial fibrillation
		SELECT DISTINCT res_id
		FROM hfj_spidx_token t
		WHERE res_type = 'Condition'
			AND t.sp_value IN ('22298006', '230690007', '271737000', '49436004')
	)
SELECT DISTINCT res_id
FROM (
		SELECT p.res_id
		FROM observations o
			JOIN hfj_res_link l1 ON (o.res_id = l1.src_resource_id)
			JOIN patients p ON (p.res_id = l1.target_resource_id)
			JOIN hfj_res_link l2 ON (p.res_id = l2.target_resource_id)
			JOIN conditions c ON (c.res_id = l2.src_resource_id)
		EXCEPT
		SELECT target_resource_id
		FROM exclusions
			JOIN hfj_res_link ON (res_id = src_resource_id)
		WHERE target_resource_type = 'Patient'
	) q;
