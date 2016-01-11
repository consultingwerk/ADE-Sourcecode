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
    Read a _QUERY-BLOCK of source code to fill-in the special _C fields
         of a BROWSE/DIALOG-BOX or FRAME universal widget.
         
Note:
    Before version 7.3A, this file was labelled _rdbrow.p.

Input Parameters:
   file_version - The UIB version of the input file.

Output Parameters:
   <None>

Author: D. Ross Hunter


Date Created:  1992
Date Modified: 
       08/08/00 jep    Assign _P recid to newly created _TRG records.
       06/21/99 SLK    IMPORT _BC._FORMAT-ATTR _BC._HELP-ATTR _BC._LABEL-ATTR
       06/10/99 tsm    Added auto-resize and column-read-only attributes
       05/21/99 tsm    Added visible attribute
       08/21/98 SLK    Remove SDO's USER-LIST by importing  
       06/03/98 SLK    Support SDO's USER-LIST by importing  
       06/03/98 HD     Support remote SDO's   
       05/27/98 HD     no object type check before run _undqry (_undqry has the logic)  
       04/02/98 SLK    For SmartData, IMPORT _BC._NAME and _BC._INHERIT-VALIDATION  
       03/11/98 HD     Don't run _undqry for non visual objects  
       02/10/98 GFS    changed disable-autozap to disable-auto-zap
       01/05/98 GFS    changed use-autozap to disable-autozap
       01/04/98 GFS    add support for new browse col. attr use-autozap & auto-return
       01/04/98 SLK    SmartData Subtype
        7/94     R Ryan (support for _Q._OptionList)

---------------------------------------------------------------------------- */
{adeuib/uniwidg.i}             /* Universal Widget TEMP-TABLE definition     */
{adecomm/adestds.i}            /* Ade standard preprocessor definitions      */
{adeuib/layout.i}              /* multi-layout information                   */
{adeuib/triggers.i}            /* Trigger TEMP-TABLE definition              */
{adeuib/name-rec.i}            /* Name indirection table                     */
{adeuib/brwscols.i}            /* Browse Column Temptable definitions        */
{adeuib/sharvars.i}            /* Shared variables                           */
{src/adm2/globals.i}
/** Contains definitions for dynamics design-time temp-tables. **/
{destdefi.i}

/* Standard End-of-line character */
&Scoped-define EOL &IF "{&WINDOW-SYSTEM}" <> "OSF/Motif" &THEN "~r" + &ENDIF CHR(10)
/* Use this to turn debugging on after each line that is read in.
   (i.e. rename no-DEBUG  to DEBUG) */
&Scoped-define no-debug message _inp_line[1] _inp_line[2] _inp_line[3] _inp_line[4] _inp_line[5] .

DEFINE INPUT PARAMETER file_version    AS  CHAR                           NO-UNDO.
DEFINE SHARED  STREAM    _P_QS.
DEFINE SHARED  VARIABLE  _inp_line     AS  CHAR      EXTENT 100           NO-UNDO.
DEFINE SHARED  VARIABLE  adj_joincode  AS  LOGICAL   INITIAL NO           NO-UNDO.
DEFINE         VARIABLE  choice        AS  CHARACTER                      NO-UNDO.
DEFINE         VARIABLE  cur_bc-rec    AS  RECID                          NO-UNDO.
DEFINE         VARIABLE  cur-lo        AS  CHAR                           NO-UNDO.
DEFINE         VARIABLE  db-switch     AS  CHARACTER                      NO-UNDO.
DEFINE         VARIABLE  element       AS  CHAR                           NO-UNDO.
DEFINE         VARIABLE  fr-name       AS  CHARACTER                      NO-UNDO.
DEFINE         VARIABLE  hSDO          AS  HANDLE                         NO-UNDO.
DEFINE         VARIABLE  i             AS  INTEGER                        NO-UNDO.
DEFINE         VARIABLE  iw            AS  INTEGER                        NO-UNDO.
DEFINE         VARIABLE  isaSMO        AS  LOGICAL                        NO-UNDO.
DEFINE         VARIABLE  isSmartData   AS  LOGICAL                        NO-UNDO.
DEFINE         VARIABLE  isDynSDO      AS LOGICAL                         NO-UNDO.
DEFINE         VARIABLE  j             AS  INTEGER                        NO-UNDO.
DEFINE         VARIABLE  lProcessAgain AS  LOGICAL                        NO-UNDO.
DEFINE         VARIABLE  never-again   AS  LOGICAL                        NO-UNDO.
DEFINE         VARIABLE  query-phrase  AS  CHARACTER                      NO-UNDO.
DEFINE         VARIABLE  ret-msg       AS  CHARACTER                      NO-UNDO.
DEFINE         VARIABLE  sdoFlds       AS  CHARACTER                      NO-UNDO.
DEFINE         VARIABLE  tmp-db-name   AS  CHARACTER                      NO-UNDO.
DEFINE         VARIABLE  tmp-dazap     AS  CHARACTER                      NO-UNDO.
DEFINE         VARIABLE  tmp-auto-ret  AS  CHARACTER                      NO-UNDO.
DEFINE         VARIABLE  tmp-width     AS  CHARACTER                      NO-UNDO.
DEFINE         VARIABLE  valid-dbs     AS  CHARACTER                      NO-UNDO.
DEFINE         VARIABLE  tmp-visible   AS  CHARACTER                      NO-UNDO.
DEFINE         VARIABLE  tmp-auto-rez  AS  CHARACTER                      NO-UNDO.
DEFINE         VARIABLE  tmp-col-ro    AS  CHARACTER                      NO-UNDO.
DEFINE         VARIABLE  tmp-formatAttr       AS  CHARACTER               NO-UNDO.
DEFINE         VARIABLE  tmp-helpAttr         AS  CHARACTER               NO-UNDO.
DEFINE         VARIABLE  tmp-labelAttr        AS  CHARACTER               NO-UNDO.

DEFINE         VARIABLE  cDataFieldName       AS  CHARACTER               NO-UNDO.
DEFINE         VARIABLE  hDesignManager       AS  HANDLE                  NO-UNDO. 
DEFINE         VARIABLE  pcInheritClasses     AS  CHARACTER               NO-UNDO.


DEFINE BUFFER  p_U      FOR _U.
DEFINE BUFFER  parent_U FOR _U.
DEFINE BUFFER  parent_L FOR _L.

/* Show the current line */
&IF "{&debug}" ne "" &THEN
  MESSAGE "Enter _rdqury.p".
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

FIND _P WHERE _P._WINDOW-HANDLE = _h_win.


/* Note isa.p doesn't work for SmartDataObject here because this is query that
   it is looking for.  */
RUN adeuib/_isa.p (INPUT INTEGER(RECID(_P)),
                   INPUT "SmartObject":U,
                   OUTPUT isaSMO).

isSmartData = isaSMO AND
              NOT CAN-FIND(FIRST _U WHERE _U._WINDOW-HANDLE = _h_win AND
                                 _U._TYPE = "FRAME":U) AND
              NOT CAN-FIND(FIRST _U WHERE _U._WINDOW-HANDLE = _h_win AND
                                 _U._TYPE = "DIALOG-BOX":U) AND
              _P._DB-AWARE.
       
IF isSmartData AND _DynamicsIsRunning THEN DO:
  isDynSDO = LOOKUP(_P.object_Type_Code, DYNAMIC-FUNCTION("getClassChildrenFromDB":U IN gshRepositoryManager, 
                                 INPUT "DynSDO":U)) <> 0 .
END.

IF _P._data-object NE "" THEN 
DO:
  ASSIGN 
    hSDO = DYNAMIC-FUNC("get-sdo-hdl" IN _h_func_lib, 
                         _P._DATA-OBJECT,
                         SOURCE-PROCEDURE).
  IF NOT VALID-HANDLE(hSDO) THEN
  DO:
      MESSAGE 'The associated SmartDataObject' _P._DATA-OBJECT 
              'used by this file' _P._save-as-file 
              'could not be instantiated. Make sure that the SmartDataObject file exists.'
      VIEW-AS ALERT-BOX WARNING.
     RETURN "_ABORT".
  END.
  ASSIGN
     sdoFlds = dynamic-function("getDataColumns":U IN hSDO).
END.

/* QUERY objects are defined here, so we need to create the Universal widget
   records for them. */
IF _inp_line[2] = "QUERY" THEN DO: 
  /* Create a Universal Widget Record and populate it as much as possible. */
  CREATE _U.
  CREATE _C.
  CREATE _L.
  CREATE _Q.
  CREATE _NAME-REC.
  
  ASSIGN /* TYPE-specific settings */
    _U._TYPE             = "QUERY":U
    _U._SUBTYPE          = IF isSmartData THEN "SmartDataObject" ELSE ""
    _U._WINDOW-HANDLE    = _h_win
    _C._q-recid          = RECID(_Q)
    _U._x-recid          = RECID(_C)
    _U._lo-recid         = RECID(_L)
    _NAME-REC._wNAME     = _inp_line[3]
    _NAME-REC._wTYPE     = _U._TYPE
    _NAME-REC._wRECID    = RECID(_U) 
    _NAME-REC._wFRAME    = ?            /* names must be unique across frames */
    .
   
  /* Make sure the new name is unique. */
  VALIDATE _NAME-REC.
  RUN adeshar/_bstname.p
       (_NAME-REC._wNAME, ?, "", 0, _U._WINDOW-HANDLE, OUTPUT _U._NAME).

END. /* If _inp_line[2] is "QUERY */
ELSE DO:  /* Else not a query - a Browse? */
  FIND _NAME-REC WHERE _NAME-REC._wNAME   = _inp_line[3] 
                   AND _NAME-REC._wDBNAME = ?  
                   AND _NAME-REC._wTABLE  = ? 
                   AND _NAME-REC._wTYPE   = _inp_line[2].
  FIND _U WHERE RECID(_U) = _NAME-REC._wRECID.
  FIND _C WHERE RECID(_C) = _U._x-recid.
  FIND _Q WHERE RECID(_Q) = _C._q-recid.
END.

lProcessAgain = NO.
PROCESS-QUERY-BLK:
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
      THEN LEAVE PROCESS-QUERY-BLK.
    END. /* Is this the end of a query line? */
    
    /* Emergency exit */
    WHEN "_UIB-CODE-BLOCK" THEN LEAVE PROCESS-QUERY-BLK.
    
    WHEN "_START_FREEFORM":U THEN DO:
      CREATE _TRG.
      ASSIGN _TRG._pRECID   = RECID(_P)
             _TRG._wRECID   = RECID(_U)
             _TRG._tSECTION = "_CONTROL":U
             _TRG._tEVENT   = "OPEN_QUERY":U
             _TRG._tSPECIAL = "_OPEN-QUERY":U
             _TRG._tCODE    = "":U.
      READ-CODE:
      REPEAT ON END-KEY UNDO READ-CODE, RETRY READ-CODE:
        IF RETRY THEN _TRG._tCODE = _TRG._tCODE + "." + {&EOL}.
        IMPORT STREAM _P_QS UNFORMATTED _inp_line[1].
        IF TRIM(_inp_line[1]) = "_END_FREEFORM":U THEN LEAVE READ-CODE.
        ELSE _TRG._tCODE = _TRG._tCODE + _inp_line[1] + {&EOL}.
      END. /* READ-CODE */
      IF file_version = "UIB_v8r1":U AND TRIM(_TRG._tCODE) BEGINS "FOR" THEN
        _TRG._tCODE = "OPEN QUERY " + _NAME-REC._wNAME + " " + 
                      TRIM(_TRG._tCODE) + {&EOL}.
    END.  /* Processing a freeform query */
    
    WHEN "_START_FREEFORM_DEFINE":U THEN DO:
      CREATE _TRG.
      ASSIGN _TRG._pRECID   = RECID(_P)
             _TRG._wRECID   = RECID(_U)
             _TRG._tSECTION = "_CONTROL":U
             _TRG._tEVENT   = "DEFINE_QUERY":U
             _TRG._tSPECIAL = "_DEFINE-QUERY":U
             _TRG._tCODE    = "":U.
      READ-CODE:
      REPEAT ON END-KEY UNDO READ-CODE, RETRY READ-CODE:
        IF RETRY THEN _TRG._tCODE = _TRG._tCODE + "." + {&EOL}.
        IMPORT STREAM _P_QS UNFORMATTED _inp_line[1].
        IF TRIM(_inp_line[1]) = "_END_FREEFORM_DEFINE":U THEN LEAVE READ-CODE.
        ELSE _TRG._tCODE = _TRG._tCODE + _inp_line[1] + {&EOL}.
      END. /* READ-CODE */
    END.  /* Definition part of a free form query */
    
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
              IF valid-dbs NE "" AND 
                 (ENTRY(1,tmp-db-name,".":U) NE "temp-tables":U AND
                  LOOKUP("TEMP-DB",valid-dbs) = 0) THEN
                RUN adeuib/_find-db (INPUT tmp-db-name,
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
    
    WHEN "_Private-Data" THEN DO:
      ASSIGN _U._PRIVATE-DATA = _inp_line[3] NO-ERROR.
      IF ERROR-STATUS:ERROR
      THEN RUN error-msg ("Could not parse PRIVATE-DATA for object.").
      IF _inp_line[4] NE "":U THEN
      ASSIGN _U._PRIVATE-DATA-ATTR = LEFT-TRIM(_inp_line[4],":":U).
    END.
    WHEN "_Design-Parent" THEN DO:
      IF _inp_line[3] eq "FRAME" THEN DO:
        /* Get the name of the parent frame.  If this is "?" then parent to
           the default frame. */
        fr-name = _inp_line[4] .
        IF fr-name ne "?" THEN DO:
          FIND _NAME-REC WHERE _NAME-REC._wTYPE = "FRAME"
                           AND _NAME-REC._wNAME = _inp_line[4] NO-ERROR.
          IF AVAILABLE _NAME-REC 
          THEN FIND parent_U WHERE RECID(parent_U) eq _NAME-REC._wRECID.
        END.
        /* If the named parent does not exist, just parent this to the 
           current frame. */        
        IF NOT AVAILABLE parent_U AND VALID-HANDLE(_h_frame) 
        THEN FIND parent_U WHERE parent_U._HANDLE eq _h_frame.
      END.
      /* In all other cases, parent the QUERY to the window. */
      IF _inp_line[3] eq "WINDOW" OR NOT AVAILABLE parent_U THEN
        FIND parent_U WHERE parent_U._HANDLE = _h_win.
      ASSIGN _U._parent-recid = RECID(parent_U).
      FIND parent_L WHERE RECID(parent_L) = parent_U._lo-recid.
      FIND _L WHERE RECID(_L) = _U._lo-recid.
      ASSIGN 
        cur-lo = parent_U._LAYOUT-NAME           
        /* Standard Settings for Universal and Layout records */
        { adeuib/std_ul.i &SECTION = "DRAW-SETUP" }
        _L._ROW  = DECIMAL(_inp_line[7])
        _L._COL  = DECIMAL(_inp_line[9])
        .   
    END. /* When _Design Parent */

    WHEN "_TuneOptions" THEN  _Q._TuneOptions =
         REPLACE(_inp_line[3], CHR(10) + FILL(" ", 26), CHR(10)).
    
    WHEN "_TblOptList" THEN _Q._TblOptList = TRIM(_inp_line[3]).

   /* * * * * * * * * * * * * * * * *  OLD CASES * * * * * ** * * * * * * * * */
   
    WHEN "/*" THEN DO:
      /* The "Query is opened statement is no longer necessary after UIB_v7r9 */
      IF _inp_line[2] = "QUERY" AND _inp_line[3] = "IS" AND
         _inp_line[4] = "NOT"   AND _inp_line[5] = "OPENED" THEN
      _Q._OpenQury = FALSE.
    END.
    
    /* The OPEN statement statement is no longer necessary after UIB_v7r9 */
    WHEN "OPEN" THEN DO:
      ASSIGN  _Q._4GLQury  = "EACH " + _inp_line[6] + " " + _inp_line[7].
      READ_4GLQUERY:
      REPEAT:
        i = LENGTH(_Q._4GLQury).
        IF R-INDEX(_Q._4GLQury,".") = i THEN DO:
          _Q._4GLQury = SUBSTRING(_Q._4GLQury,1,i - 1,"CHARACTER").
          LEAVE READ_4GLQUERY.
        END.
        IMPORT STREAM _P_QS UNFORMATTED _inp_line[1].
        _Q._4GLQury = _Q._4GLQury + {&EOL} + _inp_line[1].
      END.  /* READ_4GLQUERY */
    END. /* When OPEN QUERY */
    
    /* * * * * * * * * * * * * * END OF OLD CASES * * * * * * * * * * * * * * */

    OTHERWISE DO:
      /* Is this part of the Arrays?  If so then read all the array information. */
      IF (_inp_line[1] BEGINS "_JoinTo") OR (_inp_line[1] BEGINS "_JoinCode") OR
         (_inp_line[1] BEGINS "_Where" ) OR (_inp_line[1] BEGINS "_Fld")
      THEN DO: 
        /* Reprocess the line (i.e. don't read a new line). */
        lProcessAgain = YES.
        READ-ARRAYS:
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
            LEAVE READ-ARRAYS.
          END.     
          ELSE IF _inp_line[1] eq  "*/" THEN DO:  /* Is this the end-of-query line? */
            lProcessAgain = YES .  
            IF _inp_line[2] = "/*" AND _inp_line[3] = _NAME-REC._wTYPE AND
               _inp_line[4] = _NAME-REC._wNAME THEN
              LEAVE READ-ARRAYS.
          END.
          ELSE IF _inp_line[3] <> ? THEN DO:  /* A non ? Value - process it   */
            IF _inp_line[1] BEGINS "_JoinTo" THEN
              /* Do Nothing - this is here only to support UIB_v7r9 files */
              .
            ELSE IF _inp_line[1] BEGINS "_JoinCode" THEN DO:
              ASSIGN element = SUBSTRING(_inp_line[1],11)
                     element = SUBSTRING(element,1,LENGTH(element) - 1)
                     _Q._JoinCode[INTEGER(element) +
                                 IF adj_joincode AND INTEGER(element) = 1 THEN 1 ELSE 0]
                             = _inp_line[3].   
            END.  /* IF _JoinCode */
            ELSE IF _inp_line[1] BEGINS "_Where" THEN DO:
              ASSIGN element = SUBSTRING(_inp_line[1],8)
                     element = SUBSTRING(element,1,LENGTH(element) - 1)
                     _Q._Where[INTEGER(element)] = _inp_line[3]. 
            END. /* If a where clause */
            /* Recreate the BROWSE or SmartData */  
            ELSE IF _inp_line[1] BEGINS "_FldNameList" THEN DO:

              /* Trap reading in a browser where the field is no longer in the
               * SDO 
               */
              IF VALID-HANDLE(hSDO) AND NUM-ENTRIES(_inp_line[3], ".") > 2 AND
                 NOT CAN-DO(sdoFlds,TRIM(ENTRY(3,_inp_line[3],".":U))) THEN
              DO:
                  RUN adeuib/_advisor.w (
                  /* Text */        INPUT 
                                CHR(10)
                                + "The SmartDataObject include file changed." 
                                + CHR(10) + CHR(10)
                                + "Browse field:" + CHR(10)
                                + "     " + ENTRY(3,_inp_line[3],".":U) + CHR(10) 
                                + "is no longer in the SmartDataObject." + CHR(10)
                                + CHR(10)
                                + "SmartDataObject field(s) are:" + CHR(10)
                                + "     " + sdoFlds, 
                  /* Options */     INPUT 'Remove "'
                                    + ENTRY(3,_inp_line[3],".":U) 
                                    + '" from Browse.'
                                    + ",Continue,Cancel file opening.,Cancel",
                  /* Toggle Box */  INPUT FALSE,
                  /* Help Tool */   INPUT "AB",
                  /* Context */     INPUT ?,
                  /* Choice */      INPUT-OUTPUT choice,
                  /* Never Again */ OUTPUT never-again).

                  CASE choice:
                     WHEN "Continue":U THEN
                     DO:
                        ASSIGN _P._FILE-SAVED = NO.
                        NEXT PROCESS-QUERY-BLK.
                     END.
                     OTHERWISE DO:
                        RETURN "_ABORT".
                     END.
                  END CASE.
              END.

              CREATE _BC.
              ASSIGN element        = SUBSTRING(_inp_line[1],14)
                     element        = SUBSTRING(element,1,LENGTH(element) - 1)
                     _BC._x-recid   = RECID(_U)
                     _BC._SEQUENCE  = INTEGER(element)
                     _BC._DISP-NAME = IF NOT isSmartData THEN _inp_line[3] ELSE ""
                     _BC._DBNAME    = IF NUM-ENTRIES(_inp_line[3],".":U) NE 3 OR
                                      INDEX(_inp_line[3],"(":U) > 0 OR
                                      (isSmartData AND _inp_line[3] BEGINS "_<CALC>")
                                        THEN "_<CALC>":U
                                        ELSE ENTRY(1, _inp_line[3], ".":U)
                     cur_bc-rec     = RECID(_BC).

               /* When we read a Field Name, reset the label & format.
                 SDOs don't use this and are likely to have more fields than 
                 extents in this array, so just skip it. */
              IF NOT isSmartData THEN
                 ASSIGN _Q._FldLabelList[INTEGER(element)] = "":U
                        _Q._FldFormatList[INTEGER(element)] = "":U.

              IF db-switch ne "" AND NOT CAN-DO(_BC._DBNAME,valid-dbs) AND
                                    _BC._DBNAME NE "_<CALC>":U THEN
                DO i = 1 TO NUM-ENTRIES(db-switch):
                  _BC._DBNAME = REPLACE(_BC._DBNAME,
                                  ENTRY(1,ENTRY(i,db-switch),CHR(4)),
                                  ENTRY(2,ENTRY(i,db-switch),CHR(4))).
                END. /* Do i = 1 To num(db-switch) */

                IF _BC._DBNAME NE "_<CALC>":U AND _BC._DBNAME NE "_<SDO>" THEN DO:
                  ASSIGN _BC._TABLE = ENTRY(2,_inp_line[3],".":U)
                         _BC._NAME  = ENTRY(3,_inp_line[3],".":U).

                  /* This is necessary due to the fact that DICTDB needs to be properly
                     connected here, yet _rdqury.p can be called when no DB's are
                     connected  */
                  IF NOT CONNECTED(_BC._DBNAME) AND _BC._DBNAME NE "TEMP-TABLES" THEN DO:
                    MESSAGE 'The {&UIB_NAME} expects the' _BC._DBNAME
                            'database to be connected.' SKIP
                            'Information in this .w file has been lost. You should not save' SKIP
                            'this file on top of the original until it is determined that this .w' SKIP
                            'file is not corrupted.'
                         VIEW-AS ALERT-BOX WARNING.
                    FIND _P WHERE _P._WINDOW-HANDLE = _U._WINDOW-HANDLE.
                    _P._SAVE-AS-FILE = ?.
                    RUN adeuib/_winsave(_h_win, FALSE).
                    RETURN.
                  END.  /* If not properly connected */
                  ELSE RUN adeuib/_loadbc.p (INPUT RECID(_BC)).
                END. /* NE CALC */
               
                ELSE IF _BC._DBNAME eq "_<CALC>" THEN DO:
                  /* A calculated field */
                  ASSIGN _BC._TABLE = ?.
                END.  /* If a calculated field */
                ELSE DO: /* A SDO record for a SmartBrowse 
                         NOTE: The assign of _BC from sdo is (sadly) duplicated in _crtsobj.w */
                  ASSIGN _BC._NAME         = ENTRY(3,_BC._DISP-NAME, ".":U)
                         _BC._DBNAME       = "_<SDO>"
                         _BC._DATA-TYPE    = dynamic-function("columnDataType" IN hSDO,_BC._NAME)
                         _BC._DEF-FORMAT   = dynamic-function("columnFormat" IN hSDO,_BC._NAME)
                         _BC._DEF-HELP     = dynamic-function("columnHelp" IN hSDO,_BC._NAME)
                         _BC._DEF-LABEL    = dynamic-function("columnColumnLabel" IN hSDO,_BC._NAME)
                         _BC._DEF-WIDTH    = MAX(dynamic-function("columnWidth" IN hSDO,_BC._NAME),
                                                    FONT-TABLE:GET-TEXT-WIDTH(ENTRY(1,_BC._DEF-LABEL,"!":U)))
                         _BC._DISP-NAME    = _BC._NAME
                         _BC._FORMAT       = _BC._DEF-FORMAT
                         _BC._HELP         = _BC._DEF-HELP
                         _BC._LABEL        = _BC._DEF-LABEL
                         _BC._WIDTH        = _BC._DEF-WIDTH
                         _BC._TABLE        = "rowObject".
                         
                  IF NUM-ENTRIES(_BC._DEF-LABEL,"!":U) > 1 THEN DO:
                    DO iw = 2 TO NUM-ENTRIES(_BC._DEF-LABEL,"!":U):
                      ASSIGN _BC._DEF-WIDTH = MAX(_BC._DEF-WIDTH, 
                                             FONT-TABLE:GET-TEXT-WIDTH(ENTRY(iw,_BC._DEF-LABEL,"!":U)))
                             _BC._WIDTH     = _BC._WIDTH.
                    END.
                  END.  /* IF Stacked Columns */
                END.  /* If a SDO of a SmartBrowse */
                IF _inp_line[2] = ">":U THEN DO: /* 7.4A or higher */

                  IF isSmartData THEN 
                    IMPORT STREAM _P_QS 
                       _BC._NAME _BC._DISP-NAME _BC._LABEL _BC._FORMAT _BC._DATA-TYPE _BC._BGCOLOR
                       _BC._FGCOLOR _BC._FONT _BC._LABEL-BGCOLOR _BC._LABEL-FGCOLOR 
                       _BC._LABEL-FONT _BC._ENABLED _BC._HELP _BC._MANDATORY _BC._WIDTH _BC._INHERIT-VALIDATION 
                       .
                  ELSE
                    IMPORT STREAM _P_QS 
                       _BC._DISP-NAME _BC._LABEL _BC._FORMAT _BC._DATA-TYPE _BC._BGCOLOR
                       _BC._FGCOLOR _BC._FONT _BC._LABEL-BGCOLOR _BC._LABEL-FGCOLOR 
                       _BC._LABEL-FONT _BC._ENABLED _BC._HELP 
                       tmp-dazap tmp-auto-ret tmp-width tmp-visible tmp-auto-rez tmp-col-ro
                       tmp-formatAttr tmp-helpAttr tmp-labelAttr.
                                                  /* It is necessary for the temporary char variable
                                                     so that we can read old .w files that don't have
                                                     these five fields.  Otherwise the UIB has errors. */
                  IF tmp-dazap ne "" THEN
                    ASSIGN _BC._DISABLE-AUTO-ZAP = (tmp-dazap BEGINS "y")
                           _BC._AUTO-RETURN      = (tmp-auto-ret BEGINS "y")
                           _BC._WIDTH            = DECIMAL(tmp-width)
                           _BC._VISIBLE          = NOT (tmp-visible BEGINS "n")
                           _BC._AUTO-RESIZE      = (tmp-auto-rez BEGINS "y")
                           _BC._COLUMN-READ-ONLY = (tmp-col-ro BEGINS "y").
                  IF tmp-formatAttr NE "":U AND tmp-formatAttr NE ? THEN
                  ASSIGN _BC._FORMAT-ATTR = tmp-formatAttr.
                  IF tmp-helpAttr NE "":U AND tmp-helpAttr NE ? THEN
                  ASSIGN _BC._HELP-ATTR = tmp-helpAttr.
                  IF tmp-labelAttr NE "":U AND tmp-labelAttr NE ? THEN
                  ASSIGN _BC._LABEL-ATTR = tmp-labelAttr.
               END.  /* If ">" */
               ELSE ASSIGN _BC._FORMAT = ?  /* Initialize older (7.3B) stuff */
                           _BC._HELP   = ?
                           _BC._LABEL  = ?.      
               IF _BC._FORMAT = ? THEN _BC._FORMAT = _BC._DEF-FORMAT.       
               IF _BC._HELP   = ? THEN _BC._HELP   = _BC._DEF-HELP.       
               IF _BC._LABEL  = ? THEN _BC._LABEL  = _BC._DEF-LABEL.
               IF _BC._WIDTH  = ? THEN _BC._WIDTH  = _BC._DEF-WIDTH.
               IF (_suppress_dbname AND _BC._DBNAME NE "_<CALC>":U  OR
                    CAN-DO(_tt_log_name, _BC._DBNAME))
                    AND NOT isSmartData THEN
                 _BC._DISP-NAME = _BC._TABLE + ".":U + _BC._NAME.
               /* The next 2 lines are a kluge to allow a logical format of "*" for true */
               IF _BC._FORMAT BEGINS "*~~~~/":U THEN
                 _BC._FORMAT = "*/":U + SUBSTRING(_BC._FORMAT,5,-1,"CHARACTER":U).

               IF isSmartData AND _DynamicsIsRunning THEN
               DO:
                 IF _BC._DBNAME = "Temp-Tables":U THEN
                 DO:
                   FIND FIRST _TT WHERE _TT._p-recid = RECID(_P) AND
                                        _TT._NAME = _BC._TABLE NO-ERROR.
                   IF AVAILABLE _TT THEN
                     IF _TT._TABLE-TYPE = "B":U THEN
                       cDataFieldName = _TT._LIKE-TABLE + ".":U + _BC._NAME.
                 END.
                 /* For dynamic SDOs, _BC._NAME is the master object name and
                    _BC._DISP-NAME is the instance name.
                    For static SDOs, _BC._NAME is the calc expression and
                    _BC._DISP-NAME is the calc field name.
                    _BC._STATUS is set to "STATIC" for static SDO 
                    calculated field to support saving them as dynamic
                    by using the correct calc field name to find
                    the calculated field master object. */
                 ELSE IF _BC._DBNAME = "_<CALC>":U THEN 
                     ASSIGN 
                       cDataFieldName = IF isDynSDO THEN _BC._NAME
                                        ELSE _BC._DISP-NAME
                       _BC._STATUS    = IF isDynSDO THEN "":U
                                        ELSE "STATIC":U.
                 ELSE cDataFieldName = _BC._TABLE + ".":U + _BC._NAME.
                 
                 /* Retrieve the Datafield master object  */
                 ASSIGN hDesignManager = DYNAMIC-FUNCTION("getManagerHandle":U, INPUT "RepositoryDesignManager":U) NO-ERROR.
                 RUN retrieveDesignObject IN hDesignManager ( INPUT  cDataFieldName,
                                                              INPUT  "",  /* Get default  result Codes */
                                                              OUTPUT TABLE ttObject,
                                                              OUTPUT TABLE ttPage,
                                                              OUTPUT TABLE ttLink,
                                                              OUTPUT TABLE ttUiEvent,
                                                              OUTPUT TABLE ttObjectAttribute ) NO-ERROR.
                 FIND FIRST ttObject WHERE ttObject.tLogicalObjectName = cDataFieldName NO-ERROR.
                 IF AVAIL ttObject THEN
                 DO:
                    FIND FIRST ttObjectAttribute WHERE ttObjectAttribute.tSmartObjectObj    = ttObject.tSmartObjectObj
                                                   AND ttObjectAttribute.tObjectInstanceObj = ttObject.tObjectInstanceObj 
                                                   AND ttObjectAttribute.tAttributeLabel    = "Label":U NO-ERROR.
                    IF AVAIL ttObjectAttribute THEN    
                       ASSIGN _BC._LABEL = ttObjectAttribute.tAttributeValue.
                   
                    FIND FIRST ttObjectAttribute WHERE ttObjectAttribute.tSmartObjectObj    = ttObject.tSmartObjectObj
                                                   AND ttObjectAttribute.tObjectInstanceObj = ttObject.tObjectInstanceObj 
                                                   AND ttObjectAttribute.tAttributeLabel    = "Format":U NO-ERROR.
                    IF AVAIL ttObjectAttribute THEN    
                       ASSIGN _BC._FORMAT = ttObjectAttribute.tAttributeValue.

                    FIND FIRST ttObjectAttribute WHERE ttObjectAttribute.tSmartObjectObj    = ttObject.tSmartObjectObj
                                                   AND ttObjectAttribute.tObjectInstanceObj = ttObject.tObjectInstanceObj 
                                                   AND ttObjectAttribute.tAttributeLabel    = "Help":U NO-ERROR.
                    IF AVAIL ttObjectAttribute THEN    
                       ASSIGN _BC._HELP = ttObjectAttribute.tAttributeValue. 
                   
                    ASSIGN _BC._HAS-DATAFIELD-MASTER = TRUE NO-ERROR.     
                    
                 END. /* If avail ttObject */
               END.  /* if isSmartData and ICF Running */
            END.
            ELSE IF _inp_line[1] BEGINS "_FldLabelList" THEN DO:
              FIND _BC WHERE RECID(_BC) = cur_bc-rec.
              ASSIGN element = SUBSTRING(_inp_line[1],15)
                     element = SUBSTRING(element,1,LENGTH(element) - 1)
                     _Q._FldLabelList[INTEGER(element)] = _inp_line[3]
                     _BC._LABEL = _inp_line[3].
            END.
            ELSE IF _inp_line[1] BEGINS "_FldFormatList" THEN DO:
              FIND _BC WHERE RECID(_BC) = cur_bc-rec.
              ASSIGN element = SUBSTRING(_inp_line[1],16)
                     element = SUBSTRING(element,1,LENGTH(element) - 1)
                     _Q._FldFormatList[INTEGER(element)] = _inp_line[3]
                     _BC._FORMAT = _inp_line[3].
            END.
          END.  /* An array element with a non ? value */
        END.  /* READ-ARRAYS: REPEAT */
      END. /* IF...array...*/      
    END.  /* OTHERWISE DO:... */
   
  END CASE.  

END.  /* PROCESS-QUERY-BLK */

/* The SDO is beeing shutdown by _qssuckr.p 
IF AVAILABLE _P THEN ret-msg = shutdown-proc(_P._data-object).
*/

/* Hack for backward compatibility to 7.2 */
IF _Q._OPTIONLIST = "" AND adj_joincode THEN _Q._OPTIONLIST = "NO-LOCK".

/* Rebuild the Query from the raw material provided. */
RUN adeuib/_qbuild.p (RECID(_Q), _suppress_dbname, 0).

/* If a SmartBrowse going against a SDO, remove the NO-LOCK */
IF _Q._4GLQury = "EACH rowObject NO-LOCK" THEN
  _Q._4GLQury = "EACH rowObject".

/* If we have successfully loaded in a query, the show it (either as a
   browse simulation, or a fully realized query. */
IF AVAILABLE (_U) THEN DO:
  IF _U._TYPE = "BROWSE":U THEN DO:
    IF VALID-HANDLE(_U._PROC-HANDLE) THEN RUN destroyObject IN _U._PROC-HANDLE.
    ELSE IF VALID-HANDLE(_U._HANDLE) THEN DELETE WIDGET _U._HANDLE.
    RUN adeuib/_undbrow.p (RECID(_U)).
  END.
  ELSE IF isSmartData THEN RUN adeuib/_undsdo.p  (RECID(_U)).
  ELSE IF _U._TYPE = "QUERY":U THEN
    RUN adeuib/_undqry.p (RECID(_U)).
END.


