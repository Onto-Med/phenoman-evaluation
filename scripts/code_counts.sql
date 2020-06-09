SELECT code, count(*) FROM observations GROUP BY code;
SELECT code, count(*) FROM conditions GROUP BY code;
SELECT code, count(*) FROM allergies GROUP BY code;