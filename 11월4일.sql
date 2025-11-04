/* 모든 고객의 성, 이름, 주소 조회*/
SELECT C.last_name, C.first_name, A.address
FROM customer C
INNER JOIN address A
ON A.address_id = C.address_id;

/* 모든 고객의 이름, 성, 살고 있는 도시 */
SELECT C.last_name, C.first_name, CT.city
FROM customer C
JOIN address A
ON A.address_id = C.address_id
JOIN city CT
ON A.city_id = CT.city_id;

/* 캘리포니아에 거주하는 모든 고객의 이름, 성, 주소 및 도시 조회*/
SELECT  C.last_name, C.first_name, A.address, CT.city
FROM customer C
JOIN address A
ON A.address_id = C.address_id
JOIN city CT
ON A.city_id = CT.city_id
WHERE A.district = 'California';

SELECT  C.last_name, C.first_name, A.address, CT.city
FROM customer C
JOIN address A
ON A.address_id = C.address_id
AND A.district = 'California'
JOIN city CT
ON A.city_id = CT.city_id;

/* Cate McQueen 또는 Cuba Birch가 출연한 모든 영화를 조회 */

SELECT F.title 
FROM film F
JOIN film_actor FA
ON F.film_id = FA.film_id
JOIN actor A 
ON FA.actor_id = A.actor_id
WHERE (A.first_name, A.last_name) IN (('Cate', 'McQueen'), ('Cuba', 'Birch'));

SELECT F.title, A.first_name, A.last_name, F.film_id
FROM film F
JOIN film_actor FA
ON F.film_id = FA.film_id
JOIN actor A 
ON FA.actor_id = A.actor_id
WHERE (A.first_name = 'Cate' AND A.last_name = 'McQueen')
OR (A.first_name = 'Cuba' AND A.last_name = 'Birch');

SELECT distinct F.film_id
FROM film F
JOIN film_actor FA
ON F.film_id = FA.film_id
JOIN actor A 
ON FA.actor_id = A.actor_id
WHERE (A.first_name = 'Cate' AND A.last_name = 'McQueen')
OR (A.first_name = 'Cuba' AND A.last_name = 'Birch');

SELECT A.first_name
FROM film F
JOIN film_actor FA
ON F.film_id = FA.film_id
JOIN actor A 
ON FA.actor_id = A.actor_id
WHERE (A.first_name = 'Cate' AND A.last_name = 'McQueen')
OR (A.first_name = 'Cuba' AND A.last_name = 'Birch')
GROUP BY A.first_name;

/* Cate McQueen과  Cuba Birch가 함께 출연한 모든 영화를 조회 */
SELECT F.title 
FROM film F
JOIN film_actor FA
ON F.film_id = FA.film_id
JOIN actor A 
ON FA.actor_id = A.actor_id
WHERE (FA.actor_id, FA.film_id) IN (SELECT FA.actor_id 
                     FROM film_actor FA 
                     JOIN actor A ON A.actor_id = FA.actor_id 
                     WHERE  (A.first_name = 'Cate' AND A.last_name = 'McQueen')
                            OR (A.first_name = 'Cuba' AND A.last_name = 'Birch')
                            GROUP BY actor_id, SELECT FA.film_id
FROM film_actor FA 
JOIN actor A ON A.actor_id = FA.actor_id 
WHERE  (A.first_name = 'Cate' AND A.last_name = 'McQueen')
OR (A.first_name = 'Cuba' AND A.last_name = 'Birch')
GROUP BY film_id);
                            
SELECT FA.actor_id
FROM film_actor FA 
JOIN actor A ON A.actor_id = FA.actor_id 
WHERE  (A.first_name = 'Cate' AND A.last_name = 'McQueen')
OR (A.first_name = 'Cuba' AND A.last_name = 'Birch')
GROUP BY actor_id;

SELECT FA.actor_id
FROM film_actor FA 
JOIN actor A ON A.actor_id = FA.actor_id 
WHERE  (A.first_name = 'Cate' AND A.last_name = 'McQueen')
OR (A.first_name = 'Cuba' AND A.last_name = 'Birch');

SELECT FA.film_id
FROM film_actor FA 
JOIN actor A ON A.actor_id = FA.actor_id 
WHERE  (A.first_name = 'Cate' AND A.last_name = 'McQueen')
OR (A.first_name = 'Cuba' AND A.last_name = 'Birch')
GROUP BY film_id;

/* Cate McQueen과  Cuba Birch가 함께 출연한 모든 영화를 조회 */

SELECT F.title
FROM film F
INNER JOIN film_actor FA1
ON FA1.film_id = F.film_id
INNER JOIN actor A1
ON A1.actor_id = FA1.actor_id
AND (A1.first_name = 'Cate' AND A1.last_name = 'McQueen')
INNER JOIN film_actor FA2
ON FA2.film_id = F.film_id
INNER JOIN actor A2
ON A2.actor_id = FA2.actor_id
AND (A2.first_name = 'Cuba' AND A2.last_name = 'Birch');
SELECT F.title
FROM film F
INNER JOIN film_actor FA1
ON FA1.film_id = F.film_id
INNER JOIN actor A1
ON A1.actor_id = FA1.actor_id
INNER JOIN film_actor FA2
ON FA2.film_id = F.film_id
INNER JOIN actor A2
ON A2.actor_id = FA2.actor_id
WHERE (A1.first_name = 'Cate' AND A1.last_name = 'McQueen')
AND (A2.first_name = 'Cuba' AND A2.last_name = 'Birch');
SELECT title
FROM film F
INNER JOIN (
	-- 2명의 배우가 출연한 모든 영화 조회 후
	-- film_id로 그룹을 만들고 count가 2인 film_id를 구한다.
	-- count가 2인 것은 2명의 배우가 모두 출연한 영화라는 의미
	SELECT FA.film_id, COUNT(1) AS cnt
	FROM film_actor FA
	INNER JOIN actor A
	ON A.actor_id = FA.actor_id
	WHERE (A.first_name = 'Cate' AND A.last_name = 'McQueen')
   	OR (A.first_name = 'Cuba' AND A.last_name = 'Birch')
	GROUP BY FA.film_id
	HAVING cnt = 2
) R
ON R.film_id = F.film_id;

-- 상관 서브쿼리 
-- 고객의 영화 대여를 정확히 20번 한 고객 조회 
-- 메인 쿼리, 서브 쿼리 

-- 1. 메인 쿼리, 결과물을 서브쿼리로 전달
-- 2. 서브 쿼리, 결과물을 메인쿼리로 전달
-- 3. 메인 쿼리 결과 도출 

SELECT C.first_name, C.last_name
FROM customer c 
WHERE 20 = (SELECT COUNT(1) FROM rental R
            WHERE R.customer_id = C.customer_id); 

-- 1. 
SELECT C.first_name, C.last_name, C.customer_id
FROM customer C;

-- 2. 
SELECT COUNT(1) cnt, R.customer_id FROM rental R
WHERE R.customer_id 
GROUP BY R.customer_id
HAVING cnt = 20;

-- 3. 1번, 2번 결과물을 조합 














                            
                            