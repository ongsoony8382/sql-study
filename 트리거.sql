CREATE TABLE 개인고객(
	  주민등록번호 VARCHAR(14) PRIMARY KEY 
	, 생년월일 DATE
	, 성별 VARCHAR(1) CHECK (성별 IN ('F', 'M'))
	, 결혼여부 VARCHAR(1) CHECK (결혼여부 IN ('O', 'X'))
);

CREATE TABLE 법인고객(
	  법인등록번호 VARCHAR(14) PRIMARY KEY 
	, 대표자명 VARCHAR(5)
	, 설립일자 DATE 
);

CREATE TABLE 고객 (
	  고객번호 BIGINT PRIMARY KEY AUTO_INCREMENT 
	, 고객명 VARCHAR(5) NOT NULL 
	, 고객구분코드 VARCHAR(2) NOT NULL
	, 고객고유번호 VARCHAR(14) NOT NULL UNIQUE 
);

INSERT INTO 개인고객
   SET 주민등록번호 = '901010-1770001';

INSERT INTO 고객
   SET 고객명 = '개인고객1'
     , 고객구분코드 = '개인'
     , 고객고유번호 = '901010-1770001';

INSERT INTO 법인고객
   SET 법인등록번호 = '130111-0006246';

INSERT INTO 고객
   SET 고객명 = '삼성전자'
     , 고객구분코드 = '법인'
     , 고객고유번호 = '130111-0006246';


CREATE TABLE 개인고객2(
    고객번호 BIGINT PRIMARY KEY
  , 주민등록번호 VARCHAR(14) NOT NULL UNIQUE
  , 생년월일 DATE
  , 성별 VARCHAR(1) CHECK (성별 IN ('F', 'M'))
  , 결혼여부 VARCHAR(1) CHECK (결혼여부 IN ('O', 'X'))
);

CREATE TABLE 법인고객2(
    고객번호 BIGINT PRIMARY KEY
  , 법인등록번호 VARCHAR(14) NOT NULL UNIQUE
  , 대표자명 VARCHAR(5)
  , 설립일자 DATE
);

CREATE TABLE 고객2 (
    고객번호 BIGINT PRIMARY KEY
  , 고객명 VARCHAR(5) NOT NULL
  , 고객구분코드 VARCHAR(2) NOT NULL
);