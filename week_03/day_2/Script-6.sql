SELECT*
FROM teams;

SELECT*
FROM employees;

SELECT*
FROM pay_details;

SELECT 
e.first_name,
e.last_name,
e.pension_enrol,
t.name AS team_name
FROM employees AS e
INNER JOIN teams AS t
ON e.team_id = t.id
WHERE pension_enrol = TRUE;

SELECT 
e.first_name,
e.last_name,
t.charge_cost,
t.name AS team_name
FROM employees AS e
INNER JOIN teams AS t
ON e.team_id = t.id
WHERE CAST(t.charge_cost AS INTEGER) > 80;

SELECT
e.*,
pd.local_account_no,
pd.local_sort_code,
t.name AS team_name
FROM (employees AS e
LEFT JOIN pay_details AS pd
ON e.id = pd.id)
INNER JOIN teams AS t
ON e.team_id = t.id;

SELECT 
t.name AS team_name,
COUNT(t.id) AS no_id
FROM employees AS e
LEFT JOIN teams AS t
ON e.team_id = t.id
GROUP BY t.id
ORDER BY no_id ASC;

SELECT 
t.name AS team_name,
t.id AS team_id,
COUNT(t.id) AS no_id
FROM employees AS e
LEFT JOIN teams AS t
ON e.team_id = t.id
GROUP BY t.id;

SELECT *
FROM (
SELECT
t.id AS team_id,
t.name AS team_name,
COUNT(t.id) AS no_id,
t.charge_cost AS charge_cost,
COUNT(t.id) * CAST(t.charge_cost AS INTEGER) AS final_cost
FROM employees AS e
LEFT JOIN teams AS t
ON e.team_id = t.id
GROUP BY t.id
ORDER BY no_id) AS charge_table
WHERE charge_table.final_cost > 5000;

SELECT 
COUNT(id)
FROM employees_committees;

SELECT 
COUNT (DISTINCT employee_id)
FROM employees_committees;

SELECT
COUNT (e.id)
FROM employees AS e
LEFT JOIN employees_committees AS ec
ON e.id = ec.employee_id
WHERE committee_id IS NULL;
