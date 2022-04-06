/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*----------------------------------------------------------------------------

File: _chkfld.p

Description:

Input Parameters:
   p_u_recid -- Recid id of U record
   p_table  -- The table name. 
   p_field  -- The field name.
   p_options -- Method of validation.  "DB" Check for existence in database 
     (DICTDB will be defined).  "Local" Validate local name. 

Output Parameters:
   p_ok -- indicates that the table was found in the database. 

Author:  Nancy E.Horn 

Notes:  database name is not needed since "DICTDB" is defined to be the 
     database.  

Date Created: Feb. 1997
---------------------------------------------------------------------------- */
/* Include Definitions */
{ workshop/objects.i }
{ workshop/sharvars.i }
{ workshop/uniwidg.i }

DEFINE INPUT  PARAMETER p_u_recid AS RECID     NO-UNDO.
DEFINE INPUT  PARAMETER p_table   AS CHARACTER NO-UNDO.
DEFINE INPUT  PARAMETER p_field   AS CHARACTER NO-UNDO.
DEFINE INPUT  PARAMETER p_options AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER p_OK      AS LOGICAL NO-UNDO.

/* Include Definitions */
{ workshop/dbname.i &DB = "DICTDB"}

/* ------------------- Internal Procedures -------------------- */

/* ------------------- Main Code Block  -------------------- */

 p_OK = no. 

 /* Get the _U record */
  FIND FIRST _U WHERE RECID(_U) eq p_u_recid NO-ERROR.
  IF NOT AVAILABLE(_U) THEN 
    RETURN.

  CASE p_options:
     WHEN "DB" THEN DO:
       FIND FIRST DICTDB._file WHERE DICTDB._file._file-name eq p_table NO-ERROR.
       IF AVAILABLE (_file) THEN DO:
          FIND FIRST DICTDB._field of DICTDB._file WHERE DICTDB._field._field-name eq p_field NO-ERROR.
          IF AVAILABLE(DICTDB._field) THEN DO:
	     ASSIGN _U._DBNAME     = get-dbname(DICTDB._file._db-recid) 
		    _U._TABLE      = DICTDB._file._file-name 
		    _U._NAME       = DICTDB._field._field-name
		    _U._DEFINED-BY = "DB"
		    _U._HELP       = DICTDB._field._help.
	     FIND FIRST _F WHERE RECID(_F) = _U._x-recid NO-ERROR.
	     IF AVAILABLE (_F) THEN 
	       ASSIGN _F._DATA-TYPE  = CAPS(DICTDB._field._data-type)
	  	      _F._FORMAT     = DICTDB._field._format
		      _F._FORMAT-ATTR = DICTDB._field._format-SA
		      _F._FORMAT-SOURCE = "D"
		      _F._INITIAL-DATA  = DICTDB._field._initial.
	     ASSIGN p_OK = yes.
	  END.
          ELSE
	     p_OK = no.
       END.	 
       ELSE p_OK = no.
     END.
     /* For "Tool" (Local) clear out record */     
     WHEN "Tool" THEN DO:
	ASSIGN _U._DBNAME = ?
	       _U._TABLE  = (if p_table ne "" then TRIM(p_table) else ?)
	       _U._NAME   =  TRIM(p_field)
	       _U._DEFINED-BY = "Tool" 
	       _U._HELP       = ?.
        FIND FIRST _F WHERE RECID(_F) = _U._x-recid NO-ERROR.
        IF AVAILABLE (_F) THEN DO:
	   IF p_options ne "User" THEN 
             IF _U._TYPE eq "TOGGLE-BOX" THEN 
	       ASSIGN _F._DATA-TYPE = ("LOGICAL")
		      _F._INITIAL-DATA = ?.
             ELSE
	       ASSIGN _F._DATA-TYPE = ("CHARACTER")
		      _F._FORMAT    = "x(256)".
           ELSE
	     ASSIGN _F._DATA-TYPE = ""
		    _F._FORMAT = "".
       
           ASSIGN 
	      _F._FORMAT-ATTR = "" 
	      _F._FORMAT-SOURCE = "" 
	      _F._INITIAL-DATA  = "".
           p_OK = yes.
        END.
     END.
     /* For "User" leave what's already there, just update name, defined-by */
     WHEN "User" THEN
	ASSIGN _U._DBNAME = ?
	       _U._TABLE  = (if p_table ne "" then TRIM(p_table) else ?)
	       _U._NAME   =  TRIM(p_field)
	       _U._DEFINED-BY = "User". 
  END CASE.

 RETURN.

/* 
 * ---- End of file ----- 
 */
