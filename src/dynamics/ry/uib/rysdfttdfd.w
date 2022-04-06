&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12 GUI ADM2
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
/*---------------------------------------------------------------------------------
  File: rysdfttdfd.w

  Description:  SmartDataField Temp-Table Creation

  Purpose:      Allows a developer to define temp-tables to be used with an SDF

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   09/23/2002  Author:     Mark Davies (MIP

  Update Notes: Created from Template rysttdilgd.w

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

&scop object-name       rysdfttdfd.w
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/*  object identifying preprocessor */
&glob   astra2-staticSmartDialog yes

{src/adm2/globals.i}

DEFINE INPUT-OUTPUT PARAMETER pcTempTables AS CHARACTER  NO-UNDO.
DEFINE OUTPUT       PARAMETER plCancel     AS LOGICAL    NO-UNDO.

DEFINE VARIABLE glAdd AS LOGICAL    NO-UNDO.

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
&Scoped-Define ENABLED-OBJECTS seTable buAdd buOk buCancel buHelp 
&Scoped-Define DISPLAYED-OBJECTS seTable fiName fiPlip 

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


/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON buAdd 
     LABEL "&Add" 
     SIZE 15 BY 1.14 TOOLTIP "Add a new Temp-Table"
     BGCOLOR 8 .

DEFINE BUTTON buBrowse 
     IMAGE-UP FILE "ry/img/afbinos.gif":U
     LABEL "" 
     SIZE 5 BY 1.14
     BGCOLOR 8 .

DEFINE BUTTON buCancel AUTO-END-KEY 
     LABEL "Cancel" 
     SIZE 15 BY 1.14.

DEFINE BUTTON buHelp 
     LABEL "&Help" 
     SIZE 15 BY 1.14.

DEFINE BUTTON buOk AUTO-GO 
     LABEL "OK" 
     SIZE 15 BY 1.14.

DEFINE BUTTON buRemove 
     LABEL "&Remove" 
     SIZE 15 BY 1.14 TOOLTIP "Remove selected Temp-Table"
     BGCOLOR 8 .

DEFINE VARIABLE fiName AS CHARACTER FORMAT "X(35)":U 
     LABEL "Temp-Table Name" 
     VIEW-AS FILL-IN 
     SIZE 56.8 BY 1 NO-UNDO.

DEFINE VARIABLE fiPlip AS CHARACTER FORMAT "X(35)":U 
     LABEL "PLIP Name" 
     VIEW-AS FILL-IN 
     SIZE 56.8 BY 1 NO-UNDO.

DEFINE VARIABLE seTable AS CHARACTER 
     VIEW-AS SELECTION-LIST SINGLE SCROLLBAR-VERTICAL 
     SIZE 64.8 BY 8.48
     FONT 3 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME diDialog
     seTable AT ROW 1 COL 1.4 NO-LABEL
     buAdd AT ROW 1.14 COL 67.2
     buRemove AT ROW 2.38 COL 67.2
     fiName AT ROW 9.67 COL 1
     fiPlip AT ROW 10.71 COL 17.8 COLON-ALIGNED
     buBrowse AT ROW 10.67 COL 76.8
     buOk AT ROW 11.86 COL 1.4
     buCancel AT ROW 11.86 COL 17
     buHelp AT ROW 11.86 COL 67
     SPACE(0.59) SKIP(0.00)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         TITLE "Temp-Table Maintenance"
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
   Custom                                                               */
ASSIGN 
       FRAME diDialog:SCROLLABLE       = FALSE
       FRAME diDialog:HIDDEN           = TRUE.

/* SETTINGS FOR BUTTON buBrowse IN FRAME diDialog
   NO-ENABLE                                                            */
/* SETTINGS FOR BUTTON buRemove IN FRAME diDialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fiName IN FRAME diDialog
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN fiPlip IN FRAME diDialog
   NO-ENABLE                                                            */
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
ON WINDOW-CLOSE OF FRAME diDialog /* Temp-Table Maintenance */
DO:  
  /* Add Trigger to equate WINDOW-CLOSE to END-ERROR. */
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buAdd
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buAdd diDialog
ON CHOOSE OF buAdd IN FRAME diDialog /* Add */
DO:
  ENABLE fiName fiPlip buBrowse WITH FRAME {&FRAME-NAME}.
  glAdd = TRUE.
  ASSIGN fiName = "":U
         fiName:SCREEN-VALUE = "":U
         fiPlip:SCREEN-VALUE = "":U.
  APPLY "ENTRY":U TO fiName IN FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buBrowse
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buBrowse diDialog
ON CHOOSE OF buBrowse IN FRAME diDialog
DO:
  DEFINE VARIABLE cFilename AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lOK       AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cJunk     AS CHARACTER  NO-UNDO.
  
  ASSIGN {&WINDOW-NAME}:PRIVATE-DATA = STRING(THIS-PROCEDURE).
  SESSION:SET-WAIT-STATE("GENERAL":U).
  RUN adeuib/_opendialog.w (INPUT {&WINDOW-NAME},
                           INPUT "",
                           INPUT No,
                           INPUT "Get Temp-Table Definition Procedure (PLIP)",
                           OUTPUT cFilename,
                           OUTPUT lok).
  SESSION:SET-WAIT-STATE("":U).
  IF lOK THEN DO:
    RUN getObjectNames IN gshRepositoryManager ( INPUT  cFilename,
                                                 INPUT  "",
                                                 OUTPUT cFilename,
                                                 OUTPUT cJunk).
    ASSIGN fiPlip:SCREEN-VALUE = cFilename.
  END.
  RUN assignValue.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buCancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buCancel diDialog
ON CHOOSE OF buCancel IN FRAME diDialog /* Cancel */
DO:
  plCancel = TRUE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buHelp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buHelp diDialog
ON CHOOSE OF buHelp IN FRAME diDialog /* Help */
DO: /* Call Help Function (or a simple message). */
  APPLY "HELP" TO FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buOk
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buOk diDialog
ON CHOOSE OF buOk IN FRAME diDialog /* OK */
DO:
  DEFINE VARIABLE iLoop         AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cLine         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cMessageList  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cButton       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFileName     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cJunk         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cMessage      AS CHARACTER  NO-UNDO.
  
  ASSIGN fiPLIP.
  
  IF fiPLIP <> "":U THEN
  DO:
  
    RUN getObjectNames IN gshRepositoryManager ( INPUT  fiPLIP,
                                                 INPUT  "",
                                                 OUTPUT cFilename,
                                                 OUTPUT cJunk).
    IF cFileName = "":U THEN 
    DO:
      /* Might have the path specified */
      fiPLIP = REPLACE(fiPLIP,"~\":U,"/":U).
      fiPLIP = SUBSTRING(fiPLIP,R-INDEX(fiPLIP,"/":U) + 1,LENGTH(fiPLIP)).
      RUN getObjectNames IN gshRepositoryManager ( INPUT  fiPLIP,
                                                   INPUT  "",
                                                   OUTPUT cFilename,
                                                   OUTPUT cJunk).
      /* Maybe the user didn't specified a .p extention */
      IF cFileName = "":U AND 
         INDEX(fiPLIP,".p":U) = 0 THEN 
      DO:
        fiPLIP = fiPLIP + ".p":U.
        RUN getObjectNames IN gshRepositoryManager ( INPUT  fiPLIP,
                                                     INPUT  "",
                                                     OUTPUT cFilename,
                                                     OUTPUT cJunk).
  
      END.
  
      /* Give up - Can't find it in the repository */
      IF cFileName = "":U THEN 
      DO:
        cMessage = "Repository object for '" + fiPLIP:SCREEN-VALUE + "'".
        cMessageList = {af/sup2/aferrortxt.i 'AF' '39' '' '' "cMessage"}.
        RUN showMessages IN gshSessionManager (INPUT cMessageList,
                                               INPUT "ERR":U,
                                               INPUT "OK":U,
                                               INPUT "OK":U,
                                               INPUT "OK":U,
                                               INPUT "PLIP Name Invalid",
                                               INPUT YES,
                                               INPUT ?,
                                               OUTPUT cButton).
        APPLY "ENTRY":U TO fiPLIP IN FRAME {&FRAME-NAME}.
        RETURN NO-APPLY.
      END.
    END.
  END.
  
  ASSIGN fiPLIP:SCREEN-VALUE = cFileName.
  glAdd = FALSE.
  RUN assignValue.
  
  plCancel = FALSE.
  pcTempTables = "":U.
  DO iLoop = 1 TO NUM-ENTRIES(seTable:LIST-ITEMS):
    cLine = ENTRY(iLoop,seTable:LIST-ITEMS).
    IF TRIM(ENTRY(1,cLine,"^":U)) = "":U THEN DO:
      cMessageList = {af/sup2/aferrortxt.i 'AF' '1' '' '' '"Temp-Table Name"'}.
      RUN showMessages IN gshSessionManager (INPUT cMessageList,
                                             INPUT "ERR":U,
                                             INPUT "OK":U,
                                             INPUT "OK":U,
                                             INPUT "OK":U,
                                             INPUT "Temp-Table Name not specified",
                                             INPUT YES,
                                             INPUT ?,
                                             OUTPUT cButton).
      ASSIGN seTable:SCREEN-VALUE = cLine.
      APPLY "VALUE-CHANGED":U TO seTable IN FRAME {&FRAME-NAME}.
      RETURN NO-APPLY.
    END.
    IF TRIM(ENTRY(2,cLine,"^":U)) = "":U THEN DO:
      cMessageList = {af/sup2/aferrortxt.i 'AF' '1' '' '' '"PLIP Name"'}.
      RUN showMessages IN gshSessionManager (INPUT cMessageList,
                                             INPUT "ERR":U,
                                             INPUT "OK":U,
                                             INPUT "OK":U,
                                             INPUT "OK":U,
                                             INPUT "PLIP Name not specified",
                                             INPUT YES,
                                             INPUT ?,
                                             OUTPUT cButton).
      ASSIGN seTable:SCREEN-VALUE = cLine.
      APPLY "VALUE-CHANGED":U TO seTable IN FRAME {&FRAME-NAME}.
      APPLY "ENTRY":U TO fiPLIP IN FRAME {&FRAME-NAME}.
      RETURN NO-APPLY.
    END.
    pcTempTables = IF pcTempTables = "":U THEN TRIM(ENTRY(1,cLine,"^":U)) + "^":U + TRIM(ENTRY(2,cLine,"^":U))
                                          ELSE pcTempTables + ",":U + TRIM(ENTRY(1,cLine,"^":U)) + "^":U + TRIM(ENTRY(2,cLine,"^":U)).
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buRemove
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buRemove diDialog
ON CHOOSE OF buRemove IN FRAME diDialog /* Remove */
DO:
  ASSIGN seTable.
  seTable:DELETE(seTable).
  IF NUM-ENTRIES(seTable:LIST-ITEMS) >= 1 THEN
    ASSIGN seTable:SCREEN-VALUE = ENTRY(1,seTable:LIST-ITEMS).

  APPLY "VALUE-CHANGED":U TO seTable.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fiName
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiName diDialog
ON LEAVE OF fiName IN FRAME diDialog /* Temp-Table Name */
OR RETURN OF fiName 
  DO:
  DEFINE VARIABLE iCnt          AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cList         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iLoop         AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cMessageList  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cButton       AS CHARACTER  NO-UNDO.
  
  IF fiName:SCREEN-VALUE <> fiName OR glAdd THEN DO:

    IF fiName:SCREEN-VALUE = "":U THEN DO:
      cMessageList = {af/sup2/aferrortxt.i 'AF' '1' '' '' '"TempTable Name"'}.
      RUN showMessages IN gshSessionManager (INPUT cMessageList,
                                             INPUT "ERR":U,
                                             INPUT "OK":U,
                                             INPUT "OK":U,
                                             INPUT "OK":U,
                                             INPUT "Temp-Table Name not specified",
                                             INPUT YES,
                                             INPUT ?,
                                             OUTPUT cButton).
      APPLY "ENTRY":U TO fiName IN FRAME {&FRAME-NAME}.
      RETURN NO-APPLY.
    END.
    
    iCnt = LOOKUP(fiName:SCREEN-VALUE + FILL(" ":U,100) + "^":U + fiPlip:SCREEN-VALUE,seTable:LIST-ITEMS).
    ASSIGN fiName fiPlip.
    cList = seTable:LIST-ITEMS.
    
    DO iLoop = 1 TO NUM-ENTRIES(cList):
      IF fiName:SCREEN-VALUE = TRIM(ENTRY(1,TRIM(ENTRY(iLoop,cList)),"^":U)) THEN DO:
        
        cMessageList = {af/sup2/aferrortxt.i 'AF' '8' '' '' '"Temp-Table Name:"' "fiName"}.
        RUN showMessages IN gshSessionManager (INPUT cMessageList,
                                               INPUT "ERR":U,
                                               INPUT "OK":U,
                                               INPUT "OK":U,
                                               INPUT "OK":U,
                                               INPUT "Duplicate Temp-Table",
                                               INPUT YES,
                                               INPUT ?,
                                               OUTPUT cButton).
        glAdd = FALSE.
        ASSIGN fiName = "":U.
        IF iCnt = 0 THEN
          iCnt = 1.
        ASSIGN seTable:SCREEN-VALUE = ENTRY(iCnt,seTable:LIST-ITEMS).
        APPLY "VALUE-CHANGED":U TO seTable.
        RETURN.
      END.
    END.
    
    IF iCnt <= 0 OR iCnt = ? OR glAdd THEN DO:
      seTable:ADD-LAST(fiName + FILL(" ":U,100) + "^":U + fiPlip).
      ASSIGN seTable:SCREEN-VALUE = ENTRY(NUM-ENTRIES(seTable:LIST-ITEMS),seTable:LIST-ITEMS).
      APPLY "VALUE-CHANGED":U TO seTable.
      glAdd = FALSE.
      APPLY "ENTRY":U TO fiPLIP IN FRAME {&FRAME-NAME}.
      glAdd = FALSE.
      RETURN.
    END.
    
    ENTRY(iCnt,cList) = fiName:SCREEN-VALUE + FILL(" ":U,100) + "^":U + fiPlip.
    seTable:LIST-ITEMS = cList.
    ASSIGN seTable:SCREEN-VALUE = seTable:ENTRY(iCnt). /*fiName:SCREEN-VALUE + FILL(" ":U,100) + "^":U + fiPlip.*/
    APPLY "VALUE-CHANGED":U TO seTable.
    APPLY "ENTRY":U TO fiPLIP IN FRAME {&FRAME-NAME}.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fiPlip
&Scoped-define SELF-NAME seTable
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL seTable diDialog
ON VALUE-CHANGED OF seTable IN FRAME diDialog
DO:
  ASSIGN seTable.
  ASSIGN fiName = "":U
         fiPlip = "":U
         fiName:SCREEN-VALUE = "":U
         fiPlip:SCREEN-VALUE = "":U.
  DISABLE fiName fiPlip buBrowse buRemove WITH FRAME {&FRAME-NAME}.
         
  IF seTable:SCREEN-VALUE = "":U OR 
     seTable:SCREEN-VALUE = "?":U OR
     seTable:SCREEN-VALUE = ? THEN
    RETURN NO-APPLY.
  ASSIGN fiName = TRIM(ENTRY(1,seTable,"^":U))
         fiPlip = TRIM(ENTRY(2,seTable,"^":U))
         fiName:SCREEN-VALUE = fiName
         fiPlip:SCREEN-VALUE = fiPlip.
  ENABLE fiName fiPlip buBrowse buRemove WITH FRAME {&FRAME-NAME}.
  APPLY "ENTRY":U TO fiName IN FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK diDialog 


/* ***************************  Main Block  *************************** */
RUN assignList.
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

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE assignList diDialog 
PROCEDURE assignList :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE iLoop AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cLine AS CHARACTER  NO-UNDO.

  IF pcTempTables = "":U THEN
    RETURN.

  DO iLoop = 1 TO NUM-ENTRIES(pcTempTables):
    cLine = ENTRY(iLoop,pcTempTables).
    DO WITH FRAME {&FRAME-NAME}:
      seTable:ADD-LAST(ENTRY(1,cLine,"^":U) + FILL(" ":U,100) + "^":U + ENTRY(2,cLine,"^":U)).
    END.
  END.
  ASSIGN seTable:SCREEN-VALUE = ENTRY(1,seTable:LIST-ITEMS).
  APPLY "VALUE-CHANGED":U TO seTable IN FRAME {&FRAME-NAME}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE assignValue diDialog 
PROCEDURE assignValue :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE iCnt  AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cList AS CHARACTER  NO-UNDO.
  
  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN fiName.
    IF fiPlip:SCREEN-VALUE <> fiPlip OR glAdd THEN DO:
  
      iCnt = LOOKUP(fiName + FILL(" ":U,100) + "^":U + fiPlip:SCREEN-VALUE,seTable:LIST-ITEMS).
      IF iCnt = 0 THEN
        iCnt = LOOKUP(fiName + FILL(" ":U,100) + "^":U,seTable:LIST-ITEMS).
      ASSIGN fiName fiPlip.
      IF iCnt <= 0 OR iCnt = ? OR glAdd THEN DO:
        seTable:ADD-LAST(fiName + FILL(" ":U,100) + "^":U + fiPlip).
        ASSIGN seTable:SCREEN-VALUE = ENTRY(1,seTable:LIST-ITEMS).
        APPLY "VALUE-CHANGED":U TO seTable.
        glAdd = FALSE.
        RETURN.
      END.
      
      cList = seTable:LIST-ITEMS.
      ENTRY(iCnt,cList) = fiName:SCREEN-VALUE + FILL(" ":U,100) + "^":U + fiPlip.
      seTable:LIST-ITEMS = cList.
      ASSIGN seTable:SCREEN-VALUE = fiName + FILL(" ":U,100) + "^":U + fiPlip:SCREEN-VALUE.
      APPLY "VALUE-CHANGED":U TO seTable.
    END.
  END.

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
  DISPLAY seTable fiName fiPlip 
      WITH FRAME diDialog.
  ENABLE seTable buAdd buOk buCancel buHelp 
      WITH FRAME diDialog.
  VIEW FRAME diDialog.
  {&OPEN-BROWSERS-IN-QUERY-diDialog}
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

  RETURN fiPlip:SCREEN-VALUE IN FRAME {&FRAME-NAME}.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

