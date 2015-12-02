set serveroutput on size unlimited

-- Declare block, declare variables
DECLARE
input_number NUMBER;
	

BEGIN


LOOP
  input_number := &number;
  IF input_number BETWEEN 0 AND 11 THEN
    EXIT;
  END IF;
END LOOP;




dbms_output.put_line('['||input_number||']');

end;
/