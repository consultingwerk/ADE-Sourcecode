/* Connected Databases 
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME f_dlg
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
define variable xTitle as character no-undo init "Pages".
/* Preprocessor Definitions ---                                         */  
&Scope Main 0 [Main]
&Scope Base-Pages 16
&Scope fmt  >,>>>,>>9




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
DEFINE QUERY br_sos FOR 
      _U, 
      _S SCROLLING.

/* Browse definitions                                                   */
DEFINE BROWSE br_sos
  QUERY br_sos DISPLAY
      _U._NAME LABEL "Name"                 FORMAT "X(20)"
     _U._SUBTYPE LABEL "Type"              FORMAT "X(32)"
     _S._FILE-NAME LABEL "Master File"     FORMAT "X(64)"
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
    WITH 
    &if defined(IDE-Is-RUNNING) = 0 &then
    VIEW-AS DIALOG-BOX 
    TITLE xTitle
    &else
    no-box
    &endif
    KEEP-TAB-ORDER 
    SIDE-LABELS NO-UNDERLINE NO-VALIDATE THREE-D  SCROLLABLE .
         

/* *********************** Procedure Settings ************************ */





/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

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


/* Setting information for Queries and Browse Widgets fields            */

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

 



/* ************************  Control Triggers  ************************ */

&Scoped-define BROWSE-NAME br_sos
&Scoped-define SELF-NAME br_sos
ON DEFAULT-ACTION OF br_sos IN FRAME f_dlg
DO:
  /* Move the selected objects in the browse to a new page.*/
  RUN Move_Selected_to_Page.
END.



ON VALUE-CHANGED OF br_sos IN FRAME f_dlg
DO:
  /* Enable and disable buttons, as appropriate */
  ASSIGN b_del-obj:SENSITIVE  = (SELF:NUM-SELECTED-ROWS > 0)
         b_move-obj:SENSITIVE = b_del-obj:SENSITIVE
         . 
END.



&Scoped-define SELF-NAME b_del-obj
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



&Scoped-define SELF-NAME b_del-page
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



&Scoped-define SELF-NAME b_design
ON CHOOSE OF b_design IN FRAME f_dlg /* Design... */
DO:
    run chooseDesignPage.  
END.

&Scoped-define SELF-NAME b_goto
ON CHOOSE OF b_goto IN FRAME f_dlg /* Page... */
DO:
    run chooseGoToPage.
END.



&Scoped-define SELF-NAME b_Move-obj
ON CHOOSE OF b_Move-obj IN FRAME f_dlg /* Move to Page... */
DO:
  /* Move the selected objects in the browse to a new page. */
  RUN Move_Selected_to_Page.
END.



&Scoped-define SELF-NAME b_select
ON CHOOSE OF b_select IN FRAME f_dlg /* Start... */
DO:
  /* Set the UIB's Startup page (i.e. the page to startup on at run-time) */
  run chooseStartupPage.
END.

&Scoped-define SELF-NAME b_swap
ON CHOOSE OF b_swap IN FRAME f_dlg /* Swap Pages */
DO:
  /* Swap everything on page-A to page-B (using "?" as an intermediate). */
  RUN Move_Page (page-A, ?).
  RUN Move_Page (page-B, page-A).
  RUN Move_Page (?, page-B).
  /* Redisplay the current page (because everything on it just moved). */
  RUN Reopen_Query.
END.



&Scoped-define SELF-NAME s_page
ON DEFAULT-ACTION OF s_page IN FRAME f_dlg
DO:
  /* Set the UIB's current page */
  _P._page-current = this-page.
  DISPLAY this-page @ fi_current WITH FRAME {&FRAME-NAME}. 
END.



ON VALUE-CHANGED OF s_page IN FRAME f_dlg
DO:
  
  /* Assign the value and set the current page */
  ASSIGN s_page.
  
  /* Set the sensitivity of buttons etc. */
  RUN Set_Sensitivity.

  /* Reopen the browse query */
  RUN Reopen_Query.
END.



&UNDEFINE SELF-NAME



/* *************************  Standard Buttons ************************ */

&Scoped-define USE-3D YES
{ adecomm/okbar.i &TOOL = "AB"
                  &CONTEXT = {&Pages_Dlg_Box}
                  }

/* ***************************  Main Block  *************************** */

 &if defined(IDE-IS-RUNNING) = 0 &then
/* Parent the dialog-box to the ACTIVE-WINDOW, if there is no parent.   */
IF VALID-HANDLE(ACTIVE-WINDOW) AND FRAME {&FRAME-NAME}:PARENT eq ?
THEN FRAME {&FRAME-NAME}:PARENT = ACTIVE-WINDOW.
&endif

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
{adeuib/ide/dialoginit.i "frame ~{&FRAME-NAME~}:handle}
&SCOPED-DEFINE CANCEL-EVENT U2
{adeuib/ide/dialogstart.i  btn_ok btn_cancel xtitle}
       
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
  RUN Find_Pages.
  IF RETURN-VALUE = "NONE" THEN RETURN.
  RUN enable_UI.
  RUN Set_Sensitivity.
  ENABLE {&BROWSE-NAME} WITH FRAME {&FRAME-NAME}.
  RUN Reopen_Query.
  &if defined(IDE-IS-RUNNING) = 0 &then
  WAIT-FOR GO OF FRAME {&FRAME-NAME}.
  &else
  WAIT-FOR GO OF FRAME {&FRAME-NAME} or "{&CANCEL-EVENT}" of this-procedure.
  if cancelDialog then undo, leave.
  &endif
END.
RUN disable_UI.



/* **********************  Internal Procedures  *********************** */

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

procedure chooseGoToPage:
      &if DEFINED(IDE-IS-RUNNING) = 0 &then
      Run RunGoToPage. 
      &else
      dialogService:SetCurrentEvent(this-procedure,"RunGoToPage").
      run runChildDialog in hOEIDEService (dialogService) .
      &endif
end procedure.

Procedure RunGoToPage:
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
           s_page:SCREEN-VALUE in frame {&FRAME-NAME} = ?
           s_page:SCREEN-VALUE in frame {&FRAME-NAME} = s_page.
    /* Reset the interface */
    RUN Set_Sensitivity.
    RUN Reopen_Query.
  END.
End procedure.
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
     &if DEFINED(IDE-IS-RUNNING) <> 0 &then 
     btn_help SPACE({&HFM_WID}) 
     &endif
     SKIP({&TFM_WID})
     WITH THREE-D SIDE-LABELS
      &if DEFINED(IDE-IS-RUNNING) = 0 &then 
          VIEW-AS DIALOG-BOX
      &else
      No-BOX 
      &endif     
      DEFAULT-BUTTON Btn_OK CANCEL-BUTTON Btn_Cancel.
     
  &if DEFINED(IDE-IS-RUNNING) = 0 &then 
    FRAME f_page:TITLE = pcTitle.
    UPDATE ppage-no Btn_OK Btn_Cancel WITH FRAME f_page.
  &else
      ppage-no:screen-value in frame f_page = string(ppage-no).
      define variable defaultsService as adeuib.idialogservice no-undo.
    
      run CreateDialogService in hOEIDEService(frame f_page:HANDLE,output defaultsService).
      defaultsService:View().
      define variable lCancelDialog as logical no-undo. 
      defaultsService:SetOkButton(btn_OK:handle in frame f_page).
      defaultsService:SetCancelButton(btn_Cancel:handle in frame f_page).
      defaultsService:Title = pcTitle.
      on "choose" of btn_cancel in frame f_page  
      do:
          lCancelDialog = true.
          apply "u3" to this-procedure.
       end.    
       enable ppage-no btn_OK btn_cancel btn_help WITH FRAME f_page.
       defaultsService:View().
       wait-for "CHOOSE"  of btn_OK in FRAME f_page or "u3" of this-procedure.
       Assign ppage-no = integer(ppage-no:screen-value in frame f_page).
       if lcancelDialog then undo, leave.
  &endif
 
END PROCEDURE.


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


PROCEDURE Move_Selected_to_Page :
    RUN chooseMoveToSelectedPage.
END PROCEDURE.


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
procedure chooseMoveToSelectedPage:
      &if DEFINED(IDE-IS-RUNNING) = 0 &then
      Run RunMoveToSelectedPage. 
      &else
      dialogService:SetCurrentEvent(this-procedure,"RunMoveToSelectedPage").
      run runChildDialog in hOEIDEService (dialogService) .
      &endif
end procedure.

procedure RunMoveToSelectedPage: 
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
end procedure.

procedure chooseDesignPage:
    &if DEFINED(IDE-IS-RUNNING) = 0 &then
      Run runDesignPage. 
      &else
      dialogService:SetCurrentEvent(this-procedure,"runDesignPage").
      run runChildDialog in hOEIDEService (dialogService) .
      &endif
end procedure.

procedure runDesignPage: 

/* Set the page the UIB will show at design time */
  RUN ask4page ("Design Page", INPUT-OUTPUT _P._page-current).
  DISPLAY _P._page-current @ fi_current WITH FRAME {&FRAME-NAME}.
end procedure.

procedure chooseStartupPage:
    &if DEFINED(IDE-IS-RUNNING) = 0 &then
      Run runStartupPage. 
      &else
      dialogService:SetCurrentEvent(this-procedure,"runStartupPage").
      run runChildDialog in hOEIDEService (dialogService) .
      &endif
end procedure.

procedure runStartupPage:

RUN ask4page ("Startup on Page", INPUT-OUTPUT _P._page-select).
  DISPLAY _P._page-select @ fi_select WITH FRAME {&FRAME-NAME}.
end procedure.
