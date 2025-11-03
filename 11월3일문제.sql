-- 최소 일주일 동안 대여할 수 있는 G등급의 영화를 찾고 싶다.
-- rental_duration (대여가능기간)

SELECT * FROM film
WHERE rental_duration > 6
AND rating = 'G';

/*최소 일주일 동안 대여할 수 있는 G등급의 영화이거나 
PG-13등급이면서 3일 이하로만 대여할 수 있는 영화의 정보*/

SELECT * FROM film
WHERE rental_duration > 6 AND rating = 'G'
OR rating = 'PG-13' AND rental_duration <=3;

/* 40편 이상의 영화를 대여한 모든 고객의 정보
표시컬럼: 이름, 성, 갯수
7 rows
고객: customer
대여: rental 
*/

SELECT c.last_name, c.first_name, COUNT(r.customer_id) 
FROM customer c
JOIN rental r
ON c.customer_id = r.customer_id
GROUP BY r.customer_id
HAVING COUNT(r.customer_id) >= 40;


-- 고객별 대여 수 
SELECT customer_id, COUNT(*) cnt
FROM rental
GROUP BY customer_id;

-- group by 결과에 대한 조건문을 사용하고 싶으면 having 절 사용

SELECT C.first_name, C.last_name, R.customer_id, COUNT(*) cnt
FROM rental R
INNER JOIN customer C
ON C.customer_id = R.customer_id
GROUP BY R.customer_id , C.last_name, C.first_name
HAVING cnt >=40;

-- 2005년 06월 14일에 대여한 모든 고객 정보 

SELECT C.*
FROM rental R
JOIN customer C
ON R.customer_id = C.customer_id
WHERE DATE(R.rental_date) = '2005-06-14';

SELECT C.first_name, C.last_name, R.rental_date
FROM rental R
JOIN customer C
ON R.customer_id = C.customer_id
WHERE R.rental_date BETWEEN '2005-06-13 23:59:59' AND '2005-06-14 23:59:59';

-- 프로파일링 상태 확인
SELECT @@profiling;
-- 프로파일링 활성화
SET profiling = 1;
-- 프로파일링 내용 확인
SHOW PROFILES;
-- 프로파일링 비활성화
SET profiling = 0;

