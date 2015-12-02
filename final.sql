/*
1. [20 points] Create a base_t object type that complies with the definition in the CIT325_Object_Types.pdf document.
	 The base_t object should have a get_oname and get_name function, set_oname procedure, and to_string function. 
	 To that end, the get_name function should return a NULL value, which effectively creates a common definition 
	 without an implementation. The get_name function serves as an abstract method, which you'll implement in 
	 subtypes of the base_t object. (HINT: The ordering of columns in constructors must mirror the sequence of 
	 their definition in supertypes to their lowest subtypes. Any violation of that sequencing would raise a "too 
	 many declarations of ..." error.) 
2. [5 points] Create a tolkien table that has two columns: a tolkien_id primary key column that uses a NUMBER data 
	type; and a character column that uses a BASE_T data type; and create a tolkien_s sequence that starts with a 
	value of 1001.
3. [25 points] Create the dwarf, elf, goblin, hobbit, maia, man, and orc object types and bodies that extend the 
	behavior of the base_t object and complies with the definition of the hobbit object type 
	(found in the CIT325_Final_Project.pdf document).
	These the dwarf, elf, goblin, hobbit, maia, man, and orc object types and bodies should:

	Override the to_string function found in the base_t object type.
	Override the get_name function found in the base_t object type.
	Implement the get_genus function.
	Implement the set_name and set_genus procedures.

4. [25 points] Create the noldor, silvan, sindar, and teleri object types and bodies that extend the behavior of 
	the elf object and complies with the definition of the elf object type in the CIT325_Final_Project.pdf document. 
	These object types and bodies should override the to_string function of the base_t object type. The noldor, silvan, 
	sindar, and teleri object types should also implement the get_elfkind function and set_elfkind procedure.
5. [25 points] Write an anonymous block program that inserts the object instances. Then, use the confirmation query 
    from the CIT325_Final_Project.pdf file to verify the project.
*/

-- #1 ----------------------------------------------------------------------------------
SET SERVEROUTPUT ON SIZE UNLIMITED

BEGIN
    dbms_utility.get_dependency ( TYPE => 'TYPE'
                                , SCHEMA => 'STUDENT'
                                , NAME => 'base_t');
END;
/

--Comment your code to explain it to a novice.
-- drop type hobbit_t, base_t and sequence obj_s1 so the script is re-runnable
DROP TABLE tolkien;
DROP TYPE hobbit_t;
DROP TYPE noldor_t;
DROP TYPE sindar_t;
DROP TYPE silvan_t;
DROP TYPE teleri_t;
DROP TYPE elf_t;
DROP TYPE dwarf_t;
DROP TYPE goblin_t;
DROP TYPE maia_t;
DROP TYPE man_t;
DROP TYPE orc_t;
DROP TYPE base_t;
DROP SEQUENCE tolkien_s1;
DROP SEQUENCE obj_s1;
-- create the object type with parameters and call it base_t
/**************************************************************************
***************************************************************************
BASE BASE BASE BASE BASE BASE BASE BASE BASE BASE BASE BASE BASE BASE 
***************************************************************************
**************************************************************************/
CREATE OR REPLACE TYPE base_t IS OBJECT
( OID   NUMBER
, name  VARCHAR(30)
, CONSTRUCTOR FUNCTION base_t RETURN SELF AS RESULT
, MEMBER FUNCTION get_name RETURN VARCHAR2
, MEMBER PROCEDURE set_name (pv_name VARCHAR2)
, MEMBER FUNCTION to_string RETURN VARCHAR2)

INSTANTIABLE NOT FINAL;
/


-- create a sequence and call it obj_s1
CREATE SEQUENCE obj_s1;

-- create the default boddy of base_t
CREATE OR REPLACE TYPE BODY base_t IS

-- A default constructor w/o formal parameters.
CONSTRUCTOR FUNCTION base_t RETURN SELF AS RESULT IS
	BEGIN
		self.name := 'BASE_T';
		self.OID := obj_s1.NEXTVAL;
	RETURN;
END;

-- create function called get_name that 
MEMBER FUNCTION get_name RETURN VARCHAR2 IS 
	BEGIN
		RETURN self.name;
	END get_name;

-- create a procedure
MEMBER PROCEDURE set_name
	( pv_name VARCHAR2) IS 
	BEGIN 
		self.name := pv_name;
	END set_name;

-- create a conversion method that converts the object
-- to a string data type
MEMBER FUNCTION to_string RETURN VARCHAR2 IS
	BEGIN
		RETURN '[Object ID: '||self.OID||'] [Name: '||self.name||']';
	END to_string;
END;
/

/**************************************************************************
***************************************************************************
HOBBIT HOBBIT HOBBIT HOBBIT HOBBIT HOBBIT HOBBIT HOBBIT HOBBIT HOBBIT 
***************************************************************************
**************************************************************************/
-- create an hobbit object type
CREATE OR REPLACE TYPE hobbit_t UNDER base_t
	( genus VARCHAR2(20)
	, CONSTRUCTOR FUNCTION hobbit_t
	( pv_name  VARCHAR2) RETURN SELF AS RESULT
	, MEMBER FUNCTION get_genus RETURN VARCHAR2
	, MEMBER PROCEDURE set_genus (pv_genus VARCHAR2)
	, OVERRIDING MEMBER FUNCTION to_string RETURN VARCHAR2)

 INSTANTIABLE NOT FINAL;
/

-- create the default boddy of base_t
CREATE OR REPLACE TYPE BODY hobbit_t IS

-- A default constructor w/o formal parameters.
CONSTRUCTOR FUNCTION hobbit_t
(pv_name VARCHAR2) RETURN SELF AS RESULT IS
	BEGIN
		self.OID := obj_s1.NEXTVAL;
		self.name := pv_name;
		self.genus := 'HOBBIT';
	RETURN;
END;

-- create function called get_name that 
MEMBER FUNCTION get_genus RETURN VARCHAR2 IS 
	BEGIN
		RETURN self.genus;
	END get_genus;

-- create a procedure
MEMBER PROCEDURE set_genus
	( pv_genus VARCHAR2) IS 
	BEGIN 
		self.genus := pv_genus;
	END set_genus;

-- create a conversion method that converts the object
-- to a string data type
OVERRIDING MEMBER FUNCTION to_string RETURN VARCHAR2 IS
	BEGIN
		RETURN(self AS base_t).to_string||'[ Genus: '||self.genus||']';
	END to_string;
END;
/

/**************************************************************************
***************************************************************************
ELF ELF ELF ELF ELF ELF ELF ELF ELF ELF ELF ELF ELF ELF ELF ELF ELF ELF
***************************************************************************
**************************************************************************/
CREATE OR REPLACE TYPE elf_t UNDER base_t
	( genus VARCHAR2(20)
	, CONSTRUCTOR FUNCTION elf_t
	( pv_name   VARCHAR2) RETURN SELF AS RESULT
	, MEMBER FUNCTION get_genus RETURN VARCHAR2
	, MEMBER PROCEDURE set_genus (pv_genus VARCHAR2)
	, OVERRIDING MEMBER FUNCTION to_string RETURN VARCHAR2)

 INSTANTIABLE NOT FINAL;
/

-- create the default boddy of base_t
CREATE OR REPLACE TYPE BODY elf_t IS

-- A default constructor w/o formal parameters.
CONSTRUCTOR FUNCTION elf_t
(pv_name VARCHAR2) RETURN SELF AS RESULT IS
	BEGIN
		self.OID := obj_s1.NEXTVAL;
		self.name := pv_name;
		self.genus := 'ELF';
	RETURN;
END;

-- create function called get_name that 
MEMBER FUNCTION get_genus RETURN VARCHAR2 IS 
	BEGIN
		RETURN self.genus;
	END get_genus;

-- create a procedure
MEMBER PROCEDURE set_genus
	( pv_genus VARCHAR2) IS 
	BEGIN 
		self.genus := pv_genus;
	END set_genus;

-- create a conversion method that converts the object
-- to a string data type
OVERRIDING MEMBER FUNCTION to_string RETURN VARCHAR2 IS
	BEGIN
		RETURN(self AS base_t).to_string||'[ Genus: '||self.genus||']';
	END to_string;
END;
/
/**************************************************************************
NOLDOR NOLDOR NOLDOR NOLDOR NOLDOR NOLDOR NOLDOR NOLDOR NOLDOR NOLDOR 
**************************************************************************/
CREATE OR REPLACE TYPE noldor_t UNDER elf_t
	( elfkind  VARCHAR2(20)
	, CONSTRUCTOR FUNCTION noldor_t
	( pv_name   VARCHAR2) RETURN SELF AS RESULT
	, MEMBER FUNCTION get_elfkind RETURN VARCHAR2
	, MEMBER PROCEDURE set_elfkind (pv_elfkind VARCHAR2)
	, OVERRIDING MEMBER FUNCTION to_string RETURN VARCHAR2)

 INSTANTIABLE NOT FINAL;
/

CREATE OR REPLACE TYPE BODY noldor_t IS

-- A default constructor w/o formal parameters.
CONSTRUCTOR FUNCTION noldor_t
(pv_name VARCHAR2) RETURN SELF AS RESULT IS
	BEGIN
		self.OID := obj_s1.NEXTVAL;
		self.name := pv_name;
		self.genus := 'ELF';
		self.elfkind := 'NOLDOR';
	RETURN;
END;

MEMBER FUNCTION get_elfkind RETURN VARCHAR2 IS
	BEGIN
	RETURN self.elfkind;
	END get_elfkind;

MEMBER PROCEDURE set_elfkind 
	(pv_elfkind VARCHAR2) IS
	BEGIN
		self.elfkind := pv_elfkind;
	END set_elfkind;
-- create a conversion method that converts the object
-- to a string data type
OVERRIDING MEMBER FUNCTION to_string RETURN VARCHAR2 IS
	BEGIN
		RETURN(self AS elf_t).to_string||'[ Elfkind: '||self.elfkind||']';
	END to_string;
END;
/
/**************************************************************************
SINDAR SINDAR SINDAR SINDAR SINDAR SINDAR SINDAR SINDAR SINDAR SINDAR  
**************************************************************************/
CREATE OR REPLACE TYPE sindar_t UNDER elf_t
	( elfkind  VARCHAR2(20)
	, CONSTRUCTOR FUNCTION sindar_t
	( pv_name   VARCHAR2) RETURN SELF AS RESULT
	, MEMBER FUNCTION get_elfkind RETURN VARCHAR2
	, MEMBER PROCEDURE set_elfkind (pv_elfkind VARCHAR2)
	, OVERRIDING MEMBER FUNCTION to_string RETURN VARCHAR2)

 INSTANTIABLE NOT FINAL;
/

CREATE OR REPLACE TYPE BODY sindar_t IS

-- A default constructor w/o formal parameters.
CONSTRUCTOR FUNCTION sindar_t
(pv_name VARCHAR2) RETURN SELF AS RESULT IS
	BEGIN
		self.OID := obj_s1.NEXTVAL;
		self.name := pv_name;
		self.genus := 'ELF';
		self.elfkind := 'SINDAR';
	RETURN;
END;

MEMBER FUNCTION get_elfkind RETURN VARCHAR2 IS
	BEGIN
	RETURN self.elfkind;
	END get_elfkind;

MEMBER PROCEDURE set_elfkind 
	(pv_elfkind VARCHAR2) IS
	BEGIN
		self.elfkind := pv_elfkind;
	END set_elfkind;
-- create a conversion method that converts the object
-- to a string data type
OVERRIDING MEMBER FUNCTION to_string RETURN VARCHAR2 IS
	BEGIN
		RETURN(self AS elf_t).to_string||'[ Elfkind: '||self.elfkind||']';
	END to_string;
END;
/
/**************************************************************************
SILVAN SILVAN SILVAN SILVAN SILVAN SILVAN SILVAN SILVAN SILVAN SILVAN   
**************************************************************************/
CREATE OR REPLACE TYPE silvan_t UNDER elf_t
	( elfkind  VARCHAR2(20)
	, CONSTRUCTOR FUNCTION silvan_t
	( pv_name   VARCHAR2) RETURN SELF AS RESULT
	, MEMBER FUNCTION get_elfkind RETURN VARCHAR2
	, MEMBER PROCEDURE set_elfkind (pv_elfkind VARCHAR2)
	, OVERRIDING MEMBER FUNCTION to_string RETURN VARCHAR2)

 INSTANTIABLE NOT FINAL;
/

CREATE OR REPLACE TYPE BODY silvan_t IS

-- A default constructor w/o formal parameters.
CONSTRUCTOR FUNCTION silvan_t
(pv_name VARCHAR2) RETURN SELF AS RESULT IS
	BEGIN
		self.OID := obj_s1.NEXTVAL;
		self.name := pv_name;
		self.genus := 'ELF';
		self.elfkind := 'SILVAN';
	RETURN;
END;

MEMBER FUNCTION get_elfkind RETURN VARCHAR2 IS
	BEGIN
	RETURN self.elfkind;
	END get_elfkind;

MEMBER PROCEDURE set_elfkind 
	(pv_elfkind VARCHAR2) IS
	BEGIN
		self.elfkind := pv_elfkind;
	END set_elfkind;
-- create a conversion method that converts the object
-- to a string data type
OVERRIDING MEMBER FUNCTION to_string RETURN VARCHAR2 IS
	BEGIN
		RETURN(self AS elf_t).to_string||'[ Elfkind: '||self.elfkind||']';
	END to_string;
END;
/
/**************************************************************************
TELERI TELERI TELERI TELERI TELERI TELERI TELERI TELERI TELERI TELERI    
**************************************************************************/
CREATE OR REPLACE TYPE teleri_t UNDER elf_t
	( elfkind  VARCHAR2(20)
	, CONSTRUCTOR FUNCTION teleri_t
	( pv_name   VARCHAR2) RETURN SELF AS RESULT
	, MEMBER FUNCTION get_elfkind RETURN VARCHAR2
	, MEMBER PROCEDURE set_elfkind (pv_elfkind VARCHAR2)
	, OVERRIDING MEMBER FUNCTION to_string RETURN VARCHAR2)

 INSTANTIABLE NOT FINAL;
/

CREATE OR REPLACE TYPE BODY teleri_t IS

-- A default constructor w/o formal parameters.
CONSTRUCTOR FUNCTION teleri_t
(pv_name VARCHAR2) RETURN SELF AS RESULT IS
	BEGIN
		self.OID := obj_s1.NEXTVAL;
		self.name := pv_name;
		self.genus := 'ELF';
		self.elfkind := 'TELERI';
	RETURN;
END;

MEMBER FUNCTION get_elfkind RETURN VARCHAR2 IS
	BEGIN
	RETURN self.elfkind;
	END get_elfkind;

MEMBER PROCEDURE set_elfkind 
	(pv_elfkind VARCHAR2) IS
	BEGIN
		self.elfkind := pv_elfkind;
	END set_elfkind;
-- create a conversion method that converts the object
-- to a string data type
OVERRIDING MEMBER FUNCTION to_string RETURN VARCHAR2 IS
	BEGIN
		RETURN(self AS elf_t).to_string||'[ Elfkind: '||self.elfkind||']';
	END to_string;
END;
/
/**************************************************************************
***************************************************************************
DWARF DWARF DWARF DWARF DWARF DWARF DWARF DWARF DWARF DWARF DWARF DWARF 
***************************************************************************
**************************************************************************/
CREATE OR REPLACE TYPE dwarf_t UNDER base_t
	( genus VARCHAR2(20)
	, CONSTRUCTOR FUNCTION dwarf_t
	( pv_name   VARCHAR2) RETURN SELF AS RESULT
	, MEMBER FUNCTION get_genus RETURN VARCHAR2
	, MEMBER PROCEDURE set_genus (pv_genus VARCHAR2)
	, OVERRIDING MEMBER FUNCTION to_string RETURN VARCHAR2)

 INSTANTIABLE NOT FINAL;
/

-- create the default boddy of base_t
CREATE OR REPLACE TYPE BODY dwarf_t IS

-- A default constructor w/o formal parameters.
CONSTRUCTOR FUNCTION dwarf_t
(pv_name VARCHAR2) RETURN SELF AS RESULT IS
	BEGIN
		self.OID := obj_s1.NEXTVAL;
		self.name := pv_name;
		self.genus := 'DWARF';
	RETURN;
END;

-- create function called get_name that 
MEMBER FUNCTION get_genus RETURN VARCHAR2 IS 
	BEGIN
		RETURN self.genus;
	END get_genus;

-- create a procedure
MEMBER PROCEDURE set_genus
	( pv_genus VARCHAR2) IS 
	BEGIN 
		self.genus := pv_genus;
	END set_genus;

-- create a conversion method that converts the object
-- to a string data type
OVERRIDING MEMBER FUNCTION to_string RETURN VARCHAR2 IS
	BEGIN
		RETURN(self AS base_t).to_string||'[ Genus: '||self.genus||']';
	END to_string;
END;
/
/**************************************************************************
***************************************************************************
GOBLIN GOBLIN GOBLIN GOBLIN GOBLIN GOBLIN GOBLIN GOBLIN GOBLIN GOBLIN 
***************************************************************************
**************************************************************************/
CREATE OR REPLACE TYPE goblin_t UNDER base_t
	( genus VARCHAR2(20)
	, CONSTRUCTOR FUNCTION goblin_t
	( pv_name   VARCHAR2) RETURN SELF AS RESULT
	, MEMBER FUNCTION get_genus RETURN VARCHAR2
	, MEMBER PROCEDURE set_genus (pv_genus VARCHAR2)
	, OVERRIDING MEMBER FUNCTION to_string RETURN VARCHAR2)

 INSTANTIABLE NOT FINAL;
/

-- create the default boddy of base_t
CREATE OR REPLACE TYPE BODY goblin_t IS

-- A default constructor w/o formal parameters.
CONSTRUCTOR FUNCTION goblin_t
(pv_name VARCHAR2) RETURN SELF AS RESULT IS
	BEGIN
		self.OID := obj_s1.NEXTVAL;
		self.name := pv_name;
		self.genus := 'GOBLIN';
	RETURN;
END;

-- create function called get_name that 
MEMBER FUNCTION get_genus RETURN VARCHAR2 IS 
	BEGIN
		RETURN self.genus;
	END get_genus;

-- create a procedure
MEMBER PROCEDURE set_genus
	( pv_genus VARCHAR2) IS 
	BEGIN 
		self.genus := pv_genus;
	END set_genus;

-- create a conversion method that converts the object
-- to a string data type
OVERRIDING MEMBER FUNCTION to_string RETURN VARCHAR2 IS
	BEGIN
		RETURN(self AS base_t).to_string||'[ Genus: '||self.genus||']';
	END to_string;
END;
/
/**************************************************************************
***************************************************************************
MAIA MAIA MAIA MAIA MAIA MAIA MAIA MAIA MAIA MAIA MAIA MAIA MAIA MAIA 
***************************************************************************
**************************************************************************/
CREATE OR REPLACE TYPE maia_t UNDER base_t
	( genus VARCHAR2(20)
	, CONSTRUCTOR FUNCTION maia_t
	( pv_name   VARCHAR2) RETURN SELF AS RESULT
	, MEMBER FUNCTION get_genus RETURN VARCHAR2
	, MEMBER PROCEDURE set_genus (pv_genus VARCHAR2)
	, OVERRIDING MEMBER FUNCTION to_string RETURN VARCHAR2)

 INSTANTIABLE NOT FINAL;
/

-- create the default boddy of base_t
CREATE OR REPLACE TYPE BODY maia_t IS

-- A default constructor w/o formal parameters.
CONSTRUCTOR FUNCTION maia_t
(pv_name VARCHAR2) RETURN SELF AS RESULT IS
	BEGIN
		self.OID := obj_s1.NEXTVAL;
		self.name := pv_name;
		self.genus := 'MAIA';
	RETURN;
END;

-- create function called get_name that 
MEMBER FUNCTION get_genus RETURN VARCHAR2 IS 
	BEGIN
		RETURN self.genus;
	END get_genus;

-- create a procedure
MEMBER PROCEDURE set_genus
	( pv_genus VARCHAR2) IS 
	BEGIN 
		self.genus := pv_genus;
	END set_genus;

-- create a conversion method that converts the object
-- to a string data type
OVERRIDING MEMBER FUNCTION to_string RETURN VARCHAR2 IS
	BEGIN
		RETURN(self AS base_t).to_string||'[ Genus: '||self.genus||']';
	END to_string;
END;
/
/**************************************************************************
***************************************************************************
MAN MAN MAN MAN MAN MAN MAN MAN MAN MAN MAN MAN MAN MAN MAN MAN MAN MAN 
***************************************************************************
**************************************************************************/
CREATE OR REPLACE TYPE man_t UNDER base_t
	( genus VARCHAR2(20)
	, CONSTRUCTOR FUNCTION man_t
	( pv_name   VARCHAR2) RETURN SELF AS RESULT
	, MEMBER FUNCTION get_genus RETURN VARCHAR2
	, MEMBER PROCEDURE set_genus (pv_genus VARCHAR2)
	, OVERRIDING MEMBER FUNCTION to_string RETURN VARCHAR2)

 INSTANTIABLE NOT FINAL;
/

-- create the default boddy of base_t
CREATE OR REPLACE TYPE BODY man_t IS

-- A default constructor w/o formal parameters.
CONSTRUCTOR FUNCTION man_t
(pv_name VARCHAR2) RETURN SELF AS RESULT IS
	BEGIN
		self.OID := obj_s1.NEXTVAL;
		self.name := pv_name;
		self.genus := 'MAN';
	RETURN;
END;

-- create function called get_name that 
MEMBER FUNCTION get_genus RETURN VARCHAR2 IS 
	BEGIN
		RETURN self.genus;
	END get_genus;

-- create a procedure
MEMBER PROCEDURE set_genus
	( pv_genus VARCHAR2) IS 
	BEGIN 
		self.genus := pv_genus;
	END set_genus;

-- create a conversion method that converts the object
-- to a string data type
OVERRIDING MEMBER FUNCTION to_string RETURN VARCHAR2 IS
	BEGIN
		RETURN(self AS base_t).to_string||'[ Genus: '||self.genus||']';
	END to_string;
END;
/
/**************************************************************************
***************************************************************************
ORC ORC ORC ORC ORC ORC ORC ORC ORC ORC ORC ORC ORC ORC ORC ORC ORC ORC  
***************************************************************************
**************************************************************************/
CREATE OR REPLACE TYPE orc_t UNDER base_t
	( genus VARCHAR2(20)
	, CONSTRUCTOR FUNCTION orc_t
	( pv_name   VARCHAR2) RETURN SELF AS RESULT
	, MEMBER FUNCTION get_genus RETURN VARCHAR2
	, MEMBER PROCEDURE set_genus (pv_genus VARCHAR2)
	, OVERRIDING MEMBER FUNCTION to_string RETURN VARCHAR2)

 INSTANTIABLE NOT FINAL;
/

-- create the default boddy of base_t
CREATE OR REPLACE TYPE BODY orc_t IS

-- A default constructor w/o formal parameters.
CONSTRUCTOR FUNCTION orc_t
(pv_name VARCHAR2) RETURN SELF AS RESULT IS
	BEGIN
		self.OID := obj_s1.NEXTVAL;
		self.name := pv_name;
		self.genus := 'ORC';
	RETURN;
END;

-- create function called get_name that 
MEMBER FUNCTION get_genus RETURN VARCHAR2 IS 
	BEGIN
		RETURN self.genus;
	END get_genus;

-- create a procedure
MEMBER PROCEDURE set_genus
	( pv_genus VARCHAR2) IS 
	BEGIN 
		self.genus := pv_genus;
	END set_genus;

-- create a conversion method that converts the object
-- to a string data type
OVERRIDING MEMBER FUNCTION to_string RETURN VARCHAR2 IS
	BEGIN
		RETURN(self AS base_t).to_string||'[ Genus: '||self.genus||']';
	END to_string;
END;
/

/**************************************************************************
***************************************************************************
TEST CASE TEST CASE TEST CASE TEST CASE TEST CASE TEST CASE TEST CASE 
***************************************************************************
**************************************************************************/
-- this creates a table called tolkien that we will populate with 
-- objects/characters

CREATE SEQUENCE tolkien_s1;
CREATE TABLE tolkien
 ( tolkien_id  NUMBER
 , character    base_t);


-- Insert values into the tolkien table for our test case
INSERT INTO tolkien(tolkien_id, character)
	VALUES (tolkien_s1.NEXTVAL, man_t('Aragorn'));
INSERT INTO tolkien(tolkien_id, character)
	VALUES (tolkien_s1.NEXTVAL, orc_t('Azog the Defiler'));
INSERT INTO tolkien(tolkien_id, character)
	VALUES (tolkien_s1.NEXTVAL, hobbit_t('Bilbo'));
INSERT INTO tolkien(tolkien_id, character)
	VALUES (tolkien_s1.NEXTVAL, orc_t('Bolg'));
INSERT INTO tolkien(tolkien_id, character)
	VALUES (tolkien_s1.NEXTVAL, man_t('Boromir'));
INSERT INTO tolkien(tolkien_id, character)
	VALUES (tolkien_s1.NEXTVAL, teleri_t('Celeborn'));
INSERT INTO tolkien(tolkien_id, character)
	VALUES (tolkien_s1.NEXTVAL, teleri_t('Earwen'));
INSERT INTO tolkien(tolkien_id, character)
	VALUES (tolkien_s1.NEXTVAL, man_t('Faramir'));
INSERT INTO tolkien(tolkien_id, character)
	VALUES (tolkien_s1.NEXTVAL, noldor_t('Feanor'));
INSERT INTO tolkien(tolkien_id, character)
	VALUES (tolkien_s1.NEXTVAL, hobbit_t('Frodo'));
INSERT INTO tolkien(tolkien_id, character)
	VALUES (tolkien_s1.NEXTVAL, maia_t('Gandalf the Gray'));
INSERT INTO tolkien(tolkien_id, character)
	VALUES (tolkien_s1.NEXTVAL, dwarf_t('Gimli'));
INSERT INTO tolkien(tolkien_id, character)
	VALUES (tolkien_s1.NEXTVAL, goblin_t('Great Goblin'));
INSERT INTO tolkien(tolkien_id, character)
	VALUES (tolkien_s1.NEXTVAL, sindar_t('Legolas'));
INSERT INTO tolkien(tolkien_id, character)
	VALUES (tolkien_s1.NEXTVAL, hobbit_t('Merry'));
INSERT INTO tolkien(tolkien_id, character)
	VALUES (tolkien_s1.NEXTVAL, hobbit_t('Peppin'));
INSERT INTO tolkien(tolkien_id, character)
	VALUES (tolkien_s1.NEXTVAL, maia_t('Radagast the Brown'));
INSERT INTO tolkien(tolkien_id, character)
	VALUES (tolkien_s1.NEXTVAL, hobbit_t('Same the wise'));
INSERT INTO tolkien(tolkien_id, character)
	VALUES (tolkien_s1.NEXTVAL, maia_t('Saruman the White'));
INSERT INTO tolkien(tolkien_id, character)
	VALUES (tolkien_s1.NEXTVAL, silvan_t('Tauriel'));
INSERT INTO tolkien(tolkien_id, character)
	VALUES (tolkien_s1.NEXTVAL, sindar_t('Thranduil'));


SET PAGESIZE 999
COLUMN objectid FORMAT 9999 HEADING "Object ID"
COLUMN name FORMAT A20 HEADING "Name"
COLUMN description FORMAT A40 HEADING "Description"
SELECT t.tolkien_id AS objectid
, TREAT(t.character AS base_t).get_name() AS name
, TREAT(t.character AS base_t).to_string() AS description
FROM tolkien t
ORDER BY TREAT(t.character AS base_t).get_name();

