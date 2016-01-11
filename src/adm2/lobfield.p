&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*********************************************************************
* Copyright (C) 2005 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*--------------------------------------------------------------------------
    File        : lobfield.p
    Purpose     : Super procedure for lobfield class.

    Syntax      : RUN start-super-proc("adm2/lobfield.p":U).

    Modified    : 04/25/2004
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

DEFINE VARIABLE giSequence AS INTEGER   NO-UNDO.
DEFINE VARIABLE giCycle    AS INTEGER   NO-UNDO INIT 1000.

&SCOPED-DEFINE tempfileextension "tmp"
&SCOP ADMSuper lobfield.p

  /* Custom exclude file */

  {src/adm2/custom/lobfieldexclcustom.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-assignLOBFileName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD assignLOBFileName Procedure 
FUNCTION assignLOBFileName RETURNS LOGICAL
  ( pcfile AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-clearPointer) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD clearPointer Procedure 
FUNCTION clearPointer RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-deleteLOBFile) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD deleteLOBFile Procedure 
FUNCTION deleteLOBFile RETURNS LOGICAL
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fillData) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fillData Procedure 
FUNCTION fillData RETURNS LOGICAL
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getAutoFill) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getAutoFill Procedure 
FUNCTION getAutoFill RETURNS LOGICAL
       (   ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getLOBFileName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getLOBFileName Procedure 
FUNCTION getLOBFileName RETURNS CHARACTER
       (   ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getLOBReference) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getLOBReference Procedure 
FUNCTION getLOBReference RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getTempFileNamePrefix) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getTempFileNamePrefix Procedure 
FUNCTION getTempFileNamePrefix RETURNS CHARACTER
  (   )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getTempLocation) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getTempLocation Procedure 
FUNCTION getTempLocation RETURNS CHARACTER
       (   ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-newTempFileName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD newTempFileName Procedure 
FUNCTION newTempFileName RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setAutoFill) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setAutoFill Procedure 
FUNCTION setAutoFill RETURNS LOGICAL
       ( pcAutoFill AS LOGICAL ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setLOBFileName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setLOBFileName Procedure 
FUNCTION setLOBFileName RETURNS LOGICAL
       ( pcLOBFileName AS CHARACTER ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setTempLocation) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setTempLocation Procedure 
FUNCTION setTempLocation RETURNS LOGICAL
       ( pcTempLocation AS CHARACTER ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF


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
         HEIGHT             = 15
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB Procedure 
/* ************************* Included-Libraries *********************** */

{src/adm2/lobprop.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-destroyObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE destroyObject Procedure 
PROCEDURE destroyObject :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   
   {fn deleteLOBFile}.
   {fn clearPointer}.

   RUN SUPER. 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-displayField) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE displayField Procedure 
PROCEDURE displayField :
/*------------------------------------------------------------------------------
  Purpose: display field value    
  Parameters:  <none>
  Notes:  Published/called from the viewer when a record is available   
         - clearfield is called when no record is avail.   
------------------------------------------------------------------------------*/
   DEFINE VARIABLE lAutoFill  AS LOGICAL    NO-UNDO.

   {fn deleteLOBFile}.
   {set DataModified FALSE}.
   {get AutoFill lAutoFill}.
   IF lAutoFill THEN
     {fn fillData}.

 END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-assignLOBFileName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION assignLOBFileName Procedure 
FUNCTION assignLOBFileName RETURNS LOGICAL
  ( pcfile AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  {fn deleteLobFile}.
  {set LOBFileName pcfile}.
  {set DataModified TRUE}.
  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-clearPointer) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION clearPointer Procedure 
FUNCTION clearPointer RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE mPointer  AS MEMPTR     NO-UNDO.
  
  {get PointerValue mPointer} NO-ERROR.
  IF NOT ERROR-STATUS:ERROR THEN
     SET-SIZE(mPointer) = 0.

  RETURN TRUE.   

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-deleteLOBFile) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION deleteLOBFile Procedure 
FUNCTION deleteLOBFile RETURNS LOGICAL
  (  ) :
/*------------------------------------------------------------------------------
  Purpose: Delete the current LOB File  
    Notes: Returns true if the file was deleted
           returns false if it was not.  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cLOBFileName AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iError        AS INTEGER    NO-UNDO.   
    
  {get LOBFileName cLOBFileName}.
  /* ensure we don't delete lobs added with assignLOBFileName */
  IF cLOBFileName BEGINS {fn getTempFileNamePrefix}
  AND ENTRY(NUM-ENTRIES(cLobfilename,"."),cLobfilename,".") = {&tempfileextension}  THEN
  DO:
    OS-DELETE VALUE(cLOBFileName).
    iError = OS-ERROR.
    CASE iError:
      /* successful delete or non existing file just return true */ 
      WHEN 0 OR WHEN 2 THEN
      DO:
        {set LOBFileName ''}.
        RETURN TRUE.
      END.

      OTHERWISE DO:
        MESSAGE {fnarg messageNumber 92} + ' (' + STRING(iError) + ')'  
          VIEW-AS ALERT-BOX ERROR.
        RETURN FALSE.
      END.
    END.
  END. /* LOBFileName > '' */
  
  RETURN FALSE. /* nothing done */   

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fillData) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fillData Procedure 
FUNCTION fillData RETURNS LOGICAL
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hViewer       AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hDataSource   AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cFieldName    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFileName     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cTempLocation AS CHARACTER  NO-UNDO.
  
  &SCOPED-DEFINE xp-assign
  {get ContainerSource hViewer}
  {get FieldName cFieldName}
  {get TempLocation cTempLocation}
  .
  &UNDEFINE xp-assign
  
  IF VALID-HANDLE(hViewer) THEN
  DO:
    {get DataSource hDataSource hViewer}.
    IF VALID-HANDLE(hDataSource) THEN
    DO:
      CASE cTempLocation:
        WHEN 'File':U THEN
        DO:
          cFileName = {fn newTempFileName}.
          DYNAMIC-FUNCTION('copyLargeColumnToFile':U IN hDataSource,
                            cFieldName,
                            cFileName). 
          {set LOBFileName cFileName}.
        END.
        WHEN 'Memptr':U THEN
        DO:
          DYNAMIC-FUNCTION('copyLargeColumnToMemptr':U IN hDataSource,
                           cFieldName,
                           {fn getPointerValue}).
        END.
        WHEN 'Longchar':U THEN
        DO:
          /* In order to avoid passing longchar data around we call 
             an event handler in the instance, which then can assign the data 
             directly from the SDO to the instance longchar storage */
          DYNAMIC-FUNCTION('fillLongcharValue':U IN TARGET-PROCEDURE, 
                           cFieldName,
                           hDataSource).
        END.
      END.
    END.
  END.

  RETURN FALSE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getAutoFill) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getAutoFill Procedure 
FUNCTION getAutoFill RETURNS LOGICAL
       (   ):
/*----------------------------------------------------------------------------- 
   Purpose: Indicates whether the object's data storage should be filled 
            automatically when the data source is repositioned.  
            - Yes - fill on position change 
            - No  - fill on demand (fillData)
 Parameter:  <none>
     Notes: 
 ------------------------------------------------------------------------------*/
  DEFINE VARIABLE cAutoFill AS LOGICAL NO-UNDO .
  {get AutoFill cAutoFill}.

  RETURN cAutoFill.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getLOBFileName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getLOBFileName Procedure 
FUNCTION getLOBFileName RETURNS CHARACTER
       (   ):
/*----------------------------------------------------------------------------- 
   Purpose: Stores the FileName that stores the current LOB value
 Parameter: <none>
     Notes: The name may change each time the LOB is filled   
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cLOBFileName AS CHARACTER NO-UNDO .

  {get LOBFileName cLOBFileName}.   
  RETURN cLOBFileName.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getLOBReference) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getLOBReference Procedure 
FUNCTION getLOBReference RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose: Returns the reference to pass to the updateTarget. 
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cTempLocation AS CHARACTER  NO-UNDO.

  {get TempLocation cTempLocation}.
  CASE cTempLocation:
    WHEN 'File':U THEN
       RETURN 'File,getLOBFileName,':U + STRING(TARGET-PROCEDURE).
    WHEN 'Memptr':U THEN
       RETURN 'Data,getPointerValue,':U + STRING(TARGET-PROCEDURE).
    WHEN 'Longchar':U THEN
       RETURN 'Data,getLongcharValue,':U + STRING(TARGET-PROCEDURE).

  END CASE.
  
  RETURN "".   

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getTempFileNamePrefix) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getTempFileNamePrefix Procedure 
FUNCTION getTempFileNamePrefix RETURNS CHARACTER
  (   ) :
/*------------------------------------------------------------------------------
  Purpose: Returns the fixed part of the temp-file name used to store 
           the lob. 
    Notes: This is used in newTempfileName to generate the name and in 
           deleteLOBfile to avoid deleting it. (we used to check -T only, but 
           customers might not define -T and it defaults to work dir.) 
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cFieldName AS CHARACTER   NO-UNDO.
  {get FieldName cFieldName}.

  RETURN SESSION:TEMP-DIR 
         + "tmplob-"
         + cFieldName
         + "-" 
         + STRING(TARGET-PROCEDURE). 

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getTempLocation) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getTempLocation Procedure 
FUNCTION getTempLocation RETURNS CHARACTER
       (   ):
/*----------------------------------------------------------------------------- 
   Purpose: Decides the temporary location of the LOB Data at runtime.     
            Values: 
            - File - External File in temp-directory (getLOBFileName)
            - Memptr - Memptr in instance   (getPointerValue) 
            - Longchar - Longchar in instance  (getLongcharValue)
 Parameter:  <none>
     Notes:
 ------------------------------------------------------------------------------*/
  DEFINE VARIABLE cTempLocation AS CHARACTER NO-UNDO.

  {get TempLocation cTempLocation}.

  RETURN cTempLocation.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-newTempFileName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION newTempFileName Procedure 
FUNCTION newTempFileName RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose: Generate a new temp file name  
    Notes: 
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cFieldName AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFormat    AS CHARACTER  NO-UNDO.

  {get FieldName cFieldName}.
  
  cFormat = FILL('9':U,LENGTH(STRING(giCycle))).

  IF giSequence >= giCycle THEN
    giSequence = 1.
  ELSE
    giSequence = giSequence + 1.

  RETURN {fn getTempFileNamePrefix} 
         + STRING(giSequence,cFormat)
         + "."
         + {&tempfileextension}.
         

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setAutoFill) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setAutoFill Procedure 
FUNCTION setAutoFill RETURNS LOGICAL
       ( pcAutoFill AS LOGICAL ):
/*----------------------------------------------------------------------------- 
   Purpose: Indicates whether the object's data storage should be filled 
            automatically when the data source is repositioned.  
 Parameter: pcAutoFill - Yes - fill on position change 
                         No  - fill on demand (fillData)
     Notes:
 ------------------------------------------------------------------------------*/
  {set AutoFill pcAutoFill}.

  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setLOBFileName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setLOBFileName Procedure 
FUNCTION setLOBFileName RETURNS LOGICAL
       ( pcLOBFileName AS CHARACTER ):
/*----------------------------------------------------------------------------- 
   Purpose: Stores the FileName that stores the current LOB value
 Parameter: pcLOBFileName
    Notes:
 ------------------------------------------------------------------------------*/
  {set LOBFileName pcLOBFileName}.

  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setTempLocation) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setTempLocation Procedure 
FUNCTION setTempLocation RETURNS LOGICAL
       ( pcTempLocation AS CHARACTER ):
/*----------------------------------------------------------------------------- 
   Purpose: Decides the temporary location of the LOB Data at runtime.
 Parameter: pcTempLocation
            - File - External File in temp-directory (getLOBFileName)
            - Memptr - Memptr in instance   (getPointerValue) 
            - Longchar - Longchar in instance  (getLongcharValue)
    Notes:
 ------------------------------------------------------------------------------*/
  {set TempLocation pcTempLocation}.

  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

