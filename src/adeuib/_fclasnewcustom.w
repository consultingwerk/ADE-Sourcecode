&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12 GUI ADM2
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS fFrameWin 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*------------------------------------------------------------------------

  File:        fclassnewcustom.w

  Description: from cntnrfrm.w - ADM2 SmartFrame Template

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Notes:       Handles display of ADM csutom file names
               Read-only information

  Created:     05/1999             
 
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

/* Don't uncomment that - It has to be commented to avoid files opened
   to be parented to this SmartFrame */
/*CREATE WIDGET-POOL.*/

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartFrame
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER FRAME

&Scoped-define ADM-SUPPORTED-LINKS Data-Target,Data-Source,Page-Target,Update-Source,Update-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME fMain

/* Standard List Definitions                                            */
&Scoped-Define DISPLAYED-OBJECTS cCustomMeth cCustomProp cCustomSuper ~
cCustomPrto cCustomExcl cCustomDefs 

/* Custom List Definitions                                              */
/* FIELDS-FOR-FILE,List-2,List-3,List-4,List-5,List-6                   */
&Scoped-define FIELDS-FOR-FILE cCustomMeth cCustomProp 
&Scoped-define List-2 cCustomSuper cCustomPrto cCustomExcl cCustomDefs 
&Scoped-define List-3 cCustomMeth cCustomProp 

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE VARIABLE cCustomDefs AS CHARACTER FORMAT "X(256)":U 
     LABEL "Instance Definition File" 
     VIEW-AS FILL-IN 
     SIZE 34 BY 1 NO-UNDO.

DEFINE VARIABLE cCustomExcl AS CHARACTER FORMAT "X(256)":U 
     LABEL "Exclude Definition File" 
     VIEW-AS FILL-IN 
     SIZE 34 BY 1 NO-UNDO.

DEFINE VARIABLE cCustomMeth AS CHARACTER FORMAT "X(256)":U 
     LABEL "Method Library" 
     VIEW-AS FILL-IN 
     SIZE 34 BY 1 NO-UNDO.

DEFINE VARIABLE cCustomProp AS CHARACTER FORMAT "X(256)":U 
     LABEL "Property File" 
     VIEW-AS FILL-IN 
     SIZE 34 BY 1 NO-UNDO.

DEFINE VARIABLE cCustomPrto AS CHARACTER FORMAT "X(256)":U 
     LABEL "Prototype File" 
     VIEW-AS FILL-IN 
     SIZE 34 BY 1 NO-UNDO.

DEFINE VARIABLE cCustomSuper AS CHARACTER FORMAT "X(256)":U 
     LABEL "Super Procedure" 
     VIEW-AS FILL-IN 
     SIZE 34 BY 1 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fMain
     cCustomMeth AT ROW 3.33 COL 22 COLON-ALIGNED
     cCustomProp AT ROW 4.38 COL 22 COLON-ALIGNED
     cCustomSuper AT ROW 5.43 COL 22 COLON-ALIGNED
     cCustomPrto AT ROW 6.38 COL 22 COLON-ALIGNED
     cCustomExcl AT ROW 7.38 COL 22 COLON-ALIGNED
     cCustomDefs AT ROW 8.43 COL 22 COLON-ALIGNED
     "List of files to be generated to" VIEW-AS TEXT
          SIZE 39 BY .62 AT ROW 1.48 COL 20
     "allow customization of this class." VIEW-AS TEXT
          SIZE 39 BY .62 AT ROW 2.19 COL 20
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 70.4 BY 8.43.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartFrame
   Allow: Basic,Browse,DB-Fields,Query,Smart
   Container Links: Data-Target,Data-Source,Page-Target,Update-Source,Update-Target
   Other Settings: PERSISTENT-ONLY
 */

/* This procedure should always be RUN PERSISTENT.  Report the error,  */
/* then cleanup and return.                                            */
IF NOT THIS-PROCEDURE:PERSISTENT THEN DO:
  MESSAGE "{&FILE-NAME} should only be RUN PERSISTENT."
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  RETURN.
END.

&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW fFrameWin ASSIGN
         HEIGHT             = 8.43
         WIDTH              = 70.4.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB fFrameWin 
/* ************************* Included-Libraries *********************** */

{src/adm2/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW fFrameWin
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME fMain
   NOT-VISIBLE                                                          */
ASSIGN 
       FRAME fMain:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN cCustomDefs IN FRAME fMain
   NO-ENABLE 2                                                          */
/* SETTINGS FOR FILL-IN cCustomExcl IN FRAME fMain
   NO-ENABLE 2                                                          */
/* SETTINGS FOR FILL-IN cCustomMeth IN FRAME fMain
   NO-ENABLE 1 3                                                        */
/* SETTINGS FOR FILL-IN cCustomProp IN FRAME fMain
   NO-ENABLE 1 3                                                        */
/* SETTINGS FOR FILL-IN cCustomPrto IN FRAME fMain
   NO-ENABLE 2                                                          */
/* SETTINGS FOR FILL-IN cCustomSuper IN FRAME fMain
   NO-ENABLE 2                                                          */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fMain
/* Query rebuild information for FRAME fMain
     _Options          = ""
     _Query            is NOT OPENED
*/  /* FRAME fMain */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK fFrameWin 


/* ***************************  Main Block  *************************** */

&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN
   /* Now enable the interface  if in test mode - otherwise this happens when
      the object is explicitly initialized from its container. */
   RUN initializeObject.
&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects fFrameWin  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI fFrameWin  _DEFAULT-DISABLE
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
  HIDE FRAME fMain.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI fFrameWin  _DEFAULT-ENABLE
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
  DISPLAY cCustomMeth cCustomProp cCustomSuper cCustomPrto cCustomExcl 
          cCustomDefs 
      WITH FRAME fMain.
  {&OPEN-BROWSERS-IN-QUERY-fMain}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE names fFrameWin 
PROCEDURE names :
/*------------------------------------------------------------------------------
  Purpose:     Published by Names-Source (Basic Folder SmartFrame)
  Parameters:  Custom names
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pcCustomMeth   AS CHARACTER    NO-UNDO.
  DEFINE INPUT PARAMETER pcCustomProp   AS CHARACTER    NO-UNDO.
  DEFINE INPUT PARAMETER pcCustomSuper  AS CHARACTER    NO-UNDO.
  DEFINE INPUT PARAMETER pcCustomPrto   AS CHARACTER    NO-UNDO.
  DEFINE INPUT PARAMETER pcCustomExcl   AS CHARACTER    NO-UNDO.
  DEFINE INPUT PARAMETER pcCustomDefs   AS CHARACTER    NO-UNDO.          
  
  /* Assign the values to the screen */
  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN
      cCustomMeth:SCREEN-VALUE  = pcCustomMeth
      cCustomProp:SCREEN-VALUE  = pcCustomProp
      cCustomSuper:SCREEN-VALUE = pcCustomSuper
      cCustomPrto:SCREEN-VALUE  = pcCustomPrto
      cCustomExcl:SCREEN-VALUE  = pcCustomExcl
      cCustomDefs:SCREEN-VALUE  = pcCustomDefs
      .     
  END. /* DO WITH FRAME ... */
  
  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

