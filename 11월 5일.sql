USE tuning;

EXPLAIN SELECT * FROM employees;

-- p.122
EXPLAIN 
SELECT * FROM employees
WHERE emp_no BETWEEN 100001 AND 200000;

-- p.123 3.2.2 id
EXPLAIN
SELECT E.emp_no, E.first_name, E.last_name, S.salary,
         (SELECT MAX(DE.dept_no) FROM dept_emp DE 
         WHERE DE.emp_no = E.emp_no) 
FROM employees E
INNER JOIN salaries S
ON S.emp_no = E.emp_no
WHERE E.emp_no = 10001; 

-- select_type - simple
EXPLAIN 
SELECT * FROM employees
WHERE emp_no = 100000; 

EXPLAIN 
SELECT e.emp_no, e.first_name, e.last_name, s.salary     
  FROM employees e
 INNER JOIN ( SELECT emp_no, salary FROM salaries WHERE salary > 80000 ) s
    ON e.emp_no = s.emp_no
 WHERE e.emp_no BETWEEN 10001 AND 10010;
 
EXPLAIN  
SELECT e.emp_no, e.first_name, e.last_name, s.salary     
  FROM employees e
 INNER JOIN salaries s
    ON e.emp_no = s.emp_no
 WHERE e.emp_no BETWEEN 10001 AND 10010
   AND s.salary > 80000;
   
EXPLAIN 
SELECT e.emp_no, e.first_name, e.last_name
     , (SELECT MAX(dept_no) FROM dept_emp d WHERE d.emp_no = e.emp_no) as cnt    
  FROM employees e
 INNER JOIN salaries s
    ON e.emp_no = s.emp_no
 WHERE e.emp_no = 10001;
 
EXPLAIN 
SELECT emp_no, first_name, last_name
   FROM employees s1
  WHERE emp_no = 100001 
  
  UNION ALL 
  
SELECT emp_no, first_name, last_name
   FROM employees s2
  WHERE emp_no = 100002;
  
EXPLAIN  
SELECT ( SELECT COUNT(1) FROM dept_emp ) AS cnt
     , ( SELECT MAX(salary) FROM salaries ) AS salary;

EXPLAIN  
SELECT e.first_name, e.last_name
     , ( SELECT COUNT(1) 
           FROM dept_emp de
          INNER JOIN dept_manager dm
             ON dm.dept_no = de.dept_no ) AS cnt
  FROM employees e
 WHERE e.emp_no = 10001;
 
 SELECT COUNT(1) FROM dept_manager; -- 24건
 SELECT COUNT(1) FROM dept_emp; -- 331,603건
 -- => 쓴 순서대로 안 하고 옵티마이저가 순서 바꿈
 
 
 -- p. 130
EXPLAIN  
SELECT e.first_name, e.last_name
     , ( SELECT COUNT(1) 
           FROM dept_emp de
          INNER JOIN dept_manager dm
             ON dm.dept_no = de.dept_no
            AND de.emp_no = e.emp_no ) AS cnt
  FROM employees e
 WHERE e.first_name = 'Matt';
 
 -- 인라인뷰 -> derived 
EXPLAIN 
SELECT s.emp_no, s.salary
  FROM employees e
 INNER JOIN ( 
       SELECT emp_no, MAX(salary) AS salary 
         FROM salaries 
        WHERE emp_no BETWEEN 10001 AND 20000
        GROUP BY emp_no
     ) s
    ON e.emp_no = s.emp_no;
 
EXPLAIN 
SELECT 'M' AS gender2, gender, MAX(hire_date) AS hire_date
  FROM employees s1
 WHERE gender = 'M'

 UNION  

SELECT 'F', gender, MAX(hire_date)
  FROM employees s2
 WHERE gender = 'F';
 
EXPLAIN 
SELECT dm.dept_no
     , ( SELECT s1.first_name 
           FROM employees s1 
          WHERE s1.gender = 'F'
            AND s1.emp_no = dm.emp_no 
							  
          UNION ALL
							
         SELECT s2.first_name 
           FROM employees s2 
          WHERE s2.gender = 'M'
            AND s2.emp_no = dm.emp_no ) AS manager_name
FROM dept_manager dm;

EXPLAIN 
SELECT *
  FROM employees e1
 WHERE e1.emp_no IN (
       SELECT e2.emp_no FROM employees e2 WHERE e2.first_name = 'Matt'
       UNION
       SELECT e3.emp_no FROM employees e3 WHERE e3.last_name = 'Matt'
     );
     
EXPLAIN
SELECT *
  FROM employees 
 WHERE emp_no = ( SELECT @STATUS 
                    FROM dept_emp 
                   WHERE dept_no='d005' );
                   
EXPLAIN
SELECT *
  FROM employees 
 WHERE emp_no = ( SELECT RAND() FROM dept_emp 
                   WHERE dept_no='d005' );
                   
EXPLAIN
SELECT *
  FROM employees
 WHERE emp_no IN ( SELECT emp_no
                     FROM salaries
                    WHERE salary BETWEEN 100 AND 1000 );
     
EXPLAIN 
SELECT STRAIGHT_JOIN e.emp_no, t.title
FROM titles t
INNER JOIN employees e
ON e.emp_no = t.emp_no
WHERE e.emp_no BETWEEN 10001 AND 10100;


EXPLAIN 
SELECT e.emp_no, t.title
FROM employees e
INNER JOIN titles t
ON e.emp_no = t.emp_no
WHERE e.emp_no BETWEEN 10001 AND 10100;

CREATE INDEX idx_titles_todate
ON titles(to_date);

DROP INDEX idx_titles_todate ON titles;

EXPLAIN 
SELECT *
FROM titles 
WHERE to_date = '1985-03-01'
OR to_date IS NULL;

-- NULL 허용 컬럼에 유니크 인덱스를 생성
CREATE TABLE unique_null_test (
    id INT PRIMARY KEY AUTO_INCREMENT 
  , nm VARCHAR(10) UNIQUE NULL
);

-- nm 값이 있는 Row Insert
INSERT INTO unique_null_test
SET nm = 'aaa';

-- nm이 NULL인 Row Insert 2번
INSERT INTO unique_null_test
SET nm = NULL;

INSERT INTO unique_null_test
SET nm = NULL;

SELECT * FROM unique_null_test;

EXPLAIN 
SELECT id
FROM unique_null_test
WHERE nm IS NULL OR nm = 'aaa';

EXPLAIN
SELECT * FROM employees
WHERE emp_no BETWEEN 10001 AND 100000;

EXPLAIN 
SELECT * FROM employees 
WHERE first_name = 'Aamer';
