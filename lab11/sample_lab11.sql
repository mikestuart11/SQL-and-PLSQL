SET SERVEROUTPUT ON SIZE UNLIMITED

DROP TABLE avenger;

CREATE TABLE avenger
(avenger_id     NUMBER
,avenger_name    VARCHAR2(30)
,first_name    VARCHAR2(20)
,last_name    VARCHAR2(20)
,status        VARCHAR2(8));

CREATE OR REPLACE TRIGGER avenger_update_t1
BEFORE UPDATE ON avenger
FOR EACH ROW WHEN (new.status = 'INACTIVE')
BEGIN
raise_application_error(-20001,'No one gets to be inactive');
END avenger_update_t1;
/

INSERT INTO avenger VALUES
(1,'Iron Man','Tony','Stark','ACTIVE');

-- This is the testcase.

UPDATE avenger SET status = 'INACTIVE'
WHERE avenger_name = 'Iron Man';









DROP TABLE message_log;

CREATE TABLE message_log (message VARCHAR2(30));

CREATE OR REPLACE PROCEDURE avenger_alert
(recepient    VARCHAR2) IS 
e exception;
PRAGMA autonomous_transaction;

BEGIN
dbms_output.put_line('E-mail attempted');
RAISE e;
EXCEPTION 
WHEN OTHERS THEN 
INSERT INTO message_log VALUES (recepient);
COMMIT; 
END avenger_alert;
/

CREATE OR REPLACE TRIGGER avenger_update_t1
BEFORE UPDATE ON avenger
FOR EACH ROW WHEN (new.status = 'INACTIVE')
BEGIN
avenger_alert(:new.avenger_name);
END avenger_update_t1;
/

SET SERVEROUTPUT ON SIZE UNLIMITED

UPDATE avenger SET status = 'INACTIVE'
WHERE avenger_name = 'Iron Man';

SELECT * FROM message_log;