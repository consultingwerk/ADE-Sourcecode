&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI ADM2
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME gDialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS gDialog 
/*************************************************************/  
/* Copyright (c) 1984-2005 by Progress Software Corporation  */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from PROGRESS Software Corporation. */
/*************************************************************/
/*------------------------------------------------------------------------

  File: 

  Description: from cntnrdlg.w - ADM2 SmartDialog Template

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: Fernando de Souza

  Created: Feb 23,2005
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */
DEFINE INPUT  PARAMETER pMode        AS CHARACTER NO-UNDO.
DEFINE INPUT  PARAMETER pcFilterName AS CHARACTER NO-UNDO.
DEFINE INPUT  PARAMETER pcFilterSpec AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER pcFileName   AS CHARACTER NO-UNDO.

/* Local Variable Definitions ---                                       */

{src/adm2/widgetprto.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDialog
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER DIALOG-BOX

&Scoped-define ADM-SUPPORTED-LINKS Data-Target,Data-Source,Page-Target,Update-Source,Update-Target

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME gDialog

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS cFileName getFilebtn Btn_OK Btn_Cancel 
&Scoped-Define DISPLAYED-OBJECTS cFileName 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     LABEL "Cancel" 
     SIZE 15 BY 1.14.

DEFINE BUTTON Btn_OK AUTO-GO 
     LABEL "OK" 
     SIZE 15 BY 1.14.

DEFINE BUTTON getFilebtn 
     LABEL "&Browse" 
     SIZE 15 BY 1.14.

DEFINE VARIABLE cFileName AS CHARACTER FORMAT "X(256)":U 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 49 BY 1 TOOLTIP "Name of the file" NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME gDialog
     cFileName AT ROW 1.48 COL 12 COLON-ALIGNED WIDGET-ID 2
     getFilebtn AT ROW 1.48 COL 64 WIDGET-ID 4
     Btn_OK AT ROW 2.91 COL 20 WIDGET-ID 6
     Btn_Cancel AT ROW 2.91 COL 43 WIDGET-ID 8
     SPACE(21.79) SKIP(0.56)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         TITLE ""
         DEFAULT-BUTTON Btn_OK CANCEL-BUTTON Btn_Cancel.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDialog
   Allow: Basic,Browse,DB-Fields,Query,Smart
   Container Links: Data-Target,Data-Source,Page-Target,Update-Source,Update-Target
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB gDialog 
/* ************************* Included-Libraries *********************** */

{src/adm2/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX gDialog
   FRAME-NAME                                                           */
ASSIGN 
       FRAME gDialog:SCROLLABLE       = FALSE
       FRAME gDialog:HIDDEN           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX gDialog
/* Query rebuild information for DIALOG-BOX gDialog
     _Options          = "SHARE-LOCK"
     _Query            is NOT OPENED
*/  /* DIALOG-BOX gDialog */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME gDialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gDialog gDialog
ON GO OF FRAME gDialog
DO:
  
DEFINE VARIABLE cName AS CHAR NO-UNDO.

  /* trim file name value */
  ASSIGN cName = TRIM(cFileName:SCREEN-VALUE).

  IF pMode = "save":U THEN DO:
     /* add the extension .xml if the user didn't add it when saving file */
      
     IF INDEX(pcFilterSpec, ".xml":U) GT 0 AND INDEX(cName, ".xml":U) EQ 0 THEN
        ASSIGN cName = cName + ".xml":U.
  END.


  FILE-INFO:FILE-NAME = cName.
  IF pMode = "save":U THEN DO:

      /* check if file exists and ask for confirmation */
      IF FILE-INFO:FILE-CREATE-DATE <> ? THEN DO:
          MESSAGE "A file already exists with the name " cName SKIP
              "Do you want to overwrite it?"
              VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO 
              UPDATE choice AS LOGICAL.
    
          /* user canceled */
          IF choice = NO THEN
              RETURN NO-APPLY.
      END.
  END.
  ELSE DO:
      /* check if file exists and report error if it does not */
      IF FILE-INFO:FILE-CREATE-DATE = ? THEN DO:
          MESSAGE "ERROR: Could not find file " cName VIEW-AS ALERT-BOX ERROR.    
          RETURN NO-APPLY.
      END.
  END.

  ASSIGN pcFileName = cName.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gDialog gDialog
ON WINDOW-CLOSE OF FRAME gDialog
DO:  
  /* Add Trigger to equate WINDOW-CLOSE to END-ERROR. */
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Cancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Cancel gDialog
ON CHOOSE OF Btn_Cancel IN FRAME gDialog /* Cancel */
DO:
  ASSIGN pcFileName = "":U.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK gDialog
ON CHOOSE OF Btn_OK IN FRAME gDialog /* OK */
DO:
    
    /* check if file name is either blank or invalid */
    IF cFileName:SCREEN-VALUE = "":U THEN DO:
        MESSAGE "ERROR: You must specify a file name." VIEW-AS ALERT-BOX ERROR.
        APPLY "entry" TO cFileName.
        RETURN NO-APPLY.
    END.

    IF cFileName:SCREEN-VALUE = "?":U THEN DO:
        MESSAGE "ERROR: You must specify a valid file name." VIEW-AS ALERT-BOX ERROR.
        APPLY "entry" TO cFileName.
        RETURN NO-APPLY.
    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cFileName
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cFileName gDialog
ON LEAVE OF cFileName IN FRAME gDialog
DO:
    /* trim value */
  SELF:SCREEN-VALUE = TRIM(SELF:SCREEN-VALUE).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME getFilebtn
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL getFilebtn gDialog
ON CHOOSE OF getFilebtn IN FRAME gDialog /* Browse */
DO:

DEFINE VARIABLE pickedOne   AS LOGICAL                            NO-UNDO.
DEFINE VARIABLE csave-file  AS CHARACTER                          NO-UNDO.

     /* bring up system dialog */
     SYSTEM-DIALOG GET-FILE 
        csave-file 
        FILTERS            pcFilterName pcFilterSpec
        DEFAULT-EXTENSION  "":U
        TITLE              (IF pMode = "save":U THEN "Find Output File":U ELSE "Find file to import":U)
        UPDATE             pickedOne.

     /* if user selected a file name, assign it to the fill-in */
    IF pickedOne THEN DO:
         cFileName:SCREEN-VALUE = csave-file.
    END.

    APPLY "ENTRY":U TO cFileName.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK gDialog 


/* ***************************  Main Block  *************************** */

/* set the dialog title and the fill-in label depending on which mode
   we are running with
*/
IF pMode = "save":U THEN
   ASSIGN FRAME gDialog:TITLE = "Export Policy":U
          cFileName:LABEL = "Output File":U.
ELSE
   ASSIGN FRAME gDialog:TITLE = "Import Policy":U
          cFileName:LABEL = "Import File":U.

{src/adm2/dialogmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects gDialog  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI gDialog  _DEFAULT-DISABLE
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
  HIDE FRAME gDialog.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI gDialog  _DEFAULT-ENABLE
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
  DISPLAY cFileName 
      WITH FRAME gDialog.
  ENABLE cFileName getFilebtn Btn_OK Btn_Cancel 
      WITH FRAME gDialog.
  VIEW FRAME gDialog.
  {&OPEN-BROWSERS-IN-QUERY-gDialog}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

