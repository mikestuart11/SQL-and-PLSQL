set serveroutput on size unlimited

Declare
  lv_input varchar2(12);
Begin
  lv_input := '&input';
  dbms_output.put_line('['||lv_input||']');
Exception
  when others then
  dbms_output.put_line('Caught');
end;
/
