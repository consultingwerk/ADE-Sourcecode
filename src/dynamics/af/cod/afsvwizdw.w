&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI ADM2
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME diDialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Update-Object-Version" diDialog _INLINE
/* Actions: ? ? ? ? af/sup/afverxftrp.p */
/* This has to go above the definitions sections, as that is what it modifies.
   If its not, then the definitions section will have been saved before the
   XFTR code kicks in and changes it */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Definition Comments Wizard" diDialog _INLINE
/* Actions: ? af/cod/aftemwizcw.w ? ? ? */
/* Program Definition Comment Block Wizard
Welcome to the Program Definition Comment Block Wizard. Press Next to proceed.
af/cod/aftemwizpw.w
*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS diDialog 
/*************************************************************/  
/* Copyright (c) 1984-2005 by Progress Software Corporation  */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from PROGRESS Software Corporation. */
/*************************************************************/
/*---------------------------------------------------------------------------------
  File: afsvwizdw.w

  Description:  

  Purpose:

  Parameters:

  History:
  --------
  (v:010000)    Task:           1   UserRef:    
                Date:   02/01/2003  Author:     Thomas Hansen

  Update Notes: 02/02/03 thomas:
                Object checked out to update workspace with posse_main changes.

  (v:010001)    Task:           9   UserRef:    
                Date:   02/14/2003  Author:     Thomas Hansen

  Update Notes: Issue 8579
                Added support for RTB workspace root paths

  (v:010002)    Task:          18   UserRef:    
                Date:   02/28/2003  Author:     Thomas Hansen

  Update Notes: Issue 3533:
                Extended reference to RTB include files to be :
                scm/rtb/inc/ryrtbproch.i
                
                Changed syntax to not make use of RTB variables but use session parameter as much as possible instead..
                
                Also changed getting of root directories to use the new getSessionRootDirectory API.

  (v:020000)    Task:          49   UserRef:    
                Date:   06/20/2003  Author:     Thomas Hansen

  Update Notes: Clean up code to remove scmTool references.

-------------------------------------------------------------------------------*/
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

&scop object-name       afsvwizdw.w
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000

/* Parameters Definitions ---                                           */
&IF DEFINED(UIB_is_Running) = 0 &THEN
  DEFINE INPUT PARAMETER  plSaveAs       AS LOGICAL  NO-UNDO.
  DEFINE OUTPUT PARAMETER plRegisterObj  AS LOGICAL  NO-UNDO.
  DEFINE OUTPUT PARAMETER p_OK           AS LOGICAL  NO-UNDO .
    /* YES - User choose OK. NO - User choose Cancel.       */
&ELSE
  DEFINE VARIABLE plSaveAs      AS LOGICAL  NO-UNDO.
  DEFINE VARIABLE plRegisterObj AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE p_OK          AS LOGICAL NO-UNDO.
&ENDIF
/* Local Variable Definitions ---                                       */

/*  object identifying preprocessor */
&glob   AstraProcedure    yes

{src/adm2/globals.i}
{adeuib/uniwidg.i}      /* AppBuilder temptable definitions */
{adeuib/brwscols.i}     /* AppBuilder SDO column temp table definition */
{ry/app/rydefrescd.i}   /* Result code preprocessor def'n */

DEFINE VARIABLE cProc-Recid       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcObjectType      AS CHARACTER  NO-UNDO. 
DEFINE VARIABLE cClassChildren    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcLastSaveIn      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcSaveInList      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcDynSDOPrefix    AS CHARACTER  NO-UNDO INIT "fullo":U.
DEFINE VARIABLE gcDynViewPrefix   AS CHARACTER  NO-UNDO INIT "viewv":U.
DEFINE VARIABLE gcDynBrowPrefix   AS CHARACTER  NO-UNDO INIT "fullb":U.
DEFINE VARIABLE gcDataLogicSuffix AS CHARACTER  NO-UNDO INIT "logcp.p":U.
DEFINE VARIABLE gcCustomProcSuffix AS CHARACTER  NO-UNDO INIT "supr.p":U.
DEFINE VARIABLE glStaticObject     AS LOGICAL    NO-UNDO. /* Added by Neil to simplify deployment option (which only apply to static objects) */

&SCOPED-DEFINE MAX-SAVEIN  15

DEFINE VARIABLE ghRepositoryDesignManager AS HANDLE     NO-UNDO.

DEFINE BUFFER BUFF_P FOR _P.
DEFINE BUFFER BUFF_U FOR _U.
DEFINE BUFFER BUFF_C FOR _C.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDialog
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER DIALOG-BOX

&Scoped-define ADM-SUPPORTED-LINKS Data-Target,Data-Source,Page-Target,Update-Source,Update-Target

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME diDialog

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rect-s RECTprc RECTRepo fiFileName buFile ~
fiSaveIn coSaveIn buSavein ToRelative fiObjectName fiObjectDesc buBrowse ~
fiRootDirectory coModule fiFullPath toWeb toDesign toClient toServer ToPrc ~
coPrcModule fiPrcFilename fiprcFullPath TogUseNoUndo TogMan TogIndex ~
buCancel fiRelativeLabel fiPrcLabel fiFlag 
&Scoped-Define DISPLAYED-OBJECTS fiFileName fiSaveIn coSaveIn ToRelative ~
fiObjectName fiObjectDesc fiRootDirectory coModule fiRelDirectory ~
fiFullPath toWeb toDesign toClient toServer ToPrc coPrcModule ~
fiPrcRelDirectory fiPrcFilename fiprcFullPath TogUseNoUndo TogMan TogIndex ~
fiRelativeLabel fiPrcLabel fiFlag 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getInitialFileName diDialog 
FUNCTION getInitialFileName RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getObjectValidate diDialog 
FUNCTION getObjectValidate RETURNS LOGICAL
  ( pcObjectName AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getRDMHandle diDialog 
FUNCTION getRDMHandle RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getRegObjName diDialog 
FUNCTION getRegObjName RETURNS CHARACTER
  ( pcName AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getSDOFLA diDialog 
FUNCTION getSDOFLA RETURNS CHARACTER
  ( OUTPUT pcTableName AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setMaxSaveinList diDialog 
FUNCTION setMaxSaveinList RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON buBrowse 
     LABEL "Browse..." 
     SIZE 12 BY 1.1
     BGCOLOR 8 .

DEFINE BUTTON buCancel AUTO-END-KEY 
     LABEL "Cancel" 
     SIZE 15 BY 1.14.

DEFINE BUTTON buFile 
     IMAGE-UP FILE "ry/img/afbinos.gif":U
     LABEL "" 
     SIZE 5 BY 1.1 TOOLTIP "Choose file"
     BGCOLOR 8 .

DEFINE BUTTON buOk AUTO-GO 
     LABEL "&Save" 
     SIZE 15 BY 1.14.

DEFINE BUTTON buSavein 
     IMAGE-UP FILE "ry/img/afopen.gif":U
     LABEL "" 
     SIZE 5 BY 1.1 TOOLTIP "Choose directory"
     BGCOLOR 8 .

DEFINE VARIABLE coModule AS CHARACTER FORMAT "X(256)":U 
     LABEL "Product module" 
     VIEW-AS COMBO-BOX SORT INNER-LINES 10
     LIST-ITEM-PAIRS "Item 1","Item 1"
     DROP-DOWN-LIST
     SIZE 46 BY 1 NO-UNDO.

DEFINE VARIABLE coPrcModule AS CHARACTER FORMAT "X(256)":U 
     LABEL "Product module" 
     VIEW-AS COMBO-BOX SORT INNER-LINES 10
     LIST-ITEM-PAIRS "Item 1","Item 1"
     DROP-DOWN-LIST
     SIZE 74 BY 1 NO-UNDO.

DEFINE VARIABLE coSaveIn AS CHARACTER FORMAT "X(256)":U 
     LABEL "Save in" 
     VIEW-AS COMBO-BOX INNER-LINES 8
     DROP-DOWN-LIST
     SIZE 65 BY 1 NO-UNDO.

DEFINE VARIABLE fiFileName AS CHARACTER FORMAT "X(256)":U 
     LABEL "File name" 
     VIEW-AS FILL-IN 
     SIZE 65 BY 1 NO-UNDO.

DEFINE VARIABLE fiFlag AS CHARACTER FORMAT "X(20)":U INITIAL "Validation flags:" 
     CONTEXT-HELP-ID 0
      VIEW-AS TEXT 
     SIZE 15.2 BY .62 NO-UNDO.

DEFINE VARIABLE fiFullPath AS CHARACTER FORMAT "X(256)":U 
     LABEL "Full path name" 
     VIEW-AS FILL-IN 
     SIZE 74 BY 1 NO-UNDO.

DEFINE VARIABLE fiObjectDesc AS CHARACTER FORMAT "X(256)":U 
     LABEL "Description" 
     VIEW-AS FILL-IN 
     SIZE 61 BY 1 NO-UNDO.

DEFINE VARIABLE fiObjectName AS CHARACTER FORMAT "X(256)":U 
     LABEL "Object name" 
     VIEW-AS FILL-IN 
     SIZE 31 BY 1 NO-UNDO.

DEFINE VARIABLE fiPrcFilename AS CHARACTER FORMAT "X(256)":U 
     LABEL "File name" 
     VIEW-AS FILL-IN 
     SIZE 74 BY 1 NO-UNDO.

DEFINE VARIABLE fiprcFullPath AS CHARACTER FORMAT "X(256)":U 
     LABEL "Full path name" 
     VIEW-AS FILL-IN 
     SIZE 74 BY 1 NO-UNDO.

DEFINE VARIABLE fiPrcLabel AS CHARACTER FORMAT "X(256)":U INITIAL " Create data logic procedure" 
      VIEW-AS TEXT 
     SIZE 29 BY .81 NO-UNDO.

DEFINE VARIABLE fiPrcRelDirectory AS CHARACTER FORMAT "X(256)":U 
     LABEL "Relative directory" 
     VIEW-AS FILL-IN 
     SIZE 74 BY 1 NO-UNDO.

DEFINE VARIABLE fiRelativeLabel AS CHARACTER FORMAT "X(256)":U INITIAL "Register object" 
      VIEW-AS TEXT 
     SIZE 16 BY .81 NO-UNDO.

DEFINE VARIABLE fiRelDirectory AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 27.8 BY 1 TOOLTIP "Relative directory" NO-UNDO.

DEFINE VARIABLE fiRootDirectory AS CHARACTER FORMAT "X(256)":U 
     LABEL "Root directory" 
     VIEW-AS FILL-IN 
     SIZE 61 BY 1 NO-UNDO.

DEFINE VARIABLE fiSaveIn AS CHARACTER FORMAT "X(200)":U 
     CONTEXT-HELP-ID 0
     VIEW-AS FILL-IN 
     SIZE 61.4 BY 1 NO-UNDO.

DEFINE VARIABLE fiSaveinRect AS CHARACTER FORMAT "X(20)":U 
     CONTEXT-HELP-ID 0
      VIEW-AS TEXT 
     SIZE .6 BY .1
     BGCOLOR 7 FGCOLOR 7  NO-UNDO.

DEFINE RECTANGLE rect-s
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 96 BY 3.

DEFINE RECTANGLE RECTprc
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 61 BY .1.

DEFINE RECTANGLE RECTRepo
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 96 BY 17.14.

DEFINE VARIABLE toClient AS LOGICAL INITIAL no 
     LABEL "Deploy to client" 
     VIEW-AS TOGGLE-BOX
     SIZE 21.6 BY .81 TOOLTIP "This object will be included in WebClient deployments" NO-UNDO.

DEFINE VARIABLE toDesign AS LOGICAL INITIAL no 
     LABEL "Design object" 
     VIEW-AS TOGGLE-BOX
     SIZE 19.6 BY .81 TOOLTIP "Indicates this object is only used to design systems, and not required runtime." NO-UNDO.

DEFINE VARIABLE TogIndex AS LOGICAL INITIAL no 
     LABEL "Unique index" 
     VIEW-AS TOGGLE-BOX
     SIZE 17.2 BY .81 TOOLTIP "Generate validation for unique index fields" NO-UNDO.

DEFINE VARIABLE TogMan AS LOGICAL INITIAL no 
     LABEL "Mandatory" 
     VIEW-AS TOGGLE-BOX
     SIZE 16 BY .81 TOOLTIP "Generate validation for mandatory fields" NO-UNDO.

DEFINE VARIABLE TogUseNoUndo AS LOGICAL INITIAL yes 
     LABEL "Use NO-UNDO for RowObject" 
     VIEW-AS TOGGLE-BOX
     SIZE 35 BY .81 TOOLTIP "Generate validation for mandatory fields" NO-UNDO.

DEFINE VARIABLE ToPrc AS LOGICAL INITIAL no 
     LABEL "" 
     VIEW-AS TOGGLE-BOX
     SIZE 3 BY .81 NO-UNDO.

DEFINE VARIABLE ToRelative AS LOGICAL INITIAL no 
     LABEL "" 
     VIEW-AS TOGGLE-BOX
     SIZE 3 BY .81 NO-UNDO.

DEFINE VARIABLE toServer AS LOGICAL INITIAL no 
     LABEL "Deploy to server" 
     VIEW-AS TOGGLE-BOX
     SIZE 21.2 BY .81 TOOLTIP "This object will be included in Appserver deployments" NO-UNDO.

DEFINE VARIABLE toWeb AS LOGICAL INITIAL no 
     LABEL "Deploy to web" 
     VIEW-AS TOGGLE-BOX
     SIZE 19.6 BY .81 TOOLTIP "This object will be included in Web deployments" NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME diDialog
     fiFileName AT ROW 1.71 COL 22 COLON-ALIGNED
     buFile AT ROW 1.71 COL 89.8
     fiSaveIn AT ROW 2.81 COL 22 COLON-ALIGNED NO-LABEL
     coSaveIn AT ROW 2.81 COL 22 COLON-ALIGNED
     buSavein AT ROW 2.81 COL 89.8
     ToRelative AT ROW 4.67 COL 5
     fiObjectName AT ROW 5.62 COL 22 COLON-ALIGNED
     fiObjectDesc AT ROW 6.71 COL 22 COLON-ALIGNED
     buBrowse AT ROW 7.71 COL 86
     fiRootDirectory AT ROW 7.81 COL 22 COLON-ALIGNED
     coModule AT ROW 8.91 COL 22 COLON-ALIGNED
     fiRelDirectory AT ROW 8.91 COL 68.2 COLON-ALIGNED NO-LABEL
     fiFullPath AT ROW 10 COL 22 COLON-ALIGNED NO-TAB-STOP 
     toWeb AT ROW 11.19 COL 24
     toDesign AT ROW 11.19 COL 60.4
     toClient AT ROW 12.1 COL 24
     toServer AT ROW 13.14 COL 24
     ToPrc AT ROW 14.1 COL 5
     coPrcModule AT ROW 15.29 COL 22 COLON-ALIGNED
     fiPrcRelDirectory AT ROW 16.38 COL 22 COLON-ALIGNED
     fiPrcFilename AT ROW 17.52 COL 22 COLON-ALIGNED
     fiprcFullPath AT ROW 18.62 COL 22 COLON-ALIGNED NO-TAB-STOP 
     TogUseNoUndo AT ROW 19.91 COL 24
     TogMan AT ROW 20.91 COL 24
     TogIndex AT ROW 20.91 COL 40.2
     buOk AT ROW 22.57 COL 84
     buCancel AT ROW 24 COL 84
     fiSaveinRect AT ROW 2.81 COL 82.8 COLON-ALIGNED NO-LABEL NO-TAB-STOP 
     fiRelativeLabel AT ROW 4.67 COL 6 COLON-ALIGNED NO-LABEL
     fiPrcLabel AT ROW 14.1 COL 6 COLON-ALIGNED NO-LABEL
     fiFlag AT ROW 21 COL 6.2 COLON-ALIGNED NO-LABEL
     rect-s AT ROW 1.24 COL 3
     RECTprc AT ROW 14.48 COL 37
     RECTRepo AT ROW 5.05 COL 3
     SPACE(2.39) SKIP(3.51)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         TITLE "Save As"
         DEFAULT-BUTTON buOk CANCEL-BUTTON buCancel.


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
/* SETTINGS FOR DIALOG-BOX diDialog
   NOT-VISIBLE FRAME-NAME                                               */
ASSIGN 
       FRAME diDialog:SCROLLABLE       = FALSE
       FRAME diDialog:HIDDEN           = TRUE.

/* SETTINGS FOR BUTTON buOk IN FRAME diDialog
   NO-ENABLE                                                            */
ASSIGN 
       fiFullPath:READ-ONLY IN FRAME diDialog        = TRUE.

ASSIGN 
       fiObjectName:READ-ONLY IN FRAME diDialog        = TRUE.

ASSIGN 
       fiprcFullPath:READ-ONLY IN FRAME diDialog        = TRUE.

/* SETTINGS FOR FILL-IN fiPrcRelDirectory IN FRAME diDialog
   NO-ENABLE                                                            */
ASSIGN 
       fiPrcRelDirectory:READ-ONLY IN FRAME diDialog        = TRUE.

/* SETTINGS FOR FILL-IN fiRelDirectory IN FRAME diDialog
   NO-ENABLE                                                            */
ASSIGN 
       fiRelDirectory:READ-ONLY IN FRAME diDialog        = TRUE.

/* SETTINGS FOR FILL-IN fiSaveinRect IN FRAME diDialog
   NO-DISPLAY NO-ENABLE                                                 */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX diDialog
/* Query rebuild information for DIALOG-BOX diDialog
     _Options          = "SHARE-LOCK"
     _Query            is NOT OPENED
*/  /* DIALOG-BOX diDialog */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME diDialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL diDialog diDialog
ON WINDOW-CLOSE OF FRAME diDialog /* Save As */
DO:  
/* Add Trigger to equate WINDOW-CLOSE to END-ERROR. */
  RUN setUserProfile IN THIS-PROCEDURE.

  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buBrowse
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buBrowse diDialog
ON CHOOSE OF buBrowse IN FRAME diDialog /* Browse... */
DO:
  DEFINE VARIABLE cDirectory AS CHARACTER  NO-UNDO.

  RUN getFolder("Directory", OUTPUT cDirectory).

  IF cDirectory <> "" THEN DO:
     ASSIGN fiRootDirectory:SCREEN-VALUE IN FRAME {&FRAME-NAME} = cDirectory.
     APPLY "Value-changed":U TO fiRootDirectory.
  END.
  
  

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buCancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buCancel diDialog
ON CHOOSE OF buCancel IN FRAME diDialog /* Cancel */
DO:
  RUN setUserProfile IN THIS-PROCEDURE.
  p_OK = NO.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buFile
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buFile diDialog
ON CHOOSE OF buFile IN FRAME diDialog
DO:
 DEFINE VARIABLE lOK               AS LOGICAL    NO-UNDO.
 DEFINE VARIABLE cFile             AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cUnpathedFile     AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cRootDir          AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cInitialDir       AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cDirectory        AS CHARACTER  NO-UNDO.


 IF LOOKUP(gcObjectType,"DynView,DynBrow,DynSDO,DynDataView":U) > 0 THEN 
 DO:

    ASSIGN {&WINDOW-NAME}:PRIVATE-DATA = STRING(THIS-PROCEDURE).

    RUN ry/obj/gopendialog.w (INPUT {&WINDOW-NAME},
                           INPUT "",
                           INPUT NO,
                           INPUT "Get Object",
                           OUTPUT cFile,
                           OUTPUT lok).
    IF lOK THEN DO:
      ASSIGN cFile = REPLACE(cfile, "~\", "/")
         fiFileName:SCREEN-VALUE = ENTRY(NUM-ENTRIES(cFile,"/"), cFile, "/") .
      APPLY "VALUE-CHANGED":U TO fiFileName.
    END.
 END.
 ELSE
 DO:
   ASSIGN cFile = fiFullPath:SCREEN-VALUE.

   IF ToRelative:CHECKED  THEN
      ASSIGN cInitialDir = fiRootDirectory:SCREEN-VALUE + "~/" + fiRelDirectory:SCREEN-VALUE 
             cinitialdir = REPLACE(cInitialDir,"/","~\").
   ELSE
      ASSIGN cInitialDir = fiSaveIn:SCREEN-VALUE 
             cinitialdir = REPLACE(cInitialDir,"/","~\").
   /* Get a filename using the adecomm/_getfile.p. */

   SYSTEM-DIALOG GET-FILE cfile
       TITLE    "Find File" 
       INITIAL-DIR cInitialDir
       FILTERS  "All Source(*.w~;*.p~;*.i)"      "*.w~;*.p~;*.i":U,
                "Windows(*.w)"                   "*.w":U,
                "Procedures(*.p)"                "*.p":U,
                "Includes(*.i)"                  "*.i":U,
                "XML Schema(*.xmc~;*.xmp~;*.xsd)" "*.xmc~;*.xmp~;*.xsd":U,
                "All Files(*.*)" "*.*"
        
       UPDATE lOK .


   IF lOK THEN 
   DO:
      ASSIGN cFile = REPLACE(cfile, "~\", "/")
            fiFileName:SCREEN-VALUE = ENTRY(NUM-ENTRIES(cFile,"/"), cFile, "/") 
            cDirectory              = SUBSTRING(cFile,1,R-INDEX(cFile,"/") - 1)
            NO-ERROR.
      IF NOT toRelative:CHECKED THEN
      DO:
        IF LOOKUP(cDirectory,coSaveIN:LIST-ITEMS) > 0 THEN
          ASSIGN coSaveIn:SCREEN-VALUE IN FRAME {&FRAME-NAME} = cDirectory 
                 fiSaveIn:SCREEN-VALUE                        = cDirectory 
                 NO-ERROR.
        ELSE DO:
          ASSIGN gcSaveInList   = cDirectory +  (IF gcSaveinList = "" THEN "" ELSE ",") 
                                             + gcSaveinList.
          setMaxSaveInList().

          ASSIGN coSaveIn:LIST-ITEMS = gcSaveInList
                 coSaveIN:SCREEN-VALUE = cDirectory
                 fiSaveIn:SCREEN-VALUE = cDirectory
                 gcLastSaveIn = coSaveIN:SCREEN-VALUE 
                 NO-ERROR.
           APPLY "VALUE-CHANGED":U TO coSaveIn.
        END.
      END.

      APPLY "VALUE-CHANGED":U TO fiFileName.
   END.
 END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buOk
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buOk diDialog
ON CHOOSE OF buOk IN FRAME diDialog /* Save */
DO:
  RUN validate-save IN THIS-PROCEDURE.
  IF RETURN-VALUE > "" THEN 
  DO:
     p_OK = NO.
     RETURN NO-APPLY.
  END.
  ELSE DO:
     ASSIGN p_OK = YES
            plRegisterObj = torelative:CHECKED
            gcLastSaveIn  = fiSaveIn:SCREEN-VALUE.

      IF LOOKUP(fiSaveIn:SCREEN-VALUE,gcSaveInList) = 0 THEN
      DO:
         ASSIGN  
           gcSaveInList   = fiSaveIn:SCREEN-VALUE +  (IF gcSaveinList = "" THEN "" ELSE ",") 
                                                   + gcSaveinList .
          setMaxSaveInList().
      END.

     RUN setuserProfile IN THIS-PROCEDURE.
  END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buSavein
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buSavein diDialog
ON CHOOSE OF buSavein IN FRAME diDialog
DO:
  DEFINE VARIABLE cDirectory AS CHARACTER  NO-UNDO.
  RUN getFolder("Directory", OUTPUT cDirectory).

  IF cDirectory <> "" THEN DO:
     IF LOOKUP(cDirectory,coSaveIN:LIST-ITEMS) > 0 THEN
       ASSIGN coSaveIn:SCREEN-VALUE IN FRAME {&FRAME-NAME} = cDirectory 
              fiSaveIn:SCREEN-VALUE                        = cDirectory 
              NO-ERROR.
     ELSE DO:
        ASSIGN gcSaveInList          = cDirectory +  (IF gcSaveinList = "" THEN "" ELSE ",") 
                                                  + gcSaveinList .
        setMaxSaveInList().

        ASSIGN coSaveIn:LIST-ITEMS = gcSaveInList
               coSaveIN:SCREEN-VALUE = cDirectory
               fiSaveIn:SCREEN-VALUE = cDirectory.

        APPLY "VALUE-CHANGED":U TO coSaveIn.
     END.
     ASSIGN gcLastSaveIn = coSaveIN:SCREEN-VALUE .
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME coModule
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL coModule diDialog
ON VALUE-CHANGED OF coModule IN FRAME diDialog /* Product module */
DO:
   DEFINE VARIABLE cLabel AS CHAR NO-UNDO.
   DEFINE VARIABLE i      AS INT  NO-UNDO.
   
   ASSIGN coPrcModule:SCREEN-VALUE = SELF:SCREEN-VALUE.
   RUN getRelativePath IN THIS-PROCEDURE.
   
   /* Find the label */
   LABEL-LOOP:
   DO i = 1 to NUM-ENTRIES(SELF:LIST-ITEM-PAIRS,CHR(3)) BY 2:
      IF ENTRY(i + 1,SELF:LIST-ITEM-PAIRS,CHR(3)) = SELF:SCREEN-VALUE THEN
      DO:
        clabel = ENTRY(i,SELF:LIST-ITEM-PAIRS,CHR(3)) .
        LEAVE LABEL-LOOP.
      END.  
   END.
     
   IF VALID-HANDLE(ghRepositoryDesignManager) AND clabel > "" THEN
    DYNAMIC-FUNCTION("setCurrentproductModule":U IN ghRepositoryDesignManager, 
                      clabel).
   RUN displayFullPathName IN THIS-PROCEDURE.
   RUN setFieldLayout.
   RUN OKToSave.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME coPrcModule
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL coPrcModule diDialog
ON VALUE-CHANGED OF coPrcModule IN FRAME diDialog /* Product module */
DO:
  DEFINE VARIABLE cLabel AS CHAR NO-UNDO.
  DEFINE VARIABLE i      AS INT  NO-UNDO.
  
  RUN getRelativePath IN THIS-PROCEDURE.
  
   /* Find the label */
  LABEL-LOOP:
  DO i = 1 to NUM-ENTRIES(SELF:LIST-ITEM-PAIRS,CHR(3)) BY 2:
     IF ENTRY(i + 1,SELF:LIST-ITEM-PAIRS,CHR(3)) = SELF:SCREEN-VALUE THEN
     DO:
       clabel = ENTRY(i,SELF:LIST-ITEM-PAIRS,CHR(3)) .
       LEAVE LABEL-LOOP.
     END.  
  END.
  
  IF VALID-HANDLE(ghRepositoryDesignManager) AND cLabel > "" THEN
    DYNAMIC-FUNCTION("setCurrentproductModule":U IN ghRepositoryDesignManager, clabel).
  RUN displayFullPathName IN THIS-PROCEDURE.
  RUN OKToSave.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME coSaveIn
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL coSaveIn diDialog
ON ENTRY OF coSaveIn IN FRAME diDialog /* Save in */
DO:
IF LAST-EVENT:LABEL = "TAB":U OR LAST-EVENT:LABEL = "SHIFT-TAB":U THEN 
      RETURN NO-APPLY. 
   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL coSaveIn diDialog
ON VALUE-CHANGED OF coSaveIn IN FRAME diDialog /* Save in */
DO:
   ASSIGN fiSaveIn:SCREEN-VALUE = SELF:SCREEN-VALUE.
   
   APPLY "VALUE-CHANGED":U TO fiSaveIn. 
   IF LAST-EVENT:LABEL <> "CURSOR-UP":U 
        AND LAST-EVENT:LABEL <> "CURSOR-DOWN":U THEN 
     APPLY "ENTRY":U TO fiSaveIn.
   RUN displayFullPathName.
   RUN OKtoSave IN THIS-PROCEDURE.
  ASSIGN gcLastSavein = SELF:SCREEN-VALUE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fiFileName
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiFileName diDialog
ON ANY-PRINTABLE OF fiFileName IN FRAME diDialog /* File name */
DO:
   IF LOOKUP(gcObjectType,"DynView,DynBrow,DynSDO,DynDataView":U) > 0 THEN 
   DO:
      IF CHR(LASTKEY) = "." THEN DO:
         BELL.
         RETURN NO-APPLY.
      END.
         
   END.
 /* DO not permit commas in field name */
  IF CHR(LASTKEY) = "," THEN  
  DO:
    BELL.
    RETURN NO-APPLY.
  END.
     
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiFileName diDialog
ON VALUE-CHANGED OF fiFileName IN FRAME diDialog /* File name */
DO:
IF ToRelative:CHECKED OR toRelative:HIDDEN THEN
     ASSIGN fiObjectName:SCREEN-VALUE = SELF:SCREEN-VALUE.
  IF ToPrc:CHECKED THEN
     ASSIGN fiPrcFileName:SCREEN-VALUE = SELF:SCREEN-VALUE 
                                          + IF gcObjectType = "DynSDO":U 
                                            THEN gcDataLogicSuffix
                                            ELSE gcCustomProcSuffix.

  RUN displayFullPathName IN THIS-PROCEDURE.
  RUN OKToSave IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fiPrcFilename
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiPrcFilename diDialog
ON VALUE-CHANGED OF fiPrcFilename IN FRAME diDialog /* File name */
DO:
  RUN displayFullPathName IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fiPrcLabel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiPrcLabel diDialog
ON MOUSE-SELECT-CLICK OF fiPrcLabel IN FRAME diDialog
DO:
  ASSIGN toPrc:CHECKED = NOT ToPrc:CHECKED.
  APPLY "VALUE-CHANGED":U TO toPrc.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fiRelativeLabel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiRelativeLabel diDialog
ON MOUSE-SELECT-CLICK OF fiRelativeLabel IN FRAME diDialog
DO:
  ASSIGN toRelative:CHECKED = NOT toRelative:CHECKED.
  APPLY "VALUE-CHANGED":U TO toRelative.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fiRootDirectory
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiRootDirectory diDialog
ON ANY-PRINTABLE OF fiRootDirectory IN FRAME diDialog /* Root directory */
DO:
/* Do not allow a double slash except at the beginning to allow UNC pathnames */
  IF SELF:CURSOR-OFFSET > 2 THEN
  DO:
     IF SUBSTRING(SELF:SCREEN-VALUE,SELF:CURSOR-OFFSET - 1,1) = "/" 
        OR SUBSTRING(SELF:SCREEN-VALUE,SELF:CURSOR-OFFSET - 1,1) = "~\"  THEN
     DO:
       IF KEYLABEL(LASTKEY) = "/" OR KEYLABEL(LASTKEY) = "~\" THEN
          RETURN NO-APPLY.
     END.
  END.
  ELSE DO:
     /* do not allow blanks in the first position */
     IF SELF:CURSOR-OFFSET = 1 AND LASTKEY = 32 THEN
        RETURN NO-APPLY.
     ELSE IF (KEYLABEL(LASTKEY) = "/" 
              OR KEYLABEL(LASTKEY) = "~\") 
              AND SELF:SELECTION-START = ? 
              AND (SUBSTRING(SELF:SCREEN-VALUE,1,2) = "//":U 
                   OR SUBSTRING(SELF:SCREEN-VALUE,1,2) = "~\\":U) 
          THEN RETURN NO-APPLY.
  END.

  IF KEYLABEL(LASTKEY) = "." AND SELF:CURSOR-OFFSET > 1 THEN
     RETURN NO-APPLY.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiRootDirectory diDialog
ON VALUE-CHANGED OF fiRootDirectory IN FRAME diDialog /* Root directory */
DO:
  FILE-INFO:FILE-NAME = SELF:SCREEN-VALUE NO-ERROR.
  IF FILE-INFO:FULL-PATHNAME = ?  THEN
    ASSIGN SELF:FGCOLOR   = 7.
  ELSE
    ASSIGN SELF:FGCOLOR   = ?.
   
   RUN displayFullPathName IN THIS-PROCEDURE.
   RUN OKToSave IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fiSaveIn
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiSaveIn diDialog
ON ANY-PRINTABLE OF fiSaveIn IN FRAME diDialog
DO:
/* Do not allow a double slash except at the beginning to allow UNC pathnames */
  IF SELF:CURSOR-OFFSET > 2 THEN
  DO:
     IF SUBSTRING(SELF:SCREEN-VALUE,SELF:CURSOR-OFFSET - 1,1) = "/" 
        OR SUBSTRING(SELF:SCREEN-VALUE,SELF:CURSOR-OFFSET - 1,1) = "~\"  THEN
     DO:
       IF KEYLABEL(LASTKEY) = "/" OR KEYLABEL(LASTKEY) = "~\" THEN
          RETURN NO-APPLY.
     END.
  END.
  ELSE DO:
     /* do not allow blanks in the first position */
     IF SELF:CURSOR-OFFSET = 1 AND LASTKEY = 32 THEN
        RETURN NO-APPLY.
     ELSE IF (KEYLABEL(LASTKEY) = "/" 
              OR KEYLABEL(LASTKEY) = "~\") 
              AND SELF:SELECTION-START = ? 
              AND (SUBSTRING(SELF:SCREEN-VALUE,1,2) = "//":U 
                   OR SUBSTRING(SELF:SCREEN-VALUE,1,2) = "~\\":U) 
          THEN RETURN NO-APPLY.
  END.

  IF KEYLABEL(LASTKEY) = "." AND SELF:CURSOR-OFFSET > 1 THEN
     RETURN NO-APPLY.



END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiSaveIn diDialog
ON F4 OF fiSaveIn IN FRAME diDialog
DO:
  DEFINE VARIABLE iretval AS INTEGER NO-UNDO.
  &GLOBAL-DEFINE CB_SHOWDROPDOWN 335

  RUN SendMessageA (INPUT  CoSaveIn:HWND,
                      {&CB_SHOWDROPDOWN},
                      1,   /* True */
                      0,
                      OUTPUT iretval
                   )  NO-ERROR .
  APPLY "ENTRY":U TO coSaveIn.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiSaveIn diDialog
ON VALUE-CHANGED OF fiSaveIn IN FRAME diDialog
DO:  
/* Check whether directory is valid */
  FILE-INFO:FILE-NAME = SELF:SCREEN-VALUE NO-ERROR.
  
  IF FILE-INFO:FULL-PATHNAME = ?  THEN
    ASSIGN SELF:FGCOLOR   = 7.
  ELSE
    ASSIGN SELF:FGCOLOR   = ?.
  
 RUN OKToSave IN THIS-PROCEDURE.
 RUN displayFullPathName.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME TogIndex
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL TogIndex diDialog
ON VALUE-CHANGED OF TogIndex IN FRAME diDialog /* Unique index */
DO:
  RUN SetValidateFrom.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME TogMan
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL TogMan diDialog
ON VALUE-CHANGED OF TogMan IN FRAME diDialog /* Mandatory */
DO:
   RUN SetValidateFrom.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ToPrc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ToPrc diDialog
ON VALUE-CHANGED OF ToPrc IN FRAME diDialog
DO:
  RUN setFieldLayout IN THIS-PROCEDURE.
  
  IF SELF:CHECKED THEN
     ASSIGN fiPrcFileName:SCREEN-VALUE = fiFileName:SCREEN-VALUE + gcCustomProcSuffix.
  ELSE
     ASSIGN fiPrcFileName:SCREEN-VALUE = ""
            fiPrcFullPath:SCREEN-VALUE = "".

  RUN displayFullPathName IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ToRelative
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ToRelative diDialog
ON VALUE-CHANGED OF ToRelative IN FRAME diDialog
DO:
  RUN setFieldLayout IN THIS-PROCEDURE.
 
  IF NOT SELF:CHECKED THEN 
  DO:
     ASSIGN coSaveIn:LIST-ITEMS       = gcSaveInList
            coSaveIn:SCREEN-VALUE     = gcLastSaveIn
            fiSaveIn:SCREEN-VALUE     = gcLastSaveIn
            fiObjectName:SCREEN-VALUE = ""
            fiObjectDesc:SCREEN-VALUE = ""
            NO-ERROR.
  END.
  APPLY "VALUE-CHANGED":U TO fiFileName.
  RUN OKtoSave IN THIS-PROCEDURE.
 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK diDialog 


/* ***************************  Main Block  *************************** */

/* Get AB current procedure and container tt record */
  RUN adeuib/_uibinfo.p (INPUT ?
                        ,INPUT "PROCEDURE ?"
                        ,INPUT "PROCEDURE":U
                        ,OUTPUT cProc-Recid
                        ).

  FIND BUFF_P WHERE RECID(BUFF_P) = INTEGER(cProc-Recid) NO-ERROR.
  
  FIND BUFF_U WHERE RECID(BUFF_U) = BUFF_P._u-recid NO-ERROR.
  FIND BUFF_C WHERE RECID(BUFF_C) = BUFF_U._x-recid NO-ERROR.
  FIND _U WHERE _U._TYPE EQ "FRAME":U AND
                 _U._WINDOW-HANDLE EQ BUFF_P._WINDOW-HANDLE AND
                 _U._STATUS NE "DELETED":U NO-ERROR.
  IF AVAIL _U THEN               
    FIND _C WHERE RECID(_C) = _U._x-recid.
 

  IF AVAILABLE BUFF_P THEN
     ASSIGN gcObjectType = BUFF_P.object_type_code.
  getRDMHandle().
  IF VALID-HANDLE(gshRepositoryManager) THEN
  cClassChildren = DYNAMIC-FUNCTION("getClassParentsFromDB":U IN gshRepositoryManager,
                                      gcObjectType).
  
  IF CAN-DO(cClassChildren,"DynView":U) THEN
     ASSIGN gcObjectType   = "DynView":U.
  ELSE 
  IF CAN-DO(cClassChildren,"DynBrow":U) THEN 
    ASSIGN gcObjectType   = "DynBrow":U.
  ELSE 
  IF CAN-DO(cClassChildren,"DynSDO":U) THEN 
    ASSIGN gcObjectType   = "DynSDO":U.
  ELSE 
  IF CAN-DO(cClassChildren,"DynDataView":U) THEN 
    ASSIGN gcObjectType   = "DynDataView":U.
  ELSE
    ASSIGN glStaticObject = YES.
              
{src/adm2/dialogmn.i}

PROCEDURE SendMessageA EXTERNAL "user32" :
  DEFINE INPUT  PARAMETER hwnd        AS LONG.
  DEFINE INPUT  PARAMETER umsg        AS LONG.
  DEFINE INPUT  PARAMETER wparam      AS LONG.
  DEFINE INPUT  PARAMETER lparam      AS LONG.
  DEFINE RETURN PARAMETER ReturnValue AS LONG.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buildcomboBoxes diDialog 
PROCEDURE buildcomboBoxes :
/*------------------------------------------------------------------------------
  Purpose:    Populates the product module combo-boxes. 
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 DEFINE VARIABLE cProductList AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cCurrentPM   AS CHARACTER  NO-UNDO.

 DO WITH FRAME {&FRAME-NAME}:

    /* Show the current product module and associated path. */
    /* Allow them to change the module and change the path accordingly */
   
   cProductList = DYNAMIC-FUNCTION("getproductModuleList":U IN ghRepositoryDesignManager,
                                   INPUT "product_module_Code":U,
                                   INPUT "product_module_code,product_module_description":U,
                                   INPUT "&1 // &2":U,
                                   INPUT CHR(3))   NO-ERROR.
   ASSIGN
     coModule:DELIMITER          = CHR(3)
     coModule:LIST-ITEM-PAIRS    = cProductList
     coPrcModule:DELIMITER       = CHR(3)
     coPrcModule:LIST-ITEM-PAIRS = cProductList
     cCurrentPM                  = DYNAMIC-FUNC("getCurrentProductModule":U IN ghRepositoryDesignManager) 
     cCurrentPM                  = IF INDEX(cCurrentPM,"//":U) > 0 THEN SUBSTRING(cCurrentPM,1,INDEX(cCurrentPM,"//":U) - 1)
                                                                   ELSE cCurrentPM
     coModule:SCREEN-VALUE      = TRIM(cCurrentPM)
     coPrcModule:SCREEN-VALUE = coModule:SCREEN-VALUE
     .
 END.
 /* Get the relative path for the currently displayed module and display it */
 RUN getRelativePath IN THIS-PROCEDURE.
                                                                           
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
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE displayFullPathName diDialog 
PROCEDURE displayFullPathName :
/*------------------------------------------------------------------------------
  Purpose:     Displays the full path name of the file and custom super 
               proc/data logic proc
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE cFullPath AS CHARACTER  NO-UNDO.

IF toRelative:CHECKED IN FRAME {&FRAME-NAME}  THEN
DO:
  ASSIGN cFullPath = (IF fiRootDirectory:SCREEN-VALUE <> "":U 
                     THEN (RIGHT-TRIM(RIGHT-TRIM(fiRootDirectory:SCREEN-VALUE,"~\":U),"/":U)  + "~/":U ) 
                     ELSE "":U)
                   + IF fiRelDirectory:SCREEN-VALUE <> "":U 
                     THEN (TRIM(fiRelDirectory:SCREEN-VALUE,"~\":U) + "~/":U ) 
                     ELSE "":U
         cFullPath  = RIGHT-TRIM(cFullPath, "/")
         fiFullPath:SCREEN-VALUE  =  cFullPath + "/" + TRIM(fiFilename:SCREEN-VALUE,"~/":U).
  
  IF LOOKUP(cFullPath,coSaveIN:LIST-ITEMS) > 0 THEN
     ASSIGN coSaveIn:SCREEN-VALUE IN FRAME {&FRAME-NAME} = cFullPath 
            fiSaveIN:SCREEN-VALUE = cFullPath NO-ERROR.
  ELSE DO:
     coSaveIN:ADD-LAST(cFullPath).
     coSaveIN:SCREEN-VALUE = cFullPath.
     fiSaveIN:SCREEN-VALUE = cFullPath.
  END.
END.
ELSE DO:
   IF fiSaveIn:SCREEN-VALUE = "." THEN
      ASSIGN FILE-INFO:FILE-NAME = "."
             cFullPath           = FILE-INFO:FULL-PATHNAME
             cFullPath           = REPLACE(cFullPath,"~\","/")
             cFullPath           = RIGHT-TRIM(REPLACE(cFullPath,"~\","/"),".":U)
             cFullPath           = RIGHT-TRIM(REPLACE(cFullPath,"~\","/"),"/":U)
             fiFullPath:SCREEN-VALUE = cFullPath
                                       +  (IF cFullPath > "" THEN "/":U ELSE "") 
                                       + TRIM(fiFilename:SCREEN-VALUE,"~/":U).
   ELSE
     ASSIGN fiFullPath:SCREEN-VALUE =  RIGHT-TRIM(RIGHT-TRIM(fiSaveIn:SCREEN-VALUE,"~\":U),"/") 
                                          + (IF RIGHT-TRIM(RIGHT-TRIM(fiSaveIn:SCREEN-VALUE,"~\":U),"/")  > "" THEN "/":U ELSE "") 
                                          + TRIM(fiFilename:SCREEN-VALUE,"~/":U).
END.
IF toPrc:CHECKED THEN
   fiPrcFullPath:SCREEN-VALUE IN FRAME {&FRAME-NAME} 
              = (IF fiRootDirectory:SCREEN-VALUE <> "":U 
                 THEN (RIGHT-TRIM(RIGHT-TRIM(fiRootDirectory:SCREEN-VALUE,"~\":U),"/")  + "~/":U ) 
                 ELSE "":U)
                    + (IF fiPrcRelDirectory:SCREEN-VALUE <> "":U AND coPrcModule:SENSITIVE
                       THEN (RIGHT-TRIM(fiPrcRelDirectory:SCREEN-VALUE,"~\":U) + "~/":U ) 
                       ELSE "":U)
                    + TRIM(fiPrcFilename:SCREEN-VALUE,"~/":U)
                        .
ELSE
   fiPrcFullPath:SCREEN-VALUE = "".

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
  DISPLAY fiFileName fiSaveIn coSaveIn ToRelative fiObjectName fiObjectDesc 
          fiRootDirectory coModule fiRelDirectory fiFullPath toWeb toDesign 
          toClient toServer ToPrc coPrcModule fiPrcRelDirectory fiPrcFilename 
          fiprcFullPath TogUseNoUndo TogMan TogIndex fiRelativeLabel fiPrcLabel 
          fiFlag 
      WITH FRAME diDialog.
  ENABLE rect-s RECTprc RECTRepo fiFileName buFile fiSaveIn coSaveIn buSavein 
         ToRelative fiObjectName fiObjectDesc buBrowse fiRootDirectory coModule 
         fiFullPath toWeb toDesign toClient toServer ToPrc coPrcModule 
         fiPrcFilename fiprcFullPath TogUseNoUndo TogMan TogIndex buCancel 
         fiRelativeLabel fiPrcLabel fiFlag 
      WITH FRAME diDialog.
  {&OPEN-BROWSERS-IN-QUERY-diDialog}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE extractRootDir diDialog 
PROCEDURE extractRootDir :
/*------------------------------------------------------------------------------
  Purpose:     Extracts the root directory and the filename (without path)
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER pcSaveAsFile AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER pcPath       AS CHARACTER  NO-UNDO.
DEFINE OUTPUT PARAMETER pcRoot       AS CHARACTER  NO-UNDO.
DEFINE OUTPUT PARAMETER pcFile       AS CHARACTER  NO-UNDO.

DEFINE VARIABLE iPos AS INTEGER    NO-UNDO.

IF pcSaveAsFile = "" OR pcSaveAsFile = ? THEN RETURN.


ASSIGN pcSaveAsFile = REPLACE(pcSaveAsFile,"~\","/")
       pcPath       = REPLACE(pcPath,"~\","/").

IF (pcPath = ? OR pcPath = "") AND NUM-ENTRIES(pcSaveAsFile,"/":U) > 1  THEN 
DO:
   ASSIGN pcRoot = SUBSTRING(pcSaveAsFile, 1, R-INDEX(pcSaveAsFile,"/":U) - 1)
          pcFile = ENTRY(NUM-ENTRIES(pcSaveAsFile,"/":U), pcSaveASFile,"/":U)
          NO-ERROR.
   RETURN.
END.


iPos = INDEX(pcSaveAsFile,pcPath).

IF iPos > 0 THEN
   ASSIGN pcRoot = SUBSTRING(pcSaveAsFile, 1,iPos - 1)
          pcFile = SUBSTRING(pcSaveasFile,ipos + LENGTH(pcPath) + 1, -1)
          NO-ERROR.
ELSE
   pcFile = pcSaveAsFile.







END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getFolder diDialog 
PROCEDURE getFolder :
/*------------------------------------------------------------------------------
  Purpose:     Use the COM interface Shell to browse for a folder
  Parameters:  pcTitle   Name of title to appear in browse folder
               pcPath    (OUTPUT) Returned path
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcTitle AS CHARACTER NO-UNDO.
  DEFINE OUTPUT PARAMETER pcPath  AS CHARACTER NO-UNDO.
  
  DEFINE VARIABLE chServer AS COM-HANDLE NO-UNDO. /* shell application */
  DEFINE VARIABLE chFolder AS COM-HANDLE NO-UNDO.
  DEFINE VARIABLE chParent AS COM-HANDLE NO-UNDO.
  DEFINE VARIABLE lvFolder AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lvCount  AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hFrame   AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hWin     AS HANDLE     NO-UNDO.

  hFrame = FRAME {&FRAME-NAME}:HANDLE.
  hWin   = hFrame:WINDOW.
  
  /* create Shell Automation object */
  CREATE 'Shell.Application' chServer.

  IF NOT VALID-HANDLE(chServer) THEN 
      RETURN "":u. /* automation object not present on system */
 
  ASSIGN
      chFolder = chServer:BrowseForFolder(hWin:HWND,pcTitle,3).

  /* see if user has selected a valid folder */
   IF VALID-HANDLE(chFolder) AND chFolder:SELF:IsFolder THEN 
      ASSIGN pcPath   = chFolder:SELF:Path.
   ELSE
      ASSIGN pcPath   = "":U.

  
  
  RELEASE OBJECT chParent NO-ERROR.
  RELEASE OBJECT chFolder NO-ERROR.
  RELEASE OBJECT chServer NO-ERROR.
  
  ASSIGN
    chParent = ?
    chFolder = ?
    chServer = ?
    .
  
  ASSIGN pcPath = RIGHT-TRIM(REPLACE(LC(pcPath),"~\":U,"/":U),"~/":U).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getRelativePath diDialog 
PROCEDURE getRelativePath :
/*------------------------------------------------------------------------------
  Purpose:     Find the relative path for the product module and data logic/
               custom super proc file 
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cCalcRelativePath     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cCalcRootDir          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cCalcRelPathSCM       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cCalcFullPath         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cCalcObject           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cCalcFile             AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cCalcError            AS CHARACTER  NO-UNDO. 

  DO WITH FRAME {&FRAME-NAME}:
     /* Get the relative directory for the Object's product module */
      RUN calculateObjectPaths IN gshRepositoryManager
                ("",  /* ObjectName */          0.0, /* Object Obj */      
                 "",  /* Object Type */         coModule:SCREEN-VALUE,  /* Product Module Code */
                 "", /* Param */                "",
                 OUTPUT cCalcRootDir,           OUTPUT cCalcRelativePath,
                 OUTPUT cCalcRelPathSCM,        OUTPUT cCalcFullPath,
                 OUTPUT cCalcObject,            OUTPUT cCalcFile,
                 OUTPUT cCalcError).
      IF cCalcError > "" THEN
      DO:
        MESSAGE cCalcError VIEW-AS ALERT-BOX.
        RETURN.
      END.
      IF cCalcRelPathSCM > "" THEN
         cCalcRelativePath = cCalcRelPathSCM.    
     ASSIGN  fiRelDirectory:SCREEN-VALUE = cCalcRelativePath NO-ERROR.
        
     /* Get the relative directory for the product module */
     IF coModule:SCREEN-VALUE =  coPrcModule:SCREEN-VALUE THEN
        ASSIGN fiPrcRelDirectory:SCREEN-VALUE = fiRelDirectory:SCREEN-VALUE NO-ERROR.
     ELSE DO:
        /* Get the relative directory for the DLP/Custom Proc product module */
        RUN calculateObjectPaths IN gshRepositoryManager
                  ("",  /* ObjectName */          0.0, /* Object Obj */      
                   "",  /* Object Type */         coPrcModule:SCREEN-VALUE,  /* Product Module Code */
                   "", /* Param */                "",
                   OUTPUT cCalcRootDir,           OUTPUT cCalcRelativePath,
                   OUTPUT cCalcRelPathSCM,        OUTPUT cCalcFullPath,
                   OUTPUT cCalcObject,            OUTPUT cCalcFile,
                   OUTPUT cCalcError).
        IF cCalcError > "" THEN
        DO:
          MESSAGE cCalcError VIEW-AS ALERT-BOX.
          RETURN.
        END.
        IF cCalcRelPathSCM > "" THEN
           cCalcRelativePath = cCalcRelPathSCM.    
        ASSIGN fiPrcRelDirectory:SCREEN-VALUE = cCalcRelativePath NO-ERROR.
     END.
     
  END.
           
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
  /* Hide object until initialized */
  {set HideonInit YES}.
  
  
  RUN SUPER.

  /* Build the module combo boxes */
  RUN buildComboBoxes IN THIS-PROCEDURE.

  /* Set various initial data such as Root directory, the filename and the custom 
     super proc info. Also gets initial settings from user profile */
  RUN setInitialValues IN THIS-PROCEDURE.
  
  /* Modify the layout (Hide/view fields, rename labels ) dependent on the object type being saved. */
  RUN setLayoutView IN THIS-PROCEDURE.
  
  /* Enable/disable fields based on whether field is being registred, or custom super /data logic proc is being created */
  RUN setFieldLayout IN THIS-PROCEDURE.

  /* Display the fullpath information */
  RUN displayFullPathName IN THIS-PROCEDURE.
  
  FRAME {&FRAME-NAME}:TITLE =  (IF plSaveAS = TRUE
                               THEN "Save as"
                               ELSE "Save")
                              + IF BUFF_P.object_type_code <> "" 
                                 THEN " (" + BUFF_P.object_type_code + ")"
                                 ELSE " (" + BUFF_P._TYPE + ")".
  
  RUN viewObject.
  APPLY "ENTRY":U to fiFileName IN FRAME {&FRAME-NAME}.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE OkToSave diDialog 
PROCEDURE OkToSave :
/*------------------------------------------------------------------------------
  Purpose:     Checks whether the Save button should be enabled.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DO WITH FRAME {&FRAME-NAME}:
  IF fiFileName:SCREEN-VALUE = "" THEN
  DO:
     buOK:SENSITIVE = FALSE.
     RETURN.
  END.

  IF fiSaveIn:SENSITIVE AND (fiSaveIn:FGCOLOR <> ? OR fiRootDirectory:FGCOLOR <> ?) THEN
  DO:
     buOK:SENSITIVE = FALSE.
     RETURN.
  END.
      
  IF coModule:SENSITIVE AND coModule:SCREEN-VALUE = ?  THEN
  DO:
     buOK:SENSITIVE = FALSE.
     RETURN.
  END.

  IF coPrcModule:SENSITIVE AND coPrcModule:SCREEN-VALUE = ?  THEN
  DO:
     buOK:SENSITIVE = FALSE.
     RETURN.
  END.

  buOK:SENSITIVE = TRUE.

  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE SetFieldLayout diDialog 
PROCEDURE SetFieldLayout :
/*------------------------------------------------------------------------------
  Purpose:     Set the sensitive attribute based on field settings
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE cFullPath AS CHARACTER  NO-UNDO.

DO WITH FRAME {&FRAME-NAME}:

/* set the sensitivity of fields  */

IF toRelative:CHECKED OR toRelative:HIDDEN THEN
DO:
   ASSIGN coModule:SENSITIVE        = TRUE
          toPrc:SENSITIVE           = TRUE
          fiRootDirectory:SENSITIVE = TRUE
          buBrowse:SENSITIVE        = TRUE
          coSaveIN:SENSITIVE        = FALSE
          fiSaveIn:SENSITIVE        = FALSE
          buSaveIN:SENSITIVE        = FALSE
          fiObjectName:SENSITIVE    = TRUE
          fiObjectDesc:SENSITIVE    = TRUE
          toWeb:SENSITIVE           = TRUE
          toClient:SENSITIVE        = TRUE
          toServer:SENSITIVE        = TRUE
          toDesign:SENSITIVE        = TRUE
          fiSaveIn:FGCOLOR          = ?.          
END.
ELSE
  ASSIGN coModule:SENSITIVE         = FALSE
          toPrc:SENSITIVE           = FALSE
          toPrc:CHECKED             = FALSE
          fiRootDirectory:SENSITIVE = FALSE
          fiRootDirectory:FGCOLOR   = ?
          buBrowse:SENSITIVE        = FALSE
          coSaveIN:SENSITIVE        = TRUE
          fiSaveIn:SENSITIVE        = TRUE
          buSaveIN:SENSITIVE        = TRUE
          fiObjectName:SENSITIVE    = FALSE
          fiObjectDesc:SENSITIVE    = FALSE
          toWeb:SENSITIVE           = FALSE
          toClient:SENSITIVE        = FALSE
          toServer:SENSITIVE        = FALSE
          toDesign:SENSITIVE        = FALSE.
          
IF toPrc:CHECKED THEN
   ASSIGN coPrcModule:SENSITIVE   = TRUE
          fiPrcFilename:SENSITIVE = TRUE.
ELSE
  ASSIGN coPrcModule:SENSITIVE    = FALSE
         fiPrcFilename:SENSITIVE  = FALSE
         fiPrcFullPath:SCREEN-VALUE = "".
END.


coSavein:MOVE-TO-BOTTOM().
fiSaveinRect:MOVE-TO-TOP().
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setInitialValues diDialog 
PROCEDURE setInitialValues :
/*------------------------------------------------------------------------------
  Purpose:     Assigns the Root directory, the filename and the custom 
               super proc info. Also gets initial settings from user profile
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 DEFINE VARIABLE cRelativeDirectory  AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cRootDirectory      AS CHARACTER  NO-UNDO.                                    
 DEFINE VARIABLE cFile               AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cPreparedFile       AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cFileSuper          AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cFileDataLog        AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE imodule             AS INTEGER    NO-UNDO.
 DEFINE VARIABLE cModuleEntry        AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE rRowID              AS ROWID      NO-UNDO.
 DEFINE VARIABLE cProfileData        AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cTableName          AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cNewListItems       AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cDirectory          AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE iLoop               AS INTEGER    NO-UNDO.
 DEFINE VARIABLE cValidateFrom       AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cNewObjectName      AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cNewObjectExt       AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cEntity             AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cError              AS CHARACTER  NO-UNDO.
 
 ASSIGN cRootDirectory = DYNAMIC-FUNCTION("getSessionRootDirectory":U) NO-ERROR.
                                            

ASSIGN fiRootDirectory:SCREEN-VALUE IN FRAME {&FRAME-NAME} = cRootDirectory
       fiRootDirectory:SCREEN-VALUE = RIGHT-TRIM(fiRootDirectory:SCREEN-VALUE,".":U) /* Right trim . for UNC pathnames */
       fiRootDirectory:SCREEN-VALUE = RIGHT-TRIM(fiRootDirectory:SCREEN-VALUE,"/":U)
       NO-ERROR.
/* Set the data logic proc and custom super proc */
IF AVAILABLE BUFF_C THEN
DO:
   IF LOOKUP(gcObjectType,"DynView,DynBrow,DynDataView":U) > 0 THEN  
   DO:
      /* Set the super procedure values */
     RUN extractRootDir (BUFF_C._CUSTOM-SUPER-PROC, BUFF_C._CUSTOM-SUPER-PROC-PATH, OUTPUT cRootDirectory, OUTPUT cFileSuper).
     ASSIGN fiPrcFullPath:SCREEN-VALUE = BUFF_C._CUSTOM-SUPER-PROC
            fiPrcFileName:SCREEN-VALUE = cFileSuper
            cFile                      = cFileSuper
            toPrc:CHECKED              = IF cFileSuper > "" THEN TRUE ELSE FALSE
            NO-ERROR.
     IF BUFF_C._CUSTOM-SUPER-PROC-PMOD > "" THEN
          ASSIGN coPrcModule:SCREEN-VALUE = coModule:SCREEN-VALUE.
   END.
   ELSE IF LOOKUP(gcObjectType,"DynSDO":U) > 0 THEN  
   DO:
      /* Set the data logic procedures */
     RUN extractRootDir (BUFF_C._DATA-LOGIC-PROC, BUFF_C._DATA-LOGIC-PROC-PATH, OUTPUT cRootDirectory, OUTPUT cFileDataLog).
     ASSIGN fiPrcFullPath:SCREEN-VALUE = BUFF_C._DATA-LOGIC-PROC-PATH
            fiPrcFileName:SCREEN-VALUE = cFileDataLog
            cFile                      = cFileDataLog
            NO-ERROR.
     IF BUFF_C._DATA-LOGIC-PROC-PMOD > "" THEN
          ASSIGN coPrcModule:SCREEN-VALUE = coModule:SCREEN-VALUE.
   END.
END.

/* Get profile data for the Save in combo-box list */
ASSIGN rRowID = ?.
RUN getProfileData IN gshProfileManager ( INPUT        "General":U,
                                          INPUT        "DispRepos":U,
                                          INPUT        "SaveInDef":U,
                                          INPUT        NO,
                                          INPUT-OUTPUT rRowid,
                                           OUTPUT cProfileData).
IF cProfileData > "" AND NUM-ENTRIES(cProfileData,CHR(3)) = 2 THEN
DO:
  /* Ensure that the directories are valid */
   DO iLoop = 1 TO NUM-ENTRIES(ENTRY(1,cProfileData,CHR(3))):
         cDirectory = ENTRY(iloop, ENTRY(1,cProfileData,CHR(3))).
         FILE-INFO:FILE-NAME = cDirectory.
         IF FILE-INFO:FULL-PATHNAME = ? 
            OR INDEX(FILE-INFO:FILE-TYPE,"D") = 0 
            OR INDEX(FILE-INFO:FILE-TYPE,"W") = 0 THEN NEXT.
         cNewListItems = cNewListitems + (IF cNewListitems = "" THEN "" ELSE ",") 
                                       + ENTRY(iloop, ENTRY(1,cProfileData,CHR(3))).
   END.
   ASSIGN coSaveIn:LIST-ITEMS   = cNewListItems
          coSaveIn:SCREEN-VALUE = IF LOOKUP(ENTRY(2,cProfileData,CHR(3)), cNewListItems) > 0
                                  THEN ENTRY(2,cProfileData,CHR(3)) ELSE ENTRY(1,cNewListitems)
          fiSaveIn:SCREEN-VALUE = coSaveIn:SCREEN-VALUE
          gcSaveInList          = coSaveIn:LIST-ITEMS
          gcLastSaveIn          = coSaveIn:SCREEN-VALUE
          NO-ERROR.
                              
END.
IF AVAILABLE BUFF_P THEN
DO:
   /* Set the filaname, object name and SaveIn directory list */
   RUN extractRootDir (BUFF_P._save-as-file, BUFF_P._Save-as-path, OUTPUT cRootDirectory, OUTPUT cFile).
   /* Get the entity required for the prepareObject */
   FIND FIRST BUFF_U WHERE BUFF_U._WINDOW-HANDLE = BUFF_P._WINDOW-HANDLE
                       AND BUFF_U._TABLE > "" NO-ERROR.
   IF AVAIL BUFF_U THEN
      cEntity = BUFF_U._TABLE.
   cError = DYNAMIC-FUNCTION("prepareObjectName":U in ghRepositoryDesignManager,
                              cFile,                     /*Suggested Name */
                              "{&DEFAULT-RESULT-CODE}",  /* Result Code */
                              "",                        /* Additional string - suffix */
                              "DEFAULT":U,               /* Default or Save */
                              BUFF_P.object_type_code,   /* Object Type */
                              cEntity,                   /* Entity */
                              coModule:SCREEN-VALUE, /* Module */
                              OUTPUT cNewObjectName,     
                              OUTPUT cNewObjectExt ).
   IF cError > "" THEN
      MESSAGE cError
         VIEW-AS ALERT-BOX INFO BUTTONS OK.
   IF cNewObjectName > "" THEN
      cFile = cNewObjectName + (IF cNewObjectExt > "" THEN "." ELSE "") + TRIM(cNewObjectExt).

   ASSIGN cFile                        = RIGHT-TRIM(cFile,"/":U)
          fiFileName:SCREEN-VALUE      = cFile
          fiObjectDesc:SCREEN-VALUE    = BUFF_P.object_description
          buOK:SENSITIVE               = IF fiFileName:SCREEN-VALUE > "" THEN TRUE ELSE FALSE
          NO-ERROR.
          
    /* Set the default filename and description for dynamic objects */
   IF LOOKUP(gcObjectType,"DynView,DynBrow,DynSDO,DynDataView":U) > 0 AND NOT plSaveAs THEN  
   DO:
      IF gcObjectType = 'DynDataView':U THEN
      DO:
        /* just remove the extension as it messes up the default 
           super procedure name setting */
        IF INDEX(cFile,'.') > 0 THEN
        DO:
          ENTRY(NUM-ENTRIES(cFile,'.'),cFile,'.') = ''.
          ASSIGN fiFilename:SCREEN-VALUE = RIGHT-TRIM(cFile,'.').
        END.
      END.
      ELSE 
      DO:
        ASSIGN cPreparedFile = getSDOFLA(OUTPUT cTableName) + cfile.
        IF cNewObjectName = "" AND (cFile = gcDynViewPrefix AND gcObjectType = "DynView":U)
        OR (cFile = gcDynBrowPrefix AND gcObjectType = "DynBrow":U)
        OR (cFile = gcDynSDOPrefix AND gcObjectType = "DynSDO":U) THEN
          /* get the FLA prefix from the entity tables */
          ASSIGN fiFileName:SCREEN-VALUE  = cPreparedFile.
      END.

      IF cTableName = ? OR cTableName = "" THEN 
         cTableName = fiFileName:SCREEN-VALUE.

      IF BUFF_P.object_description = "" OR BUFF_P.object_description = ?  THEN
         ASSIGN  fiObjectDesc:SCREEN-VALUE = IF gcObjectType = "DynView":U 
                                             THEN "Dynamic Viewer for " + cTableName
                                             ELSE IF gcObjectType = "DynBrow":U
                                                  THEN "Dynamic Browse for " + cTableName
                                                  ELSE IF gcObjectType = "DynSDO":U
                                                       THEN "Dynamic SDO for " + cTableName
                                                       ELSE "".
   END.
   
       /* Add the file's directory to the saveIn combo list  */
   IF (LOOKUP(cRootDirectory,coSaveIn:LIST-ITEMS) = 0 OR coSaveIn:LIST-ITEMS = ?)
          AND cRootDirectory <> "" AND  cRootDirectory <> ? THEN
      coSaveIn:ADD-LAST(cRootDirectory).
   /* Add the root directory to the saveIn combo list if not already there */
   IF (LOOKUP(fiRootDirectory:SCREEN-VALUE,coSaveIn:LIST-ITEMS) = 0 OR coSaveIn:LIST-ITEMS = ?)
          AND fiRootDirectory:SCREEN-VALUE <> "" AND  fiRootDirectory:SCREEN-VALUE <> ? THEN
      coSaveIn:ADD-LAST(fiRootDirectory:SCREEN-VALUE).
 
   IF cRootDirectory > "" THEN
      ASSIGN coSaveIn:SCREEN-VALUE    = cRootDirectory
             fiSaveIn:SCREEN-VALUE    = cRootDirectory.
   IF coSaveIn:SCREEN-VALUE = "" OR coSaveIn:SCREEN-VALUE = ? THEN
      ASSIGN coSaveIn:SCREEN-VALUE = fiRootDirectory:SCREEN-VALUE 
             fiSaveIn:SCREEN-VALUE = fiRootDirectory:SCREEN-VALUE NO-ERROR.

   ASSIGN gcSaveInList          = coSaveIn:LIST-ITEMS
          gcLastSaveIn          = coSaveIn:SCREEN-VALUE.

   /* Set deployment options */

   ASSIGN toWeb:CHECKED    = (LOOKUP("WEB":U, BUFF_P.deployment_type) > 0)
          toServer:CHECKED = (LOOKUP("SRV":U, BUFF_P.deployment_type) > 0)
          toClient:CHECKED = (LOOKUP("CLN":U, BUFF_P.deployment_type) > 0)
          toDesign:CHECKED = (BUFF_P.design_only = YES).
END.

/* Get profile data for the Register Object checkbox */
ASSIGN rRowID = ?.
RUN getProfileData IN gshProfileManager ( INPUT        "General":U,
                                          INPUT        "DispRepos":U,
                                          INPUT        "RegisterDef":U,
                                          INPUT        NO,
                                          INPUT-OUTPUT rRowid,
                                           OUTPUT cProfileData).

IF cProfileData = "yes":U OR cProfileData = "true":U THEN
DO:
  ASSIGN toRelative:CHECKED = FALSE.
  APPLY "VALUE-CHANGED":U TO toRelative.
END.


/* Get profile data for the Data Logic/Super proc checkbox */
IF gcObjectType = "DynView":U OR gcObjectType = "DynBrow":U OR gcObjectType = "DynDataView" THEN
DO:
   ASSIGN rRowID = ?.
   RUN getProfileData IN gshProfileManager (INPUT        "General":U,
                                            INPUT        "DispRepos":U,
                                            INPUT        "SuperDef":U,
                                            INPUT        NO,
                                            INPUT-OUTPUT rRowid,
                                            OUTPUT cProfileData).
   
    IF cProfileData = "yes":U OR cProfileData = "true":U THEN
    DO:
       toPrc:CHECKED = TRUE.
       ASSIGN fiPrcFileName:SCREEN-VALUE = fiFileName:SCREEN-VALUE + gcCustomProcSuffix.
    END.
 
END.
ELSE IF gcObjectType = "DynSDO":U THEN
DO:
   /* get the Mandatory and Index flags used in the Object generator */
   ASSIGN cValidateFrom = DYNAMIC-FUNCTION("getSessionParam":U IN TARGET-PROCEDURE,
                                                INPUT "OG_ValidateFrom":U).
    IF cValidateFrom EQ ? THEN
        ASSIGN cValidateFrom = "*":U.

   IF CAN-DO(cValidateFrom,"INDEX":U) THEN
      TogIndex:CHECKED = TRUE.
   IF CAN-DO(cValidateFrom,"Mandatory":U) THEN
      TogMan:CHECKED = TRUE.

   IF fiPrcFileName:SCREEN-VALUE = "" THEN
    ASSIGN toPrc:CHECKED = TRUE
           fiPrcFileName:SCREEN-VALUE = fiFileName:SCREEN-VALUE + gcDataLogicSuffix.
END.
ASSIGN fiObjectName:SCREEN-VALUE = getRegObjName(fiFileName:SCREEN-VALUE).

IF fiObjectName:SCREEN-VALUE ="" THEN
   buOK:SENSITIVE = FALSE.

IF gcObjectType = "DynSDO":U AND AVAILABLE(BUFF_P) THEN
DO:
  FIND _U WHERE RECID(_U) = BUFF_P._u-recid NO-ERROR.
  IF AVAILABLE _U THEN
  DO:
    FIND BUFF_U WHERE BUFF_U._TYPE = "QUERY":U AND BUFF_U._WINDOW-HANDLE = _U._WINDOW-HANDLE NO-ERROR.
    IF AVAILABLE(BUFF_U) THEN
    DO:
      CheckForLOB: 
      FOR EACH _BC WHERE _BC._x-recid = RECID(BUFF_U) :
        IF LOOKUP(_BC._DATA-TYPE, "CLOB,BLOB":U) > 0 THEN
        DO:
          TogUseNoUndo:SENSITIVE = FALSE.
          LEAVE CheckForLOB.
        END.  /* if includes BLOB or CLOB */    
      END.  /* each _BC */
    END.  /* if available buff_u */
  END.  /* if available _u */
END.  /* if dynsdo */


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setLayoutView diDialog 
PROCEDURE setLayoutView :
/*------------------------------------------------------------------------------
  Purpose:     Relays out the fields depending on the obejct type.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 DEFINE VARIABLE hSide AS HANDLE     NO-UNDO.

 DO WITH FRAME {&FRAME-NAME}:
  IF LOOKUP(gcObjectType,"DynView,DynBrow,DynSDO,DynDataView":U) > 0 THEN 
     ASSIGN toRelative:CHECKED           = TRUE
            toRelative:HIDDEN            = TRUE
            fiRelativeLabel:COL          = fiRelativeLabel:COL - 3
            fiRelativeLabel:WIDTH        = FONT-TABLE:GET-TEXT-WIDTH(fiRelativeLabel:SCREEN-VALUE)
            fiFileName:LABEL             = "Object name"
            NO-ERROR.

  IF LOOKUP(gcObjectType,"DynView,DynBrow,DynDataView":U) > 0 THEN
    ASSIGN fiPrcLabel:SCREEN-VALUE = "Create custom super procedure"
           fiPrcLabel:WIDTH        = FONT-TABLE:GET-TEXT-WIDTH(fiPrcLabel:SCREEN-VALUE)
           fiFlag:HIDDEN               = TRUE
           TogMan:HIDDEN               = TRUE
           TogIndex:HIDDEN             = TRUE
           TogUseNoUndo:HIDDEN         = TRUE.
           
           
  ELSE IF LOOKUP(gcObjectType,"DynSDO":U) > 0 THEN 
   ASSIGN fiPrcLabel:SCREEN-VALUE = "Create data logic procedure"
          ToPrc:CHECKED           = TRUE
          ToPrc:HIDDEN            = TRUE
          fiPrcLabel:WIDTH        = FONT-TABLE:GET-TEXT-WIDTH(fiPrcLabel:SCREEN-VALUE)  
          fiPrcLabel:COL          = fiprcLabel:COL - 2
          RectPrc:COL             = rectPRC:COL - 2
          RectPrc:WIDTH           = rectPRC:WIDTH + 2
          .
  ELSE
     ASSIGN fiprcLabel:HIDDEN           = TRUE
            toPrc:CHECKED               = FALSE
            toPrc:HIDDEN                = TRUE
            coPrcModule:HIDDEN          = TRUE
            fiPrcRelDirectory:HIDDEN    = TRUE
            fiPrcFilename:HIDDEN        = TRUE
            fiPrcFullPath:HIDDEN        = TRUE
            fiFlag:HIDDEN               = TRUE
            TogMan:HIDDEN               = TRUE
            TogIndex:HIDDEN             = TRUE
            TogUseNoUndo:HIDDEN         = TRUE
            RectPrc:HIDDEN              = TRUE
            RectRepo:HEIGHT             = 9.24
            buOK:ROW                    = RectRepo:ROW + RectRepo:HEIGHT + .3
            buCancel:ROW                = buOK:ROW + buOK:HEIGHT + .2
            FRAME {&FRAME-NAME}:HEIGHT  = buCancel:ROW + buCancel:HEIGHT + .7.
  
  /* We only prompt for deployment information on static objects */
  IF NOT glStaticObject  THEN 
      /* Hide the fields */
      ASSIGN toWeb:HIDDEN     = YES
             toServer:HIDDEN  = YES
             toClient:HIDDEN  = YES
             toDesign:HIDDEN  = YES
      /* ...and now move the fields below them up a little bit. */
             toPrc:ROW                   = toPrc:ROW - 2.62
             fiPrcLabel:ROW              = fiPrcLabel:ROW - 2.62
             coPrcModule:ROW             = coPrcModule:ROW - 2.62
             hSide                       = coPrcModule:SIDE-LABEL-HANDLE
             hSide:ROW                   = coPrcModule:ROW
             fiPrcRelDirectory:ROW       = fiPrcRelDirectory:ROW - 2.62
             hSide                       = fiPrcRelDirectory:SIDE-LABEL-HANDLE
             hSide:ROW                   = fiPrcRelDirectory:ROW
             fiPrcFilename:ROW           = fiPrcFilename:ROW - 2.62
             hSide                       = fiPrcFilename:SIDE-LABEL-HANDLE
             hSide:ROW                   = fiPrcFilename:ROW
             fiPrcFullPath:ROW           = fiPrcFullPath:ROW - 2.62
             hSide                       = fiPrcFullPath:SIDE-LABEL-HANDLE
             hSide:ROW                   = fiPrcFullPath:ROW
             rectPrc:ROW                 = rectPrc:ROW - 2.62
             rectRepo:HEIGHT             = rectRepo:HEIGHT - 2.62
             fiFlag:ROW                  = fiFlag:ROW  - 2.62
             togMan:ROW                  = togMan:ROW  - 2.62
             togIndex:ROW                = togIndex:ROW  - 2.62
             togUseNoUndo:ROW            = togUseNoUndo:ROW - 2.62
             buOK:ROW                    = RectRepo:ROW + RectRepo:HEIGHT + .3
             buCancel:ROW                = buOK:ROW + buOK:HEIGHT + .2
             FRAME {&FRAME-NAME}:HEIGHT  = buCancel:ROW + buCancel:HEIGHT + .7.

END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setUserProfile diDialog 
PROCEDURE setUserProfile :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE cProfileData AS CHARACTER  NO-UNDO.
ASSIGN cProfileData = STRING(toRelative:CHECKED IN FRAME {&FRAME-NAME}).


RUN setProfileData IN gshProfileManager (INPUT "General":U,        /* Profile type code */
                                         INPUT "DispRepos":U,  /* Profile code */
                                         INPUT "RegisterDef":U,     /* Profile data key */
                                         INPUT ?,                 /* Rowid of profile data */
                                         INPUT cProfileData,      /* Profile data value */
                                         INPUT NO,                /* Delete flag */
                                         INPUT "PER":u).          /* Save flag (permanent) */

cProfileData = gcSaveInList + CHR(3) + gcLastSaveIn.

RUN setProfileData IN gshProfileManager (INPUT "General":U,        /* Profile type code */
                                         INPUT "DispRepos":U,  /* Profile code */
                                         INPUT "SaveInDef":U,     /* Profile data key */
                                         INPUT ?,                 /* Rowid of profile data */
                                         INPUT cProfileData,      /* Profile data value */
                                         INPUT NO,                /* Delete flag */
                                         INPUT "PER":u).          /* Save flag (permanent) */



IF gcObjectType = "DynView":U OR gcObjectType = "DynBrow":U THEN
DO:
   ASSIGN cProfileData = STRING(toPrc:CHECKED ).
   RUN setProfileData IN gshProfileManager 
           (INPUT "General":U,        /* Profile type code */
            INPUT "DispRepos":U,  /* Profile code */
            INPUT "SuperDef":U,     /* Profile data key */
            INPUT ?,                 /* Rowid of profile data */
            INPUT cProfileData,      /* Profile data value */
            INPUT NO,                /* Delete flag */
            INPUT "PER":u).          /* Save flag (permanent) */
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setValidateFrom diDialog 
PROCEDURE setValidateFrom :
/*------------------------------------------------------------------------------
  Purpose:  Sets the validatefrom flags used in the object generatror   
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE cValidateFrom AS CHARACTER  NO-UNDO.

DO WITH FRAME {&FRAME-NAME}:
ASSIGN
  cValidateFrom = (IF TogMan:CHECKED THEN "Mandatory":U ELSE "")
  cValidateFrom = cvalidateFrom + (IF cValidateFrom > "" AND TogIndex:CHECKED THEN "," ELSE "")
  cValidateFrom = cvalidateFrom + (IF TogIndex:CHECKED THEN "Index":U ELSE "")
  NO-ERROR.
END.

DYNAMIC-FUNCTION("setSessionParam":U IN TARGET-PROCEDURE,
                     INPUT "OG_ValidateFrom":U,
                     INPUT cValidateFrom ).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validate-object diDialog 
PROCEDURE validate-object :
/*------------------------------------------------------------------------------
  Purpose:     Validates whther the object name already exists
               in the repository.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hHandle AS HANDLE     NO-UNDO.
  /* Check whether object name exists */
  IF getObjectValidate(fiFilename:SCREEN-VALUE IN FRAME {&FRAME-NAME}) THEN
  DO:
     MESSAGE fiFilename:SCREEN-VALUE + " already exists in the repository" SKIP
             "Please specify another object name"
        VIEW-AS ALERT-BOX INFO BUTTONS OK.
     RETURN "ERROR":U.
  END.
  RETURN "".




  END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validate-save diDialog 
PROCEDURE validate-save :
/*------------------------------------------------------------------------------
  Purpose:     Used to validate the information entereds by the user
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE cDir           AS CHARACTER  NO-UNDO.
DEFINE VARIABLE lreplace       AS LOGICAL    NO-UNDO.
DEFINE VARIABLE cFileName      AS CHARACTER  NO-UNDO.

/* Check that directory is valid */

cDir = RIGHT-TRIM(substring(fiFullPath:SCREEN-VALUE IN FRAME {&FRAME-NAME},1,R-INDEX(fiFullPath:SCREEN-VALUE,"/":U)),"/").
FILE-INFO:FILE-NAME = cDir NO-ERROR.
/* Ensure the directory exists */
IF FILE-INFO:FULL-PATHNAME = ? AND 
  (LOOKUP(gcObjectType,"DynView,DynBrow,DynSDO,DynDataView":U) = 0 OR
   fiPrcFileName:SCREEN-VALUE IN FRAME {&FRAME-NAME} NE "":U) THEN
DO:
   /* Unless this a DynBrowse or DynView with no super procedure don't let them
      their object */
   MESSAGE "The specified directory '" + cDir + " ' does not exist." 
      VIEW-AS ALERT-BOX INFO BUTTONS OK.
   APPLY "ENTRY":U TO coModule.
 RETURN "ERROR":U.
END.


IF INDEX(FILE-INFO:FILE-TYPE,"X":U) > 0 THEN
DO:
  MESSAGE "The specified directory '" + cDir + " ' is invalid." 
       VIEW-AS ALERT-BOX INFO BUTTONS OK.
  RETURN "ERROR":U.
END.



IF INDEX(FILE-INFO:FILE-TYPE,"D") = 0 THEN
DO:
  MESSAGE "The specified directory '" + cDir + " ' is Read-only." 
       VIEW-AS ALERT-BOX INFO BUTTONS OK.
  RETURN "ERROR":U.
END.


/* Check whether the file exists for any static object, exclude check for dynamic objects */
 IF LOOKUP(gcObjectType,"DynView,DynBrow,DynSDO,DynDataView":U) = 0 THEN 
 DO:
    /* Append the default extension if no extension is provided */
    ASSIGN cFileName = fiFullPath:SCREEN-VALUE
           cFileName = IF NUM-ENTRIES(cFileName,".":U) <= 1
                       THEN cFileName + ".":U + BUFF_P._FILE-TYPE
                       ELSE cFileName.
    IF SEARCH(cFileName) > "" THEN
    DO:
       MESSAGE cFileName + " already exists." SKIP
               "Do you want to replace it?"
          VIEW-AS ALERT-BOX INFO BUTTONS YES-NO UPDATE lReplace.
       IF NOT lReplace THEN
          RETURN "ERROR":U.
       
    END.
 END.

/* IF registering the object, check whether the object already exists in the rep */
IF toRelative:CHECKED THEN
DO:
   RUN validate-object IN THIS-PROCEDURE.
   IF RETURN-VALUE > "" THEN
      RETURN "ERROR":U.

END.

/* Check that super proc or data logic proc is valid */
IF toPrc:CHECKED THEN
DO:
  /* Ensure the filename is not blank */
   IF fiPrcFileName:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "" THEN
   DO:
      MESSAGE "You must specify a File Name for the " + 
              IF gCobjectType = "DynSDO":U 
              THEN "data logic procedure."
              ELSE "custom super procedure."
         VIEW-AS ALERT-BOX INFO BUTTONS OK.
      APPLY "ENTRY":U TO fiPrcFilename. 
      RETURN "ERROR":U.
   END.

   /* Ensure the custom super proc or data logic proc has a .p extension */
  IF NUM-ENTRIES(fiPrcFilename:SCREEN-VALUE,".":U) <> 2 
      OR (NUM-ENTRIES(fiPrcFilename:SCREEN-VALUE,".":U) = 2 
            AND ENTRY(2,fiPrcFilename:SCREEN-VALUE,".":U) <> "p":U)
        THEN
  DO:
     MESSAGE  "You must specify a '.p' extension for the " + 
              IF gCobjectType = "DynSDO":U 
              THEN "data logic procedure."
              ELSE "custom super procedure."
         VIEW-AS ALERT-BOX INFO BUTTONS OK.
      APPLY "ENTRY":U TO fiPrcFilename. 
      RETURN "ERROR":U.
  END.
  cDir = RIGHT-TRIM(substring(fiPrcFullPath:SCREEN-VALUE ,1,R-INDEX(fiPrcFullPath:SCREEN-VALUE,"/":U)),"/").
  FILE-INFO:FILE-NAME = cDir NO-ERROR.
  /* Ensure the directory exists */
  IF FILE-INFO:FULL-PATHNAME = ? THEN
  DO:
    MESSAGE "The specified directory '" + cDir + " ' does not exist for the " +
             IF gCobjectType = "DynSDO":U 
             THEN "data logic procedure."
             ELSE "custom super procedure."
        VIEW-AS ALERT-BOX INFO BUTTONS OK.
    APPLY "ENTRY":U TO coPrcModule. 
    RETURN "ERROR":U.
  END.

  IF INDEX(FILE-INFO:FILE-TYPE,"X":U) > 0 THEN
  DO:
    MESSAGE "The specified directory '" + cDir + " ' is invalid." 
         VIEW-AS ALERT-BOX INFO BUTTONS OK.
    RETURN "ERROR":U.
  END.

  IF INDEX(FILE-INFO:FILE-TYPE,"D") = 0 THEN
  DO:
    MESSAGE "The specified directory '" + cDir + " ' is Read-only." 
         VIEW-AS ALERT-BOX INFO BUTTONS OK.
    RETURN "ERROR":U.
  END.
END.

/* All is OK . Assign tt record */
ASSIGN BUFF_P._save-as-file        = fiFullPath:SCREEN-VALUE
       BUFF_P.deployment_type      = (IF toWeb:CHECKED    = YES THEN "WEB,":U ELSE "":U)
                               + (IF toClient:CHECKED = YES THEN "CLN,":U ELSE "":U)
                               + (IF toServer:CHECKED = YES THEN "SRV":U ELSE "":U)
       BUFF_P.deployment_type      = RIGHT-TRIM(BUFF_P.deployment_type, ",":U)
       BUFF_P.design_only          = toDesign:CHECKED.

IF toRelative:CHECKED OR toRelative:HIDDEN  THEN
DO:
   ASSIGN BUFF_P._save-as-path        = IF toRelative:CHECKED THEN fiRelDirectory:SCREEN-VALUE ELSE ""
          BUFF_P.object_path          = BUFF_P._save-as-path
          BUFF_P.OBJECT_filename      = fiFileName:SCREEN-VALUE
          BUFF_P.OBJECT_description   = fiObjectDesc:SCREEN-VALUE
          BUFF_P.product_module_code  = coModule:SCREEN-VALUE
          NO-ERROR.
   FIND gsc_product_module NO-LOCK
       WHERE gsc_product_module.product_module_code = BUFF_P.product_module_code
       NO-ERROR.
   IF AVAILABLE gsc_product_module THEN
      ASSIGN
        BUFF_P._save-as-path      = gsc_product_module.relative_path
        BUFF_P.product_module_obj = gsc_product_module.product_module_obj
        BUFF_P.object_path        = gsc_product_module.relative_path
        NO-ERROR.
END.


IF AVAILABLE BUFF_C AND ToPrc:CHECKED THEN
DO:
  IF gcObjectType = "DynSDO":U THEN
  DO:
     ASSIGN BUFF_C._DATA-LOGIC-PROC         = fiPrcFullPath:SCREEN-VALUE
            BUFF_C._DATA-LOGIC-PROC-PATH    = fiPrcRelDirectory:SCREEN-VALUE
            BUFF_C._DATA-LOGIC-PROC-PMOD    = coPrcModule:SCREEN-VALUE
            BUFF_C._Rowobject-NO-UNDO       = togUseNoUndo:CHECKED
            NO-ERROR.
    IF AVAIL _C THEN
       ASSIGN _C._DATA-LOGIC-PROC         = fiPrcFullPath:SCREEN-VALUE
              _C._DATA-LOGIC-PROC-PATH    = fiPrcRelDirectory:SCREEN-VALUE
              _C._DATA-LOGIC-PROC-PMOD    = coPrcModule:SCREEN-VALUE
              NO-ERROR.
 END.
  ELSE DO:
    ASSIGN BUFF_C._CUSTOM-SUPER-PROC       = fiPrcRelDirectory:SCREEN-VALUE + (IF  fiPrcRelDirectory:SCREEN-VALUE = "" then "" ELSE "/":U )
                                                                            + fiPrcFileName:SCREEN-VALUE
           BUFF_C._CUSTOM-SUPER-PROC-PATH  = fiPrcRelDirectory:SCREEN-VALUE
           BUFF_C._CUSTOM-SUPER-PROC-PMOD  = coPrcModule:SCREEN-VALUE
           NO-ERROR .
   IF AVAIL _C THEN
     ASSIGN _C._CUSTOM-SUPER-PROC       = fiPrcRelDirectory:SCREEN-VALUE + (IF  fiPrcRelDirectory:SCREEN-VALUE = "" then "" ELSE "/":U )
                                                                            + fiPrcFileName:SCREEN-VALUE
            _C._CUSTOM-SUPER-PROC-PATH  = fiPrcRelDirectory:SCREEN-VALUE
            _C._CUSTOM-SUPER-PROC-PMOD  = coPrcModule:SCREEN-VALUE
            NO-ERROR   .
  END.         
END.

ELSE IF AVAILABLE BUFF_C AND NOT ToPrc:CHECKED AND toPrc:VISIBLE THEN 
DO:
  ASSIGN BUFF_C._DATA-LOGIC-PROC         = ""
         BUFF_C._DATA-LOGIC-PROC-PATH    = ""
         BUFF_C._DATA-LOGIC-PROC-PMOD    = ""
         BUFF_C._CUSTOM-SUPER-PROC       = ""
         BUFF_C._CUSTOM-SUPER-PROC-PATH  = ""
         BUFF_C._CUSTOM-SUPER-PROC-PMOD  = "".
  IF AVAIL _C THEN       
     ASSIGN  _C._DATA-LOGIC-PROC         = ""
             _C._DATA-LOGIC-PROC-PATH    = ""
             _C._DATA-LOGIC-PROC-PMOD    = ""
             _C._CUSTOM-SUPER-PROC       = ""
             _C._CUSTOM-SUPER-PROC-PATH  = ""
             _C._CUSTOM-SUPER-PROC-PMOD  = "".
END.         
/* If a static SDO is flagged to have a new DLP generated, write it to the 
   same module as the SDO */
IF AVAILABLE BUFF_C AND glstaticObject 
     AND toRelative:CHECKED AND BUFF_C._DATA-LOGIC-PROC-NEW  
     AND BUFF_C._DATA-LOGIC-PROC > "" THEN
    ASSIGN BUFF_C._DATA-LOGIC-PROC-PMOD = coModule:SCREEN-VALUE
           BUFF_C._DATA-LOGIC-PROC      = REPLACE(BUFF_C._DATA-LOGIC-PROC,"~\","/")
           BUFF_C._DATA-LOGIC-PROC      = fiRelDirectory:SCREEN-VALUE 
                                            + (IF fiRelDirectory:SCREEN-VALUE > "" THEN "/" ELSE "")
                                            +  ENTRY(NUM-ENTRIES(BUFF_C._DATA-LOGIC-PROC,"/"),BUFF_C._DATA-LOGIC-PROC,"/").
  

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getInitialFileName diDialog 
FUNCTION getInitialFileName RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  RETURN fiFileName:SCREEN-VALUE IN FRAME {&FRAME-NAME}.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getObjectValidate diDialog 
FUNCTION getObjectValidate RETURNS LOGICAL
  ( pcObjectName AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  determines whether the object exists
    Notes:  
------------------------------------------------------------------------------*/
IF DYNAMIC-FUNCTION("ObjectExists":U IN ghRepositoryDesignManager, pcObjectName) THEN
  RETURN TRUE.
ELSE RETURN FALSE.


END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getRDMHandle diDialog 
FUNCTION getRDMHandle RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  
  ASSIGN ghRepositoryDesignManager = DYNAMIC-FUNCTION("getManagerHandle":U, INPUT "RepositoryDesignManager":U).

  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getRegObjName diDialog 
FUNCTION getRegObjName RETURNS CHARACTER
  ( pcName AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Strips the . off the passed name.
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE ipos        AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cObjectName AS CHARACTER  NO-UNDO.

  ipos = R-INDEX(pcName,".").

  IF ipos > 0  THEN
    cObjectName = SUBSTRING(pcName,1,iPos - 1).
  ELSE
   cObjectName = pcName.
  
   RETURN cObjectName.   /* Function return value. */

  RETURN "".   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getSDOFLA diDialog 
FUNCTION getSDOFLA RETURNS CHARACTER
  ( OUTPUT pcTableName AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  Gets the default entity FLA based on the object's associated SDO.
            It actually runs the SDO, gets the TABLE prop, fetches the entity FLA 
            based on the table, and sets that prefix to the object name.
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cPrefix      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDataObject  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hSDO         AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cFLA         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cValueTables AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFirstTable  AS CHARACTER  NO-UNDO.
  
  ASSIGN pcTableName = "".
  IF AVAILABLE BUFF_P AND BUFF_P._data-object > "" THEN
  DO:
    ASSIGN cDataObject = BUFF_P._data-object
           cDataObject = REPLACE(cDataObject, "~\":U,"/":U)
           cDataObject = ENTRY(NUM-ENTRIES(cDataObject,"/"),cDataObject,"/":U).

    RUN StartDataObject IN gshRepositoryManager
                (INPUT cDataObject, OUTPUT hSDO) NO-ERROR.
    IF VALID-HANDLE(hSDO) THEN
    DO:
       {get Tables cValueTables hSDO} NO-ERROR.
       ASSIGN cFirstTable = ENTRY(1, cValueTables)
              cFirstTable = ENTRY( NUM-ENTRIES(cFirstTable,".":U) , cFirstTable ,".":U)
              pcTableName = cFirstTable
              NO-ERROR.
       FIND FIRST gsc_entity_mnemonic NO-LOCK
          WHERE gsc_entity_mnemonic.entity_mnemonic_description = cFirstTable NO-ERROR.
       IF AVAILABLE gsc_entity_mnemonic THEN 
          cFLA = gsc_entity_mnemonic.entity_mnemonic.
       ELSE 
          cFLA = "":U.

       IF LOOKUP("destroyObject":U,hSDO:INTERNAL-ENTRIES) > 0 THEN
          RUN destroyObject IN hSDO NO-ERROR.
       IF VALID-HANDLE(hSDO) THEN
          DELETE OBJECT hSDO NO-ERROR.
       ASSIGN cprefix = LC(cFLA).
    END.
    
    IF cprefix = "" THEN  /* Use the static sdo definition */
    DO:
      IF NUM-ENTRIES(cDataObject,"/":U) > 1 THEN
          ASSIGN cPrefix = ENTRY(NUM-ENTRIES(cDataObject,"/":U),cDataObject,"/":U).
       ELSE
         cPrefix =  cDataObject.
       /* Now strip out the  extension */
       cPrefix = ENTRY(1,cprefix,".") NO-ERROR.
       IF R-INDEX(cPrefix,gcDynSDOPrefix) > 0 THEN
          cPrefix = SUBSTRING(cPrefix,1,R-INDEX(cPrefix,gcDynSDOPrefix) - 1) NO-ERROR.
    END.
  END.


  RETURN cPrefix.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setMaxSaveinList diDialog 
FUNCTION setMaxSaveinList RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  Sets the maximum number of items in the saveIn combo, based on the
            pre-processor MAX-SAVEIN
    Notes:  
------------------------------------------------------------------------------*/
 DEFINE VARIABLE cNewString AS CHARACTER  NO-UNDO.

 IF NUM-ENTRIES(gcSaveInList) > {&MAX-SAVEIN}  THEN
 DO:
    ENTRY({&MAX-SAVEIN} + 1,gcSaveinList ) =  "".
    ASSIGN gcSaveInList = TRIM(gcSaveinList,",").
  
 END.


  RETURN TRUE.   /* Function return value. */


END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

