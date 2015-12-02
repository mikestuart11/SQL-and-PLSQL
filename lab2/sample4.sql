set serveroutput on size unlimited

Declare
  lv_input varchar2(12);
Begin
  if length(lv_input) <= 12 then 
  lv_input := '&input';
  end if;

  dbms_output.put_line('['||lv_input||']');

Exception
  when others then
  dbms_output.put_line('Caught');
end;
/
