&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v7r11 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME    dlg_XFTRed
&Scoped-define FRAME-NAME     dlg_XFTRed
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS dlg_XFTRed 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*------------------------------------------------------------------------

  File: _xftr.w

  Description: UIB eXtended FeaTuRe editor

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: Gerry Seidl

  Created: 09/15/94 -  1:41 pm
  
  Modified On: 1/13/95 gfs Disabled Add,Delete,Move Up and Move Down since
                           only In-Line XFTR's will be initially supported.

------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/
{adeuib/sharvars.i}     /* Standard shared definitions              */
{adeuib/uibhlp.i}       /* Help File Preprocessor Directives        */
{adeuib/uniwidg.i}      /* Universal widget definitions             */
{adeuib/triggers.i}     /* Trigger TEMP-TABLE definition            */
{adeuib/xftr.i}         /* eXtended Features definition             */
/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE rc  AS LOGICAL INITIAL no NO-UNDO.
DEFINE VARIABLE log AS LOGICAL            NO-UNDO.
DEFINE TEMP-TABLE tt
    FIELD xName  AS CHAR
    FIELD tLOC   AS INT
    FIELD _TRGid AS RECID.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME



/* ********************  Preprocessor Definitions  ******************** */

/* Name of first Frame and/or Browse (alphabetically)                   */
&Scoped-define FRAME-NAME  dlg_XFTRed

/* Custom List Definitions                                              */
&Scoped-define LIST-1 
&Scoped-define LIST-2 
&Scoped-define LIST-3 

/* Definitions for DIALOG-BOX dlg_XFTRed                                */
&Scoped-define FIELDS-IN-QUERY-dlg_XFTRed 
&Scoped-define ENABLED-FIELDS-IN-QUERY-dlg_XFTRed 
&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON b_Add 
     LABEL "&Add...":L 
     SIZE 12 BY 1.

DEFINE BUTTON b_Cancel AUTO-END-KEY 
     LABEL "Cancel":L 
     SIZE 12 BY 1.

DEFINE BUTTON b_Delete 
     LABEL "De&lete":L 
     SIZE 12 BY 1.

DEFINE BUTTON b_Edit 
     LABEL "&Edit...":L 
     SIZE 12 BY 1.

DEFINE BUTTON b_Help 
     LABEL "&Help":L 
     SIZE 12 BY 1.

DEFINE BUTTON b_MoveDown 
     LABEL "Move &Down":L 
     SIZE 12 BY 1.

DEFINE BUTTON b_MoveUp 
     LABEL "Move &Up":L 
     SIZE 12 BY 1.

DEFINE BUTTON b_OK AUTO-GO 
     LABEL "OK":L 
     SIZE 12 BY 1.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 37 BY 11.76.

DEFINE VARIABLE s_XFTR AS CHARACTER 
     VIEW-AS SELECTION-LIST SINGLE SCROLLBAR-VERTICAL 
     SIZE 34 BY 10 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME dlg_XFTRed
     s_XFTR AT ROW 2 COL 3 NO-LABEL
     b_OK AT ROW 2 COL 41
     b_Cancel AT ROW 3.24 COL 41
     b_Edit AT ROW 4.76 COL 41
     b_Help AT ROW 6.28 COL 41
     b_Add AT ROW 7.48 COL 41
     b_Delete AT ROW 8.92 COL 41
     b_MoveUp AT ROW 10.12 COL 41
     b_MoveDown AT ROW 11.56 COL 41
     " .W Sections" VIEW-AS TEXT
          SIZE 13 BY .68 AT ROW 1.24 COL 3
     RECT-3 AT ROW 1.52 COL 2
     "* UIB Maintained Sections" VIEW-AS TEXT
          SIZE 32 BY .68 AT ROW 12.24 COL 4
     SPACE(18.29) SKIP(0.66)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D SCROLLABLE 
         TITLE "Extensions Editor":L
         DEFAULT-BUTTON b_OK.

 


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
ASSIGN 
       FRAME dlg_XFTRed:SCROLLABLE       = FALSE.

/* SETTINGS FOR BUTTON b_Add IN FRAME dlg_XFTRed
   NO-ENABLE                                                            */
ASSIGN 
       b_Add:HIDDEN IN FRAME dlg_XFTRed           = TRUE.

/* SETTINGS FOR BUTTON b_Delete IN FRAME dlg_XFTRed
   NO-ENABLE                                                            */
ASSIGN 
       b_Delete:HIDDEN IN FRAME dlg_XFTRed           = TRUE.

/* SETTINGS FOR BUTTON b_Edit IN FRAME dlg_XFTRed
   NO-ENABLE                                                            */
/* SETTINGS FOR BUTTON b_MoveDown IN FRAME dlg_XFTRed
   NO-ENABLE                                                            */
ASSIGN 
       b_MoveDown:HIDDEN IN FRAME dlg_XFTRed           = TRUE.

/* SETTINGS FOR BUTTON b_MoveUp IN FRAME dlg_XFTRed
   NO-ENABLE                                                            */
ASSIGN 
       b_MoveUp:HIDDEN IN FRAME dlg_XFTRed           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME b_Add
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b_Add dlg_XFTRed
ON CHOOSE OF b_Add IN FRAME dlg_XFTRed /* Add... */
DO: 
    RUN adeuib/_xftradd.w.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b_Delete
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b_Delete dlg_XFTRed
ON CHOOSE OF b_Delete IN FRAME dlg_XFTRed /* Delete */
DO:
  for each tt:
      message tt.xname skip tt.tloc skip tt._trgid view-as alert-box.
  end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b_Edit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b_Edit dlg_XFTRed
ON CHOOSE OF b_Edit IN FRAME dlg_XFTRed /* Edit... */
DO:
  DEFINE VARIABLE tCode AS CHAR NO-UNDO.

  IF SUBSTRING(s_XFTR:SCREEN-VALUE,1,1,"CHARACTER":U) <> "*" THEN DO:
      FIND tt WHERE tt.xNAME = SUBSTRING(s_XFTR:SCREEN-VALUE,3) NO-ERROR.
      IF AVAILABLE (tt) THEN DO:
          FIND _TRG WHERE RECID(_TRG) = tt._TRGid.
          FIND _XFTR WHERE RECID(_XFTR) = _TRG._xRecid.
          
          ASSIGN tCode = _TRG._tCode.

          IF _XFTR._edit <> ? THEN 
            RUN VALUE(_XFTR._edit) (INPUT INT(RECID(_TRG)), INPUT-OUTPUT tCode).
          ELSE RUN adeuib/_xfcedit.w (INPUT-OUTPUT tCode).
          IF _TRG._tCode <> tCode THEN DO:          /* code changed */
              FIND _P WHERE _P._WINDOW-HANDLE eq _h_win.
              ASSIGN _TRG._tCode      = tCode
                     _P._FILE-SAVED   = no.
          END.
      END.
      ELSE MESSAGE "XFTR was not found." VIEW-AS ALERT-BOX ERROR
              BUTTONS OK.
  END.
  ELSE MESSAGE "You must use the Section Editor to edit UIB sections." VIEW-AS
          ALERT-BOX INFORMATION BUTTONS OK.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b_Help
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b_Help dlg_XFTRed
ON CHOOSE OF b_Help IN FRAME dlg_XFTRed /* Help */
OR HELP OF FRAME dlg_XFTRed
DO:
    RUN adecomm/_adehelp.p ( "AB", "CONTEXT", {&Main_Contents}, ? ). 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b_MoveDown
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b_MoveDown dlg_XFTRed
ON CHOOSE OF b_MoveDown IN FRAME dlg_XFTRed /* Move Down */
DO:
  DEFINE VAR i           AS INTEGER NO-UNDO.
  DEFINE VAR ipos        AS INTEGER NO-UNDO.
  DEFINE VAR choice      AS CHAR    NO-UNDO.
  DEFINE VAR swap-item   AS CHAR    NO-UNDO.
  DEFINE VAR choice-item AS CHAR    NO-UNDO.
  DEFINE VAR new-swap    AS CHAR    NO-UNDO.
  DEFINE VAR new-choice  AS CHAR    NO-UNDO.
  DEFINE VAR l_ok        AS LOGICAL NO-UNDO.

  ASSIGN choice = s_XFTR:SCREEN-VALUE.
  DO i = NUM-ENTRIES(choice) TO 1 BY -1:
    ASSIGN choice-item = ENTRY (i,choice) 
           ipos        = s_XFTR:LOOKUP(choice-item).

    IF ipos < s_XFTR:NUM-ITEMS THEN DO:
      /* Get the item above the current choice and swap it with the current choice.
         Change the line numbers of the choice to the swapped line number (this
         is the first 3 characters). */
      swap-item  = s_XFTR:ENTRY(ipos + 1).
      IF LOOKUP(swap-item,choice) eq 0
      THEN DO:
          ASSIGN
             new-choice = choice-item
             new-swap   = swap-item
             l_ok = s_XFTR:DELETE(swap-item).
             l_ok = s_XFTR:REPLACE(new-swap, choice-item).
          ASSIGN
             l_ok = s_XFTR:INSERT(new-choice, ipos + 1)
             ENTRY(i,choice) = new-choice.
      END.
    END.
  END.
  /* reset the value of the choice. */
  s_XFTR:SCREEN-VALUE = choice.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b_MoveUp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b_MoveUp dlg_XFTRed
ON CHOOSE OF b_MoveUp IN FRAME dlg_XFTRed /* Move Up */
DO:
  DEFINE VAR i           AS INTEGER NO-UNDO.
  DEFINE VAR ipos        AS INTEGER NO-UNDO.
  DEFINE VAR choice      AS CHAR    NO-UNDO.
  DEFINE VAR swap-item   AS CHAR    NO-UNDO. /* new */
  DEFINE VAR choice-item AS CHAR    NO-UNDO. /* one to move */
  DEFINE VAR new-swap    AS CHAR    NO-UNDO. 
  DEFINE VAR new-choice  AS CHAR    NO-UNDO.
  DEFINE VAR l_ok        AS LOGICAL NO-UNDO.
  
  ASSIGN choice = s_XFTR:SCREEN-VALUE.
  DO i = 1 TO NUM-ENTRIES(choice):
    ASSIGN choice-item = ENTRY (i,choice) 
           ipos        = s_XFTR:LOOKUP(choice-item).
    IF s_XFTR:ENTRY(ipos - 1) = "*TopOfFile" THEN DO:
        MESSAGE "You cannot place an XFTR above the TopOfFile section."
            VIEW-AS ALERT-BOX WARNING BUTTONS OK.
        RETURN NO-APPLY.
    END.
    IF ipos > 1 THEN DO:
      /* Get the item above the current choice and swap it with the current choice.
         Change the line numbers of the choice to the swapped line number (this
         is the first 3 characters). */
      swap-item  = s_XFTR:ENTRY(ipos - 1).
      IF LOOKUP(swap-item,choice) eq 0
      THEN ASSIGN
             new-choice = choice-item
             new-swap   = swap-item
             /*SUBSTRING(new-swap,1,3)   = SUBSTRING(choice-item,1,3)
             SUBSTRING(new-choice,1,3) = SUBSTRING(swap-item,1,3)*/
             l_ok = s_XFTR:REPLACE( new-swap, choice-item)
             l_ok = s_XFTR:REPLACE( new-choice, swap-item)
             ENTRY(i,choice) = new-choice.
    END.
  END.
  /* reset the value of the choice. */
  s_XFTR:SCREEN-VALUE = choice.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b_OK dlg_XFTRed
ON CHOOSE OF b_OK IN FRAME dlg_XFTRed /* OK */
DO:
  RUN fix-loc.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME s_XFTR
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL s_XFTR dlg_XFTRed
ON VALUE-CHANGED OF s_XFTR IN FRAME dlg_XFTRed
DO:
  IF SUBSTRING(s_XFTR:SCREEN-VALUE,1,1,"CHARACTER":U) = "*" THEN
      RUN btns-off.
  ELSE
      RUN btns-on.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK dlg_XFTRed 


/* ***************************  Main Block  *************************** */

/* Parent the dialog-box to the ACTIVE-WINDOW, if there is no parent.   */
IF VALID-HANDLE(ACTIVE-WINDOW) AND FRAME {&FRAME-NAME}:PARENT eq ?
THEN FRAME {&FRAME-NAME}:PARENT = ACTIVE-WINDOW.

/* Add Trigger to equate WINDOW-CLOSE to END-ERROR                      */
ON WINDOW-CLOSE OF FRAME {&FRAME-NAME} APPLY "END-ERROR":U TO SELF.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
  RUN Build-Section-List (OUTPUT rc).
  IF rc THEN RETURN.
  RUN enable_UI.
  s_XFTR:SCREEN-VALUE = s_XFTR:ENTRY(1).
  WAIT-FOR GO OF FRAME {&FRAME-NAME}.
END.
RUN disable_UI.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE add-tt dlg_XFTRed 
PROCEDURE add-tt :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER tt-xname AS CHAR NO-UNDO.
  DEFINE INPUT PARAMETER tt-tloc  AS INT  NO-UNDO.
  DEFINE INPUT PARAMETER tt-trgid AS RECID NO-UNDO.
  
  CREATE tt.
  ASSIGN xName  = tt-xname
         tLoc   = tt-tloc
         _trgid = tt-trgid.
         
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE btns-off dlg_XFTRed 
PROCEDURE btns-off :
/* -----------------------------------------------------------
  Purpose:     Disable buttons
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
DO WITH FRAME {&FRAME-NAME}:
      ASSIGN b_Edit:SENSITIVE     = no
             b_Delete:SENSITIVE   = no
             b_MoveUp:SENSITIVE   = no
             b_MoveDown:SENSITIVE = no.
END.  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE btns-on dlg_XFTRed 
PROCEDURE btns-on :
/* -----------------------------------------------------------
  Purpose:     Makes buttons sensitive
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
DO WITH FRAME {&FRAME-NAME}:
      ASSIGN b_Edit:SENSITIVE     = yes.
             /*b_Add:SENSITIVE      = yes
             b_Delete:SENSITIVE   = yes
             b_MoveUp:SENSITIVE   = yes
             b_MoveDown:SENSITIVE = yes.*/ 
END. 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Build-Section-List dlg_XFTRed 
PROCEDURE Build-Section-List :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE OUTPUT PARAMETER rc AS LOGICAL NO-UNDO.
  
  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN RC = no.
    s_XFTR:LIST-ITEMS = ?.
    FIND _U WHERE _U._HANDLE eq _h_win NO-ERROR.
    IF NOT AVAILABLE (_U) THEN DO:
        MESSAGE "No Window is available" VIEW-AS ALERT-BOX ERROR
            BUTTONS OK.
        ASSIGN rc = yes.
        RETURN.
    END.     
    FIND _C WHERE RECID(_C) = _U._X-Recid NO-ERROR.
    
    /* Show TopOfFile XFTRs first */
    log = s_XFTR:ADD-LAST ("*TopOfFile").
    RUN Add-tt (INPUT "*TopOfFile", INPUT {&TOPOFFILE}, INPUT ?).
    RUN put_next_xftrs (INPUT {&TOPOFFILE}).
        
    /* Show Def'ns */
    log = s_XFTR:ADD-LAST ("*Definitions").
    RUN Add-tt (INPUT "*Definitions", INPUT {&DEFINITIONS}, INPUT ?).
    /* Show the XFTR's that follow Definitions */ 
    RUN put_next_xftrs (INPUT {&DEFINITIONS}).

    /* Add other lines */
    ASSIGN log = s_XFTR:ADD-LAST ("*Standard Preprocessor Def'n").
    RUN Add-tt (INPUT "*Standard Preprocessor Def'n", INPUT {&STDPREPROCS}, INPUT ?).
    RUN put_next_xftrs (INPUT {&STDPREPROCS}).

    ASSIGN log = s_XFTR:ADD-LAST ("*Control Definitions").
    RUN Add-tt (INPUT "*Control Definitions", INPUT {&CONTROLDEFS}, INPUT ?).
    RUN put_next_xftrs (INPUT {&CONTROLDEFS}).
    
    ASSIGN log = s_XFTR:ADD-LAST ("*Run-time Settings").
    RUN Add-tt (INPUT "*Run-time Settings", INPUT {&RUNTIMESET}, INPUT ?).
    RUN put_next_xftrs (INPUT {&RUNTIMESET}).
    
    ASSIGN log = s_XFTR:ADD-LAST ("*Control Triggers").
    RUN Add-tt (INPUT "*Control Triggers", INPUT {&CONTROLTRIG}, INPUT ?).
    RUN put_next_xftrs (INPUT {&CONTROLTRIG}).
    
    /* Show Main-Code-Block first */
    log = s_XFTR:ADD-LAST ("*Main Code Block").
    RUN Add-tt (INPUT "*Main Code Block", INPUT {&MAINBLOCK}, INPUT ?).
    RUN put_next_xftrs (INPUT {&MAINBLOCK}).
  
    /* Show Procedures as a single section */
    log = s_XFTR:ADD-LAST ("*Internal Procedures").
    RUN Add-tt (INPUT "*Internal Procedures", INPUT {&INTPROCS}, INPUT ?).
    RUN put_next_xftrs (INPUT {&INTPROCS}).
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI dlg_XFTRed _DEFAULT-DISABLE
PROCEDURE disable_UI :
/* --------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
   -------------------------------------------------------------------- */
  /* Hide all frames. */
  HIDE FRAME dlg_XFTRed.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE display-trg dlg_XFTRed 
PROCEDURE display-trg :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
         message "** TRG **" skip
                 "RECID" RECID(_TRG) skip
                 "SECTION" _TRG._tsection skip
                 "WRECID" _TRG._wrecid skip
                 "TEVENT" _TRG._tevent skip
                 "TSPECIAL" _TRG._tspecial skip
                 "TCODE" _TRG._tcode skip
                 "XRECID" _TRG._xRECID skip
                 "TLOCATION" _TRG._tLOCATION SKIP
                 "STATUS" _TRG._status  view-as alert-box.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE display-xftr dlg_XFTRed 
PROCEDURE display-xftr :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/

        MESSAGE "** XFTR **" skip
                "NAME" _XFTR._name skip
                "WRECID" _XFTR._wrecid skip
                "CREATE"_create skip
                "REALIZE" _realize skip
                "EDIT" _edit skip
                "DESTROY" _destroy skip
                "READ" _read skip
                "WRITE" _write skip
                view-as alert-box.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI dlg_XFTRed _DEFAULT-ENABLE
PROCEDURE enable_UI :
/* --------------------------------------------------------------------
  Purpose:     ENABLE the User Interface
  Parameters:  <none>
  Notes:       Here we display/view/enable the widgets in the
               user-interface.  In addition, OPEN all queries
               associated with each FRAME and BROWSE.
               These statements here are based on the "Other 
               Settings" section of the widget Property Sheets.
   -------------------------------------------------------------------- */
  DISPLAY s_XFTR 
      WITH FRAME dlg_XFTRed.
  ENABLE RECT-3 s_XFTR b_OK b_Cancel b_Help 
      WITH FRAME dlg_XFTRed.
  {&OPEN-BROWSERS-IN-QUERY-dlg_XFTRed}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE fix-loc dlg_XFTRed 
PROCEDURE fix-loc :
/* -----------------------------------------------------------
  Purpose:     Fix locations of features
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
    DEF VAR i   AS INT NO-UNDO.
    DEF VAR loc AS INT NO-UNDO.
    
    /* CYCLE THROUGH SELECTION LIST AND RE-ORDER */
    DO i = 1 to s_XFTR:NUM-ITEMS IN FRAME {&FRAME-NAME}:
        FIND tt WHERE xName = LEFT-TRIM(s_XFTR:ENTRY(i)).
        IF _TRGid <> ? THEN DO:
            FIND _TRG WHERE RECID(_TRG) = tt._TRGid.
            ASSIGN _TRG._tLOCATION = loc
                   tt.tLoc         = loc
                   loc             = RECID(_TRG). /* last _TRG in Section */
        END.
        ELSE loc = tt.tLoc. /* loc of Section */
    END.
       
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE put_next_xftrs dlg_XFTRed 
PROCEDURE put_next_xftrs :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
    DEFINE INPUT PARAMETER loc AS INT.
    
    FIND FIRST _TRG WHERE _TRG._tLOCATION eq loc
                AND _TRG._wRECID    eq RECID(_U) NO-ERROR.

    DO WHILE AVAILABLE _TRG:
        /*RUN display-trg.*/
      FIND _xftr WHERE RECID(_xftr) eq _TRG._xRECID. 
        /*RUN display-xftr.*/
      RUN Add-tt (INPUT _xftr._name, INPUT loc, INPUT RECID(_TRG)).
      log = s_XFTR:ADD-LAST("  " + _xftr._name) IN FRAME {&FRAME-NAME}.
      loc = INT(RECID(_TRG)).
      FIND _TRG WHERE _TRG._tLOCATION eq loc
                  AND _TRG._wRECID    eq RECID(_U)
                NO-ERROR.     
    END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE FRAME-NAME
&UNDEFINE WINDOW-NAME
