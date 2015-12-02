-- Open buffer between pl/sql engine back
-- to sqlplus environment
set serveroutput on size unlimited

------------------------------------------------------------------------------
------------------------------------------------------------------------------
-- Part 1 --------------------------------------------------------------------
DECLARE -- Declare a 1 character array and a two character array
lv_a VARCHAR2(1);
lv_b VARCHAR2(2) := 'AB';
BEGIN -- try to put the two character array into the 1 character array
	lv_a := lv_b;
	-- this can't be done so it will raise an exception
EXCEPTION
	WHEN value_error THEN -- this collects all exceptions and outputs:
	dbms_output.put_line(
		'ERROR: You can''t put ['||lv_b||'] in a one character string.');
END;
/
------------------------------------------------------------------------------
------------------------------------------------------------------------------
-- Part 2 --------------------------------------------------------------------
-- Declare block, declare variables
DECLARE
	custom_error_message EXCEPTION; -- declare an exception called e
	PRAGMA EXCEPTION_INIT(custom_error_message,-20001); -- declares the compiler directive with 
									 -- a user-defined error code 
BEGIN
	-- throws the exception with the same user-defined error code
	RAISE_APPLICATION_ERROR(-20001,'You have done something wrong. You broke it.');
EXCEPTION
	-- catches the dynamic error -20001 and outputs the user-defined error code
	-- and message
	WHEN custom_error_message THEN
	dbms_output.put_line(SQLERRM);
END;
/
-------------------------------------------------------------------------
-------------------------------------------------------------------------
-- Part 3 ---------------------------------------------------------------
/* This is the Procedure that Brother McLaughlin creates to handle erros. */
CREATE OR REPLACE PROCEDURE handle_errors
( pv_object_name         IN  VARCHAR2
, pv_module_name         IN  VARCHAR2 := NULL
, pv_table_name          IN  VARCHAR2 := NULL
, pv_error_code          IN  NUMBER   := NULL
, pv_error_message       IN  VARCHAR2 := NULL
, pv_user_error_message  IN  VARCHAR2 := NULL ) IS

  /* Declare a local exception. */
  lv_error  EXCEPTION;

  -- Define a collection type and initialize it.
  TYPE error_stack IS TABLE OF VARCHAR2(100);
  lv_errors        ERROR_STACK := error_stack();

  /* Define a local function to get object type. */
  FUNCTION get_object_type
  ( pv_object_name  IN  VARCHAR2 ) RETURN VARCHAR2 IS
    /* Local return variable. */
    lv_return_type  VARCHAR2(12) := 'Unidentified';
  BEGIN
    FOR i IN ( SELECT object_type FROM user_objects
               WHERE  object_name = pv_object_name ) LOOP
      lv_return_type := i.object_type;
    END LOOP;
    RETURN lv_return_type;
  END get_object_type;
BEGIN
  -- Allot space and assign a value to collection.
  lv_errors.EXTEND;
  lv_errors(lv_errors.COUNT) :=
    get_object_type(pv_object_name)||' ['||pv_object_name||']';

  -- Substitute actual parameters for default values.
  IF pv_module_name IS NOT NULL THEN
    lv_errors.EXTEND;
    lv_errors(lv_errors.COUNT) := 'Module Name: ['||pv_module_name||']';
  END IF;
  IF pv_table_name IS NOT NULL THEN
    lv_errors.EXTEND;
    lv_errors(lv_errors.COUNT) := 'Table Name: ['||pv_table_name||']';
  END IF;
  IF pv_error_code IS NOT NULL THEN
    lv_errors.EXTEND;
    lv_errors(lv_errors.COUNT) := 'SQLCODE Value: ['||pv_error_code||']';
  END IF;
  IF pv_error_message IS NOT NULL THEN
    lv_errors.EXTEND;
    lv_errors(lv_errors.COUNT) := 'SQLERRM Value: ['||pv_error_message||']';
  END IF;
  IF pv_user_error_message IS NOT NULL THEN
    lv_errors.EXTEND;
    lv_errors(lv_errors.COUNT) := pv_user_error_message;
  END IF;

  lv_errors.EXTEND;
  lv_errors(lv_errors.COUNT) := '----------------------------------------';
  RAISE lv_error;
EXCEPTION
  WHEN lv_error THEN
    FOR i IN 1..lv_errors.COUNT LOOP
      dbms_output.put_line(lv_errors(i));
    END LOOP;
    RETURN;
END;
/

/* Creates a procedure called pear, it creates a one character string and a 
   two character string. It then tries to put the two character string into the 
   one character string, this of course passes an exception.*/
CREATE OR REPLACE PROCEDURE pear IS
	/* Declare two variables. */
	lv_one_character VARCHAR2(1);
	lv_two_character VARCHAR2(2) := 'AB';
BEGIN
	lv_one_character := lv_two_character;
	/* The excpetion block calls the handle_errors procedure and passes information
	   about the exception that was passed, it then displays that information
	   on the console for the user to see*/
EXCEPTION
	WHEN others THEN
	handle_errors(
		  pv_object_name  => 'Pear'        
		, pv_module_name => 'Module 1'
		, pv_table_name => 'Fruit'  
		, pv_error_code => SQLCODE   
		, pv_error_message => SQLERRM
		, pv_user_error_message => 'ERROR: You broke Pear');
END pear;
/

/* This procedure is created called orange, it calls the pear procedure.*/
CREATE OR REPLACE PROCEDURE orange IS
BEGIN
	pear();
	/* The excpetion block calls the handle_errors procedure and passes information
	   about the exception that was passed, it then displays that information
	   on the console for the user to see*/
EXCEPTION
	WHEN others THEN
	handle_errors(
		  pv_object_name  => 'Orange'        
		, pv_module_name => 'Module 1'
		, pv_table_name => 'Fruit'  
		, pv_error_code => SQLCODE   
		, pv_error_message => SQLERRM
		, pv_user_error_message => 'ERROR: You broke Orange');
END orange;
/

/* This procedure is created called apple, it calls the orange procedure.*/
CREATE OR REPLACE PROCEDURE apple IS
BEGIN
	orange();
	/* The excpetion block calls the handle_errors procedure and passes information
	   about the exception that was passed, it then displays that information
	   on the console for the user to see*/
EXCEPTION
	WHEN others THEN
	handle_errors(
		  pv_object_name  => 'Apple'        
		, pv_module_name => 'Module 1'
		, pv_table_name => 'Fruit'  
		, pv_error_code => SQLCODE   
		, pv_error_message => SQLERRM
		, pv_user_error_message => 'ERROR: You broke Apple');
END apple;
/

/* This anonomous block is called and it calls the apple procedure.*/
BEGIN
	apple();
EXCEPTION
	WHEN others THEN
	dbms_output.put_line('This is the last one, you broke it too.');

--	WHEN others THEN
--	/* loop through the error call stack in reverse */
--	FOR i IN REVERSE 1..utl_call_stack.backtrace_depth LOOP
--		/* Check for an anonymous block. */

--			IF utl_call_stack.backtrace_unit(i) IS NULL THEN
--			/* utl_call_stack doesn't show an error, manually override. */
--			dbms_output.put_line(
--				'ORA-06512: at Anonymous Block, line '||
--				utl_call_stack.backtrace_line(i));
--		ELSE
--		/* utl_call_stack doesn't show an error, manually override. */
--			dbms_output.put_line(
--				'ORA-06512: at '||utl_call_stack.backtrace_unit(i)||
--				', line '||utl_call_stack.backtrace_line(i));
--		END IF;

--	/* The backtrace and error depth are unrelated, and the depth of
--	calls can be and generally is higher than the depth of errors. */
--		IF i = utl_call_stack.error_depth THEN
--			dbms_output.put_line(
--				'ORA-'||LPAD(utl_call_stack.error_number(i),5,0)
--				||' '||utl_call_stack.error_msg(i));
--		END IF;
--	END LOOP;
END;
/
