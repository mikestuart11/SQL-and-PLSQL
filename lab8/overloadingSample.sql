-- Specification -----------------------------------------------------------------------------------------------------------
CREATE OR REPLACE PACKAGE overloading IS
  FUNCTION message (pv_id NUMBER, pv_text VARCHAR2) RETURN VARCHAR2;
  FUNCTION message (pv_text VARCHAR2, pv_id NUMBER) RETURN VARCHAR2;
END overloading;
/

-- Package Body ------------------------------------------------------------------------------------------------------------
CREATE OR REPLACE PACKAGE BODY overloading IS
  FUNCTION message (pv_id NUMBER, pv_text VARCHAR2) RETURN VARCHAR2 IS
    lv_module_name VARCHAR2(30) := 'Module 1';

    BEGIN
      RETURN '['||pv_id||']['||pv_text||']['||lv_module_name||']';
  END message;

  FUNCTION message (pv_text VARCHAR2, pv_id NUMBER) RETURN VARCHAR2 IS
      lv_module_name VARCHAR2(30) := 'Module 2';
    BEGIN
    RETURN '['||pv_id||']['||pv_text||']['||lv_module_name||']';
  END message;
END overloading;
/

SELECT overloading.message (1,'Captain America')
,      overloading.message ('Thor', 2)
FROM DUAL;

SELECT overloading.message (1,'Captain America')
,      overloading.message ('Thor', 2)
,      overloading.message (pv_id => 3, pv_text => 'Iron Man')
FROM DUAL;

CREATE OR REPLACE PACKAGE overloading IS
  FUNCTION message
    ( pv_id NUMBER
      , pv_text1 VARCHAR2)

  RETURN VARCHAR2;

  FUNCTION message
    ( pv_text2 VARCHAR2
      , pv_id NUMBER
      , pv_date DATE := TRUNC(SYSDATE))

  RETURN VARCHAR2;

END overloading;
/



CREATE OR REPLACE PACKAGE BODY overloading IS
  FUNCTION message
    ( pv_id NUMBER
      , pv_text1 VARCHAR2) RETURN VARCHAR2 IS
    lv_module_name VARCHAR2(30) := 'Module 1';

    BEGIN

    RETURN '['||lv_module_name||']['||pv_id||']['||pv_text1||']';

  END message;

  FUNCTION message

    ( pv_text2 VARCHAR2
      , pv_id NUMBER
      , pv_date DATE DEFAULT TRUNC(SYSDATE)) RETURN VARCHAR2 IS
      lv_module_name VARCHAR2(30) := 'Module 2';

    BEGIN
    RETURN '['||lv_module_name||']['||pv_id||']['||pv_text2||']';
  END message;

END overloading;
/

list
show errors

SELECT overloading.message (1,'Captain America')
,      overloading.message ('Thor', 2)
FROM DUAL;

SELECT overloading.message (1,'Captain America')
,      overloading.message ('Thor', 2)
,      overloading.message (pv_id => 3, pv_text1 => 'Iron Man'
 , pv_date => TRUNC(SYSDATE + 1))
FROM DUAL;



SELECT overloading.message (1,'Captain America')
,      overloading.message ('Thor', 2)
,      overloading.message (pv_id => 3, pv_text2 => 'Iron Man')
FROM DUAL;



CREATE OR REPLACE PACKAGE overloading IS
  FUNCTION message
    ( pv_id NUMBER
      , pv_text1 VARCHAR2)
  RETURN VARCHAR2;

  FUNCTION message
    ( pv_text2 VARCHAR2
      , pv_id NUMBER
      , pv_date DATE := TRUNC(SYSDATE))

  RETURN VARCHAR2;
  PROCEDURE diagnostic (pv_text VARCHAR2);
END overloading;
/



CREATE OR REPLACE PACKAGE BODY overloading IS
  lv_module_name VARCHAR2(30) := 'Overloading';
  FUNCTION message
    ( pv_id NUMBER
      , pv_text1 VARCHAR2)
  RETURN VARCHAR2 IS

  BEGIN
    diagnostic (lv_module_name);
    lv_module_name := lv_module_name||'Module 1';
    RETURN '['||lv_module_name||']['||pv_id||']['||pv_text1||']';
    END message;
    FUNCTION message
    ( pv_text2 VARCHAR2
      , pv_id NUMBER
      , pv_date DATE DEFAULT TRUNC(SYSDATE))

    RETURN VARCHAR2 IS
  BEGIN
    diagnostic (lv_module_name);
    lv_module_name := lv_module_name||'Module 2';
    RETURN '['||lv_module_name||']['||pv_id||']['||pv_text2||']';
  END message;

  PROCEDURE diagnostic (pv_text VARCHAR2) IS
    lv_output VARCHAR2(400);
  PRAGMA AUTONOMOUS_TRANSACTION;
  BEGIN
    lv_output := pv_text;
    dbms_output.put_line(lv_output);
  END diagnostic;
END overloading;
/

list
show errors

SET SERVEROUTPUT ON SIZE UNLIMITED
SELECT overloading.message (1,'Captain America')
,      overloading.message ('Thor', 2)
FROM DUAL;



SELECT overloading.message (1,'Captain America')
,      overloading.message ('Thor', 2)
,      overloading.message (pv_id => 3, pv_text1 => 'Iron Man'
, pv_date => TRUNC(SYSDATE + 1))
FROM DUAL;

SELECT overloading.message (1,'Captain America')
,      overloading.message ('Thor', 2)
,      overloading.message (pv_id => 3, pv_text2 => 'Iron Man')
FROM DUAL;