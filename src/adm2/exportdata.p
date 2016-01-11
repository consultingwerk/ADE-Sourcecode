&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
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
/*----------------------------------------------------------------------------
  File:        adm2/exportdata.p
  Description:  
  Purpose:     Export data from a data object to an external source/tool. 
  Parameters:  <none>
  Notes:       See internal procedure exportData for details.
               Inherits from smart.p in order to use messageNumber. 
               (and destroyObject)  
-----------------------------------------------------------------------------*/
/* ***************************  Definitions  ************************** */
/* The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that 
   it  can be displayed in the about window of the container */

&scop object-name       exportdata.p
&scop object-version    000000

{src/adm2/ttsdoout.i}
{src/adm2/globals.i}

/* used for Crystal */
DEFINE TEMP-TABLE ttDataSource NO-UNDO
  FIELD ttTag   AS CHARACTER
  FIELD ttValue AS CHARACTER EXTENT {&max-crystal-fields}.

{launch.i &Define-only = YES}

DEFINE VARIABLE xcVisibleLabel AS CHAR NO-UNDO INIT '&Visible Fields':T20.
DEFINE VARIABLE xcAllLabel     AS CHAR NO-UNDO INIT '&All Fields':T20.
DEFINE VARIABLE xcOkLabel      AS CHAR NO-UNDO INIT '&OK':T10.
DEFINE VARIABLE xcCancelLabel  AS CHAR NO-UNDO INIT '&Cancel':T10.
DEFINE VARIABLE xcMaxLabel     AS CHARACTER  NO-UNDO INIT 'Maximum':T40.
DEFINE VARIABLE xcAskTitle     AS CHARACTER  NO-UNDO INIT 'Transfer to':T50.

/* We make calls to Windows APIs to make sure the numeric format is correct. */ 
 PROCEDURE GetLocaleInfoA EXTERNAL "kernel32":U:
   DEFINE INPUT PARAMETER        Locale      AS LONG.
   DEFINE INPUT PARAMETER        dwFlags     AS LONG.
   DEFINE INPUT-OUTPUT PARAMETER lpLCData    AS CHAR.
   DEFINE INPUT PARAMETER        cchData     AS LONG.
   DEFINE RETURN PARAMETER       cchReturned AS LONG.
 END PROCEDURE.

/* The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name  transferdata.p     
&scop object-version   0

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
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 15.81
         WIDTH              = 53.2.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB Procedure 
/* ************************* Included-Libraries *********************** */

{src/adm2/smart.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-askQuestion) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE askQuestion Procedure 
PROCEDURE askQuestion PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     Confirm transfer and ask for max number of records    
  Parameters:  
       input pcMessage     - Message 
       input pcTitle       - Title of message box
       input plFieldChoice - Display is an option. 
                             Yes - 3 Buttons (Displayed, all, Cancel)       
                             No  - 2 Buttons (Ok-Cancel) 
       input-output piNumRecords - Max number of records       
       output       plAll        - Yes = All fields 
                                   No  = Displayed fields
                                   ?   = Cancel 
  Notes: All translatable text is defined as variables in definition section 
         of the procedure.
------------------------------------------------------------------------------*/
DEFINE INPUT        PARAMETER pcMessage     AS CHARACTER  NO-UNDO.
DEFINE INPUT        PARAMETER pcTitle       AS CHARACTER  NO-UNDO.
DEFINE INPUT        PARAMETER plFieldChoice AS LOGICAL    NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER piMaxRecords  AS INTEGER    NO-UNDO.
DEFINE OUTPUT       PARAMETER plDisplayed   AS LOGICAL    NO-UNDO.

DEFINE VARIABLE cButtons       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cMaxRecords    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE lOk            AS LOGICAL    NO-UNDO.
DEFINE VARIABLE cDefaultButton AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cButton        AS CHARACTER  NO-UNDO.

cMaxRecords = STRING(piMaxRecords).

IF plFieldChoice THEN 
  cButtons = xcVisibleLabel + ",":U + xcAllLabel + ",":U + xcCancelLabel.
ELSE 
  cButtons = xcOkLabel + ",":U + xcCancelLabel.
   
IF VALID-HANDLE(gshSessionManager) THEN
DO:
  cDefaultButton = ENTRY(1,cButtons).

  RUN askquestion IN gshSessionManager 
                  (INPUT pcMessage,
                   INPUT cButtons,
                   INPUT cDefaultButton,
                   INPUT xcCancelLabel,
                   INPUT pcTitle,
                   INPUT 'Integer':U,
                   INPUT '>>>>>>>9':U,
                   INPUT-OUTPUT cMaxRecords,
                   OUTPUT cButton).

   IF cButton = xcCancelLabel THEN
     plDisplayed = ?.
   ELSE IF cButton = xcAllLabel THEN
     plDisplayed = FALSE.
   ELSE 
     plDisplayed = TRUE. 
END.
ELSE DO:
  RUN adm2/askquestion.w (pcMessage,
                          cButtons,
                          xcMaxLabel + ',integer,L,>>>>>9':U,
                          pcTitle,
                          INPUT-OUTPUT cMaxRecords,
                          OUTPUT lOk).
 
  IF plFieldChoice THEN
    plDisplayed = lOk.
  ELSE IF NOT lOk THEN
    plDisplayed = ?.
  ELSE 
    plDisplayed = NO. 
END.

piMaxRecords = INTEGER(cMaxRecords).
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-checkCrystal) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE checkCrystal Procedure 
PROCEDURE checkCrystal :
/*------------------------------------------------------------------------------
  Purpose:   Check if Crystal files are avaialble    
  Parameters:  <none>
  Notes:     Called before tableout is called in the SDO    
------------------------------------------------------------------------------*/
  DEFINE OUTPUT PARAMETER plOk AS LOGICAL    NO-UNDO.

  DEFINE VARIABLE cErrorMessage AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cAbort        AS CHARACTER  NO-UNDO.

  IF {fn getUseRepository} = FALSE THEN
  DO:
    MESSAGE "Transfer to Crystal not available."  
            VIEW-AS ALERT-BOX 
              INFORMATION 
              TITLE "Print Error".

    RETURN.  
  END.

  IF SEARCH(SESSION:TEMP-DIRECTORY + "/aftemfullb.mdb":U) = ? THEN
  DO:
    IF SEARCH("af/rep/aftemfullb.mdb":U) = ? THEN
    DO:
      ASSIGN
        cErrorMessage = SUBSTITUTE({fnarg messageNumber 48}, "af/rep/aftemfullb.mdb").
      IF VALID-HANDLE(gshSessionManager) THEN
        RUN showMessages IN gshSessionManager (INPUT cErrorMessage,
                                               INPUT "INF":U,
                                               INPUT "OK":U,
                                               INPUT "OK":U,
                                               INPUT "OK":U,
                                               INPUT "Crystal Print Error",
                                               INPUT YES,
                                               INPUT ?,
                                               OUTPUT cAbort).
      ELSE
        MESSAGE cErrorMessage
                VIEW-AS ALERT-BOX 
                  INFORMATION 
                  TITLE "Crystal Print Error".
      RETURN.
    END.
    ELSE
    DO:
      OS-COPY VALUE(SEARCH("af/rep/aftemfullb.mdb":U)) VALUE((SESSION:TEMP-DIRECTORY + "/aftemfullb.mdb":U)).
      IF OS-ERROR <> 0 THEN
      DO:
        ASSIGN
          cErrorMessage = SUBSTITUTE({fnarg messageNumber 49}, "af/rep/aftemfullb.mdb").
        IF VALID-HANDLE(gshSessionManager) THEN
          RUN showMessages IN gshSessionManager (INPUT cErrorMessage,
                                                 INPUT "INF":U,
                                                 INPUT "OK":U,
                                                 INPUT "OK":U,
                                                 INPUT "OK":U,
                                                 INPUT "Crystal Print Error",
                                                 INPUT YES,
                                                 INPUT ?,
                                                 OUTPUT cAbort).
        ELSE
          MESSAGE cErrorMessage
                  VIEW-AS ALERT-BOX 
                    INFORMATION 
                    TITLE "Crystal Print Error".
        RETURN.
      END.    
    END.
  END.    

  IF SEARCH("af/rep/aflandscap.rpt":U) = ?  THEN
  DO:
    ASSIGN
      cErrorMessage = SUBSTITUTE({fnarg messageNumber 50}, "af/rep/aflandscap.rpt").
    IF VALID-HANDLE(gshSessionManager) THEN
      RUN showMessages IN gshSessionManager (INPUT cErrorMessage,
                                             INPUT "INF":U,
                                             INPUT "OK":U,
                                             INPUT "OK":U,
                                             INPUT "OK":U,
                                             INPUT "Crystal Print Error",
                                             INPUT YES,
                                             INPUT ?,
                                             OUTPUT cAbort).
      ELSE
        MESSAGE cErrorMessage
                VIEW-AS ALERT-BOX 
                  INFORMATION 
                  TITLE "Crystal Print Error".
    RETURN.
  END.

  IF SEARCH("af/rep/afportrait.rpt":U) = ? THEN
  DO:
    ASSIGN
      cErrorMessage = SUBSTITUTE({fnarg messageNumber 51}, "af/rep/afportrait.rpt").
    IF VALID-HANDLE(gshSessionManager) THEN
      RUN showMessages IN gshSessionManager (INPUT cErrorMessage,
                                             INPUT "INF":U,
                                             INPUT "OK":U,
                                             INPUT "OK":U,
                                             INPUT "OK":U,
                                             INPUT "Crystal Print Error",
                                             INPUT YES,
                                             INPUT ?,
                                             OUTPUT cAbort).
    ELSE
      MESSAGE cErrorMessage
              VIEW-AS ALERT-BOX 
                INFORMATION 
                TITLE "Crystal Print Error".
    RETURN.
  END.
  plOk = TRUE.

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-checkExcel) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE checkExcel Procedure 
PROCEDURE checkExcel :
/*------------------------------------------------------------------------------
  Purpose:   Check if excel is installed   
  Parameters:  <none>
  Notes:     Called before tableout is called in the SDO    
------------------------------------------------------------------------------*/
  DEFINE OUTPUT PARAMETER plOk AS LOGICAL    NO-UNDO.
  
  DEFINE VARIABLE cMessage AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cAbort   AS CHARACTER  NO-UNDO.
  
  /* If Excel is not installed, there's no point in going on.  Check first. */
  LOAD "Excel.Application":U BASE-KEY "HKEY_CLASSES_ROOT":U NO-ERROR.
  ASSIGN plOk = (ERROR-STATUS:ERROR = NO).
  UNLOAD "Excel.Application":U NO-ERROR.
  
  IF NOT plOk THEN 
  DO:
    SESSION:SET-WAIT-STATE("":U).

    cMessage = {fnarg messageNumber 56}.
    IF VALID-HANDLE(gshSessionManager) THEN
      RUN showMessages IN gshSessionManager 
          (INPUT cMessage,
           INPUT "INF":U,
           INPUT "OK":U,
           INPUT "OK":U,
           INPUT "OK":U,
           INPUT "Excel Transfer Error",
           INPUT YES,
           INPUT ?,
           OUTPUT cAbort).
    ELSE 
      MESSAGE cMessage VIEW-AS ALERT-BOX INFORMATION.    
  END.

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-disable_UI) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI Procedure 
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE OBJECT THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-exportData) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE exportData Procedure 
PROCEDURE exportData :
/*------------------------------------------------------------------------------
  Purpose:     Export the contents of an SDO to another tool  
  Parameters:  input data object handle to export data from
               input type  - Currently 'Excel' or 'Crystal' 
               input field list or leave blank for all (no table prefix)
                     The list is assumed to be 'Visible Fields'.   
               input include object fields yes/no
               input use existing running tool (currently only excel) yes/no
               input maximum records to process 
                     ? - Is signal to prompt for max records and all or disp.                      
                     This ensures backwards compatibility if anyone uses the 
                     old style of asking before calling printToExcel in an SDO  
  Notes:       Always excludes rowobject specific fields,
               e.g. RowNum,RowIdent,RowMod.
               Uses tableout procedure in the SDO.
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER phDataObject     AS HANDLE     NO-UNDO.
DEFINE INPUT  PARAMETER pcType           AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER pcFieldList      AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER plIncludeObj     AS LOGICAL    NO-UNDO.
DEFINE INPUT  PARAMETER plUseExisting    AS LOGICAL    NO-UNDO.
DEFINE INPUT  PARAMETER piMaxRecords     AS INTEGER    NO-UNDO.

DEFINE VARIABLE cMessage     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE lVisible     AS LOGICAL    NO-UNDO.
DEFINE VARIABLE lCancel      AS LOGICAL    NO-UNDO.
DEFINE VARIABLE cTitle       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE lExport      AS LOGICAL    NO-UNDO.
DEFINE VARIABLE iRecordCount AS INTEGER    NO-UNDO.
DEFINE VARIABLE cAbort       AS CHARACTER  NO-UNDO.

/* Ensure there are no unsaved or uncommitted data */
RUN confirmContinue IN phDataObject (INPUT-OUTPUT lCancel).

IF lCancel THEN 
  RETURN.

/* Unknown maxrecords is signal to ask for max records */
IF piMaxRecords = ? OR piMaxRecords = 0 THEN
DO:
  CASE pcType:
    WHEN 'Excel':U THEN
      cMessage  = {fnarg messageNumber 90}.
    WHEN 'Crystal':U THEN
      cMessage  = {fnarg messageNumber 91}.
  END CASE.
  ASSIGN
    cTitle       = xcAskTitle + ' ':U + CAPS(SUBSTR(pcType,1,1)) + LC(SUBSTR(pcType,2)).
    piMaxRecords = 500.

  RUN askQuestion IN TARGET-PROCEDURE 
    (cMessage,
     cTitle,
     pcFieldList > '':U,
     INPUT-OUTPUT piMaxRecords,
     OUTPUT lVisible).

  IF lVisible = ? THEN
    RETURN.

  IF NOT lVisible THEN
    pcFieldList = '':U.

END.

/* As for now, not no-error...  */
RUN VALUE('check':U + pcType) (OUTPUT lExport).
IF NOT lExport THEN
  RETURN.

/* Get data to export to excel */
IF pcFieldList = "":U THEN
    ASSIGN pcFieldList = "!RowIdentIdx,!RowUserProp,!RowNum,!RowIdent,!RowMod,*":U.
ELSE
    ASSIGN pcFieldList = pcFieldList + ",!RowIdentIdx,!RowUserProp,!RowNum,!RowIdent,!RowMod":U.

/* tableOut will return a record for each cell we need to populate */
RUN tableOut IN phDataObject (INPUT pcFieldList, 
                              INPUT plIncludeObj, 
                              INPUT piMaxRecords, 
                              OUTPUT TABLE ttTable, 
                              OUTPUT iRecordCount).

/* If we can't find anything to export.. */
IF NOT CAN-FIND(FIRST ttTable) THEN 
DO:
  SESSION:SET-WAIT-STATE("":U).
  cMessage = SUBSTITUTE({fnarg messageNumber 57},pcType).
  IF VALID-HANDLE(gshSessionManager) THEN
    RUN showMessages IN gshSessionManager 
        (INPUT cMessage,
         INPUT "INF":U,
         INPUT "OK":U,
         INPUT "OK":U,
         INPUT "OK":U,
         INPUT "Excel Tranfer Error",
         INPUT YES,
         INPUT ?,
         OUTPUT cAbort).
  ELSE 
    MESSAGE cMessage VIEW-AS ALERT-BOX INFORMATION.    

  RETURN.
END.

SESSION:SET-WAIT-STATE("GENERAL":U).

/* The transferTo APIs are currently privat as we probably want to aim for a 
   more consistent signature for extensibility 
   (useexisting should probably apply to Crystal? ) */  

CASE pcType:
  WHEN 'Excel':U THEN
    RUN exportToExcel IN TARGET-PROCEDURE (plUseExisting).
  WHEN 'Crystal':U THEN
    RUN exportToCrystal  IN TARGET-PROCEDURE (phDataObject,
                                              iRecordCount,
                                              piMaxRecords).    
END.

SESSION:SET-WAIT-STATE("":U).

ERROR-STATUS:ERROR = NO.

RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-exportToCrystal) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE exportToCrystal Procedure 
PROCEDURE exportToCrystal PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     Transfers the contents of the ttTable retruend from the SDO to 
               Crystal.
  Parameters:  input phDataObject 
               input piNumRecords  - Number of records 
               input piMaxRecords  - Max records to process               
  Notes:       Always excludes rowobject specific fields,
               e.g. RowNum,RowIdent,RowMod
               Uses tableout procedure defined in here also.
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER phDataObject           AS HANDLE       NO-UNDO.  
  DEFINE INPUT PARAMETER piNumRecords           AS INTEGER      NO-UNDO.
  DEFINE INPUT PARAMETER piMaxRecords           AS INTEGER      NO-UNDO.

  DEFINE VARIABLE cDataObject                   AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cTemplate                     AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cNewReport                    AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cFilter                       AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE hContainerSource              AS HANDLE       NO-UNDO.
  DEFINE VARIABLE cLogicalObjectName            AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cRunAttribute                 AS CHARACTER    NO-UNDO.                                                         
  DEFINE VARIABLE csdoName                      AS CHARACTER    NO-UNDO.                                                     
  DEFINE VARIABLE cWindowTitle                  AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cTables                       AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cFirstTable                   AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE iLoop                         AS INTEGER      NO-UNDO.
  DEFINE VARIABLE hParentWindow                 AS HANDLE       NO-UNDO.
  DEFINE VARIABLE cSdoSignature                 AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cFilterSettings               AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE rRowid                        AS ROWID        NO-UNDO.
  DEFINE VARIABLE cFieldNames                   AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cFieldValues                  AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cFieldOperators               AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cOperator                     AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cValue                        AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE iNumberOfColumns              AS INTEGER      NO-UNDO.
  DEFINE VARIABLE iNumberOfRows                 AS INTEGER      NO-UNDO.
  DEFINE VARIABLE cDataType                     AS CHARACTER    NO-UNDO.      
  DEFINE VARIABLE cDataTypeList                 AS CHARACTER    NO-UNDO.      
  DEFINE VARIABLE cFieldLabel                   AS CHARACTER    NO-UNDO.      
  DEFINE VARIABLE cFieldLabelList               AS CHARACTER    NO-UNDO.      
  DEFINE VARIABLE cFieldName                    AS CHARACTER    NO-UNDO.      
  DEFINE VARIABLE cFieldNameList                AS CHARACTER    NO-UNDO.      
  DEFINE VARIABLE dWidth                        AS DECIMAL      NO-UNDO.      
  DEFINE VARIABLE dReportWidth                  AS DECIMAL      NO-UNDO.      
  DEFINE VARIABLE cFieldWidthList               AS CHARACTER    NO-UNDO.      
  DEFINE VARIABLE cLabel                        AS CHARACTER    NO-UNDO.      
  DEFINE VARIABLE iRecordCnt                    AS INTEGER      NO-UNDO.
  DEFINE VARIABLE cHighChar                     AS CHARACTER    NO-UNDO.

  SESSION:SET-WAIT-STATE("GENERAL":U).

  ASSIGN 
    iNumberOfColumns  = 0
    iNumberOfRows     = 0
    cDataTypeList     = "":U
    cFieldLabelList   = "":U
    cFieldNameList    = "":U
    cFieldWidthList   = "":U
    .

  /* build list of field labels */
  FOR EACH ttTable WHERE ttTable.irow = 0:
    ASSIGN
      cFieldLabelList  = cFieldLabelList 
                        + (IF cFieldLabelList <> "":U THEN ",":U ELSE "":U) 
                        + ttTable.cCell
      iNumberOfColumns = iNumberOfColumns + 1 
      .
  END.

  /* build list of field names */
  FOR EACH ttTable WHERE ttTable.irow = 1:
    ASSIGN
      cFieldNameList = cFieldNameList
                     + (IF cFieldNameList <> "":U THEN ",":U ELSE "":U)
                     + ttTable.cCell 
      .
  END.

  /* build list of field datatypes */
  FOR EACH ttTable WHERE ttTable.irow = 2:
    ASSIGN
      cDataTypeList = cDataTypeList 
                    + (IF cDataTypeList <> "":U THEN ",":U ELSE "":U) 
                    + ttTable.cCell 
      .     
  END.

  /* list of field widths, chr(3) delimited to cope with European formats */
  FOR EACH ttTable WHERE ttTable.irow = 3:
    ASSIGN
      cFieldWidthList = cFieldWidthList
                      + (IF cFieldWidthList <> "":U THEN CHR(3) ELSE "":U)
                      + ttTable.cCell 
      .
  END.
  
  /* get sdo signature and see if any filters exist so we can add these to the report */
  {get ContainerSource hContainerSource phDataObject}.
  IF VALID-HANDLE(hContainerSource) THEN
  DO:
    {get LogicalObjectName cLogicalObjectName hContainerSource}.
    {get RunAttribute cRunAttribute hContainerSource}.
    {get containerHandle hParentWindow hContainerSource}.

    /* cope with static objects */
    IF cLogicalObjectName = "":U THEN
      {get LogicalObjectName cLogicalObjectName hContainerSource}.
  END.

  ASSIGN
    cSdoName      = phDataObject:FILE-NAME
    cSdoSignature = cSdoName + ",":U + cLogicalObjectName + ",":U /* + cRunAttribute */
    cWindowTitle  = IF VALID-HANDLE(hParentWindow) THEN " - ":U + hparentWindow:TITLE ELSE "":U
    rRowid        = ?
    cFilter       = "":U
    .

  IF VALID-HANDLE(gshProfileManager) THEN
    RUN getProfileData IN gshProfileManager (
        INPUT "BrwFilters":U,
        INPUT "FilterSet":U,
        INPUT cSdoSignature,
        INPUT NO,
        INPUT-OUTPUT rRowid,
        OUTPUT cFilterSettings).

  ASSIGN
    cFilter = {fnarg messageNumber 35}
    cFilter = SUBSTITUTE( cFilter , 
                          TRIM(STRING(iRecordCnt,">>>>>>>9")) , 
                          TRIM(STRING(piMaxRecords,">>>>>>>9")) ).
  IF NUM-ENTRIES(cFilterSettings,CHR(3)) = 3 THEN
  DO:
    IF VALID-HANDLE(gshGenManager) THEN
      cHighChar = DYNAMIC-FUNCTION("getHighKey":U IN gshGenManager, SESSION:CPCOLL).
    ELSE 
      cHighChar = CHR(127). /* just as a default high character */
    ASSIGN  
      cFieldNames     = ENTRY(1,cFilterSettings,CHR(3))
      cFieldValues    = ENTRY(2,cFilterSettings,CHR(3))
      cFieldOperators = ENTRY(3,cFilterSettings,CHR(3)).
    DO iLoop = 1 TO NUM-ENTRIES(cFieldNames):
      ASSIGN
        cFieldName  = ENTRY(iLoop,cFieldNames)
        cOperator   = ENTRY(iLoop,cFieldOperators)
        cValue      = TRIM(ENTRY(iLoop,cFieldValues,CHR(1)),cHighChar)
        cFilter     = cFilter + "(":U + cFieldName + cOperator + cValue + ") ":U
        .  
    END.
  END.

  /* now build temp-table to transfer to crystal */
  EMPTY TEMP-TABLE ttDataSource.

  /*Heading*/
  CREATE ttDataSource.
  ASSIGN 
      ttDataSource.ttTag      = "F0":U
      ttDataSource.ttValue[1] = "Print ":U + cWindowTitle
      ttDataSource.ttValue[2] = cFilter 
      NO-ERROR.

  /*Fieldnames*/
  CREATE ttDataSource.
  ASSIGN 
      ttDataSource.ttTag = "F1":U.
  DO iLoop = 1 TO NUM-ENTRIES(cFieldNameList):
    ASSIGN
      ttDataSource.ttValue[iLoop] = REPLACE(ENTRY(iLoop, cFieldNameList),".":U,"_":U).    
  END.

  /*Labels*/
  CREATE ttDataSource.
  ASSIGN 
      ttDataSource.ttTag = "F2":U.
  DO iLoop = 1 TO NUM-ENTRIES(cFieldLabelList):
    ASSIGN
      ttDataSource.ttValue[iLoop] = ENTRY(iLoop, cFieldLabelList).
  END.

  ASSIGN
    dReportWidth = 0.

  /*Column Widths*/
  CREATE ttDataSource.
  ASSIGN 
      ttDataSource.ttTag = "F3":U.
  DO iLoop = 1 TO NUM-ENTRIES(cFieldWidthList, CHR(3)):
    ASSIGN
      cLabel    = ENTRY(iLoop, cFieldLabelList)
      dWidth    = DECIMAL(ENTRY(iLoop,cFieldWidthList,CHR(3)))
      .
    IF LENGTH(cLabel) > dWidth THEN
      ASSIGN dWidth = LENGTH(cLabel).

    ASSIGN
      ttDataSource.ttValue[iLoop] = STRING(dWidth).

    IF dWidth > 0 THEN
      ASSIGN dReportWidth = dReportWidth + (dWidth * 96).

  END.

  /*Data Types*/
  CREATE ttDataSource.
  ASSIGN 
      ttDataSource.ttTag = "F4":U.
  DO iLoop = 1 TO NUM-ENTRIES(cDataTypeList):
    ASSIGN
      ttDataSource.ttValue[iLoop] = "10":U.
  END.

  ASSIGN
    iNumberOfColumns = IF iNumberOfColumns > 26 THEN 26 ELSE iNumberOfColumns.

  data-loop:
  FOR EACH ttTable
     WHERE ttTable.iRow > 9
     BREAK BY ttTable.iRow:

    IF ttTable.iCol > iNumberOfColumns THEN NEXT data-loop.
    IF ttTable.iCol = 1 THEN ASSIGN iNumberOfRows = ttTable.iRow.

    ASSIGN
      cDataType = ENTRY(ttTable.iCol, cDataTypeList)
      .

    IF FIRST-OF(ttTable.iRow) THEN
    DO:
      CREATE ttDataSource.
      ASSIGN 
          ttDataSource.ttTag = "D":U.
    END.

    ASSIGN
        ttDataSource.ttValue[ttTable.iCol] = IF cDataType = "INTEGER":U
                                        THEN STRING(INTEGER(ttTable.cCell))
                                        ELSE IF cDataType = "DECIMAL":U
                                        THEN STRING(DECIMAL(REPLACE(ttTable.cCell,"%":U,"":U)))
                                        ELSE IF cDataType = "CHARACTER":U
                                        AND  LENGTH( ttTable.cCell ) > 319
                                        THEN SUBSTRING( ttTable.cCell, 1, 319 )
                                        ELSE ttTable.cCell
                                        .
  END.  /* data-loop */

  ASSIGN
    cTables     = DYNAMIC-FUNCTION("getTables":U IN phDataObject)
    cFirstTable = ENTRY(1,cTables)
    cDataObject = SEARCH(SESSION:TEMP-DIRECTORY + "/aftemfullb.mdb":U)
    cTemplate   = IF dReportWidth <= 11150 
                  THEN SEARCH("af/rep/afportrait.rpt":U) /* WIDTH = 11150 */
                  ELSE SEARCH("af/rep/aflandscap.rpt":U) /* WIDTH = 16219 */
    cNewReport  = RIGHT-TRIM(RIGHT-TRIM(SESSION:TEMP-DIRECTORY,"~\"),"/") + "/":U + cFirstTable + ".rpt":U
    .

  SESSION:SET-WAIT-STATE("":U).

  {launch.i &PLIP = 'af/sup2/afcrplip2p.p':U
            &IProc = 'mip-print-report':U
            &PList="(TABLE ttDataSource,cDataObject,cFirstTable,NO,cTemplate,cNewReport)"
            &OnApp = 'no':U
            &Autokill = NO}

  ERROR-STATUS:ERROR = NO.

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-exportToExcel) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE exportToExcel Procedure 
PROCEDURE exportToExcel PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:   Check if excel is installed   
  Parameters:  <none>
  Notes:     Called before tableout is called in the SDO    
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER plUseExisting AS LOGICAL    NO-UNDO.

DEFINE VARIABLE chExcel              AS COM-HANDLE NO-UNDO.
DEFINE VARIABLE chWorkbook           AS COM-HANDLE NO-UNDO.
DEFINE VARIABLE chWorkSheet          AS COM-HANDLE NO-UNDO.
DEFINE VARIABLE cRow                 AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cRange1              AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cRange2              AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cRange3              AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cFullRange           AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cNumericCellString   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE iNumberOfColumns     AS INTEGER    NO-UNDO.
DEFINE VARIABLE iNumberOfRows        AS INTEGER    NO-UNDO.
DEFINE VARIABLE lExcelInstalled      AS LOGICAL    NO-UNDO.
DEFINE VARIABLE cDataType            AS CHARACTER  NO-UNDO.      
DEFINE VARIABLE cDataTypeList        AS CHARACTER  NO-UNDO.      
DEFINE VARIABLE iTemp1               AS INTEGER    NO-UNDO.
DEFINE VARIABLE iTemp2               AS INTEGER    NO-UNDO.
DEFINE VARIABLE lDispAnotherLine     AS LOGICAL    NO-UNDO.
DEFINE VARIABLE cNextLineToDisp      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cLabel               AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cLastColumn          AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cExportFilename      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE lCancel              AS LOGICAL    NO-UNDO.
DEFINE VARIABLE iColumns             AS INTEGER    NO-UNDO.
DEFINE VARIABLE cMessage             AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cOSNumericPoint      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cOSThousandSeparator AS CHARACTER  NO-UNDO.
DEFINE VARIABLE iReturnValue         AS INTEGER    NO-UNDO.
DEFINE VARIABLE lConvertToOSNumeric  AS LOGICAL    NO-UNDO.

/*  Windows but now running on another OS */
IF OPSYS = "win32":U THEN 
DO:
  /* Numeric point */
  ASSIGN cOSNumericPoint = FILL("x",50).
  RUN GetLocaleInfoA (1024, 
                      14, 
                      INPUT-OUTPUT cOSNumericPoint, 
                      LENGTH(cOSNumericPoint), 
                      OUTPUT iReturnValue).
  ASSIGN cOSNumericPoint = TRIM(cOSNumericPoint).

  /* Thousand seperator */
  ASSIGN cOSThousandSeparator = FILL("x",50).
  RUN GetLocaleInfoA (1024, 
                      15, 
                      INPUT-OUTPUT cOSThousandSeparator, 
                      LENGTH(cOSThousandSeparator), 
                      OUTPUT iReturnValue).
  ASSIGN cOSThousandSeparator = TRIM(cOSThousandSeparator).

  IF SESSION:NUMERIC-DECIMAL-POINT <> cOSNumericPoint
  OR SESSION:NUMERIC-SEPARATOR     <> cOSThousandSeparator THEN
    ASSIGN lConvertToOSNumeric = YES.
  ELSE
    ASSIGN lConvertToOSNumeric = NO.
END.
ELSE
  ASSIGN lConvertToOSNumeric = NO.

/* We've got data, now get it into Excel.     *
 * First, determine how many columns we have. */
FIND LAST ttTable WHERE ttTable.iCol = 1 NO-ERROR.
IF AVAILABLE ttTable THEN
    ASSIGN iNumberOfRows = ttTable.iRow.

FIND LAST ttTable WHERE ttTable.iRow = 1 NO-ERROR.

IF AVAILABLE ttTable THEN
  ASSIGN cDataTypeList = FILL(",":U, ttTable.iCol - 1)
         cRow          = "A".

/* build list of field datatypes */
FOR EACH ttTable WHERE ttTable.irow = 2:
    ASSIGN ENTRY(ttTable.iCol, cDataTypeList) = ttTable.cCell.
END.

/* Now dump all the data to disk, we'll load in into Excel from there. */
FILE-INFO:FILE-NAME = SESSION:TEMP-DIRECTORY. /* The temp dir could be relatively pathed, so we need to use the full path */
ASSIGN cLabel          = STRING(TIME, "HH:MM:SS")
       cLabel          = REPLACE(cLabel, ":":U, "":U)       
       cExportFilename = FILE-INFO:FULL-PATHNAME + "~\":U + "ExcelExport_" + cLabel + ".dmp":U.

OUTPUT TO VALUE(cExportFilename).

/* Export headers */
fe-blk:
FOR EACH ttTable
   WHERE ttTable.iRow = 0
   BREAK BY ttTable.iRow
         BY ttTable.iCol:

  IF ttTable.iCol = 1 THEN 
    PUT UNFORMATTED "Dummy Heading".
  ELSE
    PUT UNFORMATTED CHR(9) + "Dummy Heading".

  IF LAST-OF(ttTable.iRow) THEN
    PUT SKIP.
END.

/* Export data */
fe-blk:
FOR EACH ttTable
   WHERE ttTable.iRow > 9
   BREAK BY ttTable.iRow
         BY ttTable.iCol
      ON ERROR UNDO fe-blk, LEAVE fe-blk:

  ASSIGN cDataType = ENTRY(ttTable.iCol, cDataTypeList).

  /* Remove any tabs from the cell.  We use them as a delimiter, so having them in data is going to screw up our layout */
  ASSIGN ttTable.cCell = REPLACE(ttTable.cCell, CHR(9), " ":U).

  /* If the data type is numeric, format it so it makes sense to Excel */
  CASE cDataType:
    WHEN "DECIMAL":U OR WHEN "INTEGER":U THEN 
    DO:
      /* Remove any percentage symbols, and plus signs ... */
      ASSIGN cNumericCellString = REPLACE(ttTable.cCell, "%":U, "":U)
             cNumericCellString = REPLACE(cNumericCellString, "+":U, "":U).

      /* ... the convert all DR/CR symbols and parentheses to '-' where neccessary ... */
      IF cNumericCellString BEGINS "(":U THEN
          ASSIGN cNumericCellString = "-":U + SUBSTRING(cNumericCellString,2)
                 cNumericCellString = SUBSTRING(cNumericCellString, 1, LENGTH(cNumericCellString) - 1).

      ASSIGN cNumericCellString = REPLACE(cNumericCellString, "DR":U, "-":U)
             cNumericCellString = REPLACE(cNumericCellString, "CR":U, "-":U)
             cNumericCellString = REPLACE(cNumericCellString, "DB":U, "-":U).

      /* ... then make sure that the negative sign is leading (by now we should have a regular decimal/integer) */
      IF cDataType = "DECIMAL":U THEN 
      DO:
          IF NOT cNumericCellString BEGINS "-":U
          AND DECIMAL(cNumericCellString) < 0 THEN
            ASSIGN cNumericCellString = "-":U + STRING(ABSOLUTE(DECIMAL(cNumericCellString))) NO-ERROR.
      END.
      ELSE DO:
          IF NOT cNumericCellString BEGINS "-":U
          AND INTEGER(cNumericCellString) < 0 THEN
              ASSIGN cNumericCellString = "-":U + STRING(ABSOLUTE(INTEGER(cNumericCellString))) NO-ERROR.
      END.

      /* Make sure the decimal point and numeric separators in our file correspond to what Excel is going to use. */ 
      IF lConvertToOSNumeric = YES THEN
          ASSIGN cNumericCellString = REPLACE(cNumericCellString, SESSION:NUMERIC-DECIMAL-POINT, CHR(1))
                 cNumericCellString = REPLACE(cNumericCellString, SESSION:NUMERIC-SEPARATOR, CHR(2))
                 cNumericCellString = REPLACE(cNumericCellString, CHR(1), cOSNumericPoint)
                 cNumericCellString = REPLACE(cNumericCellString, CHR(2), cOSThousandSeparator)
                 NO-ERROR.

      /* Just in case there's something wrong */
      IF ERROR-STATUS:ERROR THEN
          ASSIGN cNumericCellString = ttTable.cCell.

      ASSIGN ttTable.cCell = cNumericCellString.
    END.

    WHEN "CHARACTER":U THEN
      ASSIGN ttTable.cCell = '"':U + ttTable.cCell + '"':U /* csv file wants quotes around characters */
             ttTable.cCell = SUBSTRING(ttTable.cCell, 1, 319) WHEN LENGTH(ttTable.cCell) > 319 
             NO-ERROR.
  END CASE.

  /* Now export the value to the file on disk */
  IF ttTable.iCol = 1 THEN 
    PUT UNFORMATTED ttTable.cCell.
  ELSE
    PUT UNFORMATTED CHR(9) + ttTable.cCell.

  IF LAST-OF(ttTable.iRow) THEN
    PUT SKIP.
END.
OUTPUT CLOSE.

/* The file is now on disk, open Excel and open the file on disk */
IF plUseExisting = ? THEN ASSIGN plUseExisting = YES.

IF plUseExisting THEN
    CREATE "Excel.Application" chExcel CONNECT NO-ERROR.

IF NOT VALID-HANDLE(chExcel) THEN
    CREATE "Excel.Application" chExcel.

ASSIGN chExcel:WindowState   = -4140 /* Minimized */
       chExcel:VISIBLE       = FALSE
       chExcel:DisplayAlerts = FALSE
       chWorkbook            = chExcel:Workbooks:OPEN(cExportFilename,,,1)
       chWorkSheet           = chExcel:Sheets:ITEM(1).

/* Excel locks the file on disk until the workbook is closed, preventing us from
   cleaning up properly.  To get around this, we cut the cells from the existing 
   worksheet, close the workbook, and paste the data into a new workbook.  
   We can then delete the file on disk. There must be a better way to do this, 
   feel free to replace this code with a better solution.  */
ASSIGN iColumns    = NUM-ENTRIES(cDataTypeList)
       iTemp1      = IF iColumns MODULO 26 = 0 THEN 1 ELSE 0
       iTemp2      = IF iColumns MODULO 26 = 0 THEN 26 ELSE 0
       cLastColumn = IF iColumns LE 26
                     THEN CHR(ASC(cRow) + (iColumns - 1))
                     ELSE CHR(64 + INTEGER(TRUNCATE(iColumns / 26, 0)) - iTemp1 )
                        + CHR(64 + (iColumns MODULO 26) + iTemp2).

/* Cut the data and close the workbook */
cFullRange = "A1:" + cLastColumn + STRING(iNumberOfRows - 8).
chWorkSheet:Range(cFullRange):CUT.
chWorkbook:CLOSE().

RELEASE OBJECT chWorkSheet NO-ERROR.
RELEASE OBJECT chWorkbook  NO-ERROR.
ASSIGN chWorkSheet = ?
       chWorkbook  = ?.

/* Create a new workbook and paste the data in there */
chWorkbook = chExcel:workbooks:ADD.
chWorkSheet = chExcel:Sheets:ITEM(1).
chWorkSheet:NAME = "Browser". 

/* Format the headers */
heading-loop:
FOR EACH ttTable 
   WHERE ttTable.iRow = 0
      BY ttTable.iCol:

    ASSIGN iNumberOfColumns 
                     = iNumberOfColumns + 1
           cRange1   = STRING((CHR(ASC(cRow) + (iNumberOfColumns - 1)) + STRING(1)))
           iTemp1    = IF iNumberOfColumns MODULO 26 = 0 THEN 1 ELSE 0
           iTemp2    = IF iNumberOfColumns MODULO 26 = 0 THEN 26 ELSE 0
           cRange1   = IF iNumberOfColumns LE 26 
                       THEN cRange1
                       ELSE CHR(64 + INTEGER(TRUNCATE(iNumberOfColumns / 26, 0)) - iTemp1) 
                          + CHR(64 + (iNumberOfColumns MODULO 26) + iTemp2) + STRING(1)
           cDataType = ENTRY(iNumberOfColumns, cDataTypeList).

    /* Set the numeric format on the columns */
    ASSIGN cRange3 = SUBSTRING(cRange1, 1, 1)
           cRange3 = IF iNumberOfColumns LE 26 
                     THEN cRange3
                     ELSE SUBSTRING(cRange1, 1, 2)
           chWorkSheet:Columns(cRange3):NumberFormat = IF cDataType = "DECIMAL":U
                                                       THEN (IF lConvertToOSNumeric = YES 
                                                             THEN "###" + cOSThousandSeparator + "###" + cOSThousandSeparator + "##0" + cOSNumericPoint + "00":U
                                                             ELSE "###" + SESSION:NUMERIC-SEPARATOR + "###" + SESSION:NUMERIC-SEPARATOR + "##0" + SESSION:NUMERIC-DECIMAL-POINT + "00":U)
                                                       ELSE (IF cDataType = "INTEGER":U 
                                                             THEN "#####0":U
                                                             ELSE "@":U).
    /* Set the cell to bold */
    ASSIGN chWorkSheet:Range(cRange1):Font:Bold = TRUE.
END. /* heading-loop */

chWorkSheet:PASTE.

/* Now populate the headers (they were formatted above but not populated).     *
 * We have to do it here because we can't format in the text file.  Also,      *
 * formatting the columns before filling them with data saves us a lot of      *
 * headache later.  If you try to fill with data and then format, doesn't work *
 * if Excel has "decided" what the column format should look like.             */
ASSIGN iNumberOfColumns = 0.
heading-loop:
FOR EACH ttTable 
   WHERE ttTable.irow = 0
      BY ttTable.iCol:

    ASSIGN iNumberOfColumns 
                         = iNumberOfColumns + 1
           cRange1       = STRING((CHR(ASC(cRow) + (iNumberOfColumns - 1)) + "1":U))
           iTemp1        = IF iNumberOfColumns MODULO 26 = 0 THEN 1  ELSE 0
           iTemp2        = IF iNumberOfColumns MODULO 26 = 0 THEN 26 ELSE 0
           cRange1       = IF iNumberOfColumns LE 26
                           THEN cRange1
                           ELSE CHR(64 + INTEGER(TRUNCATE(iNumberOfColumns / 26, 0)) - iTemp1) 
                              + CHR(64 + (iNumberOfColumns MODULO 26) + iTemp2) + STRING(1)
           ttTable.cCell = REPLACE(ttTable.cCell, "!":U, CHR(10))
           chWorkSheet:Range(cRange1):Formula = ttTable.cCell.
END.

/* We're not currently formatting data in the spreadsheet, but if we decide to, put the code in here */

/* Put a nice border around the headings and make sure everything fits nicely */
ASSIGN cLastColumn = IF iNumberofColumns LE 26
                     THEN CHR(ASC(cRow) + (iNumberofColumns - 1))
                     ELSE CHR(64 + INTEGER(TRUNCATE(iNumberofColumns / 26, 0)) - iTemp1 )
                        + CHR(64 + (iNumberofColumns MODULO 26) + iTemp2)
       iNumberofRows = iNumberOfRows - 8. /* real number of data rows */

cFullRange = "A1:" + cLastColumn + STRING(1).
chWorkSheet:Range(cFullRange):COLUMNS:BorderAround(1,-4138,-4105,-4105).

cFullRange = "A1:" + cLastColumn + STRING(iNumberOfRows).
chWorkSheet:Range(cFullRange):COLUMNS:BorderAround(1,-4138,-4105,-4105).
chWorkSheet:Range(cFullRange):COLUMNS:AutoFit.
chWorkSheet:Range(cFullRange):EntireRow:AutoFit.
chWorkSheet:Range("A1":U):Select.

SESSION:SET-WAIT-STATE("":U).

ASSIGN chExcel:DisplayAlerts = TRUE       
       chExcel:VISIBLE       = TRUE
       chExcel:WindowState   = -4143 /* Maximized */.

/* Do some housekeeping */
RELEASE OBJECT chWorkSheet NO-ERROR.
RELEASE OBJECT chWorkbook  NO-ERROR.
RELEASE OBJECT chExcel     NO-ERROR.

ASSIGN chWorkSheet = ?
       chWorkbook  = ?
       chExcel     = ?.

/* Empty the cell temp-table */
EMPTY TEMP-TABLE ttTable.

OS-DELETE VALUE(cExportFilename) NO-ERROR.
  
ASSIGN ERROR-STATUS:ERROR = NO.

RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

