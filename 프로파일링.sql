-- 프로파일링 상태 확인
SELECT @@profiling;
-- 프로파일링 활성화
SET profiling = 1;
-- 프로파일링 비활성화
SET profiling = 0;
-- 프로파일링 내용 확인
SHOW PROFILES;