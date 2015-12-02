/*
1. Create a base object (superclass), a subtype of the object (subclass), and an anonymous block program to test the 
   subtypes in a loop:
2. Create a BASE_T object with two attributes (or columns), the obj_id and obj_name fields and a to_string method.
3. Create a HOBBIT_T object as a subtype of the BASE_T object that adds an hobbit_name attribute.
4. Extends the to_string method of the parent class to use general invocation for the obj_id and obj_name, and then 
   add the hobbit_name attribute of the HOBBIT_T object subtype.
5. As a test case, create a collection of 5 HOBBIT_T objects and then loop through the list of HOBBIT_T objects 
   while printing their overriding to_string method's results.
6. Comment your code to explain it to a novice.
*/

-- Allow an unlimited space for the output. This opens the buffer so that user can see data returned to them.
SET SERVEROUTPUT ON SIZE UNLIMITED
--Create a base object (superclass), a subtype of the object (subclass), and an anonymous block program to test the subtypes in a loop:
---------Create a BASE_T object with two attributes (or columns), the obj_id and obj_name fields and a to_string method.

--Comment your code to explain it to a novice.
-- drop type hobbit_t, base_t and sequence obj_s1 so the script is re-runnable
drop type hobbit_t;
drop type base_t;
drop sequence obj_s1;
-- create the object type with parameters and call it base_t
CREATE OR REPLACE TYPE base_t IS OBJECT
( obj_id   VARCHAR(30)
, obj_name VARCHAR(30)
, CONSTRUCTOR FUNCTION base_t RETURN SELF AS RESULT
, MEMBER FUNCTION to_string RETURN VARCHAR2)

INSTANTIABLE NOT FINAL;
/
-- create a sequence and call it obj_s1
create sequence obj_s1;

-- create the default boddy of base_t
CREATE OR REPLACE TYPE BODY base_t IS

-- A default constructor w/o formal parameters.
CONSTRUCTOR FUNCTION base_t RETURN SELF AS RESULT IS
	BEGIN
		self.obj_name := 'BASE_T';
		self.obj_id := obj_s1.NEXTVAL;
	RETURN;
END;

-- create a conversion method that converts the object
-- to a string data type
MEMBER FUNCTION to_string RETURN VARCHAR2 IS
	BEGIN
		RETURN '['||self.obj_name||']';
	END to_string;
END;
/


---------Create a HOBBIT_T object as a subtype of the BASE_T object that adds an hobbit_name attribute.
-- create a subtype called hobbit_t that is a sub to base_t
CREATE OR REPLACE TYPE hobbit_t UNDER base_t
	( name VARCHAR2(20)
	, CONSTRUCTOR FUNCTION hobbit_t
		( name   VARCHAR2)
		RETURN SELF AS RESULT
	, OVERRIDING MEMBER FUNCTION to_string RETURN VARCHAR2)

 INSTANTIABLE NOT FINAL;
/

 -- this creates the body of the newly created subtype hobbit_t
CREATE OR REPLACE TYPE BODY hobbit_t IS
-- A default constructor with two formal parameters. 
CONSTRUCTOR FUNCTION hobbit_t
	( name   VARCHAR2 )
	RETURN SELF AS RESULT IS
		BEGIN
			self.obj_id := obj_s1.NEXTVAL;
			self.obj_name := 'HOBBIT_T';
			self.name := name;
		RETURN;
END;


---------Extends the to_string method of the parent class to use general invocation for the obj_id and 
----------obj_name, and then add the hobbit_name attribute of the HOBBIT_T object subtype.

-- A to_string conversion method.
OVERRIDING MEMBER FUNCTION to_string RETURN VARCHAR2 IS
	BEGIN

	-- Uses general invocation on parent to_string function. 
		RETURN (self as base_t).to_string || '['||self.name||']';
	END to_string;
END;
/



---------As a test case, create a collection of 5 HOBBIT_T objects and then loop through the list of HOBBIT_T objects while printing their overriding to_string method's results.
DECLARE
	-- declare a table of hobbit_t
	type HOBBIT_TABLE is table of hobbit_t;
	-- create an instance HOBBIT_TABLE and call it my_table
	my_table HOBBIT_TABLE := HOBBIT_TABLE();
BEGIN
	-- extend the table and add these hobbits
	my_table.EXTEND;
	my_table(my_table.count) := hobbit_t('Bilbo');
	my_table.EXTEND;
	my_table(my_table.count) := hobbit_t('Sam');
	my_table.EXTEND;
	my_table(my_table.count) := hobbit_t('Bolo');
	my_table.EXTEND;
	my_table(my_table.count) := hobbit_t('Polo');
	my_table.EXTEND;
	my_table(my_table.count) := hobbit_t('Olo');

	-- display the  newly added hobbits using a loop
	for i IN 1..my_table.count loop
		dbms_output.put_line(my_table(i).to_string);
	END LOOP;
END;
/