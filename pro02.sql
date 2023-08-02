DESC product;

-- 대단위 데이터 csv 파일을 해당 테이블에 import하기
LOAD DATA LOCAL INFILE 'D:/shin/db/230731/buy.csv'
REPLACE
INTO TABLE `buy`
COLUMNS TERMINATED BY ','
ENCLOSED BY ""
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

-- 해당 데이터를 csv로 export하기
-- 1. 해당 테이블 먼저 검색(select)
SELECT * FROM product;
-- 검색 결과에서 전체 선택한 후 마우스 오른쪽[격자 행 내보내기]

-- 테이블 삭제
DROP TABLE customer;
DROP TABLE buy;
DROP TABLE product;

COMMIT;

SHOW TABLES;

Customer cus = new customer();
cus.setCustomerid(request.getParameter("customerid"));
cus.setCustomername(request.getParameter("customername"));
cus.setCustomertype(request.getParameter("customertype"));
cus.getCountry(request.getParameter("country"));
cus.getCity(request.getParameter("city"));
cus.getState(request.getParameter("state"));
cus.getPostcode(Integer.paseInt(request.getParameter("postcode")));
cus.setRegiontype(request.getParameter("regiontype"));
cusInsert(cus);

-- 고객 등록
INSERT INTO customer VALUES('AK-10880', 'Alien Kim', 'Consumer', 'South Korea', 'Seoul', 'Seoul', 18517, 'West');
-- 웹에서 고객 등록
public void cusInsert(customer cus) {
	INSERT INTO customer VALUES(?, ?, ?, ?, ?, ?, ?, ?);
	pstmt.setString(1, cus.getCustomerid());
	pstmt.setString(2, cus.getCustomername());
	pstmt.setString(3, cus.getCustomertype());
	pstmt.setString(4, cus.getCountry());
	pstmt.setString(5, cus.getCity());
	pstmt.setString(6, cus.getState());
	pstmt.setInt(7, cus.getPostcode());
	pstmt.setString(8, cus.getRegiontype());
}

-- 정보 변경
UPDATE customer SET country='America', city='Los Angels', state='Los Angels' WHERE customerid='AK-10880';
-- 웹에서 고객 데이터 변경
UPDATE customer SET country=?, city=?, state=? WHERE customerid=?;
pstmt.setString(1, cus.getCountry());
pstmt.setString(2, cus.getCity());
pstmt.setString(3, cus.getState());
pstmt.setString(4, cus.getCustomerid());

-- 데이터 삭제
DELETE FROM customer WHERE customerid='AK-10880';
-- 웹에서 고객 삭제
DELETE FROM customer WHERE customerid=?;
pstmt.setString(1, customerid);


COMMIT;

SELECT * FROM customer WHERE customername LIKE '%Kim%';

SELECT * FROM customer WHERE customername LIKE '%Kim%' AND city = 'Seoul';

SELECT COUNT(*) FROM customer WHERE customername LIKE '%Kim%';