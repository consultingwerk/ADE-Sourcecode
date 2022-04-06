&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12 GUI ADM2
&ANALYZE-RESUME
/* Connected Databases 
          icfdb            PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW

/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE RowObject
       {"ry/obj/ryclafullo.i"}.


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS vTableWin 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
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

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDataViewer
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER FRAME

&Scoped-define ADM-SUPPORTED-LINKS Data-Target,Update-Source,TableIO-Target,GroupAssign-Source,GroupAssign-Target

/* Include file with RowObject temp-table definition */
&Scoped-define DATA-FIELD-DEFS "ry/obj/ryclafullo.i"

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS RowObject.layout_name RowObject.layout_type ~
RowObject.layout_code RowObject.layout_narrative RowObject.layout_filename ~
RowObject.sample_image_filename RowObject.system_owned 
&Scoped-define ENABLED-TABLES RowObject
&Scoped-define FIRST-ENABLED-TABLE RowObject
&Scoped-Define ENABLED-OBJECTS fiNarrative fiLayout fiImage 
&Scoped-Define DISPLAYED-FIELDS RowObject.layout_name RowObject.layout_type ~
RowObject.layout_code RowObject.layout_narrative RowObject.layout_filename ~
RowObject.sample_image_filename RowObject.system_owned 
&Scoped-define DISPLAYED-TABLES RowObject
&Scoped-define FIRST-DISPLAYED-TABLE RowObject
&Scoped-Define DISPLAYED-OBJECTS fiNarrative fiLayout fiImage 

/* Custom List Definitions                                              */
/* ADM-ASSIGN-FIELDS,List-2,List-3,List-4,List-5,List-6                 */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE VARIABLE fiImage AS CHARACTER FORMAT "X(256)":U INITIAL "Sample image filename:" 
      VIEW-AS TEXT 
     SIZE 23 BY 1 NO-UNDO.

DEFINE VARIABLE fiLayout AS CHARACTER FORMAT "X(256)":U INITIAL "Layout filename:" 
      VIEW-AS TEXT 
     SIZE 16.4 BY 1 NO-UNDO.

DEFINE VARIABLE fiNarrative AS CHARACTER FORMAT "X(256)":U INITIAL "Layout narrative:" 
      VIEW-AS TEXT 
     SIZE 16 BY 1 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     RowObject.layout_name AT ROW 1 COL 27 COLON-ALIGNED
          LABEL "Layout name"
          VIEW-AS FILL-IN 
          SIZE 63.2 BY 1
     RowObject.layout_type AT ROW 2.05 COL 27 COLON-ALIGNED
          LABEL "Layout type"
          VIEW-AS FILL-IN 
          SIZE 8.6 BY 1
     RowObject.layout_code AT ROW 3.1 COL 27 COLON-ALIGNED
          LABEL "Layout code"
          VIEW-AS FILL-IN 
          SIZE 24 BY 1
     RowObject.layout_narrative AT ROW 4.14 COL 29 NO-LABEL
          VIEW-AS EDITOR MAX-CHARS 500 SCROLLBAR-VERTICAL
          SIZE 63.2 BY 8
     RowObject.layout_filename AT ROW 12.19 COL 29 NO-LABEL
          VIEW-AS EDITOR MAX-CHARS 70 SCROLLBAR-VERTICAL
          SIZE 63.2 BY 2
     RowObject.sample_image_filename AT ROW 14.24 COL 29 NO-LABEL
          VIEW-AS EDITOR MAX-CHARS 70 SCROLLBAR-VERTICAL
          SIZE 63.2 BY 2
     RowObject.system_owned AT ROW 16.33 COL 29
          LABEL "System owned"
          VIEW-AS TOGGLE-BOX
          SIZE 19.2 BY 1
     fiNarrative AT ROW 4.14 COL 12.6 NO-LABEL
     fiLayout AT ROW 12.29 COL 12.6 NO-LABEL
     fiImage AT ROW 14.33 COL 5.8 NO-LABEL
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY USE-DICT-EXPS 
         SIDE-LABELS NO-UNDERLINE THREE-D NO-AUTO-VALIDATE 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDataViewer
   Data Source: "ry/obj/ryclafullo.w"
   Allow: Basic,DB-Fields,Smart
   Container Links: Data-Target,Update-Source,TableIO-Target,GroupAssign-Source,GroupAssign-Target
   Frames: 1
   Add Fields to: Neither
   Other Settings: PERSISTENT-ONLY COMPILE
   Temp-Tables and Buffers:
      TABLE: RowObject D "?" ?  
      ADDITIONAL-FIELDS:
          {ry/obj/ryclafullo.i}
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
         HEIGHT             = 17.1
         WIDTH              = 93.8.
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
   NOT-VISIBLE Size-to-Fit                                              */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN fiImage IN FRAME F-Main
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN fiLayout IN FRAME F-Main
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN fiNarrative IN FRAME F-Main
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN RowObject.layout_code IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR EDITOR RowObject.layout_filename IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN RowObject.layout_name IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR EDITOR RowObject.layout_narrative IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN RowObject.layout_type IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR EDITOR RowObject.sample_image_filename IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR TOGGLE-BOX RowObject.system_owned IN FRAME F-Main
   EXP-LABEL                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME F-Main
/* Query rebuild information for FRAME F-Main
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME F-Main */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK vTableWin 


/* ***************************  Main Block  *************************** */

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN initializeObject.
  &ENDIF         

  /************************ INTERNAL PROCEDURES ********************/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

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

