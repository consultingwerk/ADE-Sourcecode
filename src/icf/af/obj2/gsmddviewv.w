&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12 GUI ADM2
&ANALYZE-RESUME
/* Connected Databases 
          asdb             PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Update-Object-Version" vTableWin _INLINE
/* Actions: ? ? ? ? af/sup/afverxftrp.p */
/* This has to go above the definitions sections, as that is what it modifies.
   If its not, then the definitions section will have been saved before the
   XFTR code kicks in and changes it */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Definition Comments Wizard" vTableWin _INLINE
/* Actions: ? af/cod/aftemwizcw.w ? ? ? */
/* Program Definition Comment Block Wizard
Welcome to the Program Definition Comment Block Wizard. Press Next to proceed.
af/cod/aftemwizpw.w
*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE RowObject
       {"af/obj2/gsmddfullo.i"}.


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
/*---------------------------------------------------------------------------------
  File: gsmddviewv.w

  Description:  Dataset Deployment SmartDataViewer

  Purpose:      Static SmartDataViewer for maintaining gsm_dataset_deployment records.

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:    90000090   UserRef:    posse
                Date:   29/04/2001  Author:     Tammy St Pierre

  Update Notes: Created from Template rysttviewv.w

---------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       gsmddviewv.w
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    010001

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/* Astra 2 object identifying preprocessor */
&glob   astra2-staticSmartDataViewer yes

{af/sup2/afglobals.i}

DEFINE VARIABLE gcDatasetCode   AS CHARACTER    NO-UNDO.
DEFINE VARIABLE gcSiteCode      AS CHARACTER    NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDataViewer
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER FRAME

&Scoped-define ADM-SUPPORTED-LINKS Data-Target,Update-Source,TableIO-Target,GroupAssign-Source,GroupAssign-Target

/* Include file with RowObject temp-table definition */
&Scoped-define DATA-FIELD-DEFS "af/obj2/gsmddfullo.i"

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME frMain

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS RowObject.deployment_number ~
RowObject.deployment_description RowObject.deployment_date ~
RowObject.deployment_time RowObject.baseline_deployment ~
RowObject.xml_filename RowObject.xml_exception_file RowObject.import_date ~
RowObject.import_time RowObject.import_user 
&Scoped-define ENABLED-TABLES RowObject
&Scoped-define FIRST-ENABLED-TABLE RowObject
&Scoped-define DISPLAYED-TABLES RowObject
&Scoped-define FIRST-DISPLAYED-TABLE RowObject
&Scoped-Define DISPLAYED-FIELDS RowObject.deployment_number ~
RowObject.deployment_description RowObject.deployment_date ~
RowObject.deployment_time RowObject.baseline_deployment ~
RowObject.xml_filename RowObject.xml_exception_file RowObject.import_date ~
RowObject.import_time RowObject.import_user 

/* Custom List Definitions                                              */
/* ADM-ASSIGN-FIELDS,List-2,List-3,List-4,List-5,List-6                 */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME frMain
     RowObject.deployment_number AT ROW 1.05 COL 27.4 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 37 BY 1
     RowObject.deployment_description AT ROW 2.05 COL 27.4 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 72 BY 1
     RowObject.deployment_date AT ROW 3.05 COL 27.4 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 16 BY 1
     RowObject.deployment_time AT ROW 4.05 COL 27.4 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 16 BY 1
     RowObject.baseline_deployment AT ROW 5.05 COL 29.4
          VIEW-AS TOGGLE-BOX
          SIZE 24.8 BY .81
     RowObject.xml_filename AT ROW 5.86 COL 27.4 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 72 BY 1
     RowObject.xml_exception_file AT ROW 6.86 COL 27.4 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 72 BY 1
     RowObject.import_date AT ROW 7.86 COL 27.4 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 16 BY 1
     RowObject.import_time AT ROW 8.86 COL 27.4 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 16 BY 1
     RowObject.import_user AT ROW 9.86 COL 27.4 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 37 BY 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY USE-DICT-EXPS 
         SIDE-LABELS NO-UNDERLINE THREE-D NO-AUTO-VALIDATE 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDataViewer
   Data Source: "af/obj2/gsmddfullo.w"
   Allow: Basic,DB-Fields,Smart
   Container Links: Data-Target,Update-Source,TableIO-Target,GroupAssign-Source,GroupAssign-Target
   Frames: 1
   Add Fields to: Neither
   Other Settings: PERSISTENT-ONLY COMPILE
   Temp-Tables and Buffers:
      TABLE: RowObject D "?" ?  
      ADDITIONAL-FIELDS:
          {af/obj2/gsmddfullo.i}
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
         HEIGHT             = 9.95
         WIDTH              = 102.8.
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
/* SETTINGS FOR FRAME frMain
   NOT-VISIBLE Size-to-Fit                                              */
ASSIGN 
       FRAME frMain:SCROLLABLE       = FALSE
       FRAME frMain:HIDDEN           = TRUE.

ASSIGN 
       RowObject.import_date:READ-ONLY IN FRAME frMain        = TRUE.

ASSIGN 
       RowObject.import_time:READ-ONLY IN FRAME frMain        = TRUE.

ASSIGN 
       RowObject.import_user:READ-ONLY IN FRAME frMain        = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME frMain
/* Query rebuild information for FRAME frMain
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME frMain */
&ANALYZE-RESUME





/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME RowObject.deployment_number
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL RowObject.deployment_number vTableWin
ON VALUE-CHANGED OF RowObject.deployment_number IN FRAME frMain /* Deployment Number */
DO:
  DEFINE VARIABLE cFileName AS CHARACTER    NO-UNDO.

  /* Update xml file names based on changed deployment number */
  ASSIGN
    cFileName = TRIM(gcSiteCode) + TRIM(gcDatasetCode) + STRING(ENTRY(1, SELF:SCREEN-VALUE, '.':U))
    RowObject.xml_filename:SCREEN-VALUE = cFileName + '.xml':U
    RowObject.xml_exception_file:SCREEN-VALUE = cFileName + 'e.xml':U.

  DYNAMIC-FUNCTION('setDataModified':U,
     INPUT YES).

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
DEFINE VARIABLE cFileName       AS CHARACTER    NO-UNDO.
DEFINE VARIABLE dDatasetObj     AS DECIMAL      NO-UNDO.
DEFINE VARIABLE dDeploymentNum  AS DECIMAL      NO-UNDO.
DEFINE VARIABLE hDataSource     AS HANDLE       NO-UNDO.

  RUN SUPER.

  /* Default deployment number to what the next deployment number should be and
     default the xml filenames to owning site code, dataset code and dataset 
     deployment number.  We don't know what the dataset deployment is 
     going to be yet so we need to get this information from the SDO */
  hDataSource = DYNAMIC-FUNCTION('getDataSource':U).
  hDataSource = DYNAMIC-FUNCTION('getDataSource':U IN hDataSource).
  gcSiteCode = DYNAMIC-FUNCTION('columnStringValue':U IN hDataSource,
                                INPUT 'owner_site_code':U).
  gcDatasetCode = DYNAMIC-FUNCTION('columnStringValue':U IN hDataSource,
                                   INPUT 'dataset_code':U).
  dDatasetObj = DECIMAL(DYNAMIC-FUNCTION('columnStringValue':U IN hDataSource,
                                         INPUT 'deploy_dataset_obj':U)).

  /* Run this procedure on the AppServer to get what the next deployment 
     number should be to default the deployment number */
  RUN af/sup2/gsmddndnmp.p ON gshAstraAppServer (INPUT dDatasetObj, OUTPUT dDeploymentNum).

  cFileName = TRIM(gcSiteCode) + TRIM(gcDatasetCode) + STRING(dDeploymentNum).

  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN 
      RowObject.deployment_number:SCREEN-VALUE = STRING(dDeploymentNum)
      RowObject.xml_filename:SCREEN-VALUE = cFileName + '.xml':U
      RowObject.xml_exception_file:SCREEN-VALUE = cFileName + 'e.xml':U.
  END.  /* do with frame */

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
  HIDE FRAME frMain.
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

  DEFINE VARIABLE hDataSource   AS HANDLE       NO-UNDO.

  RUN SUPER( INPUT pcColValues).

  hDataSource = DYNAMIC-FUNCTION('getDataSource':U).
  hDataSource = DYNAMIC-FUNCTION('getDataSource':U IN hDataSource).

  /* Set Dataset code and Site code globally so they can be used to 
     reset the xml filenames if the deployment number is changed by the
     user */
  ASSIGN
    gcDatasetCode = DYNAMIC-FUNCTION('columnStringValue':U IN hDataSource,
                                     INPUT 'dataset_code':U)
    gcSiteCode = DYNAMIC-FUNCTION('columnStringValue':U IN hDataSource,
                                  INPUT 'owner_site_code':U).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

