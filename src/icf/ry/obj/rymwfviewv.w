&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12 GUI ADM2
&ANALYZE-RESUME
/* Connected Databases 
          asdb             PROGRESS
          rydb             PROGRESS
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
       {"ry/obj/rymwffullo.i"}.


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
  File: rymwfviewv.w

  Description:  Wizard Folder Viewer

  Purpose:      Wizard Folder Viewer

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:        6478   UserRef:    
                Date:   17/08/2000  Author:     Anthony Swindells

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

&scop object-name       rymwfviewv.w
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    010001

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
&Scoped-define DATA-FIELD-DEFS "ry/obj/rymwffullo.i"

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME frMain

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS RowObject.object_name ~
RowObject.object_description RowObject.window_title RowObject.default_mode ~
RowObject.no_sdo RowObject.viewer_link_name 
&Scoped-define ENABLED-TABLES RowObject
&Scoped-define FIRST-ENABLED-TABLE RowObject
&Scoped-define DISPLAYED-TABLES RowObject
&Scoped-define FIRST-DISPLAYED-TABLE RowObject
&Scoped-Define ENABLED-OBJECTS ToBoxGA 
&Scoped-Define DISPLAYED-FIELDS RowObject.object_name ~
RowObject.object_description RowObject.window_title RowObject.default_mode ~
RowObject.no_sdo RowObject.viewer_link_name RowObject.generated_date ~
RowObject.generated_time_str 
&Scoped-Define DISPLAYED-OBJECTS ToBoxGA 

/* Custom List Definitions                                              */
/* ADM-ASSIGN-FIELDS,List-2,List-3,List-4,List-5,List-6                 */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */


/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_gscpmcsdfv AS HANDLE NO-UNDO.
DEFINE VARIABLE h_gscprcsdfv AS HANDLE NO-UNDO.
DEFINE VARIABLE h_ryclacsdfv AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE VARIABLE ToBoxGA AS LOGICAL INITIAL no 
     LABEL "One-to-One Update in SBO" 
     VIEW-AS TOGGLE-BOX
     SIZE 31.2 BY .81 TOOLTIP "Use GroupAssign link between viewers for a one-to-one update in an SBO" NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME frMain
     RowObject.object_name AT ROW 3.38 COL 33.8 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 46 BY 1 TOOLTIP "Specify a unique name for the object (no path or extension)"
     RowObject.object_description AT ROW 4.48 COL 33.8 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 46 BY 1 TOOLTIP "Specify description for object as it should appear on a menu"
     RowObject.window_title AT ROW 5.57 COL 33.8 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 46 BY 1 TOOLTIP "Specify the window title for the folder window"
     RowObject.default_mode AT ROW 6.67 COL 33.8 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 46 BY 1 TOOLTIP "Specify the default mode, usually modify"
     RowObject.no_sdo AT ROW 7.76 COL 35.8
          VIEW-AS TOGGLE-BOX
          SIZE 20.8 BY .81 TOOLTIP "Set to NO for folder windows that do not require an SDO for data"
     ToBoxGA AT ROW 10 COL 35.8
     RowObject.viewer_link_name AT ROW 10.86 COL 33.8 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 46 BY 1 TOOLTIP "Specify a manual link to create between viewers linked to same SDO"
     RowObject.generated_date AT ROW 12.05 COL 33.8 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 19 BY 1
     RowObject.generated_time_str AT ROW 13.14 COL 33.8 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 19 BY 1
     SPACE(28.60) SKIP(0.00)
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY USE-DICT-EXPS 
         SIDE-LABELS NO-UNDERLINE THREE-D NO-AUTO-VALIDATE 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDataViewer
   Data Source: "ry/obj/rymwffullo.w"
   Allow: Basic,DB-Fields,Smart
   Container Links: Data-Target,Update-Source,TableIO-Target,GroupAssign-Source,GroupAssign-Target
   Frames: 1
   Add Fields to: Neither
   Other Settings: PERSISTENT-ONLY COMPILE
   Temp-Tables and Buffers:
      TABLE: RowObject D "?" ?  
      ADDITIONAL-FIELDS:
          {ry/obj/rymwffullo.i}
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
         HEIGHT             = 13.38
         WIDTH              = 84.8.
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

/* SETTINGS FOR FILL-IN RowObject.generated_date IN FRAME frMain
   NO-ENABLE                                                            */
ASSIGN 
       RowObject.generated_date:READ-ONLY IN FRAME frMain        = TRUE.

/* SETTINGS FOR FILL-IN RowObject.generated_time_str IN FRAME frMain
   NO-ENABLE                                                            */
ASSIGN 
       RowObject.generated_time_str:READ-ONLY IN FRAME frMain        = TRUE.

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

&Scoped-define SELF-NAME RowObject.object_description
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL RowObject.object_description vTableWin
ON LEAVE OF RowObject.object_description IN FRAME frMain /* Object Description */
DO:
  IF RowObject.WINDOW_title:SCREEN-VALUE = "":U THEN
    ASSIGN RowObject.WINDOW_title:SCREEN-VALUE = SELF:SCREEN-VALUE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ToBoxGA
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ToBoxGA vTableWin
ON VALUE-CHANGED OF ToBoxGA IN FRAME frMain /* One-to-One Update in SBO */
DO:
  /* If the one-to-one toggle is checked then we need to assign the viewer
     link name to GroupAssign and make it read only.  Otherwise we set viewer
     link name to blank and make it readable. */
  IF SELF:CHECKED THEN
    ASSIGN 
      RowObject.viewer_link_name:SCREEN-VALUE = 'GroupAssign':U
      RowObject.viewer_link_name:READ-ONLY = TRUE.
  ELSE 
    ASSIGN
      RowObject.viewer_link_name:SCREEN-VALUE = '':U
      RowObject.viewer_link_name:READ-ONLY = FALSE.

  DYNAMIC-FUNCTION('setDataModified':U,
     INPUT YES).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME RowObject.window_title
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL RowObject.window_title vTableWin
ON LEAVE OF RowObject.window_title IN FRAME frMain /* Window Title */
DO:
  IF RowObject.OBJECT_description:SCREEN-VALUE = "":U THEN
    ASSIGN RowObject.OBJECT_description:SCREEN-VALUE = SELF:SCREEN-VALUE.
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

  IF VALID-HANDLE(h_ryclacsdfv) THEN
  DO:
    DYNAMIC-FUNCTION("setDataValue":U IN h_ryclacsdfv, INPUT "Top/Center/Bottom":U).
  END.

  DO WITH FRAME {&FRAME-NAME}:
    RowObject.default_mode:SCREEN-VALUE = "modify":U.
  END.


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
  DEFINE VARIABLE currentPage  AS INTEGER NO-UNDO.

  ASSIGN currentPage = getCurrentPage().

  CASE currentPage: 

    WHEN 0 THEN DO:
       RUN constructObject (
             INPUT  'ry/obj/gscprcsdfv.w':U ,
             INPUT  FRAME frMain:HANDLE ,
             INPUT  'FieldNameproduct_codeDisplayFieldyesEnableFieldyesHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT h_gscprcsdfv ).
       RUN repositionObject IN h_gscprcsdfv ( 1.00 , 27.40 ) NO-ERROR.
       RUN resizeObject IN h_gscprcsdfv ( 1.10 , 54.60 ) NO-ERROR.

       RUN constructObject (
             INPUT  'ry/obj/gscpmcsdfv.w':U ,
             INPUT  FRAME frMain:HANDLE ,
             INPUT  'FieldNameproduct_module_codeDisplayFieldyesEnableFieldyesHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT h_gscpmcsdfv ).
       RUN repositionObject IN h_gscpmcsdfv ( 2.14 , 19.80 ) NO-ERROR.
       RUN resizeObject IN h_gscpmcsdfv ( 1.10 , 62.40 ) NO-ERROR.

       RUN constructObject (
             INPUT  'ry/obj/ryclacsdfv.w':U ,
             INPUT  FRAME frMain:HANDLE ,
             INPUT  'FieldNamepage_layoutDisplayFieldyesEnableFieldyesHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT h_ryclacsdfv ).
       RUN repositionObject IN h_ryclacsdfv ( 8.81 , 27.40 ) NO-ERROR.
       RUN resizeObject IN h_ryclacsdfv ( 1.10 , 56.00 ) NO-ERROR.

       /* Adjust the tab order of the smart objects. */
       RUN adjustTabOrder ( h_gscprcsdfv ,
             RowObject.object_name:HANDLE IN FRAME frMain , 'BEFORE':U ).
       RUN adjustTabOrder ( h_gscpmcsdfv ,
             h_gscprcsdfv , 'AFTER':U ).
       RUN adjustTabOrder ( h_ryclacsdfv ,
             RowObject.no_sdo:HANDLE IN FRAME frMain , 'AFTER':U ).
    END. /* Page 0 */

  END CASE.

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

  DEFINE VARIABLE cContainerMode    AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE hContainerSource  AS HANDLE       NO-UNDO.

  RUN SUPER( INPUT pcColValues).

  hContainerSource = DYNAMIC-FUNCTION('getContainerSource':U).
  cContainerMode = DYNAMIC-FUNCTION('getContainerMode':U IN hContainerSource).

  /* If viewer link name is groupAssign then we need to check the one-to-one
     toggle and make the viewer link name field read only.  Otherwise we 
     un-check the toggle and make the viewer link name readable. */
  IF cContainerMode = 'Modify':U THEN
  DO WITH FRAME {&FRAME-NAME}:
    IF RowObject.viewer_link_name:SCREEN-VALUE = 'GroupAssign':U THEN
      ASSIGN
        RowObject.viewer_link_name:READ-ONLY = TRUE
        ToBoxGA:CHECKED = TRUE.
    ELSE
      ASSIGN
          RowObject.viewer_link_name:READ-ONLY = FALSE
          ToBoxGA:CHECKED = FALSE.
  END.  /* if mode = modify */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE RTB_xref_generator vTableWin 
PROCEDURE RTB_xref_generator :
/* -----------------------------------------------------------
Purpose:    Generate RTB xrefs for SMARTOBJECTS.
Parameters: <none>
Notes:      This code is generated by the UIB.  DO NOT modify it.
            It is included for Roundtable Xref generation. Without
            it, Xrefs for SMARTOBJECTS could not be maintained by
            RTB.  It will in no way affect the operation of this
            program as it never gets executed.
-------------------------------------------------------------*/
  RUN "ry\obj\gscprcsdfv.w *RTB-SmObj* ".
  RUN "ry\obj\gscpmcsdfv.w *RTB-SmObj* ".
  RUN "ry\obj\ryclacsdfv.w *RTB-SmObj* ".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updateRecord vTableWin 
PROCEDURE updateRecord :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE cButton AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cError  AS CHARACTER    NO-UNDO.

  DO WITH FRAME {&FRAME-NAME}:
    IF NOT ToBoxGA:CHECKED AND 
      RowObject.viewer_link_name:SCREEN-VALUE = 'GroupAssign':U THEN
    DO:
      cError = {af/sup2/aferrortxt.i 'AF' '118' 'rym_wizard_fold' 'viewer_link_name'}.
      RUN showMessages IN gshSessionManager (INPUT cError,
                                             INPUT "ERR":U,
                                             INPUT "OK":U,
                                             INPUT "OK":U,
                                             INPUT "OK":U,
                                             INPUT "Viewer Link Name",
                                             INPUT YES,
                                             INPUT ?,
                                             OUTPUT cButton).
      RETURN 'ADM-ERROR':U.
    END.
  END.  /* do with frame */

  RUN SUPER.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

