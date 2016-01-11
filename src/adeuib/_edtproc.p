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

File: _edtproc.p

Description:
    Procedure to show the Procedure Settings property sheet.

Input Parameters:
    ph_win: The handle of the window for the current procedure (this
            should be the same as _h_win.)

Output Parameters:
   <None>

Author: D. Ross Hunter, Gerry Seidl, Wm.T.Wood

Date Created: 1995

Modified on 10/24/96 gfs - Removed text from image buttons and added tooltips
            01/09/97 gfs - Added db check for temp-table button selection 
            01/01/98 slk - Removed External Tables for SmartData
	                         Removed External Tables for all ADM2 objects
            08/08/00 jep - Assign _P recid to newly created _TRG records.
----------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER ph_win   AS WIDGET                            NO-UNDO.

&SCOPED-DEFINE USE-3D           YES
&GLOBAL-DEFINE WIN95-BTN        YES

{adecomm/adestds.i}             /* Standards for "Sullivan Look"            */
{adeuib/uniwidg.i}              /* Universal widget definition              */
{adeuib/layout.i}               /* Definitions of the layout records        */
{adeuib/property.i}             /* Temp-Table containing attribute info     */
{adeuib/custwidg.i}             /* Temp-Table for PALETTE (and CUSTOM)      */
{adeuib/triggers.i}             /* Temp-Table for _TRG code records.        */
{adeuib/uibhlp.i}               /* Help pre-processor directives            */
{adecomm/adefext.i}             /* Standard ADE file extensions             */
{adeuib/sharvars.i}             /* UIB shared variables                     */
{adecomm/appserv.i}             /* Appserver Service things                 */

&IF DEFINED(ADEICONDIR) = 0 &THEN
 {adecomm/icondir.i}
&ENDIF

&SCOPED-DEFINE FRAME-NAME f_proc_sht
&SCOPED-DEFINE NOT-WEB-OPTIONS OCX-file compile-into txt_tbls xTables btn_xTables txt_attrs b_adv tg_persist _P._app-srv-aware _P._partition

DEFINE BUFFER      x_U FOR _U.
DEFINE BUFFER      x_C FOR _C.
DEFINE BUFFER      x_L FOR _L.

/* Checked as necessary */
DEFINE BUTTON    btn_libraries    IMAGE-UP FILE {&ADEICON-DIR} + "methlibs" + "{&BITMAP-EXT}" FROM X 0 Y 0 
                                  IMAGE-SIZE-P 28 BY 28 LABEL "&Method". 
DEFINE BUTTON    btn_xTables      LABEL "&Tables..." SIZE 15 BY 1.125.  
DEFINE BUTTON    b_adv            LABEL "&Advanced..."  SIZE 15 BY 1.125.

DEFINE RECTANGLE rect-pal         SIZE .18 BY 3   NO-FILL EDGE-PIXELS 3 FGC 1.

DEFINE VARIABLE adjust            AS DECIMAL DECIMALS 2      NO-UNDO.
DEFINE VARIABLE compile-into      AS CHAR    FORMAT "X(256)" NO-UNDO.
DEFINE VARIABLE cTemp             AS CHAR    FORMAT "X(256)" NO-UNDO.
DEFINE VARIABLE cur-row           AS DECIMAL DECIMALS 2      NO-UNDO.
DEFINE VARIABLE broker_url        AS CHAR    FORMAT "X(256)" NO-UNDO.
DEFINE VARIABLE OCX-file          AS CHAR    FORMAT "X(256)" NO-UNDO.
DEFINE VARIABLE save_name         AS CHAR    FORMAT "X(256)" NO-UNDO.
DEFINE VARIABLE short_name        AS CHAR    FORMAT "X(256)" NO-UNDO.

DEFINE VARIABLE l_can-run         AS LOGICAL NO-UNDO.
DEFINE VARIABLE l_OCX-file        AS LOGICAL NO-UNDO.

DEFINE VARIABLE lNewTitle         AS LOGICAL NO-UNDO.  
DEFINE VARIABLE lPagesEditted     AS LOGICAL NO-UNDO.  
DEFINE VARIABLE stupid            AS LOGICAL NO-UNDO.  /* Error catcher for methods */
DEFINE VARIABLE tg_persist        AS LOGICAL LABEL "Run &Persistent from AppBuilder" 
                                  VIEW-AS TOGGLE-BOX NO-UNDO.
DEFINE VARIABLE icon-hp           AS INTEGER                 NO-UNDO.
DEFINE VARIABLE icon-wp           AS INTEGER                 NO-UNDO.

DEFINE VARIABLE xTables           AS CHAR NO-UNDO.
DEFINE VARIABLE proc-type         AS CHAR NO-UNDO.
DEFINE VARIABLE txt_attrs         AS CHAR VIEW-AS TEXT SIZE 64 BY .77 FORMAT "X(40)".
DEFINE VARIABLE txt_tbls          AS CHAR VIEW-AS TEXT SIZE 64 BY .77 FORMAT "X(40)".

DEFINE VARIABLE last-tab          AS WIDGET-HANDLE           NO-UNDO.
DEFINE VARIABLE h_btn_link        AS WIDGET-HANDLE           NO-UNDO.
DEFINE VARIABLE h_btn_pproc       AS WIDGET-HANDLE           NO-UNDO.
DEFINE VARIABLE h_btn_pages       AS WIDGET-HANDLE           NO-UNDO.
DEFINE VARIABLE h_btn_ttbls       AS WIDGET-HANDLE           NO-UNDO.
DEFINE VARIABLE h_btn_userfields  AS WIDGET-HANDLE           NO-UNDO.
DEFINE VARIABLE h_side_label      AS WIDGET-HANDLE           NO-UNDO.

DEFINE VARIABLE isSmartData	      AS LOGICAL NO-UNDO.
DEFINE VARIABLE isWebObject       AS LOGICAL NO-UNDO.

/* Preprocessor Variables for the Combo-Boxes */
&Scope Dflt-OCX Default [same location as file]
&Scope Dflt-Dir Default [same directory as file]
&Scope Cur-Dir  Current Directory
&Scope OtherOpt Other...

CREATE WIDGET-POOL.
 
BIG-TRANS-BLK:
DO ON STOP   UNDO BIG-TRANS-BLK, LEAVE BIG-TRANS-BLK
   ON ERROR  UNDO BIG-TRANS-BLK, LEAVE BIG-TRANS-BLK
   ON ENDKEY UNDO BIG-TRANS-BLK, LEAVE BIG-TRANS-BLK TRANSACTION:
  /* Turn off status messages, otherwise they will appear in the status area of
   * the Design window.  They are turned back on before exiting the procedure */
  STATUS INPUT OFF.

  RUN adecomm/_setcurs.p ("WAIT":U).

  /* Create necessary widgets and initialize with current data                */
  FIND _U WHERE _U._HANDLE eq ph_win.
  FIND _P WHERE _P._u-recid eq RECID(_U).
  FIND _L WHERE RECID(_L) eq _U._lo-recid.
  FIND _C WHERE RECID(_C) eq _U._x-recid.

  ASSIGN isSmartData     = (_P._adm-version >= "ADM2":U)
                            AND NOT CAN-FIND(FIRST x_U
                            WHERE x_U._WINDOW-HANDLE = ph_win AND
                                  LOOKUP(x_U._TYPE,"FRAME,DIALOG-BOX":U) > 0)
         _P._partition   = IF isSmartData AND (_P._partition = "")
                             THEN "(None)" ELSE _P._partition.

  ASSIGN isWebObject =  (_P._TYPE BEGINS "WEB":U OR
                         CAN-FIND(FIRST _TRG WHERE _TRG._pRECID   eq RECID(_P) 
                                               AND _TRG._tSECTION eq "_PROCEDURE":U
                                               AND _TRG._tEVENT   eq "process-web-request":U)).
      
  IF NOT RETRY THEN DO:
    DEFINE FRAME {&FRAME-NAME}
         rect-pal          AT ROW 1.13  COL 67.5
         btn_libraries     AT ROW 1.13  COL 68.75    
         proc-type         AT ROW 1.13  COL 13 COLON-ALIGNED
                           FORMAT "X(50)" LABEL "Type" 
                           VIEW-AS FILL-IN SIZE 51 BY 1
         save_name         COLON 13 FORMAT "X(80)" LABEL "File Name"
                           VIEW-AS FILL-IN SIZE 51 BY 1
         broker_url        COLON 13 FORMAT "X(255)" LABEL "Broker URL"
                           VIEW-AS FILL-IN SIZE 51 BY 1
         _P._DESC          COLON 13 LABEL "&Description"
                           VIEW-AS EDITOR SIZE 51 BY 3 SCROLLBAR-VERTICAL
                                   {&STDPH_ED4GL}       
         OCX-file          COLON 13 LABEL "&OCX Binary"
                           VIEW-AS COMBO-BOX SIZE 51 BY 1 
                                   INNER-LINES 2
                                   LIST-ITEMS "{&Dflt-OCX}" ,
                                              "{&OtherOpt}"
         compile-into      COLON 13 LABEL "Compile &in"
                           VIEW-AS COMBO-BOX SIZE 51 BY 1
                                   INNER-LINES 3
                                   LIST-ITEMS "{&Dflt-Dir}" , 
                                              "{&Cur-Dir}" , 
                                              "{&OtherOpt}"
         SKIP ({&VM_WIDG})
         txt_tbls          AT 2 BGC 1 FGC 15 NO-LABEL SKIP(0.1)
         xTables           AT 3 NO-LABEL FORMAT "X(256)"
                           VIEW-AS EDITOR SCROLLBAR-V
                           INNER-CHARS 40 INNER-LINES 2
         btn_xTables       TO 65 SKIP(0.25)
         SKIP ({&VM_WIDG})
         txt_attrs         AT 2   BGC 1 FGC 15 NO-LABEL
         b_adv             AT ROW-OF txt_attrs       COL 71.5
         tg_persist        AT ROW-OF txt_attrs + 1   COL  3
         _P._compile       TO 65 VIEW-AS TOGGLE-BOX LABEL "&Compile Master on Save"
         _P._app-srv-aware AT ROW-OF txt_attrs + 2   COL 3
                              VIEW-AS TOGGLE-BOX LABEL "App&Server Aware"
         _P._partition   VIEW-AS COMBO-BOX SIZE 28.3 BY 1 COLON 36 
                                   FORMAT "X(23)" LABEL "Partition"
       WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER
            SIDE-LABELS SIZE 78 BY 16
            TITLE "Procedure Settings" THREE-D.
    ASSIGN 
         FRAME {&FRAME-NAME}:HIDDEN = TRUE
         FRAME {&FRAME-NAME}:SCROLLABLE = FALSE
         btn_libraries:COLUMN       = IF SESSION:WIDTH-PIXELS > 700 THEN 69.5
                                                                   ELSE 68.75
         txt_tbls:SCREEN-VALUE IN FRAME {&FRAME-NAME}  = " External Tables":L30
         txt_attrs:SCREEN-VALUE IN FRAME {&FRAME-NAME} = " Other Settings":L30
         last-tab                   = _P._compile:HANDLE IN FRAME {&FRAME-NAME}
         cur-row                    = txt_attrs:ROW + 2.1
         /* Don't show the Advanced sheet if it is not a template */
         xTables:READ-ONLY          = YES
         xTables:BGCOLOR            = {&READ-ONLY_BGC}
         xTables:WIDTH              = btn_xTables:COL - 1 - xTables:COL 
         _P._DESC:RETURN-INSERTED   = YES  
         btn_libraries:TOOLTIP      = "Method Libraries"
         _P._partition:HIDDEN       = NOT isSmartData
         _P._partition:DELIMITER    = CHR(3)
         _P._partition:LIST-ITEMS = "(None)":U + CHR(3) +
                       dynamic-function("definedPartitions" IN appSrvUtils)
         .
    

    /* Handle sizing based on screen real estate */
    ASSIGN icon-hp = btn_libraries:HEIGHT-P IN FRAME {&FRAME-NAME}
           icon-wp = btn_libraries:WIDTH-P IN FRAME {&FRAME-NAME}.

    IF SESSION:WINDOW-SYSTEM BEGINS "MS-WIN":u AND
       SESSION:WIDTH-PIXELS = 640 AND SESSION:PIXELS-PER-COLUMN = 6 THEN
      ASSIGN icon-hp = 32
             icon-wp = 34
             FRAME {&FRAME-NAME}:WIDTH = 89 .
    /* *************************** Generate Needed Widgets ************************** */

    /* Set up the stuff at the top of the property sheet --- NON-toggle stuff         */         
    RUN create_top_stuff.

    /* Tab orders */ 
    ASSIGN stupid        = btn_libraries:MOVE-AFTER(last-tab) IN FRAME {&FRAME-NAME}
           last-tab      = btn_libraries:HANDLE IN FRAME {&FRAME-NAME}.
    
    IF h_btn_pproc NE ? THEN
      ASSIGN stupid   = h_btn_pproc:MOVE-AFTER(last-tab)
             last-tab = h_btn_pproc.
    IF h_btn_ttbls NE ? THEN
      ASSIGN stupid   = h_btn_ttbls:MOVE-AFTER(last-tab)
             last-tab = h_btn_ttbls.
    IF h_btn_link NE ? THEN
      ASSIGN stupid   = h_btn_link:MOVE-AFTER(last-tab)
             last-tab = h_btn_link.
    IF h_btn_pages NE ? THEN
      ASSIGN stupid   = h_btn_pages:MOVE-AFTER(last-tab)
             last-tab = h_btn_pages.
    IF h_btn_userfields NE ? THEN
      ASSIGN stupid   = h_btn_userfields:MOVE-AFTER(last-tab)
             last-tab = h_btn_userfields.

    {adecomm/okbar.i}

    ASSIGN b_adv:ROW = btn_cancel:ROW
           b_Adv:COL = btn_cancel:COL + btn_cancel:WIDTH + 4
           stupid    = b_Adv:MOVE-AFTER(btn_cancel:HANDLE)
    .
           
    ASSIGN FRAME {&FRAME-NAME}:DEFAULT-BUTTON = btn_OK:HANDLE IN FRAME {&FRAME-NAME}
           rect-pal:HEIGHT                    = btn_ok:ROW - 2. 

  END.  /* IF NOT RETRY */

  /***********************************************************************/ 
  /****************************** TRIGGERS *******************************/
  /***********************************************************************/

  /* Desensitize _RUN-PERSISTENT if a WINDOW with a shared frame or browse.
     BETTER STILL, if the user sets RUN-PERSISTENT to YES, then we should
     ask if all Shared frames should be reset.  */
  ON VALUE-CHANGED OF tg_persist DO:
    DEFINE VARIABLE choice AS LOGICAL NO-UNDO.
  
    IF SELF:CHECKED THEN DO:
      IF CAN-FIND (FIRST x_U WHERE CAN-DO("FRAME,BROWSE",x_U._TYPE) AND 
                                   x_U._WINDOW-HANDLE = _U._HANDLE  AND
                                   x_U._SHARED)                     THEN
      DO:
        MESSAGE "You cannot Run Persistent if this procedure" skip 
                "contains shared frames or browses." skip
                "Do you want to reset all shared frames and browses?"
                VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE choice.
        IF choice THEN DO:
          FOR EACH x_U WHERE CAN-DO("FRAME,BROWSE",x_U._TYPE) AND 
                             x_U._WINDOW-HANDLE = _U._HANDLE:
            IF x_U._SHARED THEN ASSIGN x_U._SHARED = FALSE.
          END.
        END.
        ELSE DO:
          SELF:CHECKED = NO.
          RETURN NO-APPLY.
        END.
      END.
    END.
  END. 

  ON WINDOW-CLOSE OF FRAME {&FRAME-NAME} APPLY "END-ERROR":U TO SELF.

  ON CHOOSE OF btn_libraries IN FRAME {&FRAME-NAME} DO:
    DEFINE VAR lib-list   AS CHAR     NO-UNDO.
    DEFINE VAR l_ok       AS LOGICAL  NO-UNDO.
    DEFINE VAR l_code     AS CHAR     NO-UNDO.
    
    DO ON STOP  UNDO, LEAVE
       ON ERROR UNDO, LEAVE :
      /* LIB-MGR - Method Library Dialog Box. */
      RUN adeuib/_mldlg.w (INPUT _U._NAME , INPUT STRING(_U._WINDOW-HANDLE) ,
                           OUTPUT lib-list , OUTPUT l_code ,
                           OUTPUT l_ok).
      IF l_OK THEN
      DO:
          FIND _TRG WHERE _TRG._wRECID   = RECID(_U)
                    AND   _TRG._tSECTION = "_CUSTOM"
                    AND   _TRG._tEVENT   = "_INCLUDED-LIB"
                    NO-ERROR.
          IF AVAILABLE _TRG THEN
          DO:
            /* If there's Included Libs, save their code to _TRG. Otherwise,
               delete the existing _TRG record to avoid saving an empty
               Included Libs section in the .w. */
            IF lib-list <> "":U THEN
                ASSIGN _TRG._tCODE = l_code .
            ELSE
                DELETE _TRG.
          END.
          ELSE IF /* NOT AVAILABLE _TRG AND */ lib-list <> "":U THEN
          DO:
            CREATE _TRG.
            ASSIGN _TRG._pRECID   = (IF AVAIL(_P) THEN RECID(_P) ELSE ?)
                   _TRG._wRECID   = RECID(_U)
                   _TRG._tSECTION = "_CUSTOM":U
                   _TRG._tEVENT   = "_INCLUDED-LIB":U
                   _TRG._tCODE    = l_code .
          END.
      END.
    END.
    RETURN.
  END.

  ON CHOOSE OF btn_xTables IN FRAME {&FRAME-NAME} DO:
    DEFINE VAR frst-tbl AS CHARACTER NO-UNDO.
    DEFINE VAR i        AS INTEGER   NO-UNDO.
    DEFINE VAR ldummy   AS LOGICAL   NO-UNDO.
    DEFINE VAR lok      AS LOGICAL   NO-UNDO.
    DEFINE VAR new-list AS CHARACTER NO-UNDO.

    /* Make sure there is a current database */
    IF NUM-DBS = 0 THEN DO:
      RUN adecomm/_dbcnnct.p (
        INPUT "You must have at least one connected database to insert database fields.",
        OUTPUT ldummy).
      if ldummy eq no THEN RETURN.
    END.
  
    /* Edit the list */
    new-list = _P._xTblList.
    RUN adeuib/_xtblist.w (INPUT-OUTPUT new-list).
    IF new-list NE _P._xTblList THEN DO:
      _P._xTblList = new-list.
      RUN show_xTables.
      /* Scan all queries for this procedure and remove all external tables  */
      FOR EACH x_U WHERE x_U._WINDOW-HANDLE = _P._WINDOW-HANDLE AND
                         CAN-DO("FRAME,BROWSE,DIALOG-BOX,QUERY",x_U._TYPE):
        FIND x_C WHERE RECID(x_C) = x_U._x-recid.
        FIND _Q WHERE RECID(_Q) = x_C._q-recid NO-ERROR.
        IF AVAILABLE _Q THEN DO:
          RUN remove-ext-tables(x_C._q-recid,_P._xTblList).
          IF _P._xTblList NE "":U AND NUM-ENTRIES(ENTRY(1,_Q._TblList)," ":U) = 1
          THEN DO:  /* The first non-external table needs to be in the form of
                       tbl of ext-tbl OR tbl where ext-tbl ... */
            frst-tbl = ENTRY(1,_Q._TblList).
            FIND-JOIN:
            REPEAT i = 1 TO NUM-ENTRIES(new-list):
              RUN adecomm/_j-test.p (frst-tbl, ENTRY(1,ENTRY(i,new-list)," ":U),
                                     OUTPUT lok).
              IF NOT lok THEN
                RUN adecomm/_j-test.p (ENTRY(1,ENTRY(i,new-list)," ":U), frst-tbl,
                                       OUTPUT lok).
              IF lok THEN DO:  /* Make the join */
                ENTRY(1,_Q._TblList) = ENTRY(1, _Q._TblList) + " OF ":U +
                                        ENTRY(i,new-list).
                LEAVE FIND-JOIN.             
              END.
            END.  /* FIND-JOIN */
            IF NOT lok THEN DO:  /* No good join was found do a WHERE thingy */
              ENTRY(1,_Q._TblList) = ENTRY(1, _Q._TblList) + " Where ":U +
                                       TRIM(ENTRY(1,new-list)) + " ...":U.
            END.  /* No good join was found */
          END. /* IF first table is not joined to an external table */
        END.  /* IF available _Q */
      END.  /* For each x_U */
    END.  /* IF the list has changed */
  END.

  ON CHOOSE OF btn_help IN FRAME {&FRAME-NAME} OR HELP OF FRAME {&FRAME-NAME} DO:
    
    RUN adecomm/_adehelp.p 
        ( "AB", "CONTEXT", IF isWebObject 
                           THEN {&Procedure_Settings_Web}
                           ELSE {&Procedure_Settings_Dlg_Box}, ? ).
  END.   

  ON CHOOSE OF b_adv
    DO:
      DEF VAR old-title AS CHAR NO-UNDO.
      /* The advanced procedure settings can change the title on the window. */
      old-title = _U._LABEL.
      RUN adeuib/_advpset.w (INPUT RECID(_P)).  
      lNewTitle = (_U._LABEL ne old-title).
      RUN Adjust_Persist.   
      RUN File_Type_Chk.       
      RUN Adjust_Buttons.
  END.
        
  /* Changing compile-into based on user choice. */
  ON VALUE-CHANGED OF compile-into DO:  
    DEF VAR l_OK AS LOGICAL NO-UNDO.
    DEF VAR new-dir AS CHAR NO-UNDO.

    ASSIGN compile-into.
    CASE compile-into:
      WHEN "{&Dflt-Dir}"  THEN _P._compile-into = ?.  
      WHEN "{&Cur-Dir}"   THEN _P._compile-into = ".".
      WHEN "{&OtherOpt}"  THEN DO:
        IF _P._compile-into NE ? THEN new-dir = _compile-into.
        RUN adeshar/_dirname.p 
          ( INPUT        "Compile Into Directory",
                                       /* Dialog Title Bar */
            INPUT        NO,           /* YES is \'s converted to /'s */
            INPUT        YES,          /* YES if file must exist */
            INPUT        "AB",        /* ADE Tool (used for help call) */
            INPUT        {&Other_Compile_Into_Dlg_Box},         
                                       /* Context ID for HELP call */
            INPUT-OUTPUT new-dir ,     /* File Spec entered */
            OUTPUT       l_OK          /* YES if user hits OK */
           ) .   
        IF l_OK THEN ASSIGN _P._compile-into = new-dir 
                             compile-into = new-dir.
        /* Even if they hit cancel in the dialog, we want to return
           the combo-box to a real value, not "Other...". */
                
        IF _P._compile-into eq ? THEN compile-into = "{&Dflt-Dir}".
        ELSE IF _P._compile-into eq "." THEN compile-into = "{&Cur-Dir}".
        ELSE DO:
          compile-into = _P._compile-into.
          IF compile-into:LOOKUP (compile-into) eq 0
          THEN stupid = compile-into:INSERT (compile-into, 3).
        END.  
        &IF "{&WINDOW-SYSTEM}" ne "OSF/Motif" &THEN
        compile-into:INNER-LINES = MIN( 10, compile-into:NUM-ITEMS).
        &ENDIF
        /* Always redisplay the value (If a new file was chosen, it 
           needs to be shown. If the use cancelled, we need to 
           overwrite the "Other..." */             
        compile-into:SCREEN-VALUE = compile-into.
      END.      
      OTHERWISE _P._compile-into = compile-into.
    END CASE.
  END.

  /* Changing OCX-file based on user choice. */
  ON VALUE-CHANGED OF OCX-file DO:
    DEF VAR l_OK        AS LOGICAL NO-UNDO.
    DEF VAR new-file    AS CHAR    NO-UNDO.
    DEF VAR checkFile   AS LOGICAL NO-UNDO INITIAL FALSE.
    DEF VAR binaryState	AS INTEGER NO-UNDO.
    DEF VAR saveDisp    AS CHAR    NO-UNDO.
    DEF VAR saveName    AS CHAR    NO-UNDO.
    
    ASSIGN saveDisp = OCX-file
           saveName = _P._vbx-file
           OCX-file .
    
    CASE   OCX-file:
      WHEN "{&Dflt-OCX}"  THEN _P._vbx-file = ?.  
      WHEN "{&OtherOpt}"  THEN DO:  
        IF _P._vbx-file NE ? THEN
          ASSIGN new-file = _P._vbx-file.
        ELSE IF _P._SAVE-AS-FILE <> ? 
           THEN new-file = substr(_P._SAVE-AS-FILE,
                                  1,
                                  r-index(_P._SAVE-AS-FILE, ".") - 1)
                         + {&STD_EXT_UIB_WVX}.
           ELSE new-file = "".
        RUN adeshar/_filname.p 
          ( INPUT        "OCX Binary File",  /* Dialog Title Bar */
            INPUT        NO,           /* YES is \'s converted to /'s */
            INPUT        NO,           /* YES if file must exist */
            INPUT        'USE-FILENAME':U,         /* Use new-file as default */
            INPUT        "OCX Binary Files (*" + {&STD_EXT_UIB_WVX} + ")", 
                                       /* File Filter (eg. "Include") */
            INPUT        "*" + {&STD_EXT_UIB_WVX},           
                                       /* File Spec  (eg. *.i) */
            INPUT        "AB",        /* ADE Tool (used for help call) */
            INPUT        {&Other_VBX_Binary_Dlg_Box}, 
                                       /* Context ID for HELP call */
            INPUT-OUTPUT new-file ,    /* File Spec entered */
            OUTPUT       l_OK          /* YES if user hits OK */
           ) .   
        IF l_OK THEN ASSIGN
                       _P._vbx-file = new-file
                       checkFile = TRUE.
        /* Even if they hit cancel in the dialog, we want to return
           the combo-box to a real value, not "Other...". */
        IF _P._VBX-FILE eq ? THEN OCX-file = "{&Dflt-OCX}".
        ELSE ASSIGN OCX-file = _P._VBX-FILE.
        IF OCX-file:LOOKUP (OCX-file) eq 0 
        THEN ASSIGN stupid = OCX-file:INSERT(OCX-file, 2)
                    &IF "{&WINDOW-SYSTEM}" ne "OSF/Motif" &THEN
                    OCX-file:INNER-LINES = MIN (10, OCX-file:NUM-ITEMS)
                    &ENDIF
                    .
        /* Always redisplay the value (If a new file was chosen, it 
           needs to be shown. If the use cancelled, we need to 
           overwrite the "Other..." */             
        OCX-file:SCREEN-VALUE = OCX-file.
      END.
      OTHERWISE ASSIGN
                  _P._vbx-file = OCX-file
                  checkFile = true
                .  
    END CASE.
    
    /*
     * If this is a "new" filename, then check to see if it can be used.
     */
    
    IF checkFile AND OCX-file <> ? THEN DO:
      RUN adecomm/_setcurs.p("WAIT":U).
      RUN adeshar/_testbin.p(ph_win, OCX-file, output binaryState).
      
      IF binaryState > 0 THEN DO:
          assign
              OCX-file = saveDisp
              OCX-file:SCREEN-VALUE = OCX-file
              _P._vbx-file = saveName
          .
      END.
      RUN adecomm/_setcurs.p("":U).
    END.
  END.
    
  ON GO OF FRAME {&FRAME-NAME} DO:   
      /* Assign any remaining values (that aren't changed automatically
         when the values change. */
      ASSIGN _P._DESC 
             _P._compile.

      IF isWebObject = NO THEN
      ASSIGN _P._RUN-PERSISTENT = tg_persist:CHECKED
             _P._app-srv-aware  = _P._app-srv-aware:CHECKED
             .
  END.
  
  /***********************************************************************/ 
  /****************************** MAIN CODE ******************************/
  /***********************************************************************/
       
  /* Assign various initial values. */  
  ASSIGN proc-type  = _P._TYPE + IF _P._template THEN " [Template]" ELSE ""
         /* Not all procedures have a compile-into, or a OCX-file */
         l_OCX-file = (OPSYS = "WIN32":u) AND _P._FILE-TYPE = "w"
         l_can-run  = _P._FILE-TYPE <> "i" 
         .
  /* Assign OCX-file and compile location, which are not always used. */
  IF l_OCX-file THEN DO:
    IF _P._VBX-FILE eq ? THEN OCX-file = "{&Dflt-OCX}".
    ELSE ASSIGN OCX-file             = _P._VBX-FILE
                stupid               = OCX-file:INSERT(OCX-file, 2)
                &IF "{&WINDOW-SYSTEM}" ne "OSF/Motif" &THEN
                OCX-file:INNER-LINES = MIN (10, OCX-file:NUM-ITEMS)
                &ENDIF
                . 
  END.
  IF l_can-run THEN DO: 
    /* Get the directories that the palette looks in. */
    RUN Get-Palette-Dirs (OUTPUT cTemp).
    IF cTemp ne "" THEN stupid = compile-into:INSERT (cTemp, 3).
                
    IF _P._compile-into eq ? THEN compile-into = "{&Dflt-Dir}".
    ELSE IF _P._compile-into eq "." THEN compile-into = "{&Cur-Dir}".
    ELSE DO:
      compile-into = _P._compile-into.
      IF compile-into:LOOKUP (compile-into) eq 0
      THEN stupid = compile-into:INSERT (compile-into, 3).
    END.  
    &IF "{&WINDOW-SYSTEM}" ne "OSF/Motif" &THEN
    compile-into:INNER-LINES = MIN( 10, compile-into:NUM-ITEMS).
    &ENDIF
  END.
   
  RUN show_xtables.    
  RUN Sensitize.
  RUN Adjust_Fields.

  /* Shorten display name. If we do, set tooltip to long name. */
  ASSIGN 
    save_name  = _P._SAVE-AS-FILE
    broker_url = (IF _P._Broker-URL NE "" THEN _P._Broker-URL ELSE "").
  IF (save_name <> ?) THEN DO:
      RUN adecomm/_ossfnam.p
          (INPUT save_name,
           INPUT save_name:WIDTH IN FRAME {&FRAME-NAME},
           INPUT save_name:FONT  IN FRAME {&FRAME-NAME},
           OUTPUT short_name).
      IF save_name <> short_name THEN
          ASSIGN save_name:TOOLTIP = save_name
                 save_name         = short_name.
  END.
  IF broker_url EQ "" THEN
    broker_url:VISIBLE IN FRAME {&FRAME-NAME} = FALSE.
  ELSE DO:
      RUN adecomm/_ossfnam.p
          (INPUT broker_url,
           INPUT broker_url:WIDTH IN FRAME {&FRAME-NAME},
           INPUT broker_url:FONT  IN FRAME {&FRAME-NAME},
           OUTPUT short_name).
      IF broker_url <> short_name THEN
          ASSIGN broker_url:TOOLTIP = broker_url
                 broker_url         = short_name.
  END.

  DISPLAY (IF save_name eq ? THEN "Untitled":U ELSE save_name) @ save_name
          broker_url  WHEN _P._Broker-URL NE ""
          _P._DESC    
          OCX-file     WHEN l_OCX-file
          _P._app-srv-aware
      WITH FRAME {&FRAME-NAME}.
  IF l_can-run 
  THEN DISPLAY compile-into _P._compile WITH FRAME {&FRAME-NAME}.

  /* One last adjustment. */
  RUN Adjust_Other.
     
  /* Stop Waiting and show the frame */
  FRAME {&FRAME-NAME}:HIDDEN = no.
  RUN adecomm/_setcurs.p ("").
  
  WAIT-FOR "GO" OF FRAME {&FRAME-NAME}.  
    
  /* Check that any paging information that was changed */
  IF lPagesEditted THEN RUN Check_Page_Change.
  IF isSmartData THEN DO WITH FRAME {&FRAME-NAME}:
    ASSIGN _P._partition.
    IF _P._partition = "(None)" THEN _P._partition = "".
  END.

  /* If the window type has changed, and there is NO-WINDOW then update
     the window title. */
  IF lNewTitle THEN 
    RUN adeuib/_wintitl.p (IF ph_win:TYPE eq "FRAME":U THEN ph_win:PARENT ELSE ph_win, 
                           _U._LABEL, 
                           _U._LABEL-ATTR, 
                           _P._SAVE-AS-FILE).

  RUN adeuib/_winsave.p (_P._WINDOW-HANDLE, FALSE).

END.  /* BIG-TRANS-BLK */

/* Turn status messages back on. (They were turned off at the top of the block */
STATUS INPUT.   
RUN adecomm/_setcurs.p ("").
HIDE FRAME {&FRAME-NAME}.
DELETE WIDGET-POOL.

/* ***************** PERSISTENT TRIGGERS FOR DYNAMIC WIDGETS  **************** */

/* Change the links for objects in THIS-PROCEDURE */
PROCEDURE edit-links:
    RUN adeuib/_linked.w (RECID(_P), RECID(_U)).
END PROCEDURE.

/* Change the "page" information for this procedure */
PROCEDURE edit-pages:
    RUN adeuib/_edtpage.w (RECID(_P)).  
    /* Remember that the user edited pages. */
    lPagesEditted = YES.
END PROCEDURE.

/* Change the names of the preprocessor variables */
PROCEDURE edit-pproc:
  RUN adeuib/_ppvars.w (INPUT-OUTPUT _P._LISTS).
END PROCEDURE.

/* Change the temp-table definitions in THIS-PROCEDURE */
PROCEDURE edit-ttbls:
  DEFINE VARIABLE lDummy       AS LOGICAL                      NO-UNDO.
  
  /* 
   * Check that a at least one database is connected. If not, connect one
   * or abort Add 
   */
  IF NUM-DBS = 0 THEN DO:
    RUN adecomm/_dbcnnct.p (
      INPUT "You must have at least one connected database to create a temp-table definition." ,
      OUTPUT lDummy).
    IF lDummy = NO THEN RETURN.
  END.

  RUN adeuib/_ttmaint.w.
END PROCEDURE.


/* ************************ OTHER INTERNAL PROCEDURES ************************ */

/* Generate the non-toggle attribute widgets           */
PROCEDURE create_top_stuff:        
  DEFINE VARIABLE button_diff AS DECIMAL NO-UNDO.
  
  ASSIGN button_diff = IF isWebObject THEN .25 ELSE .75.

  /* Create all the buttons */
      /* Edit Preprocessor Variables Button */
      CREATE BUTTON h_btn_pproc
           ASSIGN FRAME       = FRAME {&FRAME-NAME}:HANDLE
                  ROW         = btn_libraries:ROW + btn_libraries:HEIGHT + button_diff
                  X           = btn_libraries:X
                  HEIGHT-P    = icon-hp
                  WIDTH-P     = icon-wp
                  SENSITIVE   = TRUE 
                  LABEL       = "C&ustom"
                  TOOLTIP     = "Custom Lists"
           TRIGGERS:
              ON CHOOSE PERSISTENT RUN edit-pproc.
            END TRIGGERS.
            
      ASSIGN stupid = h_btn_pproc:LOAD-IMAGE({&ADEICON-DIR} + "prepsect" +
                                              "{&BITMAP-EXT}",0,0,28,28).
      /* Temp-Table Defintion Button */
      CREATE BUTTON h_btn_ttbls
           ASSIGN FRAME       = FRAME {&FRAME-NAME}:HANDLE
                  ROW         = h_btn_pproc:ROW + h_btn_pproc:HEIGHT + button_diff
                  X           = btn_libraries:X
                  HEIGHT-P    = icon-hp
                  WIDTH-P     = icon-wp
                  SENSITIVE   = TRUE 
                  LABEL       = "&Temp-Tables"
                  TOOLTIP     = "Temp-Table Definitions"
           TRIGGERS:
              ON CHOOSE PERSISTENT RUN edit-ttbls.
            END TRIGGERS.
            
      ASSIGN stupid = h_btn_ttbls:LOAD-IMAGE({&ADEICON-DIR} + "tmptable" +
                                              "{&BITMAP-EXT}",0,0,28,28).
      /* Link Editor Button */
      CREATE BUTTON h_btn_link
           ASSIGN FRAME       = FRAME {&FRAME-NAME}:HANDLE
                  ROW         = h_btn_ttbls:ROW +  h_btn_ttbls:HEIGHT + button_diff
                  X           = btn_libraries:X
                  HEIGHT-P    = icon-hp
                  WIDTH-P     = icon-wp
                  SENSITIVE   = TRUE
                  LABEL       = "Smart&Links"
                  TOOLTIP     = "SmartLinks"
            TRIGGERS:
              ON CHOOSE PERSISTENT RUN edit-links.
            END TRIGGERS.
      ASSIGN stupid = h_btn_link:LOAD-IMAGE({&ADEICON-DIR} + "linkedit" +
                                              "{&BITMAP-EXT}",0,0,28,28).
      /* Pages Button */
      CREATE BUTTON h_btn_pages
           ASSIGN FRAME       = FRAME {&FRAME-NAME}:HANDLE
                  ROW         = h_btn_link:ROW + h_btn_link:HEIGHT + button_diff
                  X           = btn_libraries:X
                  HEIGHT-P    = icon-hp
                  WIDTH-P     = icon-wp
                  SENSITIVE   = TRUE  
                  LABEL       = "Pa&ges"
                  TOOLTIP     = "Pages"
            TRIGGERS:
              ON CHOOSE PERSISTENT RUN edit-pages.
            END TRIGGERS.
      ASSIGN stupid = h_btn_pages:LOAD-IMAGE({&ADEICON-DIR} + "pages" +
                                              "{&BITMAP-EXT}",0,0,28,28).
      /* User Fields Button */
      CREATE BUTTON h_btn_userfields
           ASSIGN FRAME       = FRAME {&FRAME-NAME}:HANDLE
                  ROW         = h_btn_pages:ROW + h_btn_pages:HEIGHT + button_diff
                  X           = btn_libraries:X
                  HEIGHT-P    = icon-hp
                  WIDTH-P     = icon-wp
                  SENSITIVE   = TRUE  
                  LABEL       = "&User Fields"
                  TOOLTIP     = "User Fields"
            TRIGGERS:
              ON CHOOSE PERSISTENT RUN adeuib/_ufmaint.w.
            END TRIGGERS.
      ASSIGN stupid = h_btn_userfields:LOAD-IMAGE({&ADEICON-DIR} + "userflds" +
                                                  "{&BITMAP-EXT}",0,0,28,28).
END. /* PROCEDURE create_top_stuff */

PROCEDURE sensitize:
  RUN File_Type_Chk.     
  ENABLE btn_libraries  b_adv
         _P._DESC
    WITH FRAME {&FRAME-NAME} KEEP-TAB-ORDER.
  /* Users may toggle AppServer Aware on or off except when DB Aware is true.
     It is felt that since there is no UI for DB Aware, that developers who
     know enough to set DB-AWARE in their templates will know enough how to
     properly set AppServer-Aware in their templates.                       */
  _P._app-srv-aware:SENSITIVE IN FRAME {&FRAME-NAME} = NOT _P._DB-Aware.

  IF isSmartData THEN DO WITH FRAME {&FRAME-NAME}:
    DISPLAY _P._partition.
    _P._partition:SENSITIVE = TRUE.
  END.
END.  /* Procedure sensitize */

/* show_xTables: This routine shows the external tables in the xTables 
                 field.  We don't show _P._xTblList directly because we
                 want to process it (i.e. add spaces between items, don't
                 show database if there is only one). */
PROCEDURE show_xTables:
  define var cnt as integer no-undo.
  define var i as integer no-undo.
  define var first_db as character no-undo.
  define var item as character no-undo.
  define var show_db as logical no-undo.
  
  DO WITH FRAME {&FRAME-NAME}:
    /* There may be nothing to display */
    cnt = NUM-ENTRIES (_P._xTblList) .
    IF cnt eq 0 
    THEN ASSIGN xTables = "[no external tables]"
                btn_xTables:LABEL = "&Add...".
    ELSE DO:
      /* Is there more than 1 database mentioned in the list */
      ASSIGN first_db = ENTRY(1,_P._xTblList,".":U)
             show_db  = NO
             btn_xTables:LABEL = "M&odify...".
      DO i = 2 TO cnt:
        IF ENTRY (1, ENTRY(i, _P._xTblList), ".":U) ne first_db
        THEN show_db = YES.
      END.
      DO i = 1 TO cnt:
        item = ENTRY (i, _P._xTblList).
        IF NOT show_db THEN item = ENTRY(2, item, ".":U).
        IF i eq 1 THEN xTables = item.
        ELSE xTables = xTables + ", " + item. 
      END.       
    END.
  END.    
  
  /* Now show the value */
  DISPLAY xTables WITH FRAME {&FRAME-NAME}.

END PROCEDURE.

PROCEDURE Adjust_Fields:
  RUN Adjust_Persist.
  RUN Adjust_Buttons.
END.


PROCEDURE Adjust_Persist:
  DO WITH FRAME {&FRAME-NAME}:
    /* Handle Run Persistent toggle-box. */  
    IF NOT tg_persist:HIDDEN THEN DO:
      IF _P._persistent-only THEN 
        ASSIGN tg_persist:CHECKED   = YES
               tg_persist:SENSITIVE = NO.
      ELSE
        ASSIGN tg_persist:CHECKED   = _P._RUN-PERSISTENT
               tg_persist:SENSITIVE = YES.   
    END.
  END.     
END.

PROCEDURE Adjust_Buttons:   
 DO WITH FRAME {&FRAME-NAME}:    

  /* Both to be hidden */
  IF NOT CAN-DO(_P._links,"Page-Target") AND NOT CAN-DO (_P._ALLOW,"Smart") THEN DO: 
    ASSIGN h_btn_pages:HIDDEN  = yes
           h_btn_link:HIDDEN   = yes
    .          
  END.
  /* Hide Links - move up Pages and Advanced button */
  ELSE IF CAN-DO(_P._links,"Page-Target") AND NOT CAN-DO (_P._ALLOW,"Smart") THEN DO:
    ASSIGN h_btn_link:HIDDEN   = yes
           h_btn_pages:ROW     = h_btn_link:ROW
           h_btn_pages:HIDDEN  = no.
  END.
  /* Hide Pages - move up Adv */
  ELSE IF NOT CAN-DO(_P._links,"Page-Target") AND CAN-DO (_P._ALLOW,"Smart") THEN DO:
    ASSIGN h_btn_pages:HIDDEN  = yes
           h_btn_link:HIDDEN   = no
    .           
  END.      
  /* Both to be displayed */
  ELSE IF CAN-DO(_P._links,"Page-Target") AND CAN-DO (_P._ALLOW,"Smart") THEN DO: 
    ASSIGN h_btn_link:HIDDEN   = no
           h_btn_pages:ROW     = h_btn_link:ROW + h_btn_link:HEIGHT + 1
           h_btn_pages:HIDDEN  = no.
  END.

  ASSIGN h_btn_userfields:HIDDEN = (isWebObject = NO).
  IF isWebObject THEN
  DO:
    IF h_btn_link:HIDDEN AND h_btn_pages:HIDDEN THEN
        ASSIGN h_btn_userfields:ROW = h_btn_link:ROW.
    ELSE IF h_btn_pages:HIDDEN THEN
        ASSIGN h_btn_userfields:ROW = h_btn_pages:ROW.
  END.
  
 END. /* DO WITH FRAME */
END PROCEDURE.   


PROCEDURE Adjust_Other.
 DO WITH FRAME {&FRAME-NAME}:    
    DO WITH FRAME {&FRAME-NAME}:
      IF isWebObject THEN DO:
        HIDE {&NOT-WEB-OPTIONS} IN FRAME {&FRAME-NAME}.
        ASSIGN _P._compile:ROW = _P._DESC:ROW + _P._DESC:HEIGHT + 0.25 NO-ERROR.
        ASSIGN _P._compile:X   = save_name:X NO-ERROR.
        ASSIGN rect-pal:HEIGHT = h_btn_userfields:ROW.
        ASSIGN btn_OK:ROW      = rect-pal:HEIGHT + 2.25 NO-ERROR.
        ASSIGN btn_Cancel:ROW  = btn_OK:ROW NO-ERROR.
        ASSIGN btn_Help:ROW    = btn_OK:ROW NO-ERROR.
        ASSIGN FRAME {&FRAME-NAME}:HEIGHT = btn_OK:ROW + btn_OK:HEIGHT + .75 NO-ERROR.
      
        /* For non-remote web files, move up Description and Compile on Save. */
        IF _P._Broker-URL EQ "" THEN
          ASSIGN adjust           = _P._DESC:ROW - broker_url:ROW
                 _P._DESC:ROW     = broker_url:ROW
                 h_side_label     = _P._DESC:SIDE-LABEL-HANDLE
                 h_side_label:ROW = _P._DESC:ROW
                 _P._compile:ROW  = _P._compile:ROW - adjust.
      END.
    END.                         
  END.
END PROCEDURE.
                                               
/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
 * Check_Page_Change: If the user changed any Pages information inside the 
 * Pages dialog, we need to reflect those changes.  We do this by looking at
 * all the SmartObjects in the current procedure and dealing with them.  The
 * possible changes include:
 *    1) an object was moved to a different page
 *    2) an object was moved to the current page
 *    3) the current page changed
 *    4) an object was deleted [This is identified by a STATUS of "DELETE-PENDING"
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
PROCEDURE Check_Page_Change:
  /* Delete any objects that were on pages deleted in the Page dialog. */
  FOR EACH x_U WHERE x_U._WINDOW-HANDLE eq _P._WINDOW-HANDLE
                 AND x_U._STATUS eq "DELETE-PENDING":U:
     RUN adeuib/_delet_u.p (INPUT RECID(x_U), INPUT TRUE /* Trash */) .
  END.    
  /* Show the current page. */
  RUN adeuib/_showpag.p  (RECID(_P), _P._page-current).
END PROCEDURE.

PROCEDURE File_Type_Chk:
  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN
         /* Not all procedures have a compile-into, or a OCX-file */
         l_OCX-file                 = (OPSYS = "WIN32":u) AND _P._FILE-TYPE = "w"
         l_can-run                  = _P._FILE-TYPE <> "i" 
         tg_persist:HIDDEN          = NOT l_can-run
         _P._compile:HIDDEN         = NOT l_can-run
         compile-into:HIDDEN        = NOT l_can-run
         OCX-file:HIDDEN            = NOT l_OCX-file 
         _P._compile:SENSITIVE      = l_can-run
         compile-into:SENSITIVE     = l_can-run
         OCX-file:SENSITIVE         = l_OCX-file  
         .    
    /* Do checks for TEMPLATE. */
    ASSIGN 
      /* The COMPILE toggle only applies is Master Files, not Templates, 
         so we need to adjust its label to be more specific. */
      _P._compile:LABEL = "&Compile " + 
                          (IF _P._template THEN "Master ":U ELSE "":U) +
                          "on Save"                                
      proc-type:SCREEN-VALUE = _P._TYPE + 
                               IF _P._template THEN " [Template]" ELSE ""
      .

    /* Cover the OCX and Compile information with the description */
    IF NOT OCX-file:HIDDEN THEN
      _P._DESC:HEIGHT = OCX-file:ROW - _P._DESC:ROW. 
    ELSE DO:
      IF NOT compile-into:HIDDEN THEN 
        _P._DESC:HEIGHT = compile-into:ROW - _P._DESC:ROW.
      ELSE
        _P._DESC:HEIGHT = compile-into:ROW + compile-into:HEIGHT - _P._DESC:ROW.
    END.
    
    IF _P._FILE-TYPE = "i" THEN DO:
      ASSIGN h_btn_pproc:SENSITIVE = no.
      DISABLE xTables btn_xTables tg_persist.
    END.
    ELSE DO:
      RUN Adjust_Persist.
      ASSIGN h_btn_pproc:SENSITIVE = yes.
      IF _P._adm-version < "ADM2":U THEN 
      ENABLE xTables btn_xTables.
    END.
  END.
END PROCEDURE. 


/* Get-Palette-Dirs - Go to the Palette and see if there are any items
 * that have the same type as this procedure.  If YES, then return the
 * directory list from that palette item. */
PROCEDURE Get-Palette-Dirs :
  DEFINE OUTPUT PARAMETER p_dirs AS CHAR NO-UNDO.  
   
  DEFINE VAR i AS INTEGER NO-UNDO.
  DEFINE VAR cnt AS INTEGER NO-UNDO.
  DEFINE VAR test AS CHAR NO-UNDO.
            
  /* Does this type of object have a palette entry */
  FIND _palette_item WHERE _palette_item._NAME eq _P._TYPE NO-ERROR.
  /* Is it a SmartContainer? */
  IF NOT AVAILABLE _palette_item AND CAN-DO (_P._Allow, "Smart")
  THEN FIND _palette_item WHERE _palette_item._NAME eq "SmartContainer" NO-ERROR.

  /* Return the Directory list in the palette */
  IF AVAILABLE _palette_item THEN DO: 

    ASSIGN cnt =  NUM-ENTRIES(_palette_item._attr,CHR(10))
           i   = 1.
    DO WHILE i <= cnt AND p_dirs eq "":
      IF ENTRY(i,_palette_item._attr,CHR(10)) BEGINS "DIRECTORY-LIST" 
      THEN p_dirs = TRIM(SUBSTRING(TRIM(ENTRY(i,_attr,CHR(10))),15,-1,"CHARACTER")).
      i = i + 1.
    END.
    /* Remove the Current Directory from the list. For example:
         p_dirs     =  "src/adm,."
         Add commas =  ",src/adm,.,"
         Remove ,., =  ",src/adm,"
         Del commas =  "src/adm"
     */
    ASSIGN p_dirs = REPLACE ("," + p_dirs + ",", ",.,", ",")
           p_dirs = SUBSTRING (p_dirs, 2, LENGTH(p_dirs, "CHARACTER") - 2, "CHARACTER")
           .  
  END.
  
END PROCEDURE.


/* This procedure scans a query's tablelist to see if it contains any external
   tables of the procedure.  If it does, it removes them and then rebuilds the
   query.                                                                       */
PROCEDURE remove-ext-tables:
DEFINE INPUT PARAMETER q-rec      AS RECID                                   NO-UNDO.
DEFINE INPUT PARAMETER proc-xtbls AS CHARACTER                               NO-UNDO.

DEFINE VARIABLE doit        AS LOGICAL                                       NO-UNDO.
DEFINE VARIABLE found       AS LOGICAL                                       NO-UNDO.
DEFINE VARIABLE i           AS INTEGER                                       NO-UNDO.
DEFINE VARIABLE j           AS INTEGER                                       NO-UNDO.
DEFINE VARIABLE num-tbls AS INTEGER                                          NO-UNDO.
DEFINE VARIABLE pos         AS INTEGER                                       NO-UNDO.
DEFINE VARIABLE qtbls       AS CHARACTER                                     NO-UNDO.
DEFINE VARIABLE xtbl        AS CHARACTER                                     NO-UNDO.


  FIND _Q WHERE RECID(_Q) = q-rec.
  
  ASSIGN found = FALSE                          /* Initialize found flag          */
         num-tbls = NUM-ENTRIES(_Q._TblList).   /* number of tables in query      */

  /* build simpler list of query tables because existing one is in the form of
     tbl1, tbl2 OF tbl1, tbl3 where ...                                           */
  DO i = 1 TO num-tbls:
    qtbls = qtbls + (IF qtbls NE "" THEN "," ELSE "") +
                    ENTRY(1,TRIM(ENTRY(i,_Q._TblList))," ":U).
  END.

  DO i = 1 TO NUM-ENTRIES(proc-xtbls):  /* Loop through procedure external tables */
    ASSIGN xtbl = ENTRY(i,proc-xtbls)   /* Current external table        */
           pos  = LOOKUP(xtbl,qtbls).   /* position of xtbl within qtbls */
    IF pos > 0 THEN DO:  /* This query contains xtbl */
      DO j = pos TO num-tbls:
        IF j < num-tbls THEN   /* Slide things down a notch */
          ASSIGN _Q._JoinCode[j] =  _Q._JoinCode[j + 1]
                 _Q._Where[j]    =  _Q._Where[j + 1].
        ELSE /* Last one is blanked out */
          ASSIGN _Q._JoinCode[j] =  _Q._JoinCode[j + 1]
                 _Q._Where[j]    =  _Q._Where[j + 1].       
      END.  /* j = pos to num-tbls */
      ASSIGN found                  = TRUE
             ENTRY(pos,_Q._TblList) = ""
             _Q._TblList            = TRIM(REPLACE(_Q._TblList, ",,":U, ",":U),
                                           ",":U)
             ENTRY(pos,qtbls)       = ""
             qtbls                  = TRIM(REPLACE(qtbls, ",,":U, ",":U), ",":U).
    END.  /* IF pos > 0 */
  END.  /* For EACH extable */
  IF found THEN DO: /* This query has been changed -- rebuild it. */
    Message "All external tables of this procedure will be external " +
            "tables to all queries contained in the procedure."
        VIEW-AS ALERT-BOX WARNING BUTTONS OK-CANCEL UPDATE doit.
    IF NOT doit THEN UNDO, RETURN.
    RUN adeuib/_qbuild.p(q-rec, _suppress_dbname, 0).
  END.
END.  /* Procedure remove-ext-tables */


