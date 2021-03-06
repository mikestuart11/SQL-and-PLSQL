SET SERVEROUTPUT ON SIZE UNLIMITED
DECLARE
  
/* Declare a ADT. */
  TYPE fruit_array IS VARRAY(4) OF VARCHAR2(20);
  
/* Declare a variable using our ADT. */
  lv_array  FRUIT_ARRAY := fruit_array('Apple','Orange','Pear');
BEGIN
  
/* Print the maximum possible values in an array. */
  dbms_output.put_line('Limit: ['||lv_array.LIMIT||']');
  
/* Print the maximum actual values in an array. */
  dbms_output.put_line('Count: ['||lv_array.COUNT||']');
  
/* Allocates memory to the array. */
  lv_array.EXTEND;
  
/* Assign a value at the end of the array. */
  lv_array(lv_array.COUNT) := 'Strawberry';
  
/* Read from the first to last element of the array. */
  FOR i IN 1..lv_array.COUNT LOOP
    dbms_output.put_line(lv_array(i));
  END LOOP;
  
/* Read from the first to last element of the array. */
  FOR i IN lv_array.FIRST..lv_array.LAST LOOP
    dbms_output.put_line(lv_array(i));
  END LOOP;
END;
/

LIST
SHOW ERRORS

DECLARE
  
/* Declare a ADT. */
  TYPE fruit_array IS TABLE OF VARCHAR2(20);
  
/* Declare a variable using our ADT. */
  lv_array  FRUIT_ARRAY := fruit_array('Apple','Orange','Pear');
BEGIN
  
/* You can't print the maximum possible values in a list
     because they're never known, except for the actual count
     of values in the list. */
  -- dbms_output.put_line('Limit: ['||lv_array.LIMIT||']');
  
/* Print the maximum actual values in an array. */
  dbms_output.put_line('Count: ['||lv_array.COUNT||']');
  
/* Allocates memory to the array. */
  lv_array.EXTEND;
  
/* Assign a value at the end of the array. */
  lv_array(lv_array.COUNT) := 'Strawberry';
  
/* Read from the first to last element of the array. */
  FOR i IN 1..lv_array.COUNT LOOP
    dbms_output.put_line(lv_array(i));
  END LOOP;
  
/* Read from the first to last element of the array. */
  FOR i IN lv_array.FIRST..lv_array.LAST LOOP
    dbms_output.put_line(lv_array(i));
  END LOOP;
END;
/

LIST
SHOW ERRORS

DECLARE
  
/* Declare a ADT. */
  TYPE fruit_array IS TABLE OF VARCHAR2(20);
  
/* Declare a variable using our ADT. */
  lv_array  FRUIT_ARRAY := fruit_array('Apple','Orange','Pear');
  
  current NUMBER;
  
BEGIN
  
/* You can't print the maximum possible values in a list
     because they're never known, except for the actual count
     of values in the list. */
  dbms_output.put_line('Limit: ['||lv_array.LIMIT||']');
  
/* Print the maximum actual values in an array. */
  dbms_output.put_line('Count: ['||lv_array.COUNT||']');
  
/* Allocates memory to the array. */
  lv_array.EXTEND;
  -- Assign a value at the end of the array.
  lv_array(lv_array.COUNT) := 'Strawberry';
  lv_array.DELETE(2);

  
/* Read from the first to last element of the array.*/

/* FOR i IN lv_array.FIRST..lv_array.LAST LOOP
    dbms_output.put_line(lv_array(i));
  END LOOP; */
  
  current := lv_array.FIRST;

  WHILE (current <= lv_array.LAST) LOOP
    if (lv_array.exists(current)) then
    dbms_output.put_line('Values ['||current||']['||lv_array(current)||']');
    END if;
    
  current := lv_array.NEXT(current);
  END LOOP;
  

  -- Read from the first to last element of the array.
  
/* FOR i IN 1..lv_array.COUNT LOOP
    dbms_output.put_line(lv_array(i));
  END LOOP; */
END;
/

LIST
SHOW ERRORS
