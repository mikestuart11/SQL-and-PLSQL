/************************************************************************************************************
1.Create a DDL trigger:
	Create a DDL trigger on an event.
	Create a test program that creates the action to trigger the event.
	Comment the test program so a novice can understand it.

2. Create a DML trigger (5 points for success/5 points for autonomous write with failure):
	Create a DML trigger on INSERT or UPDATE action. It should work against a single table. 
	The trigger should write to a log of the transaction to a table when the logic allows the 
	DML statement to complete normally or when the logic disallows the DML statement to complete normally.
	Create a test program that creates the action to trigger the event.
	Comment the test program so a novice can understand it.

3. Create an INSTEAD OF trigger:
	Create an INSTEAD OF trigger on a view across two or more tables.
	Create a test program that creates the action to trigger the event.
	Comment the test program so a novice can understand it.
*************************************************************************************************************/



-- Allow an unlimited space for the output. This opens the buffer so that user can see data returned to them.
SET SERVEROUTPUT ON SIZE UNLIMITED

-- 1. -------------------------------------------------------------------------------------------------------
CREATE TABLE create_audit
( creation_audit_id NUMBER
, owner_name VARCHAR2(30)
, obj_name VARCHAR2(30)
, audit_time DATE);

-- Create a sequence
CREATE SEQUENCE create_audit_s1;

CREATE OR REPLACE TRIGGER create_audit_ddl_tl
BEFORE CREATE ON SCHEMA -- Before a rename on a schema
BEGIN
-- Insert values in the audit table holding information regarding the attempted rename.
INSERT INTO  create_audit VALUES
( creation_audit_s1.NEXTVAL
, ORA_DICT_OBJ_OWNER
, ORA_DICT_OBJ_NAME
, SYSDATE());
END create_audit_ddl_tl;
/
	 -- Create a test program that creates the action to trigger the event.

	CREATE TABLE ninja
		( ninja_id NUMBER
		, ninja_name VARCHAR2(60));
		DROP TABLE ninja;
		DROP TRIGGER create_audit_ddl_tl;
		DROP TABLE create_audit;
		DROP SEQUENCE create_audit_s1;

-- 2. --------------------------------------------------------------------------------------------------------

DROP TABLE avenger;
-- create avenger table
CREATE TABLE avenger
( avenger_id NUMBER
, avenger_name VARCHAR2(30)
, first_name VARCHAR2(20)
, last_name VARCHAR2(20)
, status VARCHAR2(20)); -- active or inactive

DROP TABLE message_log;
CREATE TABLE message_log
( message VARCHAR2(200));

-- create a procedure to simply raise an exception. The pragma autonomous_transaction will give it its own schema.
create OR replace procedure avenger_error(error_name_avenge VARCHAR2) IS
	e exception;
	PRAGMA AUTONOMOUS_TRANSACTION;
	BEGIN
		RAISE e;
	EXCEPTION
		WHEN OTHERS THEN
		INSERT INTO message_log VALUES('tried to make' || error_name_avenge || 'INACTIVE');
		COMMIT;
		END;
	/
-- before creating, lets drop the trigger so any multiple creates will be overwritten.
DROP TRIGGER avenger_update_insert_t1;
-- create a trigger for anyone trying to update or insert.
CREATE OR replace trigger avenger_update_insert_t1
before insert OR UPDATE of status ON avenger
for each row
when (new.status = 'INACTIVE')
BEGIN
-- write an if then statement to capture what the user is trying to do. if they insert, that is fine, if they update, they will not be successful and the error "not allowed" will appear.
if inserting THEN
	dbms_output.put_line('allowed');
	end if;
	if updating THEN
		dbms_output.put_line('not allowed');
		avenger_error(:new.avenger_name); -- the :new.avenger_name is a bind value that will change according to what the user is using as an avenger name.
		END if;
	end;
/

-- test insert should be successful
INSERT INTO avenger VALUES (1, 'iron-man','Thor','Stark', 'INACTIVE');
	-- test update should be unsuccessful
	INSERT INTO avenger VALUES (2, 'Thor','Thor','', 'ACTIVE');
UPDATE avenger SET status = 'INACTIVE'
	WHERE avenger_name = 'Thor';
SELECT * FROM message_log;

-- 3. ---------------------------------------------------------------------------------------------------------


CREATE OR REPLACE VIEW person_info AS
	SELECT c.first_name, c.last_name, t.telephone_number FROM contact c, telephone t
	WHERE c.contact_id = t.contact_id;

-- CREATE A PROCEDURE TO HELP TRIGGER. This will run between the begin and end for the person_info_t1 trigger.

CREATE OR REPLACE PROCEDURE err_person_change IS
		e EXCEPTION; 
		PRAGMA AUTONOMOUS_TRANSACTION;  --so that it runs in its own scope
	BEGIN
		RAISE e;
	EXCEPTION
		WHEN OTHERS THEN
			dbms_output.put_line('You cannot change information in this view');
	END;
/


-- Create an INSTEAD OF trigger on a view across two or more tables 

CREATE OR REPLACE TRIGGER person_info_t1
	INSTEAD OF UPDATE ON person_info
	FOR EACH ROW
		BEGIN
			err_person_change();
		END;
/
	-- Create a test program that creates the action to trigger the event. 
UPDATE person_info SET last_name = 'Stuart';
SELECT * FROM person_info;
