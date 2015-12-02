set serverouput on size unlimited



DECLARE
	-- Define explicit record structure
	TYPE title_record IS RECORD
	( item_title    VARCHAR2(60)
	, item_subtitle VARCHAR2(60));

	-- Define dynamic values
	title_cursor SYS_REFCURSOR;
	title_row TITLE_RECORD;
	stmt VARCHAR2(2000);
BEGIN
	
	stmt := 'SELECT item_title, item_subtitle '
			|| 'FROM item '
			|| 'WHERE SUBSTR(item_title, 1, 12) = :input';

	OPEN title_cursor FOR stmt USING 'Harry Potter';
	LOOP
		FETCH title_cursor INTO title_row;
		EXIT WHEN title_cursor%NOTFOUND;
		dbms_output.put_line(
			'['||title_row.item_title||']('
				||title_row.item_subtitle||']');
	END LOOP;
	CLOSE title_cursor;
END;
/

-- NDS slides, 19, 20, 21
DROP FUNCTION get_item_list;
DROP TYPE item_list;
DROP TYPE item_object

CREATE OR REPLACE
	TYPE movie_object Is OBJECT 
	( item_title   VARCHAR2(60)
	, item_subtitle  VARCHAR2(60));
/

CREATE OR REPLACE
	TYPE item_list Is TABLE OF  item_object;
/


CREATE OR REPLACE FUNCTION get_item_list
	( pv_item_title   VARCHAR2) RETURN item_list IS
	-- Define explicit record structure
	TYPE title_record IS RECORD
	( item_title    VARCHAR2(60)
	, item_subtitle VARCHAR2(60));

	-- Declare local variables
	lv_counter      NUMBER := 0; 
	lv_item_record  ITEM_RECORD;
	lv_item_list    ITEM_LIST := item_list();

	-- Define dynamic values
	title_cursor SYS_REFCURSOR;
	stmt         VARCHAR2(2000);
BEGIN
	
	stmt := 'SELECT item_title, item_subtitle '
			|| 'FROM item '
			|| 'WHERE REGEXP_LIKE(item_title, 1, :input, '''i''')';
			dbms_output.put_line(stmt);

	OPEN title_cursor FOR stmt USING 'Harry Potter';
	LOOP
		FETCH title_cursor INTO lv_item_record;
		EXIT WHEN title_cursor%NOTFOUND;
		lv_movie_list.EXTEND;
		lv_item_list(lv_counter) :=
			item_object(lv_item_record.item_title
				, lv_item_record.item_subtitle);
		dbms_output.put_line(
			'['||lv_item_record.item_title||']('
				||lv_item_record.item_subtitle||']');
	END LOOP;
	CLOSE title_cursor;
END;
/








