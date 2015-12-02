/*
1. [5 points] Create a package specification that defines a record type and a table collection of the record type. 
	Make sure the record type that matches one of your already defined tables, like MEMBER, CONTACT, or RENTAL, et cetera.

2. [5 points] Create a pipelined table function that takes a table name as its formal parameter and returns the contents 
	of the table as a collection of records, where the collection data type is defined by your package specification.

3. [2 points] Write an anonymous block program to test your newly created pipelined table function.

4. [1 point] Document all preceding code with comments that novice can understand.

5. [2 points] Create a copy of your base table as MEMBER_COPY, CONTACT_COPY, or RENTAL_COPY, et cetera. (HINT: You can 
	use the CREATE TABLE AS subquery; syntax to migrate a table definition and contents to a new table.)

6. [5 points] Create a procedure that takes a table name and COPY suffix as its formal parameters. Inside the procedure, 
	you should use a dynamic cursor to discover if the table name, an underscore, and the suffix identifies a valid table in 
	the USER_TABLES view of the data catalog. If the table is valid, you should create a new table with an NDS statement that 
	uses a suffix of BACKUP instead of COPY. After creating the new table, use an NDS statement to drop the old table (HINT: 
	The one with the COPY suffix.)

7. [5 points] Write queries to count the number of rows and display side-by-side the values in the base and copy tables. 
	(HINT: Modify the example from Appendix D on the DBMS_COMPARISON package.)
*/


-- #1 -------------------------------------------------------------------------------------------------------------------------
-- this creates a package that includes a table called member_table
-- this is a table of records that are called member_object's
CREATE OR REPLACE PACKAGE package_member IS
	TYPE member_object IS RECORD
	( member_id          NUMBER
	, member_type        NUMBER
	, account_number     VARCHAR2(10)
	, credit_card_number VARCHAR2(19)
	, credit_card_type   NUMBER
	, created_by         NUMBER
	, creation_date      DATE
	, last_updated_by    NUMBER
	, last_update_date   DATE);

TYPE member_table IS TABLE of member_object;
END package_member;	
/

-- #2 -------------------------------------------------------------------------------------------------------------------------
-- this creates a function that pipelines a table name and it's contents into a 
-- record structure
CREATE OR REPLACE FUNCTION pipeline_member (table_name VARCHAR2)
  RETURN package_member.member_table
    PIPELINED AS
          -- declare collection control var and collection var 
        name_cursor   SYS_REFCURSOR;
        name_row      package_member.member_object;
        statement     VARCHAR2(200);

BEGIN
-- this selects everything from the table and then using a loop stores
-- them in records
  statement := 'SELECT * FROM '|| table_name; 

  OPEN name_cursor FOR statement;
     LOOP
  FETCH name_cursor INTO name_row;
  EXIT WHEN name_cursor%NOTFOUND;
      PIPE ROW(name_row);
  END LOOP;
    CLOSE name_cursor;
    RETURN;
 EXCEPTION 
    WHEN OTHERS THEN dbms_output.put_line(statement);
END;
/

-- #3 -------------------------------------------------------------------------------------------------------------------------
-- this is a test to see if our pipeline function works
SELECT * FROM TABLE (pipeline_member('member'));

-- #4 -------------------------------------------------------------------------------------------------------------------------

-- Comment all code

-- #5 -------------------------------------------------------------------------------------------------------------------------

DROP TABLE member_copy;
-- this creates a copy of the member table so we can run it through other functions
CREATE TABLE member_copy AS SELECT * FROM member;

-- this creates a procedure that takes a table name as a parameter
-- it concatonates the table name with other code to create a table or drop a table
CREATE OR REPLACE PROCEDURE create_copy(table_name VARCHAR2) IS
     statement VARCHAR2(1000);
     stmt_validate VARCHAR2(1000);
  BEGIN 
     stmt_validate := 'DROP TABLE '||table_name||'_copy';
    EXECUTE IMMEDIATE stmt_validate;
     statement := 'CREATE TABLE '||table_name||'_copy'||' AS SELECT * FROM ' ||table_name;
    EXECUTE IMMEDIATE statement;
       
  EXCEPTION
    WHEN OTHERS THEN
       dbms_output.put_line('Somethings messed up');
  END;
/

-- this is a test for our create_copy procedure
BEGIN
	create_copy('member');
END;
/

-- #6 -------------------------------------------------------------------------------------------------------------------------
-- this creates a backup table, it accepts a table name and also a suffix that changes what the 
-- procedure does
-- if you input copy then it copies the table to make a backup
CREATE OR REPLACE PROCEDURE backup_table(table_name VARCHAR2, suffix VARCHAR2) IS
  full_table VARCHAR2(100) := table_name||'_'||suffix;
  backup_name VARCHAR2(100) := table_name||'_backup';
  check_stmt VARCHAR2(100) := 'SELECT table_name FROM user_tables WHERE table_name = :1';
  create_backup VARCHAR2(100) := 'CREATE TABLE '||backup_name||' AS SELECT * FROM '||full_table;
  drop_stmt VARCHAR2(100) := 'DROP TABLE '||full_table;
  results VARCHAR2(2000);
  backup_cursor SYS_REFCURSOR;
-- this creates a cursor that loops through the table and makes a copy of it row by row
BEGIN
  OPEN backup_cursor FOR check_stmt USING table_name||'_'||suffix;
  LOOP
	  FETCH backup_cursor INTO results;
	  EXIT WHEN backup_cursor%NOTFOUND;
	  
	  EXECUTE IMMEDIATE create_backup;
	  EXECUTE IMMEDIATE drop_stmt;
  END LOOP;
  CLOSE backup_cursor;
END;
/

-- this creates a copy and then a backup
-- this is our test case
BEGIN
	create_copy('member');
	backup_table('member', 'COPY');
END;
/




-- #7 -------------------------------------------------------------------------------------------------------------------------

-- this is our test, it selects both the original table and the copy
SELECT ( SELECT count(*) FROM member ) as "Original"
,( SELECT count(*) FROM member_copy ) AS "Backup"
FROM DUAL;
-- this is an inner join that joins both tables and then displays them
SELECT * FROM member m
INNER JOIN member_copy mc
ON m.member_id = mc.member_id;






















