-- Open buffer between pl/sql engine back
-- to sqlplus environment*/
set serveroutput on size unlimited
------------------------------------------------------------------------------
------------------------------------------------------------------------------
-- Part 1 --------------------------------------------------------------------
DECLARE
-- create a varray of varchar2 strings
	TYPE my_varray IS VARRAY(3) OF VARCHAR2(20);
-- create 3 input varibales
	input1    VARCHAR2(30);
	input2    VARCHAR2(30);
	input3    VARCHAR2(30);
	input4    VARCHAR2(30);
-- create an empty VARRAY for MY_ARRAY
	lv_array MY_VARRAY := my_varray();
BEGIN
-- prompt users for inputs and save them into inputs 1 through 3
	input1 := '&input1';
	input2 := '&input2';
	input3 := '&input3';
	input4 := '&input4';
-- check if input1 is not null and then extending the array and assigning
-- input1 to index 1
	if input1 IS NOT NULL THEN
		lv_array.EXTEND;
		lv_array(lv_array.COUNT) := input1;
	END IF;
-- check if input2 is not null and then extending the array and assigning
-- input1 to index 2
	if input2 IS NOT NULL THEN
		lv_array.EXTEND;
		lv_array(lv_array.COUNT) := input2;
	END IF;
-- check if input3 is not null and then extending the array and assigning
-- input1 to index 3
	if input3 IS NOT NULL THEN
		lv_array.EXTEND;
		lv_array(lv_array.COUNT) := input3;
	END IF;
-- check if input3 is not null and then extending the array and assigning
-- input1 to index 3
	if input4 IS NOT NULL THEN
		lv_array.EXTEND;
		lv_array(lv_array.COUNT) := input4;
	END IF;
-- prints out all the elements in the lv_array to the screen
	FOR i IN lv_array.FIRST..lv_array.LAST LOOP
		dbms_output.put_line(lv_array(i));
	END LOOP;
EXCEPTION
when others then
dbms_output.put_line('[Not Enough Space in Array]');
END;
/
------------------------------------------------------------------------------
------------------------------------------------------------------------------
-- Part 1 --------------------------------------------------------------------
-- Declare block, declare variables
DECLARE
-- Decare a RECORD data type called PERSON_RECORD

	TYPE person_record IS RECORD (
		  full_name     VARCHAR2(60)
		, city		    VARCHAR2(60)
		, state		    VARCHAR2(60)
		, street		VARCHAR2(60));
-- create a table of PERSON_RECORD records.
	TYPE person_table IS TABLE OF PERSON_RECORD;
-- creating an empty table of PERSON_TABLE.
	my_table PERSON_TABLE := PERSON_TABLE();
-- create a temporary table called PERSON_RECORD
	temp PERSON_RECORD;
		CURSOR c IS
			SELECT	(c.first_name||' '||c.middle_name||' '||c.last_name) AS full_name
				,a.city AS city
				,a.state_province AS state
				,sa.street_address AS street
			FROM contact c INNER JOIN address a
			ON c.contact_id = a.contact_id
			INNER JOIN street_address sa
			ON a.address_id = sa.address_id
			ORDER BY full_name;

BEGIN
-- create for loop to extend my_table and put info into temp from tables
	FOR i IN c LOOP
		my_table.EXTEND;
		temp.full_name := i.full_name;
		temp.city :=i.city;
		temp.state := i.state;
		temp.street := i.street;
		my_table(my_table.COUNT) := temp;
	END LOOP;
-- print out all information displaying it all in reverse
	FOR i IN REVERSE my_table.FIRST..my_table.LAST LOOP
		dbms_output.put_line(my_table(i).full_name);
    END LOOP;

END;
/
-------------------------------------------------------------------------
-------------------------------------------------------------------------
-- Part 3 ---------------------------------------------------------------
DECLARE
-- create a record type 
	TYPE title_record IS RECORD (
		  item_title     VARCHAR2(60)
		, mpaa_ratings   VARCHAR2(8));
-- create a table of PERSON_RECORD records.
	TYPE lv_titles IS TABLE OF TITLE_RECORD;
-- creating an empty table of PERSON_TABLE.
	movies LV_TITLES := LV_TITLES();
-- create an index to use in our while loop
	lv_index NUMBER := 1;
-- create a cursor to store data from item table
	CURSOR c IS SELECT item_title, item_rating AS mpaa_ratings
			    FROM item;
-- create a temporary table to store data in
	temp_movie c%ROWTYPE;
BEGIN
-- open the cursor
	OPEN c;
-- fetch the first row of data and put into temp_movie
	FETCH c INTO temp_movie;
-- start while loop
	WHILE lv_index <= c%ROWCOUNT LOOP
		FETCH c INTO temp_movie; -- fetch a row of info and put in temp_movie
		movies.EXTEND; -- extend the collection
		movies(movies.COUNT).item_title := temp_movie.item_title; -- store info from temp table to movies
		movies(movies.COUNT).mpaa_ratings := temp_movie.mpaa_ratings;
		lv_index := lv_index + 1; -- increment loop
	END LOOP; 
-- print out all information to the screen
	FOR i IN movies.FIRST..movies.LAST LOOP
		dbms_output.put_line('Titles: '||movies(i).item_title||' Ratings: '||movies(i).mpaa_ratings);
    END LOOP;

END;
/
