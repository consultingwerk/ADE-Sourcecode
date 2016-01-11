&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME f_dlg
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS f_dlg 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*------------------------------------------------------------------------

  File: _edtpage.w

  Description: ADM Page Informatino Editor for the UIB 

  Input Parameters:
      p_p_Precid - Recid of the current _P record

  Output Parameters:
      <none>

  Author: William T. Wood

  Created: 4/1/95

------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/
/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER p_Precid AS RECID. /* recid of _P record */
&GLOBAL-DEFINE WIN95-BTN YES

{ adeuib/uniwidg.i }  /* universal widget defs */
{ adeuib/uibhlp.i }   /* Include File containing HELP file Context ID's */

/* ***************************  Definitions  ************************** */


/* Local Variable Definitions ---                                       */  
DEFINE VARIABLE ldummy    AS LOGICAL NO-UNDO.
DEFINE VARIABLE l_master  AS LOGICAL NO-UNDO. /* True, if Master Layout */
DEFINE VARIABLE page-A    AS INTEGER NO-UNDO. /* Page-A and -B are...   */
DEFINE VARIABLE page-B    AS INTEGER NO-UNDO. /* ...used to swap pages  */
DEFINE VARIABLE this-page AS INTEGER NO-UNDO.

/* Preprocessor Definitions ---                                         */  
&Scope Main 0 [Main]
&Scope Base-Pages 16
&Scope fmt  >,>>>,>>9

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DIALOG-BOX
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f_dlg
&Scoped-define BROWSE-NAME br_sos

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES _U _S

/* Definitions for BROWSE br_sos                                        */
&Scoped-define FIELDS-IN-QUERY-br_sos _U._NAME _U._SUBTYPE _S._FILE-NAME   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_sos   
&Scoped-define SELF-NAME br_sos
&Scoped-define OPEN-QUERY-br_sos OPEN QUERY br_sos FOR       EACH _U WHERE _U._WINDOW-HANDLE eq _P._WINDOW-HANDLE                                 AND _U._STATUS eq "NORMAL"                                 AND _U._TYPE eq "SmartObject", ~
             FIRST _S WHERE RECID(_S) eq _U._x-recid                  AND _S._page-number eq this-page.
&Scoped-define TABLES-IN-QUERY-br_sos _U _S
&Scoped-define FIRST-TABLE-IN-QUERY-br_sos _U
&Scoped-define SECOND-TABLE-IN-QUERY-br_sos _S


/* Definitions for DIALOG-BOX f_dlg                                     */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-6 RECT-5 RECT-4 RECT-3 s_page b_goto ~
br_sos fi_current fi_select 
&Scoped-Define DISPLAYED-OBJECTS s_page fi_current fi_select 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON b_del-obj 
     LABEL "De&lete SmartObject" 
     SIZE 22.6 BY 1.14.

DEFINE BUTTON b_del-page 
     LABEL "&Delete..." 
     SIZE 11 BY 1.14.

DEFINE BUTTON b_design 
     LABEL "&Design..." 
     SIZE 11 BY 1.14.

DEFINE BUTTON b_goto 
     LABEL "&Page..." 
     SIZE 11 BY 1.14.

DEFINE BUTTON b_Move-obj 
     LABEL "&Move to Page..." 
     SIZE 22.6 BY 1.14.

DEFINE BUTTON b_select 
     LABEL "&Start..." 
     SIZE 11 BY 1.14.

DEFINE BUTTON b_swap 
     LABEL "S&wap Pages" 
     SIZE 23.6 BY 1.14.

DEFINE VARIABLE contents AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 28 BY .67 NO-UNDO.

DEFINE VARIABLE fi_current AS INTEGER FORMAT ">,>>>,>>9":U INITIAL 0 
      VIEW-AS TEXT 
     SIZE 5 BY 1.19 NO-UNDO.

DEFINE VARIABLE fi_select AS INTEGER FORMAT ">,>>>,>>9":U INITIAL 0 
      VIEW-AS TEXT 
     SIZE 5 BY 1.19 NO-UNDO.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 25.6 BY 12.14.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 48 BY 12.14.

DEFINE RECTANGLE RECT-5
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 9 BY 1.57.

DEFINE RECTANGLE RECT-6
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 9 BY 1.57.

DEFINE VARIABLE s_page AS CHARACTER 
     VIEW-AS SELECTION-LIST MULTIPLE SCROLLBAR-VERTICAL 
     SIZE 13 BY 10 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_sos FOR 
      _U, 
      _S SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_sos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_sos f_dlg _FREEFORM
  QUERY br_sos DISPLAY
      _U._NAME LABEL "Name"                 FORMAT "X(20)"
     _U._SUBTYPE LABEL "Type"              FORMAT "X(32)"
     _S._FILE-NAME LABEL "Master File"     FORMAT "X(64)"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS MULTIPLE SIZE 46 BY 10.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f_dlg
     s_page AT ROW 1.76 COL 3 NO-LABEL
     b_goto AT ROW 1.81 COL 16
     br_sos AT ROW 1.81 COL 29
     b_del-page AT ROW 3.38 COL 16
     b_design AT ROW 5.81 COL 16
     b_select AT ROW 8.81 COL 16
     b_swap AT ROW 12 COL 3
     b_del-obj AT ROW 12 COL 29
     b_Move-obj AT ROW 12 COL 52.6
     contents AT ROW 1 COL 28 COLON-ALIGNED NO-LABEL
     fi_current AT ROW 7.19 COL 20.6 NO-LABEL
     fi_select AT ROW 10.19 COL 20.6 NO-LABEL
     " Pages" VIEW-AS TEXT
          SIZE 7.6 BY .67 AT ROW 1 COL 4
     "p." VIEW-AS TEXT
          SIZE 2.6 BY 1.19 AT ROW 10.19 COL 18
     RECT-6 AT ROW 10.05 COL 17
     "p." VIEW-AS TEXT
          SIZE 2.6 BY 1.19 AT ROW 7.19 COL 18
     RECT-5 AT ROW 7.05 COL 17
     RECT-4 AT ROW 1.29 COL 28
     RECT-3 AT ROW 1.29 COL 2
     SPACE(49.06) SKIP(0.00)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE NO-VALIDATE THREE-D  SCROLLABLE 
         TITLE "Pages".


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: DIALOG-BOX
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX f_dlg
                                                                        */
/* BROWSE-TAB br_sos b_goto f_dlg */
ASSIGN 
       FRAME f_dlg:SCROLLABLE       = FALSE
       FRAME f_dlg:HIDDEN           = TRUE.

/* SETTINGS FOR BUTTON b_del-obj IN FRAME f_dlg
   NO-ENABLE                                                            */
/* SETTINGS FOR BUTTON b_del-page IN FRAME f_dlg
   NO-ENABLE                                                            */
/* SETTINGS FOR BUTTON b_design IN FRAME f_dlg
   NO-ENABLE                                                            */
/* SETTINGS FOR BUTTON b_Move-obj IN FRAME f_dlg
   NO-ENABLE                                                            */
/* SETTINGS FOR BUTTON b_select IN FRAME f_dlg
   NO-ENABLE                                                            */
/* SETTINGS FOR BUTTON b_swap IN FRAME f_dlg
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN contents IN FRAME f_dlg
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR FILL-IN fi_current IN FRAME f_dlg
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN fi_select IN FRAME f_dlg
   ALIGN-L                                                              */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_sos
/* Query rebuild information for BROWSE br_sos
     _START_FREEFORM
OPEN QUERY br_sos FOR
      EACH _U WHERE _U._WINDOW-HANDLE eq _P._WINDOW-HANDLE
                                AND _U._STATUS eq "NORMAL"
                                AND _U._TYPE eq "SmartObject",
      FIRST _S WHERE RECID(_S) eq _U._x-recid
                 AND _S._page-number eq this-page.
     _END_FREEFORM
     _Query            is NOT OPENED
*/  /* BROWSE br_sos */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define BROWSE-NAME br_sos
&Scoped-define SELF-NAME br_sos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_sos f_dlg
ON DEFAULT-ACTION OF br_sos IN FRAME f_dlg
DO:
  /* Move the selected objects in the browse to a new page.*/
  RUN Move_Selected_to_Page.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_sos f_dlg
ON VALUE-CHANGED OF br_sos IN FRAME f_dlg
DO:
  /* Enable and disable buttons, as appropriate */
  ASSIGN b_del-obj:SENSITIVE  = (SELF:NUM-SELECTED-ROWS > 0)
         b_move-obj:SENSITIVE = b_del-obj:SENSITIVE
         . 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b_del-obj
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b_del-obj f_dlg
ON CHOOSE OF b_del-obj IN FRAME f_dlg /* Delete SmartObject */
DO:
  DEFINE VARIABLE i        AS INTEGER NO-UNDO.
  
  /* This button should not be enabled if there is no current SmartObject */
  IF NOT AVAILABLE _S THEN SELF:SENSITIVE = no.
  ELSE DO:
    /* Delete everything selected page... 
       We don't actually delete them, because the user might change their mind and
       cancel. Just mark this for a later deletion */
    DO i = 1 TO {&BROWSE-NAME}:NUM-SELECTED-ROWS:
      IF {&BROWSE-NAME}:FETCH-SELECTED-ROW (i)
      THEN _U._STATUS = "DELETE-PENDING".
    END.
    
    /* Redisplay the current page. */
    RUN Reopen_Query.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b_del-page
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b_del-page f_dlg
ON CHOOSE OF b_del-page IN FRAME f_dlg /* Delete... */
DO:
  DEFINE VARIABLE ans AS LOGICAL NO-UNDO.
  
  DEFINE BUFFER x_U FOR _U.
  DEFINE BUFFER x_S FOR _S.
 
  /* You should only be able to delete 1 page at a time.  This is just a
     check.  Set_Sensitivity should have disabled the button if two pages are
     selected. */
  ASSIGN s_page.
  IF NUM-ENTRIES(s_page, CHR(10)) ne 1 THEN RETURN.
  
  /* Confirm the deletion. */
  MESSAGE "Are you sure you want to delete all SmartObjects on Page" 
          LEFT-TRIM(STRING(this-page, "{&fmt}"))  "?"
          VIEW-AS ALERT-BOX QUESTION BUTTONS OK-CANCEL UPDATE ans.
  IF ans THEN DO:
    /* Delete everything on this page... */
    FOR EACH x_U WHERE x_U._WINDOW-HANDLE eq _P._WINDOW-HANDLE 
                   AND x_U._STATUS eq "NORMAL" AND x_U._TYPE eq "SmartObject", 
        FIRST x_S WHERE RECID(x_S) eq x_U._x-recid AND x_S._page-number eq this-page:
      /* We don't actually delete them, because the user might change their mind and
         cancel. Just mark this for a later deletion */
      x_U._STATUS = "DELETE-PENDING".
    END.
    
    /* Remove the page from the selection list, unless it is 0. */
    IF this-page ne 0 THEN DO:
      ASSIGN ldummy              = s_page:DELETE (s_page)
             this-page           = 0
             s_page              = "{&Main}"
             s_page:SCREEN-VALUE = s_page
             .  
      /* Set the sensitivity of buttons etc. */
      RUN Set_Sensitivity.
    END.
    
    /* Show the empty page */
    RUN Reopen_Query.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b_design
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b_design f_dlg
ON CHOOSE OF b_design IN FRAME f_dlg /* Design... */
DO:
  /* Set the page the UIB will show at design time */
  RUN ask4page ("Design Page", INPUT-OUTPUT _P._page-current).
  DISPLAY _P._page-current @ fi_current WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b_goto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b_goto f_dlg
ON CHOOSE OF b_goto IN FRAME f_dlg /* Page... */
DO:
  DEFINE VARIABLE new-page AS INTEGER NO-UNDO.
  
  new-page = this-page.
  RUN ask4page ("Goto Page", INPUT-OUTPUT new-page).
  IF new-page ne this-page THEN DO:
    RUN Add_Page (new-page).
    ASSIGN this-page           = new-page
           s_page              = IF this-page eq 0 THEN "{&Main}"
                                 ELSE LEFT-TRIM(STRING(this-page, "{&fmt}" ))
           /* Setting SCREEN-VALUE of multi-select list does not deselect the
              old values (unless you explicitly set the value to ? first.) */
           s_page:SCREEN-VALUE = ?
           s_page:SCREEN-VALUE = s_page.
    /* Reset the interface */
    RUN Set_Sensitivity.
    RUN Reopen_Query.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b_Move-obj
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b_Move-obj f_dlg
ON CHOOSE OF b_Move-obj IN FRAME f_dlg /* Move to Page... */
DO:
  /* Move the selected objects in the browse to a new page. */
  RUN Move_Selected_to_Page.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b_select
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b_select f_dlg
ON CHOOSE OF b_select IN FRAME f_dlg /* Start... */
DO:
  /* Set the UIB's Startup page (i.e. the page to startup on at run-time) */
  RUN ask4page ("Startup on Page", INPUT-OUTPUT _P._page-select).
  DISPLAY _P._page-select @ fi_select WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b_swap
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b_swap f_dlg
ON CHOOSE OF b_swap IN FRAME f_dlg /* Swap Pages */
DO:
  /* Swap everything on page-A to page-B (using "?" as an intermediate). */
  RUN Move_Page (page-A, ?).
  RUN Move_Page (page-B, page-A).
  RUN Move_Page (?, page-B).
  /* Redisplay the current page (because everything on it just moved). */
  RUN Reopen_Query.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME s_page
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL s_page f_dlg
ON DEFAULT-ACTION OF s_page IN FRAME f_dlg
DO:
  /* Set the UIB's current page */
  _P._page-current = this-page.
  DISPLAY this-page @ fi_current WITH FRAME {&FRAME-NAME}. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL s_page f_dlg
ON VALUE-CHANGED OF s_page IN FRAME f_dlg
DO:
  
  /* Assign the value and set the current page */
  ASSIGN s_page.
  
  /* Set the sensitivity of buttons etc. */
  RUN Set_Sensitivity.

  /* Reopen the browse query */
  RUN Reopen_Query.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK f_dlg 


/* *************************  Standard Buttons ************************ */

&Scoped-define USE-3D YES
{ adecomm/okbar.i &TOOL = "AB"
                  &CONTEXT = {&Pages_Dlg_Box}
                  }

/* ***************************  Main Block  *************************** */

/* Parent the dialog-box to the ACTIVE-WINDOW, if there is no parent.   */
IF VALID-HANDLE(ACTIVE-WINDOW) AND FRAME {&FRAME-NAME}:PARENT eq ?
THEN FRAME {&FRAME-NAME}:PARENT = ACTIVE-WINDOW.

/* Add Trigger to equate WINDOW-CLOSE to END-ERROR                      */
ON WINDOW-CLOSE OF FRAME {&FRAME-NAME} APPLY "END-ERROR":U TO SELF.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */

/* Get this procedure */
FIND _P WHERE RECID(_P) eq p_Precid.
FIND _U WHERE RECID(_U) eq _P._u-recid.

/* Fill in some values */
ASSIGN fi_current = _P._page-current
       fi_select  = _P._page-select
       l_master   = _U._LAYOUT-NAME eq "Master Layout":U
       .

/* Set some attributes in the frame. */
DO WITH FRAME {&FRAME-NAME}:
  ASSIGN ldummy  = {&BROWSE-NAME}:MOVE-AFTER-TAB-ITEM (b_swap:HANDLE)
         s_page:DELIMITER = CHR(10)
         /* {&BROWSE-NAME}:MULTIPLE = YES -- I don't know why this doesn't work */
         {&BROWSE-NAME}:NUM-LOCKED-COLUMNS = 1.
END.
       .
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
  RUN Find_Pages.
  IF RETURN-VALUE = "NONE" THEN RETURN.
  RUN enable_UI.
  RUN Set_Sensitivity.
  ENABLE {&BROWSE-NAME} WITH FRAME {&FRAME-NAME}.
  RUN Reopen_Query.
  WAIT-FOR GO OF FRAME {&FRAME-NAME}.
END.
RUN disable_UI.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Add_Page f_dlg 
PROCEDURE Add_Page :
/*------------------------------------------------------------------------------
  Purpose:     Make sure that the new-page is in the selection list.  If not
               then add it.
  Parameters:  iPage -- the number of the new page
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER piPage AS INTEGER NO-UNDO.
  
  DEFINE VARIABLE cnt AS INTEGER NO-UNDO.
  DEFINE VARIABLE cPage AS CHAR NO-UNDO.
  DEFINE VARIABLE i AS INTEGER NO-UNDO.
  DEFINE VARIABLE iValue AS INTEGER NO-UNDO.
  
  /* We usually show the first N pages.  However, we could have deleted one
     of them with the "Delete..." button. */
  DO WITH FRAME {&FRAME-NAME}:
    /* Is the page in the list? */
    cPage = TRIM(STRING(piPage, "{&fmt}")).
    IF s_page:LOOKUP(cPage) eq 0 THEN DO:
      ASSIGN cnt = s_page:NUM-ITEMS
             i   = {&Base-Pages} + 1 
             .
      SEARCH-LOOP:
      DO WHILE i <= cnt:
        /* If piPage < this page, then we have found where to insert it. */
        iValue = INTEGER(s_page:ENTRY(i)).
        IF iValue > piPage THEN LEAVE SEARCH-LOOP.
        i = i + 1.
      END. /* SEARCH-LOOP: DO... */
      /* Add the value */
      IF i <= cnt THEN ldummy = s_page:INSERT(cPage,i).
      ELSE ldummy = s_page:ADD-LAST (cPage).
    END. /* IF s_page:LOOKUP(cPage)... */
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ask4page f_dlg 
PROCEDURE ask4page :
/*------------------------------------------------------------------------------
  Purpose:  Puts up a small dialog-box that a user can enter a page-number into.  
  Parameters: INPUT-OUTPUT ppage-no
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT        PARAMETER pcTitle  AS CHAR    NO-UNDO.
  DEFINE INPUT-OUTPUT PARAMETER ppage-no AS INTEGER NO-UNDO.

  /* Define a simple dialog-box (NOTE that the Btn_OK and Btn_Cancel were defined
     in adecomm/okform.i */
  DEFINE FRAME f_page
     ppage-no   LABEL "Page Number" FORMAT "{&fmt}" VIEW-AS FILL-IN {&STDPH_FILL}
                AT ROW 1.4 COL 20 COLON-ALIGNED
     "Note - the ~"Main~" page (i.e. 0) is always shown."
                VIEW-AS TEXT SIZE 55 BY 1
                AT ROW 2.6 COL 2.5   
     SPACE({&HFM_WID})  
     SKIP ({&IVM_OKBOX})  SPACE(12)
     Btn_OK space({&HM_DBTN}) Btn_Cancel SPACE({&HFM_WID})
     SKIP({&TFM_WID})
     WITH THREE-D SIDE-LABELS
          VIEW-AS DIALOG-BOX DEFAULT-BUTTON Btn_OK CANCEL-BUTTON Btn_Cancel.
     
  FRAME f_page:TITLE = pcTitle.
  
  UPDATE ppage-no Btn_OK Btn_Cancel WITH FRAME f_page.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI f_dlg  _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Hide all frames. */
  HIDE FRAME f_dlg.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI f_dlg  _DEFAULT-ENABLE
PROCEDURE enable_UI :
/*------------------------------------------------------------------------------
  Purpose:     ENABLE the User Interface
  Parameters:  <none>
  Notes:       Here we display/view/enable the widgets in the
               user-interface.  In addition, OPEN all queries
               associated with each FRAME and BROWSE.
               These statements here are based on the "Other 
               Settings" section of the widget Property Sheets.
------------------------------------------------------------------------------*/
  DISPLAY s_page fi_current fi_select 
      WITH FRAME f_dlg.
  ENABLE RECT-6 RECT-5 RECT-4 RECT-3 s_page b_goto br_sos fi_current fi_select 
      WITH FRAME f_dlg.
  VIEW FRAME f_dlg.
  {&OPEN-BROWSERS-IN-QUERY-f_dlg}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Find_Pages f_dlg 
PROCEDURE Find_Pages :
/* -----------------------------------------------------------
  Purpose:     Find the Pages used in the current _P record.
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE VARIABLE pages AS CHAR NO-UNDO.
  DEFINE VARIABLE i     AS INTEGER NO-UNDO.
  
  DEFINE BUFFER ipU FOR _U.
  DEFINE BUFFER ipS FOR _S.
  
  /* We always show the first Base-Pages pages (plus "Main") */
  pages = "{&Main}".
  DO i = 1 to {&Base-Pages}:
    pages = pages + CHR(10) + LEFT-TRIM(STRING(i, "{&fmt}")).
  END.
  
  /* Add in any other pages used */
  FOR EACH ipU WHERE ipU._WINDOW-HANDLE eq _P._WINDOW-HANDLE
                 AND ipU._TYPE eq "SmartObject"
                 AND ipU._STATUS ne "DELETED",
     FIRST ipS WHERE RECID(ipS) eq ipU._x-recid
                 AND ipS._page-number > {&Base-Pages}
     BREAK BY ipS._page-number:
    IF FIRST-OF (ipS._page-number) 
    THEN pages = pages + CHR(10) + LEFT-TRIM(STRING(ipS._page-number, "{&fmt}")).
  END.
     
  /* Set the pages in the selection-list */
  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN s_page:LIST-ITEMS = pages
           this-page         = 0
           s_page            = "{&Main}"
           .
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Move_Page f_dlg 
PROCEDURE Move_Page :
/*------------------------------------------------------------------------------
  Purpose:     Move everything on the old-page to the new-page.
  Parameters:  old-page -- the old page number
               new-page -- the new page number
       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER old-page AS INTEGER NO-UNDO.
  DEFINE INPUT PARAMETER new-page AS INTEGER NO-UNDO.

  DEFINE BUFFER ipU FOR _U.
  DEFINE BUFFER ipS FOR _S.
  
  IF old-page ne new-page THEN DO:
    FOR EACH ipU WHERE ipU._WINDOW-HANDLE eq _P._WINDOW-HANDLE
                  AND ipU._TYPE eq "SmartObject",
        EACH ipS WHERE RECID(ipS) eq ipU._x-recid
                   AND ipS._page-number eq old-page :
      ipS._page-number = new-page.
    END.
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Move_Selected_to_Page f_dlg 
PROCEDURE Move_Selected_to_Page :
/*------------------------------------------------------------------------------
  Purpose:     Move the selected objects in the browse to a new page. 
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE new-page AS INTEGER NO-UNDO.
  DEFINE VARIABLE i        AS INTEGER NO-UNDO.
  
  /* This button should not be enabled if there is no current SmartObject */
  IF NOT AVAILABLE _S THEN SELF:SENSITIVE = no.
  ELSE DO WITH FRAME {&FRAME-NAME}:
    new-page = _S._Page-Number.
    RUN ask4page ("Move to Page", INPUT-OUTPUT new-page).
    /* Move it */
    IF new-page ne _S._Page-Number THEN DO:
      /* Make sure the page is displayed */
      RUN Add_Page (new-page).

      /* Move all the selected objects */
      DO i = 1 TO {&BROWSE-NAME}:NUM-SELECTED-ROWS:
        IF {&BROWSE-NAME}:FETCH-SELECTED-ROW (i)
        THEN _S._Page-Number = new-page.
      END.
    
      RUN Reopen_Query.
    END.
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Reopen_Query f_dlg 
PROCEDURE Reopen_Query :
/* -----------------------------------------------------------
  Purpose:     Reopen the query
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DO WITH FRAME {&FRAME-NAME}:
    
    /* Show the current page */
    ASSIGN contents              = " Contents of Page " + 
                                     LEFT-TRIM(STRING(this-page, "{&fmt}")) + " "
           contents:WIDTH-P      = FONT-TABLE:GET-TEXT-WIDTH-P 
                                     (contents, contents:FONT)
           contents:SCREEN-VALUE = contents
           .
    /* Open the query */
    {&OPEN-QUERY-{&BROWSE-NAME}}  
    
    /* Enable and disable buttons, as appropriate */
    ASSIGN b_del-obj:SENSITIVE  = ({&BROWSE-NAME}:NUM-SELECTED-ROWS > 0)
           b_move-obj:SENSITIVE = b_del-obj:SENSITIVE
           .   
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Set_Sensitivity f_dlg 
PROCEDURE Set_Sensitivity :
/*------------------------------------------------------------------------------
  Purpose:     Set the sensitivity of various buttons in the dialog-box  
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/ 
  DEFINE VARIABLE cnt        AS INTEGER NO-UNDO.
  DEFINE VARIABLE cnt-not-0  AS INTEGER NO-UNDO.
  DEFINE VARIABLE cThis-page AS CHAR    NO-UNDO.
  
  DO WITH FRAME {&FRAME-NAME}:
    cnt = NUM-ENTRIES(s_page,CHR(10))
           .
    /* Get the count not including page 0 */
    IF ENTRY(1, s_page, CHR(10)) eq  "{&Main}" THEN cnt-not-0 = cnt - 1.
    ELSE cnt-not-0 = cnt.
    
    CASE cnt:
      WHEN 0 THEN this-page = ?.
      WHEN 1 THEN DO:
        If s_page eq "{&Main}" THEN this-page = 0.
        ELSE this-page = INTEGER(s_page).
      END.
      OTHERWISE DO:
        /* Set the page to the first selected, if it isn't already in the list. */
        cThis-page = IF this-page eq 0
                     THEN "{&Main}"
                     ELSE LEFT-TRIM ( STRING (this-page, "{&fmt}" )).
        IF NOT s_page:IS-SELECTED (cThis-page)
        THEN DO:
          cThis-page = ENTRY(1, s_page, CHR(10)).
          If cThis-page eq "{&Main}" THEN this-page = 0.
          ELSE this-page = INTEGER(cThis-page).
        END.
      END.
    END CASE.
    
    /* Sensitize some buttons. You can't change the Design page except in
       the master layout. */
    ASSIGN b_design:SENSITIVE   = (this-page ne ?) AND l_master
           b_select:SENSITIVE   = (this-page ne ?)  
           b_del-page:SENSITIVE = (cnt eq 1)
           .
    
    /* Can we swap pages? If so, label the button "Swap N and M" */
    IF cnt eq 2 and cnt-not-0 eq 2
    THEN ASSIGN page-A           = INTEGER (ENTRY(1,s_page,CHR(10)))
                page-B           = INTEGER (ENTRY(2,s_page,CHR(10)))
                b_swap:SENSITIVE = yes
                b_swap:LABEL     = "S&wap " + TRIM(ENTRY(1,s_page,CHR(10))) +
                                   " and "  + TRIM(ENTRY(2,s_page,CHR(10))) .
    ELSE ASSIGN page-A           = 0
                page-B           = 0
                b_swap:SENSITIVE = no
                b_swap:LABEL     = "S&wap Pages" .
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

