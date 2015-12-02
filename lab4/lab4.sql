-- Open buffer between pl/sql engine back
-- to sqlplus environment*/
set serveroutput on size unlimited

-- Declare block, declare variables
DECLARE
input_number NUMBER;
counter      NUMBER := 10;

-- declare a record with one variable inside it
TYPE title_record IS RECORD
( item_title VARCHAR2(60));

-- declare a collection of the records
TYPE title_table Is TABLE OF TITLE_RECORD;
-- create an instance of the collection
lv_titles TITLE_TABLE;

-- Begin block
BEGIN

  -- prompt user for input
input_number := '&number';

-- if input_number is between 0 and 10 then Match
-- will be displayed, if not then Not a Match will
-- be displayed*/
IF input_number <= 10 AND input_number >= 1 THEN
  dbms_output.put_line('['||'Match'||']');
ELSE
  dbms_output.put_line('Not A Match');
END IF;


--select all the titles from item_titles in the items table, assign
--each of those values to the item_title variables inside the record
--inside the collection

SELECT item_title
  BULK COLLECT INTO lv_titles
FROM   item;
-- next use a for loop to print the item_title variables in the 
-- record to the screen
FOR i IN 1..lv_titles.COUNT LOOP 
dbms_output.put_line('Title ('||lv_titles(i).item_title||']');
  END LOOP;


-- loops through the numbers 10 down to 0
-- and prints that number to the screen
WHILE counter >= 0 
LOOP 
dbms_output.put('[' || counter|| ']' || ' ');
-- dbms_output.put_line(counter);
counter := counter - 1;
END LOOP;

dbms_output.put_line(' ');

-- end BEGIN

-- exception to catch errors
EXCEPTION
when others then
dbms_output.put_line('Incorrect Input');
end;
/
