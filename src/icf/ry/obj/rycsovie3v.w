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
       {"ry/obj/rycsofullo.i"}.


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
  File: rycsoviewv.w

  Description:  Smart Object Viewer 1

  Purpose:      Smart Object Viewer 1

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:        6962   UserRef:    
                Date:   16/01/2001  Author:     Jenny Bond

  Update Notes: Initial coding

  (v:010001)    Task:        7748   UserRef:    
                Date:   30/01/2001  Author:     Jenny Bond

  Update Notes: Complete Smart Object Maintenance

--------------------------------------------------------------------------------*/
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

&scop object-name       rycsovie3v.w
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/* Astra 2 object identifying preprocessor */
&glob   astra2-staticSmartDataViewer yes

&SCOPED-DEFINE num-tables 2
{af/sup2/afglobals.i}

&SCOPED-DEFINE ttName ttGscObject
{ry/inc/gscobttdef.i}
&UNDEFINE ttName
&SCOPED-DEFINE ttName ttRycAttributeValue
{ry/inc/rycavttdef.i}
&UNDEFINE ttName
&SCOPED-DEFINE ttName ttRycObjectInstance
{ry/inc/rycoittdef.i}
&UNDEFINE ttName
&SCOPED-DEFINE ttName ttRycPage
{ry/inc/rycpattdef.i}
&UNDEFINE ttName
&SCOPED-DEFINE ttName ttRycSmartlink
{ry/inc/rycsmttdef.i}
&UNDEFINE ttName

DEFINE VARIABLE gcUIBMode   AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cRunWhen    AS CHARACTER    NO-UNDO INITIAL "Anytime,ANY,When no other running,NOR,With only one instance,ONE":U.
DEFINE VARIABLE dObject     AS DECIMAL      NO-UNDO INITIAL 0.

DEFINE VARIABLE ghBrowse    AS HANDLE       NO-UNDO.
DEFINE VARIABLE ghQuery     AS HANDLE       NO-UNDO.
DEFINE VARIABLE ghBuffer    AS HANDLE       NO-UNDO.
DEFINE VARIABLE giNumRecs   AS INTEGER      NO-UNDO.

{af/sup2/afttcombo.i}

DEFINE VARIABLE gcDataString        AS CHARACTER    NO-UNDO.
DEFINE VARIABLE ghAttributeGroup    AS HANDLE       NO-UNDO.
DEFINE VARIABLE ghAttribute         AS HANDLE       NO-UNDO.
DEFINE VARIABLE ghAttributeValue    AS HANDLE       NO-UNDO.
DEFINE VARIABLE ghConstantValue     AS HANDLE       NO-UNDO.
DEFINE VARIABLE ghInheritedValue    AS HANDLE       NO-UNDO.
DEFINE VARIABLE gcAttributeAction   AS CHARACTER    NO-UNDO.
DEFINE VARIABLE gdMaxAttributeGroup AS DECIMAL      NO-UNDO.
DEFINE VARIABLE ghGroupAssign       AS HANDLE       NO-UNDO.
DEFINE VARIABLE ghRycoiTT           AS HANDLE       NO-UNDO.
DEFINE VARIABLE ghRycavTT           AS HANDLE       NO-UNDO.
DEFINE VARIABLE ghRycsmTT           AS HANDLE       NO-UNDO.
DEFINE VARIABLE ghRycpaTT           AS HANDLE       NO-UNDO.
DEFINE VARIABLE gcContainerMode     AS CHARACTER    NO-UNDO.
DEFINE VARIABLE gdObjectObj         AS DECIMAL      NO-UNDO.
DEFINE VARIABLE gdSmartObjectObj    AS DECIMAL      NO-UNDO.
DEFINE VARIABLE gdObjectTypeObj     AS DECIMAL      NO-UNDO.
DEFINE VARIABLE gcAVUpdateState     AS CHARACTER    NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDataViewer
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER FRAME

&Scoped-define ADM-SUPPORTED-LINKS Data-Target,Update-Source,TableIO-Target,GroupAssign-Source,GroupAssign-Target

/* Include file with RowObject temp-table definition */
&Scoped-define DATA-FIELD-DEFS "ry/obj/rycsofullo.i"

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME frMain

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS RowObject.object_filename ~
RowObject.shutdown_message_text RowObject.system_owned ~
RowObject.static_object RowObject.template_smartobject ~
RowObject.custom_super_procedure 
&Scoped-define ENABLED-TABLES RowObject
&Scoped-define FIRST-ENABLED-TABLE RowObject
&Scoped-define DISPLAYED-TABLES RowObject
&Scoped-define FIRST-DISPLAYED-TABLE RowObject
&Scoped-Define ENABLED-OBJECTS bu_find_object fiObjectDescription ~
fiObjectPath coRunWhen bu_find_physical bu_find_security toContainer ~
toRunnableFromMenu toRunPersistent toDisabled toLogicalObject ~
toGenericObject EdRequiredDBList fiTooltip fiToolBarImage fiObjectLabel ~
TeShutdownText TeCustomProcedure TeRequiredDBList 
&Scoped-Define DISPLAYED-FIELDS RowObject.object_filename ~
RowObject.shutdown_message_text RowObject.system_owned ~
RowObject.static_object RowObject.template_smartobject ~
RowObject.custom_super_procedure 
&Scoped-Define DISPLAYED-OBJECTS fiObjectDescription fiObjectPath coRunWhen ~
toContainer toRunnableFromMenu toRunPersistent toDisabled toLogicalObject ~
toGenericObject EdRequiredDBList fiTooltip fiToolBarImage fiObjectLabel ~
TeShutdownText TeCustomProcedure TeRequiredDBList 

/* Custom List Definitions                                              */
/* ADM-ASSIGN-FIELDS,List-2,List-3,List-4,List-5,List-6                 */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */


/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_dynlookup AS HANDLE NO-UNDO.
DEFINE VARIABLE h_dynlookup-2 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_dynlookup-3 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_dynlookup-4 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_gscotcmsfv AS HANDLE NO-UNDO.
DEFINE VARIABLE h_gscpmprdfv AS HANDLE NO-UNDO.
DEFINE VARIABLE h_ryclacmsfv AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON bu_find_object 
     LABEL "Find O&bject..." 
     SIZE 15 BY 1 TOOLTIP "Find an object"
     BGCOLOR 8 .

DEFINE BUTTON bu_find_physical 
     LABEL "Find &Physical..." 
     SIZE 15 BY 1 TOOLTIP "Find an object"
     BGCOLOR 8 .

DEFINE BUTTON bu_find_security 
     LABEL "Find &Security..." 
     SIZE 15 BY 1 TOOLTIP "Find an object"
     BGCOLOR 8 .

DEFINE VARIABLE coRunWhen AS CHARACTER FORMAT "X(256)":U 
     LABEL "Run When" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEM-PAIRS "Item 1","Item 1"
     DROP-DOWN-LIST
     SIZE 45 BY 1 NO-UNDO.

DEFINE VARIABLE EdRequiredDBList AS CHARACTER 
     VIEW-AS EDITOR SCROLLBAR-VERTICAL
     SIZE 45 BY 2.

DEFINE VARIABLE fiObjectDescription AS CHARACTER FORMAT "X(256)":U 
     LABEL "Object Description" 
     VIEW-AS FILL-IN 
     SIZE 45 BY 1 NO-UNDO.

DEFINE VARIABLE fiObjectLabel AS CHARACTER FORMAT "X(256)":U INITIAL "Object Filename:" 
      VIEW-AS TEXT 
     SIZE 16 BY .62 NO-UNDO.

DEFINE VARIABLE fiObjectPath AS CHARACTER FORMAT "X(256)":U 
     LABEL "Object Path" 
     VIEW-AS FILL-IN 
     SIZE 45 BY 1 NO-UNDO.

DEFINE VARIABLE fiToolBarImage AS CHARACTER FORMAT "X(256)":U 
     LABEL "Toolbar Image Filename" 
     VIEW-AS FILL-IN 
     SIZE 45 BY 1 NO-UNDO.

DEFINE VARIABLE fiTooltip AS CHARACTER FORMAT "X(256)":U 
     LABEL "Tooltip Text" 
     VIEW-AS FILL-IN 
     SIZE 45 BY 1 NO-UNDO.

DEFINE VARIABLE TeCustomProcedure AS CHARACTER FORMAT "X(256)":U INITIAL "Custom Super Procedure:" 
      VIEW-AS TEXT 
     SIZE 24 BY .62 NO-UNDO.

DEFINE VARIABLE TeRequiredDBList AS CHARACTER FORMAT "X(256)":U INITIAL "Required DB List:" 
      VIEW-AS TEXT 
     SIZE 16.8 BY .62 NO-UNDO.

DEFINE VARIABLE TeShutdownText AS CHARACTER FORMAT "X(256)":U INITIAL "Shutdown Message Text:" 
      VIEW-AS TEXT 
     SIZE 24.4 BY .62 NO-UNDO.

DEFINE VARIABLE toContainer AS LOGICAL INITIAL no 
     LABEL "Container" 
     VIEW-AS TOGGLE-BOX
     SIZE 21 BY .81 NO-UNDO.

DEFINE VARIABLE toDisabled AS LOGICAL INITIAL no 
     LABEL "Disabled" 
     VIEW-AS TOGGLE-BOX
     SIZE 21 BY .81 NO-UNDO.

DEFINE VARIABLE toGenericObject AS LOGICAL INITIAL no 
     LABEL "Generic Object" 
     VIEW-AS TOGGLE-BOX
     SIZE 21 BY .81 NO-UNDO.

DEFINE VARIABLE toLogicalObject AS LOGICAL INITIAL no 
     LABEL "Logical Object" 
     VIEW-AS TOGGLE-BOX
     SIZE 21 BY .81 NO-UNDO.

DEFINE VARIABLE toRunnableFromMenu AS LOGICAL INITIAL no 
     LABEL "Runs From Menu" 
     VIEW-AS TOGGLE-BOX
     SIZE 21 BY .81 NO-UNDO.

DEFINE VARIABLE toRunPersistent AS LOGICAL INITIAL no 
     LABEL "Run Persistent" 
     VIEW-AS TOGGLE-BOX
     SIZE 21 BY .81 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME frMain
     RowObject.object_filename AT ROW 4.38 COL 20.2 NO-LABEL
          VIEW-AS EDITOR MAX-CHARS 70 SCROLLBAR-VERTICAL
          SIZE 45 BY 2
     bu_find_object AT ROW 4.38 COL 65.6
     fiObjectDescription AT ROW 6.43 COL 18.2 COLON-ALIGNED
     fiObjectPath AT ROW 7.48 COL 18.2 COLON-ALIGNED
     coRunWhen AT ROW 8.52 COL 18.4 COLON-ALIGNED
     bu_find_physical AT ROW 11.76 COL 65.6
     bu_find_security AT ROW 12.81 COL 65.6
     RowObject.shutdown_message_text AT ROW 1 COL 109.4 NO-LABEL
          VIEW-AS EDITOR MAX-CHARS 70 SCROLLBAR-VERTICAL
          SIZE 45 BY 2
     toContainer AT ROW 3 COL 109.4
     toRunnableFromMenu AT ROW 3.81 COL 109.4
     toRunPersistent AT ROW 4.62 COL 109.4
     RowObject.system_owned AT ROW 5.43 COL 109.4
          VIEW-AS TOGGLE-BOX
          SIZE 21 BY .81
     toDisabled AT ROW 6.24 COL 109.4
     RowObject.static_object AT ROW 3 COL 133.4
          VIEW-AS TOGGLE-BOX
          SIZE 21 BY .81
     toLogicalObject AT ROW 3.81 COL 133.4
     RowObject.template_smartobject AT ROW 4.62 COL 133.4
          VIEW-AS TOGGLE-BOX
          SIZE 21 BY .81
     toGenericObject AT ROW 5.43 COL 133.4
     EdRequiredDBList AT ROW 7.14 COL 109.4 NO-LABEL
     RowObject.custom_super_procedure AT ROW 9.19 COL 109.4 NO-LABEL
          VIEW-AS EDITOR MAX-CHARS 70 SCROLLBAR-VERTICAL
          SIZE 45 BY 2
     fiTooltip AT ROW 12.29 COL 107.4 COLON-ALIGNED
     fiToolBarImage AT ROW 13.33 COL 107.4 COLON-ALIGNED
     fiObjectLabel AT ROW 4.38 COL 1.6 COLON-ALIGNED NO-LABEL
     TeShutdownText AT ROW 1 COL 82.2 NO-LABEL
     TeCustomProcedure AT ROW 9.19 COL 82.2 NO-LABEL
     TeRequiredDBList AT ROW 7.14 COL 92 NO-LABEL
     SPACE(45.60) SKIP(6.05)
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY USE-DICT-EXPS 
         SIDE-LABELS NO-UNDERLINE THREE-D NO-AUTO-VALIDATE 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDataViewer
   Data Source: "ry/obj/rycsofullo.w"
   Allow: Basic,DB-Fields,Smart
   Container Links: Data-Target,Update-Source,TableIO-Target,GroupAssign-Source,GroupAssign-Target
   Frames: 1
   Add Fields to: Neither
   Other Settings: PERSISTENT-ONLY COMPILE
   Temp-Tables and Buffers:
      TABLE: RowObject D "?" ?  
      ADDITIONAL-FIELDS:
          {ry/obj/rycsofullo.i}
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
         HEIGHT             = 14.95
         WIDTH              = 154.
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
   NOT-VISIBLE Size-to-Fit Custom                                       */
ASSIGN 
       FRAME frMain:SCROLLABLE       = FALSE
       FRAME frMain:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN TeCustomProcedure IN FRAME frMain
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN TeRequiredDBList IN FRAME frMain
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN TeShutdownText IN FRAME frMain
   ALIGN-L                                                              */
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

&Scoped-define SELF-NAME bu_find_object
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bu_find_object vTableWin
ON CHOOSE OF bu_find_object IN FRAME frMain /* Find Object... */
DO:
  DO WITH FRAME {&FRAME-NAME}:
    DEFINE VARIABLE lOk                   AS   LOGICAL                NO-UNDO.
    DEFINE VARIABLE cRoot                 AS   CHARACTER              NO-UNDO.
    DEFINE VARIABLE cFilename             AS   CHARACTER              NO-UNDO.
    DEFINE VARIABLE cFilterNamestring    AS   CHARACTER EXTENT 5     NO-UNDO.
    DEFINE VARIABLE cFilterFilespec      LIKE cFilterNamestring   NO-UNDO.
    DEFINE VARIABLE cFile                 AS   CHARACTER              NO-UNDO.
    DEFINE VARIABLE cPath                 AS   CHARACTER              NO-UNDO.

    /* Initialize the file filters, for special cases. */

    ASSIGN  cFilterNamestring[1] = "All Files(*.*)"
            cFilterFilespec[1] = "*.*"
            cFilterNamestring[2] = "All windows(?????????w.w)"
            cFilterFilespec[2] = "?????????w.w".

    /*  Ask for a file name. NOTE: File-names to run must exist.
        --------------------------------------------------------
    */

    cFilename = RowObject.object_filename:SCREEN-VALUE.

    SYSTEM-DIALOG GET-FILE cFilename
                  TITLE    "Lookup Program"
                  FILTERS  cFilterNamestring[ 1 ]   cFilterFilespec[ 1 ],
                           cFilterNamestring[ 2 ]   cFilterFilespec[ 2 ]
                  MUST-EXIST
                  UPDATE   lOk IN WINDOW {&WINDOW-NAME}.  

    cRoot = IF  REPLACE(cFilename,"\":U,"/":U) BEGINS REPLACE(ENTRY(2,PROPATH),"\":U,"/":U) THEN
                REPLACE(ENTRY(2,PROPATH),"\":U,"/":U)
                ELSE REPLACE(ENTRY(1,PROPATH),"\":U,"/":U).

    IF  lOk THEN DO:
        ASSIGN
            cFile                                  = REPLACE(REPLACE(TRIM(LC(cFilename)),"\":U,"/":U),cRoot + "/":U,"":U)
            RowObject.object_filename:SCREEN-VALUE = SUBSTRING(cFile,R-INDEX(cFile,"/":U) + 1)
            cPath                                  = SUBSTRING(cFile,1,R-INDEX(cFile,"/":U))
            RowObject.object_filename:MODIFIED     = TRUE.

        ASSIGN
            fiObjectPath:SCREEN-VALUE IN FRAME {&FRAME-NAME} = cPath.

        APPLY "ENTRY":U TO RowObject.object_filename.
    END.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bu_find_physical
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bu_find_physical vTableWin
ON CHOOSE OF bu_find_physical IN FRAME frMain /* Find Physical... */
DO:
  DO WITH FRAME {&FRAME-NAME}:
    DEFINE VARIABLE lOk                 AS   LOGICAL                NO-UNDO.
    DEFINE VARIABLE cRoot               AS   CHARACTER              NO-UNDO.
    DEFINE VARIABLE cFilename           AS   CHARACTER              NO-UNDO.
    DEFINE VARIABLE cFilterNamestring   AS   CHARACTER EXTENT 5     NO-UNDO.
    DEFINE VARIABLE cFilterFilespec     LIKE cFilterNamestring      NO-UNDO.
    DEFINE VARIABLE cFile               AS   CHARACTER              NO-UNDO.

    /* Initialize the file filters, for special cases. */

    ASSIGN  cFilterNamestring[1] = "All Files(*.*)"
            cFilterFilespec[1] = "*.*"
            cFilterNamestring[2] = "All windows(?????????w.w)"
            cFilterFilespec[2] = "?????????w.w".

    /*  Ask for a file name. NOTE: File-names to run must exist.
        --------------------------------------------------------
    */

    cFilename = DYNAMIC-FUNCTION("getDataValue":U IN h_dynlookup-2).

    SYSTEM-DIALOG GET-FILE cFilename
        TITLE    "Lookup Physical Object"
        FILTERS  cFilterNamestring[ 1 ]   cFilterFilespec[ 1 ],
                 cFilterNamestring[ 2 ]   cFilterFilespec[ 2 ]
        MUST-EXIST
        UPDATE   lOk IN WINDOW {&WINDOW-NAME}.  

    cRoot = IF  REPLACE(cFilename,"\":U,"/":U) BEGINS REPLACE(ENTRY(2,PROPATH),"\":U,"/":U) THEN
              REPLACE(ENTRY(2,PROPATH),"\":U,"/":U)
              ELSE REPLACE(ENTRY(1,PROPATH),"\":U,"/":U).

    IF  lOk THEN DO:
        ASSIGN
            cFile = REPLACE(REPLACE(TRIM(LC(cFilename)),"\":U,"/":U),cRoot + "/":U,"":U).
            lOk   = DYNAMIC-FUNCTION("setDataValue":U IN h_dynlookup-2, INPUT SUBSTRING(cFile,R-INDEX(cFile,"/":U) + 1)).
    END.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bu_find_security
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bu_find_security vTableWin
ON CHOOSE OF bu_find_security IN FRAME frMain /* Find Security... */
DO:
  DO WITH FRAME {&FRAME-NAME}:
    DEFINE VARIABLE lOk                 AS   LOGICAL                NO-UNDO.
    DEFINE VARIABLE cRoot               AS   CHARACTER              NO-UNDO.
    DEFINE VARIABLE cFilename           AS   CHARACTER              NO-UNDO.
    DEFINE VARIABLE cFilterNamestring   AS   CHARACTER EXTENT 5     NO-UNDO.
    DEFINE VARIABLE cFilterFilespec     LIKE cFilterNamestring      NO-UNDO.
    DEFINE VARIABLE cFile               AS   CHARACTER              NO-UNDO.

    /* Initialize the file filters, for special cases. */

    ASSIGN  cFilterNamestring[1] = "All Files(*.*)"
            cFilterFilespec[1] = "*.*"
            cFilterNamestring[2] = "All windows(?????????w.w)"
            cFilterFilespec[2] = "?????????w.w".

    /*  Ask for a file name. NOTE: File-names to run must exist.
        --------------------------------------------------------
    */

    cFilename = DYNAMIC-FUNCTION("getDataValue":U IN h_dynlookup-3).

    SYSTEM-DIALOG GET-FILE cFilename
        TITLE    "Lookup Security Object"
        FILTERS  cFilterNamestring[ 1 ]   cFilterFilespec[ 1 ],
                 cFilterNamestring[ 2 ]   cFilterFilespec[ 2 ]
        MUST-EXIST
        UPDATE   lOk IN WINDOW {&WINDOW-NAME}.  

    cRoot = IF  REPLACE(cFilename,"\":U,"/":U) BEGINS REPLACE(ENTRY(2,PROPATH),"\":U,"/":U) THEN
              REPLACE(ENTRY(2,PROPATH),"\":U,"/":U)
              ELSE REPLACE(ENTRY(1,PROPATH),"\":U,"/":U).

    IF  lOk THEN DO:
        ASSIGN
            cFile                           = REPLACE(REPLACE(TRIM(LC(cFilename)),"\":U,"/":U),cRoot + "/":U,"":U).
            lOk = DYNAMIC-FUNCTION("setDataValue":U IN h_dynlookup-3, INPUT SUBSTRING(cFile,R-INDEX(cFile,"/":U) + 1)).
    END.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME coRunWhen
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL coRunWhen vTableWin
ON VALUE-CHANGED OF coRunWhen IN FRAME frMain /* Run When */
DO:
    {set DataModified TRUE}.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME EdRequiredDBList
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL EdRequiredDBList vTableWin
ON VALUE-CHANGED OF EdRequiredDBList IN FRAME frMain
DO:
    /*
    IF NOT glModified THEN
    DO:
       glModified = YES.
       PUBLISH 'updateState':U ('update':U).  
    END.  
    */
    {set DataModified TRUE}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fiObjectDescription
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiObjectDescription vTableWin
ON VALUE-CHANGED OF fiObjectDescription IN FRAME frMain /* Object Description */
DO:
    {set DataModified TRUE}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fiObjectLabel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiObjectLabel vTableWin
ON VALUE-CHANGED OF fiObjectLabel IN FRAME frMain
DO:
   {set DataModified TRUE}.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fiObjectPath
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiObjectPath vTableWin
ON VALUE-CHANGED OF fiObjectPath IN FRAME frMain /* Object Path */
DO:
    {set DataModified TRUE}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fiToolBarImage
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiToolBarImage vTableWin
ON VALUE-CHANGED OF fiToolBarImage IN FRAME frMain /* Toolbar Image Filename */
DO:
    {set DataModified TRUE}.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fiTooltip
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiTooltip vTableWin
ON VALUE-CHANGED OF fiTooltip IN FRAME frMain /* Tooltip Text */
DO:
    {set DataModified TRUE}.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME toContainer
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL toContainer vTableWin
ON VALUE-CHANGED OF toContainer IN FRAME frMain /* Container */
DO:
    {set DataModified TRUE}. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME toDisabled
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL toDisabled vTableWin
ON VALUE-CHANGED OF toDisabled IN FRAME frMain /* Disabled */
DO:
    {set DataModified TRUE}. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME toGenericObject
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL toGenericObject vTableWin
ON VALUE-CHANGED OF toGenericObject IN FRAME frMain /* Generic Object */
DO:
    {set DataModified TRUE}.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME toLogicalObject
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL toLogicalObject vTableWin
ON VALUE-CHANGED OF toLogicalObject IN FRAME frMain /* Logical Object */
DO:

    ASSIGN
        toLogicalObject.

    IF  NOT toLogicalObject THEN DO:
        DYNAMIC-FUNCTION("setDataValue":U IN h_dynlookup-2, INPUT 0).
        RUN disableField IN h_dynlookup-2.
    END.
    ELSE
        RUN enableField IN h_dynlookup-2.

    {set DataModified TRUE}.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME toRunnableFromMenu
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL toRunnableFromMenu vTableWin
ON VALUE-CHANGED OF toRunnableFromMenu IN FRAME frMain /* Runs From Menu */
DO:
    {set DataModified TRUE}. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME toRunPersistent
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL toRunPersistent vTableWin
ON VALUE-CHANGED OF toRunPersistent IN FRAME frMain /* Run Persistent */
DO:
    {set DataModified TRUE}.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK vTableWin 


/* ***************************  Main Block  *************************** */

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN initializeObject.
  &ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

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
             INPUT  'adm2/dynlookup.w':U ,
             INPUT  FRAME frMain:HANDLE ,
             INPUT  'DisplayedFieldgsm_multi_media.physical_file_nameKeyFieldgsm_multi_media.multi_media_objFieldLabelToolbar Multi MediaFieldTooltipKeyFormat>>>>>>>>>>>>>>>>>9.999999999KeyDatatypedecimalDisplayFormatX(70)DisplayDatatypecharacterBaseQueryStringFOR EACH gsm_multi_media NO-LOCK,
                     EACH gsc_multi_media_type NO-LOCK
                     WHERE gsc_multi_media_type.multi_media_type_obj = gsm_multi_media.multi_media_type_objQueryTablesgsm_multi_media,gsc_multi_media_typeBrowseFieldsgsc_multi_media_type.multi_media_type_code,gsc_multi_media_type.file_extension,gsm_multi_media.physical_file_name,gsm_multi_media.multi_media_description,gsm_multi_media.creation_dateBrowseFieldDataTypescharacter,character,character,character,dateBrowseFieldFormatsX(10),X(3),X(70),X(35),99/99/9999RowsToBatch200BrowseTitleLookupViewerLinkedFieldsLinkedFieldDataTypesLinkedFieldFormatsViewerLinkedWidgetsColumnLabelsColumnFormatSDFFileNameSDFTemplateLookupImageadeicon/select.bmpParentFieldParentFilterQueryMaintenanceObjectMaintenanceSDOFieldNametoolbarMultiMediaDisplayFieldyesEnableFieldyesHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT h_dynlookup-4 ).
       RUN repositionObject IN h_dynlookup-4 ( 11.19 , 109.40 ) NO-ERROR.
       RUN resizeObject IN h_dynlookup-4 ( 1.00 , 45.00 ) NO-ERROR.

       RUN constructObject (
             INPUT  'adm2/dynlookup.w':U ,
             INPUT  FRAME frMain:HANDLE ,
             INPUT  'DisplayedFieldryc_smartobject.object_filenameKeyFieldryc_smartobject.smartobject_objFieldLabelSDO NameFieldTooltipKeyFormat>>>>>>>>>>>>>>>>>9.999999999KeyDatatypedecimalDisplayFormatX(70)DisplayDatatypecharacterBaseQueryStringFOR EACH gsc_object_type NO-LOCK
                     WHERE gsc_object_type.OBJECT_type_code = "SDO",
                     EACH ryc_smartobject NO-LOCK
                     WHERE ryc_smartobject.OBJECT_type_obj = gsc_object_type.OBJECT_type_objQueryTablesgsc_object_type,ryc_smartobjectBrowseFieldsryc_smartobject.object_filename,ryc_smartobject.template_smartobject,gsc_object_type.object_type_code,gsc_object_type.object_type_descriptionBrowseFieldDataTypescharacter,logical,character,characterBrowseFieldFormatsX(70),YES/NO,X(15),X(35)RowsToBatch200BrowseTitleLookup SDOViewerLinkedFieldsLinkedFieldDataTypesLinkedFieldFormatsViewerLinkedWidgetsColumnLabelsColumnFormatSDFFileNameSDFTemplateLookupImageadeicon/select.bmpParentFieldParentFilterQueryMaintenanceObjectMaintenanceSDOFieldNamesdo_smartobject_objDisplayFieldyesEnableFieldyesHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT h_dynlookup ).
       RUN repositionObject IN h_dynlookup ( 10.71 , 20.60 ) NO-ERROR.
       RUN resizeObject IN h_dynlookup ( 1.00 , 45.00 ) NO-ERROR.

       RUN constructObject (
             INPUT  'adm2/dynlookup.w':U ,
             INPUT  FRAME frMain:HANDLE ,
             INPUT  'DisplayedFieldgsc_object.object_filenameKeyFieldgsc_object.object_objFieldLabelPhysical ObjectFieldTooltipKeyFormat>>>>>>>>>>>>>>>>>9.999999999KeyDatatypedecimalDisplayFormatX(35)DisplayDatatypecharacterBaseQueryStringFOR EACH gsc_object NO-LOCK
                     WHERE NOT gsc_object.LOGICAL_object,
                     FIRST gsc_object_type NO-LOCK
                     WHERE gsc_object_type.OBJECT_type_obj = gsc_object.OBJECT_type_obj,
                     FIRST gsc_product_module NO-LOCK
                     WHERE gsc_product_module.product_module_obj = gsc_object.product_module_obj,
                     FIRST gsc_product NO-LOCK
                     WHERE gsc_product.product_obj = gsc_product_module.product_obj INDEXED-REPOSITIONQueryTablesgsc_object,gsc_object_type,gsc_product_module,gsc_productBrowseFieldsgsc_product.product_code,gsc_product_module.product_module_code,gsc_object_type.object_type_code,gsc_object.object_filename,gsc_object.logical_object,gsc_object.object_description,gsc_object.container_objectBrowseFieldDataTypescharacter,character,character,character,logical,character,logicalBrowseFieldFormatsX(10),X(10),X(15),X(35),YES/NO,X(35),YES/NORowsToBatch200BrowseTitleLookup Physical ObjectViewerLinkedFieldsLinkedFieldDataTypesLinkedFieldFormatsViewerLinkedWidgetsColumnLabelsColumnFormatSDFFileNameSDFTemplateLookupImageadeicon/select.bmpParentFieldParentFilterQueryMaintenanceObjectMaintenanceSDOFieldNamephysicalObjectDisplayFieldyesEnableFieldyesHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT h_dynlookup-2 ).
       RUN repositionObject IN h_dynlookup-2 ( 11.76 , 20.60 ) NO-ERROR.
       RUN resizeObject IN h_dynlookup-2 ( 1.00 , 45.00 ) NO-ERROR.

       RUN constructObject (
             INPUT  'adm2/dynlookup.w':U ,
             INPUT  FRAME frMain:HANDLE ,
             INPUT  'DisplayedFieldgsc_object.object_filenameKeyFieldgsc_object.object_objFieldLabelSecurity ObjectFieldTooltipKeyFormat>>>>>>>>>>>>>>>>>9.999999999KeyDatatypedecimalDisplayFormatX(35)DisplayDatatypecharacterBaseQueryStringFOR EACH gsc_object NO-LOCK,
                     FIRST gsc_object_type NO-LOCK
                     WHERE gsc_object_type.OBJECT_type_obj = gsc_object.OBJECT_type_obj,
                     FIRST gsc_product_module NO-LOCK
                     WHERE gsc_product_module.product_module_obj = gsc_object.product_module_obj,
                     FIRST gsc_product NO-LOCK
                     WHERE gsc_product.product_obj = gsc_product_module.product_objQueryTablesgsc_object,gsc_object_type,gsc_product_module,gsc_productBrowseFieldsgsc_product.product_code,gsc_product_module.product_module_code,gsc_object_type.object_type_code,gsc_object.object_filename,gsc_object.container_object,gsc_object.logical_object,gsc_object.generic_object,gsc_object.disabledBrowseFieldDataTypescharacter,character,character,character,logical,logical,logical,logicalBrowseFieldFormatsX(10),X(10),X(15),X(35),YES/NO,YES/NO,YES/NO,YES/NORowsToBatch200BrowseTitleLookup Security ObjectViewerLinkedFieldsLinkedFieldDataTypesLinkedFieldFormatsViewerLinkedWidgetsColumnLabelsColumnFormatSDFFileNameSDFTemplateLookupImageadeicon/select.bmpParentFieldParentFilterQueryMaintenanceObjectMaintenanceSDOFieldNamesecurityObjectDisplayFieldyesEnableFieldyesHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT h_dynlookup-3 ).
       RUN repositionObject IN h_dynlookup-3 ( 12.81 , 20.60 ) NO-ERROR.
       RUN resizeObject IN h_dynlookup-3 ( 1.00 , 45.00 ) NO-ERROR.

       RUN constructObject (
             INPUT  'ry/obj/gscpmprdfv.w':U ,
             INPUT  FRAME frMain:HANDLE ,
             INPUT  'FieldNameproduct_module_objDisplayFieldyesEnableFieldyesHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT h_gscpmprdfv ).
       RUN repositionObject IN h_gscpmprdfv ( 1.00 , 1.00 ) NO-ERROR.
       RUN resizeObject IN h_gscpmprdfv ( 2.33 , 72.80 ) NO-ERROR.

       RUN constructObject (
             INPUT  'ry/obj/gscotcmsfv.w':U ,
             INPUT  FRAME frMain:HANDLE ,
             INPUT  'FieldNameobject_type_objDisplayFieldyesEnableFieldyesHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT h_gscotcmsfv ).
       RUN repositionObject IN h_gscotcmsfv ( 3.29 , 7.40 ) NO-ERROR.
       RUN resizeObject IN h_gscotcmsfv ( 1.19 , 59.60 ) NO-ERROR.

       RUN constructObject (
             INPUT  'ry/obj/ryclacmsfv.w':U ,
             INPUT  FRAME frMain:HANDLE ,
             INPUT  'FieldNamelayout_objDisplayFieldyesEnableFieldyesHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT h_ryclacmsfv ).
       RUN repositionObject IN h_ryclacmsfv ( 9.62 , 7.60 ) NO-ERROR.
       RUN resizeObject IN h_ryclacmsfv ( 1.10 , 58.80 ) NO-ERROR.

       /* Adjust the tab order of the smart objects. */
       RUN adjustTabOrder ( h_dynlookup-4 ,
             RowObject.object_filename:HANDLE IN FRAME frMain , 'BEFORE':U ).
       RUN adjustTabOrder ( h_dynlookup ,
             h_dynlookup-4 , 'AFTER':U ).
       RUN adjustTabOrder ( h_dynlookup-2 ,
             h_dynlookup , 'AFTER':U ).
       RUN adjustTabOrder ( h_dynlookup-3 ,
             h_dynlookup-2 , 'AFTER':U ).
       RUN adjustTabOrder ( h_gscpmprdfv ,
             h_dynlookup-3 , 'AFTER':U ).
       RUN adjustTabOrder ( h_gscotcmsfv ,
             h_gscpmprdfv , 'AFTER':U ).
       RUN adjustTabOrder ( h_ryclacmsfv ,
             coRunWhen:HANDLE IN FRAME frMain , 'AFTER':U ).
    END. /* Page 0 */

  END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE collectChanges vTableWin 
PROCEDURE collectChanges :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT-OUTPUT PARAMETER pcChanges AS CHARACTER NO-UNDO.
  DEFINE INPUT-OUTPUT PARAMETER pcInfo    AS CHARACTER NO-UNDO.

  /* Code placed here will execute PRIOR to standard behavior. */
  RUN SUPER(INPUT-OUTPUT pcChanges,
            INPUT-OUTPUT pcInfo).

  /* Code placed here will execute AFTER standard behavior.    */
  RUN updateTempTable.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE deleteRecord vTableWin 
PROCEDURE deleteRecord :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  FIND FIRST ttGscObject NO-ERROR.
  IF  AVAILABLE ttGscObject THEN
      ASSIGN
          ttGscObject.rowMod     = "D":U.

  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */

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
    DEFINE INPUT PARAMETER pcColValues  AS CHARACTER    NO-UNDO.

    DEFINE VARIABLE cBufferList         AS CHARACTER    NO-UNDO.
    DEFINE VARIABLE hContainer          AS HANDLE       NO-UNDO.
    DEFINE VARIABLE cColvalues          AS CHARACTER    NO-UNDO.
    DEFINE VARIABLE hDataSource         AS HANDLE       NO-UNDO.
    DEFINE VARIABLE cDataSource         AS CHARACTER    NO-UNDO.
    DEFINE VARIABLE lOk                 AS LOGICAL      NO-UNDO.
    DEFINE VARIABLE hSelection          AS HANDLE       NO-UNDO.
    DEFINE VARIABLE iLoop               AS INTEGER      NO-UNDO.
    DEFINE VARIABLE hWindow             AS HANDLE       NO-UNDO.
    DEFINE VARIABLE cGroupAssignLink    AS CHARACTER    NO-UNDO.

    DEFINE BUFFER bttGscObject          FOR ttGscObject.

    /* Code placed here will execute PRIOR to standard behavior. */         

    {get ContainerSource hContainer}.

    IF  VALID-HANDLE(hContainer) THEN DO:
        {get ContainerMode gcContainerMode hContainer}.
    END.

    {get DataSource cDataSource}.

    DO  iLoop = 1 TO NUM-ENTRIES(cDataSource):
        hDataSource = WIDGET-HANDLE(ENTRY(iLoop, cDataSource)) NO-ERROR.
    END.

    ASSIGN
        coRunWhen:LIST-ITEM-PAIRS IN FRAME {&FRAME-NAME} = cRunWhen.

    EMPTY TEMP-TABLE ttGscObject.
    EMPTY TEMP-TABLE ttRycAttributeValue.
    EMPTY TEMP-TABLE ttRycObjectInstance.
    EMPTY TEMP-TABLE ttRycSmartlink.
    EMPTY TEMP-TABLE ttRycPage.

    IF  gcContainerMode <> "add":u
    AND VALID-HANDLE(hDataSource) THEN
        ASSIGN
            cColvalues  = DYNAMIC-FUNCTION ("colValues" IN hDataSource, INPUT "object_obj,smartobject_obj,object_type_obj").    

    ASSIGN
        gdObjectObj        = IF gcContainerMode NE "add":u THEN DECIMAL(ENTRY(2, cColValues, CHR(1))) ELSE 0
        gdSmartObjectObj   = IF gcContainerMode NE "add":u THEN DECIMAL(ENTRY(3, cColValues, CHR(1))) ELSE 0
        gdObjectTypeObj    = IF gcContainerMode NE "add":u THEN DECIMAL(ENTRY(4, cColValues, CHR(1))) ELSE 0
        .

    {af/sup2/afrun2.i &PLIP  = 'ry/app/gscobplipp.p'
                      &IProc = 'fetchDBRecords'
                      &OnApp = 'yes'
                      &PList = "(INPUT SUBSTRING(gcContainerMode,1,1),~
                                 INPUT gdObjectObj,~
                                 INPUT gdSmartObjectObj,~
                                 INPUT gdObjectTypeObj,~
                                 INPUT-OUTPUT TABLE ttGscObject)"
                      &autokill=YES}

        ASSIGN
            ghRycoiTT = TEMP-TABLE ttRycObjectInstance:HANDLE
            ghRycavTT = TEMP-TABLE ttRycAttributeValue:HANDLE
            ghRycpaTT = TEMP-TABLE ttRycPage:HANDLE
            ghRycsmTT = TEMP-TABLE ttRycSmartlink:HANDLE.

    FIND FIRST ttGscObject NO-ERROR.
    IF  AVAILABLE ttGscObject THEN
        ASSIGN
            fiObjectDescription = ttGscObject.object_description
            fiObjectPath        = ttGscObject.object_path
            fiToolBarImage      = ttGscObject.toolbar_image_filename 
            fiTooltip           = ttGscObject.tooltip_text
            ToContainer         = ttGscObject.container_object
            ToDisabled          = ttGscObject.disabled
            ToRunnableFromMenu  = ttGscObject.runnable_from_menu
            toGenericObject     = ttGscObject.generic_object
            toLogicalObject     = ttGscObject.logical_object
            ToRunPersistent     = ttGscObject.run_persistent
            coRunWhen           = ttGscObject.run_when
            edRequiredDBList    = ttGscObject.required_db_list
            .
    ELSE
        ASSIGN
            fiObjectDescription = "":U
            fiObjectPath        = "":U
            fiToolBarImage      = "":U
            fiTooltip           = "":U
            ToContainer         = NO
            ToDisabled          = NO
            ToRunnableFromMenu  = NO
            toGenericObject     = NO
            toLogicalObject     = NO
            ToRunPersistent     = NO
            coRunWhen           = "":U
            edRequiredDBList    = "".


    DISPLAY
        coRunWhen
        fiObjectDescription
        fiObjectPath
        fiToolBarImage
        fiTooltip
        ToContainer
        ToDisabled
        ToRunnableFromMenu
        toGenericObject
        toLogicalObject
        ToRunPersistent
    WITH FRAME {&FRAME-NAME}.        

    RUN SUPER (INPUT pcColValues).

    /* Code placed here will execute AFTER standard behavior.    */

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

  /* Code placed here will execute PRIOR to standard behavior. */

  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */

    IF  NOT toLogicalObject THEN DO:
        DYNAMIC-FUNCTION("setDataValue":U IN h_dynlookup-2, INPUT 0).
        RUN disableField IN h_dynlookup-2.
    END.
    ELSE
        RUN enableField IN h_dynlookup-2.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE fetchRycsoRecords vTableWin 
PROCEDURE fetchRycsoRecords :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE OUTPUT PARAMETER TABLE FOR ttGscObject.
    /*
    DEFINE OUTPUT PARAMETER TABLE FOR ttRycAttributeValue.
    DEFINE OUTPUT PARAMETER TABLE FOR ttRycObjectInstance.
    DEFINE OUTPUT PARAMETER TABLE FOR ttRycPage.
    DEFINE OUTPUT PARAMETER TABLE FOR ttRycSmartLink.
    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject vTableWin 
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE VARIABLE hContainerSource     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cLinkHandles         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hToolBarSource       AS HANDLE     NO-UNDO.

  /* Code placed here will execute PRIOR to standard behavior. */

  &IF DEFINED(UIB_IS_RUNNING) = 0 &THEN

    /* Get container handle */
    {get ContainerSource hContainerSource}.

    /* Get handle to toolbar of the container */
    cLinkHandles   = DYNAMIC-FUNCTION('linkHandles' IN hContainerSource, 'Toolbar-Source').
    hToolbarSource = WIDGET-HANDLE(ENTRY(1,cLinkHandles)). 

    IF VALID-HANDLE(hToolBarSource) THEN
    DO:
        /* Subscribe this procedure to 'toolbar' event published by the toolbar of the container */
        SUBSCRIBE PROCEDURE THIS-PROCEDURE  TO 'toolbar'     IN hToolbarSource.

        /* Subscrive the toolbar of the container to 'updateState' published by the toolbar of the container */
        SUBSCRIBE PROCEDURE  hToolbarSource TO 'updateState' IN THIS-PROCEDURE.                

    END.

  &ENDIF  


  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE repositionObject vTableWin 
PROCEDURE repositionObject :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER pdRow AS DECIMAL NO-UNDO.
  DEFINE INPUT PARAMETER pdCol AS DECIMAL NO-UNDO.

  /* Code placed here will execute PRIOR to standard behavior. */

  RUN SUPER( INPUT pdRow, INPUT pdCol).

  /* Code placed here will execute AFTER standard behavior.    */


/*
  FRAME {&FRAME-NAME}:HEIGHT-PIXELS             = {&WINDOW-NAME}:HEIGHT-PIXELS - 75 NO-ERROR.
/*  FRAME {&FRAME-NAME}:WIDTH-PIXELS              = {&WINDOW-NAME}:WIDTH-PIXELS - 30 NO-ERROR.*/
  fiAttributeValue:Y     IN FRAME {&FRAME-NAME} = FRAME {&FRAME-NAME}:HEIGHT-PIXELS - fiAttributeValue:HEIGHT-PIXELS - 5.
  coAttributeGroup:Y     IN FRAME {&FRAME-NAME} = fiAttributeValue:Y.
  coAttribute:Y          IN FRAME {&FRAME-NAME} = fiAttributeValue:Y.
  ToConstant:Y           IN FRAME {&FRAME-NAME} = fiAttributeValue:Y.
  ToInherited:Y          IN FRAME {&FRAME-NAME} = fiAttributeValue:Y.
  IF VALID-HANDLE(ghBrowse) THEN DO:
    ghBrowse:HEIGHT-PIXELS = fiAttributeValue:Y - buAdd:Y - buAdd:HEIGHT-PIXELS - 10.
    ghBrowse:WIDTH-PIXELS  = FRAME {&FRAME-NAME}:WIDTH-PIXELS - 10.
    RUN resetBrowseColumns(INPUT ghBrowse:WIDTH-PIXELS).
  END.
  /* Frame height and width is re-assigned here because previous assign may have caused an error */
  /* depending on whether you are making the frame bigger or smaller.  The assign must be done in both */
  /* places. */
  FRAME {&FRAME-NAME}:HEIGHT-PIXELS = {&WINDOW-NAME}:HEIGHT-PIXELS - 75 NO-ERROR.
/*  FRAME {&FRAME-NAME}:WIDTH-PIXELS  = {&WINDOW-NAME}:WIDTH-PIXELS - 30 NO-ERROR.*/
*/

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
  RUN "adm2\dynlookup.w *RTB-SmObj* ".
  RUN "ry\obj\gscpmprdfv.w *RTB-SmObj* ".
  RUN "ry\obj\gscotcmsfv.w *RTB-SmObj* ".
  RUN "ry\obj\ryclacmsfv.w *RTB-SmObj* ".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updateTempTable vTableWin 
PROCEDURE updateTempTable :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


    FIND FIRST ttGscObject NO-ERROR.
    IF  NOT AVAILABLE ttGscObject THEN DO:
        CREATE ttGscObject.
        ASSIGN
            ttGscObject.object_obj = 0
            ttGscObject.rowMod     = "A":U
            ttGscObject.rowNum     = 100001
            ttGscObject.rowIdent   = "0":U.
    END.
    ELSE
    IF ttGscObject.rowMod EQ "C":U THEN
        ASSIGN
            ttGscObject.object_obj = 0
            ttGscObject.rowNum     = 100001
            ttGscObject.rowIdent   = "0":U.

    DO WITH FRAME {&FRAME-NAME}:
        ASSIGN
            coRunWhen
            EdRequiredDBList
            fiObjectDescription
            fiObjectPath
            fiToolBarImage
            fiTooltip
            toContainer
            toDisabled
            toGenericObject
            toLogicalObject
            toRunnableFromMenu
            toRunPersistent.
    END.

    ASSIGN
        ttGscObject.container_object        = toContainer
        ttGscObject.disabled                = toDisabled
        ttGscObject.generic_object          = toGenericObject
        ttGscObject.logical_object          = toLogicalObject
        ttGscObject.object_description      = fiObjectDescription
        ttGscObject.object_filename         = RowObject.object_filename:SCREEN-VALUE IN FRAME {&FRAME-NAME}
        ttGscObject.object_path             = fiObjectPath
        ttGscObject.required_db_list        = EdRequiredDBList
        ttGscObject.runnable_from_menu      = toRunnableFromMenu
        ttGscObject.run_persistent          = toRunPersistent
        ttGscObject.run_when                = coRunWhen
        ttGscObject.toolbar_image_filename  = fiToolBarImage
        ttGscObject.tooltip_text            = fiTooltip.

    ttGscObject.toolbar_multi_media_obj = DECIMAL(DYNAMIC-FUNCTION ("getDataValue":U IN h_dynlookup-4)).
    ttGscObject.object_type_obj         = DECIMAL(DYNAMIC-FUNCTION ("getDataValue":U IN h_gscotcmsfv)).
    ttGscObject.physical_object_obj     = DECIMAL(DYNAMIC-FUNCTION ("getDataValue":U IN h_dynlookup-2)).
    ttGscObject.product_module_obj      = DECIMAL(DYNAMIC-FUNCTION ("getDataValue":U IN h_gscpmprdfv)).
    ttGscObject.security_object_obj     = DECIMAL(DYNAMIC-FUNCTION ("getDataValue":U IN h_dynlookup-3)).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

