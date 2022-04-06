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
  File: rysdfbuffd.w

  Description:  SDF Buffer Maintenance SmartDialog

  Purpose:      Defines buffers for database tables to be used in an SDF

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   09/22/2002  Author:     Mark Davies (MIP)

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

&scop object-name       rysdfbuffd.w
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/*  object identifying preprocessor */
&glob   astra2-staticSmartDialog yes

{src/adm2/globals.i}
DEFINE INPUT-OUTPUT PARAMETER pcBufferList AS CHARACTER  NO-UNDO.
DEFINE OUTPUT       PARAMETER plCancel     AS LOGICAL    NO-UNDO.

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
&Scoped-Define ENABLED-OBJECTS seBuffers buAdd buOk buCancel buHelp 
&Scoped-Define DISPLAYED-OBJECTS seBuffers fiName 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON buAdd 
     LABEL "&Add" 
     SIZE 15 BY 1.14 TOOLTIP "Add a new buffer"
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
     SIZE 15 BY 1.14 TOOLTIP "Remove selected buffer"
     BGCOLOR 8 .

DEFINE VARIABLE fiName AS CHARACTER FORMAT "X(256)":U 
     LABEL "Buffer Name" 
     VIEW-AS FILL-IN 
     SIZE 51.6 BY 1 TOOLTIP "Enter a buffer name" NO-UNDO.

DEFINE VARIABLE seBuffers AS CHARACTER 
     VIEW-AS SELECTION-LIST SINGLE 
     SCROLLBAR-HORIZONTAL SCROLLBAR-VERTICAL 
     SIZE 64.8 BY 7.14
     FONT 3 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME diDialog
     seBuffers AT ROW 1 COL 1 NO-LABEL
     buAdd AT ROW 1.1 COL 67
     buRemove AT ROW 2.43 COL 67
     fiName AT ROW 8.19 COL 12.2 COLON-ALIGNED
     buOk AT ROW 9.29 COL 1.4
     buCancel AT ROW 9.29 COL 17.4
     buHelp AT ROW 9.29 COL 67.4
     SPACE(0.39) SKIP(0.00)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         TITLE "Buffer Maintenance"
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
                                                                        */
ASSIGN 
       FRAME diDialog:SCROLLABLE       = FALSE
       FRAME diDialog:HIDDEN           = TRUE.

/* SETTINGS FOR BUTTON buRemove IN FRAME diDialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fiName IN FRAME diDialog
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
ON WINDOW-CLOSE OF FRAME diDialog /* Buffer Maintenance */
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
  DEFINE VARIABLE cDb    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cTable AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lOK    AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE iLoop  AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iCnt   AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cOrig  AS CHARACTER  NO-UNDO.

  RUN adecomm/_tblsel.p (INPUT FALSE, /* Multiple */
                         INPUT ?,    /* Temp-Table data */
                         INPUT-OUTPUT cDb, /* Schema Database */
                         INPUT-OUTPUT cTable, /*Selected Table */
                         OUTPUT lOK). /* OK Pressed */
  IF NOT lOK THEN
    RETURN NO-APPLY.
  cOrig = cTable.
  iCnt = 1.
  DO iLoop = 1 TO NUM-ENTRIES(seBuffers:LIST-ITEMS):
    IF INDEX(ENTRY(iLoop,seBuffers:LIST-ITEMS),cTable) > 0 THEN
      iCnt = iCnt + 1.
  END.
  IF iCnt > 1 THEN
    cTable = "b":U + cTable + "_":U + STRING(iCnt).
  ELSE 
    cTable = "b":U + cTable.

   seBuffers:ADD-LAST(cTable + " LIKE ":U + TRIM(cDb) + ".":U + cOrig).
   seBuffers:SCREEN-VALUE = ENTRY(NUM-ENTRIES(seBuffers:LIST-ITEMS),seBuffers:LIST-ITEMS).
   APPLY "ENTRY":U TO seBuffers.
   APPLY "VALUE-CHANGED":U TO seBuffers.
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
  DEFINE VARIABLE iLoop   AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cList   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cBuffer AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cTable  AS CHARACTER  NO-UNDO.

  plCancel = FALSE.
  pcBufferList = "":U.
  DO iLoop = 1 TO NUM-ENTRIES(seBuffers:LIST-ITEMS):
    cList = ENTRY(iLoop,seBuffers:LIST-ITEMS).
    ASSIGN cBuffer = SUBSTRING(cList,1,INDEX(cList," LIKE ":U) - 1)
           cTable  = SUBSTRING(cList,INDEX(cList," LIKE ":U) + 5,LENGTH(cList)).
    pcBufferList = IF pcBufferList = "":U THEN cBuffer + ",":U + cTable
                                          ELSE pcBufferList + ",":U + cBuffer + ",":U + cTable.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buRemove
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buRemove diDialog
ON CHOOSE OF buRemove IN FRAME diDialog /* Remove */
DO:
  ASSIGN seBuffers.
  seBuffers:DELETE(seBuffers).
  IF NUM-ENTRIES(seBuffers:LIST-ITEMS) >= 1 THEN
    ASSIGN seBuffers:SCREEN-VALUE = ENTRY(1,seBuffers:LIST-ITEMS).

  APPLY "VALUE-CHANGED":U TO seBuffers.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fiName
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiName diDialog
ON LEAVE OF fiName IN FRAME diDialog /* Buffer Name */
OR RETURN OF fiName 
  DO:
  DEFINE VARIABLE iCnt         AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cOrig        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cList        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cMessageList AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cButton      AS CHARACTER  NO-UNDO.
  
  IF fiName:SCREEN-VALUE <> fiName THEN DO:

    ASSIGN fiName.
    IF fiName = "":U THEN DO:
      cMessageList = {af/sup2/aferrortxt.i 'AF' '1' '' '' '"Buffer Name"'}.
      RUN showMessages IN gshSessionManager (INPUT cMessageList,
                                             INPUT "ERR":U,
                                             INPUT "OK":U,
                                             INPUT "OK":U,
                                             INPUT "OK":U,
                                             INPUT "Buffer Name not specified",
                                             INPUT YES,
                                             INPUT ?,
                                             OUTPUT cButton).
      RETURN NO-APPLY.
    END.
    iCnt = LOOKUP(seBuffers,seBuffers:LIST-ITEMS).
    
    IF iCnt <= 0 THEN
      RETURN NO-APPLY.
    
    cOrig = ENTRY(iCnt,seBuffers:LIST-ITEMS).
    cOrig = SUBSTRING(cOrig,INDEX(cOrig," LIKE ":U),LENGTH(cOrig)).
    cList = seBuffers:LIST-ITEMS.
    IF LOOKUP(fiName:SCREEN-VALUE + cOrig,cList) > 0 THEN DO:
      cMessageList = {af/sup2/aferrortxt.i 'AF' '8' '' '' '"Buffer Name:"' "fiName:SCREEN-VALUE"}.
      RUN showMessages IN gshSessionManager (INPUT cMessageList,
                                             INPUT "ERR":U,
                                             INPUT "OK":U,
                                             INPUT "OK":U,
                                             INPUT "OK":U,
                                             INPUT "Duplicate Buffer Name",
                                             INPUT YES,
                                             INPUT ?,
                                             OUTPUT cButton).
      ASSIGN fiName = "":U.
      ASSIGN seBuffers:SCREEN-VALUE = ENTRY(iCnt,seBuffers:LIST-ITEMS).
      APPLY "VALUE-CHANGED":U TO seBuffers.
      RETURN.
    END.
    ENTRY(iCnt,cList) = fiName:SCREEN-VALUE + cOrig.
    seBuffers:LIST-ITEMS = cList.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME seBuffers
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL seBuffers diDialog
ON VALUE-CHANGED OF seBuffers IN FRAME diDialog
DO:
  ASSIGN seBuffers.
  ASSIGN fiName = "":U
         fiName:SCREEN-VALUE = "":U.
  DISABLE fiName buRemove WITH FRAME {&FRAME-NAME}.
         
  IF seBuffers:SCREEN-VALUE = "":U OR 
     seBuffers:SCREEN-VALUE = "?":U OR
     seBuffers:SCREEN-VALUE = ? THEN
    RETURN NO-APPLY.
  ASSIGN fiName = SUBSTRING(seBuffers,1,INDEX(seBuffers," LIKE ":U) - 1)
         fiName:SCREEN-VALUE = fiName.
  ENABLE fiName buRemove WITH FRAME {&FRAME-NAME}.
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

  IF pcBufferList = "":U OR
     (NUM-ENTRIES(pcBufferList) MOD 2) <> 0 THEN
    RETURN.

  DO WITH FRAME {&FRAME-NAME}:
    seBuffers:LIST-ITEMS = "":U.
    DO iLoop = 1 TO NUM-ENTRIES(pcBufferList):
      seBuffers:ADD-LAST(ENTRY(iLoop,pcBufferList) + " LIKE ":U + TRIM(ENTRY(iLoop + 1,pcBufferList))).
      iLoop = iLoop + 1.
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
  DISPLAY seBuffers fiName 
      WITH FRAME diDialog.
  ENABLE seBuffers buAdd buOk buCancel buHelp 
      WITH FRAME diDialog.
  VIEW FRAME diDialog.
  {&OPEN-BROWSERS-IN-QUERY-diDialog}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

