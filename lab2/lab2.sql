--Open buffer between pl/sql engine back
--to sqlplus environment
set serveroutput on size unlimited

-- Declare block, declare variables
DECLARE
  lv_input    VARCHAR2(100);
  lv_local    VARCHAR2(10);
  lv_print    VARCHAR2(17);

-- Begin block
BEGIN
  -- prompt user for input and save
  -- into lv_input
  lv_input := '&input';

  -- create if statement to check that 
  -- lv_input is less than 10 characters
  -- then saves it into lv_local
  if length(lv_input) <= 10 then
  lv_local := lv_input;

  -- if the lv_input is more than 10
  -- characters then only 10 characters are
  -- saved into lv_local
  else
  lv_local := SUBSTR(lv_input, 0, 9);  
  end if;

  -- 'Hello and the lv_local are saved into
  -- lv_print
  lv_print := 'Hello '||lv_local||'!';

  -- lv_print is then displayed on the screen
  dbms_output.put_line('['||lv_print||']');

EXCEPTION
  when others then
  dbms_output.put_line('Caught');
end;
/
