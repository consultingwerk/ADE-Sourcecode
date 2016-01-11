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
/*--------------------------------------------------------------------------
    File        : router.p
    Purpose     : Super procedure for router class.

    Syntax      : RUN start-super-proc("adm2/router.p":U).

    Modified    : 05/16/2000
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
&SCOP ADMSuper router.p

/* Custom exclude file */
{ src/adm2/custom/routerexclcustom.i }

/* This is currently defined both in b2b and router, both does inherit 
   from xml.p, but this does not belong there  */ 
DEFINE VARIABLE ghSchemaManager AS HANDLE    NO-UNDO.
DEFINE VARIABLE xcSchemaManager AS CHAR      NO-UNDO INIT "adecomm/xmlschema.p":U.
DEFINE VARIABLE xcConExtension  AS CHARACTER NO-UNDO INIT "xmc":U.
  
DEFINE TEMP-TABLE tFileReference
  FIELD TargetProc  AS HANDLE
  FIELD ExternalRef AS CHAR
  FIELD InternalRef AS CHAR
  INDEX FileRef     TargetProc ExternalRef InternalRef.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-createDocument) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD createDocument Procedure 
FUNCTION createDocument RETURNS LOGICAL
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getExternalRefList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getExternalRefList Procedure 
FUNCTION getExternalRefList RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getInternalRefList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getInternalRefList Procedure 
FUNCTION getInternalRefList RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getRouterSource) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getRouterSource Procedure 
FUNCTION getRouterSource RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getSchemaManager) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getSchemaManager Procedure 
FUNCTION getSchemaManager RETURNS HANDLE
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-internalSchemaFile) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD internalSchemaFile Procedure 
FUNCTION internalSchemaFile RETURNS CHARACTER
  (pcNameSpace AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setExternalRefList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setExternalRefList Procedure 
FUNCTION setExternalRefList RETURNS LOGICAL
  ( pcExternalRefList AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setInternalRefList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setInternalRefList Procedure 
FUNCTION setInternalRefList RETURNS LOGICAL
  ( pcInternalRefList AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setRouterSource) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setRouterSource Procedure 
FUNCTION setRouterSource RETURNS LOGICAL
  ( pcRouterSource AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-startB2BObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD startB2BObject Procedure 
FUNCTION startB2BObject RETURNS HANDLE
  ( pcContainer AS CHARACTER)  FORWARD.

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
         HEIGHT             = 10.43
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB Procedure 
/* ************************* Included-Libraries *********************** */

{src/adm2/routprop.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-initializeObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject Procedure 
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose:     SmartRouter version of initializeObject
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  RUN processFileRefs IN TARGET-PROCEDURE.

  RUN SUPER.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-obtainInMsgTarget) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE obtainInMsgTarget Procedure 
PROCEDURE obtainInMsgTarget :
/*------------------------------------------------------------------------------
  Purpose:     This procedure gets the handle of the incoming message and 
               returns the handle of the InMessage-Target from whatever
               Container it starts based on the contents of the message.
  Parameters: INPUT phMessage HANDLE 
               - A procedure handle to the object with the JMS message
                 or any object with getMessageType and a corresponding get 
                 function to retrieve the message.
              OUTPUT pohInMessageTarget HANDLE 
               - The procedure handle of the SmartB2B that got the document. 
  Notes:       
------------------------------------------------------------------------------*/
 DEFINE INPUT  PARAMETER phMessage         AS HANDLE NO-UNDO.
 DEFINE OUTPUT PARAMETER phInMessageTarget AS HANDLE NO-UNDO.

 DEFINE VARIABLE cMessageType      AS CHAR       NO-UNDO.
 DEFINE VARIABLE cMessageProcedure AS CHARACTER  NO-UNDO.
 
 ASSIGN
   cMessageType = DYNAMIC-FUNCTION('getMessageType':U IN phMessage)
   /* 9.1B only had a routeBytesMessage procedure, in 9.1C the actual 
      load is done in receiveHandler so a simpler and more generic routeMessage 
      was introduced. This dynamic check for route<MessageType> procedures 
      does now give the ability to create/override procedures for message type 
      specific routing if desired. */
   cMessageProcedure = 'route':U + cMessageType
 .   
 
 IF {fnarg Signature cMessageProcedure} <> '':U THEN
   RUN VALUE(cMessageProcedure) IN TARGET-PROCEDURE
                   (INPUT  phMessage,
                    OUTPUT phInMessageTarget) NO-ERROR.
 ELSE 
   RUN routeMessage IN TARGET-PROCEDURE
                   (INPUT  phMessage,
                    OUTPUT phInMessageTarget) NO-ERROR.

 IF ERROR-STATUS:ERROR OR RETURN-VALUE = 'adm-error':U THEN
   RETURN ERROR.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-processFileRefs) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE processFileRefs Procedure 
PROCEDURE processFileRefs :
/*------------------------------------------------------------------------------
  Purpose:     This procedure creates tFileReference temp-table records from
               ExternalRefList and InternalRefList property values.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE cExternalRefs AS CHARACTER NO-UNDO.
DEFINE VARIABLE cInternalRefs AS CHARACTER NO-UNDO.
DEFINE VARIABLE iNumRefs      AS INTEGER   NO-UNDO.

  {get ExternalRefList cExternalRefs}.
  {get InternalRefList cInternalRefs}.

  DO iNumRefs = 1 TO NUM-ENTRIES(cExternalRefs, CHR(1)):
    CREATE tFileReference.
    ASSIGN
      tFileReference.ExternalRef = ENTRY(iNumRefs, cExternalRefs, CHR(1))
      tFileReference.InternalRef = ENTRY(iNumRefs, cInternalRefs, CHR(1))
      tFileReference.TargetProc  = TARGET-PROCEDURE.
  END.  /* do iNumRefs */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-routeBytesMessage) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE routeBytesMessage Procedure 
PROCEDURE routeBytesMessage :
/*------------------------------------------------------------------------------
  Purpose:  Takes a procedure that has a BytesMessage, load the message 
            and send the document to a B2B object and return its handle.      
  Parameters: INPUT phMessage HANDLE 
               - A procedure handle to the object with the BytesMessage
                 and a corresponding getMemptr function to retrieve the message.
              OUTPUT pohInMessageTarget HANDLE 
               - The procedure handle of the SmartB2B that got the document. 
  Notes:    Mostly here for backward compatibility, but it is possible to 
            override this if this message type requires different routing. 
            See obtainInmessageTarget for details. 
------------------------------------------------------------------------------*/
 DEFINE INPUT  PARAMETER phMessage          AS HANDLE NO-UNDO.
 DEFINE OUTPUT PARAMETER pohInMessageTarget AS HANDLE NO-UNDO.

 RUN routeMessage IN TARGET-PROCEDURE (INPUT  phMessage,
                                       OUTPUT pohInMessageTarget) NO-ERROR.

 IF ERROR-STATUS:ERROR OR RETURN-VALUE = 'adm-error':U THEN
   RETURN ERROR RETURN-VALUE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-routeDocument) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE routeDocument Procedure 
PROCEDURE routeDocument :
/*-------------------------------------------------------------------------
  Purpose:     This procedure routes the documentHandle to a SmartB2BObject,
               including starting the SmartContainer with the SmartB2B 
               if required and giving it the loaded schema.                    
  Parameters:  output phInMessageTarget 
               - The SmartB2B that got the document. 
---------------------------------------------------------------------------*/
 DEFINE OUTPUT PARAMETER pohInMessageTarget AS HANDLE NO-UNDO.

 DEFINE VARIABLE hDocument   AS HANDLE NO-UNDO.
 DEFINE VARIABLE hRoot       AS HANDLE NO-UNDO.
 DEFINE VARIABLE cSchemaName AS CHAR   NO-UNDO.
 DEFINE VARIABLE cSchemaFile AS CHAR   NO-UNDO.
 DEFINE VARIABLE cContainer  AS CHAR   NO-UNDO.
 DEFINE VARIABLE hSchemaMngr AS HANDLE NO-UNDO.
 DEFINE VARIABLE hNode       AS HANDLE NO-UNDO.
 DEFINE VARIABLE hSchema     AS HANDLE NO-UNDO.
 DEFINE VARIABLE hNameSpace  AS HANDLE NO-UNDO.
 DEFINE VARIABLE hContainer  AS HANDLE NO-UNDO.
 DEFINE VARIABLE mMessageBody AS MEMPTR NO-UNDO.

 {get DocumentHandle hDocument}.
 
 CREATE X-NODEREF hRoot.

 hDocument:GET-DOCUMENT-ELEMENT(hRoot).
 cSchemaName = hRoot:GET-ATTRIBUTE('xmlns':u).
 
 IF cSchemaName <> '':U THEN
   cSchemaFile = {fnarg internalSchemaFile cSchemaName}.

     /* DTD support requires 9.1C */
    &IF {&CompileOn91C} &THEN  
 /* No xmlns or no match.. probably no use to check for dtd if xmlns, but..*/
 IF cSchemaFile = "":U THEN 
 DO:
   /* If there is a DTD public-id, check if there is an internal match */
   cSchemaName = hDocument:PUBLIC-ID.
   
   IF cSchemaName <> '':U THEN
     cSchemaFile = {fnarg internalSchemaFile cSchemaName}. 
       
   /* No public-id or no match, try system-id.*/
   IF cSchemaFile = '':U THEN
     cSchemaName = hDocument:SYSTEM-ID. 
   
   IF cSchemaName <> '':U THEN
     cSchemaFile = {fnarg internalSchemaFile cSchemaName}. 
 END.
    &ENDIF  /*CompileOn91C*/       

 IF cSchemaName = '':U THEN
 DO:
   DYNAMIC-FUNCTION ('showMessage':U IN TARGET-PROCEDURE,27).
   RETURN ERROR. 
 END.
  
 IF cSchemaFile = '':U THEN
 DO:
   DYNAMIC-FUNCTION ('showMessage':U IN TARGET-PROCEDURE, 
                     STRING(28) + ',':U + cSchemaName).
   RETURN ERROR.
 END.

 /* Is the B2B already started? */
 PUBLISH cSchemaFile FROM TARGET-PROCEDURE (OUTPUT pohInMessageTarget). 
 
 IF NOT VALID-HANDLE(pohInMessageTarget) THEN
 DO:
   {get SchemaManager hSchemaMngr}.

   RUN loadSchema IN hSchemaMngr (cSchemaFile,
                                  YES, /* delete after load */
                                  OUTPUT TABLE-HANDLE hNode,
                                  OUTPUT TABLE-HANDLE hSchema,
                                  OUTPUT TABLE-HANDLE hNameSpace).
   IF ERROR-STATUS:ERROR THEN 
     RETURN ERROR.

   {get Container cContainer hSchemaMngr}.
   pohInMessageTarget = {fnarg startB2BObject cContainer}.
   
   IF ERROR-STATUS:ERROR THEN 
     RETURN ERROR.

   /* Push the document and schema over to the B2B */
   IF VALID-HANDLE(pohInMessageTarget) THEN
   DO:
     {set SchemaHandle hSchema pohInMessageTarget}.
     
     /* Subscribe to this procedure TargetProcedure so we can find it again*/ 
     SUBSCRIBE PROCEDURE pohInMessageTarget TO cSchemaFile IN TARGET-PROCEDURE 
       RUN-PROCEDURE "TargetProcedure":U.

   END.     
 END.  /* if not valid-handle(phInMessageTarget) */
 
 IF VALID-HANDLE(pohInMessageTarget) THEN
   {set DocumentHandle hDocument pohInMessageTarget}.
 
 RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-routeMessage) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE routeMessage Procedure 
PROCEDURE routeMessage :
/*------------------------------------------------------------------------------
  Purpose:  Takes a procedure that has a message, load the message 
            and send the document to a B2B object and return its handle.      
  Parameters: INPUT phMessage HANDLE 
               - A procedure handle to the object with the JMS message
                 or any object with getMessageType and a corresponding get 
                 function to retrieve the message.
              OUTPUT pohInMessageTarget HANDLE 
               - The procedure handle of the SmartB2B that got the document. 
  Notes:    Called directly from obtainInMesages OR from specific 
            route<MessageType> procedures. 
------------------------------------------------------------------------------*/
 DEFINE INPUT PARAMETER  phMessage          AS HANDLE NO-UNDO.
 DEFINE OUTPUT PARAMETER pohInMessageTarget AS HANDLE NO-UNDO.

 RUN receiveHandler IN TARGET-PROCEDURE(INPUT  phMessage) NO-ERROR. 
 IF ERROR-STATUS:ERROR OR RETURN-VALUE = 'adm-error':U THEN
   RETURN ERROR RETURN-VALUE.

 RUN routeDocument  IN TARGET-PROCEDURE(OUTPUT pohInMessageTarget) NO-ERROR.
 IF ERROR-STATUS:ERROR OR RETURN-VALUE = 'adm-error':U THEN
   RETURN ERROR RETURN-VALUE.

 END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-createDocument) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION createDocument Procedure 
FUNCTION createDocument RETURNS LOGICAL
  (  ) :
/*------------------------------------------------------------------------------
  Purpose: create a document  
    Notes: Override of xml.p that does NOT delete the current document 
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hDoc AS HANDLE NO-UNDO.
  
  CREATE X-DOCUMENT hDoc.  
  
  {set DocumentHandle hDoc}.  
  
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getExternalRefList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getExternalRefList Procedure 
FUNCTION getExternalRefList RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose: Returns External Ref List property value 
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cExternalRefList AS CHARACTER NO-UNDO.
  {get ExternalRefList cExternalRefList} NO-ERROR.
  RETURN cExternalRefList.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getInternalRefList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getInternalRefList Procedure 
FUNCTION getInternalRefList RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose: Returns Internal Ref List property value 
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cInternalRefList AS CHARACTER NO-UNDO.
  {get InternalRefList cInternalRefList} NO-ERROR.
  RETURN cInternalRefList.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getRouterSource) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getRouterSource Procedure 
FUNCTION getRouterSource RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose: Returns Router Source property value 
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cRouterSource AS CHARACTER NO-UNDO.
  {get RouterSource cRouterSource} NO-ERROR.
  RETURN cRouterSource.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getSchemaManager) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getSchemaManager Procedure 
FUNCTION getSchemaManager RETURNS HANDLE
  ( ) :
/*------------------------------------------------------------------------------
  Purpose: Return (and start if not started) the procedure handle of the 
           schema manager.
    Notes: This is a Class Property shared by all instances. 
           There's currently duplicate code in b2b.p   
------------------------------------------------------------------------------*/
 IF NOT VALID-HANDLE(ghSchemaManager) THEN
   RUN VALUE(xcSchemaManager) PERSISTENT SET ghSchemaManager.  
  
 RETURN ghSchemaManager. 

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-internalSchemaFile) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION internalSchemaFile Procedure 
FUNCTION internalSchemaFile RETURNS CHARACTER
  (pcNameSpace AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose: Return the internal Schema file name based on the external and 
           internal fiel reference definitions.
parameter: pcNameSpace. Target Name Space, the xmlns attribute from the 
                        incoming XML document.   
                        or the document type if DTDs are used.                          
    Notes:  
------------------------------------------------------------------------------*/
DEFINE VARIABLE iLength    AS INT     NO-UNDO.
DEFINE VARIABLE cFileName  AS CHAR    NO-UNDO.
DEFINE VARIABLE cExtension AS CHAR    NO-UNDO.
DEFINE VARIABLE iExt       AS INT     NO-UNDO.
 
 ASSIGN
   iExt       = NUM-ENTRIES(pcNameSpace,".":U).
 
 IF iExt > 1 THEN
   ASSIGN
     cExtension = ENTRY(iExt,pcNameSpace,".":U).

 /* Look at all external refs that matches the beginning of the 
    TargetNameSpace (This comparison cannot use index!) */
 FOR EACH tFileReference WHERE tFileReference.TargetProc =  TARGET-PROCEDURE 
                         AND   pcNameSpace BEGINS tFileReference.ExternalRef:
   /* The one with the most matching characters will be used */
   IF LENGTH(tFileReference.ExternalRef) > iLength THEN
   DO:
     ASSIGN 
       cFileName = REPLACE(" ":U + pcNameSpace,
                           " ":U + tFileReference.ExternalRef,
                          tFileReference.InternalRef) 

       iLength   = LENGTH(tFileReference.ExternalRef).
     
     /* Unless the InternalRef specifies a complete filename with extension, 
        we need to make sure that the Mapping file extension is added.  */
     IF INDEX(tFileReference.InternalRef,".":U) = 0 THEN
     DO:
       /* The TargetNameSpace's .xml extension will still remain and need to 
          be replaced (Just in case let's also look for .dtd and .xsd) */
       IF CAN-DO('xml,dtd,xsd':U,cExtension) 
       AND NUM-ENTRIES(cFileName,".":U) > 1 THEN 
         ENTRY(NUM-ENTRIES(cFileName,".":U),cFileName,".":U) = xcConExtension.
       ELSE /* if no known extension we add the mapping file extension */
         cFileName = cFileName + ".":U + xcConExtension.
   
     END. /* If no extension in Internlref */  
   END. /* if length(Externalref)  > length */ 
 END. /* for each tFileReference */
 
 RETURN cFileName. 
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setExternalRefList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setExternalRefList Procedure 
FUNCTION setExternalRefList RETURNS LOGICAL
  ( pcExternalRefList AS CHARACTER ) :
/*------------------------------------------------------------------------------
     Purpose: Sets the External References this router uses to determine
              how external target namespaces map to internal XML mapping
              schemas
  Parameters: pcExternalRefList AS CHARACTER
       Notes:  
------------------------------------------------------------------------------*/

  {set ExternalRefList pcExternalRefList}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setInternalRefList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setInternalRefList Procedure 
FUNCTION setInternalRefList RETURNS LOGICAL
  ( pcInternalRefList AS CHARACTER ) :
/*------------------------------------------------------------------------------
     Purpose: Sets the Internal References this router uses to determine
              how external target namespaces map to internal XML mapping
              schemas
  Parameters: pcInternalRef AS CHARACTER
       Notes:  
------------------------------------------------------------------------------*/

  {set InternalRefList pcInternalRefList}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setRouterSource) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setRouterSource Procedure 
FUNCTION setRouterSource RETURNS LOGICAL
  ( pcRouterSource AS CHARACTER ) :
/*------------------------------------------------------------------------------
     Purpose: Sets the Router Source property value, this contains a list
              of handles for router-source objects
  Parameters: pcRouterSource AS CHARACTER
       Notes:  
------------------------------------------------------------------------------*/

  {set RouterSource pcRouterSource}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-startB2BObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION startB2BObject Procedure 
FUNCTION startB2BObject RETURNS HANDLE
  ( pcContainer AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose: Start the Container with the B2b object link it to the consumer
           and return it's handle. 
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hContainer     AS HANDLE NO-UNDO.
  DEFINE VARIABLE hWidget        AS HANDLE NO-UNDO.
  DEFINE VARIABLE hB2BContainer  AS HANDLE NO-UNDO.
  DEFINE VARIABLE cTargets       AS CHAR   NO-UNDO.
  DEFINE VARIABLE hTarget        AS HANDLE NO-UNDO.
  DEFINE VARIABLE i              AS INT    NO-UNDO.
  DEFINE VARIABLE cObjectType    AS CHAR   NO-UNDO.
  DEFINE VARIABLE cContainerType AS CHARACTER  NO-UNDO.
  
  /* Start the object from the Router's container so the B2B Contaoner will 
     be destroyed from it */

   {get ContainerSource hContainer}.
   {get ContainerHandle hWidget}.
   
   DO ON STOP UNDO, RETURN ERROR:
     RUN constructObject IN hContainer 
                (INPUT  pcContainer,
                 INPUT  hWidget,
                 INPUT  '':U,
                 OUTPUT hB2BContainer).
   
   END.

   {get ContainerTarget cTargets hB2BContainer}.

   FindB2B:
   DO i  = 1 TO NUM-ENTRIES(cTargets):
     hTarget = WIDGET-HANDLE(ENTRY(i,ctargets)).
     
     {get ObjectType cObjectType hTarget}.
     
     IF cObjectType = 'SmartB2BObject':U THEN
       LEAVE FindB2B.
     
     hTarget = ?.
   END.
      
   {get ContainerType cContainerType hB2BContainer}.
   IF cContainerType <> "VIRTUAL":U THEN  
       RUN initializeObject IN hB2Bcontainer.
   
   {set LoadedByRouter TRUE hTarget}.
   RETURN hTarget.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

