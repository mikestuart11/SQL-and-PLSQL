BEGIN
  FOR i IN (SELECT object_name
  			, object_type
  			FROM user_objects
  			WHERE object_name = 'DUMMY') LOOP
  EXECUTE immediate 'drop ' || i.object_type
  			|| ' ' || i.object_name;
  END LOOP;
END;
/

DROP table message;
CREATE table message(message_text varchar2(200));

CREATE OR REPLACE FUNCTION dummy RETURN varchar2 IS
PRAGMA autonomous_transaction;
BEGIN
	INSERT into message VALUES ( 'Doing nothing.');
RETURN 'Do nothing.';
END;
/

set serveroutput on size unlimited;
DECLARE
	lv_output varchar2(40);
BEGIN
  lv_output := dummy;
  dbms_output.put_line(lv_output);
END;
/

COLUMN output format A40
SELECT dummy() as output FROM dual;
SELECT * FROM message;

-- when you want to test pl/sql code in a sql environment
-- then you need to put parenthesis after the function like: dummy()

