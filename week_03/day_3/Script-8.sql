/* Question 1. Are there any pay_details records lacking both a local_account_no and iban number? */

SELECT *
FROM pay_details
WHERE local_account_no AND iban IS NULL;

/* Question 2. Get a table of employees first_name, last_name and country, ordered alphabetically first by country and then by last_name (put any NULLs last). */

SELECT
	first_name,
	last_name,
	country 
FROM employees 
ORDER BY country, last_name, first_name NULLS LAST;

/* Question 3. Find the details of the top ten highest paid employees in the corporation. */

SELECT *
FROM employees
ORDER BY salary DESC NULLS LAST
LIMIT 10;

/* Question 4. Find the first_name, last_name and salary of the lowest paid employee in Hungary. */

SELECT
	first_name,
	last_name,
	salary
FROM employees
WHERE country = 'Hungary';

/* Question 5. Find all the details of any employees with a ‘yahoo’ email address? */

SELECT *
FROM employees
WHERE email LIKE '%yahoo%';

/* Question 6. Obtain a count by department of the employees who started work with the corporation in 2003. */

SELECT
department,
COUNT(*) AS no_employees
FROM employees
WHERE (start_date BETWEEN '2003-01-01' AND '2003-12-31')
GROUP BY department;

/* Question 7. Obtain a table showing department, fte_hours and the number of employees in each department who work each fte_hours pattern. Order the table alphabetically by department, and then in ascending order of fte_hours. */

SELECT 
department,
fte_hours,
COUNT(fte_hours) AS no_employees
FROM employees
GROUP BY department, fte_hours
ORDER BY department, fte_hours;

/* Question 8. Provide a breakdown of the numbers of employees enrolled, not enrolled, and with unknown enrollment status in the corporation pension scheme. */

SELECT
pension_enrol,
COUNT(*) AS enrol_status
FROM employees
GROUP BY pension_enrol;

/* Question 9. What is the maximum salary among those employees in the ‘Engineering’ department who work 1.0 full-time equivalent hours (fte_hours)? */

SELECT
salary
FROM employees
WHERE department = 'Engineering' AND fte_hours = 1
ORDER BY salary DESC
LIMIT 1;

/* Question 10. Get a table of country, number of employees in that country, and the average salary of employees in that country for any countries in which more than 30 employees are based. Order the table by average salary descending. */

SELECT
country,
COUNT(*) AS no_employees,
AVG(salary) AS avg_salary
FROM employees
GROUP BY country
HAVING COUNT(*) > 30
ORDER BY AVG(salary);

/* Question 11. Return a table containing each employees first_name, last_name, full-time equivalent hours (fte_hours), salary, and a new column effective_yearly_salary which should contain fte_hours multiplied by salary. */

SELECT
first_name,
last_name,
fte_hours,
salary,
fte_hours * salary AS effective_yearly_salary
FROM employees;

/* Question 12. Find the first name and last name of all employees who lack a local_tax_code. */

SELECT
e.first_name,
e.last_name,
pd.local_tax_code AS local_tax_code 
FROM employees AS e
INNER JOIN pay_details AS pd
ON e.id = pd.id
WHERE local_tax_code IS NULL;

/* Question 13. The expected_profit of an employee is defined as (48 * 35 * charge_cost - salary) * fte_hours, where charge_cost depends upon the team to which the employee belongs. Get a table showing expected_profit for each employee. */

SELECT
e.first_name,
e.last_name,
(((48 * 35 * CAST(t.charge_cost AS INTEGER)) - salary) * fte_hours) AS expected_profit
FROM employees AS e
LEFT JOIN teams AS t
ON e.team_id = t.id;

/* Question 14. Obtain a table showing any departments in which there are two or more employees lacking a stored first name. Order the table in descending order of the number of employees lacking a first name, and then in alphabetical order by department. */

SELECT
department,
COUNT(*) AS no_employees
FROM employees
WHERE first_name IS NULL 
GROUP BY department
HAVING COUNT(*) >= 2
ORDER BY COUNT(id), department;

/* Question 15. [Bit Tougher] Return a table of those employee first_names shared by more than one employee, together with a count of the number of times each first_name occurs. Omit employees without a stored first_name from the table. Order the table descending by count, and then alphabetically by first_name. */

SELECT 
first_name,
COUNT(*) AS no_names
FROM employees
WHERE first_name IS NOT NULL
GROUP BY first_name
HAVING COUNT(*) >= 2
ORDER BY COUNT(*), first_name;

/* Question 16.
[Tough] Find the proportion of employees in each department who are grade 1. */

WITH total_employees AS (
SELECT
department,
COUNT(*) AS no_employees
FROM employees
GROUP BY department)

SELECT
e.department,
COUNT(e.*) AS no_grade1, 100 * COUNT(e.*)/t.no_employees AS percentage_grade1
FROM employees AS e
INNER JOIN total_employees as t
ON e.department = t.department    
WHERE grade = 1
GROUP BY e.department, t.no_employees;


ANSWERS:

WITH grade_1_count AS (
SELECT
	department,
	CAST(COUNT(id) AS REAL) AS count_grade_1
FROM employees
WHERE grade = 1
GROUP BY department
),
department_count AS (
SELECT
	department,
	COUNT(id) AS count_all
FROM employees
GROUP BY department
)
SELECT
	dc.department,
	g1.count_grade_1,
	dc.count_all,
	g1.count_grade_1/dc.count_all AS grade_1_prop
FROM department_count AS dc
INNER JOIN grade_1_count as g1
ON dc.department = g1.department;

