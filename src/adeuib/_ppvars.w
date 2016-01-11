&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME f_dlg
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS f_dlg 
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
/*------------------------------------------------------------------------

  File: _ppvars.w

  Description: Dialog to change the names of preprocessor variables in
               a UIB .w file.

  Input-Output Parameters:
      pcLists: a comma delimited list of names for the User Lists
               (formally known as LIST-1, LIST-2 etc.)

  Output Parameters:
      <none>

  Author: Wm.T.Wood

  Created: 02/16/95 -  2:18 am

------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */
/* NOTE that we use PROGRESS to UNDO the changes if the user cancels -- */
/* So do NOT make the input list NO-UNDO.                               */
&IF DEFINED(UIB_is_Running) eq 0 &THEN
  DEFINE INPUT-OUTPUT PARAMETER pcLists AS CHAR. /* Do not make NO-UNDO */
&ELSE
  DEFINE VAR pcLists AS CHAR INITIAL "aaa,bbb,ccc,ddd,eee,fff".
&ENDIF

&GLOBAL-DEFINE WIN95-BTN YES

/* Shared Variable Definitions ---                                      */
{adecomm/adestds.i} /* Standard Definitions             */ 
{adeuib/uibhlp.i}   /* Help pre-processor directives    */

/* Local Variable Definitions ---                                       */
define var lOK as logical no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DIALOG-BOX

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f_dlg

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS LIST-1 LIST-2 LIST-3 LIST-4 LIST-5 LIST-6 
&Scoped-Define DISPLAYED-OBJECTS LIST-1 LIST-2 LIST-3 LIST-4 LIST-5 LIST-6 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE VARIABLE LIST-1 AS CHARACTER FORMAT "X(256)":U 
     LABEL "List-&1" 
     VIEW-AS FILL-IN 
     SIZE 37 BY 1 NO-UNDO.

DEFINE VARIABLE LIST-2 AS CHARACTER FORMAT "X(256)":U 
     LABEL "List-&2" 
     VIEW-AS FILL-IN 
     SIZE 37 BY 1 NO-UNDO.

DEFINE VARIABLE LIST-3 AS CHARACTER FORMAT "X(256)":U 
     LABEL "List-&3" 
     VIEW-AS FILL-IN 
     SIZE 37 BY 1 NO-UNDO.

DEFINE VARIABLE LIST-4 AS CHARACTER FORMAT "X(256)":U 
     LABEL "List-&4" 
     VIEW-AS FILL-IN 
     SIZE 37 BY 1 NO-UNDO.

DEFINE VARIABLE LIST-5 AS CHARACTER FORMAT "X(256)":U 
     LABEL "List-&5" 
     VIEW-AS FILL-IN 
     SIZE 37 BY 1 NO-UNDO.

DEFINE VARIABLE LIST-6 AS CHARACTER FORMAT "X(256)":U 
     LABEL "List-&6" 
     VIEW-AS FILL-IN 
     SIZE 37 BY 1 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f_dlg
     LIST-1 AT ROW 2 COL 9 COLON-ALIGNED
     LIST-2 AT ROW 3 COL 9 COLON-ALIGNED
     LIST-3 AT ROW 4 COL 9 COLON-ALIGNED
     LIST-4 AT ROW 5 COL 9 COLON-ALIGNED
     LIST-5 AT ROW 6 COL 9 COLON-ALIGNED
     LIST-6 AT ROW 7 COL 9 COLON-ALIGNED
     "Enter Names for Preprocessor Lists" VIEW-AS TEXT
          SIZE 39.6 BY .67 AT ROW 1.19 COL 2
     SPACE(6.40) SKIP(6.41)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         TITLE "Custom Lists":L.

 

/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: DIALOG-BOX
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX f_dlg
   Default                                                              */
ASSIGN 
       FRAME f_dlg:SCROLLABLE       = FALSE
       FRAME f_dlg:HIDDEN           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME f_dlg
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL f_dlg f_dlg
ON WINDOW-CLOSE OF FRAME f_dlg /* Custom Lists */
DO:
   /* Add Trigger to equate WINDOW-CLOSE to END-ERROR  */
   APPLY "END-ERROR":U TO SELF. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME LIST-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL LIST-1 f_dlg
ON LEAVE OF LIST-1 IN FRAME f_dlg /* List-1 */
DO:  
  RUN leave-list-name (1, OUTPUT lOK).  
  IF lOK eq FALSE THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME LIST-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL LIST-2 f_dlg
ON LEAVE OF LIST-2 IN FRAME f_dlg /* List-2 */
DO:
  RUN leave-list-name (2, OUTPUT lOK).  
  IF lOK eq FALSE THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME LIST-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL LIST-3 f_dlg
ON LEAVE OF LIST-3 IN FRAME f_dlg /* List-3 */
DO:
  RUN leave-list-name (3, OUTPUT lOK).  
  IF lOK eq FALSE THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME LIST-4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL LIST-4 f_dlg
ON LEAVE OF LIST-4 IN FRAME f_dlg /* List-4 */
DO:
  RUN leave-list-name (4, OUTPUT lOK).  
  IF lOK eq FALSE THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME LIST-5
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL LIST-5 f_dlg
ON LEAVE OF LIST-5 IN FRAME f_dlg /* List-5 */
DO:
  RUN leave-list-name (5, OUTPUT lOK).  
  IF lOK eq FALSE THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME LIST-6
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL LIST-6 f_dlg
ON LEAVE OF LIST-6 IN FRAME f_dlg /* List-6 */
DO:
  RUN leave-list-name (6, OUTPUT lOK).  
  IF lOK eq FALSE THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK f_dlg 


/* *************************  Standard Buttons ************************ */

{ adecomm/okbar.i &TOOL = "AB"
                  &CONTEXT = {&Custom_Lists_Dlg_Box}
                  }

/* ***************************  Main Block  *************************** */

/* In 7.4 this is defined automatically */
&Scoped-define DISPLAY LIST-1 LIST-2 LIST-3 LIST-4 LIST-5 LIST-6

/* Parent the dialog-box to the ACTIVE-WINDOW, if there is no parent.   */
IF VALID-HANDLE(ACTIVE-WINDOW) AND FRAME {&FRAME-NAME}:PARENT eq ?
THEN FRAME {&FRAME-NAME}:PARENT = ACTIVE-WINDOW.

/* Initialize the Lists -- note that there must be 6. */
ASSIGN LIST-1 = ENTRY(1, pcLists)
       LIST-2 = ENTRY(2, pcLists)
       LIST-3 = ENTRY(3, pcLists)
       LIST-4 = ENTRY(4, pcLists)
       LIST-5 = ENTRY(5, pcLists)
       LIST-6 = ENTRY(6, pcLists)
       .
/* If there are too few lists, then reinitialize them */
IF LIST-1 eq "":U THEN LIST-1 = "List-1".
IF LIST-2 eq "":U THEN LIST-2 = "List-2".
IF LIST-3 eq "":U THEN LIST-3 = "List-3".
IF LIST-4 eq "":U THEN LIST-4 = "List-4".
IF LIST-5 eq "":U THEN LIST-5 = "List-5".
IF LIST-6 eq "":U THEN LIST-6 = "List-6".

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
  RUN enable_UI.
  WAIT-FOR GO OF FRAME {&FRAME-NAME}. 
END.
RUN disable_UI.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI f_dlg _DEFAULT-DISABLE
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI f_dlg _DEFAULT-ENABLE
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
  DISPLAY LIST-1 LIST-2 LIST-3 LIST-4 LIST-5 LIST-6 
      WITH FRAME f_dlg.
  ENABLE LIST-1 LIST-2 LIST-3 LIST-4 LIST-5 LIST-6 
      WITH FRAME f_dlg.
  VIEW FRAME f_dlg.
  {&OPEN-BROWSERS-IN-QUERY-f_dlg}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE leave-list-name f_dlg 
PROCEDURE leave-list-name :
/* -----------------------------------------------------------
  Purpose: Run this code when you leave any of the fields that
           define the name of a User-List Preprocessor variable.    
  Parameters:
    INPUT  pIndex - the index of the list (1 to 6)
    OUTPUT pOK - TRUE if name is OK, FALSE if an error
  Notes: We check only for the fact that the value entered is
         a legal keyword, and that it is not used in one of the
         other lists. 
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pIndex AS INTEGER NO-UNDO.
  DEFINE OUTPUT PARAMETER pOK   AS LOGICAL NO-UNDO.
  
  DEFINE VAR test AS CHAR NO-UNDO.
  DEFINE VAR i    AS INTEGER NO-UNDO.
   
  /* Test the new value */
  ASSIGN test = SELF:SCREEN-VALUE.
         pOK  = false.
  
  /* Is it a valid PROGRESS identifier */
  if test = ""  then do:
      message "Please enter a value for the name." SKIP
              "It may not be left blank."
              view-as ALERT-BOX ERROR buttons OK.
      RETURN.
  end.
   
  if SUBSTRING(test,1,1) < "A" OR 
        SUBSTRING(test,1,1) > "Z" then do:
    message "A valid PROGRESS preprocessor name must start with a letter." SKIP
            "Please enter another name."
            view-as ALERT-BOX ERROR buttons OK.
    RETURN.
  end.
  /* Check all other characters */
  pOK = true.
  do i = 2 to LENGTH(test, "CHARACTER") while pOK:
    pOK = INDEX("#$%&-_0123456789ETAONRISHDLFCMUGYPWBVKXJQZ",
                     SUBSTRING(test,i,1)) > 0.
  end.
  if NOT pOK then do:
    message "This name contains at least one invalid character: " + 
            SUBSTR(test, i - 1, 1, "CHARACTER")  SKIP
            "Please enter another name."
            view-as ALERT-BOX ERROR buttons OK.
    RETURN.
  end.
  /* Is the name already used */
  ASSIGN i = LOOKUP(test, pcLists).
         pOK =  i eq 0 OR i eq pIndex /* Not Used, or equal to itself */
         .
  if NOT pOK then
    message "This name is already used. " + 
            "Please enter another name."
            view-as ALERT-BOX ERROR buttons OK.
  /* Store the new values */
  if pOK THEN ASSIGN ENTRY(pIndex, pcLists) = test.   
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


