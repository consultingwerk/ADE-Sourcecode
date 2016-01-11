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

File: _rdqury.p

Description:
    Read a _QUERY-BLOCK of source code to fill-in the special _Q fields
    of a query
         
    
Input Parameters:
    p_proc-id  - Procedure Context ID for the relevent _P record.
    p_qry-name - Name of the query.
    p_orig-ver - the original version number of the input file.
    p_options  - A comma-delimited list of options [currently unused]

Output Parameters:
   <None>

Author: Wm.T.Wood [from old adeuib/_rdqury.p]

Date Created:  1992
Date Modified: 
  2/20/97  wood  Created as new Workshop file from original _rdqury.p

---------------------------------------------------------------------------- */
DEFINE INPUT  PARAMETER p_proc-id    AS INTEGER NO-UNDO .                     
DEFINE INPUT  PARAMETER p_qry-name   AS CHAR    NO-UNDO .
DEFINE INPUT  PARAMETER p_orig-ver   AS CHAR    NO-UNDO .
DEFINE INPUT  PARAMETER p_options    AS CHAR    NO-UNDO .

/* Shared Include File definitions */
{ workshop/code.i }        /* Code section TEMP-TABLE definition             */
{ workshop/objects.i }     /* Object TEMP-TABLE definition                   */
{ workshop/sharvars.i }    /* Shared variables                               */
{ workshop/uniwidg.i }     /* Universal Widget TEMP-TABLE definition         */

/* Standard End-of-line character */
&Scoped-define EOL &IF "{&OPSYS}" <> "unix" &THEN "~r" + &ENDIF CHR(10)
/* Use this to turn debugging on after each line that is read in.
   (i.e. rename no-DEBUG  to DEBUG) */
&Scoped-define no-debug yes

DEFINE SHARED  STREAM    _P_QS.
DEFINE SHARED  VARIABLE  _inp_line     AS  CHAR      EXTENT 100           NO-UNDO.
DEFINE         VARIABLE  element       AS  CHAR                           NO-UNDO.
DEFINE         VARIABLE  i             AS  INTEGER                        NO-UNDO.
DEFINE         VARIABLE  j             AS  INTEGER                        NO-UNDO.
DEFINE         VARIABLE  lProcessAgain AS  LOGICAL                        NO-UNDO.
DEFINE         VARIABLE  fr-name       AS  CHAR                           NO-UNDO.
DEFINE         VARIABLE  db-switch     AS  CHARACTER                      NO-UNDO.
DEFINE         VARIABLE  query-phrase  AS  CHARACTER                      NO-UNDO.
DEFINE         VARIABLE  tmp-db-name   AS  CHARACTER                      NO-UNDO.
DEFINE         VARIABLE  tmp-switch    AS  CHARACTER                      NO-UNDO.
DEFINE         VARIABLE  valid-dbs     AS  CHARACTER                      NO-UNDO.

/* Show the current line */
&IF "{&debug}" ne "" &THEN    
  { src/web/method/cgidefs.i }
  &Scoped-define debug {&OUT} _inp_line[1] _inp_line[2] _inp_line[3] _inp_line[4] _inp_line[5] "<br>".
  {&OUT} "Enter _rdqury.p <br>".
  {&debug}
&ENDIF       

/* Build a list of db's to be used to determine if the a db is valid.  This
   will help customers that build a .w with 1 database but load it into the
   UIB with another db                                                      */
DO i = 1 TO NUM-DBS:
  IF NOT CAN-DO(ldbname(i),valid-dbs) THEN
    valid-dbs = valid-dbs + (IF i = 1 THEN "" ELSE ",":U) + ldbname(i).
  IF NOT CAN-DO(pdbname(i),valid-dbs) THEN
    valid-dbs = valid-dbs + ",":U + pdbname(i).
END.

/* Find the current _P record. */
FIND _P WHERE RECID(_P) eq p_proc-id.

/* QUERY objects are defined here, so we need to create the Universal widget
   records for them. */

/* Create a Universal Widget Record and populate it as much as possible. */
CREATE _U.
CREATE _Q.
  
ASSIGN /* TYPE-specific settings and relationships */ 
    _U._TYPE    = "QUERY":U
    _U._P-recid = p_proc-id
    _U._x-recid = RECID(_Q)
    .
/* Make sure the new name is unique. */
VALIDATE _U.
RUN workshop/_bstname.p (p_qry-name, ?, p_proc-id, OUTPUT _U._NAME).

lProcessAgain = NO.
Process-Query-Block:
REPEAT:
  /* Read in the next line (unless we need to process the current line again. */
  IF lProcessAgain eq NO THEN DO: 
    _inp_line = "".
    IMPORT STREAM _P_QS _inp_line. {&debug}
  END.
  ELSE lProcessAgain = NO.
  
  CASE _inp_line[1]:

    /* Expected Exit */
    
    WHEN "*/" THEN DO:  /* Is this the end-of-query line? */
      &IF "{&debug}" ne "" &THEN
      MESSAGE _inp_line[2] SKIP 
              _inp_line[3] _inp_line[3] eq _U._TYPE SKIP
              _inp_line[5].
      &ENDIF       
      IF _inp_line[2] eq "/*" AND _inp_line[3] eq _U._TYPE AND _inp_line[5] eq "*/"
      THEN LEAVE Process-Query-Block.
    END.
    
    /* Emergency exit */
    WHEN "_UIB-CODE-BLOCK" THEN LEAVE Process-Query-Block.
    
    WHEN "_START_FREEFORM":U THEN DO:      
      RUN create-freeform (BUFFER _code).
      FIND _code-text WHERE RECID(_code-text) eq _code._text-id.
      Read-Code:
      REPEAT ON END-KEY UNDO Read-Code, RETRY Read-Code:
        IF RETRY THEN _code-text._text = _code-text._text + "." + {&EOL}.
        IMPORT STREAM _P_QS UNFORMATTED _inp_line[1].
        IF TRIM(_inp_line[1]) = "_END_FREEFORM":U THEN LEAVE Read-Code.
        ELSE _code-text._text = _code-text._text + _inp_line[1] + {&EOL}.
      END. /* Read-Code */
    END.
    
    WHEN "_TblList" THEN DO:
      _Q._TblList    = _inp_line[3].
      /* The remainder of this when is new code to allow users to switch databases
         with similar schemas                                                      */
      DO i = 1 TO NUM-ENTRIES(_Q._TblList):
        query-phrase = ENTRY(i,_Q._TblList).
        DO j = 1 TO NUM-ENTRIES(query-phrase," ":U):
          tmp-db-name = ENTRY(j,query-phrase," ":U).
          IF NUM-ENTRIES(tmp-db-name,".") = 2 THEN DO:
            IF LOOKUP(ENTRY(1,tmp-db-name,".":U),valid-dbs) = 0 THEN DO:
              /* What we have here is an invalid db name, scan valid-dbs to
                 find the first one that has this table in it. This code used
                 to be inline, but had to be broken out to keep from having
                 a data-base connected for _rdqury.p to be run.  This is in
                 response to bug 97-03-18-053.                              */
              IF valid-dbs NE "" THEN
                RUN workshop/_find-db.p (INPUT tmp-db-name,
                                         INPUT valid-dbs,
                                         INPUT-OUTPUT db-switch).
            END. /* An invalid db name */
          END. /* A DB.TABLE combination */
        END.  /* Do j = 1 to num tokens of the ith phrase */
      END.  /* For each comma delimitted phrase */
      /* db-switch is now a list of pairs of db-names to be switched */
      IF db-switch ne "" THEN DO i = 1 TO NUM-ENTRIES(db-switch):
        _Q._TblList = REPLACE(_Q._TblList, ENTRY(1,ENTRY(i,db-switch),CHR(4)) + ".":U,
                                           ENTRY(2,ENTRY(i,db-switch),CHR(4)) + ".":U).
      END.
    END.  /* WHEN _TblList */

    WHEN "_Options" THEN _Q._OptionList = _inp_line[3].   
    WHEN "_FldList" THEN _Q._FldList    = _inp_line[3].
    WHEN "_OrdList" THEN _Q._OrdList    = _inp_line[3].
    
    WHEN "_Query"   THEN  DO:          
      /* Is this line "_Query is [NOT] OPENED */ 
      IF _inp_line[2] eq "is":U 
      THEN  _Q._OpenQury = (_inp_line[3] eq "OPENED":U).
    END.
    

    WHEN "_TuneOptions" THEN  _Q._TuneOptions =
         REPLACE(_inp_line[3], CHR(10) + FILL(" ", 26), CHR(10)).
    
    WHEN "_TblOptList" THEN _Q._TblOptList = TRIM(_inp_line[3]).

   /* * * * * * * * * * * * * * * * *  OLD CASES * * * * * ** * * * * * * * * */
    WHEN "_Design-Parent" THEN DO:
       /* In v1r1 -- Queries parented to frames. */
    END.
   
   /* * * * * * * * * * * * * * END OF OLD CASES * * * * * * * * * * * * * * */
    
   OTHERWISE DO:
     /* Is this part of the Arrays?  If so then read all the array information. */
     IF (_inp_line[1] BEGINS "_JoinTo") OR (_inp_line[1] BEGINS "_JoinCode") OR
        (_inp_line[1] BEGINS "_Where" ) OR (_inp_line[1] BEGINS "_Fld")
     THEN DO: 
        /* Reprocess the line (i.e. don't read a new line). */
        lProcessAgain = YES.
        Read-Arrays:
        REPEAT:
          /* Read next line, if necessary */
          IF NOT lProcessAgain THEN DO:
            _inp_line = "".               /* Reinitialize because WHERE clause  */
                                          /* may need more than 3 elements      */
                                          /* depending upon quoted strings      */
            IMPORT STREAM _P_QS _inp_line. {&debug}
          END.
          ELSE lProcessAgain = NO.
            
          /* Is this the end of the READ-ARRAY block line? If so, set the flag
             so the line will be reprocessed again. */
          IF CAN-DO("_Query,_Design-Parent", _inp_line[1]) THEN DO:
            lProcessAgain = YES. 
            /* This is the end of the query input */
            LEAVE Read-Arrays.
          END.     
          ELSE IF _inp_line[1] eq  "*/" THEN DO:  /* Is this the end-of-query line? */
            lProcessAgain = YES .  
            IF _inp_line[2] = "/*" AND _inp_line[3] = _U._TYPE AND _inp_line[4] = _U._NAME
            THEN LEAVE Read-Arrays.
          END.
          ELSE IF _inp_line[3] <> ? THEN DO:  /* A non ? Value - process it   */
            IF _inp_line[1] BEGINS "_JoinTo" THEN
              /* Do Nothing - this is here only to support UIB_v7r9 files */
              .
            ELSE IF _inp_line[1] BEGINS "_JoinCode" THEN DO:
              ASSIGN element = SUBSTRING(_inp_line[1],11)
                     element = SUBSTRING(element,1,LENGTH(element) - 1)
                     _Q._JoinCode[INTEGER(element)] = _inp_line[3].   
            END.
            ELSE IF _inp_line[1] BEGINS "_Where" THEN DO:
              ASSIGN element = SUBSTRING(_inp_line[1],8)
                     element = SUBSTRING(element,1,LENGTH(element) - 1)
                     _Q._Where[INTEGER(element)] = _inp_line[3]. 
            END. /* If a where clause */
          END.  /* An array element with a non ? value */
        END.  /* Read-Arrays: REPEAT */
      END. /* IF...array...*/      
    END.  /* OTHERWISE DO:... */
   
  END CASE.  

END.  /* Process-Query-Block */

/* 
 * Rebuild the Query from the raw material provided 
 * and store as a freeform query
 */
IF NOT AVAILABLE _code THEN DO:  
  RUN workshop/_qbuild.p (RECID(_Q), _suppress_dbname, 0).
  RUN create-freeform (BUFFER _code).
  FIND _code-text WHERE RECID(_code-text) eq _code._text-id.
  _code-text._text = _Q._4GLQury.
END.

/* *************************************************************************  
 * create-freeform: 
 *    Creates a freeform code block for the current query.  
 * ************************************************************************* */
PROCEDURE create-freeform :     
  DEFINE PARAMETER BUFFER p_code FOR _code.
  
  DEFINE VARIABLE last-id AS RECID NO-UNDO.
  DEFINE VARIABLE new-id  AS RECID NO-UNDO.  
  
  /* Insert this code section at the end. */
  RUN workshop/_find_cd.p (p_proc-id, "LAST":U, "":U, OUTPUT last-id).   
  RUN workshop/_ins_cd.p (INPUT  last-id, RECID(_P), RECID(_U), 
                          INPUT  "_CONTROL", "":U, "OPEN_QUERY":U,    
                          OUTPUT new-id).
  FIND p_code WHERE RECID(p_code) eq new-id.   
  CREATE _code-text.
  ASSIGN p_code._text-id = RECID(_code-text)
         _code-text._code-id = RECID(_code)
         _code-text._text    = "":U
         .
END PROCEDURE.

/* 
 * ---- End of file ----- 
 */
 

