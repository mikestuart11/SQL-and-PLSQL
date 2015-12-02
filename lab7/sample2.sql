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

CREATE OR REPLACE FUNCTION dummy RETURN varchar2 IS
BEGIN
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

-- when you want to test pl/sql code in a sql environment
-- then you need to put parenthesis after the function like: dummy()

