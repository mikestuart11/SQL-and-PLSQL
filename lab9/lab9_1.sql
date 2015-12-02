



DECLARE
-- creates an array of strings
  TYPE title_array IS VARRAY(6) OF VARCHAR2(1024);
-- create an instance of the the title_array array
  myArray title_array := title_array
                ( 'Harry Potter and the Sorcer''s Stone'
                , 'Harry Potter and the Chamber of Secrets'
                , 'Harry Potter and the Prisoner of Azkaban'
                , 'Harry Potter and the Goblet of Fire'
                , 'Harry Potter and the Order of the Phoenix');

BEGIN
-- create a loop that loops through all the text files in the array
  FOR j IN 1..myArray.count LOOP

    FOR i IN (SELECT item_id
              FROM   item
              WHERE  REGEXP_LIKE(item_title, myArray(j), 'i')
              AND    item_type IN (SELECT common_lookup_id
                                   FROM   common_lookup
                                   WHERE  common_lookup_table = 'ITEM'
                                   AND    common_lookup_column = 'ITEM_TYPE'
                                   AND    REGEXP_LIKE(common_lookup_type,'^(dvd|vhs)*','i'))) LOOP
    -- this applies whatever is in the textfile to the item_desc 
    load_clob_from_file( src_file_name     => myArray(j) || '.txt'
                       , table_name        => 'ITEM'
                       , column_name       => 'ITEM_DESC'
                       , primary_key_name  => 'ITEM_ID'
                       , primary_key_value => TO_CHAR(i.item_id) );
    END LOOP;
  END LOOP;
END;
/

-- Check after load.
SELECT item_id
,      item_title
,      dbms_lob.getlength(item_desc) AS "SIZE"
FROM   item
WHERE  dbms_lob.getlength(item_desc) > 0;
/


