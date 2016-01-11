&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12 GUI ADM2
&ANALYZE-RESUME
/* Connected Databases 
          icfdb            PROGRESS
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
       {"ry/obj/rycuefullo.i"}.


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
  File: rycueviewv.w

  Description:  UI Event Viewer

  Purpose:      UI Event Viewer

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:   101000029   UserRef:    
                Date:   09/12/2001  Author:     Peter Judge

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

&scop object-name       rycueviewv.w
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    010000

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/* Astra 2 object identifying preprocessor */
&glob   astra2-staticSmartDataViewer yes

{af/sup2/afglobals.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDataViewer
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER FRAME

&Scoped-define ADM-SUPPORTED-LINKS Data-Target,Update-Source,TableIO-Target,GroupAssign-Source,GroupAssign-Target

/* Include file with RowObject temp-table definition */
&Scoped-define DATA-FIELD-DEFS "ry/obj/rycuefullo.i"

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME frMain

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS RowObject.event_name RowObject.action_type ~
RowObject.object_type_obj RowObject.container_smartobject_obj ~
RowObject.smartobject_obj RowObject.object_instance_obj ~
RowObject.action_target RowObject.event_action RowObject.event_parameter ~
RowObject.event_disabled 
&Scoped-define ENABLED-TABLES RowObject
&Scoped-define FIRST-ENABLED-TABLE RowObject
&Scoped-define DISPLAYED-TABLES RowObject
&Scoped-define FIRST-DISPLAYED-TABLE RowObject
&Scoped-Define DISPLAYED-FIELDS RowObject.event_name RowObject.action_type ~
RowObject.object_type_obj RowObject.container_smartobject_obj ~
RowObject.smartobject_obj RowObject.object_instance_obj ~
RowObject.action_target RowObject.event_action RowObject.event_parameter ~
RowObject.event_disabled RowObject.constant_value ~
RowObject.inheritted_value 

/* Custom List Definitions                                              */
/* ADM-ASSIGN-FIELDS,List-2,List-3,List-4,List-5,List-6                 */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME frMain
     RowObject.event_name AT ROW 1.19 COL 18.6 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 37 BY 1
     RowObject.action_type AT ROW 2.24 COL 18.6 COLON-ALIGNED FORMAT "X(15)"
          VIEW-AS FILL-IN 
          SIZE 30 BY 1
     RowObject.object_type_obj AT ROW 2.67 COL 60.2 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 5 BY 1
     RowObject.container_smartobject_obj AT ROW 2.67 COL 60.2 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 5 BY 1
     RowObject.smartobject_obj AT ROW 2.67 COL 60.2 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 5 BY 1
     RowObject.object_instance_obj AT ROW 2.67 COL 60.2 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 5 BY 1
     RowObject.action_target AT ROW 3.24 COL 18.6 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 30 BY 1
     RowObject.event_action AT ROW 4.24 COL 18.6 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 37 BY 1
     RowObject.event_parameter AT ROW 5.29 COL 18.6 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 72 BY 1
     RowObject.event_disabled AT ROW 6.43 COL 20.6
          VIEW-AS TOGGLE-BOX
          SIZE 19.4 BY .81
     RowObject.constant_value AT ROW 7.19 COL 20.6
          VIEW-AS TOGGLE-BOX
          SIZE 19.4 BY .81
     RowObject.inheritted_value AT ROW 8.05 COL 20.6
          VIEW-AS TOGGLE-BOX
          SIZE 19.8 BY .81
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY USE-DICT-EXPS 
         SIDE-LABELS NO-UNDERLINE THREE-D NO-AUTO-VALIDATE 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDataViewer
   Data Source: "ry/obj/rycuefullo.w"
   Allow: Basic,DB-Fields,Smart
   Container Links: Data-Target,Update-Source,TableIO-Target,GroupAssign-Source,GroupAssign-Target
   Frames: 1
   Add Fields to: Neither
   Other Settings: PERSISTENT-ONLY COMPILE
   Temp-Tables and Buffers:
      TABLE: RowObject D "?" ?  
      ADDITIONAL-FIELDS:
          {ry/obj/rycuefullo.i}
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
         HEIGHT             = 7.86
         WIDTH              = 91.6.
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

/* SETTINGS FOR FILL-IN RowObject.action_type IN FRAME frMain
   EXP-FORMAT                                                           */
/* SETTINGS FOR TOGGLE-BOX RowObject.constant_value IN FRAME frMain
   NO-ENABLE                                                            */
ASSIGN 
       RowObject.container_smartobject_obj:HIDDEN IN FRAME frMain           = TRUE
       RowObject.container_smartobject_obj:PRIVATE-DATA IN FRAME frMain     = 
                "NOLOOKUPS".

/* SETTINGS FOR TOGGLE-BOX RowObject.inheritted_value IN FRAME frMain
   NO-ENABLE                                                            */
ASSIGN 
       RowObject.object_instance_obj:HIDDEN IN FRAME frMain           = TRUE
       RowObject.object_instance_obj:PRIVATE-DATA IN FRAME frMain     = 
                "NOLOOKUPS".

ASSIGN 
       RowObject.object_type_obj:HIDDEN IN FRAME frMain           = TRUE
       RowObject.object_type_obj:PRIVATE-DATA IN FRAME frMain     = 
                "NOLOOKUPS".

ASSIGN 
       RowObject.smartobject_obj:HIDDEN IN FRAME frMain           = TRUE
       RowObject.smartobject_obj:PRIVATE-DATA IN FRAME frMain     = 
                "NOLOOKUPS".

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME frMain
/* Query rebuild information for FRAME frMain
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME frMain */
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE addRecord vTableWin 
PROCEDURE addRecord :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE hContainer          AS HANDLE                       NO-UNDO.
    DEFINE VARIABLE hDataSource         AS HANDLE                       NO-UNDO.
    DEFINE VARIABLE hParentData         AS HANDLE                       NO-UNDO.
    DEFINE VARIABLE cDataSource         AS CHARACTER                    NO-UNDO.
    DEFINE VARIABLE cMode               AS CHARACTER                    NO-UNDO.
    DEFINE VARIABLE cColValues          AS CHARACTER                    NO-UNDO.
    DEFINE VARIABLE cLevel              AS CHARACTER                    NO-UNDO.
    DEFINE VARIABLE cColumns            AS CHARACTER                    NO-UNDO.
    DEFINE VARIABLE cColumnValue        AS CHARACTER                    NO-UNDO.
    DEFINE VARIABLE iLoop               AS INTEGER                      NO-UNDO.

    RUN SUPER.
    
    DO WITH FRAME {&FRAME-NAME}:
        {get DataSource cDataSource}.
        DO iLoop = 1 TO NUM-ENTRIES(cDataSource):
            ASSIGN hDataSource = WIDGET-HANDLE(ENTRY(iLoop, cDataSource)).
            IF VALID-HANDLE(hDataSource) THEN
            DO:
                /* Determine where we are */
                ASSIGN cLevel = DYNAMIC-FUNCTION("getSDOLevel":U IN hDataSource).

                {get DataSource hParentData hDataSource}.

                IF VALID-HANDLE(hParentData) THEN
                DO:
                    IF cLevel EQ "SmartObject":U THEN
                        ASSIGN cColumns = "object_type_obj,smartobject_obj":U.
                    ELSE
                        ASSIGN cColumns = "container_smartobject_obj,smartobject_obj,object_type_obj,object_instance_obj":U.

                    ASSIGN cColValues = DYNAMIC-FUNCTION ("colValues" IN hParentData, INPUT cColumns).

                    IF cLevel EQ "SmartObject":U THEN
                    DO:                        
                        ASSIGN cColumnValue                           = ENTRY(2, cColValues, CHR(1))
                               rowObject.object_type_obj:SCREEN-VALUE = cColumnValue
                               .                      
                        ASSIGN cColumnValue                           = ENTRY(3, cColValues, CHR(1))
                               rowObject.smartObject_obj:SCREEN-VALUE = cColumnValue
                               .
                        ASSIGN rowObject.container_smartObject_obj:SCREEN-VALUE = STRING(0)
                               rowObject.object_instance_obj:SCREEN-VALUE       = STRING(0)
                               .
                    END.    /* SmartObject */
                    ELSE
                    DO:
                        ASSIGN cColumnValue                                     = ENTRY(2, cColValues, CHR(1))
                               rowObject.container_smartObject_obj:SCREEN-VALUE = cColumnValue
                               .
                        ASSIGN cColumnValue                           = ENTRY(3, cColValues, CHR(1))
                               rowObject.smartObject_obj:SCREEN-VALUE = cColumnValue
                               .
                        ASSIGN cColumnValue                           = ENTRY(4, cColValues, CHR(1))
                               rowObject.object_type_obj:SCREEN-VALUE = cColumnValue
                               .
                        ASSIGN cColumnValue = ENTRY(5, cColValues, CHR(1))
                               rowObject.object_instance_obj:SCREEN-VALUE = cColumnValue
                               .
                    END.    /* ObjectInstance */
                END.    /* valid parent */
            END.    /* valid data source */
        END.    /* loop through data sources */
    END.    /* ADD mode */    

    RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects vTableWin  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

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

