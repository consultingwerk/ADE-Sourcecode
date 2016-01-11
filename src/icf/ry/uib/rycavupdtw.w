&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12 GUI ADM2
&ANALYZE-RESUME
/* Connected Databases 
          icfdb            PROGRESS
*/
&Scoped-define WINDOW-NAME wiWin
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Update-Object-Version" wiWin _INLINE
/* Actions: ? ? ? ? af/sup/afverxftrp.p */
/* This has to go above the definitions sections, as that is what it modifies.
   If its not, then the definitions section will have been saved before the
   XFTR code kicks in and changes it */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Definition Comments Wizard" wiWin _INLINE
/* Actions: ? af/cod/aftemwizcw.w ? ? ? */
/* Program Definition Comment Block Wizard
Welcome to the Program Definition Comment Block Wizard. Press Next to proceed.
af/cod/aftemwizpw.w
*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wiWin 
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
  File: rycavupdtw.w

  Description:  Attribute Value Update Utility SmartWind

  Purpose:      Attribute Value Update Utility SmartWindow

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   10/31/2001  Author:     Mark Davies (MIP)

  Update Notes: Created from Template rysttbconw.w

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

&scop object-name       rycavupdtw.w
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/* object identifying preprocessor */
&glob   astra2-staticSmartWindow yes

{af/sup2/afglobals.i}

{af/sup2/afrun2.i     &define-only = YES} 

/* Include Temp-Table definitions */
{ry/inc/rycavtempt.i}

DEFINE VARIABLE gdObjectType     AS DECIMAL    NO-UNDO.
DEFINE VARIABLE gdProductModule  AS DECIMAL    NO-UNDO.
DEFINE VARIABLE gcObjectFileName AS CHARACTER  NO-UNDO.
DEFINE VARIABLE glAllObjects     AS LOGICAL    NO-UNDO.
DEFINE VARIABLE ghProgressDialog AS HANDLE   NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

&Scoped-define ADM-SUPPORTED-LINKS Data-Target,Data-Source,Page-Target,Update-Source,Update-Target,Filter-target,Filter-Source

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME frMain
&Scoped-define BROWSE-NAME BrBrowse

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES gsc_object gsc_product_module ~
gsc_object_type ryc_smartobject

/* Definitions for BROWSE BrBrowse                                      */
&Scoped-define FIELDS-IN-QUERY-BrBrowse gsc_object.object_filename ~
gsc_object.object_extension gsc_object.object_path ~
gsc_object.object_description gsc_object_type.object_type_code ~
gsc_product_module.product_module_code gsc_object.logical_object ~
gsc_object.generic_object gsc_object.disabled 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BrBrowse 
&Scoped-define OPEN-QUERY-BrBrowse OPEN QUERY BrBrowse FOR EACH gsc_object ~
      WHERE (IF gdObjectType <> 0 THEN gsc_object.object_type_obj = gdObjectType ELSE TRUE) ~
 AND (IF gdProductModule <> 0 THEN gsc_object.product_module_obj = gdProductModule ELSE TRUE) ~
 AND gsc_object.object_filename BEGINS gcObjectFileName NO-LOCK, ~
      FIRST gsc_product_module WHERE gsc_product_module.product_module_obj = gsc_object.product_module_obj NO-LOCK, ~
      FIRST gsc_object_type WHERE gsc_object_type.object_type_obj = gsc_object.object_type_obj NO-LOCK, ~
      FIRST ryc_smartobject WHERE ryc_smartobject.object_obj = gsc_object.object_obj NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BrBrowse gsc_object gsc_product_module ~
gsc_object_type ryc_smartobject
&Scoped-define FIRST-TABLE-IN-QUERY-BrBrowse gsc_object
&Scoped-define SECOND-TABLE-IN-QUERY-BrBrowse gsc_product_module
&Scoped-define THIRD-TABLE-IN-QUERY-BrBrowse gsc_object_type
&Scoped-define FOURTH-TABLE-IN-QUERY-BrBrowse ryc_smartobject


/* Definitions for FRAME frMain                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS BrBrowse buOK buCancel 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wiWin AS WIDGET-HANDLE NO-UNDO.

/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_rycavupdtv AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON buCancel 
     LABEL "&Cancel" 
     SIZE 15 BY 1.14
     BGCOLOR 8 .

DEFINE BUTTON buDeselectAll 
     LABEL "&Deselect All" 
     SIZE 15 BY 1.14
     BGCOLOR 8 .

DEFINE BUTTON buOK 
     LABEL "&OK" 
     SIZE 15 BY 1.14
     BGCOLOR 8 .

DEFINE BUTTON buSelectAll 
     LABEL "Select &All" 
     SIZE 15 BY 1.14
     BGCOLOR 8 .

DEFINE BUTTON buViewLog 
     LABEL "&View Log" 
     SIZE 15 BY 1.14
     BGCOLOR 8 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BrBrowse FOR 
      gsc_object, 
      gsc_product_module, 
      gsc_object_type, 
      ryc_smartobject SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BrBrowse
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BrBrowse wiWin _STRUCTURED
  QUERY BrBrowse NO-LOCK DISPLAY
      gsc_object.object_filename FORMAT "X(35)":U
      gsc_object.object_extension FORMAT "X(35)":U WIDTH 17.4
      gsc_object.object_path FORMAT "X(70)":U WIDTH 23.2
      gsc_object.object_description FORMAT "X(35)":U WIDTH 52.4
      gsc_object_type.object_type_code FORMAT "X(15)":U
      gsc_product_module.product_module_code FORMAT "X(10)":U
      gsc_object.logical_object FORMAT "YES/NO":U
      gsc_object.generic_object FORMAT "YES/NO":U
      gsc_object.disabled FORMAT "YES/NO":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS MULTIPLE SIZE 155.2 BY 12.29 EXPANDABLE.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME frMain
     BrBrowse AT ROW 13 COL 1.8
     buSelectAll AT ROW 25.48 COL 1.8
     buDeselectAll AT ROW 25.48 COL 17.2
     buViewLog AT ROW 25.48 COL 111.4
     buOK AT ROW 25.48 COL 127
     buCancel AT ROW 25.48 COL 142.4
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 157.2 BY 25.71.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Container Links: Data-Target,Data-Source,Page-Target,Update-Source,Update-Target,Filter-target,Filter-Source
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wiWin ASSIGN
         HIDDEN             = YES
         TITLE              = "Attribute Value Update Utility"
         HEIGHT             = 25.71
         WIDTH              = 157.2
         MAX-HEIGHT         = 28.81
         MAX-WIDTH          = 169.2
         VIRTUAL-HEIGHT     = 28.81
         VIRTUAL-WIDTH      = 169.2
         RESIZE             = no
         SCROLL-BARS        = no
         STATUS-AREA        = no
         BGCOLOR            = ?
         FGCOLOR            = ?
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB wiWin 
/* ************************* Included-Libraries *********************** */

{src/adm2/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wiWin
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME frMain
                                                                        */
/* BROWSE-TAB BrBrowse 1 frMain */
/* SETTINGS FOR BUTTON buDeselectAll IN FRAME frMain
   NO-ENABLE                                                            */
/* SETTINGS FOR BUTTON buSelectAll IN FRAME frMain
   NO-ENABLE                                                            */
/* SETTINGS FOR BUTTON buViewLog IN FRAME frMain
   NO-ENABLE                                                            */
ASSIGN 
       buViewLog:HIDDEN IN FRAME frMain           = TRUE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wiWin)
THEN wiWin:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BrBrowse
/* Query rebuild information for BROWSE BrBrowse
     _TblList          = "ICFDB.gsc_object,ICFDB.gsc_product_module WHERE ICFDB.gsc_object ...,ICFDB.gsc_object_type WHERE ICFDB.gsc_object ...,ICFDB.ryc_smartobject WHERE ICFDB.gsc_object ..."
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _TblOptList       = ", FIRST, FIRST, FIRST"
     _Where[1]         = "(IF gdObjectType <> 0 THEN gsc_object.object_type_obj = gdObjectType ELSE TRUE)
 AND (IF gdProductModule <> 0 THEN gsc_object.product_module_obj = gdProductModule ELSE TRUE)
 AND gsc_object.object_filename BEGINS gcObjectFileName"
     _JoinCode[2]      = "gsc_product_module.product_module_obj = gsc_object.product_module_obj"
     _JoinCode[3]      = "gsc_object_type.object_type_obj = gsc_object.object_type_obj"
     _JoinCode[4]      = "ICFDB.ryc_smartobject.object_obj = ICFDB.gsc_object.object_obj"
     _FldNameList[1]   = ICFDB.gsc_object.object_filename
     _FldNameList[2]   > ICFDB.gsc_object.object_extension
"gsc_object.object_extension" ? ? "character" ? ? ? ? ? ? no ? no no "17.4" yes no no "U" "" ""
     _FldNameList[3]   > ICFDB.gsc_object.object_path
"gsc_object.object_path" ? ? "character" ? ? ? ? ? ? no ? no no "23.2" yes no no "U" "" ""
     _FldNameList[4]   > ICFDB.gsc_object.object_description
"gsc_object.object_description" ? ? "character" ? ? ? ? ? ? no ? no no "52.4" yes no no "U" "" ""
     _FldNameList[5]   = ICFDB.gsc_object_type.object_type_code
     _FldNameList[6]   = ICFDB.gsc_product_module.product_module_code
     _FldNameList[7]   = ICFDB.gsc_object.logical_object
     _FldNameList[8]   = ICFDB.gsc_object.generic_object
     _FldNameList[9]   = ICFDB.gsc_object.disabled
     _Query            is NOT OPENED
*/  /* BROWSE BrBrowse */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wiWin
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wiWin wiWin
ON END-ERROR OF wiWin /* Attribute Value Update Utility */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wiWin wiWin
ON WINDOW-CLOSE OF wiWin /* Attribute Value Update Utility */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  IF VALID-HANDLE(ghProgressDialog) THEN
    APPLY "CLOSE":U TO ghProgressDialog.
    
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buCancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buCancel wiWin
ON CHOOSE OF buCancel IN FRAME frMain /* Cancel */
DO:
  &IF "{&PROCEDURE-TYPE}" EQ "SmartPanel" &THEN
    &IF "{&ADM-VERSION}" EQ "ADM1.1" &THEN
      RUN dispatch IN THIS-PROCEDURE ('exit').
    &ELSE
      RUN exitObject.
    &ENDIF
  &ELSE
      APPLY "CLOSE":U TO THIS-PROCEDURE.
  &ENDIF
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buDeselectAll
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buDeselectAll wiWin
ON CHOOSE OF buDeselectAll IN FRAME frMain /* Deselect All */
DO:
  SESSION:SET-WAIT-STATE("GENERAL":U).
  {&BROWSE-NAME}:DESELECT-ROWS() NO-ERROR.
  SESSION:SET-WAIT-STATE("":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buOK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buOK wiWin
ON CHOOSE OF buOK IN FRAME frMain /* OK */
DO:
  RUN startProcess.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buSelectAll
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buSelectAll wiWin
ON CHOOSE OF buSelectAll IN FRAME frMain /* Select All */
DO:
  SESSION:SET-WAIT-STATE("GENERAL":U).
  {&BROWSE-NAME}:SELECT-ALL NO-ERROR.
  SESSION:SET-WAIT-STATE("":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buViewLog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buViewLog wiWin
ON CHOOSE OF buViewLog IN FRAME frMain /* View Log */
DO:
  DEFINE VARIABLE cApplicationCommand AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iResult             AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cButton             AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hTarget             AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cLogFile            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cADODir             AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE dObjectTypeObj      AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE lOutputToScreen     AS LOGICAL    NO-UNDO.
  
  
  {get ContainerTarget hTarget}.
  IF VALID-HANDLE(hTarget) AND 
     LOOKUP("getOtherDetails":U,hTarget:INTERNAL-ENTRIES) > 0 THEN
    RUN getOtherDetails IN hTarget (OUTPUT cLogFile,
                                    OUTPUT cADODir,
                                    OUTPUT lOutputToScreen,
                                    OUTPUT dObjectTypeObj).
  IF cLogFile = "":U THEN
    RETURN NO-APPLY.
  
  cApplicationCommand = "NOTEPAD.EXE " + cLogFile.
  RUN LaunchExternalProcess IN gshSessionmanager (INPUT  cApplicationCommand,
                                                  INPUT  "":U, /* Default Directory */
                                                  INPUT  1, /* Window State - Normal */
                                                  OUTPUT iResult).
  IF iResult = 0 THEN
    RUN showMessages IN gshSessionManager (INPUT  "The Application could not be launched",    /* message to display */
                                           INPUT  "ERR":U,          /* error type */
                                           INPUT  "&OK":U,    /* button list */
                                           INPUT  "&OK":U,           /* default button */ 
                                           INPUT  "&OK":U,       /* cancel button */
                                           INPUT  "Could not view log file":U,             /* error window title */
                                           INPUT  YES,              /* display if empty */ 
                                           INPUT  ?,                /* container handle */ 
                                           OUTPUT cButton           /* button pressed */
                                          ).
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BrBrowse
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wiWin 


/* ***************************  Main Block  *************************** */

/* Include custom  Main Block code for SmartWindows. */
{src/adm2/windowmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects wiWin  _ADM-CREATE-OBJECTS
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
             INPUT  'ry/obj/rycavupdtv.w':U ,
             INPUT  FRAME frMain:HANDLE ,
             INPUT  'HideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT h_rycavupdtv ).
       RUN repositionObject IN h_rycavupdtv ( 1.19 , 1.80 ) NO-ERROR.
       /* Size in AB:  ( 11.38 , 153.80 ) */

       /* Adjust the tab order of the smart objects. */
       RUN adjustTabOrder ( h_rycavupdtv ,
             BrBrowse:HANDLE IN FRAME frMain , 'BEFORE':U ).
    END. /* Page 0 */

  END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createObjectList wiWin 
PROCEDURE createObjectList :
/*------------------------------------------------------------------------------
  Purpose:     This procedure will create a temp-table containing all the 
               smartobjects selected.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lLog            AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE iLoop           AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hTarget         AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cAttributeLabel AS CHARACTER  NO-UNDO.
  
  EMPTY TEMP-TABLE ttAttributeOptions.
  {get ContainerTarget hTarget}.
  IF VALID-HANDLE(hTarget) AND 
     LOOKUP("getAttributeOptions":U,hTarget:INTERNAL-ENTRIES) > 0 THEN DO:
    CREATE ttAttributeOptions.
    RUN getAttributeOptions IN hTarget (OUTPUT ttAttributeOptions.cAttributeLabel,
                                        OUTPUT ttAttributeOptions.cNewAttributeLabel,
                                        OUTPUT ttAttributeOptions.cAttributeValue,
                                        OUTPUT ttAttributeOptions.dObjectTypeObj,
                                        OUTPUT ttAttributeOptions.cAction,
                                        OUTPUT ttAttributeOptions.lSetInheritedNo,
                                        OUTPUT ttAttributeOptions.lOverrideValues,
                                        OUTPUT ttAttributeOptions.lGenerateADO,
                                        OUTPUT ttAttributeOptions.lCheckOutObject,
                                        OUTPUT ttAttributeOptions.lUpdateTypes,
                                        OUTPUT ttAttributeOptions.lUpdateObject,
                                        OUTPUT ttAttributeOptions.lUpdateObjectInstance).

    ASSIGN cAttributeLabel = ttAttributeOptions.cAttributeLabel.
  END.
  
  
  EMPTY TEMP-TABLE ttObjects.
  DO WITH FRAME {&FRAME-NAME}:
    IF glAllObjects THEN DO:
      GET FIRST {&BROWSE-NAME}.
      DO WHILE AVAILABLE ryc_smartobject:
        CREATE ttObjects.
        ASSIGN ttObjects.cAttributeLabel = cAttributeLabel
               ttObjects.dSmartObjectObj = ryc_smartobject.smartobject_obj
               ttObjects.cObjectFileName = ryc_smartobject.object_filename
               ttObjects.dObjectTypeObj  = ryc_smartobject.object_type_obj.
        GET NEXT {&BROWSE-NAME}.
      END.
    END.
    ELSE DO:
      DO iLoop = 1 TO {&BROWSE-NAME}:NUM-SELECTED-ROWS :
        ASSIGN lLog = {&BROWSE-NAME}:FETCH-SELECTED-ROW(iLoop).
        IF lLog = TRUE THEN DO:
          CREATE ttObjects.
          ASSIGN ttObjects.cAttributeLabel = cAttributeLabel
                 ttObjects.dSmartObjectObj = ryc_smartobject.smartobject_obj
                 ttObjects.cObjectFileName = ryc_smartobject.object_filename
                 ttObjects.dObjectTypeObj  = ryc_smartobject.object_type_obj.
        END.
      END.
    END.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI wiWin  _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Delete the WINDOW we created */
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wiWin)
  THEN DELETE WIDGET wiWin.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI wiWin  _DEFAULT-ENABLE
PROCEDURE enable_UI :
/*------------------------------------------------------------------------------
  Purpose:     ENABLE the User Interface
  Parameters:  <none>
  Notes:       Here we display/view/enable the widgets in the
               user-interface.  In addition, OPEN all queries
               associated with each FRAME and BROWSE.
               These statements here are based on the "Other 
               Settings" section of the widget Property Sheets.
------------------------------------------------------------------------------*/
  ENABLE BrBrowse buOK buCancel 
      WITH FRAME frMain IN WINDOW wiWin.
  {&OPEN-BROWSERS-IN-QUERY-frMain}
  VIEW wiWin.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE exitObject wiWin 
PROCEDURE exitObject :
/*------------------------------------------------------------------------------
  Purpose:  Window-specific override of this procedure which destroys 
            its contents and itself.
    Notes:  
------------------------------------------------------------------------------*/

  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE objectsSelected wiWin 
PROCEDURE objectsSelected :
/*------------------------------------------------------------------------------
  Purpose:     This procedure will disable or enable the browse and the select
               buttons depending on the value of All Objects.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER plAllObjects  AS LOGICAL    NO-UNDO.
  
  ASSIGN glAllObjects = plAllObjects.
  IF plAllObjects THEN DO:
    APPLY "CHOOSE":U TO buDeselectAll IN FRAME {&FRAME-NAME}.
    DISABLE {&BROWSE-NAME}
            buSelectAll
            buDeSelectAll
            WITH FRAME {&FRAME-NAME}.
  END.
  ELSE DO:
    ENABLE {&BROWSE-NAME} WITH FRAME {&FRAME-NAME}.
    IF NUM-RESULTS("{&BROWSE-NAME}":U) <> ? AND
       NUM-RESULTS("{&BROWSE-NAME}":U) > 0 THEN
      ENABLE buSelectAll
             buDeSelectAll
             WITH FRAME {&FRAME-NAME}.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE refreshQuery wiWin 
PROCEDURE refreshQuery :
/*------------------------------------------------------------------------------
  Purpose:     This procedure will refresh the query depending on the objects
               selected.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pdObjectType     AS DECIMAL    NO-UNDO.
  DEFINE INPUT  PARAMETER pdProductModule  AS DECIMAL    NO-UNDO.
  DEFINE INPUT  PARAMETER pcObjectFileName AS CHARACTER  NO-UNDO.
  
  ASSIGN gdObjectType     = pdObjectType    
         gdProductModule  = pdProductModule 
         gcObjectFileName = pcObjectFileName.

  SESSION:SET-WAIT-STATE("GENERAL":U).
  {&OPEN-QUERY-{&BROWSE-NAME}}
  SESSION:SET-WAIT-STATE("":U).
  
  IF NUM-RESULTS("{&BROWSE-NAME}":U) <> ? AND
     NUM-RESULTS("{&BROWSE-NAME}":U) > 0 THEN
    ENABLE buSelectAll
           buDeselectAll
           WITH FRAME {&FRAME-NAME}.
  ELSE
    DISABLE buSelectAll
            buDeselectAll
            WITH FRAME {&FRAME-NAME}.
   
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE startProcess wiWin 
PROCEDURE startProcess :
/*------------------------------------------------------------------------------
  Purpose:     This procedure will create the temp-tables and start the actual
               process.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hContainer      AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lError          AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lContinue       AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE hTarget         AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cError          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cLogFile        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cADODir         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE dObjectTypeObj  AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE cButton         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lOutputToScreen AS LOGICAL    NO-UNDO.
  
  
  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN buViewLog:HIDDEN    = TRUE
           buViewLog:SENSITIVE = FALSE.
  END.
  
  /* Although there is validation in the actual processing 
     we will do some on-screen validation first */
  {get ContainerTarget hContainer}.
  lError = NO.
  IF VALID-HANDLE(hContainer) AND
     LOOKUP("validateData":U,hContainer:INTERNAL-ENTRIES) > 0 THEN
    RUN validateData IN hContainer (OUTPUT lError).
  
  IF lError THEN
    RETURN.
  MESSAGE "Are you sure you want to continue with this process?"
          VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE lContinue.
  
  IF NOT lContinue THEN
    RETURN.
    
  RUN createObjectList.
  
  {get ContainerTarget hTarget}.
  IF VALID-HANDLE(hTarget) AND 
     LOOKUP("getOtherDetails":U,hTarget:INTERNAL-ENTRIES) > 0 THEN
    RUN getOtherDetails IN hTarget (OUTPUT cLogFile,
                                    OUTPUT cADODir,
                                    OUTPUT lOutputToScreen,
                                    OUTPUT dObjectTypeObj).

  SESSION:SET-WAIT-STATE("GENERAL":U).
  RUN ry/prc/rycavupdtp.p (INPUT  cLogFile,
                           INPUT  cADODir,
                           INPUT  FALSE, /* APPEND FILE */
                           INPUT  (IF lOutputToScreen THEN THIS-PROCEDURE ELSE ?),
                           INPUT TABLE ttAttributeOptions,
                           INPUT TABLE ttObjects,
                           OUTPUT cError).
  SESSION:SET-WAIT-STATE("":U).
  
  IF cError <> "":U THEN DO:
    RUN showMessages IN gshSessionManager (INPUT  cError,    /* message to display */
                                           INPUT  "ERR":U,          /* error type */
                                           INPUT  "&OK,&Cancel":U,    /* button list */
                                           INPUT  "&OK":U,           /* default button */ 
                                           INPUT  "&Cancel":U,       /* cancel button */
                                           INPUT  "Error":U,             /* error window title */
                                           INPUT  YES,              /* display if empty */ 
                                           INPUT  ?,                /* container handle */ 
                                           OUTPUT cButton           /* button pressed */
                                          ).
    
    RETURN.
  END.
  ELSE DO WITH FRAME {&FRAME-NAME}:
    RUN showMessages IN gshSessionManager (INPUT  "The update of the Attribute Values completed successfully. ",    /* message to display */
                                           INPUT  "INF":U,          /* error type */
                                           INPUT  "&OK":U,    /* button list */
                                           INPUT  "&OK":U,           /* default button */ 
                                           INPUT  "&OK":U,       /* cancel button */
                                           INPUT  "Completed Successfully":U,             /* error window title */
                                           INPUT  YES,              /* display if empty */ 
                                           INPUT  ?,                /* container handle */ 
                                           OUTPUT cButton           /* button pressed */
                                          ).
    
    ASSIGN buViewLog:HIDDEN    = FALSE
           buViewLog:SENSITIVE = TRUE.
    APPLY "ENTRY":U TO buViewLog.
  END.
    
  
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE viewMessage wiWin 
PROCEDURE viewMessage :
/*------------------------------------------------------------------------------
  Purpose:     This procedure receives a string message from the update procedure
               and this can then be displayed on screen.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcMessage AS CHARACTER  NO-UNDO.
  
  IF NOT VALID-HANDLE(ghProgressDialog) THEN
    RUN ry/uib/rycavupdtd.w PERSISTEN SET ghProgressDialog.
  IF VALID-HANDLE(ghProgressDialog) THEN DO:
    RUN viewMessage IN ghProgressDialog (pcMessage).
    PROCESS EVENTS.
  END.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

