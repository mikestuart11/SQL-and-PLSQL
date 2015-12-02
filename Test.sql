set serveroutput on size unlimited

-- Declare block, declare variables
DECLARE
input_number NUMBER;
tell BOOLEAN := false;


BEGIN

  -- prompt user for input



WHILE tell = false LOOP
  input_number := '&number';

  IF input_number BETWEEN 0 AND 11 THEN
    tell := true;
  ELSE
    dbms_output.put_line('['||'Please input number between 0 and 10'||']');
  END IF;
END LOOP;



end;
/