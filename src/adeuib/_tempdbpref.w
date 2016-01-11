&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI ADM2
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME diDialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS diDialog 
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
  File:         adeuib/_tempdbpref.w

  Description:  Preference dialog for TEMP-db maintenance tool. Called 
                from _tempdb.w 

  Parameters:   OUTPUT  plOK  YES - OK was selected.

  Author:      Don Bulua
  Created:     05/04/2001

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
/* Parameters Definitions ---                                           */
&IF DEFINED(UIB_is_Running) = 0 &THEN
DEFINE OUTPUT PARAMETER plOK            AS LOGICAL   NO-UNDO .
    /* YES - User choose OK. NO - User choose Cancel.       */
&ELSE
DEFINE VAR plOK            AS LOGICAL   NO-UNDO .
&ENDIF

/* Local Variable Definitions ---                                       */

DEFINE VARIABLE glDynamicsRunning AS LOGICAL    NO-UNDO.

{ adeuib/uibhlp.i }          /* Help File Preprocessor Directives       */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDialog
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER DIALOG-BOX

&Scoped-define ADM-SUPPORTED-LINKS Data-Target,Data-Source,Page-Target,Update-Source,Update-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME diDialog

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS buOk buCancel BtnHelp 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_folder AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BtnHelp 
     LABEL "&Help" 
     SIZE 15 BY 1.14.

DEFINE BUTTON buCancel AUTO-END-KEY 
     LABEL "Cancel" 
     SIZE 15 BY 1.14.

DEFINE BUTTON buOk AUTO-GO 
     LABEL "OK" 
     SIZE 15 BY 1.14.

DEFINE BUTTON btn 
     IMAGE-UP FILE "adeicon/open.bmp":U
     LABEL "Button" 
     CONTEXT-HELP-ID 0
     SIZE 5 BY 1.14.

DEFINE VARIABLE fiExt AS CHARACTER FORMAT "X(50)":U 
     LABEL "Having extension" 
     CONTEXT-HELP-ID 0
     VIEW-AS FILL-IN 
     SIZE 11 BY 1 NO-UNDO.

DEFINE VARIABLE fiLog AS CHARACTER FORMAT "X(100)":U 
     CONTEXT-HELP-ID 0
     VIEW-AS FILL-IN 
     SIZE 54 BY 1 NO-UNDO.

DEFINE VARIABLE raInclude AS LOGICAL 
     CONTEXT-HELP-ID 0
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Use Include file reference", yes,
"Use DEFINE TEMP-TABLE LIKE ", no
     SIZE 48 BY 2.14 NO-UNDO.

DEFINE RECTANGLE RECT-10
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 3.8 BY .1.

DEFINE RECTANGLE RECT-11
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 40 BY .1.

DEFINE RECTANGLE RECT-12
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 3.8 BY .1.

DEFINE RECTANGLE RECT-7
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 38 BY .1.

DEFINE RECTANGLE RECT-8
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 3.8 BY .1.

DEFINE RECTANGLE RECT-9
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 44 BY .1.

DEFINE VARIABLE toADE AS LOGICAL INITIAL no 
     LABEL "Update TEMP-DB when saving files in ADE Tools" 
     CONTEXT-HELP-ID 0
     VIEW-AS TOGGLE-BOX
     SIZE 52 BY .81 NO-UNDO.

DEFINE VARIABLE toAppend AS LOGICAL INITIAL no 
     LABEL "Append to file" 
     CONTEXT-HELP-ID 0
     VIEW-AS TOGGLE-BOX
     SIZE 18 BY .81 NO-UNDO.

DEFINE VARIABLE tolog AS LOGICAL INITIAL no 
     LABEL "Write to log file" 
     CONTEXT-HELP-ID 0
     VIEW-AS TOGGLE-BOX
     SIZE 21.2 BY .81 NO-UNDO.

DEFINE VARIABLE coDFType AS CHARACTER FORMAT "X(90)":U 
     LABEL "Object Type" 
     CONTEXT-HELP-ID 0
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Item 1" 
     DROP-DOWN-LIST
     SIZE 44.8 BY 1 TOOLTIP "The class to which the DataField Objects belong." NO-UNDO.

DEFINE VARIABLE coEntityType AS CHARACTER FORMAT "X(90)":U 
     LABEL "ObjectType" 
     CONTEXT-HELP-ID 0
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Item 1" 
     DROP-DOWN-LIST
     SIZE 44.8 BY 1 TOOLTIP "The class to which the Entity Objects belong." NO-UNDO.

DEFINE VARIABLE coModule AS CHARACTER FORMAT "X(90)":U 
     LABEL "Product Module" 
     CONTEXT-HELP-ID 0
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEM-PAIRS "Item 1","Item 1"
     DROP-DOWN-LIST
     SIZE 44.8 BY 1 TOOLTIP "The product module in which the Entity objects will be created." NO-UNDO.

DEFINE VARIABLE coModuleDF AS CHARACTER FORMAT "X(90)":U 
     LABEL "Product Module" 
     CONTEXT-HELP-ID 0
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEM-PAIRS "Item 1","Item 1"
     DROP-DOWN-LIST
     SIZE 44.8 BY 1 TOOLTIP "he product module in which the DataFields will be created." NO-UNDO.

DEFINE VARIABLE fiPrefix AS INTEGER FORMAT ">9":U INITIAL 0 
     LABEL "Prefix Length" 
     CONTEXT-HELP-ID 0
     VIEW-AS FILL-IN 
     SIZE 7 BY 1 TOOLTIP "Table prefix length or 0 for none" NO-UNDO.

DEFINE VARIABLE fiSep AS CHARACTER FORMAT "X(50)":U 
     LABEL "Separator" 
     CONTEXT-HELP-ID 0
     VIEW-AS FILL-IN 
     SIZE 7 BY 1 TOOLTIP "Word separation character for field names" NO-UNDO.

DEFINE VARIABLE raImportPrompt AS LOGICAL 
     CONTEXT-HELP-ID 0
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Prompt user when saving file", yes,
"Do not prompt and use entity defaults below", no
     SIZE 47 BY 1.67 NO-UNDO.

DEFINE RECTANGLE RECT-13
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 64 BY 4.1.

DEFINE RECTANGLE RECT-14
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 40 BY .1.

DEFINE RECTANGLE RECT-15
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 3.8 BY .1.

DEFINE RECTANGLE RECT-16
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 53 BY .1.

DEFINE RECTANGLE RECT-17
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 3.8 BY .1.

DEFINE VARIABLE toassociate AS LOGICAL INITIAL no 
     LABEL "Associate datafields with entities" 
     CONTEXT-HELP-ID 0
     VIEW-AS TOGGLE-BOX
     SIZE 40 BY .81 NO-UNDO.

DEFINE VARIABLE toEntityImport AS LOGICAL INITIAL no 
     LABEL "Perform entity import when saving file" 
     CONTEXT-HELP-ID 0
     VIEW-AS TOGGLE-BOX
     SIZE 40 BY .81 NO-UNDO.

DEFINE VARIABLE togenerateDF AS LOGICAL INITIAL no 
     LABEL "Generate Datafields" 
     CONTEXT-HELP-ID 0
     VIEW-AS TOGGLE-BOX
     SIZE 24 BY .81 TOOLTIP "Update lists of fields for entities to display in generic objects" NO-UNDO.

DEFINE VARIABLE toOverwrite AS LOGICAL INITIAL no 
     LABEL "Overwrite all attributes from schema" 
     CONTEXT-HELP-ID 0
     VIEW-AS TOGGLE-BOX
     SIZE 38 BY .81 TOOLTIP "Override all local attributes such as Format, Label and Help with schema values" NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME diDialog
     buOk AT ROW 17.67 COL 17
     buCancel AT ROW 17.67 COL 34
     BtnHelp AT ROW 17.67 COL 55
     SPACE(0.99) SKIP(0.04)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         TITLE "TEMP-DB Maintenance Preferences"
         DEFAULT-BUTTON buOk CANCEL-BUTTON buCancel.

DEFINE FRAME FRAME-2
     toEntityImport AT ROW 2.24 COL 4
     raImportPrompt AT ROW 3.19 COL 9 NO-LABEL
     fiSep AT ROW 6.43 COL 18 COLON-ALIGNED
     fiPrefix AT ROW 6.43 COL 55.4 COLON-ALIGNED
     coModule AT ROW 7.48 COL 18.2 COLON-ALIGNED
     coEntityType AT ROW 8.62 COL 18.2 COLON-ALIGNED
     togenerateDF AT ROW 9.91 COL 4
     coModuleDF AT ROW 10.95 COL 18.2 COLON-ALIGNED
     coDFType AT ROW 12.1 COL 18.2 COLON-ALIGNED
     toOverwrite AT ROW 13.29 COL 20.2
     toassociate AT ROW 14.62 COL 4
     "Entity Import Defaults" VIEW-AS TEXT
          SIZE 21 BY .62 AT ROW 5.52 COL 5.2
     "General" VIEW-AS TEXT
          SIZE 8 BY .95 AT ROW 1.14 COL 5.2
     RECT-13 AT ROW 10.24 COL 2
     RECT-14 AT ROW 5.81 COL 26
     RECT-15 AT ROW 5.81 COL 1
     RECT-16 AT ROW 1.57 COL 13
     RECT-17 AT ROW 1.57 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3 ROW 2.52
         SIZE 66 BY 14.67.

DEFINE FRAME FRAME-1
     toADE AT ROW 2.67 COL 4
     fiExt AT ROW 3.52 COL 23.2 COLON-ALIGNED
     tolog AT ROW 6.81 COL 4
     btn AT ROW 7.71 COL 61
     fiLog AT ROW 7.76 COL 5 COLON-ALIGNED NO-LABEL
     toAppend AT ROW 8.95 COL 43.4
     raInclude AT ROW 11.38 COL 4 NO-LABEL
     "Log File Default" VIEW-AS TEXT
          SIZE 16.2 BY .62 AT ROW 5.76 COL 6
     "ADE Tools Integration" VIEW-AS TEXT
          SIZE 22 BY .95 AT ROW 1.52 COL 6
     "Use Include Default" VIEW-AS TEXT
          SIZE 20 BY .62 AT ROW 10.48 COL 6
     RECT-7 AT ROW 1.95 COL 28
     RECT-8 AT ROW 1.95 COL 1
     RECT-9 AT ROW 6.05 COL 22
     RECT-10 AT ROW 6.05 COL 1
     RECT-11 AT ROW 10.71 COL 26
     RECT-12 AT ROW 10.71 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3 ROW 2.91
         SIZE 66 BY 13.81.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDialog
   Allow: Basic,Browse,DB-Fields,Query,Smart
   Container Links: Data-Target,Data-Source,Page-Target,Update-Source,Update-Target
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB diDialog 
/* ************************* Included-Libraries *********************** */

{src/adm2/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* REPARENT FRAME */
ASSIGN FRAME FRAME-1:FRAME = FRAME diDialog:HANDLE
       FRAME FRAME-2:FRAME = FRAME diDialog:HANDLE.

/* SETTINGS FOR DIALOG-BOX diDialog
                                                                        */
ASSIGN 
       FRAME diDialog:SCROLLABLE       = FALSE
       FRAME diDialog:HIDDEN           = TRUE.

/* SETTINGS FOR FRAME FRAME-1
                                                                        */
/* SETTINGS FOR FRAME FRAME-2
                                                                        */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX diDialog
/* Query rebuild information for DIALOG-BOX diDialog
     _Options          = "SHARE-LOCK"
     _Query            is NOT OPENED
*/  /* DIALOG-BOX diDialog */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME FRAME-1
/* Query rebuild information for FRAME FRAME-1
     _Query            is NOT OPENED
*/  /* FRAME FRAME-1 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME FRAME-2
/* Query rebuild information for FRAME FRAME-2
     _Query            is NOT OPENED
*/  /* FRAME FRAME-2 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME diDialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL diDialog diDialog
ON HELP OF FRAME diDialog /* TEMP-DB Maintenance Preferences */
ANYWHERE DO:
   RUN RunHelp IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL diDialog diDialog
ON WINDOW-CLOSE OF FRAME diDialog /* TEMP-DB Maintenance Preferences */
DO:  
  /* Add Trigger to equate WINDOW-CLOSE to END-ERROR. */
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME FRAME-1
&Scoped-define SELF-NAME btn
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btn diDialog
ON CHOOSE OF btn IN FRAME FRAME-1 /* Button */
DO:
  DEFINE VARIABLE cFile AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lOK   AS LOGICAL    NO-UNDO.

  ASSIGN cFile = fiLog:SCREEN-VALUE.

  SYSTEM-DIALOG GET-FILE cFile
    TITLE "Choose Log File" 
    FILTERS "Text File(*.txt)" "*.txt":U, "All FIles(*.*)" "*.*"
    INITIAL-DIR "."
    UPDATE lOk IN WINDOW {&WINDOW-NAME}.
  
  IF lOk THEN 
      fiLog:SCREEN-VALUE = cfile.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME diDialog
&Scoped-define SELF-NAME BtnHelp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BtnHelp diDialog
ON CHOOSE OF BtnHelp IN FRAME diDialog /* Help */
DO:
  RUN RunHelp IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buOk
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buOk diDialog
ON CHOOSE OF buOk IN FRAME diDialog /* OK */
DO:
  RUN SetPreference IN THIS-PROCEDURE.
  ASSIGN plOK = YES.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME FRAME-1
&Scoped-define SELF-NAME toADE
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL toADE diDialog
ON VALUE-CHANGED OF toADE IN FRAME FRAME-1 /* Update TEMP-DB when saving files in ADE Tools */
DO:
  IF SELF:CHECKED THEN
    ASSIGN fiExt:SENSITIVE                           = TRUE.
  ELSE 
    ASSIGN fiExt:SENSITIVE                           = FALSE.
               
  RUN ValueChangedEntityImport.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME FRAME-2
&Scoped-define SELF-NAME toEntityImport
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL toEntityImport diDialog
ON VALUE-CHANGED OF toEntityImport IN FRAME FRAME-2 /* Perform entity import when saving file */
DO:
  IF SELF:CHECKED AND SELF:SENSITIVE = TRUE THEN
      ASSIGN raImportPrompt:SENSITIVE = TRUE.
  ELSE
      ASSIGN raImportPrompt:SENSITIVE = FALSE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME togenerateDF
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL togenerateDF diDialog
ON VALUE-CHANGED OF togenerateDF IN FRAME FRAME-2 /* Generate Datafields */
DO:
   RUN ValueChangeGenerateDF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME FRAME-1
&Scoped-define SELF-NAME tolog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tolog diDialog
ON VALUE-CHANGED OF tolog IN FRAME FRAME-1 /* Write to log file */
DO:
  IF SELF:CHECKED THEN
     ASSIGN toAppend:SENSITIVE = TRUE
            fiLog:SENSITIVE    = TRUE.
  ELSE
      ASSIGN toAppend:SENSITIVE = FALSE
            fiLog:SENSITIVE    = FALSE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME diDialog
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK diDialog 


/* ***************************  Main Block  *************************** */

{src/adm2/dialogmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects diDialog  _ADM-CREATE-OBJECTS
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
             INPUT  'adm2/folder.w':U ,
             INPUT  FRAME diDialog:HANDLE ,
             INPUT  'FolderLabels':U + 'General|Entity Import' + 'FolderTabWidth0FolderFont-1HideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT h_folder ).
       RUN repositionObject IN h_folder ( 1.24 , 2.00 ) NO-ERROR.
       RUN resizeObject IN h_folder ( 16.19 , 68.00 ) NO-ERROR.

       /* Links to SmartFolder h_folder. */
       RUN addLink ( h_folder , 'Page':U , THIS-PROCEDURE ).

       /* Adjust the tab order of the smart objects. */
       RUN adjustTabOrder ( h_folder ,
             FRAME FRAME-2:HANDLE , 'BEFORE':U ).
    END. /* Page 0 */

  END CASE.
  /* Select a Startup page. */
  IF currentPage eq 0
  THEN RUN selectPage IN THIS-PROCEDURE ( 1 ).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI diDialog  _DEFAULT-DISABLE
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
  HIDE FRAME diDialog.
  HIDE FRAME FRAME-1.
  HIDE FRAME FRAME-2.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI diDialog  _DEFAULT-ENABLE
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
  ENABLE buOk buCancel BtnHelp 
      WITH FRAME diDialog.
  VIEW FRAME diDialog.
  {&OPEN-BROWSERS-IN-QUERY-diDialog}
  DISPLAY toEntityImport raImportPrompt fiSep fiPrefix coModule coEntityType 
          togenerateDF coModuleDF coDFType toOverwrite toassociate 
      WITH FRAME FRAME-2.
  ENABLE RECT-13 RECT-14 RECT-15 RECT-16 RECT-17 toEntityImport raImportPrompt 
         fiSep fiPrefix coModule coEntityType togenerateDF coModuleDF coDFType 
         toOverwrite toassociate 
      WITH FRAME FRAME-2.
  {&OPEN-BROWSERS-IN-QUERY-FRAME-2}
  DISPLAY toADE fiExt tolog fiLog toAppend raInclude 
      WITH FRAME FRAME-1.
  ENABLE RECT-7 RECT-8 RECT-9 RECT-10 RECT-11 RECT-12 toADE fiExt tolog btn 
         fiLog toAppend raInclude 
      WITH FRAME FRAME-1.
  {&OPEN-BROWSERS-IN-QUERY-FRAME-1}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getPreference diDialog 
PROCEDURE getPreference :
/*------------------------------------------------------------------------------
  Purpose:     Get the Preferences stored in the registry and set the
               values.
               
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 DEFINE VARIABLE cSection AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cValue AS CHARACTER  NO-UNDO.

 ASSIGN cSection = "ProAB":U.

 GET-KEY-VALUE SECTION  cSection KEY "TempDBIntegration":U VALUE cValue.
 toADE = IF cValue EQ ? THEN FALSE
         ELSE CAN-DO ("true,yes,on",cValue).

 GET-KEY-VALUE SECTION  cSection KEY "TempDBExtension":U VALUE cValue.
 fiExt = IF cValue = ? THEN "*.i"  ELSE cValue.

 GET-KEY-VALUE SECTION  cSection KEY "TempDBUseLogFile":U VALUE cValue.
 toLog = IF cValue EQ ? THEN TRUE
         ELSE CAN-DO ("true,yes,on",cValue).

 GET-KEY-VALUE SECTION  cSection KEY "TempDBLogFile":U VALUE cValue.
  IF cValue = ? THEN 
      ASSIGN FILE-INFO:FILE-NAME = "."
             fiLog = FILE-INFO:FULL-PATHNAME  + "\" + "Temp-dbLog.txt":U .
  ELSE fiLog = cValue.

 GET-KEY-VALUE SECTION  cSection KEY "TempDBLogFileAppend":U VALUE cValue.
 toAppend = IF cValue EQ ? THEN TRUE
            ELSE CAN-DO ("true,yes,on",cValue).

 GET-KEY-VALUE SECTION  cSection KEY "TempDBUseInclude":U VALUE cValue.
 raInclude = IF cValue EQ ? THEN TRUE
             ELSE CAN-DO ("true,yes,on",cValue).

IF glDynamicsRunning THEN
DO:
   GET-KEY-VALUE SECTION  cSection KEY "TempDBEntityImport":U VALUE cValue.
   toEntityImport = IF cValue EQ ? THEN FALSE
                    ELSE CAN-DO ("true,yes,on",cValue).
   
   GET-KEY-VALUE SECTION  cSection KEY "TempDBEntityPrompt":U VALUE cValue.
   raImportPrompt = IF cValue EQ ? THEN TRUE
                    ELSE CAN-DO ("true,yes,on",cValue).

   GET-KEY-VALUE SECTION  cSection KEY "TempDBEntitySeparator":U VALUE cValue.
   fiSep          = IF cValue EQ ? THEN ""
                    ELSE cValue.

   GET-KEY-VALUE SECTION  cSection KEY "TempDBEntityPrefix":U VALUE cValue.
   fiPrefix       = IF cValue EQ ? THEN 0
                    ELSE INT(cValue).

   GET-KEY-VALUE SECTION  cSection KEY "TempDBEntityModule":U VALUE cValue.
   coModule       = IF cValue EQ ? AND NUM-ENTRIES(coModule:LIST-ITEM-PAIRS IN FRAME FRAME-2, CHR(3)) GE 2 
                    THEN ENTRY(2,coModule:LIST-ITEM-PAIRS,CHR(3))
                    ELSE cValue. 

   GET-KEY-VALUE SECTION  cSection KEY "TempDBEntityType":U VALUE cValue.
   coEntityType   = IF cValue EQ ? 
                    THEN ENTRY(1,coEntityType:LIST-ITEMS)
                    ELSE cValue. 

   GET-KEY-VALUE SECTION  cSection KEY "TempDBGenerateDF":U VALUE cValue.
   togenerateDF   = IF cValue EQ ? THEN TRUE
                    ELSE CAN-DO ("true,yes,on",cValue).

   GET-KEY-VALUE SECTION  cSection KEY "TempDBDFModule":U VALUE cValue.
   coModuleDF     = IF cValue EQ ? AND NUM-ENTRIES(coModuleDF:LIST-ITEM-PAIRS IN FRAME FRAME-2, CHR(3)) GE 2 
                    THEN ENTRY(2,coModuleDF:LIST-ITEM-PAIRS,CHR(3))
                    ELSE cValue. 
   
   GET-KEY-VALUE SECTION  cSection KEY "TempDBDFType":U VALUE cValue.
   coDFType       = IF cValue EQ ? 
                    THEN ENTRY(1,coDFType:LIST-ITEMS)
                    ELSE cValue. 

   GET-KEY-VALUE SECTION  cSection KEY "TempDBOverwriteAttr":U VALUE cValue.
   toOverwrite    = IF cValue EQ ? THEN TRUE
                    ELSE CAN-DO ("true,yes,on",cValue).

   GET-KEY-VALUE SECTION  cSection KEY "TempDBAssociateDF":U VALUE cValue.
   toassociate    = IF cValue EQ ? THEN TRUE
                    ELSE CAN-DO ("true,yes,on",cValue).
END.











END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initdynamics diDialog 
PROCEDURE initdynamics :
/*------------------------------------------------------------------------------
  Purpose:     Populates Entity Import specific information
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE hRDM           AS HANDLE     NO-UNDO.
DEFINE VARIABLE cObjectList    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cDataFieldList AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cDFListNoCalc  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cEntityList    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cCalcFieldList AS CHARACTER  NO-UNDO.
DEFINE VARIABLE i              AS INTEGER    NO-UNDO.

ASSIGN hRDM = DYNAMIC-FUNCTION("getManagerHandle":U IN THIS-PROCEDURE, INPUT "RepositoryDesignManager":U) NO-ERROR.
IF VALID-HANDLE(hRDM) THEN
   ASSIGN
     coModule:DELIMITER IN FRAME Frame-2    = CHR(3)
     coModuleDF:DELIMITER IN FRAME Frame-2  = CHR(3)
     coModule:LIST-ITEM-PAIRS = DYNAMIC-FUNCTION("getProductModuleList":U IN hRdm,
                                                     INPUT "product_module_Code":U,
                                                     INPUT "product_module_code,product_module_description":U,
                                                     INPUT "&1 // &2":U,
                                                     INPUT CHR(3)) 
    coModuleDF:LIST-ITEM-PAIRS = coModule:LIST-ITEM-PAIRS
    .
/* Get the object type */
ASSIGN cObjectList     = DYNAMIC-FUNCTION("getClassChildrenFromDB":U IN gshRepositoryManager, "DataField,Entity":U)
       cDataFieldList  = ENTRY(1, cObjectList, CHR(3))
       cEntityList     = ENTRY(2, cObjectList, CHR(3))
       cCalcFieldList  = DYNAMIC-FUNCTION("getClassChildrenFromDB":U IN gshRepositoryManager, "CalculatedField":U)
       NO-ERROR.

/* Calculated fields should not be included in the list of object types for import.   */
DO i = 1 TO NUM-ENTRIES(cDataFieldList):
   IF LOOKUP(ENTRY(i,cDataFieldList),cCalcFieldList) > 0 THEN
        NEXT.
   cDFListNoCalc = cDFListNoCalc + (IF cDFListNoCalc  = "" THEN "" ELSE ",") + ENTRY(i,cDataFieldList).
END.
 
ASSIGN coEntityType:LIST-ITEMS = cEntityList
       coDFType:LIST-ITEMS     = cDFListNoCalc
       NO-ERROR.

        

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject diDialog 
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hContainer AS HANDLE     NO-UNDO.

  ASSIGN glDynamicsRunning = DYNAMIC-FUNCTION("IsICFRunning":U) NO-ERROR.
  IF glDynamicsRunning = ? THEN glDynamicsRunning = NO.

  IF NOT glDynamicsRunning THEN
      RUN deleteFolderPage IN h_folder (2).
  ELSE
      RUN initDynamics IN THIS-PROCEDURE.

  RUN getPreference IN THIS-PROCEDURE.

  RUN SUPER.

  IF VALID-HANDLE(h_folder) THEN
  DO:
    {get ContainerHandle hContainer h_folder}.
    ON HELP OF hContainer PERSISTENT RUN RunHelp.
  END.

  APPLY "VALUE-CHANGED":U TO toADE IN FRAME FRAME-1.
  APPLY "VALUE-CHANGED":U TO toLog IN FRAME FRAME-1.
  
  IF glDynamicsRunning THEN
     RUN ValueChangeGenerateDF IN THIS-PROCEDURE. 
      

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE RunHelp diDialog 
PROCEDURE RunHelp :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 IF glDynamicsRunning THEN
    RUN adecomm/_adehelp.p ("AB":U,"CONTEXT":U,{&TEMP_DB_Preferences_Dlg_Dyn},?).
 ELSE
    RUN adecomm/_adehelp.p ("AB":U,"CONTEXT":U,{&TEMP_DB_Preferences_Dlg},?).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE selectPage diDialog 
PROCEDURE selectPage :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER piPageNum AS INTEGER NO-UNDO.

  /* Code placed here will execute PRIOR to standard behavior. */

  RUN SUPER( INPUT piPageNum).

  IF piPageNum = 1 THEN
  DO:
     ASSIGN FRAME FRAME-1:HIDDEN = FALSE
            FRAME FRAME-2:HIDDEN = TRUE    .
  END.
  ELSE IF piPageNum = 2 THEN
  DO:
    ASSIGN FRAME frame-1:HIDDEN = TRUE
           FRAME FRAME-2:HIDDEN = FALSE.
    FRAME frame-2:MOVE-TO-TOP().
    FRAME frame-1:MOVE-TO-BOTTOM().
  END.
  
  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setPreference diDialog 
PROCEDURE setPreference :
/*------------------------------------------------------------------------------
  Purpose:     Sets the preferences
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE cSection AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cValue AS CHARACTER  NO-UNDO.

ASSIGN cSection = "ProAB":U.

PUT-KEY-VALUE SECTION  cSection KEY "TempDBIntegration" VALUE STRING(toADE:CHECKED IN FRAME FRAME-1).

PUT-KEY-VALUE SECTION  cSection KEY "TempDBExtension" VALUE fiExt:SCREEN-VALUE.

PUT-KEY-VALUE SECTION  cSection KEY "TempDBUseLogFile" VALUE STRING(toLog:CHECKED).

PUT-KEY-VALUE SECTION  cSection KEY "TempDBLogFile" VALUE fiLog:SCREEN-VALUE.
 
PUT-KEY-VALUE SECTION  cSection KEY "TempDBLogFileAppend" VALUE STRING(toAppend:CHECKED).

PUT-KEY-VALUE SECTION  cSection KEY "TempDBUseInclude" VALUE raInclude:SCREEN-VALUE.

IF glDynamicsRunning THEN
DO:
   PUT-KEY-VALUE SECTION  cSection KEY "TempDBEntityImport":U VALUE STRING(toEntityImport:CHECKED IN FRAME FRAME-2).
   
   PUT-KEY-VALUE SECTION  cSection KEY "TempDBEntityPrompt":U VALUE STRING(raImportPrompt:SCREEN-VALUE IN FRAME FRAME-2).
   
   PUT-KEY-VALUE SECTION  cSection KEY "TempDBEntitySeparator":U VALUE fiSep:SCREEN-VALUE.
   
   PUT-KEY-VALUE SECTION  cSection KEY "TempDBEntityPrefix":U VALUE fiPrefix:SCREEN-VALUE.
   
   PUT-KEY-VALUE SECTION  cSection KEY "TempDBEntityModule":U VALUE coModule:SCREEN-VALUE.

   PUT-KEY-VALUE SECTION  cSection KEY "TempDBEntityType":U VALUE coEntityType:SCREEN-VALUE.
   
   PUT-KEY-VALUE SECTION  cSection KEY "TempDBGenerateDF":U VALUE STRING(togenerateDF:CHECKED).
   
   PUT-KEY-VALUE SECTION  cSection KEY "TempDBDFModule":U VALUE coModuleDF:SCREEN-VALUE.
   
   PUT-KEY-VALUE SECTION  cSection KEY "TempDBDFType":U VALUE coDFType:SCREEN-VALUE.
   
   PUT-KEY-VALUE SECTION  cSection KEY "TempDBOverwriteAttr":U VALUE STRING(toOverwrite:CHECKED).
   
   PUT-KEY-VALUE SECTION  cSection KEY "TempDBAssociateDF":U VALUE STRING(toassociate:CHECKED).
   
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE valueChangedEntityImport diDialog 
PROCEDURE valueChangedEntityImport :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
IF toEntityImport:CHECKED IN FRAME FRAME-2 AND toEntityImport:SENSITIVE = TRUE THEN
      ASSIGN raImportPrompt:SENSITIVE = TRUE.
  ELSE
      ASSIGN raImportPrompt:SENSITIVE = FALSE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE valueChangeGenerateDF diDialog 
PROCEDURE valueChangeGenerateDF :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
ASSIGN coModuleDF:SENSITIVE IN FRAME FRAME-2 = toGenerateDF:CHECKED
       coDFType:SENSITIVE   = toGenerateDF:CHECKED
       toAssociate:CHECKED  = toGenerateDF:CHECKED   WHEN NOT toAssociate:CHECKED
       toAssociate:SENSITIVE = NOT toGenerateDF:CHECKED
       toOverwrite:SENSITIVE =  toGenerateDF:CHECKED.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

