-- 회원(member) 테이블 생성
CREATE TABLE member(
	id VARCHAR(16) NOT NULL,
	pw VARCHAR(330) NOT NULL,
	NAME VARCHAR(100) NOT NULL,
	email VARCHAR(100) NOT NULL,
	tel VARCHAR(13),
	regdate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP(),
	POINT INT DEFAULT 0,
	PRIMARY KEY (id));
	
-- 테이블 목록 보기	
SHOW TABLES;

-- 회원 테이블 구조 보기
DESC member;

-- 회원 테이블에 더미데이터 넣기
INSERT INTO member(id, pw, NAME, email, tel)
VALUES('admin','1234', '관리자', 'admin@edu.com', '010-1004-1004');

INSERT INTO member(id, pw, NAME, email, tel)
VALUES('kim','4321', '김이름', 'kim@edu.com', '010-1234-5678');

INSERT INTO member(id, pw, NAME, email, tel)
VALUES('lee','1111', '이이름', 'lee@edu.com', '010-8765-4321');

INSERT INTO member(id, pw, NAME, email, tel)
VALUES('park','2222', '박이름', 'park@edu.com', '010-1111-2222');

INSERT INTO member(id, pw, NAME, email, tel)
VALUES('choi','3456', '최이름', 'park@edu.com', '010-1122-3344');

INSERT INTO member(id, pw, NAME, email, tel)
VALUES('shin','3333', '신이름', 'shin@edu.com', '010-0987-6543');


-- 게시판 테이블 생성
CREATE TABLE board(
	bno INT PRIMARY KEY AUTO_INCREMENT,
	title VARCHAR(200) NOT NULL,
	content VARCHAR(1000),
	author VARCHAR(20),
	resdate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	cnt INT DEFAULT 0);
	
-- 테이블 구조 확인
DESC board;

-- 게시판 테이블에 더미 데이터 넣기
INSERT INTO board(title, content, author)
VALUES ('더미글1', '여기는 더미글1입니다', 'admin');

INSERT INTO board(title, content, author)
VALUES ('더미글2', '여기는 더미글2입니다', 'admin');

INSERT INTO board(title, content, author)
VALUES ('더미글3', '여기는 더미글3입니다', 'admin');

INSERT INTO board(title, content, author)
VALUES ('더미글4', '여기는 더미글4입니다', 'admin');

INSERT INTO board(title, content, author)
VALUES ('더미글5', '여기는 더미글5입니다', 'admin');

INSERT INTO board(title, content, author)
VALUES ('더미글6', '여기는 더미글6입니다', 'admin');

INSERT INTO board(title, content, author)
VALUES ('더미글7', '여기는 더미글7입니다', 'admin');

INSERT INTO board(title, content, author)
VALUES ('더미글8', '여기는 더미글8입니다', 'kim');

-- 게시판 테이블 검색
SELECT * FROM board;

-- 회원 테이블 검색
SELECT * FROM member;

-- 아이디가 'shin'인 회원의 레코드 삭제
DELETE FROM member WHERE id='shin';

-- 글번호가 5인 레코드의 작성자 아이디를 'lee'로 변경
UPDATE board SET author='lee' WHERE bno=5;

-- 커밋! (데이터의 변경이 있었다면 커밋해주기)
COMMIT;

-- 일치 검색
SELECT * FROM member
WHERE NAME IN ('김이름','이이름','최이름');
SELECT * FROM member
WHERE NAME = '김이름' OR NAME = '이이름' OR NAME = '최이름';

-- 유사 검색(김으로 시작하는 데이터 검색)
SELECT * FROM member
WHERE NAME LIKE '김%';
SELECT * FROM member
WHERE NAME LIKE '%세%';

-- 중복성 제거
SELECT DISTINCT author FROM board;

-- 구간 검색
SELECT * 
FROM board 
WHERE bno BETWEEN 3 AND 6;
SELECT * FROM board
LIMIT 2, 4;

-- 이중쿼리(7번 글에 대한 작성자의 이름)
SELECT id, NAME 
FROM member
WHERE id = (
	SELECT author 
	FROM board
	WHERE bno = 7);

SELECT id, NAME 
FROM member 
WHERE id NOT IN (SELECT author FROM board);


-- 연관쿼리와 join
-- 연관쿼리 (alias 활용)
SELECT * FROM member a, board b;		-- 결과 갯수: 7 * 8 = 56건, 13개 항목

SELECT a.id AS pid, a.name AS pname, a.email AS pemail, b.bno AS pno, b.title AS title
FROM member a, board b;					-- 56건, 5개 항목

-- 게시판에 글을 올린 회원 정보와 글 정보를 모두 표시
SELECT a.id AS pid, a.name AS pname, a.email AS pemail, b.bno AS pno, b.title AS title
FROM member a, board b
WHERE a.id = b.author;

SELECT a.id, a.name, a.email, b.bno, b.title
FROM member a INNER JOIN board b ON a.id=b.author;

SELECT bno, title, author, resdate
FROM member a INNER JOIN board b ON a.id=b.author;

-- 테이블 복제
CREATE TABLE board2 AS SELECT * FROM board;
SELECT * FROM board2;
DESC board2;					-- key에 대한 복제는 이루어지지 않음 (제약조건의 복제X)
ALTER TABLE board2 ADD CONSTRAINT PRIMARY KEY (bno);		-- 제약조건 설정해주기

ALTER TABLE board2 modify bno INT AUTO_INCREMENT;

-- 뷰 생성
CREATE VIEW writer_info AS (SELECT a.id, a.name, a.email, b.bno, b.title
FROM member a INNER JOIN board b ON a.id=b.author);

-- 생성된 뷰의 결과 출력
SELECT * FROM writer_info;


-- 테이블 만들기 및 예시 데이터 추가
-- 테이블명 : 상품(goods)
-- 상품코드 : gcode - 정수/일련번호(기본키) - 필수입력
-- 상품명 : gname - 문자열(150) - 필수입력
-- 종류 : gcate - 문자열(40) - 필수입력
-- 단가 : gprice - 정수 - 필수입력
-- 수량 : gqty - 정수 - 기본값:0
-- 등록일 : regdate - 날짜 - 기본값: 오늘날짜 및 시간
CREATE TABLE goods (
	gcode INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
	gname VARCHAR(150) NOT NULL,
	gcate VARCHAR(40) NOT NULL,
	gprice INT NOT NULL,
	gqty INT DEFAULT 0,
	regdate TIMESTAMP DEFAULT CURRENT_TIMESTAMP());
	
SELECT * FROM goods;

INSERT INTO goods(gname, gcate, gprice, gqty)
VALUES ('컴퓨터활용능력 1급 필기', '001', 15000, 50);

UPDATE goods SET gqty = 50
WHERE gcode=11;

-- 테이블명 : 판매(sales)
-- 판매코드 : pcode - 정수/일련번호(기본키) - 필수입력
-- 상품코드 : gcode - 정수 - 필수입력
-- 구매자 : id - 문자열(16) - 필수입력
-- 수량 : qty - 정수 - 기본값:1 - 필수입력
-- 구매단가 : sprice - 정수 - 필수입력
-- 결제수단 : stype - 정수 - 필수입력
-- 할인금액 : distotal - 정수
-- 결제금액 : paytotal - 정수
-- 총금액 : stotal - 정수
-- 판매일 : saledate - 날짜 - 기본값 : 오늘날짜 및 시간
CREATE TABLE sales (
	pcode INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
	gcode INT NOT NULL,
	id VARCHAR(16) NOT NULL,
	qty INT NOT NULL DEFAULT 1,
	sprice INT NOT NULL,
	stype INT NOT NULL,
	distotal INT,
	paytotal INT,
	stotal INT,
	saledate TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

DESC sales;

-- 더미데이터는 본인이 임의로 각자 12건 이상 추가하되
-- 상품 데이터는 교육, 서적, 동영상 강의 등의 카테고리를 본인이 정하여 추가할 것

-- sort(소트) = 분류
UPDATE board SET cnt = cnt+1 WHERE bno = 6;

SELECT * FROM board 
ORDER BY author, cnt DESC;

SELECT author, COUNT(author)
FROM board
GROUP BY author;