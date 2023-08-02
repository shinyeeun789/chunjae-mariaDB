create table product(
	productid varchar(15) primary key,
	bigcategory varchar(50) not NULL,
	subcategory varchar(50),
	productname varchar(100) not null,
	price decimal(10,2));
	
create table buy(
	seq int(10) primary key auto_increment,
   orderid varchar(15) not null,
   orderdate timestamp,
   shipdate timestamp,
   customerid varchar(15),
   productid varchar(15),
   quantity int(10),
   discount decimal(10,2));
    
create table customer(
   customerid varchar(15) not null primary key,
   customername varchar(50) not null,
   customertype varchar(50) not null,
   country varchar(50) not null,
   city varchar(50),
   state varchar(50),
   postcode int,
   regiontype varchar(50));