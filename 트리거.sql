/* trigger (방아쇠)는 특정 테이블에 이벤트(insert or update)가 발생되었을 때 
처리하고 싶은 업무를 작성한다. 
*/
-- 기존 트리거가 있다면 삭제하고, 없다면 에러가 터지지 않도록 한다. 
DROP TRIGGER if EXISTS tg_insert_개인고객_고객번호2; 
DELIMITER $$ -- 세미콜론(끝)의 역할을 $$로 변경하겠다.

CREATE TRIGGER tg_insert_개인고객_고객번호2 -- create trigger 트리거 이름 
BEFORE INSERT ON 개인고객2 -- 시점(before/after), 이벤트 그리고  대상 테이블 
FOR EACH ROW -- 각각의 row마다 실행 
BEGIN -- 업무 내용 시작 
    DECLARE num INT; -- 변수 선언 
	SET num = 0; -- 초기화 (값 대입) 

   /* NEW.고객 번호는 개인 고객2에 INSERT 되려고 하는 새로운 고객 번호임. 
   새로운 고객번호가 법인 고객2 테이블에 있다면 NUM 변수에 1이 저장되고
   없다면 NUM 변수에 0이 저장됨.  */
	SELECT COUNT(1) INTO num FROM 법인고객2 WHERE 고객번호 = NEW.고객번호;
	
   /*NUM값이 0이 아니라는 것은 법인고객2 테이블에 개인고객2에 INSERT하려는 고객번호가
   있다는 뜻 -> 결국 인서트 안 됨. */
	if num != 0 then 
   -- 에러 메세지가 뜨면서 개인고객2 테이블에 INSERT가 취소됨. 
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '법인 고객2에 존재하는 중복된 고객번호입니다.';
	END if;
	
END; $$ -- 업무 내용 끝 
DELIMITER ; -- 종료 표기를 $$에서 다시 ; 세미콜론으로 변경한다.

DROP TRIGGER if EXISTS tg_update_개인고객_고객번호2; 
DELIMITER $$

CREATE TRIGGER tg_update_개인고객_고객번호2 
BEFORE UPDATE ON 개인고객2
FOR EACH ROW 
BEGIN 
	DECLARE num INT;
	SET num = 0;	

	SELECT COUNT(1) INTO num FROM 법인고객2 WHERE 고객번호 = NEW.고객번호;
	
	if num != 0 then 
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '법인 고객2에 존재하는 중복된 고객번호입니다.';
	END if;
	
END; $$
DELIMITER ;

DROP TRIGGER if EXISTS tg_insert_법인고객_고객번호2; 
DELIMITER $$

CREATE TRIGGER tg_insert_법인고객_고객번호2
BEFORE INSERT ON 법인고객2
FOR EACH ROW 
BEGIN 
	DECLARE num INT;
	SET num = 0;	

	SELECT COUNT(1) INTO num FROM 개인고객2 WHERE 고객번호 = NEW.고객번호;
	
	if num != 0 then 
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '개인 고객2에 존재하는 중복된 고객번호입니다.';
	END if;
	
END; $$
DELIMITER ;


DROP TRIGGER if EXISTS tg_update_법인고객_고객번호2; 
DELIMITER $$

CREATE TRIGGER tg_update_법인고객_고객번호2
BEFORE update ON 법인고객2
FOR EACH ROW 
BEGIN 
	DECLARE num INT;
	SET num = 0;	

	SELECT COUNT(1) INTO num FROM 개인고객2 WHERE 고객번호 = NEW.고객번호;
	
	if num != 0 then 
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '개인 고객2에 존재하는 중복된 고객번호입니다.';
	END if;
	
END; $$
DELIMITER ;