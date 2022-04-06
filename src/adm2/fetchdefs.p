&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*********************************************************************
* Copyright (C) 2005 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*-----------------------------------------------------------------------------
  File: fetchdefs.p 

 Description: Stateless retrieval of data definitions from a SmartDataObject  
 Purpose:     Allow a client to retrieve data definition from the server 
              with ONE appserver call.
 Parameters: 
   input        pcObject    - physical object name of an sdo       
                              Will be extended to support logical icf SDOs 
   input-output piocContext - Context from client to server 
                              Will return new context to client.                               
                              In this case that would be only be first time                              
                              properties.
   output table phRowObject - RowObject table  
   output       pocMessages - error messages in adm format
                       
 Notes:     Standard ADM needs this for a completely dynamic data object when 
            for example openOnInit is false. 
            Dynamics need this in all cases when OpenOnInit is false.    
            It will also be used in design time 
------------------------------------------------------------------------------*/
 
/* ***************************  Definitions  ************************** */
&scop object-name       fetchdefs.p
&scop object-version    000000
 
 DEFINE INPUT PARAMETER pcObject AS CHARACTER  NO-UNDO.
 
 DEFINE INPUT-OUTPUT PARAMETER piocContext  AS CHARACTER  NO-UNDO.
 
 DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject.
 DEFINE OUTPUT PARAMETER pocMessages AS CHARACTER  NO-UNDO.

 /* returned by getCurrentLogicalname */                                                    
 DEFINE VARIABLE gcLogicalName AS CHARACTER  NO-UNDO.

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
  (  )  FORWARD.

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
         HEIGHT             = 14.33
         WIDTH              = 80.4.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

DEFINE VARIABLE hObject       AS HANDLE     NO-UNDO.
DEFINE VARIABLE hRowObject    AS HANDLE     NO-UNDO.
DEFINE VARIABLE lDynamic      AS LOGICAL    NO-UNDO. 
DEFINE VARIABLE cEntityFields AS CHARACTER  NO-UNDO.

IF NUM-ENTRIES(pcObject,':') > 1 THEN
  ASSIGN
    gcLogicalName = ENTRY(2,pcObject,':':U)
    pcObject     = ENTRY(1,pcObject,':':U).

DO ON STOP UNDO, LEAVE:   
  RUN VALUE(pcObject) PERSISTENT SET hObject NO-ERROR.   
END.

IF NOT VALID-HANDLE(hObject) THEN
DO:
  pocMessages = ERROR-STATUS:GET-MESSAGE(1).
  RETURN.
END.

RUN setPropertyList IN hObject (piocContext).

{get DynamicData lDynamic hObject}.
{get EntityFields cEntityFields hObject}.

IF lDynamic THEN 
DO:
  CREATE TEMP-TABLE phRowObject.
  {set RowObjectTable phRowObject hObject}.
  RUN createObjects IN hObject.
END.
ELSE DO:
  RUN fetchRowObjectTable IN hObject( OUTPUT TABLE-HANDLE phRowObject ).
END.

IF cEntityFields = ? THEN
  RUN initializeEntityDetails IN hObject.

IF {fn anyMessage hObject} THEN
    pocMessages = {fn fetchMessages hObject}.

RUN getContextAndDestroy IN hObject (OUTPUT piocContext).

IF lDynamic AND VALID-HANDLE(phRowObject) THEN
  DELETE OBJECT phRowObject.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-getCurrentLogicalName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getCurrentLogicalName Procedure 
FUNCTION getCurrentLogicalName RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose: Call back for prepareInstance 
    Notes:  
------------------------------------------------------------------------------*/
  RETURN gcLogicalName. 
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

