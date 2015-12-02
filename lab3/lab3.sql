--Open buffer between pl/sql engine back
--to sqlplus environment
set serveroutput on size unlimited

-- Declare block, declare variables
DECLARE
  -- Declare input variables
  input_number VARCHAR2(100);
  input_date VARCHAR2(10);
  input_varchar VARCHAR2(100);
  
  -- declare local variables
  local_number NUMBER;
  local_date DATE;
  local_varchar VARCHAR2(10);
  
  -- declare record data type
  TYPE lab3_record IS RECORD
  ( lab3_number NUMBER
  , lab3_date DATE
  , lab3_varchar VARCHAR2(10));
  
  -- create instance of lab3_record data type
  the_record lab3_record;

-- Begin block
BEGIN
  -- prompt user for input and save into input 
  -- variables
  input_number := '&number';
  input_date := verify_date('&date');
  input_varchar := '&description';

  -- cast input variables into local variables 
  local_number := TO_NUMBER(input_number);
  local_date := TO_DATE(input_date);
  
  -- check length of varchar and save into
  -- local varchar
  if length(input_varchar) <= 10 THEN
  local_varchar := input_varchar;
  ELSE
  local_varchar := SUBSTR(input_varchar, 1, 10);  
  END if;

  -- store local variables into record variables
  the_record.lab3_number := local_number;
  the_record.lab3_date := local_date;
  the_record.lab3_varchar := local_varchar;
  
  
  -- record variables are then displayed on the screen
  dbms_output.put_line('Output:');
  dbms_output.put_line('---------------------------------');
  dbms_output.put_line('The record number is '|| the_record.lab3_number);
  dbms_output.put_line('The record date is '|| the_record.lab3_date);
  dbms_output.put_line('The record word is '|| the_record.lab3_varchar);

-- end BEGIN

-- exception to catch errors
EXCEPTION
when others then
dbms_output.put_line('Incorrect Input');
end;
/
