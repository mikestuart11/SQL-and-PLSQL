SET SERVEROUTPUT ON SIZE UNLIMITED
-- step 2
DECLARE
	TYPE person_record IS RECORD (
		full_name	VARCHAR2(60)
		,city		VARCHAR2(60)
		,state		VARCHAR2(60)
		,street		VARCHAR2(60));
	TYPE person_table IS TABLE OF PERSON_RECORD;
--creating an empty table.
	my_table PERSON_TABLE := PERSON_TABLE();

	temp PERSON_RECORD;
		CURSOR c IS
			SELECT	(c.first_name||''||c.last_name) AS full_name
				, a.city AS city
				, a.state_province AS state
				, sa.street_address AS street
			FROM contact c INNER JOIN address a
			ON c.contact_id = a.contact_id
			INNER JOIN street_address sa
			ON a.address_id = sa.address_id
			ORDER BY full_name;
		
BEGIN
	FOR i IN c LOOP
		my_table.EXTEND;
		temp.full_name := i.full_name;
		temp.city :=i.city;
		temp.state := i.state;
		temp.street := i.street;
		my_table(my_table.COUNT) := temp;
	END LOOP;
	dbms_output.put_line(my_table.COUNT);
END;
/