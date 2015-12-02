/*
1. Create a package specification that defines an overloaded function and overloaded procedure.
2. Create a package body that implements an overloaded function and overloaded procedure.
3. Create an anonymous block that tests the overloaded function.
4. Create an anonymous block that tests the overloaded procedure.
5. Create a test case that calls the two anonymous blocks that test the overloaded function 
	and procedure (embed the two previous anonymous blocks into a single anonymous block, which 
	becomes a single test case for two tests).
6. Comment your code to explain it to a novice.
*/

-------------------------------------------------------------------------
-------------------------------------------------------------------------
-- Part 1 ---------------------------------------------------------------
-- set the unlimited buffer between the PL/SQL block and the SQLplus block
SET SERVEROUTPUT ON SIZE UNLIMITED
-- this creates a package called test_package
-- it has two functions and two procedures
-- the functions and procedures also assign the variables inside them
CREATE OR REPLACE PACKAGE test_package IS
	FUNCTION get_person(name VARCHAR2) RETURN VARCHAR2;
	FUNCTION get_person(name VARCHAR2, age NUMBER) RETURN VARCHAR2;
	PROCEDURE naming(first_name VARCHAR2);
	PROCEDURE naming(first_name VARCHAR2, last_name VARCHAR2);
END test_package;
/

-------------------------------------------------------------------------
-------------------------------------------------------------------------
-- Part 2 ---------------------------------------------------------------
-- this creates the inside of the package test_package
CREATE OR REPLACE PACKAGE BODY test_package IS
	-- this function accepts a name and prints it out
	FUNCTION get_person(name VARCHAR2) RETURN VARCHAR2 IS
		BEGIN
			RETURN name;
		END;
	-- this function accepts a name and an age and prints it out
	FUNCTION get_person(name VARCHAR2, age NUMBER) RETURN VARCHAR2 IS
		BEGIN
			RETURN 'Name: ' || name || ' and Age: ' || age;
		END;
	-- this procedure accpets a first name and prints it out
	PROCEDURE naming(first_name VARCHAR2) IS
		BEGIN
			dbms_output.put_line('Hello, ' || first_name || '!');
		END;
	-- this procedure accepts a first and last name and prints them out
	PROCEDURE naming(first_name VARCHAR2, last_name VARCHAR2) IS
		BEGIN
			dbms_output.put_line('Hello, ' || first_name || ' ' || last_name || '!');
		END;
END test_package;
/


-------------------------------------------------------------------------
-------------------------------------------------------------------------
-- Part 3 ---------------------------------------------------------------
-- this runs two queries that call the functions inside the test_package
-- package and displays the result sets with headers
SELECT test_package.get_person('Mike') AS FIRST_NAME
FROM DUAL;
SELECT test_package.get_person('Mike', 25) AS NAME_AND_AGE
FROM DUAL;


-------------------------------------------------------------------------
-------------------------------------------------------------------------
-- Part 4 ---------------------------------------------------------------
-- this is an anonomous block that calls both procedures inside the 
-- test_package package and displays the results of the names supplied
-- to the procedures
BEGIN
	test_package.naming('Mike');
	test_package.naming('Mike', 'Stuart');
END;
/

-------------------------------------------------------------------------
-------------------------------------------------------------------------
-- Part 5 ---------------------------------------------------------------
-- this is an anonomous block that tests all functions and procedures in
-- the test_package package, it supplies each function or procedure with 
-- valid input and then it outputs the results
DECLARE
	lv_result VARCHAR2(60);
BEGIN
	lv_result := test_package.get_person('Mike');
	dbms_output.put_line('Name is: ' || lv_result || '.');

	lv_result := test_package.get_person('Mike', 25);
	dbms_output.put_line('Name and age is: ' || lv_result || '.');

	test_package.naming('Mike');
	test_package.naming('Mike', 'Stuart');
END;
/