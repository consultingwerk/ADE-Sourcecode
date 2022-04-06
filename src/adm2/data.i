&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
/* Procedure Description
"Method Library for SmartDataObjects."
*/
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Method-Library 
/*********************************************************************
* Copyright (C) 2005 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*--------------------------------------------------------------------------
    Library     : data.i - Basic include file for the V9 SmartData object

    Syntax      : {src/adm2/data.i}

    Modified    : August 4, 2000 Version 9.1B
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

&IF "{&ADMClass}":U = "":U &THEN
   &GLOB ADMClass data
&ENDIF

&IF "{&ADMClass}":U = "data":U &THEN
  {src/adm2/dataprop.i}
&ELSE  
  /* if this is included in an extended class ensure that start-super-proc
     keeps the DataLogicObject started in this main block at the bottom of 
     the super-procedure stack */  
    &IF DEFINED(LAST-SUPER-PROCEDURE-PROP) = 0 &THEN
  &SCOPED-DEFINE LAST-SUPER-PROCEDURE-PROP DataLogicObject 
    &ENDIF
&ENDIF

/* exclude the smart.i version */
&SCOPED-DEFINE exclude-destroyObject

/* Exclude the static function and procedures for a dynamic data object */ 
&IF DEFINED(DATA-FIELD-DEFS) = 0 &THEN
   &SCOPED-DEFINE EXCLUDE-getRowObjUpdStatic
   &SCOPED-DEFINE EXCLUDE-serverCommit
   &SCOPED-DEFINE EXCLUDE-remoteCommit
   &SCOPED-DEFINE EXCLUDE-pushRowObjUpdTable
   &SCOPED-DEFINE EXCLUDE-pushTableAndValidate
&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-getRowObjUpdStatic) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getRowObjUpdStatic Method-Library 
FUNCTION getRowObjUpdStatic RETURNS HANDLE
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Method-Library
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: INCLUDE-ONLY
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Method-Library ASSIGN
         HEIGHT             = 13
         WIDTH              = 52.6.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB Method-Library 
/* ************************* Included-Libraries *********************** */

  {src/adm2/query.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Method-Library 


/* ***************************  Main Block  *************************** */
&IF DEFINED(ADM-EXCLUDE-STATIC) = 0 &THEN
IF NOT {&ADM-LOAD-FROM-REPOSITORY} THEN
DO:
  RUN start-super-proc("adm2/data.p":U).
  RUN start-super-proc("adm2/dataext.p":U).
  /* dataext.p is merely a simple "extension" of data.p.  This was necessary
     because data.p got too big and had to be broken up. 
     dataext.p have all get and set property functions and contains the 
     do* procedures for client TT management */
  RUN start-super-proc("adm2/dataextcols.p":U).
  /* dataextcols.p is also a simple "extension" of data.p.  This was necessary
     because the action segment became too big on A400 also after the split in 
     data and dataext. The functions in  dataextcols.p are column properties 
    (column and assignColumn functions) as well as col* procedures  */

  RUN start-super-proc("adm2/dataextapi.p":U).
 /* dataextapi.p is also a simple "extension" of data.p separated because the 
    ecode segment became too big. dataextapi.p contains the open client api */

  &IF DEFINED(DATA-FIELD-DEFS) = 0 &THEN
    {set DynamicData YES}.
  &ENDIF 
END.  /* if not adm-load-from-repos */
&ENDIF

&IF DEFINED(DATA-FIELD-DEFS) <> 0 &THEN
 
 DEFINE TEMP-TABLE RowObject {&DATA-TABLE-NO-UNDO}
  /* Allow users to ommit the hardcoded RCODE-INFORMATION and put it in the 
     include instead. 
     This makes it possible to manually maintain the include using LIKE 
     and thus avoid -inp and -tok limitations 
   ----------------------------------------    
    LIKE  CUSTOMER {&TEMP-TABLE-OPTIONS}  
   --------------------------------------*/
 &IF '{&TEMP-TABLE-OPTIONS}' = '' &THEN
     RCODE-INFORMATION
 &ENDIF
  
 /* The prepreprocessor check involving DATA-FIELD-DEFS is used to provide
    backward compatibility with how Beta 2 code defined the preprocessor.
   It got changed for final release to support spaces in the include file's
   path or name. The preprocessor is now a quoted file name. */

 &IF '{&DATA-FIELD-DEFS}' BEGINS '"' &THEN
   {{&DATA-FIELD-DEFS}}
 &ELSE
   {&DATA-FIELD-DEFS}
 &ENDIF
   {src/adm2/robjflds.i}.
 
 DEFINE TEMP-TABLE RowObjUpd    NO-UNDO LIKE RowObject
   FIELD ChangedFields AS CHARACTER.

 DEFINE QUERY    qDataQuery           FOR RowObject SCROLLING.
 DEFINE VARIABLE cContainerType       AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cQueryString         AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE hRowObject           AS HANDLE     NO-UNDO.
 DEFINE VARIABLE hDataQuery           AS HANDLE     NO-UNDO.
 DEFINE VARIABLE cColumns             AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cDataFieldDefs       AS CHARACTER  NO-UNDO.

 {set DynamicData NO}.
  cDataFieldDefs  = '{&DATA-FIELD-DEFS}':U.
  {set DataFieldDefs cDataFieldDefs}.
  hDataQuery = QUERY qDataQuery:HANDLE.  /* Temp-Table query */
  {set DataHandle hDataQuery}.
  /* Set up the RowObject query to be opened dynamically. */
  hRowObject = BUFFER RowObject:HANDLE.
  {set RowObject hRowObject}.  /* Handle of RowObject buffer.*/
  cQueryString = "FOR EACH " + hRowObject:NAME.
  {set DataQueryString cQueryString}.
  hDataQuery:QUERY-PREPARE(cQueryString).  
  hRowObject = BUFFER RowObjUpd:HANDLE.
  {set RowObjUpd hRowObject}. /* Row Update buffer handle. */
  hRowObject = TEMP-TABLE RowObject:HANDLE.
  {set RowObjectTable hRowObject}.  /*  RowObject temp-table handle. */
  hRowObject = TEMP-TABLE RowObjUpd:HANDLE.
  {set RowObjUpdTable hRowObject}.  /*  RowObjUpd temp-table handle. */

  /* Don't let this object be an Update-Target if its fields are not updatable*/
  {get UpdatableColumns cColumns}.   /* Fetch this prop, set in query.i */
  
  IF cColumns = "":U THEN
    RUN modifyListProperty(THIS-PROCEDURE, 'REMOVE':U, 'SupportedLinks':U,
        'Update-Target':U).

&ENDIF /* Static TT - defined(Data-field-defs) <> 0  */
    
&IF DEFINED(ADM-EXCLUDE-STATIC) = 0 &THEN
  /* _ADM-CODE-BLOCK-START _CUSTOM _INCLUDED-LIB-CUSTOM CUSTOM */
  {src/adm2/custom/datacustom.i}
  /* _ADM-CODE-BLOCK-END */
&ENDIF

&IF '{&DATA-LOGIC-PROCEDURE}':U <> '':U AND '{&DATA-LOGIC-PROCEDURE}':U <> '.p':U &THEN
  {set DataLogicProcedure '{&DATA-LOGIC-PROCEDURE}':U}.
&ENDIF

  /* defined in defintion section to exlude smart.i version */
&IF DEFINED(include-destroyobject) <> 0 &THEN
   &UNDEFINE exclude-destroyObject
&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-destroyObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE destroyObject Method-Library 
PROCEDURE destroyObject :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 DEFINE VARIABLE cDivision         AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE lDestroyStateless AS LOGICAL    NO-UNDO.

 RUN SUPER.

 &SCOPED-DEFINE xp-assign
  {get ASDivision cDivision}
  {get DestroyStateless lDestroyStateless}
  .  
  &UNDEFINE xp-assign
  
  IF (cDivision <> "SERVER":U AND SESSION:CLIENT-TYPE <> "WEBSPEED":U) OR 
    lDestroyStateless THEN
    {fn deleteProperties}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-pushRowObjUpdTable) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pushRowObjUpdTable Method-Library 
PROCEDURE pushRowObjUpdTable :
/*------------------------------------------------------------------------------
  Purpose:     wrapper for pre and postTransactionValidate procedures when
               run from SBO.
  Parameters:  INPUT pcValType AS CHARACTER -- "Pre" or "Post",
               INPUT-OUTPUT TABLE FOR RowObjUpd.
  Notes:     - This is an override of the dynamic version in data.p and is 
               conditionally excluded if there is no RowObject TT include.     
------------------------------------------------------------------------------*/
   DEFINE INPUT PARAMETER TABLE FOR RowObjUpd.
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-pushTableAndValidate) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pushTableAndValidate Method-Library 
PROCEDURE pushTableAndValidate :
/*------------------------------------------------------------------------------
  Purpose:     wrapper for pre and postTransactionValidate procedures when
               run from SBO.
  Parameters:  INPUT pcValType AS CHARACTER -- "Pre" or "Post",
               INPUT-OUTPUT TABLE FOR RowObjUpd.
  Notes:     - This is an override of the dynamic version in data.p and is 
               conditionally excluded if there is no RowObject TT include.     
------------------------------------------------------------------------------*/
   DEFINE INPUT        PARAMETER pcValType AS CHAR   NO-UNDO.
   DEFINE INPUT-OUTPUT PARAMETER TABLE FOR RowObjUpd.
   
   RUN bufferValidate IN TARGET-PROCEDURE (INPUT pcValType).
   RETURN RETURN-VALUE.   /* Return whatever we got from the val. proc. */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-remoteCommit) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE remoteCommit Method-Library 
PROCEDURE remoteCommit :
/*------------------------------------------------------------------------------
  Purpose:     Procedure executed on a server side SmartDataObject.   
               This is the equivalent of serverCommit, but can be run in 
               a not intialized object as it has input-ouput parameters for \
               context.  
  Parameters: 
   INPUT-OUTPUT  pcContext  - in Contextfrom client 
                              out new context
   INPUT-OUTPUT TABLE RowObjUpd - The Update version of the RowObject 
                                  Temp-Table
 
   OUTPUT cMessages - a CHR(3) delimited string of accumulated messages from
                      server.
   OUTPUT cUndoIds  - list of any RowObject ROWIDs whose changes need to be 
                       undone as the result of errors in the form of:
               "RowNumCHR(3)ADM-ERROR-STRING,RowNumCHR(3)ADM-ERROR-STRING,..."

  Notes:       If another user has modified the database records since the 
               original was read, the new database values are copied into the 
               RowObjUpd record and returned to Commit so the UI object can 
               display them.
             - This is an override of the dynamic version in data.p and is 
               conditionally excluded if there is no RowObject TT include.     
-----------------------------------------------------------------------------*/
  DEFINE INPUT-OUTPUT  PARAMETER pcContext AS CHARACTER  NO-UNDO.
  DEFINE INPUT-OUTPUT  PARAMETER TABLE FOR RowObjUpd.

  DEFINE OUTPUT PARAMETER pcMessages AS CHARACTER  NO-UNDO.
  DEFINE OUTPUT PARAMETER pcUndoIds  AS CHARACTER  NO-UNDO.
                          
  RUN setContextAndInitialize IN TARGET-PROCEDURE (pcContext).

  RUN bufferCommit IN TARGET-PROCEDURE
                 (OUTPUT pcMessages,
                  OUTPUT pcUndoIds).
                  
  pcContext = {fn obtainContextForClient}.
  
  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-serverCommit) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE serverCommit Method-Library 
PROCEDURE serverCommit :
/*------------------------------------------------------------------------------
  Purpose:     Update procedure executed on the server side of a split 
               SmartDataObject, called from the client Commit function.
               Commit passes a set of RowObjUpdate records both have changes to
               be committed and their pre-change copies (before-images).  
               commitRows verifies that the records have not been changed 
               since they were read, and then commits the changes to the 
               database.
  Parameters:
   INPUT-OUTPUT TABLE RowObjUpd - The Update version of the RowObject 
                                  Temp-Table
 
   OUTPUT cMessages - a CHR(3) delimited string of accumulated messages from
                       server.
    OUTPUT cUndoIds  - list of any RowObject ROWIDs whose changes need to be 
                       undone as the result of errors in the form of:
               "RowNumCHR(3)ADM-ERROR-STRING,RowNumCHR(3)ADM-ERROR-STRING,..."

 Notes:        If another user has modified the database records since the 
               original was read, the new database values are copied into the 
               RowObjUpd record and returned to Commit so the UI object can 
               display them.
             - This is an override of the dynamic version in data.p and is 
               conditionally excluded if there is no RowObject TT include.     
------------------------------------------------------------------------------*/
  DEFINE INPUT-OUTPUT  PARAMETER TABLE FOR RowObjUpd.
  DEFINE OUTPUT PARAMETER pcMessages AS CHARACTER  NO-UNDO.
  DEFINE OUTPUT PARAMETER pcUndoIds  AS CHARACTER  NO-UNDO.
  
  RUN bufferCommit IN TARGET-PROCEDURE (OUTPUT pcMessages,
                                        OUTPUT pcUndoIds).
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-getRowObjUpdStatic) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getRowObjUpdStatic Method-Library 
FUNCTION getRowObjUpdStatic RETURNS HANDLE
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: returns the static update buffer handle   
    Notes: Defined as private since it currently is used (in desperation) when 
           default-buffer-handle is unknown in setRowObjUpdTable.
           This problem occurs when an SBO runs locally; as 
           serverCommitTransaction( input-output table-handle) makes the 
           default-buffer-handle unknown. Maybe a side-effect of the fact that
           the buffer is static on the server? 
------------------------------------------------------------------------------*/

  RETURN BUFFER RowObjUpd:HANDLE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

