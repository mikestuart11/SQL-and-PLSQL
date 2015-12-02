ALTER SESSION SET PLSQL_CCFLAGS = 'debug:1';

SET SERVEROUTPUT ON SIZE UNLIMITED
DROP TABLE message;
CREATE TABLE message (
text_message VARCHAR2(30));

CREATE OR REPLACE PROCEDURE write_always
	( pv_message VARCHAR2) IS
	lv_guarantee VARCHAR2(30) := 'PARAMETER NULL';
	PRAGMA AUTONOMOUS_TRANSACTION;
	$IF $$DEBUG = 1 THEN
		dbms_output.put_line('Debug Level 1 Enabled');
BEGIN
	INSERT INTO message VALUES (NVL(pv_message,lv_guarantee));
COMMIT;
END;
/
EXECUTE write_always('test');
EXECUTE write_always(NULL);
SELECT * FROM message;

CREATE OR REPLACE FUNCTION query_write
	( pv_message VARCHAR2) RETURN VARCHAR2 IS
	lv_return VARCHAR2(30) := 'NULL';
BEGIN
	write_always(pv_message);
SELECT text_message 
	INTO lv_return 
	FROM message
	WHERE text_message = pv_message;
	dbms_output.put_line('Debug ['|| lv_return ||']'); 
RETURN lv_return;
EXCEPTION
WHEN OTHERS THEN
	dbms_output.put_line('Debug ['|| lv_return ||']'|| chr(10)|| sqlerrm);
RETURN lv_return;
END;
/

SELECT query_write ('something') FROM dual;
SELECT query_write (NULL) FROM dual;