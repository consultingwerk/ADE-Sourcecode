&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12
/* Procedure Description
"Super Procedure for Dynamic SmartDataViewer"
*/
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*************************************************************/  
/* Copyright (c) 1984-2005 by Progress Software Corporation  */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from PROGRESS Software Corporation. */
/*************************************************************/
/*------------------------------------------------------------------------

  File: usrgrpviwvsupr.p

  Description: 

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: 

  Created: 05/18/03 - 12:14 pm

------------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.       */
/*----------------------------------------------------------------------*/

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       grpusrsupr.p
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/*  object identifying preprocessor */
&glob   AstraProcedure    yes

{src/adm2/globals.i}

DEFINE VARIABLE gdLastSetWidth    AS DECIMAL    NO-UNDO.
DEFINE VARIABLE gdLastSetHeight   AS DECIMAL    NO-UNDO.

DEFINE VARIABLE glChangesMade     AS LOGICAL    NO-UNDO.
DEFINE VARIABLE gdUserObj        AS DECIMAL    NO-UNDO.
DEFINE VARIABLE gcAvailableUsers  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcAllocatedUsers  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE ghTableIO         AS HANDLE     NO-UNDO.
DEFINE VARIABLE glAddRecord       AS LOGICAL    NO-UNDO.

{dynlaunch.i &define-only = YES }

DEFINE TEMP-TABLE ttAvailable NO-UNDO
  FIELD dUserObj      AS DECIMAL
  FIELD cUserName     AS CHARACTER
  INDEX idx1          AS PRIMARY UNIQUE dUserObj
  INDEX idx2          cUserName.

DEFINE TEMP-TABLE ttAllocated NO-UNDO
  FIELD dUserObj      AS DECIMAL
  FIELD cUserName     AS CHARACTER
  INDEX idx1          AS PRIMARY UNIQUE dUserObj
  INDEX idx2          cUserName.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Procedure
   Allow: Basic,Browse,DB-Fields
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 14.24
         WIDTH              = 78.6.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB Procedure 
/* ************************* Included-Libraries *********************** */

{src/adm2/customsuper.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    /* RUN initializeObject. */  /* Commented out by migration progress */
  &ENDIF         

  /************************ INTERNAL PROCEDURES ********************/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-addAll) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE addAll Procedure 
PROCEDURE addAll :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  
  SESSION:SET-WAIT-STATE("GENERAL":U).
  FOR EACH ttAvailable
      EXCLUSIVE-LOCK:
    CREATE ttAllocated.
    BUFFER-COPY ttAvailable TO ttAllocated.
    DELETE ttAvailable.
  END.
  SESSION:SET-WAIT-STATE("":U).

  RUN populateSelLists IN TARGET-PROCEDURE.
  RUN setButtonState IN TARGET-PROCEDURE.
  RUN changesMade IN TARGET-PROCEDURE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-addRecord) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE addRecord Procedure 
PROCEDURE addRecord :
/*------------------------------------------------------------------------------
  Purpose:     Override Add Process
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  RUN setButtonState IN TARGET-PROCEDURE.
  
  glAddRecord = TRUE.
  enableWidget("seAvailable":U).
  enableWidget("seSelected":U).
  disableWidget("fiLoginCompanyObj":U).


  DYNAMIC-FUNCTION("sensitizeActions":U IN ghTableIO, "Add,Delete,FolderUpdate,Reset", FALSE).
  DYNAMIC-FUNCTION("sensitizeActions":U IN ghTableIO, "Cancel", TRUE).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-addSelected) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE addSelected Procedure 
PROCEDURE addSelected :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hSelListAvail     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lAvailSel         AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE iLoop             AS INTEGER    NO-UNDO.
  
  hSelListAvail = DYNAMIC-FUNCTION("internalWidgetHandle":U IN TARGET-PROCEDURE, "seAvailable":U, "ALL":U).

  SESSION:SET-WAIT-STATE("GENERAL":U).
  DO iLoop = 1 TO (NUM-ENTRIES(hSelListAvail:LIST-ITEM-PAIRS,CHR(1)) / 2):
    IF hSelListAvail:IS-SELECTED(iloop) THEN DO:
      FIND FIRST ttAvailable
           WHERE ttAvailable.dUserObj = DECIMAL(hSelListAvail:ENTRY(iLoop))
           EXCLUSIVE-LOCK NO-ERROR.
      CREATE ttAllocated.
      BUFFER-COPY ttAvailable TO ttAllocated.
      DELETE ttAvailable.
    END.
  END.
  SESSION:SET-WAIT-STATE("":U).

  RUN populateSelLists IN TARGET-PROCEDURE.
  RUN setButtonState IN TARGET-PROCEDURE.
  RUN changesMade IN TARGET-PROCEDURE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-cancelRecord) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE cancelRecord Procedure 
PROCEDURE cancelRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  
  glAddRecord = FALSE.
  glChangesMade = FALSE.

  RUN dataChanged IN TARGET-PROCEDURE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-changesMade) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE changesMade Procedure 
PROCEDURE changesMade :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DYNAMIC-FUNCTION("sensitizeActions":U IN ghTableIO, "Save,Reset", TRUE).
  
  glChangesMade = TRUE.

  IF glAddRecord THEN
    DYNAMIC-FUNCTION("sensitizeActions":U IN ghTableIO, "Reset", FALSE).


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-chooseButton) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE chooseButton Procedure 
PROCEDURE chooseButton :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcButton AS CHARACTER  NO-UNDO.
  
  CASE pcButton:
    WHEN "Add":U THEN
      RUN addSelected IN TARGET-PROCEDURE.
    WHEN "AddAll":U THEN
      RUN addAll IN TARGET-PROCEDURE.
    WHEN "Remove":U THEN
      RUN removeSelected IN TARGET-PROCEDURE.
    WHEN "RemoveAll":U THEN
      RUN removeAll IN TARGET-PROCEDURE.
  END CASE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-comboValueChanged) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE comboValueChanged Procedure 
PROCEDURE comboValueChanged :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcKeyFieldValue   AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcDisplayedValue  AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER phComboHandle     AS HANDLE     NO-UNDO.

  RUN dataChanged IN TARGET-PROCEDURE.
/*
  IF CAN-FIND(FIRST ttAllocated) THEN DO:
    DYNAMIC-FUNCTION("sensitizeActions":U IN ghTableIO, "Add,Save,Reset,Cancel":U, FALSE).
    DYNAMIC-FUNCTION("sensitizeActions":U IN ghTableIO, "Delete,FolderUpdate":U, TRUE).
  END.
  */
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-dataAvailable) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE dataAvailable Procedure 
PROCEDURE dataAvailable :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcState AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE hDataSource     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hCombo          AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cQuestion       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cButton         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iStack          AS INTEGER    NO-UNDO.
  DEFINE VARIABLE lInitialization AS LOGICAL    NO-UNDO.

  {get DataSource hDataSource}.

  IF glChangesMade THEN DO:
    cQuestion = {aferrortxt.i 'AF' '131' '' '?' '"user allocations"'}.

    RUN showMessages IN gshSessionManager (INPUT cQuestion,
                                           INPUT "QUE":U,
                                           INPUT "&YES,&NO":U,
                                           INPUT "&NO":U,
                                           INPUT "&NO":U,
                                           INPUT "Save Changes",
                                           INPUT YES,
                                           INPUT ?,
                                           OUTPUT cButton).

    IF cButton = "&YES":U THEN 
      RUN updateRecord IN TARGET-PROCEDURE.
  END.

  glChangesMade = FALSE.
  gdUserObj = DECIMAL(ENTRY(2,DYNAMIC-FUNCTION("colValues":U IN hDataSource, "user_obj":U),CHR(1))).
  IF gdUserObj = ? THEN
    gdUserObj = 0.

  iStack = 2.
  REPEAT WHILE PROGRAM-NAME(iStack) <> ?:
    IF PROGRAM-NAME(iStack) = 'initializeObject adm2/viewer.p':U THEN
    DO:
      lInitialization = TRUE.
      LEAVE.
    END.
    iStack = iStack + 1.
  END.

  /* Only run displayFields when the viewer is being initialized */
  IF lInitialization THEN
    RUN displayFields IN TARGET-PROCEDURE ("?":U).

  assignWidgetValue("fiLoginCompanyObj":U, "0":U).
  
  RUN dataChanged IN TARGET-PROCEDURE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-dataChanged) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE dataChanged Procedure 
PROCEDURE dataChanged :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  disableWidget("seAvailable":U).
  disableWidget("seSelected":U).
  disableWidget("buAdd":U).
  disableWidget("buAddAll":U).
  disableWidget("buRemove":U).
  disableWidget("buRemoveAll":U).
  
  RUN displayData IN TARGET-PROCEDURE.

  IF gdUserObj <> 0 THEN DO:
    enableWidget("fiLoginCompanyObj":U).
    DYNAMIC-FUNCTION("sensitizeActions":U IN ghTableIO, "Add":U, TRUE).
    IF CAN-FIND(FIRST ttAllocated) THEN DO:
      DYNAMIC-FUNCTION("sensitizeActions":U IN ghTableIO, "Delete,FolderUpdate":U, TRUE).
      DYNAMIC-FUNCTION("sensitizeActions":U IN ghTableIO, "Add":U, FALSE).
    END.
    ELSE
      DYNAMIC-FUNCTION("sensitizeActions":U IN ghTableIO, "Delete,FolderUpdate":U, FALSE).

    DYNAMIC-FUNCTION("sensitizeActions":U IN ghTableIO, "Save,Reset,Cancel":U, FALSE).
    
  END.
  ELSE DO:
    disableWidget("fiLoginCompanyObj":U).
    DYNAMIC-FUNCTION("sensitizeActions":U IN ghTableIO, "Add,Delete,FolderUpdate,Save,Reset,Cancel":U, FALSE).
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-deleteRecord) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE deleteRecord Procedure 
PROCEDURE deleteRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cQuestion AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cButton   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cAnswer   AS CHARACTER  NO-UNDO.

  cQuestion = {aferrortxt.i 'HTM' '4' '' '?'}.
  
  RUN showMessages IN gshSessionManager (INPUT cQuestion,
                                         INPUT "QUE":U,
                                         INPUT "&YES,&NO":U,
                                         INPUT "&NO":U,
                                         INPUT "&NO":U,
                                         INPUT "Delete Record",
                                         INPUT YES,
                                         INPUT ?,
                                         OUTPUT cButton).

  IF cButton <> "&YES":U THEN 
    RETURN.


  EMPTY TEMP-TABLE ttAllocated.

  RUN updateRecord IN TARGET-PROCEDURE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-displayData) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE displayData Procedure 
PROCEDURE displayData :
/*------------------------------------------------------------------------------
  Purpose:     This procedure will retreive the data from the Server and display
               it.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE dLoginCompanyObj  AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE cMessageList      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cButton           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iLoop             AS INTEGER    NO-UNDO.
  
  dLoginCompanyObj = DECIMAL(formattedWidgetValue("fiLoginCompanyObj":U)).
  
  SESSION:SET-WAIT-STATE("GENERAL":U).
  {dynlaunch.i 
            &PLIP     = "'af/app/secgetdata.p'"
            &iProc    = "'getAllocatedGroups'"              
            &OnApp    = YES
            &AutoKill = YES
            &mode1    = INPUT  &parm1  = gdUserObj          &dataType1  = DECIMAL
            &mode2    = INPUT  &parm2  = dLoginCompanyObj   &dataType2  = DECIMAL
            &mode3    = OUTPUT &parm3  = gcAvailableUsers   &dataType3  = CHARACTER
            &mode4    = OUTPUT &parm4  = gcAllocatedUsers   &dataType4  = CHARACTER
  }
  SESSION:SET-WAIT-STATE("":U).

  IF ERROR-STATUS:ERROR OR
     RETURN-VALUE <> "":U THEN DO:
    cMessageList = RETURN-VALUE.
    IF cMessageList <> "":U THEN
      RUN showMessages IN gshSessionManager (INPUT cMessageList,
                                             INPUT "ERR":U,
                                             INPUT "OK":U,
                                             INPUT "OK":U,
                                             INPUT "OK":U,
                                             INPUT "Error",
                                             INPUT YES,
                                             INPUT ?,
                                             OUTPUT cButton).

    RETURN.
  END.

  SESSION:SET-WAIT-STATE("GENERAL":U).
  EMPTY TEMP-TABLE ttAvailable.
  EMPTY TEMP-TABLE ttAllocated.

  DO iLoop = 1 TO NUM-ENTRIES(gcAvailableUsers,CHR(5)):
    CREATE ttAvailable.
    ASSIGN ttAvailable.dUserObj  = DECIMAL(ENTRY(1,ENTRY(iLoop,gcAvailableUsers,CHR(5)),CHR(4)))
           ttAvailable.cUserName = ENTRY(2,ENTRY(iLoop,gcAvailableUsers,CHR(5)),CHR(4)).
  END.
  
  DO iLoop = 1 TO NUM-ENTRIES(gcAllocatedUsers,CHR(5)):
    CREATE ttAllocated.
    ASSIGN ttAllocated.dUserObj  = DECIMAL(ENTRY(1,ENTRY(iLoop,gcAllocatedUsers,CHR(5)),CHR(4)))
           ttAllocated.cUserName = ENTRY(2,ENTRY(iLoop,gcAllocatedUsers,CHR(5)),CHR(4)).
  END.

  RUN populateSelLists IN TARGET-PROCEDURE.
  SESSION:SET-WAIT-STATE("":U).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-initializeObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject Procedure 
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  
  {get TableIoSource ghTableIO}.

  SUBSCRIBE PROCEDURE TARGET-PROCEDURE TO "comboValueChanged":U IN TARGET-PROCEDURE.

  RUN SUPER.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-populateSelLists) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE populateSelLists Procedure 
PROCEDURE populateSelLists :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cAvailableList    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cAllocatedList    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hSelListAvail     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hSelListAlloc     AS HANDLE     NO-UNDO.
  
  SESSION:SET-WAIT-STATE("GENERAL":U).

  FOR EACH ttAvailable 
      NO-LOCK
      BY ttAvailable.cUserName:
    cAvailableList = IF cAvailableList = "":U THEN ttAvailable.cUserName + CHR(1) + STRING(ttAvailable.dUserObj) ELSE cAvailableList + CHR(1) + ttAvailable.cUserName + CHR(1) + STRING(ttAvailable.dUserObj).
  END.

  FOR EACH ttAllocated
    NO-LOCK
    BY ttAllocated.cUserName:
    cAllocatedList = IF cAllocatedList = "":U THEN ttAllocated.cUserName + CHR(1) + STRING(ttAllocated.dUserObj) ELSE cAllocatedList + CHR(1) + ttAllocated.cUserName + CHR(1) + STRING(ttAllocated.dUserObj).
  END.
    
  hSelListAvail = DYNAMIC-FUNCTION("internalWidgetHandle":U IN TARGET-PROCEDURE, "seAvailable":U, "ALL":U).
  hSelListAlloc = DYNAMIC-FUNCTION("internalWidgetHandle":U IN TARGET-PROCEDURE, "seSelected":U, "ALL":U).

  IF cAvailableList = "":U THEN
    cAvailableList = ?.
  IF cAllocatedList = "":U THEN
    cAllocatedList = ?.
  
  ASSIGN hSelListAvail:DELIMITER       = CHR(1)
         hSelListAlloc:DELIMITER       = CHR(1)
         hSelListAvail:LIST-ITEM-PAIRS = cAvailableList
         hSelListAlloc:LIST-ITEM-PAIRS = cAllocatedList.
  SESSION:SET-WAIT-STATE("":U).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-removeAll) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE removeAll Procedure 
PROCEDURE removeAll :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  
  SESSION:SET-WAIT-STATE("GENERAL":U).
  FOR EACH ttAllocated
      EXCLUSIVE-LOCK:
    CREATE ttAvailable.
    BUFFER-COPY ttAllocated TO ttAvailable.
    DELETE ttAllocated.
  END.
  SESSION:SET-WAIT-STATE("":U).

  RUN populateSelLists IN TARGET-PROCEDURE.
  RUN setButtonState IN TARGET-PROCEDURE.
  RUN changesMade IN TARGET-PROCEDURE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-removeSelected) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE removeSelected Procedure 
PROCEDURE removeSelected :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hSelListAlloc     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE iLoop             AS INTEGER    NO-UNDO.
  
  hSelListAlloc = DYNAMIC-FUNCTION("internalWidgetHandle":U IN TARGET-PROCEDURE, "seSelected":U, "ALL":U).

  SESSION:SET-WAIT-STATE("GENERAL":U).
  DO iLoop = 1 TO (NUM-ENTRIES(hSelListAlloc:LIST-ITEM-PAIRS,CHR(1)) / 2):
    IF hSelListAlloc:IS-SELECTED(iloop) THEN DO:
      FIND FIRST ttAllocated
           WHERE ttAllocated.dUserObj = DECIMAL(hSelListAlloc:ENTRY(iLoop))
           EXCLUSIVE-LOCK NO-ERROR.
      CREATE ttAvailable.
      BUFFER-COPY ttAllocated TO ttAvailable.
      DELETE ttAllocated.
    END.
  END.
  SESSION:SET-WAIT-STATE("":U).

  RUN populateSelLists IN TARGET-PROCEDURE.
  RUN setButtonState IN TARGET-PROCEDURE.
  RUN changesMade IN TARGET-PROCEDURE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-repositionObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE repositionObject Procedure 
PROCEDURE repositionObject :
/*------------------------------------------------------------------------------
  Purpose:     Override procedure to add NO-ERROR to assignment of COL and ROW
               due to unexplained errors.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pdRow AS DECIMAL    NO-UNDO.
  DEFINE INPUT  PARAMETER pdCol AS DECIMAL    NO-UNDO.

  DEFINE VARIABLE hContainer  AS HANDLE     NO-UNDO.


  {get ContainerHandle hContainer}.
  
  IF VALID-HANDLE(hContainer) THEN
    ASSIGN hContainer:ROW = pdRow
           hContainer:COL = pdCol NO-ERROR.
  ERROR-STATUS:ERROR = FALSE.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-resetRecord) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE resetRecord Procedure 
PROCEDURE resetRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  
  glAddRecord = FALSE.
  glChangesMade = FALSE.

  RUN dataChanged IN TARGET-PROCEDURE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-resizeObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE resizeObject Procedure 
PROCEDURE resizeObject :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pdHeight AS DECIMAL    NO-UNDO.
  DEFINE INPUT  PARAMETER pdWidth  AS DECIMAL    NO-UNDO.

  DEFINE VARIABLE hFrame AS HANDLE     NO-UNDO.

  {get ContainerHandle hFrame}.
          
  ASSIGN gdLastSetWidth  = pdWidth
         gdLastSetHeight = pdHeight.
  
  IF NOT VALID-HANDLE(hFrame) THEN
    RETURN.
                       
  IF pdWidth <= 0 OR
    pdHeight <= 0 THEN 
    RETURN.

  IF pdWidth < hFrame:WIDTH OR 
     pdHeight < hFrame:HEIGHT THEN DO:
    /* Move All Widgets and then the frame */
    RUN resizeWidgets IN TARGET-PROCEDURE (INPUT pdHeight, INPUT pdWidth).
    ASSIGN hFrame:SCROLLABLE     = TRUE
           hFrame:WIDTH          = pdWidth
           hFrame:HEIGHT         = pdHeight
           hFrame:VIRTUAL-WIDTH  = pdWidth
           hFrame:VIRTUAL-HEIGHT = pdHeight
           hFrame:SCROLLABLE     = FALSE.
  END.
  ELSE DO:
    /* Move the frame and then the widgets */
    ASSIGN hFrame:SCROLLABLE     = TRUE
           hFrame:WIDTH          = pdWidth
           hFrame:HEIGHT         = pdHeight
           hFrame:VIRTUAL-WIDTH  = pdWidth
           hFrame:VIRTUAL-HEIGHT = pdHeight
           hFrame:SCROLLABLE     = FALSE.
    RUN resizeWidgets IN TARGET-PROCEDURE (INPUT pdHeight, INPUT pdWidth).
  END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-resizeWidgets) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE resizeWidgets Procedure 
PROCEDURE resizeWidgets :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pdHeight AS DECIMAL    NO-UNDO.
  DEFINE INPUT  PARAMETER pdWidth  AS DECIMAL    NO-UNDO.
  
  DEFINE VARIABLE hButton   AS HANDLE     NO-UNDO EXTENT 4.
  DEFINE VARIABLE hLabel    AS HANDLE     NO-UNDO EXTENT 2.
  DEFINE VARIABLE hSelList  AS HANDLE     NO-UNDO EXTENT 2.
  DEFINE VARIABLE dCentre   AS DECIMAL    NO-UNDO.

  hButton[1] = DYNAMIC-FUNCTION("internalWidgetHandle" IN TARGET-PROCEDURE,"buAdd":U, "ALL":U).
  hButton[2] = DYNAMIC-FUNCTION("internalWidgetHandle" IN TARGET-PROCEDURE,"buAddAll":U, "ALL":U).
  hButton[3] = DYNAMIC-FUNCTION("internalWidgetHandle" IN TARGET-PROCEDURE,"buRemove":U, "ALL":U).
  hButton[4] = DYNAMIC-FUNCTION("internalWidgetHandle" IN TARGET-PROCEDURE,"buRemoveAll":U, "ALL":U).
  
  hLabel[1]  = DYNAMIC-FUNCTION("internalWidgetHandle" IN TARGET-PROCEDURE,"fiLabelAvail":U, "ALL":U).
  hLabel[2]  = DYNAMIC-FUNCTION("internalWidgetHandle" IN TARGET-PROCEDURE,"fiLabelSel":U, "ALL":U).
  
  hSelList[1]  = DYNAMIC-FUNCTION("internalWidgetHandle" IN TARGET-PROCEDURE,"seAvailable":U, "ALL":U).
  hSelList[2]  = DYNAMIC-FUNCTION("internalWidgetHandle" IN TARGET-PROCEDURE,"seSelected":U, "ALL":U).

  IF NOT VALID-HANDLE(hButton[1]) THEN 
    RETURN.
  
  /* Width Changes */
  ASSIGN dCentre = pdWidth / 2.
  
  ASSIGN hButton[1]:COL  = dCentre - (hButton[1]:WIDTH / 2)
         hButton[2]:COL  = hButton[1]:COL
         hButton[3]:COL  = hButton[1]:COL
         hButton[4]:COL  = hButton[1]:COL
         hLabel[1]:ROW   = 2.20
         hLabel[2]:ROW   = 2.20
         hSelList[1]:ROW = hLabel[1]:HEIGHT
         hSelList[2]:ROW = hLabel[2]:HEIGHT
         hSelList[1]:COL = 1.5
         hLabel[1]:COL   = hSelList[1]:COL
         NO-ERROR.
    ASSIGN hSelList[1]:WIDTH = hButton[1]:COL - 2
           hSelList[2]:WIDTH = hSelList[1]:WIDTH
           hSelList[2]:COL   = hButton[1]:COL + hButton[1]:WIDTH + .5
           hLabel[2]:COL     = hSelList[2]:COL
           hLabel[1]:WIDTH   = hSelList[1]:WIDTH
           hLabel[2]:WIDTH   = hSelList[2]:WIDTH
           NO-ERROR.
  
  /* Height Changes */
  dCentre = ((pdHeight - hSelList[1]:ROW) / 2) + 1.
  ASSIGN hButton[1]:ROW = dCentre
         hButton[2]:ROW = hButton[1]:ROW + hButton[2]:HEIGHT + .05
         hButton[3]:ROW = hButton[2]:ROW + hButton[3]:HEIGHT + .05
         hButton[4]:ROW = hButton[3]:ROW + hButton[4]:HEIGHT + .05
         hSelList[1]:HEIGHT = (pdHeight - hSelList[1]:ROW)
         hSelList[2]:HEIGHT = hSelList[1]:HEIGHT
         NO-ERROR.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-selectionMade) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE selectionMade Procedure 
PROCEDURE selectionMade :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcWidget AS CHARACTER  NO-UNDO.

  RUN setButtonState IN TARGET-PROCEDURE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setButtonState) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setButtonState Procedure 
PROCEDURE setButtonState :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hSelListAvail     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hSelListAlloc     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lAvailSel         AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lAllocSel         AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE iLoop             AS INTEGER    NO-UNDO.
  
  hSelListAvail = DYNAMIC-FUNCTION("internalWidgetHandle":U IN TARGET-PROCEDURE, "seAvailable":U, "ALL":U).
  hSelListAlloc = DYNAMIC-FUNCTION("internalWidgetHandle":U IN TARGET-PROCEDURE, "seSelected":U, "ALL":U).

  IF CAN-FIND(FIRST ttAvailable) THEN
    enableWidget("buAddAll":U).
  ELSE
    disableWidget("buAddAll":U).
  IF CAN-FIND(FIRST ttAllocated) THEN
    enableWidget("buRemoveAll":U).
  ELSE
    disableWidget("buRemoveAll":U).

  AVAIL_LIST:
  DO iLoop = 1 TO (NUM-ENTRIES(hSelListAvail:LIST-ITEM-PAIRS,CHR(1)) / 2):
    IF hSelListAvail:IS-SELECTED(iloop) THEN DO:
      lAvailSel = TRUE.
      LEAVE AVAIL_LIST.
    END.
  END.
  
  ALLOC_LIST:
  DO iLoop = 1 TO (NUM-ENTRIES(hSelListAlloc:LIST-ITEM-PAIRS,CHR(1)) / 2):
    IF hSelListAlloc:IS-SELECTED(iloop) THEN DO:
      lAllocSel = TRUE.
      LEAVE ALLOC_LIST.
    END.
  END.

  IF lAvailSel THEN
    enableWidget("buAdd":U).
  ELSE
    disableWidget("buAdd":U).

  IF lAllocSel THEN
    enableWidget("buRemove":U).
  ELSE
    disableWidget("buRemove":U).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-updateMode) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updateMode Procedure 
PROCEDURE updateMode :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcMode AS CHARACTER  NO-UNDO.
  
  IF pcMode = "Modify":U THEN DO:
    RUN setButtonState IN TARGET-PROCEDURE.

    glAddRecord = FALSE.
    enableWidget("seAvailable":U).
    enableWidget("seSelected":U).
    disableWidget("fiLoginCompanyObj":U).


    DYNAMIC-FUNCTION("sensitizeActions":U IN ghTableIO, "Add,Delete,FolderUpdate,Reset", FALSE).
    DYNAMIC-FUNCTION("sensitizeActions":U IN ghTableIO, "Cancel", TRUE).
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-updateRecord) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updateRecord Procedure 
PROCEDURE updateRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cAllocatedList    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE dLoginCompanyObj  AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE cMessageList      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cButton           AS CHARACTER  NO-UNDO.
  
  dLoginCompanyObj = DECIMAL(formattedWidgetValue("fiLoginCompanyObj":U)).

  SESSION:SET-WAIT-STATE("GENERAL":U).
  
  FOR EACH ttAllocated:
    cAllocatedList = IF cAllocatedList = "":U THEN STRING(ttAllocated.dUserObj) ELSE cAllocatedList + CHR(4) + STRING(ttAllocated.dUserObj).
  END.
  
  {dynlaunch.i 
            &PLIP     = "'af/app/secgetdata.p'"
            &iProc    = "'setAllocatedGroups'"              
            &OnApp    = YES
            &AutoKill = YES
            &mode1    = INPUT  &parm1  = gdUserObj         &dataType1  = DECIMAL
            &mode2    = INPUT  &parm2  = dLoginCompanyObj   &dataType2  = DECIMAL
            &mode3    = INPUT  &parm3  = cAllocatedList     &dataType3  = CHARACTER
  }
  SESSION:SET-WAIT-STATE("":U).

  IF ERROR-STATUS:ERROR OR
     RETURN-VALUE <> "":U THEN DO:
    cMessageList = RETURN-VALUE.
    IF cMessageList <> "":U THEN
      RUN showMessages IN gshSessionManager (INPUT cMessageList,
                                             INPUT "ERR":U,
                                             INPUT "OK":U,
                                             INPUT "OK":U,
                                             INPUT "OK":U,
                                             INPUT "Error",
                                             INPUT YES,
                                             INPUT ?,
                                             OUTPUT cButton).

    RETURN.
  END.
  
  glAddRecord = FALSE.
  glChangesMade = FALSE.
  RUN dataChanged IN TARGET-PROCEDURE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-viewObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE viewObject Procedure 
PROCEDURE viewObject :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hFrame AS HANDLE     NO-UNDO.

  RUN SUPER.

  {get ContainerHandle hFrame}.
  IF VALID-HANDLE(hFrame) THEN
    RUN resizeObject IN TARGET-PROCEDURE (gdLastSetHeight, gdLastSetWidth).

  RUN dataChanged IN TARGET-PROCEDURE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

