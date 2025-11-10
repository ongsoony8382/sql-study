-- 프로파일링 상태 확인
SELECT @@profiling;
-- 프로파일링 활성화
SET profiling = 1;
-- 프로파일링 비활성화
SET profiling = 0;
-- 프로파일링 내용 확인
SHOW PROFILES;

SELECT @@autocommit; -- (세션)autocommit 상태 확인
SET autocommit = 0; -- autocommit off 끄기
SET autocommit = 1; -- autocommit on 켜기