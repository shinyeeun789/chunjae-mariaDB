USE shop;

-- 트랜잭션(Transaction)

-- 재고 테이블
CREATE TABLE inven(
	ino INT PRIMARY KEY AUTO_INCREMENT,
	pid VARCHAR(20),
	qty INT);

-- 판매 테이블	
CREATE TABLE sale(
	sno INT PRIMARY KEY AUTO_INCREMENT,
	pid VARCHAR(20),
	qty INT);

SHOW TABLES;

-- 입고
INSERT INTO inven(pid, qty) VALUES ('a001', 12);
INSERT INTO inven(pid, qty) VALUES ('b001', 25);
INSERT INTO inven(pid, qty) VALUES ('c001', 18);
INSERT INTO inven(pid, qty) VALUES ('a001', 11);
INSERT INTO inven(pid, qty) VALUES ('b001', 12);
INSERT INTO inven(pid, qty) VALUES ('c001', 14);

CREATE VIEW pro_view1 AS (SELECT pid, SUM(qty) AS '재고합계' FROM inven GROUP BY pid);

SELECT * FROM pro_view1;

-- 출고 (트랜잭션 처리)
START TRANSACTION;

SAVEPOINT a;

INSERT INTO sale(pid, qty) VALUES ('a001', 5);

UPDATE inven SET qty = qty-5
WHERE pid = 'a001' AND ino = (SELECT MIN(ino) FROM inven WHERE pid='a001' GROUP BY pid);

SELECT * FROM inven;

ROLLBACK; 				-- 전부 롤백(이전 commit 이후로 다 사라짐)
ROLLBACK TO a;			-- 해당 SAVEPOINT 내용만 롤백

COMMIT;


-- 트랜잭션 처리가 되지 않으면, 재고 처리 시스템에 문제가 발생하므로 이러한 경우 간혹 차집합으로 연산하는 경우가 있음. 그러나 테이블의 변화를 예측하기 힘든 현상이 발생하기 때문에 사용하지 않는 것이 좋다.
CREATE VIEW jk AS (SELECT * FROM inven EXCEPT SELECT * FROM sale);


CREATE TABLE student(
	sno INT PRIMARY KEY AUTO_INCREMENT,
	sname VARCHAR(100),
	kor INT,
	eng INT,
	mat INT);
	
-- 5명의 학생 성적 데이터를 추가
INSERT INTO student(sname, kor, eng, mat)
VALUES('서동성', 85, 90, 70);

SELECT * FROM student;

-- ave가 80점 이상이면 합격, 아니면 보충대상자 출력
SELECT sname AS name, kor+eng+mat AS tot, ROUND((kor+eng+mat)/3) AS ave, if(ROUND((kor+eng+mat)/3) >= 80, '합격', '보충대상자') AS pan
FROM student
GROUP BY sname;

-- 학점까지 출력
SELECT sname AS name, kor+eng+mat AS tot, ROUND((kor+eng+mat)/3) AS ave, 
	if(ROUND((kor+eng+mat)/3) >= 80, '합격', '보충대상자') AS pan,
	case
		when ROUND((kor+eng+mat)/3) BETWEEN 90 AND 100 then 'A'
		when ROUND((kor+eng+mat)/3) BETWEEN 80 AND 89 then 'B'
		when ROUND((kor+eng+mat)/3) BETWEEN 70 AND 79 then 'C'
		ELSE 'F'
	END AS hak
FROM student
GROUP BY sname;