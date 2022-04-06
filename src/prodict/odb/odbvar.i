/*********************************************************************
* Copyright (C) 2005-2006, 2009 by Progress Software Corporation. All*
* rights reserved.  Prior versions of this work may contain portions *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*
    History:  D. McMann   03/03/99 Removed On-line from Informix
              D. McMann   02/01/00 Added sqlwidth variable
              D. McMann   10/08/02 Added shadowcol variable
              D. McMann   06/17/03 Removed unsupported data sources
              D. McMann   10/16/03 Created two OTHER catigories and removed MS Access
              K. McIntosh 04/13/04 Added support for ODBC type DB2/400
              fernando    08/14/06 Removed Informix from list of valid foreign db types
	      rkumar      01/07/09 Added default values for ODBC DataServer- OE00177724
              rkumar      05/05/09 Added RECID support  for ODBC DataServer- OE00177721
*/    

DEFINE {1} SHARED VARIABLE pro_dbname   AS CHARACTER NO-UNDO.
DEFINE {1} SHARED VARIABLE pro_conparms AS CHARACTER NO-UNDO.
DEFINE {1} SHARED VARIABLE osh_dbname   AS CHARACTER NO-UNDO.
DEFINE {1} SHARED VARIABLE odb_dbname   AS CHARACTER NO-UNDO.
DEFINE {1} SHARED VARIABLE odb_pdbname  AS CHARACTER NO-UNDO.
DEFINE {1} SHARED VARIABLE odb_username AS CHARACTER NO-UNDO.
DEFINE {1} SHARED VARIABLE odb_password AS CHARACTER NO-UNDO.
DEFINE {1} SHARED VARIABLE odb_codepage AS CHARACTER NO-UNDO.
DEFINE {1} SHARED VARIABLE odb_collname AS CHARACTER NO-UNDO.
DEFINE {1} SHARED VARIABLE odb_library  AS CHARACTER NO-UNDO.
DEFINE {1} SHARED VARIABLE odb_conparms AS CHARACTER NO-UNDO.
DEFINE {1} SHARED VARIABLE odb_type     AS CHARACTER FORMAT "x(16)"
  INITIAL "Sybase" VIEW-AS COMBO-BOX  
     LIST-ITEMS  "Sybase", "DB2/400", "DB2(Other)", "Other(MS Access)",  "Other(Generic)"  
         SIZE-CHAR 32 By 1.

DEFINE {1} SHARED VARIABLE movedata     AS LOGICAL NO-UNDO.
DEFINE {1} SHARED VARIABLE pcompatible  AS LOGICAL NO-UNDO.
DEFINE {1} SHARED VARIABLE shadowcol    AS LOGICAL NO-UNDO.
DEFINE {1} SHARED VARIABLE odbdef       AS LOGICAL NO-UNDO. 
DEFINE {1} SHARED VARIABLE sqlwidth     AS LOGICAL NO-UNDO.
DEFINE {1} SHARED VARIABLE loadsql      AS LOGICAL NO-UNDO.
DEFINE {1} SHARED VARIABLE rmvobj       AS LOGICAL NO-UNDO.
DEFINE {1} SHARED VARIABLE iFmtOption   AS INTEGER NO-UNDO INITIAL 2.
DEFINE {1} SHARED VARIABLE lFormat      AS LOGICAL NO-UNDO INITIAL TRUE.
DEFINE {1} SHARED VARIABLE iRidOption   AS INTEGER NO-UNDO INITIAL 2. /* OE00177721*/

DEFINE {1} SHARED STREAM dbg_stream.

DEFINE {1} SHARED VARIABLE stages 		AS LOGICAL EXTENT 7 NO-UNDO.
DEFINE {1} SHARED VARIABLE stages_complete 	AS LOGICAL EXTENT 7 NO-UNDO.

/*
 * Constants describing stage we are at.
 */ 
define {1} shared variable odb_create_sql	as integer   initial 1.
define {1} shared variable odb_dump_data   	as integer   initial 2.
define {1} shared variable odb_create_sh 	as integer   initial 3. 
define {1} shared variable odb_create_objects	as integer   initial 4.
define {1} shared variable odb_build_schema	as integer   initial 5.
define {1} shared variable odb_fixup_schema	as integer   initial 6.
define {1} shared variable odb_load_data	as integer   initial 7. 
define {1} shared variable s_file-sel           as character initial "*". 



