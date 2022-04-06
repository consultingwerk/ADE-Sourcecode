/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
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
/** Contains definitions for dynamics design-time temp-tables. **/
{destdefi.i}


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
DEFINE VARIABLE h_no_undo         AS WIDGET-HANDLE           NO-UNDO.
DEFINE VARIABLE h_query           AS WIDGET-HANDLE           NO-UNDO.   
DEFINE VARIABLE h_qry_lbl         AS WIDGET-HANDLE           NO-UNDO.   

DEFINE VARIABLE cur-row           AS DECIMAL DECIMALS 2      NO-UNDO.
DEFINE VARIABLE sav-qry           AS CHARACTER INITIAL ? NO-UNDO. /* Query editor       */

DEFINE VARIABLE isSmartData       AS LOGICAL INITIAL NO NO-UNDO.
DEFINE VARIABLE isWebObject       AS LOGICAL INITIAL NO NO-UNDO.
/* Dynamics specific variables */
DEFINE VARIABLE h_Data-Logic_Proc_lbl    AS HANDLE     NO-UNDO.
DEFINE VARIABLE h_Data-Logic_Proc        AS HANDLE     NO-UNDO.
DEFINE VARIABLE h_Data-Logic_Proc_btn    AS HANDLE     NO-UNDO.
DEFINE VARIABLE h_Data-Logic_Proc_btn2   AS HANDLE     NO-UNDO.
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
DEFINE VARIABLE lContainsLOB             AS LOGICAL    NO-UNDO.
DEFINE VARIABLE lDynamic                 AS LOGICAL    NO-UNDO.
define variable frameTitle               as character no-undo.
define variable closeWindow              as logical no-undo.
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
    
    IF _DynamicsIsRunning AND DYNAMIC-FUNCTION("ClassIsA" IN gshRepositoryManager, _P.object_type_code, "DynSDO":U) THEN
      lDynamic = TRUE.
    
    IF NOT lDynamic THEN 
      RUN checkLOBs.
    
    IF NOT RETRY THEN DO:
      DEFINE FRAME prop_sht
             name         AT ROW 1.13  COL 11 COLON-ALIGNED {&STDPH_FILL}
             btn_adv      AT ROW 19    COL 50         
           WITH 
           &if defined(IDE-IS-RUNNING) = 0 &then
           VIEW-AS DIALOG-BOX 
           &else
           no-box
           &endif
           SIDE-LABELS SIZE 95 BY 22 THREE-D.
    
      {adeuib/ide/dialoginit.i "frame prop_sht:handle"}
      &if defined(IDE-IS-RUNNING) <> 0 &then
      dialogService:View().
      &endif
      RUN adjust_frame.
      
      /* *************************** Generate Needed Widgets ************************** */
    
      /* Set up the stuff at the top of the property sheet --- NON-toggle stuff         */
      RUN create_smartData_stuff.
      RUN set_tab_order.
    
      {adecomm/okbar.i &FRAME-NAME = prop_sht}
      RUN final_adjustments.
    END.  /* IF NOT RETRY */
    
    ON WINDOW-CLOSE OF FRAME prop_sht DO:
       &if DEFINED(IDE-IS-RUNNING) = 0  &then
         APPLY "END-ERROR":U TO SELF.
       &else 
         closeWindow = true.
         APPLY "U2" to this-procedure.
       &endif
    end.
    
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
             &if defined(IDE-IS-RUNNING) = 0 &then
                   FRAME prop_sht:TITLE = "Property Sheet - " 
                                        + IF isSmartData THEN _P._TYPE ELSE "" + " " + _U._NAME
             &endif
                   .
          END.
          ELSE RETURN NO-APPLY.
        END.
    END.
    
    ON CHOOSE OF btn_adv DO:
       run choose_advanced.
    END.
    
    IF SESSION:WIDTH-PIXELS = 640 AND SESSION:PIXELS-PER-COLUMN = 8 THEN
    ASSIGN FRAME prop_sht:X = 0 - CURRENT-WINDOW:X 
           FRAME prop_sht:Y = 0 - CURRENT-WINDOW:Y.
           
    RUN sensitize.
    
    RUN adecomm/_setcurs.p ("").
    
    &scoped-define CANCEL-EVENT U2    
    {adeuib/ide/dialogstart.i  btn_ok btn_cancel frameTitle}
   
    &if DEFINED(IDE-IS-RUNNING) = 0  &then
        WAIT-FOR "GO" OF FRAME prop_sht. 
    &ELSE
        WAIT-FOR "GO" OF FRAME prop_sht or "u2" of this-procedure.       
        if cancelDialog or closeWindow THEN UNDO, LEAVE.  
    &endif
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
    IF NOT lDynamic THEN
      ASSIGN _C._RowObject-NO-UNDO = LOGICAL(h_No_Undo:SCREEN-VALUE).
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

procedure choose_advanced:
   &if defined(IDE-IS-RUNNING) <> 0 &then
      dialogService:SetCurrentEvent(this-procedure,"do_choose_advanced").
      run runChildDialog in hOEIDEService (dialogService).
   &else
      run do_choose_advanced.
   &endif 
end procedure.

procedure do_choose_advanced:
    &if defined(IDE-IS-RUNNING) <> 0 &then
    
        RUN adeuib/ide/_dialog_advdprp.p (RECID(_U), lbl_wdth).
    &else
        RUN adeuib/_advdprp.w (RECID(_U), lbl_wdth).
    
    &endif 
    APPLY "ENTRY" TO btn_OK IN FRAME prop_sht.

end procedure.

procedure field_edit.
  &if defined(IDE-IS-RUNNING) <> 0 &then
      dialogService:SetCurrentEvent(this-procedure,"do_field_edit").
      run runChildDialog in hOEIDEService (dialogService).
  &else
      run do_field_edit.      
  &endif

end procedure.

procedure do_field_edit.
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

  /* adeuib/_coledit reuires a valid DICTDB, if it is unknow, set it to the
     1st connected DB    IZ 10235                                          */
  IF LDBNAME("DICTDB") = ? AND NUM-DBS > 0 THEN
    create alias "DICTDB" for database value(ldbname(1)).

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
  &if defined(IDE-IS-RUNNING) <> 0 &then
      RUN adeuib/ide/_dialog_coledit.p (INPUT table-list,INPUT ?).
  &else
      /* Send over the table list or a handle to the SmartData */
      RUN adeuib/_coledit.p (INPUT table-list,INPUT ?).
  &endif 
  RUN checkLOBs.
  
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

  &if defined(IDE-IS-RUNNING) <> 0 &then
      dialogService:SetCurrentEvent(this-procedure,"do_query_modify").
      run runChildDialog in hOEIDEService (dialogService).
  &else
      run do_query_modify.      
  &endif
END.

procedure do_query_modify:
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
end.    


procedure adjust_frame.
  ASSIGN FRAME prop_sht:HIDDEN     = TRUE 
     &if defined(IDE-IS-RUNNING) = 0 &then
         FRAME prop_sht:PARENT     = ACTIVE-WINDOW
         FRAME prop_sht:TITLE      = "Property Sheet - " + _U._NAME
     &else
         frameTitle                = "Property Sheet - " + _U._NAME    
     &endif    
         last-tab                  = name:HANDLE IN FRAME prop_sht
         name:SENSITIVE IN FRAME prop_sht = TRUE
         name:SCREEN-VALUE         = _U._NAME
         btn_adv:SENSITIVE         = TRUE
         cur-row                   = name:ROW + 1.2.
END PROCEDURE.  /* adjust_frame */ 

PROCEDURE checkLOBs.
  lContainsLOB = FALSE.
  CheckForLOB:
  FOR EACH _BC WHERE _BC._x-recid = RECID(_U):
    IF LOOKUP(_BC._DATA-TYPE, "CLOB,BLOB":U) > 0 THEN
    DO:
      lContainsLOB = TRUE.
      LEAVE CheckForLOB.
    END.
  END.  /* for each _BC */
  IF VALID-HANDLE(h_No_Undo) THEN
  DO:
    ASSIGN h_No_Undo:SENSITIVE    = NOT lContainsLOB.
    IF lContainsLOB THEN h_No_Undo:SCREEN-VALUE = "YES":U.
  END.
END PROCEDURE. /* checkLOBs */

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
             FORMAT       = "X(5)"
             SCREEN-VALUE = "DLP:"
             WIDTH        = FONT-TABLE:GET-TEXT-WIDTH("DLP: ")
             TOOLTIP      = "Data Logic Procedure"
             ROW          = cur-row + .2
             COL          =  h_query:COL - h_Data-Logic_Proc_lbl:WIDTH.
  /* cur-row = cur-row + .65.*/
            
   CREATE FILL-IN h_Data-Logic_Proc
      ASSIGN FRAME             = FRAME prop_sht:HANDLE
             ROW               = cur-row
             COLUMN            =  h_query:COL
             HEIGHT            = 1
             WIDTH             = 58
             DATA-TYPE         = "CHARACTER"
             FORMAT            = "X(100)"
             TOOLTIP           = "Data Logic Procedure"
             SIDE-LABEL-HANDLE = h_Data-Logic_Proc_lbl
             SENSITIVE         = FALSE.
   
   CREATE BUTTON h_Data-Logic_Proc_btn
      ASSIGN FRAME             = FRAME prop_sht:HANDLE
             LABEL             = "Lookup"
             ROW               = cur-row
             COLUMN            =  h_Data-Logic_Proc:COLUMN + h_Data-Logic_Proc:WIDTH + .2
             HEIGHT            = 1.14
             WIDTH             = 5
             SENSITIVE         = TRUE
             TOOLTIP           = IF _DynamicsIsRunning THEN "Lookup data logic procedure"
                                                  ELSE "Search for data logic procedure"
        TRIGGERS:
          ON CHOOSE PERSISTENT RUN Data-Logic-Proc-change("Lookup":U).
        END TRIGGERS.

   CREATE BUTTON h_Data-Logic_Proc_btn2
      ASSIGN FRAME             = FRAME prop_sht:HANDLE
             LABEL             = "Search"
             ROW               = cur-row
             COLUMN            =  h_Data-Logic_Proc_btn:COLUMN + h_Data-Logic_Proc_btn:WIDTH
             HEIGHT            = 1.14
             WIDTH             = 5
             HIDDEN            = IF _DynamicsIsRUnning THEN FALSE ELSE TRUE
             SENSITIVE         = IF _DynamicsIsRunning THEN TRUE ELSE FALSE
             TOOLTIP           =  "Search for data logic procedure"
        TRIGGERS:
          ON CHOOSE PERSISTENT RUN Data-Logic-Proc-change ("Search":U).
        END TRIGGERS.

   IF _DynamicsIsRunning THEN
     h_Data-Logic_Proc_btn:LOAD-IMAGE("ry/img/afbinos.gif":U) NO-ERROR.
   ELSE
     h_Data-Logic_Proc_btn:LOAD-IMAGE-UP({&ADEICON-DIR} + "open":U) NO-ERROR.

   h_Data-Logic_Proc_btn2:LOAD-IMAGE-UP({&ADEICON-DIR} + "open":U) NO-ERROR. 

   ASSIGN stupid   = h_Data-Logic_Proc_btn:MOVE-AFTER(last-tab)
          last-tab = h_Data-Logic_Proc_btn.

   CREATE BUTTON h_Data-Logic_Proc_btndel
          ASSIGN FRAME             = FRAME prop_sht:HANDLE
                 LABEL             = "Clear"
                 ROW               = cur-row
                 COLUMN            =  IF _DynamicsIsRunning 
                                      THEN h_Data-Logic_Proc_btn2:COL +  h_Data-Logic_Proc_btn2:WIDTH 
                                      ELSE h_Data-Logic_Proc_btn:COL +  h_Data-Logic_Proc_btn:WIDTH 
                 HEIGHT            = 1.14
                 WIDTH             = 5
                 SENSITIVE         = TRUE
                 TOOLTIP           = "Clear data logic procedure"
           TRIGGERS:
             ON CHOOSE PERSISTENT RUN Data-Logic-Proc-Clear.
           END TRIGGERS.
   
    h_Data-Logic_Proc_btndel:LOAD-IMAGE-UP({&ADEICON-DIR} + "del-au":U) NO-ERROR.
   

   ASSIGN stupid   = h_Data-Logic_Proc_btnDel:MOVE-AFTER(last-tab)
          last-tab = h_Data-Logic_Proc_btnDel
          cur-row  = cur-row + 1.2.   
   
   cDataLogicProc = "".
   IF _C._DATA-LOGIC-PROC <> ? AND _C._DATA-LOGIC-PROC <> "" THEN
       RUN adecomm/_relname.p (_C._DATA-LOGIC-PROC, "",OUTPUT cDataLogicProc).
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
   
   IF NOT lDynamic THEN
   DO:
     CREATE TOGGLE-BOX h_no_Undo
       ASSIGN
         FRAME        = FRAME prop_sht:HANDLE
         LABEL        = "Use NO-UNDO for RowObject"
         ROW          = cur-row
         COLUMN       = h_query:COL
         HEIGHT       = .81
         WIDTH        = 35
         SENSITIVE    = NOT lContainsLOB
         SCREEN-VALUE = STRING(_C._RowObject-NO-UNDO).

     ASSIGN cur-row = cur-row + 1.2.
   END.  /* if not dynamic SDO */

END PROCEDURE.


PROCEDURE Data-logic-Proc-change:
/* ***********************************************************
   Purpose: Lookup dialog call for Dynamics data logic 
            procedure when the lookup button is choosen
*************************************************************/
 DEFINE INPUT  PARAMETER pcType    AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cFilename         AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE lOK               AS LOGICAL    NO-UNDO.
 DEFINE VARIABLE cPathedFilename   AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE hRepDesManager    AS HANDLE     NO-UNDO.
 DEFINE VARIABLE cCalcRelativePath AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cCalcRootDir      AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cCalcRelPathSCM   AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cCalcFullPath     AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cCalcObject       AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cCalcFile         AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cCalcError        AS CHARACTER  NO-UNDO.
 

 ASSIGN CURRENT-WINDOW:PRIVATE-DATA = STRING(THIS-PROCEDURE).
 IF pcType= "Lookup":U AND _DynamicsIsRunning THEN
 DO:
   RUN adecomm/_setcurs.p ("WAIT":U).
   RUN adeuib/_opendialog.w (INPUT CURRENT-WINDOW,
                             INPUT "",
                             INPUT No,
                             INPUT "Get Object",
                             OUTPUT cFilename,
                             OUTPUT lok).
   RUN adecomm/_setcurs.p ("":U).
   IF lOK THEN
   DO:
      hRepDesManager = DYNAMIC-FUNCTION("getManagerHandle":U, INPUT "RepositoryDesignManager":U).
      /* Retrieve the objects for the specified object  */
      RUN retrieveDesignObject IN hRepDesManager ( INPUT  cFilename,
                                                   INPUT  "",  /* Get default result Code */
                                                   OUTPUT TABLE ttObject ,
                                                   OUTPUT TABLE ttPage,
                                                   OUTPUT TABLE ttLink,
                                                   OUTPUT TABLE ttUiEvent,
                                                   OUTPUT TABLE ttObjectAttribute ) NO-ERROR.  
      FIND FIRST ttObject WHERE ttObject.tLogicalObjectname       = cFilename 
                            AND ttObject.tContainerSmartObjectObj = 0 NO-ERROR.
      IF AVAIL ttObject THEN
      DO:
         /* Get relative directory of specified object */ 
         RUN calculateObjectPaths IN gshRepositoryManager
                            (cFilename,  /* ObjectName */          0.0, /* Object Obj */      
                             "",  /* Object Type */         "",  /* Product Module Code */
                             "", /* Param */                "",
                             OUTPUT cCalcRootDir,           OUTPUT cCalcRelativePath,
                             OUTPUT cCalcRelPathSCM,        OUTPUT cCalcFullPath,
                             OUTPUT cCalcObject,            OUTPUT cCalcFile,
                             OUTPUT cCalcError).
         IF cCalcRelPathSCM > "" THEN
            cCalcRelativePath = cCalcRelPathSCM.
         ASSIGN cPathedFilename = cCalcRelativePath + (IF cCalcRelativePath = "" then "" ELSE "/":U )
                                                    + cCalcFile .
         IF (_P.static_object = NO AND DYNAMIC-FUNCTION("classisA":U IN gshRepositoryManager, ttObject.tClassname, "DLProc":U))
            OR (_P.static_object = YES AND (DYNAMIC-FUNCTION("classisA":U IN gshRepositoryManager, ttObject.tClassname, "Procedure":U)
                                            OR DYNAMIC-FUNCTION("classisA":U IN gshRepositoryManager, ttObject.tClassname, "DLProc":U)))
         THEN ASSIGN  h_Data-Logic_Proc:SCREEN-VALUE   = cPathedFilename
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
  
  IF AVAILABLE _P AND _DynamicsIsRunning THEN
  DO:
     IF _P.static_object = YES THEN
        RETURN REPLACE(DYNAMIC-FUNCTION("getClassChildrenFromDB":U IN gshRepositoryManager, 
                                 INPUT "Procedure,DLProc":U),CHR(3),",":U).
     ELSE
        RETURN  REPLACE(DYNAMIC-FUNCTION("getClassChildrenFromDB":U IN gshRepositoryManager, 
                                 INPUT "DLProc":U),CHR(3),",":U).

  END.
END FUNCTION.
