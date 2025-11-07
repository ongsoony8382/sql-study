USE tuning;
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
WHERE emp_no >= 11000
  AND emp_no <= 11009;

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

/* 이름이 'Radwan이고 성별이 남자인 사원을 조회 */

-- All (인덱스를 가공하면 인덱스가 없는 것처럼 작동하므로 가공 하면 안 됨. )
EXPLAIN
SELECT *
FROM employees
WHERE CONCAT(gender, last_name) = 'MRdawan';

-- ref
EXPLAIN
SELECT *
FROM employees
WHERE gender = 'M'
  AND last_name = 'Radwan';

/* 부서 관리자의 사원 번호, 이름, 성, 부서번호 데이터를 중복 제거하여 조회 */
-- DM - index / E - eq_ref
EXPLAIN
SELECT E.emp_no, E.last_name, E.first_name, DM.dept_no
FROM dept_manager DM
         JOIN employees E
              ON DM.emp_no = E.emp_no;

/* UNION ALL 이용
   성이 'Baba' 이면서 성별이 남자인 사원과, 성이 'Baba'이면서 성별이 여자인 사원 조회*/

-- range
EXPLAIN
SELECT *
FROM employees
WHERE last_name = 'Baba' AND gender = 'F'
   OR last_name = 'Baba' AND gender = 'M';

-- 인덱스를 활용하지 못하는 쿼리 (ALL)
EXPLAIN
SELECT *
FROM employees
WHERE last_name = 'Baba';

-- SELECT에 인덱스 걸린 컬럼을 명시해주면 이렇게 적어도 RANGE 나옴
EXPLAIN
SELECT gender, emp_no
FROM employees
WHERE last_name = 'Baba';

-- REF, REF
EXPLAIN
SELECT gender, emp_no
FROM employees
WHERE gender = 'F'
  AND last_name = 'Baba'

UNION ALL

SELECT gender, emp_no
FROM employees
WHERE gender = 'M'
  AND last_name = 'Baba';

/* 직원의 성과 성별 순서로 그룹핑하여 몇 건의 데이터가 있는지 구하시오. */
-- 그룹바이에 적는 인덱스 순서에 따라 Extra가 달라짐.

-- index , Using index; Using temporary
EXPLAIN
SELECT last_name, gender, COUNT(1)
FROM employees
GROUP BY last_name, gender;

-- index, Using index
EXPLAIN
SELECT last_name, gender, COUNT(1)
FROM employees
GROUP BY gender, last_name;

/* 사원의 입사일자 값이 '1989'로 시작하면서 사원번호가 100_000를 초과하는 데이터를 조회 */

-- 300,024 rows
SELECT COUNT(1)
FROM employees;
-- 28,394 rows
SELECT COUNT(1)
FROM employees
WHERE hire_date LIKE '1989%';
-- 210024 rows
SELECT COUNT(1)
FROM employees
WHERE emp_no > 100000;

-- filtered가 11.11 -> 손해
EXPLAIN
SELECT emp_no
FROM employees
WHERE hire_date LIKE '1989%'
  AND emp_no > 100000;

-- filtered가 100 -> 굿
EXPLAIN
SELECT emp_no
FROM employees USE INDEX (I_입사일자)
WHERE hire_date LIKE '1989%'
  AND emp_no > 100000;

EXPLAIN
SELECT emp_no
FROM employees USE INDEX (I_입사일자)
WHERE hire_date >= '1989-01-01'
  AND hire_date < '1990-01-01'
  AND emp_no > 100000;

/* 4.2.9 emp_access_logs (사원출입기록), door(출입문)
   'B' 출입문으로 출입한 이력이 있는 정보를 모두 조회
 */


-- 인덱스 활용을 못하는데 인덱스를 갖고 있으면 속도 저하
-- ref
EXPLAIN
SELECT *
FROM emp_access_logs
WHERE door = 'B';

-- 그땐 All이 나은 경우가 있음.
EXPLAIN
SELECT *
FROM emp_access_logs IGNORE INDEX (I_출입문)
WHERE door = 'B';

-- 660,000 rows
SELECT COUNT(1)
FROM emp_access_logs;

-- 300,000 rows
SELECT COUNT(1)
FROM emp_access_logs
WHERE door = 'B';

/* 4.2.10 입사일자가 1994년 1월 1일부터 2000년 12월 31일까지인 사원들의
   이름과 성을 출력*/

-- All 테이블 스캔
EXPLAIN
SELECT last_name, first_name
FROM employees
WHERE hire_date BETWEEN STR_TO_DATE('1994-01-01', '%Y-%m-%d')
          AND STR_TO_DATE('2000-12-31', '%Y-%m-%d');

-- range 인덱스 강제 사용
EXPLAIN
SELECT last_name, first_name
FROM employees FORCE INDEX (I_입사일자)
WHERE hire_date BETWEEN STR_TO_DATE('1994-01-01', '%Y-%m-%d')
          AND STR_TO_DATE('2000-12-31', '%Y-%m-%d');

-- 데이터가 엄청 많으면 random access(range)보다 sequence access(all)가 빠를 수도 있음
-- 300,024 rows
SELECT COUNT(1)
FROM employees;
-- 48,875 rows
EXPLAIN
SELECT COUNT(1)
FROM employees
WHERE hire_date BETWEEN STR_TO_DATE('1994-01-01', '%Y-%m-%d')
          AND STR_TO_DATE('2000-12-31', '%Y-%m-%d');

SELECT 48875 / 300024 * 100; -- 16.29%

SELECT last_name, first_name
FROM employees
WHERE YEAR(hire_date) BETWEEN '1994' AND '2000';

/* 부서사원 테이블 (dept_emp)과 부서(departments) 테이블을 조인하여 부서 시작일자가
   '2002-03-01' 부터인 사원의 데이터를 조회하는 쿼리. 표시 컬럼은 사원 번호, 부서번호 */

EXPLAIN
SELECT DE.emp_no, D.dept_no
FROM departments D
         JOIN dept_emp DE
              ON D.dept_no = DE.dept_no
WHERE DE.from_date >= '2002-03-01';

-- 331,603rows
SELECT COUNT(1)
FROM dept_emp;
-- 1,341 rows
SELECT COUNT(1)
FROM dept_emp
WHERE from_date >= '2002-03-01';
-- 9rows
SELECT COUNT(1)
FROM departments;

EXPLAIN
SELECT STRAIGHT_JOIN DE.emp_no, D.dept_no
FROM departments D
         JOIN dept_emp DE
              ON D.dept_no = DE.dept_no
WHERE DE.from_date >= '2002-03-01';

/* 4.3.2 사원번호가 450,000보다 크고 최대 연봉이 100,000보다 큰 데이터를 찾아 출력하시오.
   즉, 사원 번호가 450,000번을 초과하면서 그동안 받은 연봉 중 한 번이라도 100,000 달러를
   초과한 적이 있는 사원의 정보를 출력.
   표시 컬럼: 사원 번호, 이름, 성
   3,155 rows*/

EXPLAIN
SELECT e.emp_no, e.last_name, e.first_name
FROM employees e
         JOIN salaries s
              ON e.emp_no = s.emp_no
WHERE e.emp_no > 450000
GROUP BY e.emp_no
HAVING MAX(s.salary) > 100000;

/* 'A'출입문으로 출입한 사원이 총 몇 명인지 구하시오 */

SELECT COUNT(DISTINCT emp_no)
FROM emp_access_logs
WHERE door = 'A';

/* -- 5.1.1 */

-- JOIN
EXPLAIN
SELECT E.emp_no, E.first_name, E.last_name, ROUND(AVG(salary)), ROUND(MAX(salary)), ROUND(MIN(salary))
FROM employees E
         INNER JOIN salaries S
                    ON S.emp_no = E.emp_no
WHERE E.emp_no BETWEEN 10001 AND 10100
GROUP BY S.emp_no;

-- STRAIGHT
EXPLAIN
SELECT STRAIGHT_JOIN E.emp_no,
                     E.first_name,
                     E.last_name,
                     ROUND(AVG(salary)),
                     ROUND(MAX(salary)),
                     ROUND(MIN(salary))
FROM salaries S
         INNER JOIN employees E
                    ON S.emp_no = E.emp_no
WHERE E.emp_no >= 10001
  AND E.emp_no < 10101
GROUP BY S.emp_no;

-- 5.1.2 비효율적인 페이징 수행

-- original
SELECT E.emp_no, E.first_name, E.last_name, E.hire_date
FROM employees E
         INNER JOIN salaries S
                    ON S.emp_no = E.emp_no
WHERE E.emp_no BETWEEN 10001 AND 50000
GROUP BY E.emp_no
ORDER BY SUM(S.salary) DESC
LIMIT 150, 10;

--
EXPLAIN
SELECT E.emp_no, E.first_name, E.last_name, E.hire_date
FROM employees e
         INNER JOIN (SELECT emp_no
                     FROM salaries
                     WHERE e.emp_no >= 10001
                       AND e.emp_no <= 50000
                     GROUP BY e.emp_no
                     ORDER BY SUM(salary) DESC
                     LIMIT 150, 10) s
                    ON s.emp_no = e.emp_no;

/* 필요 이상으로 많은 정보를 가져오는 나쁜 sql문
*/
-- original
SELECT count(s.emp_no) as cnt
from (SELECT e.emp_no, dm.dept_no
      FROM (SELECT * FROM employees
                     WHERE gender = 'M'
                     AND emp_no > 300000) e
               LEFT JOIN dept_manager dm
                         ON dm.emp_no = e.emp_no) s;

EXPLAIN
SELECT count(s.emp_no) as cnt
from (SELECT e.emp_no
      FROM (SELECT emp_no FROM employees
                     WHERE gender = 'M'
                     AND emp_no > 300000) e
               ) s;

SELECT count(1) FROM employees
                     WHERE gender = 'M'
                     AND emp_no > 300000;

/*5.1.4 대량의 데이터를 가져와 조인하는 나쁜 sql문*/

-- original
SELECT DISTINCT de.dept_no
FROM dept_manager dm
INNER JOIN dept_emp de
ON de.dept_no = dm.dept_no
ORDER BY de.dept_no;

-- 24
select count(1) from dept_manager;
-- 331,603
select count(1) from dept_emp;

select distinct dept_no from dept_manager;