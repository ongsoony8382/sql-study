/*사원번호가 1100으로 시작하면서 사원번호가 5자리인 사원의 정보를 모두 조회*/

-- ALL
EXPLAIN 
SELECT *
FROM employees
WHERE emp_no LIKE '1100_';


-- range
EXPLAIN 
SELECT *
FROM employees
WHERE emp_no >= 11000 AND emp_no <= 11009;

EXPLAIN 
SELECT *
FROM employees
WHERE emp_no BETWEEN 11000 AND 11009;

-- ALL
EXPLAIN
SELECT *
FROM employees 
WHERE SUBSTRING(emp_no, 1, 4) = 1100
AND LENGTH(emp_no) = 5;


/* 성별 기준으로 몇 명의 사원이 있는지 출력하는 쿼리
null인 경우는 NO DATA로 표시하시오. */

EXPLAIN 
SELECT IFNULL(gender, 'NO DATA') AS group_gender, gender, COUNT(gender)
FROM employees
GROUP BY gender;

EXPLAIN 
SELECT gender, COUNT(gender)
FROM employees
GROUP BY gender;

/* 사용여부 use_yn 값이 1인 데이터의 row 수 */

-- 0.45s
EXPLAIN
SELECT COUNT(1)
FROM salaries
WHERE use_yn = 1;

-- 0.000s
EXPLAIN
SELECT COUNT(1)
FROM salaries
WHERE use_yn = '1';