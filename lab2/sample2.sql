set serveroutput on size unlimited

Declare
  lv_input varchar2(12) := '&input';
Begin
  dbms_output.put_line('['||lv_input||']');
end;
/
