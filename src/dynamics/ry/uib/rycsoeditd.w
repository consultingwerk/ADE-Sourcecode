&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME Dialog-Frame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Dialog-Frame 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*------------------------------------------------------------------------

  File: 

  Description: 

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: 

  Created: 
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBulder.       */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

DEFINE INPUT-OUTPUT PARAMETER pdLayoutObj               AS DECIMAL   NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER pdObjectTypeObj           AS DECIMAL   NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER pdProductModuleObj        AS DECIMAL   NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER pcObjectFilename          AS CHARACTER NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER pcCustomSuperProcedure    AS CHARACTER NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER plStaticObject            AS LOGICAL   NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER plSystemOwned             AS LOGICAL   NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER plTemplateSmartObject     AS LOGICAL   NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER plLogicalObject           AS LOGICAL   NO-UNDO. /* This parameter is only kept for backwards compatibility, rather use plStaticObject */
DEFINE INPUT-OUTPUT PARAMETER pcPhysicalObjectName      AS CHARACTER NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER pcObjectPath              AS CHARACTER NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER pcObjectDescription       AS CHARACTER NO-UNDO.
DEFINE OUTPUT       PARAMETER plProceed                 AS LOGICAL   NO-UNDO INITIAL FALSE.


/* Local Variable Definitions ---                                       */

{af/sup2/afglobals.i}

DEFINE VARIABLE lValid      AS LOGICAL      NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Dialog-Box
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME Dialog-Frame

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS cbLayout cbObjectType cbProductModule ~
fiObjectFileName fiObjectDescription fiObjectPath fiCustomSuperProcedure ~
toStaticObject toSystemOwned toTemplateSmartObject fiPhysicalObjectName ~
Btn_OK Btn_Cancel 
&Scoped-Define DISPLAYED-OBJECTS cbLayout cbObjectType cbProductModule ~
fiObjectFileName fiObjectDescription fiObjectPath fiCustomSuperProcedure ~
toStaticObject toSystemOwned toTemplateSmartObject fiPhysicalObjectName 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     LABEL "Cancel" 
     SIZE 15 BY 1.14
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK AUTO-GO 
     LABEL "OK" 
     SIZE 15 BY 1.14
     BGCOLOR 8 .

DEFINE VARIABLE cbLayout AS DECIMAL FORMAT "->>>>>>>>>>>>>>>>>9.999999999":U INITIAL 0 
     LABEL "Layout" 
     VIEW-AS COMBO-BOX SORT INNER-LINES 5
     LIST-ITEM-PAIRS "",0
     DROP-DOWN-LIST
     SIZE 53 BY 1 NO-UNDO.

DEFINE VARIABLE cbObjectType AS DECIMAL FORMAT "->>>>>>>>>>>>>>>>>9.999999999":U INITIAL 0 
     LABEL "Object Type" 
     VIEW-AS COMBO-BOX SORT INNER-LINES 5
     LIST-ITEM-PAIRS "",0
     DROP-DOWN-LIST
     SIZE 53 BY 1 NO-UNDO.

DEFINE VARIABLE cbProductModule AS DECIMAL FORMAT "->>>>>>>>>>>>>>>>>9.999999999":U INITIAL 0 
     LABEL "Product Module" 
     VIEW-AS COMBO-BOX SORT INNER-LINES 5
     LIST-ITEM-PAIRS "",0
     DROP-DOWN-LIST
     SIZE 53 BY 1.05 NO-UNDO.

DEFINE VARIABLE fiCustomSuperProcedure AS CHARACTER FORMAT "X(256)":U 
     LABEL "Custom Super Procedure" 
     VIEW-AS FILL-IN 
     SIZE 49 BY 1 NO-UNDO.

DEFINE VARIABLE fiObjectDescription AS CHARACTER FORMAT "X(256)":U 
     LABEL "Object Description" 
     VIEW-AS FILL-IN 
     SIZE 49 BY 1 NO-UNDO.

DEFINE VARIABLE fiObjectFileName AS CHARACTER FORMAT "X(256)":U 
     LABEL "Object Filename" 
     VIEW-AS FILL-IN 
     SIZE 49 BY 1 NO-UNDO.

DEFINE VARIABLE fiObjectPath AS CHARACTER FORMAT "X(256)":U 
     LABEL "Object Path" 
     VIEW-AS FILL-IN 
     SIZE 49 BY 1 NO-UNDO.

DEFINE VARIABLE fiPhysicalObjectName AS CHARACTER FORMAT "X(256)":U 
     LABEL "Physical Object Filename" 
     VIEW-AS FILL-IN 
     SIZE 24 BY 1 NO-UNDO.

DEFINE VARIABLE toStaticObject AS LOGICAL INITIAL no 
     LABEL "Static Object" 
     VIEW-AS TOGGLE-BOX
     SIZE 21 BY .81 NO-UNDO.

DEFINE VARIABLE toSystemOwned AS LOGICAL INITIAL no 
     LABEL "System Owned" 
     VIEW-AS TOGGLE-BOX
     SIZE 21 BY .81 NO-UNDO.

DEFINE VARIABLE toTemplateSmartObject AS LOGICAL INITIAL no 
     LABEL "Template SmartObject" 
     VIEW-AS TOGGLE-BOX
     SIZE 27 BY .81 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME Dialog-Frame
     cbLayout AT ROW 1.14 COL 25 COLON-ALIGNED
     cbObjectType AT ROW 2.19 COL 25 COLON-ALIGNED
     cbProductModule AT ROW 3.24 COL 25 COLON-ALIGNED
     fiObjectFileName AT ROW 4.29 COL 25 COLON-ALIGNED
     fiObjectDescription AT ROW 5.29 COL 25 COLON-ALIGNED
     fiObjectPath AT ROW 6.29 COL 25 COLON-ALIGNED
     fiCustomSuperProcedure AT ROW 7.29 COL 25 COLON-ALIGNED
     toStaticObject AT ROW 8.33 COL 27
     toSystemOwned AT ROW 9.29 COL 27
     toTemplateSmartObject AT ROW 10.24 COL 27
     fiPhysicalObjectName AT ROW 12 COL 25 COLON-ALIGNED
     Btn_OK AT ROW 13.38 COL 49
     Btn_Cancel AT ROW 13.38 COL 65
     SPACE(1.59) SKIP(0.00)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         TITLE "SmartObject"
         DEFAULT-BUTTON Btn_OK CANCEL-BUTTON Btn_Cancel.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Dialog-Box
   Allow: Basic,Browse,DB-Fields,Query
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX Dialog-Frame
                                                                        */
ASSIGN 
       FRAME Dialog-Frame:SCROLLABLE       = FALSE
       FRAME Dialog-Frame:HIDDEN           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME Dialog-Frame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Dialog-Frame Dialog-Frame
ON WINDOW-CLOSE OF FRAME Dialog-Frame /* SmartObject */
DO:
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK Dialog-Frame
ON CHOOSE OF Btn_OK IN FRAME Dialog-Frame /* OK */
DO:
    ASSIGN FRAME {&FRAME-NAME} 
        cbLayout 
        cbProductModule 
        cbObjectType 
        fiObjectFilename 
        fiCustomSuperProcedure 
        toStaticObject 
        toTemplateSmartObject 
        toSystemOwned        
        fiObjectPath
        fiPhysicalObjectName
        fiObjectDescription.

    ASSIGN
        lValid = NO.

    RUN validateRecord.
    IF NOT lValid THEN
        RETURN NO-APPLY.

    ASSIGN
         pdLayoutObj            = cbLayout
         pdProductModuleObj     = cbProductModule
         pdObjectTypeObj        = cbObjectType
         pcObjectFilename       = fiObjectFilename
         pcCustomSuperProcedure = fiCustomSuperProcedure
         plStaticObject         = toStaticObject
         plTemplateSmartObject  = toTemplateSMartObject
         plSystemOwned          = toSystemOwned
         plLogicalObject        = NOT toStaticObject
         pcObjectPath           = fiObjectPath
         pcPhysicalObjectName   = fiPhysicalObjectName
         pcObjectDescription    = fiObjectDescription
         plProceed              = TRUE.
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

   RUN initialize.
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
  DISPLAY cbLayout cbObjectType cbProductModule fiObjectFileName 
          fiObjectDescription fiObjectPath fiCustomSuperProcedure toStaticObject 
          toSystemOwned toTemplateSmartObject fiPhysicalObjectName 
      WITH FRAME Dialog-Frame.
  ENABLE cbLayout cbObjectType cbProductModule fiObjectFileName 
         fiObjectDescription fiObjectPath fiCustomSuperProcedure toStaticObject 
         toSystemOwned toTemplateSmartObject fiPhysicalObjectName Btn_OK 
         Btn_Cancel 
      WITH FRAME Dialog-Frame.
  VIEW FRAME Dialog-Frame.
  {&OPEN-BROWSERS-IN-QUERY-Dialog-Frame}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initialize Dialog-Frame 
PROCEDURE initialize :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DO WITH FRAME {&FRAME-NAME}: END.
    ASSIGN
        cbLayout:LIST-ITEM-PAIRS        = ",0":u
        cbObjectType:LIST-ITEM-PAIRS    = ",0":u
        cbProductModule:LIST-ITEM-PAIRS = ",0":u.

    FOR EACH ryc_layout NO-LOCK:
        cbLayout:ADD-FIRST(ryc_layout.layout_name, ryc_layout.layout_obj).
    END.

    FOR EACH gsc_object_type NO-LOCK:
        cbObjectType:ADD-FIRST(gsc_object_type.object_type_description, gsc_object_type.object_type_obj).
    END.

    FOR EACH gsc_product_module NO-LOCK:        
        cbProductModule:ADD-FIRST(gsc_product_module.product_module_code, gsc_product_module.product_module_obj).
    END.

    ASSIGN
        cbLayout = pdLayoutObj
        cbProductModule = pdProductModuleObj
        cbObjectType = pdObjectTypeObj
        fiObjectFilename = pcObjectFilename
        fiCustomSuperProcedure = pcCustomSuperProcedure
        toStaticObject = plStaticObject
        toTemplateSMartObject = plTemplateSmartObject
        toSystemOwned = plSystemOwned
        fiPhysicalObjectName = pcPhysicalObjectName
        fiObjectPath = pcObjectPath
        fiObjectDescription = pcObjectDescription.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE showMessage Dialog-Frame 
PROCEDURE showMessage :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER ipMessage   AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cButton AS CHARACTER NO-UNDO.

    RUN showMessages IN gshSessionManager (INPUT  ipMessage,        /* messages */
                                           INPUT  "ERR":U,          /* type */
                                           INPUT  "OK":U,           /* button list */
                                           INPUT  "OK":U,           /* default */
                                           INPUT  "OK":U,           /* cancel */
                                           INPUT  "":U,             /* title */
                                           INPUT  YES,              /* disp. empty */
                                           INPUT  ?,                /* container handle */
                                           OUTPUT cButton           /* button pressed */
                                          ).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateRecord Dialog-Frame 
PROCEDURE validateRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE cErrorMessage AS CHARACTER  NO-UNDO.

    IF (NOT toStaticObject) THEN DO:
        IF NUM-ENTRIES(fiObjectFilename, ".") > 1 THEN DO:
            cErrorMessage = {af/sup2/aferrortxt.i 'RY' '7'}.
            RUN showMessage (INPUT cErrorMessage).
            APPLY "entry":u TO fiObjectFileName IN FRAME {&FRAME-NAME}.
            RETURN.
        END.

        IF fiPhysicalObjectName = "":u OR fiPhysicalObjectName = ? THEN DO:
            cErrorMessage = {af/sup2/aferrortxt.i 'RY' '8'}.
            RUN showMessage (INPUT cErrorMessage).
            APPLY "entry":u TO fiPhysicalObjectName IN FRAME {&FRAME-NAME}.
            RETURN.
        END.
    END.
    ELSE DO:
        IF fiObjectPath = "":u OR fiObjectPath = ? THEN DO:
            cErrorMessage = {af/sup2/aferrortxt.i '' "'Please specify a path.'"}.
            RUN showMessage (INPUT cErrorMessage).
            APPLY "entry":u TO fiObjectPath IN FRAME {&FRAME-NAME}.
            RETURN.
        END.
    END.

    ASSIGN
        lValid = YES.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

