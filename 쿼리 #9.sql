-- person 테이블 
-- DDL, DML. DCL
-- 자연키(의미가 있는 키 - 업무키), 대리키(아무런 의미가 없는 데이터)
-- 복합키
-- 이름, 생일
-- 이름, 주소

/*
CRUD

Create (생성 - insert) 
Read (읽기 - select)
Update (수정 - update)
Delete (삭제 - delete)

*/
 

CREATE TABLE person (
   NAME VARCHAR(40),
   eye_color CHAR(2) CHECK (eye_color IN ('BL', 'BR', 'GR')),
   bitth_date DATE,
   address VARCHAR(100),
   favorite_foods VARCHAR(200)
);

INSERT INTO person
(NAME, eye_color, bitth_date, address, favorite_foods)
VALUES 
('홍길동', 'BL', '2020-10-10', '대구시 중구', '김치찌개');

INSERT INTO person
VALUES 
('홍길동2', 'BL', '2020-10-10', '대구시 중구', '김치찌개');

/*ALTER TABLE person
CHANGE COLUMN bitth_date birth_date DATE;*/

INSERT INTO person
SET NAME = '신사임당'
, eye_color = 'BL'
, birth_date = '2019-01-02'
, address = '서울시 서초동'
, favorite_foods = '한우 스테이크';

INSERT INTO person
(NAME, eye_color, birth_date, address, favorite_foods)
VALUES 
('홍길동5', 'BL', '2020-10-10', '대구시 중구', '김치찌개')
, ('홍길동6', 'BL', '2020-10-10', '대구시 중구', '김치찌개');

INSERT INTO person
(NAME, eye_color, birth_date, address, favorite_foods)
SELECT '홍길동8', 'BR', '2011-08-12', '경상북도 포항', '과메기'; -- 이렇게도 INSERT 가능

-- CHECK 제약조건
INSERT INTO person
SET NAME = '신사임당2'
, eye_color = 'BB'
, birth_date = '2019-01-02'
, address = '서울시 서초동'
, favorite_foods = '한우 스테이크';

-- select 
SELECT * FROM person;

-- 특정 컬럼만 보고 싶은 경우 select from 사이에 컬럼명 작성 
SELECT NAME, birth_date FROM person;

-- 표시 컬럼명을 변경하고 싶을 때 
SELECT NAME AS '이름', birth_date '생년월일' FROM person;

-- where절(조건문)이 있으면 부분 rows를 가져오겠다는 의미 
-- 대구시 중구에 살고 있는 사람 정보
SELECT * FROM person
WHERE address = '대구시 중구';

-- 0:false, 1: true 결과가 true인 row만 가져오게 된다.
SELECT *, address = '대구시 중구' FROM person;

/*
조건을 추가하고 싶다면 AND, OR을 사용해야 한다.
AND, OR

1 AND 0 OR 1 >> TRUE
=> 1 AND 0 = FALSE 
=> 0 OR 1 =  TRUE

1 AND (0 OR 1) >> TRUE
=> 0 OR 1 = TRUE 
=> 1 AND 1 = TRUE

*/

-- 대구시 중구에 살면서 눈 색상이 GR인 사람의 정보를 보고 싶다.
SELECT * 
FROM person
WHERE address = '대구시 중구' -- 1천명
AND eye_color = 'GR'; -- 1만명

SELECT *, address = '대구시 중구', eye_color = 'GR'
FROM person;

-- 수정 
UPDATE person 
   SET eye_color = 'BR'
WHERE NAME = '홍길동2';

UPDATE person
   SET eye_color = 'BR'
WHERE NAME = '홍길동5';

-- 홍길동6, 눈 색상 -GR, 좋아하는 음식은 '된장찌개'로 변경
UPDATE person
   SET eye_color='GR',
       favorite_foods = '된장찌개'
WHERE NAME = '홍길동6';

-- WHERE 조건에 맞는 ROW가 없기 때문에 영향받은 행의 수는 0이다.
-- 에러가 터지진 않는다. 에러는 문법상 문제가 있을 때 터진다.
UPDATE person
   SET eye_color='GR',
       favorite_foods = '된장찌개'
WHERE NAME = '홍길동9';

-- ROW 표시 순서 정렬 order by, 오름차순 ASC, 내림차순 DESC
SELECT * FROM person
ORDER BY eye_color DESC, NAME DESC; 

-- 그룹 정렬 (group by 문장이 있느냐 없느냐) 
-- 그룹 함수 (min, max, count, avg, sum) 

SELECT COUNT(*) FROM person;
SELECT MIN(address) FROM person;
SELECT MAX(address) FROM person;

-- distinct를 통한 중복 제거 (내부적으로 group by)
SELECT DISTINCT eye_color FROM person;

-- group by를 통한 중복 제거 
SELECT eye_color, COUNT(*) FROM person
GROUP BY eye_color;

SELECT eye_color, COUNT(*), MIN(address), MAX(address) FROM person
GROUP BY eye_color; 

-- LIKE _ %
SELECT * FROM person
WHERE NAME LIKE '%길동%';

SELECT * FROM person
WHERE NAME LIKE '%길동_';

-- union(중복 제거), union all(중복 허용)

-- 9 rows
SELECT NAME FROM person
UNION
SELECT address FROM person;

-- 12 rows 
SELECT NAME FROM person
UNION ALL 
SELECT address FROM person;


-- limit 
-- 이 결과에서 
SELECT * FROM person; 

-- 위 두 row만 가져온다. 
SELECT * FROM person
LIMIT 2;

-- 이 결과에서 
SELECT * FROM person ORDER BY eye_color; 

-- 위 세 row만 가져온다. 
SELECT * FROM person ORDER BY eye_color LIMIT 3; 


-- LIMIT 인자 2개 (index, length)
-- 이 결과에서 
SELECT * FROM person; 

SELECT * FROM person LIMIT 2, 3; 

-- 서브 쿼리 
-- 위치 : SELECT-FROM(COLUMN) 사이, WHERE 절, FROM 절(인라인 뷰)

-- 스칼라 값 (Scalar) one row, one column
SELECT '홍길동';

-- select-from(column) 사이는 서브 쿼리 결과가 스칼라 값이어야 한다.
-- 에러 발생 
SELECT NAME, (SELECT address FROM person) FROM person;
SELECT address FROM person;

-- 스칼라값 
SELECT address FROM person WHERE address LIKE '%포항%';
-- 문제 없음
SELECT NAME, (SELECT address FROM person WHERE address LIKE '%포항%') FROM person;

(SELECT address, favorite_foods FROM person WHERE address LIKE '%포항%');

SELECT NAME, (SELECT address, favorite_foods FROM person WHERE address LIKE '%포항%')
FROM person;

/* 인라인 뷰(inline view), AS 필수, from 절에서 서브쿼리 사용 
   테이블 이름도 ALIAS(별명) 줄 수 있음. 
   I.G. 테이블 이름 AS B
        테이블 이름 B 
*/

SELECT *
FROM (
   SELECT NAME, address FROM person
) A;

-- WHERE절에서 서브 쿼리 

-- 스칼라 값인 경우 = (equal) 사용

-- 스칼라값 o
SELECT * FROM person
WHERE NAME = (SELECT NAME FROM person WHERE address LIKE '%포항%');

SELECT * FROM person
WHERE NAME = '홍길동7';


-- 스칼라값 x
-- 컬럼 1개 row가 많은 경우 (in 연산자 사용)
SELECT eye_color FROM person WHERE address = '대구시 중구';

SELECT * FROM person 
WHERE eye_color IN (SELECT eye_color FROM person WHERE address = '대구시 중구');

-- 컬럼 2개 row가 많은 경우 (in 연산자 사용)
SELECT NAME, address FROM person WHERE favorite_foods = '김치찌개';

SELECT * FROM person
WHERE (NAME, address) IN (SELECT NAME, address FROM person  
                           WHERE favorite_foods = '김치찌개'); 
                           
-- delete (row 삭제)
SELECT @@autocommit; -- (세션)autocommit 상태 확인
SET autocommit = 0; -- autocommit off(끄기)

DELETE FROM person
WHERE NAME = '홍길동5';

ROLLBACK; -- 원 상태로 복원
COMMIT; -- 현 상태로 적용 











