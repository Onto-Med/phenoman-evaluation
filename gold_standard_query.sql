SELECT DISTINCT id
FROM patients p
WHERE
  -- inclusion: male subjects
  gender = 'M'

  -- inclusion: age between 40 and 65
  AND extract(year FROM age(birthdate)) BETWEEN 40 AND 65

  -- inclusion: at least one observation of systolic blood pressure >= 130 mmHg in the last year
  AND EXISTS (
    SELECT 1
    FROM observations
      WHERE patient = p.id
        AND code = '8480-6'
        AND value::double precision >= 130
        AND date >= CURRENT_DATE - interval '1 years'
  )

  -- exclusion: myocardial infarction or stroke
  AND NOT EXISTS (
    SELECT 1
    FROM conditions
      WHERE patient = p.id
        AND code IN ('22298006', '230690007')
  );