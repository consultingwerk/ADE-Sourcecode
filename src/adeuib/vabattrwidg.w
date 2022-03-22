&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12 GUI ADM2
&ANALYZE-RESUME
/* Connected Databases 
          ab               PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW

/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE RowObject
       {"adeuib/dabattribute.i"}.


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
&Scoped-define DATA-FIELD-DEFS "adeuib/dabattribute.i"

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS RowObject.proc RowObject.wind RowObject.dial ~
RowObject.frm RowObject.brow RowObject.butt RowObject.comb RowObject.edit ~
RowObject.fil RowObject.imag RowObject.ocx RowObject.radi RowObject.rec ~
RowObject.sele RowObject.slid RowObject.togg RowObject.txt 
&Scoped-define ENABLED-TABLES RowObject
&Scoped-define FIRST-ENABLED-TABLE RowObject
&Scoped-define DISPLAYED-TABLES RowObject
&Scoped-define FIRST-DISPLAYED-TABLE RowObject
&Scoped-Define ENABLED-OBJECTS RECT-1 
&Scoped-Define DISPLAYED-FIELDS RowObject.proc RowObject.wind ~
RowObject.dial RowObject.frm RowObject.brow RowObject.butt RowObject.comb ~
RowObject.edit RowObject.fil RowObject.imag RowObject.ocx RowObject.radi ~
RowObject.rec RowObject.sele RowObject.slid RowObject.togg RowObject.txt 

/* Custom List Definitions                                              */
/* ADM-ASSIGN-FIELDS,List-2,List-3,List-4,List-5,List-6                 */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 77 BY 6.91.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     RowObject.proc AT ROW 2.57 COL 12
          LABEL "Procedure"
          VIEW-AS TOGGLE-BOX
          SIZE 16 BY .81
     RowObject.wind AT ROW 2.57 COL 38.8
          LABEL "Window"
          VIEW-AS TOGGLE-BOX
          SIZE 13.4 BY .81
     RowObject.dial AT ROW 2.57 COL 66.6
          LABEL "Dialog Box"
          VIEW-AS TOGGLE-BOX
          SIZE 17 BY .81
     RowObject.frm AT ROW 3.57 COL 12
          LABEL "Frame"
          VIEW-AS TOGGLE-BOX
          SIZE 13.4 BY .81
     RowObject.brow AT ROW 3.57 COL 38.8
          LABEL "Browse"
          VIEW-AS TOGGLE-BOX
          SIZE 13.4 BY .81
     RowObject.butt AT ROW 3.57 COL 66.6
          LABEL "Button"
          VIEW-AS TOGGLE-BOX
          SIZE 13.4 BY .81
     RowObject.comb AT ROW 4.57 COL 12
          LABEL "Combo-Box"
          VIEW-AS TOGGLE-BOX
          SIZE 16 BY .81
     RowObject.edit AT ROW 4.57 COL 38.8
          LABEL "Editor"
          VIEW-AS TOGGLE-BOX
          SIZE 13.4 BY .81
     RowObject.fil AT ROW 4.57 COL 66.6
          LABEL "Fill-in"
          VIEW-AS TOGGLE-BOX
          SIZE 13.4 BY .81
     RowObject.imag AT ROW 5.57 COL 12
          LABEL "Image"
          VIEW-AS TOGGLE-BOX
          SIZE 13.4 BY .81
     RowObject.ocx AT ROW 5.57 COL 38.8
          LABEL "OCX"
          VIEW-AS TOGGLE-BOX
          SIZE 13.4 BY .81
     RowObject.radi AT ROW 5.57 COL 66.6
          LABEL "Radio-Set"
          VIEW-AS TOGGLE-BOX
          SIZE 14.6 BY .81
     RowObject.rec AT ROW 6.57 COL 12
          LABEL "Rectangle"
          VIEW-AS TOGGLE-BOX
          SIZE 14.6 BY .81
     RowObject.sele AT ROW 6.57 COL 38.8
          LABEL "Selection-List"
          VIEW-AS TOGGLE-BOX
          SIZE 21 BY .81
     RowObject.slid AT ROW 6.57 COL 66.6
          LABEL "Slider"
          VIEW-AS TOGGLE-BOX
          SIZE 14.6 BY .81
     RowObject.togg AT ROW 7.57 COL 12
          LABEL "Toggle-Box"
          VIEW-AS TOGGLE-BOX
          SIZE 14.6 BY .81
     RowObject.txt AT ROW 7.57 COL 38.8
          LABEL "Text"
          VIEW-AS TOGGLE-BOX
          SIZE 14.6 BY .81
     RECT-1 AT ROW 1.95 COL 8
     "Applies To:" VIEW-AS TEXT
          SIZE 11 BY .62 AT ROW 1.67 COL 9
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY USE-DICT-EXPS 
         SIDE-LABELS NO-UNDERLINE THREE-D NO-AUTO-VALIDATE 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDataViewer
   Data Source: "adeuib/dabattribute.w"
   Allow: Basic,DB-Fields,Smart
   Container Links: Data-Target,Update-Source,TableIO-Target,GroupAssign-Source,GroupAssign-Target
   Frames: 1
   Add Fields to: Neither
   Other Settings: PERSISTENT-ONLY COMPILE
   Temp-Tables and Buffers:
      TABLE: RowObject D "?" ?  
      ADDITIONAL-FIELDS:
          {adeuib/dabattribute.i}
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
         HEIGHT             = 10.14
         WIDTH              = 98.4.
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

/* SETTINGS FOR TOGGLE-BOX RowObject.brow IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR TOGGLE-BOX RowObject.butt IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR TOGGLE-BOX RowObject.comb IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR TOGGLE-BOX RowObject.dial IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR TOGGLE-BOX RowObject.edit IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR TOGGLE-BOX RowObject.fil IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR TOGGLE-BOX RowObject.frm IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR TOGGLE-BOX RowObject.imag IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR TOGGLE-BOX RowObject.ocx IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR TOGGLE-BOX RowObject.proc IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR TOGGLE-BOX RowObject.radi IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR TOGGLE-BOX RowObject.rec IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR TOGGLE-BOX RowObject.sele IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR TOGGLE-BOX RowObject.slid IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR TOGGLE-BOX RowObject.togg IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR TOGGLE-BOX RowObject.txt IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR TOGGLE-BOX RowObject.wind IN FRAME F-Main
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

