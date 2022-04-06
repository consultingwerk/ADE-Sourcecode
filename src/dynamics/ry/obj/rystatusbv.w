&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12 GUI ADM2
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS sObject 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*------------------------------------------------------------------------

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

{af/sup2/afglobals.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartObject
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main

/* Standard List Definitions                                            */
&Scoped-Define DISPLAYED-OBJECTS fiUserName fiOrganisationName ~
fiProcessDate 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE VARIABLE fiOrganisationName AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 14 BY .91 NO-UNDO.

DEFINE VARIABLE fiProcessDate AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 14 BY .91 NO-UNDO.

DEFINE VARIABLE fiUserName AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 14 BY .91 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     fiUserName AT ROW 1 COL 1 NO-LABEL
     fiOrganisationName AT ROW 1 COL 15 NO-LABEL
     fiProcessDate AT ROW 1 COL 27 COLON-ALIGNED NO-LABEL
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartObject
   Compile into: dynamics/ry/obj
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
         HEIGHT             = 6.52
         WIDTH              = 50.
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
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN fiOrganisationName IN FRAME F-Main
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN fiProcessDate IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fiUserName IN FRAME F-Main
   NO-ENABLE ALIGN-L                                                    */
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject sObject 
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    /* status bar does not require security - so set object secured to true
       to avoid appserver hits to check for security on it
    */
    {set ObjectSecured TRUE} NO-ERROR.

    RUN SUPER.

    DEFINE VARIABLE cPropertyValues AS CHARACTER.

    SUBSCRIBE TO 'ClientCachedDataChanged' IN gshSessionManager RUN-PROCEDURE 'initializeObject'.

    cPropertyValues = DYNAMIC-FUNCTION('getPropertyList' IN gshSessionManager, "currentUserName,currentOrganisationName,currentProcessDate", TRUE).
    fiUserName            = ENTRY(1,cPropertyValues,CHR(3)).
    fiOrganisationName    = ENTRY(2,cPropertyValues,CHR(3)).
    fiProcessDate         = ENTRY(3,cPropertyValues,CHR(3)).

    DISPLAY fiUserName fiOrganisationName fiProcessDate WITH FRAME {&FRAME-NAME}.

    RUN resizeObject(FRAME {&FRAME-NAME}:HEIGHT, FRAME {&FRAME-NAME}:WIDTH).

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
DEFINE INPUT PARAMETER pdNewHeight AS DECIMAL NO-UNDO.
DEFINE INPUT PARAMETER pdNewWidth AS DECIMAL NO-UNDO.

    /* resize the frame if bigger */

    FRAME {&FRAME-NAME}:WIDTH = MAX(FRAME {&FRAME-NAME}:WIDTH, pdNewWidth).
    FRAME {&FRAME-NAME}:HEIGHT = MAX(FRAME {&FRAME-NAME}:HEIGHT, pdNewHeight).

    DEFINE VARIABLE hFrame AS HANDLE NO-UNDO.                       
    DEFINE VARIABLE hFieldGroup AS HANDLE NO-UNDO.
    DEFINE VARIABLE hWidget AS HANDLE NO-UNDO.

    DEFINE VARIABLE dTextWidth AS DECIMAL NO-UNDO.
    DEFINE VARIABLE dTotalTextWidth AS DECIMAL NO-UNDO.
    DEFINE VARIABLE dSpaceToShare AS DECIMAL NO-UNDO.
    DEFINE VARIABLE iFillInCnt AS INTEGER NO-UNDO.
    DEFINE VARIABLE dNextColumn AS DECIMAL NO-UNDO.
    DEFINE VARIABLE hLastWidget AS HANDLE NO-UNDO.

    hFrame = FRAME {&FRAME-NAME}:HANDLE.
    hFieldGroup = hFrame:FIRST-CHILD.
    hWidget = hFieldGroup:FIRST-CHILD.


    REPEAT WHILE VALID-HANDLE(hWidget):
        IF hWidget:TYPE = "FILL-IN" THEN
        DO:       
            dTextWidth = MAX(10,FONT-TABLE:GET-TEXT-WIDTH(hWidget:SCREEN-VALUE, hWidget:FONT)).
            dTotalTextWidth = dTotalTextWidth + dTextWidth.
            iFillInCnt = iFillInCnt + 1.
        END.
        hWidget = hWidget:NEXT-SIBLING.
    END.


    dSpaceToShare = pdNewWidth - (2 * iFillInCnt) - 1.

    hWidget = hFieldGroup:FIRST-CHILD.

    DEFINE VARIABLE dMagic AS INT.               
    dMagic = 1.                                        
    dNextColumn = 1.                                                   
    REPEAT WHILE VALID-HANDLE(hWidget):       
        IF hWidget:TYPE = "FILL-IN" THEN
        DO:       
            hLastWidget = hWidget.
            hWidget:COLUMN = 1.
            dTextWidth = MAX(10,FONT-TABLE:GET-TEXT-WIDTH(hWidget:SCREEN-VALUE, hWidget:FONT)).
            hWidget:WIDTH = dSpaceToShare * (dTextWidth / dTotalTextWidth) + 2.
            hWIdget:COLUMN = dNextColumn.


            dNextColumn = dNextColumn + hWidget:WIDTH.

        END.
        hWidget = hWidget:NEXT-SIBLING.
    END.

    FRAME {&FRAME-NAME}:WIDTH = pdNewWidth.
    FRAME {&FRAME-NAME}:HEIGHT = pdNewHeight.

    /* correct for any rounding errors by making the last widget reach to the end of the frame */
    hLastWidget:WIDTH = pdNewWidth - hLastWidget:COLUMN + 1.




END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

