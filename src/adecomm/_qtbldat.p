/**********************************************************************
* Copyright (C) 2000,2006 by Progress Software Corporation. All rights*
* reserved.  Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                            *
*                                                                     *
**********************************************************************/

/*----------------------------------------------------------------------------

File: _qtbldat.p

Description:
   Display _File information for the quick table report.  It will go to 
   the currently set output device (e.g., a file, the printer).
 
Input Parameters:
   p_DbId    - Id of the _Db record for this database.

Author: Tony Lavinio, Laura Stern

Date Created: 10/02/92
    
    Modified: 01/07/98 DLM Added display of current storage area.
              07/10/98 DLM Added DBVERSION and _Owner check.
              10/17/03 DLM Added NO-LOCK to _Db find.
              06/15/06 fernando   Adding support for long dump names    

----------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER p_DbId AS RECID NO-UNDO.

DEFINE SHARED STREAM rpt.

DEFINE VARIABLE flags   AS CHARACTER               NO-UNDO.
DEFINE VARIABLE fldcnt  AS INTEGER                 NO-UNDO INITIAL -1.
DEFINE VARIABLE odbtyp  AS CHARACTER               NO-UNDO. /* list of ODBC-types */
DEFINE VARIABLE starea  AS CHARACTER FORMAT "x(4)" NO-UNDO.

FORM
   dictdb._File._File-name  FORMAT "x(29)"  COLUMN-LABEL "Table!Name" 
   starea                            COLUMN-LABEL "St!Area"   
   dictdb._File._Dump-name  FORMAT "x(13)"   COLUMN-LABEL "Dump!Name"
   flags             FORMAT "x(3)"   COLUMN-LABEL "Tbl!Flg" 
   fldcnt            FORMAT ">>>>9"  COLUMN-LABEL "Field!Count"
   dictdb._File._numkey     FORMAT ">>>>9"  COLUMN-LABEL "Index!Count"
   dictdb._File._File-label FORMAT "x(11)"  COLUMN-LABEL "Table!Label" 
   WITH FRAME shotable USE-TEXT STREAM-IO DOWN.

ASSIGN
  odbtyp      = {adecomm/ds_type.i
                  &direction = "ODBC"
                  &from-type = "flags"
                  }.
                  
FIND dictdb._Db WHERE RECID(dictdb._Db) = p_DbId NO-LOCK.
FOR EACH dictdb._File WHERE dictdb._File._Db-recid = p_DbId AND NOT dictdb._File._Hidden:
   IF INTEGER(DBVERSION("DICTDB")) > 8 AND
      (dictdb._File._Owner <> "PUB" AND dictdb._File._Owner <> "_FOREIGN") THEN NEXT.
   
   IF INTEGER(DBVERSION("DICTDB")) > 10 THEN
      flags = (IF dictdb._File._File-Attributes[1] THEN "m" ELSE "").  
   ASSIGN
      flags = (flags + IF dictdb._File._Db-lang > 0 THEN "s" ELSE "")
      flags = (flags + IF dictdb._File._Frozen THEN "f" ELSE "").
    
   IF dictdb._Db._Db-type = "PROGRESS" AND INTEGER(DBVERSION("DICTDB")) > 8 THEN 
   DO:  
     
     /* note: this check may not be needed, but just in case reports need to work against old versions  */
     if INTEGER(DBVERSION("DICTDB")) > 10 then
     do:
         FIND dictdb._StorageObject WHERE dictdb._StorageObject._DB-recid    = dictdb._File._DB-recid  
                                    and dictdb._StorageObject._Object-Number = dictdb._File._File-number 
                                    AND dictdb._StorageObject._Object-type   = 1 
                                    AND dictdb._StorageObject._Partitionid   = 0
                                    NO-LOCK NO-ERROR.
     end.
     else do:
         FIND dictdb._StorageObject WHERE dictdb._StorageObject._DB-recid    = dictdb._File._DB-recid  
                                    and dictdb._StorageObject._Object-Number = dictdb._File._File-number 
                                    AND dictdb._StorageObject._Object-type   = 1 
                                    NO-LOCK NO-ERROR.  
     end.
     IF AVAILABLE dictdb._StorageObject THEN
        ASSIGN starea = STRING(dictdb._StorageObject._Area-number). 
     ELSE 
        ASSIGN starea = STRING(dictdb._File._ianum).
   END.
   ELSE
      ASSIGN starea = "N/A".
 
   DISPLAY STREAM rpt
      dictdb._File._File-name
      starea
      dictdb._File._File-label
      flags
      /* Progress Db's have an extra hidden field that holds the table # 
      	 which gateway Db's don't have.
      */
      (IF dictdb._Db._Db-type = "PROGRESS"
       OR dictdb._Db._Db-type = "AS400" 
       OR CAN-DO(odbtyp,dictdb._Db._Db-type)
				    THEN dictdb._File._numfld - 1
      	       	    ELSE dictdb._File._numfld) @ fldcnt
      dictdb._File._numkey
      dictdb._File._Dump-name
      WITH FRAME shotable.
   DOWN STREAM rpt WITH FRAME shotable.
END.









