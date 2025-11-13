-- 오라클 기준 
-- 1. 컬럼 단위 제약조건
    CREATE TABLE emp(
        emp_id NUMBER PRIMARY KEY,
        dept_id  NUMBER REFERENCES dept(dept_id) ON DELETE CASCADE     
    );

-- 2. 테이블 레벨 제약조건
      CREATE TABLE emp(
      emp_id NUMBER,
      dept_id NUMBER 
      CONSTRAINT pk_emp PRIMARY KEY(emp_id),
      CONSTRAINT fk_emp_dept FOREIGN KEY(dept_id)
      REFERENCES dept(dept_id) ON DELETE CASCADE
      );

-- 3. CREATE 후 ALTER

-- 3.1. 연속해서 여러 번 (가능하지만 비추천)
      ALTER TABLE emp ADD CONSTRAINT pk_emp PRIMARY KEY(emp_id);
      ALTER TABLE emp ADD CONSTRAINT fk_emp_dept FOREIGN KEY(dept_id) 
      REFERENCES dept(dept_id) ON DELETE CASCADE;

-- 3.2. 괄호로 묶어서 한 번에 여러 개
      ALTER TABLE emp 
      ADD (
         CONSTRAINT pk_emp PRIMARY KEY(emp_id),
         CONSTRAINT fk_emp_dept FOREIGN KEY(dept_id)
         REFERENCES dept(dept_id) ON DELETE CASCADE
      );
      