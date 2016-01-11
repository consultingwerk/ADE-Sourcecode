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

File: _prpsdo.p

Description:
    Procedure to create a property sheet for the SmartDataObject
Input Parameters:
   h_self : The handle of the object we are editing

Output Parameters:
   <None>

Author: SLK
Copied from _prpobj.p
----------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER h_self   AS WIDGET                            NO-UNDO.

&GLOBAL-DEFINE WIN95-BTN  TRUE
&SCOPED-DEFINE USE-3D     YES

{adecomm/adestds.i}             /* Standards for "Sullivan Look"            */
{adeuib/uniwidg.i}              /* Universal widget definition              */
{adeuib/brwscols.i}             /* Definition of _BC records                */
{adeuib/triggers.i}             /* Trigger Temp-table definition            */
{adeuib/uibhlp.i}               /* Help pre-processor directives            */
{adeuib/sharvars.i}             /* The shared variables                     */
{src/adm2/globals.i}            /* Global vars for Dynamics */
{adecomm/icondir.i}

&SCOPED-DEFINE datatypes CHARACTER,DATE,DECIMAL,LOGICAL,INTEGER,RECID
&SCOPED-DEFINE FRAME-NAME prop_sht

DEFINE VARIABLE  name AS          CHAR LABEL "Object":U FORMAT "X(80)" VIEW-AS FILL-IN
                                     SIZE 43 BY 1            NO-UNDO.
DEFINE BUTTON    btn_adv          LABEL "&Advanced...":L SIZE 15 BY 1.125.
DEFINE VARIABLE  last-tab         AS WIDGET-HANDLE           NO-UNDO.
DEFINE VARIABLE  adjust           AS DECIMAL DECIMALS 2      NO-UNDO.
DEFINE VARIABLE  l_error_on_go    AS LOGICAL                 NO-UNDO.
DEFINE VARIABLE  lbl_wdth         AS DECIMAL DECIMALS 2      NO-UNDO.
DEFINE VARIABLE  stupid           AS LOGICAL NO-UNDO.  /* Error catcher for methods */

DEFINE VARIABLE h_btn_flds        AS WIDGET-HANDLE           NO-UNDO.
DEFINE VARIABLE h_btn_mdfy        AS WIDGET-HANDLE           NO-UNDO.
DEFINE VARIABLE h_query           AS WIDGET-HANDLE           NO-UNDO.   
DEFINE VARIABLE h_qry_lbl         AS WIDGET-HANDLE           NO-UNDO.   

DEFINE VARIABLE cur-row           AS DECIMAL DECIMALS 2      NO-UNDO.
DEFINE VARIABLE sav-qry           AS CHARACTER INITIAL ? NO-UNDO. /* Query editor       */

DEFINE VARIABLE isSmartData       AS LOGICAL INITIAL NO NO-UNDO.
DEFINE VARIABLE isWebObject       AS LOGICAL INITIAL NO NO-UNDO.
/* Dynamics specific variables */
DEFINE VARIABLE lisICFRunning            AS LOGICAL    NO-UNDO.
DEFINE VARIABLE h_Data-Logic_Proc_lbl    AS HANDLE     NO-UNDO.
DEFINE VARIABLE h_Data-Logic_Proc        AS HANDLE     NO-UNDO.
DEFINE VARIABLE h_Data-Logic_Proc_btn    AS HANDLE     NO-UNDO.
DEFINE VARIABLE h_Data-Logic_Proc_btndel AS HANDLE     NO-UNDO.
DEFINE VARIABLE hObjectBuffer            AS HANDLE     NO-UNDO.
DEFINE VARIABLE cDataLogicProc           AS CHARACTER  NO-UNDO.
DEFINE VARIABLE hAttributeBuffer         AS HANDLE     NO-UNDO.
DEFINE VARIABLE lEditDataLogicProc       AS LOGICAL    NO-UNDO.
DEFINE VARIABLE iRecid                   AS RECID      NO-UNDO.
DEFINE VARIABLE cDefCode                 AS CHARACTER  NO-UNDO.
DEFINE VARIABLE iStart                   AS INTEGER    NO-UNDO.
DEFINE VARIABLE iEnd                     AS INTEGER    NO-UNDO.
DEFINE VARIABLE cLine                    AS CHARACTER  NO-UNDO.

/* Define a SKIP for alert-boxes that only exists under Motif */
&Global-define SKP &IF "{&WINDOW-SYSTEM}" = "OSF/Motif" &THEN SKIP &ELSE &ENDIF

CREATE WIDGET-POOL.

/* We convert from a selection list to a text list by replacing commas with
   the End-Of-Line string.  This is chr(10) in UNIX but is chrs 13/10 in
   windows. */		 
BIG-TRANS-BLK:
DO TRANSACTION:
/* Turn off status messages, otherwise they will appear in the status area of
 * the Design window.  They are turned back on before exiting the procedure */
STATUS INPUT OFF.

ASSIGN lisICFRunning =  DYNAMIC-FUNCTION("IsICFRunning":U)  NO-ERROR. /* Check whether dynamics is running */
/* Create necessary widgets and initialize with current data                */
FIND _U WHERE _U._HANDLE = h_self.
FIND _P WHERE _P._WINDOW-HANDLE eq _U._WINDOW-HANDLE.
FIND _F WHERE RECID(_F) = _U._x-recid NO-ERROR.
IF NOT AVAILABLE _F THEN DO:
  FIND _C WHERE RECID(_C) = _U._x-recid.
  IF _C._q-recid NE ? THEN FIND _Q WHERE RECID(_Q) = _C._q-recid NO-ERROR.
END.

/* Find _C of Window  */
FIND _U WHERE _U._HANDLE = _h_win.
FIND _C WHERE RECID(_C)  = _U._x-recid.
FIND _U WHERE _U._HANDLE = h_self.

ASSIGN 
  isSmartData = _U._TYPE = "QUERY":U AND _U._SUBTYPE = "SmartDataObject":U
  isWebObject = _P._TYPE BEGINS "WEB":U.

IF NOT RETRY THEN DO:
  DEFINE FRAME prop_sht
         name         AT ROW 1.13  COL 11 COLON-ALIGNED {&STDPH_FILL}
         btn_adv      AT ROW 19    COL 50         
       WITH VIEW-AS DIALOG-BOX SIDE-LABELS SIZE 95 BY 22 THREE-D.

  RUN adjust_frame.
  
  /* *************************** Generate Needed Widgets ************************** */

  /* Set up the stuff at the top of the property sheet --- NON-toggle stuff         */
  RUN create_smartData_stuff.
  RUN set_tab_order.

  {adecomm/okbar.i &FRAME-NAME = prop_sht}
  RUN final_adjustments.
END.  /* IF NOT RETRY */

ON WINDOW-CLOSE OF FRAME prop_sht APPLY "END-ERROR":U TO SELF.


ON CHOOSE OF btn_help IN FRAME prop_sht OR HELP OF FRAME prop_sht DO:
  DEFINE VARIABLE help-context AS INTEGER NO-UNDO.
  IF isSmartData          THEN help-context = {&Property_Sheet_for_SmartDataObject_Client_Server_}.
  ELSE IF isWebObject     THEN help-context = {&Property_Sheet_for_SmartDataObject_Web_}.
  RUN adecomm/_adehelp.p ( "AB", "CONTEXT", help-context, ? ).
END.

/* Make sure names are valid */
ON LEAVE OF name IN FRAME prop_sht DO:
  DEFINE VARIABLE valid_name AS LOGICAL NO-UNDO.

    IF SELF:SCREEN-VALUE <> _U._NAME THEN DO:
      RUN adeuib/_ok_name.p (SELF:SCREEN-VALUE, RECID(_U), OUTPUT valid_name).
      IF valid_name THEN DO:
        ASSIGN _U._NAME = INPUT FRAME prop_sht name
               FRAME prop_sht:TITLE = "Property Sheet - " + 
		IF isSmartData THEN _P._TYPE ELSE "" + " " + _U._NAME.
      END.
      ELSE RETURN NO-APPLY.
    END.
END.

ON CHOOSE OF btn_adv DO:
  RUN adeuib/_advdprp.w (RECID(_U), lbl_wdth).
  APPLY "ENTRY" TO btn_OK IN FRAME prop_sht.
END.

IF SESSION:WIDTH-PIXELS = 640 AND SESSION:PIXELS-PER-COLUMN = 8 THEN
ASSIGN FRAME prop_sht:X = 0 - CURRENT-WINDOW:X 
       FRAME prop_sht:Y = 0 - CURRENT-WINDOW:Y.
       
RUN sensitize.

RUN adecomm/_setcurs.p ("").

WAIT-FOR "GO" OF FRAME prop_sht.

/* Turn status messages back on. (They were turned off at the top of the block */
STATUS INPUT.

RUN complete_the_transaction.
END.  /* BIG-TRANS-BLK */
HIDE FRAME prop_sht.
DELETE WIDGET-POOL.
/* ***************** PERSISTENT TRIGGERS FOR DYNAMIC WIDGETS  **************** */
PROCEDURE complete_the_transaction:
  DO WITH FRAME prop_sht:
    RUN adeuib/_winsave.p (_U._WINDOW-HANDLE, FALSE).
    IF h_Data-Logic_Proc:MODIFIED THEN
       ASSIGN _C._DATA-LOGIC-PROC = h_Data-Logic_Proc:SCREEN-VALUE.
    IF _P.Static_object = YES AND h_Data-Logic_Proc:MODIFIED THEN
    DO:
       /* For backward compatibilty, remove the DATA-LOGIC preprocessor from the definition section */
       /* Write back the preprocessor to the definitions section */
       RUN adeuib/_accsect.p("GET":U, ?, "DEFINITIONS":U, INPUT-OUTPUT iRecID, INPUT-OUTPUT cDefCode ).
       ASSIGN iStart     = INDEX(cDefCode,"&GLOB DATA-LOGIC-PROCEDURE":U)
              iStart     = IF iStart = 0 
                           THEN INDEX(cDefCode,"&GLOBAL-DEFINE DATA-LOGIC-PROCEDURE":U)
                           ELSE iStart
              iEnd       = IF iStart > 0 
                           THEN INDEX(cDefCode,".p":U, iStart)
                           ELSE 0
              iEnd       = IF iEnd = 0  AND iStart > 0
                           THEN INDEX(cDefCode,CHR(10), iStart)
                           ELSE iEnd.

       IF iStart > 0 THEN
          ASSIGN cDefCode  = SUBSTRING(cDefCode,1, iStart - 1) 
                               + IF iEnd + 2 < LENGTH(cDefCode) 
                               THEN SUBSTRING(cDefcode, iEnd + 2)
                               ELSE "".
      
      /* Write back the Definition section without the DATA-LOGIC-PROCEDURE preprocessor */
      RUN adeuib/_accsect.p (INPUT "SET":U,
                             INPUT ?,
                             INPUT 'DEFINITIONS':U,
                             INPUT-OUTPUT irecid,
                             INPUT-OUTPUT cDefCode).
    END.
  END.  /* DO WITH FRAME prop_sht */
END.  /* Complete the transaction */

procedure field_edit.
  DEFINE VARIABLE i           AS INTEGER           NO-UNDO.
  DEFINE VARIABLE table-list  AS CHARACTER         NO-UNDO.
  DEFINE VARIABLE tmp-name    AS CHARACTER         NO-UNDO.
  DEFINE VARIABLE xtbls       AS CHARACTER         NO-UNDO.
  DEFINE VARIABLE ctblname    AS CHARACTER         NO-UNDO.

  /* Get the external tables if any */
  RUN adeuib/_tbllist.p (INPUT RECID(_U), INPUT FALSE, OUTPUT xtbls).
  /*
  IF xtbls = "":U AND _P.object_type_code = "DynSDO":U THEN DO:
    /* Is is a dynamic SDO, we need to build this */
    FOR EACH _BC WHERE _BC._x-recid = RECID(_U):
       IF LOOKUP(_BC._TABLE, xTbls) = 0 THEN
         xTbls = xTbls + ",":U + _BC._TABLE.
    END.
    xTbls = LEFT-TRIM(xTbls,",":U).
  END.
  */
  ASSIGN table-list = xtbls.

  /* First see if the query is freeform.  If so use the _TRG record to determine
     the tables in the query, otherwise use _Q._TblList                       */
  FIND _TRG WHERE _TRG._wRECID = RECID(_U) AND
                  _TRG._tEVENT = "OPEN_QUERY":U NO-ERROR.
  IF AVAILABLE _TRG THEN DO:
    RUN build_table_list (INPUT _TRG._tCODE, INPUT ",":U, INPUT YES,
                          INPUT-OUTPUT table-list).
    IF xtbls NE "" THEN table-list = xtbls + "," + table-list.
  END.  /* If we found the OPEN_QUERY trigger */

  /* Add in _Q._TblList table not already in table-list */
  ELSE IF _Q._TblList NE "" THEN DO:
    DO i = 1 TO NUM-ENTRIES(_Q._TblList):
      IF NOT CAN-DO(table-list, ENTRY(i,_Q._TblList)) THEN
        table-list = table-list + "," + ENTRY(i,_Q._TblList).
    END. /* For each table in _Q._TblList */
    /* Trim off any leading or trailing commas */
    table-list = TRIM(table-list,",":U).
  END.

  _query-u-rec = RECID(_U).

  DO i = 1 TO NUM-ENTRIES (table-list):
    ASSIGN ENTRY(i,table-list) = ENTRY(1, ENTRY(i,table-list), " ":U)
           tmp-name            = ENTRY(i,table-list).
    IF NUM-ENTRIES(tmp-name,".":U) = 1 THEN ctblname = tmp-name.  /* May be a buffer */
    ELSE ctblname = ENTRY(2,tmp-name,".":U).
    FIND FIRST _TT WHERE _TT._p-recid = RECID(_P)
                     AND _TT._NAME = ctblname NO-ERROR.
    IF AVAILABLE _TT THEN
      ENTRY(i,table-list) = "Temp-Tables":U + "." + ctblname.

    /* In freeform queries, we sometimes only have the table name, yet _coledit.p
       requires db.table */
    IF NUM-ENTRIES(tmp-name,".":U) = 1 THEN DO:
      FIND FIRST _BC WHERE _BC._x-recid = _query-u-rec AND _BC._TABLE = tmp-name NO-ERROR.
      IF AVAILABLE _BC THEN
        ENTRY(i,table-list) = (IF AVAILABLE _TT THEN "Temp-Tables":U ELSE _BC._DBNAME) + "." + _BC._TABLE.
      ELSE  /* We're desperate here */
        ENTRY(i,table-list) = (IF AVAILABLE _TT THEN "Temp-Tables":U ELSE ldbname(1)) + "." + tmp-name.
    END. /* Entry has only a table name */
  END.
  /* Send over the table list or a handle to the SmartData */
  RUN adeuib/_coledit.p (INPUT table-list,INPUT ?).
END.
 
procedure query_edit.
  IF AVAILABLE _F THEN
    _F._LIST-ITEMS = REPLACE(RIGHT-TRIM(SELF:SCREEN-VALUE),CHR(13),"").
END.

procedure query_modify.
  DEFINE VARIABLE dbconnected AS LOGICAL  NO-UNDO.
  IF NUM-DBS = 0 THEN DO:
    RUN adecomm/_dbcnnct.p (
      INPUT "You must have at least one connected database to modify a query." ,
      OUTPUT dbconnected).
    if dbconnected eq no THEN RETURN.
  END.

  DO ON QUIT, LEAVE:
      
    /* iz 7535 Get rid of the freeform query button for dynamic sdos */
    RUN adeuib/_callqry.p ("_U":U, 
                           RECID(_U), 
                           IF AVAILABLE _P AND (NOT _P.Static_object OR (_P.object_type_code EQ "DynSDO":U))
                             THEN "QUERY-ONLY,NO-FREEFORM-QUERY":U
                               ELSE "QUERY-ONLY":U).
    FIND _TRG WHERE _TRG._wRECID = RECID(_U) AND
                    _TRG._tEVENT = "OPEN_QUERY":U NO-ERROR.
    IF AVAILABLE _TRG THEN RUN freeform_setup.
    ELSE ASSIGN  h_query:SCREEN-VALUE = TRIM (_Q._4GLQury).

    IF VALID-HANDLE(h_btn_flds) THEN
      h_btn_flds:SENSITIVE = yes.
  END.
END.

procedure adjust_frame.
  ASSIGN FRAME prop_sht:HIDDEN     = TRUE 
         FRAME prop_sht:PARENT     = ACTIVE-WINDOW
         FRAME prop_sht:TITLE      = "Property Sheet - " + _U._NAME
         last-tab                  = name:HANDLE IN FRAME prop_sht
         name:SENSITIVE IN FRAME prop_sht = TRUE
         name:SCREEN-VALUE         = _U._NAME
         btn_adv:SENSITIVE         = TRUE
         cur-row                   = name:ROW + 1.2.
END PROCEDURE.  /* adjust_frame */ 


/* Procedure build_table_list is in adeuib/bld_tbls.i */
{adeuib/bld_tbls.i}

procedure create_smartData_stuff.

   
   CREATE TEXT h_qry_lbl
          ASSIGN FRAME = FRAME prop_sht:HANDLE FORMAT = "X(12)".
   CREATE EDITOR h_query
        ASSIGN FRAME                = FRAME prop_sht:HANDLE
               ROW                  = cur-row 
               COLUMN               = name:COLUMN IN FRAME prop_sht
               SCROLLBAR-VERTICAL   = TRUE
               SCROLLBAR-HORIZONTAL = TRUE
               RETURN-INSERTED      = TRUE
               WIDTH                = FRAME prop_sht:WIDTH - h_query:COL -  8
               FONT                 = editor_font
               INNER-LINES          = IF SESSION:HEIGHT-PIXELS > 500 THEN 6
                                                                     ELSE 4
               SCREEN-VALUE         = _Q._4GLQURY
               SIDE-LABEL-HANDLE    = h_qry_lbl
               LABEL                = "Query:"
        TRIGGERS:                            
          ON LEAVE PERSISTENT RUN query_edit.
        END TRIGGERS.

   ASSIGN h_query:BGCOLOR = {&READ-ONLY_BGC}.
            
   ASSIGN stupid            = h_query:MOVE-AFTER(last-tab)
          last-tab          = h_query
          sav-qry           = _Q._4GLQURY
          h_qry_lbl:HEIGHT  = 1
          h_qry_lbl:WIDTH   = FONT-TABLE:GET-TEXT-WIDTH-CHARS(h_query:LABEL + " ")
          h_qry_lbl:ROW     = h_query:ROW
          h_qry_lbl:COLUMN  = h_query:COLUMN - h_qry_lbl:WIDTH
          h_query:SENSITIVE = TRUE
          h_query:READ-ONLY = TRUE.

   CREATE BUTTON h_btn_mdfy
        ASSIGN FRAME             = FRAME prop_sht:HANDLE
               ROW               = name:ROW - .05
               COLUMN            = NAME:COL + NAME:WIDTH + .2
               WIDTH             = 15
               HEIGHT            = 1.1
               LABEL             = "Query..." 
               SENSITIVE         = NOT CAN-FIND(_TRG
                                         WHERE _TRG._wRECID = RECID(_U) AND
                                               _TRG._tEVENT = "OPEN_QUERY":U)
       TRIGGERS:
         ON CHOOSE PERSISTENT RUN query_modify.
       END TRIGGERS.
     
   ASSIGN stupid            = h_btn_mdfy:MOVE-AFTER(last-tab)
          last-tab          = h_btn_mdfy.

   CREATE BUTTON h_btn_flds
        ASSIGN FRAME             = FRAME prop_sht:HANDLE
               ROW               = h_btn_mdfy:ROW 
               COLUMN            = h_btn_mdfy:COLUMN + h_btn_mdfy:WIDTH + .2
               WIDTH             = h_btn_mdfy:WIDTH
               HEIGHT            = 1.1
               LABEL             = "Fields..."
               SENSITIVE         = TRUE
     TRIGGERS:
       ON CHOOSE PERSISTENT RUN field_edit.
     END TRIGGERS.
     
   ASSIGN stupid    = h_btn_flds:MOVE-AFTER(last-tab)
          last-tab  = h_btn_flds
          cur-row   = cur-row + h_query:HEIGHT + .1.
   IF CAN-FIND(_TRG WHERE _TRG._wRECID = RECID(_U) AND
                          _TRG._tEVENT = "OPEN_QUERY":U) THEN
      RUN freeform_setup.                    
 
   /* Issue 3810, add data logic support */
   cur-row = cur-row + .25.
   CREATE TEXT h_Data-Logic_Proc_lbl
      ASSIGN FRAME        = FRAME prop_sht:HANDLE
             FORMAT       = "X(25)"
             SCREEN-VALUE = "DataLogic Procedure:"
             COLUMN       = name:COLUMN IN FRAME prop_sht
             WIDTH        = FONT-TABLE:GET-TEXT-WIDTH("DataLogic Procedure: ")
             ROW          = cur-row + .2.
  /* cur-row = cur-row + .65.*/
            
   CREATE FILL-IN h_Data-Logic_Proc
      ASSIGN FRAME             = FRAME prop_sht:HANDLE
             ROW               = cur-row
             COLUMN            =  h_Data-Logic_Proc_lbl:COL +  h_Data-Logic_Proc_lbl:WIDTH
             HEIGHT            = 1
             WIDTH             = 42
             DATA-TYPE         = "CHARACTER"
             FORMAT            = "X(100)"
             SENSITIVE         = FALSE.
   
   CREATE BUTTON h_Data-Logic_Proc_btn
      ASSIGN FRAME             = FRAME prop_sht:HANDLE
             LABEL             = "Lookup"
             ROW               = cur-row
             COLUMN            =  h_Data-Logic_Proc:COLUMN + h_Data-Logic_Proc:WIDTH
             HEIGHT            = 1.14
             WIDTH             = 5
             SENSITIVE         = TRUE
             TOOLTIP           = IF lisICFRunning THEN "Lookup data logic procedure"
                                                  ELSE "Search for data logic procedure"
        TRIGGERS:
          ON CHOOSE PERSISTENT RUN Data-Logic-Proc-change.
        END TRIGGERS.
   IF lIsICFRUnning THEN
     h_Data-Logic_Proc_btn:LOAD-IMAGE("ry/img/afbinos.gif":U) NO-ERROR.
   ELSE
     h_Data-Logic_Proc_btn:LOAD-IMAGE-UP({&ADEICON-DIR} + "open":U) NO-ERROR.
    

   ASSIGN stupid   = h_Data-Logic_Proc_btn:MOVE-AFTER(last-tab)
          last-tab = h_Data-Logic_Proc_btn.

   CREATE BUTTON h_Data-Logic_Proc_btndel
          ASSIGN FRAME             = FRAME prop_sht:HANDLE
                 LABEL             = "Clear"
                 ROW               = cur-row
                 COLUMN            =  h_Data-Logic_Proc_btn:COL +  h_Data-Logic_Proc_btn:WIDTH + .45
                 HEIGHT            = 1.14
                 WIDTH             = 5
                 SENSITIVE         = TRUE
                 TOOLTIP           = "Clear data logic procedure"
           TRIGGERS:
             ON CHOOSE PERSISTENT RUN Data-Logic-Proc-Clear.
           END TRIGGERS.
   
   IF lIsICFRUnning THEN
     h_Data-Logic_Proc_btnDel:LOAD-IMAGE("ry/img/objectcancel.bmp":U) NO-ERROR.
   ELSE
     h_Data-Logic_Proc_btndel:LOAD-IMAGE-UP({&ADEICON-DIR} + "del-au":U) NO-ERROR.
   

   ASSIGN stupid   = h_Data-Logic_Proc_btnDel:MOVE-AFTER(last-tab)
          last-tab = h_Data-Logic_Proc_btnDel
          cur-row  = cur-row + 1.2.   
   
   
   IF lisICFRunning AND _C._DATA-LOGIC-PROC = "" AND _P.Static_object = NO THEN
   DO: 
       IF DYNAMIC-FUNCTION("cacheObjectOnClient":U IN gshRepositoryManager,
                       INPUT _P.object_filename,
                       INPUT "", /* Get all Result Codes */
                       INPUT "",  /* RunTime Attributes not applicable in design mode */
                       INPUT YES  /* Design Mode is yes */
                  )  THEN
       ASSIGN 
         hObjectBuffer    = DYNAMIC-FUNC("getCacheObjectBuffer":U IN gshRepositoryManager, INPUT ?)
         hAttributeBuffer = hObjectBuffer:BUFFER-FIELD("tClassBufferHandle":U):BUFFER-VALUE
         cDataLogicProc = hAttributeBuffer:BUFFER-FIELD("DataLogicProcedure":U):BUFFER-VALUE
       NO-ERROR.
   END.
   ELSE IF _C._DATA-LOGIC-PROC <> ? AND _C._DATA-LOGIC-PROC <> "" THEN
   DO:
       RUN adecomm/_relname.p (_C._DATA-LOGIC-PROC, "",OUTPUT cDataLogicProc).
   END.
   ELSE IF _P.Static_object = YES  THEN
   DO:
      /* For backward compatibility, check the definitions section */
      RUN adeuib/_accsect.p("GET":U, ?, "DEFINITIONS":U, INPUT-OUTPUT iRecID, INPUT-OUTPUT cDefCode ).
      
      /* Get the DATA-LOGIC-PROCEDURE line from the definitions sesction */
      ASSIGN iStart     = INDEX(cDefCode,"&GLOB DATA-LOGIC-PROCEDURE":U)
             iStart     = IF iStart = 0 
                          THEN INDEX(cDefCode,"&GLOBAL-DEFINE DATA-LOGIC-PROCEDURE":U)
                          ELSE iStart
             iEnd       = IF iStart > 0 
                          THEN INDEX(cDefCode,".p":U, iStart)
                          ELSE 0
             iEnd       = IF iEnd = 0  
                          THEN INDEX(cDefCode,CHR(10), iStart)
                          ELSE iEnd
             cLine      = IF iStart > 0 AND iEnd > 0 
                          THEN  SUBSTRING(cDefCode, iStart, iEnd - iStart + 2)
                          ELSE ""
         cDataLogicProc = IF cLine > ""
                          THEN  TRIM(SUBSTRING(cLine,R-INDEX(cline," ":U)))
                          ELSE ""
     NO-ERROR.
   END.

   ASSIGN h_Data-Logic_Proc:SCREEN-VALUE   = cDataLogicProc.
   IF FONT-TABLE:GET-TEXT-WIDTH(cDataLogicProc) > h_Data-Logic_Proc:WIDTH THEN
       h_Data-Logic_Proc:TOOLTIP   = cDataLogicProc.
   

END PROCEDURE.


PROCEDURE Data-logic-Proc-change:
/* ***********************************************************
   Purpose: Lookup dialog call for Dynamics data logic 
            procedure when the lookup button is choosen
*************************************************************/
 DEFINE VARIABLE cFilename     AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE lOK           AS LOGICAL    NO-UNDO.
 DEFINE VARIABLE hObjectBuffer AS HANDLE     NO-UNDO.

 ASSIGN CURRENT-WINDOW:PRIVATE-DATA = STRING(THIS-PROCEDURE).
 IF lisICFRunning THEN
 DO:
   RUN adecomm/_setcurs.p ("WAIT":U).
   RUN ry/obj/gopendialog.w (INPUT CURRENT-WINDOW,
                             INPUT "",
                             INPUT No,
                             INPUT "Get Object",
                             OUTPUT cFilename,
                             OUTPUT lok).
   RUN adecomm/_setcurs.p ("":U).
   IF lOK THEN
   DO:
      IF DYNAMIC-FUNCTION("cacheObjectOnClient":U IN gshRepositoryManager,
                             INPUT cFilename,
                             INPUT "", /* Get all Result Codes */
                             INPUT "",  /* RunTime Attributes not applicable  */
                             INPUT YES  /* Design Mode is yes */
                        )  THEN
      DO:
         ASSIGN hObjectBuffer = DYNAMIC-FUNC("getCacheObjectBuffer":U IN gshRepositoryManager, INPUT ?).
         IF (_P.static_object = NO AND DYNAMIC-FUNCTION("classisA":U IN gshRepositoryManager, hObjectBuffer:BUFFER-FIELD("tClassName":U):BUFFER-VALUE, "DLProc":U))
            OR (_P.static_object = YES AND DYNAMIC-FUNCTION("classisA":U IN gshRepositoryManager, hObjectBuffer:BUFFER-FIELD("tClassName":U):BUFFER-VALUE, "Procedure":U))
         THEN ASSIGN  h_Data-Logic_Proc:SCREEN-VALUE   = hObjectBuffer:BUFFER-FIELD("tObjectPathedFileName":U):BUFFER-VALUE
                      h_Data-Logic_Proc:MODIFIED       = YES.
                      
      END.
   END.
 END.
 ELSE DO:
    ASSIGN cFileName = TRIM(h_Data-Logic_Proc:SCREEN-VALUE).
  
    RUN adecomm/_opnfile.w 
                ("Choose a logic procedure",
                 "Logic Files (*.p), All Files (*.*)",
                 INPUT-OUTPUT cFileName).
  
    IF cFileName <> "":U THEN
      ASSIGN  h_Data-Logic_Proc:SCREEN-VALUE = REPLACE(cFileName,"~\","/")
              h_Data-Logic_Proc:MODIFIED = YES.
 END.


END PROCEDURE.

PROCEDURE Data-logic-Proc-Clear:
/* ***********************************************************
   Purpose: Clear Progress Dynamics data logic procedure 
*************************************************************/
   ASSIGN
     h_Data-Logic_Proc:SCREEN-VALUE = ""
     h_Data-Logic_Proc:MODIFIED     = YES.

END PROCEDURE.


PROCEDURE final_adjustments:
  DO WITH FRAME prop_sht:
    /* Put the Advanced... button in the bottom row with OK & Cancel */
    ASSIGN btn_adv:ROW             = btn_Cancel:ROW
           btn_adv:COL             = btn_Cancel:COL + btn_Cancel:WIDTH + 4
           stupid                  = btn_adv:MOVE-AFTER(btn_cancel:HANDLE) IN FRAME prop_sht
           FRAME prop_sht:DEFAULT-BUTTON = btn_OK:HANDLE IN FRAME prop_sht
           cur-row                 = cur-row + {&IVM_OKBOX} - .2
           adjust                  = frame prop_sht:HEIGHT - cur-row - 2.25
           btn_ok:ROW              = btn_ok:ROW - adjust
           btn_cancel:ROW          = btn_cancel:ROW - adjust
           btn_help:ROW            = btn_help:ROW - adjust
           btn_adv:ROW             = btn_adv:ROW - adjust
           FRAME prop_sht:HEIGHT   = frame prop_sht:HEIGHT - adjust
           FRAME prop_sht:HIDDEN   = FALSE.

  END.  /* DO WITH FRAME prop_sht */
END.  /* PROCEDURE final_adjustments */

/* freeform_setup: Removes query amd fields buttons enlargens the query    */
/*                 editor box                                              */
PROCEDURE freeform_setup.
  ASSIGN h_btn_mdfy:SENSITIVE = FALSE
         h_query:SCREEN-VALUE = "Freeform Query:" + CHR(10) +
                                  "  Use Code Section Editor to modify.".
END. /* Procedure freeform_setup */

PROCEDURE sensitize.
  DEF VAR h         AS HANDLE  NO-UNDO.
  DEF VAR i         AS INTEGER NO-UNDO.  
  DEF VAR local_var AS LOGICAL NO-UNDO.
  DEF VAR start-y   AS INTEGER NO-UNDO.    
  
    ASSIGN name:SENSITIVE IN FRAME prop_sht = TRUE.
    IF h_query              NE ? THEN ASSIGN h_query:SENSITIVE              = TRUE.
    IF h_btn_mdfy           NE ? THEN ASSIGN h_btn_mdfy:SENSITIVE = 
                              NOT CAN-FIND(_TRG WHERE _TRG._wRECID = RECID(_U) AND
                                           _TRG._tEVENT = "OPEN_QUERY":U).
    IF h_btn_flds           NE ? THEN ASSIGN h_btn_flds:SENSITIVE = YES.
    IF h_btn_mdfy NE ? AND h_btn_mdfy:SENSITIVE = FALSE THEN 
      RUN freeform_setup.
END.  /* Procedure sensitize */

procedure set_tab_order.
  /* Tab orders */
  ASSIGN stupid   = btn_adv:MOVE-AFTER(last-tab) IN FRAME prop_sht.
END PROCEDURE. /* set_tab_order */

/* Dynamics only - Used to filter the open object dialog to DLProc types from gopendialog.w*/
FUNCTION getOpenObjectFilter RETURNS CHARACTER
  ( ) :
  
  IF AVAILABLE _P AND lisICFRunning THEN
  DO:
     IF _P.static_object = YES THEN
        RETURN REPLACE(DYNAMIC-FUNCTION("getClassChildrenFromDB":U IN gshRepositoryManager, 
                                 INPUT "Procedure,DLProc":U),CHR(3),",":U).
     ELSE
        RETURN  REPLACE(DYNAMIC-FUNCTION("getClassChildrenFromDB":U IN gshRepositoryManager, 
                                 INPUT "DLProc":U),CHR(3),",":U).

  END.
END FUNCTION.
