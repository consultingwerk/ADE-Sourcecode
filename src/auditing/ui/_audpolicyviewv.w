&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI ADM2
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW

/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE RowObject NO-UNDO
       {"auditing/sdo/_audpolicysdo.i"}.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS vTableWin 
/*************************************************************/  
/* Copyright (c) 1984-2005 by Progress Software Corporation  */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from PROGRESS Software Corporation. */
/*************************************************************/
/*------------------------------------------------------------------------

  File:

  Description: from viewer.w - Template for SmartDataViewer objects

  Input Parameters:
      <none>

  Output Parameters:
      <none>

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

{src/adm2/widgetprto.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDataViewer
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER FRAME

&Scoped-define ADM-SUPPORTED-LINKS Data-Target,Update-Source,TableIO-Target,GroupAssign-Source,GroupAssign-Target

/* Include file with RowObject temp-table definition */
&Scoped-define DATA-FIELD-DEFS "auditing/sdo/_audpolicysdo.i"

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS RowObject._Audit-policy-name ~
RowObject._Audit-policy-description RowObject._Audit-data-security-level ~
RowObject._Audit-custom-detail-level RowObject._Audit-policy-active 
&Scoped-define ENABLED-TABLES RowObject
&Scoped-define FIRST-ENABLED-TABLE RowObject
&Scoped-Define DISPLAYED-FIELDS RowObject._Audit-policy-name ~
RowObject._Audit-policy-description RowObject._Audit-data-security-level ~
RowObject._Audit-custom-detail-level RowObject._Audit-policy-active 
&Scoped-define DISPLAYED-TABLES RowObject
&Scoped-define FIRST-DISPLAYED-TABLE RowObject


/* Custom List Definitions                                              */
/* ADM-ASSIGN-FIELDS,List-2,List-3,List-4,List-5,List-6                 */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     RowObject._Audit-policy-name AT ROW 1.24 COL 24 COLON-ALIGNED WIDGET-ID 2
          VIEW-AS FILL-IN 
          SIZE 37 BY 1 TOOLTIP "The unique name of the audit policy"
     RowObject._Audit-policy-description AT ROW 2.81 COL 3.2 WIDGET-ID 4
          VIEW-AS FILL-IN 
          SIZE 72 BY 1 TOOLTIP "A description of what the policy audits"
     RowObject._Audit-data-security-level AT ROW 4.38 COL 7.4 WIDGET-ID 6
          VIEW-AS COMBO-BOX INNER-LINES 5
          LIST-ITEM-PAIRS "No Additional Security",0,
                     "Message Digest",1,
                     "DB Passkey",2
          DROP-DOWN-LIST
          SIZE 37 BY 1 TOOLTIP "Set the level of security applied to the audit data tables (data seal)"
     RowObject._Audit-custom-detail-level AT ROW 6 COL 2 WIDGET-ID 8
          VIEW-AS COMBO-BOX INNER-LINES 5
          LIST-ITEM-PAIRS "Off",0,
                     "On",1
          DROP-DOWN-LIST
          SIZE 37 BY 1 TOOLTIP "Defines whether to store additional, custom information about the audit data"
     RowObject._Audit-policy-active AT ROW 7.43 COL 26 WIDGET-ID 10
          LABEL "Policy active"
          VIEW-AS TOGGLE-BOX
          SIZE 16 BY .81 TOOLTIP "Defines if this policy is active"
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY USE-DICT-EXPS 
         SIDE-LABELS NO-UNDERLINE THREE-D NO-AUTO-VALIDATE 
         AT COL 1 ROW 1 SCROLLABLE  WIDGET-ID 10.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDataViewer
   Data Source: "auditing/sdo/_audpolicysdo.w"
   Allow: Basic,DB-Fields,Smart
   Container Links: Data-Target,Update-Source,TableIO-Target,GroupAssign-Source,GroupAssign-Target
   Frames: 1
   Add Fields to: Neither
   Other Settings: PERSISTENT-ONLY COMPILE
   Temp-Tables and Buffers:
      TABLE: RowObject D "?" NO-UNDO  
      ADDITIONAL-FIELDS:
          {auditing/sdo/_audpolicysdo.i}
      END-FIELDS.
   END-TABLES.
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
  CREATE WINDOW vTableWin ASSIGN
         HEIGHT             = 7.81
         WIDTH              = 100.2.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB vTableWin 
/* ************************* Included-Libraries *********************** */

{src/adm2/viewer.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW vTableWin
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   NOT-VISIBLE FRAME-NAME Size-to-Fit                                   */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* SETTINGS FOR COMBO-BOX RowObject._Audit-custom-detail-level IN FRAME F-Main
   ALIGN-L                                                              */
/* SETTINGS FOR COMBO-BOX RowObject._Audit-data-security-level IN FRAME F-Main
   ALIGN-L                                                              */
/* SETTINGS FOR TOGGLE-BOX RowObject._Audit-policy-active IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN RowObject._Audit-policy-description IN FRAME F-Main
   ALIGN-L                                                              */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME F-Main
/* Query rebuild information for FRAME F-Main
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME F-Main */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME RowObject._Audit-policy-name
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL RowObject._Audit-policy-name vTableWin
ON LEAVE OF RowObject._Audit-policy-name IN FRAME F-Main /* Audit policy name */
DO:
  SELF:SCREEN-VALUE = TRIM(SELF:SCREEN-VALUE).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK vTableWin 


/* ***************************  Main Block  *************************** */

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN initializeObject.
  &ENDIF         
  
  /************************ INTERNAL PROCEDURES ********************/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE addRecord vTableWin 
PROCEDURE addRecord :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */

  /* make it active by default */
  ASSIGN RowObject._Audit-policy-active:CHECKED IN FRAME {&FRAME-NAME} = YES
         RowObject._Audit-policy-active:MODIFIED = YES.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE confirmDelete vTableWin 
PROCEDURE confirmDelete :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       Override so we display our own message
------------------------------------------------------------------------------*/

  DEFINE INPUT-OUTPUT PARAMETER plAnswer AS LOGICAL NO-UNDO.

  DEFINE VARIABLE cMessage AS CHARACTER NO-UNDO.
  DEFINE VARIABLE hSDO     AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cValue   AS CHARACTER NO-UNDO.
  DEFINE VARIABLE lActive  AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE lMult    AS LOGICAL   NO-UNDO INIT NO.
  DEFINE VARIABLE hCSource AS HANDLE    NO-UNDO.

  /* check if multiple records are selected before deleting */
  ASSIGN hCSource = DYNAMIC-FUNCTION('getContainerSource':U IN TARGET-PROCEDURE).

  lMult = DYNAMIC-FUNCTION ('hasMultipleSelected':U IN hCSource) NO-ERROR.
  IF lMult THEN DO:
      MESSAGE "Select only one record to be deleted" VIEW-AS ALERT-BOX ERROR.
      plAnswer = NO.
      RETURN.
  END.

  /* OVERRIDE STANDARD BEHAVIOR - DISPLAY OUR OWN MESSAGE */

  /* Code placed here will execute PRIOR to standard behavior. */
  /*  RUN SUPER( INPUT-OUTPUT plAnswer).*/
  /* Code placed here will execute AFTER standard behavior.    */

  ASSIGN hSDO = DYNAMIC-FUNCTION('getDataSource')
         cValue = DYNAMIC-FUNCTION("columnStringValue":U IN hSDO,
                                         INPUT "_Audit-policy-name").
   ASSIGN cMessage = "Do you want to delete policy " + QUOTER(TRIM(cValue)) + " ?" 
          cMessage = cMessage + "~n(Note that all the settings under this policy will also be deleted)."
          lActive = LOGICAL(DYNAMIC-FUNCTION("columnStringValue":U IN hSDO,
                                             INPUT "_Audit-policy-active"))
         cMessage = cMessage + (IF lActive THEN "~n(Policy is currently active!)" ELSE "").

   MESSAGE cMessage VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO 
           UPDATE plAnswer.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI vTableWin  _DEFAULT-DISABLE
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

