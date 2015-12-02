/*
Call the create_store.sql script found in Data/cit325/oracle/lib/Workbook 
in order to populate your database. Do not attempt to recreate the tables.

1. Create a procedure that writes an all or nothing insert into the contact, 
address, and telephone tables, which means you use transaction control 
language (TCL) where it commits after a successful insert into all tables, 
but rollsback all inserts with a failure to insert into any one of the tables.

2. Create an autonomous procedure that writes to the rental and rental_item 
tables. It should use transaction control language (TCL) to commit inserts to 
both tables or not insert into either table.

3. Create an autonomous function that calls the procedure that writes to the 
contact, address, and telephone tables.

4. Create a query test case that calls the autonomous function.

5. Create a function that returns a list of full names in the last_name, 
first_name middle name format.

6. Create a query test case that calls the function that returns formatted 
full_name values.
*/

-- Open buffer between pl/sql engine back
-- to sqlplus environment

set serveroutput on size unlimited
-------------------------------------------------------------------------
-------------------------------------------------------------------------
-- Part 2 ---------------------------------------------------------------
CREATE OR REPLACE PROCEDURE new_account
( pv_contact_type     VARCHAR2
, pv_last_name        VARCHAR2
, pv_first_name       VARCHAR2
, pv_middle_name      VARCHAR2
, pv_address          VARCHAR2
, pv_city             VARCHAR2
, pv_state            VARCHAR2
, pv_zip              VARCHAR2
, pv_telephone_type   VARCHAR2
, pv_country_code     VARCHAR2
, pv_area_code        VARCHAR2
, pv_telephone_number VARCHAR2 ) IS
BEGIN
SAVEPOINT all_or_nothing1;

INSERT INTO contact
  ( contact_id
  , member_id
  , contact_type
  , last_name
  , first_name
  , middle_name
  , created_by
  , creation_date
  , last_updated_by
  , last_update_date)
  VALUES
  ( contact_s1.NEXTVAL
  , 1001
  ,(SELECT   common_lookup_id
    FROM     common_lookup
    WHERE    common_lookup_table = 'CONTACT'
    AND      common_lookup_column = 'CONTACT_TYPE'
    AND      common_lookup_type = 'CUSTOMER')
  , pv_last_name
  , pv_first_name
  , pv_middle_name
  , 3
  , SYSDATE()
  , 3
  , SYSDATE());
 
  INSERT INTO address
  ( address_id
  , contact_id
  , ADDRESS_TYPE
  , city
  , state_province
  , postal_code
  , created_by
  , creation_date
  , last_updated_by
  , last_update_date)
  VALUES
  ( address_s1.NEXTVAL
  , contact_s1.CURRVAL
  ,(SELECT   common_lookup_id
    FROM     common_lookup
    WHERE    common_lookup_table = 'ADDRESS'
    AND      common_lookup_column = 'ADDRESS_TYPE'
    AND      common_lookup_type   = 'HOME')
  , pv_city
  , pv_state
  , pv_zip
  , 3
  , SYSDATE()
  , 3
  , SYSDATE());  

  INSERT INTO telephone
  ( telephone_id
  , contact_id
  , address_id
  , telephone_type
  , country_code
  , area_code
  , telephone_number
  , created_by
  , creation_date
  , last_updated_by
  , last_update_date)
  VALUES
  ( telephone_s1.nextval
  , address_s1.currval
  , contact_s1.currval
  ,(SELECT   common_lookup_id
    FROM     common_lookup
    WHERE    common_lookup_table = 'TELEPHONE'
    AND      common_lookup_column = 'TELEPHONE_TYPE'
    AND      common_lookup_type = 'HOME')
  , pv_country_code
  , pv_area_code
  , pv_telephone_number
  , 2
  , SYSDATE()
  , 2
  , SYSDATE());

COMMIT;
EXCEPTION
	WHEN others THEN
		ROLLBACK TO all_or_nothing1;
		dbms_output.put_line('Inserts not valid, rolledback to savepoint.');
		dbms_output.put_line('Debug []' || chr(10) || sqlerrm);
END;
/

-------------------------------------------------------------------------
-------------------------------------------------------------------------
-- Part 3 ---------------------------------------------------------------

CREATE OR REPLACE PROCEDURE rental_insert
( pv_check_out_date      DATE
, pv_return_date         DATE
, pv_rental_item_price   NUMBER
, pv_rental_item_type    NUMBER) IS
  -- Local variables, to leverage subquery assignments in 
  -- INSERT statements.
  PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
  SAVEPOINT all_or_nothing2;

  INSERT INTO rental
	  ( rental_id       
	  , customer_id     
	  , check_out_date  
	  , return_date     
	  , created_by      
	  , creation_date   
	  , last_updated_by 
	  , last_update_date)
  VALUES
	  ( rental_s1.NEXTVAL       
	  , contact_s1.CURRVAL  
	  , pv_check_out_date  
	  , pv_return_date     
	  , 3     
	  , SYSDATE()  
	  , 3
	  , SYSDATE());

  INSERT INTO rental_item
	  ( rental_item_id   
	  , rental_id        
	  , item_id          
	  , rental_item_price
	  , rental_item_type 
	  , created_by       
	  , creation_date    
	  , last_updated_by  
	  , last_update_date)
  VALUES
	  ( rental_item_s1.nextval  
	  , rental_s1.currval       
	  , (SELECT common_lookup_id
	  	 FROM common_lookup
	  	 WHERE common_lookup_table = 'RENTAL_ITEM'
	  	 AND common_lookup_column  = 'RENTAL_ITEM_TYPE'
	  	 AND common_lookup_type    = 'DVD_FULL_SCREEN')         
	  , pv_rental_item_price
	  , pv_rental_item_type 
	  , 3       
	  , SYSDATE()    
	  , 3  
	  , SYSDATE());

  COMMIT;
EXCEPTION 
  WHEN OTHERS THEN
    ROLLBACK TO all_or_nothing2;
    dbms_output.put_line('There was an error inserting the values');
    RETURN;
END;
/
-------------------------------------------------------------------------
-------------------------------------------------------------------------
-- Part 4 ---------------------------------------------------------------
CREATE OR REPLACE FUNCTION add_person
	( pv_contact_type     VARCHAR2
	, pv_last_name        VARCHAR2
	, pv_first_name       VARCHAR2
	, pv_middle_name      VARCHAR2
	, pv_address          VARCHAR2
	, pv_city             VARCHAR2
	, pv_state            VARCHAR2
	, pv_zip              VARCHAR2
	, pv_telephone_type   VARCHAR2
	, pv_country_code     VARCHAR2
	, pv_area_code        VARCHAR2
	, pv_telephone_number VARCHAR2) RETURN VARCHAR2 IS
	PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
	new_account(
	  pv_contact_type
	, pv_last_name
	, pv_first_name
	, pv_middle_name
	, pv_address
	, pv_city
	, pv_state
	, pv_zip
	, pv_telephone_type
	, pv_country_code
	, pv_area_code
	, pv_telephone_number);
	RETURN 'Success!!';
EXCEPTION
	When others THEN 
	RETURN 'Failed.';
END;
/
-------------------------------------------------------------------------
-------------------------------------------------------------------------
-- Part 5 ---------------------------------------------------------------



SELECT add_person
	( 'CUSTOMER'
	, 'Bird'
	, 'Robert'
	, 'Peter'
	, '546 Walnut Ave'
	, 'Kaysville'
	, 'Utah'
	, '84039'
	, '1010'
	, 'USA'
	, '985'
	, '888-9685') AS results FROM DUAL;

-------------------------------------------------------------------------
-------------------------------------------------------------------------
-- Part 6 ---------------------------------------------------------------
CREATE OR REPLACE FUNCTION merge
  ( last_name    VARCHAR2
  , first_name   VARCHAR2
  , middle_name  VARCHAR2)
 RETURN VARCHAR2 PARALLEL_ENABLE IS
  BEGIN
   RETURN last_name ||', '||first_name||', '||middle_name;
  END;
/

-------------------------------------------------------------------------
-------------------------------------------------------------------------
-- Part 7 ---------------------------------------------------------------
SELECT merge(last_name, first_name, middle_name) AS Full_name
  	FROM contact
  	ORDER BY last_name, first_name, middle_name;