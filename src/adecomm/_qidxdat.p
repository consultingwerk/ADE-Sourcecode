/*********************************************************************
* Copyright (C) 2000-2021 by Progress Software Corporation. All rights *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*----------------------------------------------------------------------------

File: _qidxdat.p

Description:
   Display _Index information for the quick index report.  It will go to 
   the currently set output device (e.g., a file, the printer).
 
Input Parameters:
   p_DbId - Id of the _Db record for this database.
   p_Tbl  - The name of the table whose indexes we're showing or "ALL".

Author: Tony Lavinio, Laura Stern

Date Created: 10/05/92

Modified on 05/31/95 gfs Allow display of hidden tables (not meta-schema).
            06/14/94 gfs Added NO-LOCKs to file accesses.
            01/07/98 DLM Added display of current storage area for PROGRESS
                         databases or N/A for foreign databases.
            04/17/98 DLM Added check for _field-recid > 0 for default index.
            07/23/98 DLM Added DBVERSION and _Owner check
            01/18/00 DLM Added NO-LOCK where missed.
            03/12/21 tmasood  Show correct status of index
----------------------------------------------------------------------------*/
{ prodict/fhidden.i }

DEFINE INPUT PARAMETER p_DbId AS RECID NO-UNDO.
DEFINE INPUT PARAMETER p_Tbl  AS CHAR  NO-UNDO.

DEFINE SHARED STREAM rpt.
DEFINE VARIABLE flags      AS CHARACTER   NO-UNDO.
DEFINE VARIABLE starea     AS CHARACTER   NO-UNDO.

FORM
   _File._File-name  LABEL "Table"
   SKIP
   WITH FRAME tblhdr NO-ATTR-SPACE USE-TEXT SIDE-LABELS STREAM-IO.

FORM
  flags                   FORMAT "x(5)"  COLUMN-LABEL "Flags"
  _Index._Index-name      FORMAT "x(23)" COLUMN-LABEL "Index Name"
  starea                  FORMAT "x(4)" COLUMN-LABEL "St Area"
  _Index._Num-comp        FORMAT ">>9"   COLUMN-LABEL "Cnt"
  _Index-field._Ascending FORMAT "+/- " COLUMN-LABEL "Fi" SPACE(0)
  _Field._Field-name      FORMAT "x(20)" COLUMN-LABEL "eld Name" 
  WITH FRAME shoindex 
  DOWN USE-TEXT STREAM-IO.

FORM
  SKIP(1) 
  SPACE(3) _File._File-name LABEL "Working on" FORMAT "x(32)" SPACE
  SKIP(1)
  WITH FRAME working_on SIDE-LABELS VIEW-AS DIALOG-BOX 
  TITLE "Generating Report".


/*----------------------------Mainline code--------------------------------*/

IF p_Tbl = "ALL" THEN
   SESSION:IMMEDIATE-DISPLAY = yes.

FIND _DB WHERE RECID(_Db) = p_dbId NO-LOCK.

FOR EACH _File NO-LOCK WHERE _File._Db-recid = p_DbId AND
                            (IF p_Tbl = "ALL" THEN (IF NOT fHidden THEN NOT _File._Hidden ELSE _File._File-Number > 0)
                                 ELSE _File._File-name = p_Tbl)
                     BY _File._File-name:
   
   IF INTEGER(DBVERSION("DICTDB")) > 8 
      AND (_File._Owner <> "PUB" AND _File._Owner <> "_FOREIGN") THEN NEXT.

   PAGE STREAM rpt.

   IF p_Tbl = "ALL" THEN
      DISPLAY _File._File-name WITH FRAME working_on.

   DISPLAY STREAM rpt _File._File-name WITH FRAME tblhdr.

   FOR EACH _Index OF _File NO-LOCK BREAK BY _Index._Index-name:
      FIND LAST _Index-field OF _Index NO-LOCK NO-ERROR.
      FIND FIRST _StorageObject WHERE _StorageObject._DB-recid = _File._DB-recid
                                  AND _StorageObject._Object-type = 2
                                  AND _StorageObject._Object-number = _Index._Idx-num
                                  AND _StorageObject._partitionid = 0
                                  NO-LOCK NO-ERROR.
      flags = 
               ( (IF NOT _File._File-Attributes[3]
               THEN "" ELSE IF _Index._index-attributes[1] AND _File._File-Attributes[3] THEN "l" ELSE "g")
              + (IF _File._Prime-index = RECID(_Index) 
               THEN "p" ELSE "")
           + (IF _Unique   
               THEN "u" ELSE "")
           + (IF NOT _Active OR (AVAILABLE _StorageObject AND (get-bits(_StorageObject._Object-State,1,1) = 1))
               THEN "i" ELSE "") 
           + (IF _Index._Wordidx = 1
               THEN "w" ELSE "") 
                 + (IF AVAILABLE _Index-field AND _Index-field._Abbreviate
                     THEN "a" ELSE "") ).
                     
      IF _Db._Db-type = "PROGRESS" THEN DO:    
         /* note: this check may not be needed, but just in case reports need to work against old versions  */
         if INTEGER(DBVERSION("DICTDB")) > 10 then
         do:
             FIND _StorageObject WHERE _StorageObject._DB-recid      = _File._DB-recid  
                                   and _StorageObject._Object-Number = _Index._Idx-num 
                                   AND _StorageObject._Object-type   = 2 
                                   AND _StorageObject._Partitionid   = 0
                                   NO-LOCK NO-ERROR.
             
             
         end.
         else do:
             FIND _StorageObject WHERE _StorageObject._DB-recid      = _File._DB-recid  
                                   and _StorageObject._Object-Number = _Index._Idx-num 
                                   AND _StorageObject._Object-type   = 2 
                                   NO-LOCK NO-ERROR.  
         end.    
         
         IF AVAILABLE _StorageObject THEN
           ASSIGN starea = STRING(_StorageObject._Area-number).
         ELSE
           ASSIGN starea = STRING(_Index._ianum).       
      END.     
      ELSE
          ASSIGN starea = "N/A".
      

      DISPLAY STREAM rpt
                starea
                flags
                _Index._Index-name
                _Index._Num-comp                
                WITH FRAME shoindex.

      /* The default index has no fields! so this loop must be separate
               from the FOR EACH _Index loop or we'll get no output.
      */
      FOR EACH _Index-field OF _Index NO-LOCK:
        IF _Index-field._Field-recid > 0 THEN DO:
          FIND _Field where RECID(_Field) = _Index-field._Field-recid NO-LOCK.
              
           DISPLAY STREAM rpt
              _Index-field._Ascending
              _Field._Field-name
              WITH FRAME shoindex.
          DOWN STREAM rpt WITH FRAME shoindex.
        END.
        ELSE 
          DISPLAY STREAM rpt
            _Index-field._Ascending
            "" @ _Field._Field-name
          with frame shoindex.
      END.
      
     /* Put an extra line in between each index. */
     IF LAST-OF(_Index._Index-name) THEN 
        DOWN STREAM rpt 1 WITH FRAME shoindex.
   END.
END.

IF p_Tbl = "ALL" THEN
DO:
   HIDE FRAME working_on NO-PAUSE.
   SESSION:IMMEDIATE-DISPLAY = no.
END.
