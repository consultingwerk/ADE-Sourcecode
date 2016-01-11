&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI ADM2
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW

/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE RowObject
       {"protools/dappsrv.i"}.


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS vTableWin 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation ("PSC"),       *
* 14 Oak Park, Bedford, MA 01730, and other contributors as listed   *
* below.  All Rights Reserved.                                       *
*                                                                    *
* The Initial Developer of the Original Code is PSC.  The Original   *
* Code is Progress IDE code released to open source December 1, 2000.*
*                                                                    *
* The contents of this file are subject to the Possenet Public       *
* License Version 1.0 (the "License"); you may not use this file     *
* except in compliance with the License.  A copy of the License is   *
* available as of the date of this notice at                         *
* http://www.possenet.org/license.html                               *
*                                                                    *
* Software distributed under the License is distributed on an "AS IS"*
* basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. You*
* should refer to the License for the specific language governing    *
* rights and limitations under the License.                          *
*                                                                    *
* Contributors:                                                      *
*                                                                    *
*********************************************************************/
/*------------------------------------------------------------------------

  File:               protools/vappsrv.w

  Description:        AppServer Partition Viewer. 
                      This Viewer provides editing facilities for the
                      AppServer partition type data in appserv-tt.

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Created:            May 9, 2000 - Bruce Gruenbaum

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
&Scoped-define DATA-FIELD-DEFS "protools/dappsrv.i"

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS RowObject.Partition RowObject.Host ~
RowObject.Parameters RowObject.Service RowObject.App-Service ~
RowObject.ServerURL RowObject.Configuration RowObject.Security ~
RowObject.Info 
&Scoped-define ENABLED-TABLES RowObject
&Scoped-define FIRST-ENABLED-TABLE RowObject
&Scoped-Define ENABLED-OBJECTS RECT-2 
&Scoped-Define DISPLAYED-FIELDS RowObject.Partition RowObject.Host ~
RowObject.Parameters RowObject.Service RowObject.App-Service ~
RowObject.ServerURL RowObject.Configuration RowObject.Security ~
RowObject.Info 
&Scoped-define DISPLAYED-TABLES RowObject
&Scoped-define FIRST-DISPLAYED-TABLE RowObject
&Scoped-Define DISPLAYED-OBJECTS toSSL toSessionReuse toHostVerify 

/* Custom List Definitions                                              */
/* ADM-ASSIGN-FIELDS,List-2,List-3,List-4,List-5,List-6                 */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 68 BY 15.1.

DEFINE VARIABLE toHostVerify AS LOGICAL INITIAL no 
     LABEL "Host verification disabled" 
     VIEW-AS TOGGLE-BOX
     SIZE 30 BY .81 TOOLTIP "Host verification disabled (-nohostverify)" NO-UNDO.

DEFINE VARIABLE toSessionReuse AS LOGICAL INITIAL no 
     LABEL "Session reuse disabled" 
     VIEW-AS TOGGLE-BOX
     SIZE 30 BY .81 TOOLTIP "Session reuse disabled (-nosessionreuse)" NO-UNDO.

DEFINE VARIABLE toSSL AS LOGICAL INITIAL no 
     LABEL "SSL enabled" 
     VIEW-AS TOGGLE-BOX
     SIZE 30 BY .81 TOOLTIP "SSL enabled (-ssl)" NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     RowObject.Partition AT ROW 1.24 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 27 BY 1
     RowObject.Host AT ROW 2.43 COL 20 COLON-ALIGNED
          LABEL "Host (-H)"
          VIEW-AS FILL-IN 
          SIZE 17 BY 1
     RowObject.Parameters AT ROW 2.91 COL 41 NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 27 BY 1
     RowObject.Service AT ROW 3.62 COL 20 COLON-ALIGNED
          LABEL "Service (-S)"
          VIEW-AS FILL-IN 
          SIZE 17 BY 1
     toSSL AT ROW 4.71 COL 22.2
     toSessionReuse AT ROW 5.48 COL 22.2
     toHostVerify AT ROW 6.24 COL 22.2
     RowObject.App-Service AT ROW 7.05 COL 2.6
          VIEW-AS FILL-IN 
          SIZE 27 BY 1
     RowObject.ServerURL AT ROW 8.24 COL 5.8
          LABEL "AppServer URL"
          VIEW-AS FILL-IN 
          SIZE 45 BY 1
     RowObject.Configuration AT ROW 9.43 COL 22 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL EXPAND 
          RADIO-BUTTONS 
                    "Remote", yes,
"Local", no
          SIZE 31 BY .95
     RowObject.Security AT ROW 10.38 COL 22
          LABEL "Prompt for userid and password"
          VIEW-AS TOGGLE-BOX
          SIZE 34.6 BY .81
     RowObject.Info AT ROW 12.29 COL 3 NO-LABEL
          VIEW-AS EDITOR NO-WORD-WRAP MAX-CHARS 255 SCROLLBAR-HORIZONTAL SCROLLBAR-VERTICAL
          SIZE 64 BY 3.57
     "AppServer Information String:" VIEW-AS TEXT
          SIZE 29 BY .62 AT ROW 11.33 COL 3
     "Configuration:" VIEW-AS TEXT
          SIZE 13 BY .95 AT ROW 9.43 COL 8
     RECT-2 AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY USE-DICT-EXPS 
         SIDE-LABELS NO-UNDERLINE THREE-D NO-AUTO-VALIDATE 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDataViewer
   Data Source: "protools/dappsrv.w"
   Allow: Basic,DB-Fields,Smart
   Container Links: Data-Target,Update-Source,TableIO-Target,GroupAssign-Source,GroupAssign-Target
   Frames: 1
   Add Fields to: Neither
   Other Settings: PERSISTENT-ONLY COMPILE
   Temp-Tables and Buffers:
      TABLE: RowObject D "?" ?  
      ADDITIONAL-FIELDS:
          {protools/dappsrv.i}
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
         HEIGHT             = 15.1
         WIDTH              = 68.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB vTableWin 
/* ************************* Included-Libraries *********************** */

{src/adm2/viewer.i}
{adecomm/_adetool.i}

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

/* SETTINGS FOR FILL-IN RowObject.App-Service IN FRAME F-Main
   ALIGN-L                                                              */
/* SETTINGS FOR RADIO-SET RowObject.Configuration IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN RowObject.Host IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR EDITOR RowObject.Info IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN RowObject.Parameters IN FRAME F-Main
   ALIGN-L                                                              */
ASSIGN 
       RowObject.Parameters:HIDDEN IN FRAME F-Main           = TRUE.

/* SETTINGS FOR TOGGLE-BOX RowObject.Security IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN RowObject.ServerURL IN FRAME F-Main
   ALIGN-L EXP-LABEL                                                    */
/* SETTINGS FOR FILL-IN RowObject.Service IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR TOGGLE-BOX toHostVerify IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX toSessionReuse IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX toSSL IN FRAME F-Main
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

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME toHostVerify
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL toHostVerify vTableWin
ON VALUE-CHANGED OF toHostVerify IN FRAME F-Main /* Host verification disabled */
DO:
  {set DataModified TRUE}.
  RUN setParameters.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME toSessionReuse
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL toSessionReuse vTableWin
ON VALUE-CHANGED OF toSessionReuse IN FRAME F-Main /* Session reuse disabled */
DO:
  {set DataModified TRUE}.
  RUN setParameters.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME toSSL
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL toSSL vTableWin
ON VALUE-CHANGED OF toSSL IN FRAME F-Main /* SSL enabled */
DO:
  {set DataModified TRUE}.
  RUN setParameters.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disableFields vTableWin 
PROCEDURE disableFields :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER pcFieldType AS CHARACTER NO-UNDO.

  RUN SUPER( INPUT pcFieldType).
  DO WITH FRAME {&FRAME-NAME}:
     ASSIGN toSSL:SENSITIVE          = FALSE
            toSessionReuse:SENSITIVE = FALSE
            toHostVerify:SENSITIVE   = FALSE.
  END.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE displayFields vTableWin 
PROCEDURE displayFields :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER pcColValues AS CHARACTER NO-UNDO.

  RUN SUPER( INPUT pcColValues).
  DO WITH FRAME {&FRAME-NAME}:
     toSSL:CHECKED          = INDEX(RowObject.Parameters:SCREEN-VALUE, "-ssl") > 0.
     toSessionReuse:CHECKED = INDEX(RowObject.Parameters:SCREEN-VALUE, "-nosessionreuse") > 0.
     toHostVerify:CHECKED   = INDEX(RowObject.Parameters:SCREEN-VALUE, "-nohostverify") > 0.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enableFields vTableWin 
PROCEDURE enableFields :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hDataSource    AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cQueryPosition AS CHARACTER NO-UNDO.

  RUN SUPER.

  {get DataSource hDataSource}.
  IF NOT VALID-HANDLE(hDataSource) THEN
     RETURN.

  IF DYNAMIC-FUNCTION('getQueryPosition':U IN hDataSource) <> "NoRecordAvailable":U 
     OR DYNAMIC-FUNCTION('getNewRecord':U) = "Add":U THEN
  DO WITH FRAME {&FRAME-NAME}:
     ASSIGN toSSL:SENSITIVE          = TRUE
            toSessionReuse:SENSITIVE = TRUE
            toHostVerify:SENSITIVE   = TRUE.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setParameters vTableWin 
PROCEDURE setParameters PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  
  DO WITH FRAME {&FRAME-NAME}:
     RowObject.Parameters:SCREEN-VALUE =
        (IF toSSL:CHECKED          THEN " -ssl":U            ELSE "":U) +
        (IF toSessionReuse:CHECKED THEN " -nosessionreuse":U ELSE "":U) +
        (IF toHostVerify:CHECKED   THEN " -nohostverify":U   ELSE "":U).
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

