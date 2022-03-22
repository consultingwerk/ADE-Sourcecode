&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12 GUI ADM2
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS sObject 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
**********************************************************************

  File:

  Description: from SMART.W - Template for basic ADM2 SmartObject

  Author:
  Created:

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

/* Local Variable Definitions ---                                       */

DEFINE VARIABLE old_hit   AS DECIMAL NO-UNDO. /* initial viewer height */
DEFINE VARIABLE old_wid   AS DECIMAL NO-UNDO. /* initial viewer width */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartObject
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-1 
&Scoped-Define DISPLAYED-OBJECTS fiNode fiParent fiType fiDataType ~
fiDocumentPath fiSchemaPath 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE VARIABLE fiDataType AS CHARACTER FORMAT "X(256)":U 
     LABEL "Data Type" 
     VIEW-AS FILL-IN 
     SIZE 52 BY 1
     FGCOLOR 2  NO-UNDO.

DEFINE VARIABLE fiDocumentPath AS CHARACTER FORMAT "X(256)":U 
     LABEL "Document Path" 
     VIEW-AS FILL-IN 
     SIZE 52 BY 1
     FGCOLOR 2  NO-UNDO.

DEFINE VARIABLE fiNode AS CHARACTER FORMAT "X(256)":U 
     LABEL "Node Name" 
     VIEW-AS FILL-IN 
     SIZE 52 BY 1
     FGCOLOR 2  NO-UNDO.

DEFINE VARIABLE fiParent AS CHARACTER FORMAT "X(256)":U 
     LABEL "Parent Name" 
     VIEW-AS FILL-IN 
     SIZE 52 BY 1
     FGCOLOR 2  NO-UNDO.

DEFINE VARIABLE fiSchemaPath AS CHARACTER FORMAT "X(256)":U 
     LABEL "Schema Path" 
     VIEW-AS FILL-IN 
     SIZE 52 BY 1
     FGCOLOR 2  NO-UNDO.

DEFINE VARIABLE fiType AS CHARACTER FORMAT "X(256)":U 
     LABEL "Node Type" 
     VIEW-AS FILL-IN 
     SIZE 52 BY 1
     FGCOLOR 2  NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 71 BY 7.62.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     fiNode AT ROW 1.24 COL 17 COLON-ALIGNED
     fiParent AT ROW 2.43 COL 17 COLON-ALIGNED
     fiType AT ROW 3.62 COL 17 COLON-ALIGNED
     fiDataType AT ROW 4.81 COL 17 COLON-ALIGNED
     fiDocumentPath AT ROW 6 COL 17 COLON-ALIGNED
     fiSchemaPath AT ROW 7.19 COL 17 COLON-ALIGNED
     RECT-1 AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartObject
   Allow: Basic
   Frames: 1
   Add Fields to: Neither
   Other Settings: PERSISTENT-ONLY COMPILE
 */

/* This procedure should always be RUN PERSISTENT.  Report the error,  */
/* then cleanup and return.                                            */
IF NOT THIS-PROCEDURE:PERSISTENT THEN DO:
  MESSAGE "{&FILE-NAME} should only be RUN PERSISTENT.":U
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  RETURN.
END.

&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW sObject ASSIGN
         HEIGHT             = 15
         WIDTH              = 72.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB sObject 
/* ************************* Included-Libraries *********************** */

{src/adm2/visual.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW sObject
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   NOT-VISIBLE Size-to-Fit                                              */
ASSIGN 
       FRAME F-Main:HIDDEN           = TRUE
       FRAME F-Main:HEIGHT           = 15
       FRAME F-Main:WIDTH            = 72.

/* SETTINGS FOR FILL-IN fiDataType IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fiDocumentPath IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fiNode IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fiParent IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fiSchemaPath IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fiType IN FRAME F-Main
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME F-Main
/* Query rebuild information for FRAME F-Main
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME F-Main */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK sObject 


/* ***************************  Main Block  *************************** */

/* If testing in the UIB, initialize the SmartObject. */  
&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
  RUN initializeObject.
&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI sObject  _DEFAULT-DISABLE
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
  HIDE FRAME F-Main.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE moveObject sObject 
PROCEDURE moveObject :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pRow    AS DECIMAL    NO-UNDO.
  DEFINE INPUT  PARAMETER pColumn AS DECIMAL    NO-UNDO.
  
  DEFINE VARIABLE dRow    AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE dColumn AS DECIMAL    NO-UNDO.
  
  {get ROW dRow}.
  {get COLUMN dColumn}.
  
  dColumn = IF pColumn = ? THEN dColumn ELSE pColumn.
  
  RUN repositionObject ( dRow, dColumn ) NO-ERROR.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE nodeData sObject 
PROCEDURE nodeData :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pName   AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pParent AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pType   AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pData   AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pDPath  AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pSPath  AS CHARACTER  NO-UNDO.
  
  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN
      fiNode:SCREEN-VALUE         = pName
      fiParent:SCREEN-VALUE       = pParent
      fiType:SCREEN-VALUE         = pType
      fiDataType:SCREEN-VALUE     = pData
      fiDocumentPath:SCREEN-VALUE = pDPath
      fiSchemaPath:SCREEN-VALUE   = pSPath.
  END.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE resizeObject sObject 
PROCEDURE resizeObject :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pHeight AS DECIMAL NO-UNDO. /* container height */
  DEFINE INPUT PARAMETER pWidth  AS DECIMAL NO-UNDO. /* container width */

  /* window height growing */
  IF pHeight <> ? AND pHeight > old_hit THEN
    ASSIGN
      FRAME {&FRAME-NAME}:HEIGHT              = pHeight
      FRAME {&FRAME-NAME}:VIRTUAL-HEIGHT      = pHeight.
  ELSE
  /* window height shrinking */
  IF pHeight <> ? AND pHeight < old_hit THEN
    ASSIGN
      FRAME {&FRAME-NAME}:HEIGHT                = pHeight
      FRAME {&FRAME-NAME}:VIRTUAL-HEIGHT        = pHeight.
  
  /* window width growing */
  IF pWidth <> ? AND pWidth > old_wid THEN
    ASSIGN
      FRAME {&FRAME-NAME}:WIDTH                 = pWidth
      FRAME {&FRAME-NAME}:VIRTUAL-WIDTH         = pWidth.
  ELSE
  /* window width shrinking */
  IF pWidth <> ? AND SELF:WIDTH-PIXELS < old_wid THEN
    ASSIGN
      FRAME {&FRAME-NAME}:WIDTH                 = pWidth
      FRAME {&FRAME-NAME}:VIRTUAL-WIDTH         = pWidth.
  
  ASSIGN
    old_hit = pHeight WHEN pHeight <> ?
    old_wid = pWidth  WHEN pWidth  <> ?.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

