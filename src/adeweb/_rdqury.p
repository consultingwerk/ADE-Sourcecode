/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*---------------------------------------------------------------------------- 
File: _rdqury.p

Description:
    Read a _QUERY-BLOCK of source code to fill-in the special _Q fields
    of a V2 query
         
    
Input Parameters:
    p_proc-id  - Procedure Context ID for the relevent _P record.
    p_qry-name - Name of the query.
    p_orig-ver - the original version number of the input file.
    p_options  - A comma-delimited list of options [currently unused]

Output Parameters:
   <None>

Author: Wm.T.Wood [from old adeuib/_rdqury.p]
Created:  1992
Updated: 02/20/97  wood  Created as new Workshop file from original _rdqury.p
         02/03/98  adams Modified for Skywalker 9.0a for reading V2 queries
         04/26/01  jep   IZ 993 - Check Syntax support for local WebSpeed V2 files.
                         Added _L._LO-NAME = "Master Layout" assignments.

---------------------------------------------------------------------------- */

DEFINE INPUT  PARAMETER p_proc-id    AS INTEGER NO-UNDO.
DEFINE INPUT  PARAMETER p_qry-name   AS CHAR    NO-UNDO.
DEFINE INPUT  PARAMETER p_orig-ver   AS CHAR    NO-UNDO.
DEFINE INPUT  PARAMETER p_options    AS CHAR    NO-UNDO.

/* Shared Include File definitions */
{ adeuib/sharvars.i }    /* Shared variables                               */
{ adeuib/uniwidg.i }     /* Universal Widget TEMP-TABLE definition         */
{ adeuib/layout.i } 
{ adeuib/triggers.i }

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

DEFINE BUFFER frm_U FOR _U.

/* Show the current line */
&IF "{&debug}" ne "" &THEN    
  { src/web/method/cgidefs.i }
  &Scoped-define debug message _inp_line[1] _inp_line[2] _inp_line[3] _inp_line[4] _inp_line[5] view-as alert-box.
  message "Enter _rdqury.p" view-as alert-box.
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

/* Find the frame. */
FIND frm_U WHERE frm_U._WINDOW-HANDLE eq _P._WINDOW-HANDLE AND
                 frm_U._TYPE eq "FRAME":U NO-ERROR.
                 
/* QUERY objects are defined here, so we need to create the Universal widget
   records for them. */

/* Create a Universal Widget Record and populate it as much as possible. */
CREATE _U.
CREATE _C.
CREATE _L.
CREATE _Q.
  
ASSIGN /* TYPE-specific settings and relationships */ 
  _U._WINDOW-HANDLE = _P._WINDOW-HANDLE
  _U._parent-recid  = RECID(frm_U) WHEN AVAILABLE frm_U
  _U._TYPE          = "QUERY":U
  _C._q-recid       = RECID(_Q)
  /*_U._x-recid = RECID(_Q)*/
  _U._x-recid       = RECID(_C)
  _U._lo-recid      = RECID(_L)
  /* _L._u-recid       = RECID(_U) */
  _L._LO-NAME       = "Master Layout"
  _L._COL           = 1
  _L._ROW           = 1
  .
  
/* Make sure the new name is unique. */
VALIDATE _U.
RUN adeweb/_bstname.p (p_qry-name, ?, p_proc-id, OUTPUT _U._NAME).

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
      RUN create-freeform (BUFFER _TRG).
      Read-Code:
      REPEAT ON END-KEY UNDO Read-Code, RETRY Read-Code:
        IF RETRY THEN 
          _TRG._tCODE = _TRG._tCODE + ".":U + {&EOL}.
        IMPORT STREAM _P_QS UNFORMATTED _inp_line[1].
        IF TRIM(_inp_line[1]) = "_END_FREEFORM":U THEN LEAVE Read-Code.
        ELSE _TRG._tCODE = _TRG._tCODE + _inp_line[1] + {&EOL}.
      END. /* Read-Code */
    END.
    
    WHEN "_TblList" THEN DO:
      _Q._TblList    = _inp_line[3].
      /* The remainder of this is new code to allow users to switch databases
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
                RUN adeweb/_find-db.p (tmp-db-name, valid-dbs,
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

    WHEN "_Options":U THEN _Q._OptionList = _inp_line[3].   
    WHEN "_FldList":U THEN _Q._FldList    = _inp_line[3].
    WHEN "_OrdList":U THEN _Q._OrdList    = _inp_line[3].
    
    WHEN "_Query":U   THEN DO:          
      /* Is this line "_Query is [NOT] OPENED */ 
      IF _inp_line[2] eq "is":U 
      THEN  _Q._OpenQury = (_inp_line[3] eq "OPENED":U).
    END.

    WHEN "_TuneOptions":U THEN _Q._TuneOptions =
         REPLACE(_inp_line[3], CHR(10) + FILL(" ":U, 26), CHR(10)).
    
    WHEN "_TblOptList":U THEN  _Q._TblOptList  = TRIM(_inp_line[3]).

   /* * * * * * * * * * * * * * * * *  OLD CASES * * * * * ** * * * * * * * * */
    WHEN "_Design-Parent":U THEN DO:
       /* In v1r1 -- Queries parented to frames. */
    END.
   
   /* * * * * * * * * * * * * * END OF OLD CASES * * * * * * * * * * * * * * */
    
   OTHERWISE DO:
     /* Is this part of the Arrays?  If so then read all the array information. */
     IF (_inp_line[1] BEGINS "_JoinTo":U) OR (_inp_line[1] BEGINS "_JoinCode":U) OR
        (_inp_line[1] BEGINS "_Where":U ) OR (_inp_line[1] BEGINS "_Fld":U)
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
IF NOT AVAILABLE _TRG THEN DO:  
  RUN adeweb/_qbuild.p (RECID(_Q), _suppress_dbname, 0).
  RUN create-freeform (BUFFER _TRG).
  _TRG._tCODE = _Q._4GLQury.
END.

/* Create the "query" in the form of a frame widget. */
RUN adeuib/_undqry.p (RECID(_U)).
/*
CREATE FRAME _U._HANDLE
  ASSIGN
*/

/* *************************************************************************  
 * create-freeform: 
 *    Creates a freeform code block for the current query.  
 * ************************************************************************* */
PROCEDURE create-freeform :     
  DEFINE PARAMETER BUFFER p_TRG FOR _TRG.
  
  /* Insert this code section at the end. */
  FIND LAST p_TRG WHERE p_TRG._pRECID eq p_proc-id NO-ERROR.
  CREATE _TRG.
  ASSIGN _TRG._pRECID   = RECID(_P)
         _TRG._wRECID   = RECID(_U) 
         _TRG._tSECTION = "_CONTROL":U
         _TRG._tEVENT   = "OPEN_QUERY":U
         _TRG._tSPECIAL = "_OPEN-QUERY":U
         _TRG._seq      = (IF AVAILABLE p_TRG THEN p_TRG._seq + 1 ELSE 1)
         .
END PROCEDURE.

/* _rdqury.p - end of file */

