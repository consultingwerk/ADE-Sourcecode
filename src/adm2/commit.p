&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*********************************************************************
* Copyright (C) 2005 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*---------------------------------------------------------------------------------
  File: commit.p 

 Description: Stateless commit of data to any SmartDataObject  
 Purpose:     Allow a client to commit data to the server with 
               ONE appserver call  

 Parameters: 
   input        pcObject    - physical object name of an sdo       
                              Will be extended to support logical icf SDOs 
   input-output piocContext - Context from client to server 
                                Will return new context to client   
   input-output table phRowObjUpd - RowObjUpd table with changes
   output       pocMessages  - error messages in adm format
   output       pocUndoids   - list of failed rowobjupd ROwnums 
                       
 Notes:  The only difference from the remoteCommit method in data.p is the 
         objectname     
 
 History:
---------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

DEFINE INPUT PARAMETER pcObject            AS CHARACTER  NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER piocContext  AS CHARACTER  NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER TABLE-HANDLE phRowObjUpd. 

DEFINE OUTPUT PARAMETER pocMessages AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER pocUndoIds  AS CHARACTER NO-UNDO.

DEFINE VARIABLE gcCurrentLogicalName AS CHAR NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-getCurrentLogicalName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getCurrentLogicalName Procedure 
FUNCTION getCurrentLogicalName RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

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
         HEIGHT             = 6.14
         WIDTH              = 47.6.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
DEFINE VARIABLE hObject       AS HANDLE   NO-UNDO.
DEFINE VARIABLE hRowObjUpd    AS HANDLE   NO-UNDO.
DEFINE VARIABLE lDynamicData  AS LOGICAL  NO-UNDO.
DEFINE VARIABLE iEntry        AS INTEGER    NO-UNDO.
DEFINE VARIABLE cLogicalName  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cLocalContext AS CHARACTER  NO-UNDO.

cLocalContext = REPLACE(piocContext, CHR(3), CHR(4)).

IF NUM-ENTRIES(pcObject,':') > 1 THEN
  ASSIGN
    cLogicalName = ENTRY(2,pcObject,':':U)
    pcObject     = ENTRY(1,pcObject,':':U).

IF cLogicalName > '':U THEN
DO:                                     /* look for running object */
  gcCurrentLogicalName = cLogicalName.
  PUBLISH "searchCache" + cLogicalName (OUTPUT hObject).
  /* if found, use it */
  IF VALID-HANDLE(hObject) THEN
    RUN removeFromCache IN hObject.
END.

IF NOT VALID-HANDLE(hObject) THEN       /* start a new instance */
DO ON STOP UNDO, LEAVE:   
  RUN VALUE(pcObject) PERSISTENT SET hObject NO-ERROR.   
END.

IF NOT VALID-HANDLE(hObject) THEN
DO:
  pocMessages = ERROR-STATUS:GET-MESSAGE(1).
  RETURN.
END.

{get DynamicData lDynamicData hObject}.
{set ASDivision 'SERVER':U hObject}.

IF lDynamicData THEN
DO:
  {set RowObjUpdTable phRowObjUpd hObject}. 
  RUN setContextAndInitialize IN hObject (piocContext).
  RUN bufferCommit IN hObject (OUTPUT pocMessages, 
                               OUTPUT pocUndoIds).
  RUN getContextAndDestroy IN hObject (OUTPUT piocContext).
END.
ELSE DO:
  RUN remoteCommit IN hObject ( INPUT-OUTPUT piocContext,
                                INPUT-OUTPUT TABLE-HANDLE phRowObjUpd,
                                OUTPUT pocMessages, 
                                OUTPUT pocUndoIds).
  RUN destroyObject IN hObject. 
END.

DELETE OBJECT phRowObjUpd NO-ERROR.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-getCurrentLogicalName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getCurrentLogicalName Procedure 
FUNCTION getCurrentLogicalName RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  RETURN gcCurrentLogicalName. 

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

