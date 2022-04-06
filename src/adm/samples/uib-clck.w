&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r2 GUI
/* Procedure Description
"Click-Here SmartObject

Replaces itself with an instance of another SmartObject. Only runs in the UIB at design-time and will not visualize itself at any other time."
*/
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS UIB-Window 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*------------------------------------------------------------------------

  File: uib-clck.w

  Description: A button that works in the UIB that allows you to
               add another object by "Clicking Here!"

  Input Parameters:
      <none>

  Output Parameters:
      <none>

------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Click-Here

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS ClickHere 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE BUTTON ClickHere 
     LABEL "Click Here!" 
     SIZE 14.78 BY 1.38.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     ClickHere AT ROW 1.34 COL 3.56
     "Click to Add" VIEW-AS TEXT
          SIZE 16 BY .63 AT ROW 2.72 COL 4.22
     "SmartViewer" VIEW-AS TEXT
          SIZE 14.45 BY .63 AT ROW 3.38 COL 4.56
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.

 

/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Click-Here
   Allow: Basic
   Frames: 1
   Add Fields to: Neither
   Other Settings: PERSISTENT-ONLY COMPILE
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
  CREATE WINDOW UIB-Window ASSIGN
         HEIGHT             = 3.16
         WIDTH              = 21.56.
                                                                        */
&ANALYZE-RESUME


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW UIB-Window
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   NOT-VISIBLE Size-to-Fit                                              */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME F-Main
/* Query rebuild information for FRAME F-Main
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME F-Main */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB UIB-Window 
/* ************************* Included-Libraries *********************** */

{src/adm/method/smart.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME ClickHere
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ClickHere UIB-Window
ON CHOOSE OF ClickHere IN FRAME F-Main /* Click Here! */
DO:
  DEF VAR ch          AS CHAR NO-UNDO.
  DEF VAR c_info      AS CHAR NO-UNDO.
  DEF VAR c_name      AS CHAR NO-UNDO.  
  DEF VAR fileChosen  AS CHAR NO-UNDO.
  DEF VAR i_Me        AS INTEGER NO-UNDO.
  DEF VAR i_ParentID  AS INTEGER NO-UNDO.
  DEF VAR i_New       AS INTEGER NO-UNDO.
  DEF VAR l_cancelled AS LOGICAL NO-UNDO.
  
  /* Get the name of the of a SmartObject. */
  RUN adecomm/_chosobj.w 
        (INPUT "",               /* p_mode - i.e. NOT VBX */
         INPUT "DIRECTORY-LIST ." + CHR(10) +
               "FILTERS v-*.*" + CHR(10) +
               "TITLE Choose SmartViewer",
         INPUT "",               /* No NEW template */
         INPUT "BROWSE,PREVIEW", /* Options */
         OUTPUT fileChosen,      /* SmartObject */
         OUTPUT ch,              /* Ignored */
         OUTPUT l_Cancelled).    /* Did user cancel? */
  
  /* Did the user cancel? */
  IF l_Cancelled THEN RETURN.
   
  /* Get the name and id of the parent frame/window this object is in. */
  IF FRAME {&FRAME-NAME}:FRAME ne ?
  THEN c_name = "HANDLE " + STRING(FRAME {&FRAME-NAME}:FRAME).
  ELSE c_name = "HANDLE " + STRING(FRAME {&FRAME-NAME}:PARENT).

  RUN adeuib/_uibinfo.p (INPUT ?,
                         INPUT c_name,
                         INPUT "CONTEXT",
                         OUTPUT c_info).
  i_ParentID = INTEGER(c_info).
  
  /* Create a SmartObject at the location of the object. */
  RUN adeuib/_uib_crt.p (INPUT i_ParentID,
                         INPUT "SmartObject",
                         INPUT "SmartObject: " + fileChosen,
                         INPUT FRAME {&FRAME-NAME}:ROW,
                         INPUT FRAME {&FRAME-NAME}:COLUMN,
                         INPUT FRAME {&FRAME-NAME}:HEIGHT,
                         INPUT FRAME {&FRAME-NAME}:WIDTH,
                         OUTPUT i_New). 
                         
  IF RETURN-VALUE ne "" THEN DO:
     MESSAGE "Object could not be created."  SKIP
             "Call to adeuib/_uib_crt.p returned" RETURN-VALUE
             VIEW-AS ALERT-BOX ERROR.
  END.
  ELSE DO:                 
    /* Get the handle of this procedure, and delete it. */
    c_name = "HANDLE " + STRING(THIS-PROCEDURE).
    RUN adeuib/_uibinfo.p (INPUT ?,
                           INPUT c_name,
                           INPUT "CONTEXT",
                           OUTPUT c_info).
    i_Me = INTEGER(c_info).   
    
    RUN adeuib/_uib_del.p (INPUT i_Me).
    
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK UIB-Window 



/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI UIB-Window _DEFAULT-DISABLE
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize UIB-Window 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method.
               This object should ONLY run in the UIB.
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  RUN get-attribute ('UIB-mode').
  IF RETURN-VALUE eq ? THEN RETURN.
  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'adm-initialize' ) .
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-UIB-mode UIB-Window 
PROCEDURE local-UIB-mode :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
               The Click Here! button is not enabled unless the click-here
               instance appears in a template.
   Notes:       
------------------------------------------------------------------------------*/
  DEF VAR c_info AS CHAR NO-UNDO.
  
  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'UIB-mode':U ) .
  
  /* Code placed here will execute AFTER standard behavior.    */
  
  /* Find out if this instance is in a TEMPLATE. Enable the button if it
     is not a template.  */
  RUN adeuib/_uibinfo.p (INPUT ?,
                         INPUT "HANDLE " + STRING(THIS-PROCEDURE),
                         INPUT "TEMPLATE",
                         OUTPUT c_info).
  IF c_info ne "yes" THEN DO:
    ClickHere:SENSITIVE IN FRAME {&FRAME-NAME} = YES.
  END.
  
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed UIB-Window 
PROCEDURE state-changed :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p-issuer-hdl AS HANDLE    NO-UNDO.
  DEFINE INPUT PARAMETER p-state      AS CHARACTER NO-UNDO.

  CASE p-state:
      /* Object instance CASEs can go here to replace standard behavior
         or add new cases. */
  
  END CASE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


