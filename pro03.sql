USE shop;

SHOW TABLES;

SELECT * FROM buy;

-- customerid 별로 그룹화하여 customerid, 제품거래건수, 총수량, 평균 할인율을 출력하시오.
SELECT customerid, COUNT(customerid) AS '제품거래건수', SUM(quantity) AS '총수량', AVG(discount) AS '평균 할인율'
FROM buy
GROUP BY customerid;

-- buy 테이블에서 할인율이 가장 작은 거래 정보를 수량의 내림차순으로 출력하시오.
-- 단, 수량이 같은 경우주문일(orderdate)의 오름차순으로 하시오
SELECT * FROM buy
WHERE discount = (SELECT MIN(discount) FROM buy)
ORDER BY quantity DESC, orderdate ASC;

-- 배송일(shipdate)의 년도별로 총수량의 합계와 총수량의 평균, 총수량의 최대값을 집계하시오. (년도 추출 함수 year)
SELECT YEAR(shipdate) AS '년도', SUM(quantity) AS '총합계', AVG(quantity) AS '총평균', MAX(quantity) AS '최대배송량'
FROM buy
GROUP BY YEAR(shipdate);

-- 주문일(orderdate)의 년도와 월별로 주문수량(quantity)의 합계와 평균 할인율을 집계하시오. (date_format 함수 사용)
-- date_format(컬럼, 형식)
SELECT date_format(orderdate, '%Y-%m') AS '년월', SUM(quantity) AS '주문량합계', AVG(discount) AS '할인율평균'
FROM buy
GROUP BY DATE_FORMAT(orderdate, '%Y-%m')
HAVING SUM(quantity) != 0;

-- 제품번호(productid)가 FUR로 시작하는 가구 종류를 구매한 고객정보 중에서 고객명(customername), 국가(country), 도시(city)를 출력하되,
-- 고객id(customerid)의 내림차순으로 하고, 고객id가 같은 경우 주문수량(quantity)의 오름차순으로할 것
-- 이중쿼리, 연관쿼리, 내부조인 등 원하는 방식으로 해결할 것
SELECT a.customername, a.country, a.city
FROM customer a, buy b
WHERE a.customerid = b.customerid AND b.productid LIKE 'FUR%'
ORDER BY a.customerid DESC, quantity ASC;

SELECT a.customername, a.country, a.city
FROM customer a INNER JOIN buy b ON a.customerid = b.customerid
WHERE productid LIKE 'FUR%'
ORDER BY a.customerid DESC, quantity ASC;

-- 제품(product) 테이블로부터 가격(price)이 40 이상인 제품을 검색하여 제품2(product2) 테이블을 생성하시오.
CREATE TABLE product2 AS (
	SELECT * FROM product WHERE price >= 40);
	
SELECT * FROM product2;

-- 제품(product) 테이블로부터 가격(price)이 40 미만인 제품을 검색하여 제품3(product3) 테이블을 생성하시오.
CREATE TABLE product3 AS (
	SELECT * FROM product WHERE price < 40);
	
SELECT * FROM product3;

-- 제품3(product3) 테이블로부터 price가 0인 레코드를 삭제하시오.
DELETE FROM product3 WHERE price <= 0;

-- 제품명(productname)에 "가 있는 데이터의 "(큰따옴포)를 제거하시오.
UPDATE product3 SET productname = SUBSTRING(productname, 2, LENGTH(productname)-1)			-- mariaDB는 1부터 시작
WHERE productname LIKE '\"%';

-- 집합
-- UNION(합집합) : 중복을 제거하여 합집합
-- UNION ALL : 중복 포함하여 합집합
-- View로 만들어주어야 함
CREATE VIEW uni_tab1 AS (SELECT productid, price FROM product2 UNION SELECT productid, price FROM product3);

SELECT * FROM uni_tab1;

-- 교집합
CREATE VIEW int_tab1 AS (SELECT productid, price FROM product2 INTERSECT SELECT productid, price FROM product3);

SELECT * FROM int_tab1;

-- 차집합
CREATE VIEW exc_tab1 AS (SELECT productid, price FROM product EXCEPT SELECT productid, price FROM product2);

SELECT * FROM exc_tab1;


-- 집합 예제
-- 제품2(product2)와 제품3(product3)의 테이블 데이터를 합집합하여 전체상품(totpro)의 테이블을 생성하시오.
CREATE TABLE totpro AS (SELECT * FROM product2 UNION SELECT * FROM product3);

SELECT * FROM totpro;

-- 제품(product)와 제품3(product3)의 테이블 데이터를 차집합하여 제거상품(revpro)의 테이블을 생성하시오.
CREATE TABLE revpro AS (SELECT * FROM product EXCEPT SELECT * FROM product3);

SELECT * FROM revpro;

-- 제품(product)와 제품2(product2)의 테이블 데이터를 교집합하여 인기상품(hotpro)의 테이블을 생성하시오.
CREATE TABLE hotpro AS (SELECT * FROM product INTERSECT SELECT * FROM product2);

SELECT * FROM hotpro;

SELECT * FROM buy;
-- 특정 고객의 주문정보를 검색
SELECT * FROM buy WHERE customerid = 'BH-11710';
-- 웹에서 특정 고객의 주문정보 검색
SELECT * FROM buy WHERE customerid = ?;
pstmt.setString(1, customerid);

-- 특정 고객의 본인정보
SELECT * FROM customer WHERE customerid = 'BH-11710';
-- 웹에서 특정 고객의 본인정보
-- DAO (Data Access Object) => CustomDAO => Model
public customer myInfo(String custormerid) {
	STRING SQL = "SELECT * FROM customer WHERE customerid = ?";
	pstmt.setString(1, customerid);
	rs = pstmt.excute(SQL);
	Customer cus = new Customer();
	if(rs.next()) {
		cus.setCustomerid(rs.getString("customerid"));
		cus.setCustomerName(rs.getString("customername"));
		...
	}
	return cus;
}

-- Controller(Ctrl)
"http://localhost:8081/mypage?customerid=BH-11710"
String cid = request.getParameter("customerid");

CustomDAO dao = NEW CustomDAO();
Customer cus = dao.myInfo(cid);
...
patcher.forward(cus);

-- View(.jsp) => 사용자에게 보여지는 화면
Customer cus = (Customer)request.getParameter("cus");
<p> <%= cus.getCustomerid() %> </p>

