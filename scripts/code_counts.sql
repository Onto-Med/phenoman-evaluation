SELECT code, count(*) FROM observations GROUP BY code ORDER BY 2;
SELECT code, count(*) FROM conditions GROUP BY code ORDER BY 2;
SELECT code, count(*) FROM allergies GROUP BY code ORDER BY 2;
