-- Patient?_elements=id&birthdate=gt1954-06-17T14:34:35&birthdate=le1980-06-17T14:34:35&gender=male
-- Observation?_elements=subject&component-code-value-quantity=http://loinc.org|8480-6$ge130|http://unitsofmeasure.org|mm[Hg]&date=ge2020-05-17T14:35:03
-- Condition?_elements=subject&code=http://snomed.info/sct|22298006,http://snomed.info/sct|230690007

WITH patients AS (
		-- inclusion: male subjects
		-- inclusion: age >= 40 and <= 65 years
		SELECT DISTINCT res_id
		FROM hfj_spidx_token t
			JOIN hfj_spidx_date d USING (res_id, res_type)
		WHERE res_type = 'Patient'
			AND t.sp_name = 'gender'
			AND sp_value = 'male'
			AND d.sp_name = 'birthdate'
			AND extract(year FROM age(sp_value_high)) BETWEEN 40 AND 65
	), observations AS (
		-- inclusion: observation of systolic blood pressure >= 130 mmHg in the last month
		SELECT DISTINCT res_id
		FROM hfj_spidx_date d
			JOIN (
				SELECT res_id, sp_name, sp_value
				FROM hfj_spidx_token
				WHERE sp_name = 'component-code'
			) t USING (res_id)
			JOIN (
				SELECT res_id, sp_name, sp_value
				FROM hfj_spidx_quantity
				WHERE sp_name = 'component-value-quantity'
			) q USING (res_id)
		WHERE res_type = 'Observation'
			AND d.sp_name = 'date'
			AND d.sp_value_high >= CURRENT_DATE - interval '1 months'
			AND t.sp_value = '8480-6'
			AND q.sp_value >= 130
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
		FROM observations o
			JOIN hfj_res_link ON (o.res_id = src_resource_id)
			JOIN patients p ON (p.res_id = target_resource_id)
		EXCEPT
		SELECT target_resource_id
		FROM exclusions
			JOIN hfj_res_link ON (res_id = src_resource_id)
		WHERE target_resource_type = 'Patient'
	) q;
