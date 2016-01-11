/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation ("PSC"),       *
* 14 Oak Park, Bedford, MA 01730, and other contributors as listed   *
* below.  All Rights Reserved.                                       *
*                                                                    *
* The Initial Developer of the Original Code is PSC.  The Original   *
* Code is Progress IDE code released to open source December 1, 2000.*
*                                                                    *
* The contents of this file are subject to the Possenet Public       *
* License Version 1.0 (the "License"); you may not use this file     *
* except in compliance with the License.  A copy of the License is   *
* available as of the date of this notice at                         *
* http://www.possenet.org/license.html                               *
*                                                                    *
* Software distributed under the License is distributed on an "AS IS"*
* basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. You*
* should refer to the License for the specific language governing    *
* rights and limitations under the License.                          *
*                                                                    *
* Contributors:                                                      *
*                                                                    *
*********************************************************************/

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

----------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER p_DbId AS RECID NO-UNDO.

DEFINE SHARED STREAM rpt.

DEFINE VARIABLE flags   AS CHARACTER               NO-UNDO.
DEFINE VARIABLE fldcnt  AS INTEGER                 NO-UNDO INITIAL -1.
DEFINE VARIABLE odbtyp  AS CHARACTER               NO-UNDO. /* list of ODBC-types */
DEFINE VARIABLE starea  AS CHARACTER FORMAT "x(4)" NO-UNDO.

FORM
   _File._File-name  FORMAT "x(29)"  COLUMN-LABEL "Table!Name" 
   starea                            COLUMN-LABEL "St!Area"   
   _File._Dump-name  FORMAT "x(8)"   COLUMN-LABEL "Dump!Name"
   flags             FORMAT "x(5)"   COLUMN-LABEL "Table!Flags" 
   fldcnt            FORMAT ">>>>9"  COLUMN-LABEL "Field!Count"
   _File._numkey     FORMAT ">>>>9"  COLUMN-LABEL "Index!Count"
   _File._File-label FORMAT "x(15)"  COLUMN-LABEL "Table!Label" 
   WITH FRAME shotable USE-TEXT STREAM-IO DOWN.

ASSIGN
  odbtyp      = {adecomm/ds_type.i
                  &direction = "ODBC"
                  &from-type = "flags"
                  }.
                  
FIND _Db WHERE RECID(_Db) = p_DbId NO-LOCK.
FOR EACH _File WHERE _File._Db-recid = p_DbId AND NOT _File._Hidden:
   IF INTEGER(DBVERSION("DICTDB")) > 8 AND
      (_File._Owner <> "PUB" AND _File._Owner <> "_FOREIGN") THEN NEXT.
   ASSIGN
      flags = (IF _File._Db-lang > 0 THEN "s" ELSE "")
      flags = (flags + IF _File._Frozen THEN "f" ELSE "").
    
   IF _Db._Db-type = "PROGRESS" AND INTEGER(DBVERSION("DICTDB")) > 8 THEN DO:  
     FIND FIRST _StorageObject WHERE _StorageObject._Object-Number = _File._File-number 
                                 AND _StorageObject._Object-type = 1 NO-LOCK NO-ERROR.
     IF AVAILABLE _StorageObject THEN
        ASSIGN starea = STRING(_StorageObject._Area-number). 
     ELSE 
        ASSIGN starea = STRING(_File._ianum).
   END.
   ELSE
      ASSIGN starea = "N/A".
 
   DISPLAY STREAM rpt
      _File._File-name
      starea
      _File._File-label
      flags
      /* Progress Db's have an extra hidden field that holds the table # 
      	 which gateway Db's don't have.
      */
      (IF _Db._Db-type = "PROGRESS"
       OR _Db._Db-type = "AS400" 
       OR CAN-DO(odbtyp,_Db._Db-type)
				    THEN _File._numfld - 1
      	       	     	      	    ELSE _File._numfld) @ fldcnt
      _File._numkey
      _File._Dump-name
      WITH FRAME shotable.
   DOWN STREAM rpt WITH FRAME shotable.
END.









