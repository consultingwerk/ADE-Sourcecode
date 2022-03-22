&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME Dialog-Frame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Dialog-Frame 
/*********************************************************************
* Copyright (C) 2005 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*------------------------------------------------------------------------

  File: adeuib/_get-sdo.w

  Description: Procedure to ask the user for a SmartData object file name.
               This returns either a valid filename or blank (if canceled).

  Input Parameters:
      pName  - The name of a column in the SmartData object
      pType  - The type of object this is being called for - can be
               SmartViewer or SmartBrowser

  Output Parameters:
      filenm - Either a valid SDO filename or blank

  Author: Ross Hunter

  Created: 3/24/98
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

{adeuib/sharvars.i}
/* Parameters Definitions ---                                           */
DEFINE INPUT  PARAMETER pName  AS CHARACTER                       NO-UNDO.
DEFINE INPUT  PARAMETER pType  AS CHARACTER                       NO-UNDO.
DEFINE OUTPUT PARAMETER filenm AS CHARACTER                       NO-UNDO.

/* Local Variable Definitions ---                                       */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DIALOG-BOX
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME Dialog-Frame

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS Instructions Btn_OK Btn_Cancel sdo ~
btn-browse Btn_Help 
&Scoped-Define DISPLAYED-OBJECTS Instructions sdo 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON btn-browse 
     LABEL "&Browse..." 
     SIZE 15 BY 1.14.

DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     LABEL "Cancel" 
     SIZE 15 BY 1.14
     BGCOLOR 8 .

DEFINE BUTTON Btn_Help 
     LABEL "&Help" 
     SIZE 15 BY 1.14
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK AUTO-GO 
     LABEL "OK" 
     SIZE 15 BY 1.14
     BGCOLOR 8 .

DEFINE VARIABLE Instructions AS CHARACTER 
     VIEW-AS EDITOR NO-BOX
     SIZE 57 BY 2.86
     FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE sdo AS CHARACTER FORMAT "X(256)":U 
     LABEL "Filename" 
     VIEW-AS FILL-IN 
     SIZE 30 BY 1 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME Dialog-Frame
     Instructions AT ROW 1.48 COL 4 NO-LABEL
     Btn_OK AT ROW 1.48 COL 65
     Btn_Cancel AT ROW 2.71 COL 65
     sdo AT ROW 4.57 COL 11 COLON-ALIGNED
     btn-browse AT ROW 4.57 COL 43
     Btn_Help AT ROW 4.71 COL 65
     SPACE(1.59) SKIP(1.09)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         TITLE "Select a SmartDataObject"
         DEFAULT-BUTTON Btn_OK CANCEL-BUTTON Btn_Cancel.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: DIALOG-BOX
   Allow: Basic,Browse,DB-Fields,Query
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX Dialog-Frame
   FRAME-NAME                                                           */
ASSIGN 
       FRAME Dialog-Frame:SCROLLABLE       = FALSE
       FRAME Dialog-Frame:HIDDEN           = TRUE.

ASSIGN 
       Instructions:READ-ONLY IN FRAME Dialog-Frame        = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME Dialog-Frame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Dialog-Frame Dialog-Frame
ON WINDOW-CLOSE OF FRAME Dialog-Frame /* Select a SmartDataObject */
DO:
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btn-browse
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btn-browse Dialog-Frame
ON CHOOSE OF btn-browse IN FRAME Dialog-Frame /* Browse... */
DO:
  DEFINE VARIABLE s       AS LOGICAL            NO-UNDO.
  DEFINE VARIABLE tmpName AS CHARACTER          NO-UNDO.

  SYSTEM-DIALOG GET-FILE sdo
        TITLE  "Choose a SmartDataObject"
        FILTERS "Converted SmartQueries (q*.w)" "q*.w",
                "SmartDataObject Files (d*.w)"  "d*.w",
                "All Files (*.*)"  "*.*"
        INITIAL-DIR "~."
        DEFAULT-EXTENSION ".w"
        UPDATE s.    
                                            
  IF s THEN DO:
    RUN adecomm/_relname.p (INPUT replace(sdo, "~/", "~\"),
                            INPUT "must-exist",
                            OUTPUT tmpName).
    sdo = tmpName.
  END.
  ELSE sdo = ?.
  DISPLAY sdo WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Cancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Cancel Dialog-Frame
ON CHOOSE OF Btn_Cancel IN FRAME Dialog-Frame /* Cancel */
DO:
  filenm = "".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Help
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Help Dialog-Frame
ON CHOOSE OF Btn_Help IN FRAME Dialog-Frame /* Help */
OR HELP OF FRAME {&FRAME-NAME}
DO: /* Call Help Function (or a simple message). */
  MESSAGE "Help for File: {&FILE-NAME}" VIEW-AS ALERT-BOX INFORMATION.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK Dialog-Frame
ON CHOOSE OF Btn_OK IN FRAME Dialog-Frame /* OK */
DO:
  DEFINE VARIABLE tmpHandle  AS HANDLE                          NO-UNDO.
  DEFINE VARIABLE tmpString  AS CHARACTER                       NO-UNDO.
  DEFINE VARIABLE tmpLogical AS LOGICAL                         NO-UNDO.

  /* Test if sdo is a valid SmartData object */
  IF sdo ne "" THEN DO:
    tmpHandle = DYNAMIC-FUNC("get-sdo-hdl" IN _h_func_lib, INPUT sdo, 
                                                           INPUT TARGET-PROCEDURE).
    IF VALID-HANDLE(tmpHandle) THEN DO:
      /* test to see if this is a reasonable SmartData object */

      /* Make sure that it is a SmartDataObject */
      tmpString = DYNAMIC-FUNC("getObjectType" IN tmpHandle) NO-ERROR.
      IF tmpString NE "SmartDataObject" THEN DO:
        MESSAGE '"' + sdo + '" is not a SmartDataObject.' SKIP
                'Do you want to select another object?'
           VIEW-AS ALERT-BOX QUESTION BUTTONS Yes-No UPDATE tmpLogical.
        IF tmpLogical THEN DO:
          DYNAMIC-FUNCTION("shutdown-sdo" IN _h_func_lib,TARGET-PROCEDURE).
          RETURN NO-APPLY.
        END.
      END.  /* If it is not a SmartDataObject */

      /* Use ColumnReadOnly to see if pName is a valid column name */
      tmpLogical = DYNAMIC-FUNC("columnReadOnly" IN tmpHandle, pName) NO-ERROR.
      IF ERROR-STATUS:ERROR OR tmpLogical = ? THEN DO:
        MESSAGE '"' + sdo + '" is an incompatible SmartDataObject.' SKIP
                'Please choose another.' VIEW-AS ALERT-BOX ERROR.
        DYNAMIC-FUNCTION("shutdown-sdo" IN _h_func_lib, TARGET-PROCEDURE).
        RETURN NO-APPLY.
      END.
       
      filenm = sdo.
      /* Shutdown the sdo */
      DYNAMIC-FUNCTION("shutdown-sdo" IN _h_func_lib,TARGET-PROCEDURE).
    END.  /* tmp_handle is valid */

    ELSE filenm = "".

  END.  /* If sdo is non-blank */
  ELSE filenm = "".
  IF filenm = "" THEN DO:
    MESSAGE "You have not specified a valid SmartDataObject." VIEW-AS ALERT-BOX.
    RETURN NO-APPLY.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Dialog-Frame 


/* ***************************  Main Block  *************************** */

/* Parent the dialog-box to the ACTIVE-WINDOW, if there is no parent.   */
IF VALID-HANDLE(ACTIVE-WINDOW) AND FRAME {&FRAME-NAME}:PARENT eq ?
THEN FRAME {&FRAME-NAME}:PARENT = ACTIVE-WINDOW.


/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
  Instructions = "This " + pType + " was generated from a Version 8 " +
                 pType + " and needs a valid SmartDataObject to " +
                 "properly load.  Please enter the filename of a " +
                 "valid SmartDataObject:".
  RUN enable_UI.
  WAIT-FOR GO OF FRAME {&FRAME-NAME}.
END.
RUN disable_UI.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI Dialog-Frame  _DEFAULT-DISABLE
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
  HIDE FRAME Dialog-Frame.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI Dialog-Frame  _DEFAULT-ENABLE
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
  DISPLAY Instructions sdo 
      WITH FRAME Dialog-Frame.
  ENABLE Instructions Btn_OK Btn_Cancel sdo btn-browse Btn_Help 
      WITH FRAME Dialog-Frame.
  VIEW FRAME Dialog-Frame.
  {&OPEN-BROWSERS-IN-QUERY-Dialog-Frame}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

