&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Check Version Notes Wizard" Procedure _INLINE
/* Actions: af/cod/aftemwizcw.w ? ? ? ? */
/* MIP Update Version Notes Wizard
Check object version notes.
af/cod/aftemwizpw.w
*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Update-Object-Version" Procedure _INLINE
/* Actions: ? ? ? ? af/sup/afverxftrp.p */
/* This has to go above the definitions sections, as that is what it modifies.
   If its not, then the definitions section will have been saved before the
   XFTR code kicks in and changes it */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Definition Comments Wizard" Procedure _INLINE
/* Actions: ? af/cod/aftemwizcw.w ? ? ? */
/* Program Definition Comment Block Wizard
Welcome to the Program Definition Comment Block Wizard. Press Next to proceed.
af/cod/aftemwizpw.w
*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*---------------------------------------------------------------------------------
  File: ryvoblib.p

  Description:  Visual Object Builder procedure library

  Purpose:      Procedure library for Visual Object Builder. Contains all functions and
                procedures

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   28/02/2002  Author:     

  Update Notes: Created from Template rytemprocp.p
                Created from Template ryvoblib.p

---------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       ryvobplipp.p
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000


/* object identifying preprocessor */
&glob   AstraProcedure    yes

{src/adm2/globals.i}

/* Temp Table Handle variables */
{ry/inc/ryvobttdef.i}

 /* Defines the NO-RESULT-CODE and DEFAULT-RESULT-CODE result codes. */
{ ry/app/rydefrescd.i }


/* Property Sheet Handle */
DEFINE VARIABLE ghPropSheet AS HANDLE     NO-UNDO.

/* Unique object ID for main key in temp tables ttObject and ttAttribute */
DEFINE VARIABLE giObjectID AS INTEGER    NO-UNDO.

/* Used for assigning a list of attributes per calling handle */
DEFINE VARIABLE gcAttributeFirst AS CHARACTER  NO-UNDO.


/* used to store the last displayed object */
DEFINE VARIABLE ghLastCallingProc   AS HANDLE     NO-UNDO.
DEFINE VARIABLE gcLastContainerName AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcLastObjectName    AS CHARACTER  NO-UNDO.

/* Design manager handle */
DEFINE VARIABLE ghRepositoryDesignManager AS HANDLE     NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-extractProperty) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD extractProperty Procedure 
FUNCTION extractProperty RETURNS CHARACTER
  ( pcPropertyList AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getAttributeFirst) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getAttributeFirst Procedure 
FUNCTION getAttributeFirst RETURNS CHARACTER
  ( phProc AS HANDLE )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getBuffer) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getBuffer Procedure 
FUNCTION getBuffer RETURNS HANDLE
  ( pcTable AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getClassList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getClassList Procedure 
FUNCTION getClassList RETURNS CHARACTER
( INPUT  phCallingProc AS HANDLE,
  INPUT  pcContainerName AS CHAR, 
  INPUT  pcObject        AS CHAR,
  OUTPUT pcClassList AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getGroupList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getGroupList Procedure 
FUNCTION getGroupList RETURNS CHARACTER
  ( phCallingProc    AS HANDLE,
    pcContainerName  AS CHAR,
    pcObjectNameList AS CHAR) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getNextID) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getNextID Procedure 
FUNCTION getNextID RETURNS INTEGER
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getObjectList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getObjectList Procedure 
FUNCTION getObjectList RETURNS CHARACTER
  ( phCallingProc AS HANDLE,
    pcContainerName AS CHAR,
    OUTPUT pcObjectLabels AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getPropSheet) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getPropSheet Procedure 
FUNCTION getPropSheet RETURNS HANDLE
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getRepostionQuery) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getRepostionQuery Procedure 
FUNCTION getRepostionQuery RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getResultCodeList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getResultCodeList Procedure 
FUNCTION getResultCodeList RETURNS CHARACTER
  ( INPUT  phCallingProc AS HANDLE,
    INPUT  pcContainerName AS CHAR, 
    INPUT  pcObject        AS CHAR) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setAttributeFirst) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setAttributeFirst Procedure 
FUNCTION setAttributeFirst RETURNS LOGICAL
  ( phProc      AS HANDLE,
    pcAttribute AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setPropSheet) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setPropSheet Procedure 
FUNCTION setPropSheet RETURNS LOGICAL
  ( phPropertySheet AS HANDLE)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setRepositionQuery) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setRepositionQuery Procedure 
FUNCTION setRepositionQuery RETURNS LOGICAL
  ( plRepositionQuery AS LOG )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setResultCodeList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setResultCodeList Procedure 
FUNCTION setResultCodeList RETURNS LOGICAL
 (  INPUT  phCallingProc AS HANDLE,
    INPUT  pcContainerName AS CHAR, 
    INPUT  pcObject        AS CHAR,
    INPUT  pcResultCode    AS CHAR  )  FORWARD.

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
         HEIGHT             = 31.33
         WIDTH              = 56.4.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-addResultCode) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE addResultCode Procedure 
PROCEDURE addResultCode :
/*------------------------------------------------------------------------------
  Purpose:    Adds a result code for all objects of a specified container 
  Parameters: phCallingProc     Handle of calling procedure
              pcContainerName   Name of container or master object (Required)
              pcResultCode      Result Code to be added to this object
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER phCallingProc     AS HANDLE     NO-UNDO.
DEFINE INPUT  PARAMETER pcContainerName   AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER pcResultCode      AS CHARACTER  NO-UNDO.


DEFINE BUFFER BUFttAttribute FOR  ttAttribute.
DEFINE BUFFER BUFttEvent     FOR  ttEvent.

ASSIGN pcResultCode = TRIM(pcResultCode)
       pcResultCode = IF pcResultCode = "{&DEFAULT-RESULT-CODE}":U
                      OR pcResultCode = "{&NO-RESULT-CODE}":U
                      THEN ""
                      ELSE pcResultCode. 

IF NOT CAN-FIND(FIRST ttAttribute 
                WHERE ttAttribute.callingProc   = phCallingProc
                  AND ttAttribute.containerName = pcContainerName
                  AND ttATtribute.resultcode     = pcResultCode) THEN
FOR EACH ttObject WHERE ttObject.callingProc   = phCallingProc 
                    AND ttObject.containerName = pcContainerName :   
   /* Copy attributes of the objects' default for this new resultcode*/
   FOR EACH ttAttribute WHERE ttAttribute.ObjectID    = ttObject.objectID
                          AND ttAttribute.resultCode  = "":
       CREATE BUFttAttribute.
       BUFFER-COPY ttAttribute TO  BUFttAttribute
            ASSIGN BUFttAttribute.resultCode    = pcResultCode
                   BUFttAttribute.defaultValue =  ttAttribute.setValue
                   NO-ERROR.

   END.
   IF LOOKUP(pcResultCode,ttObject.ResultCodes) = 0  THEN
      ASSIGN ttObject.resultCodes = ttObject.ResultCodes + (IF ttObject.resultCodes = "" THEN "" ELSE ",")
                                                         + pcResultCode.
                                 
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-assignDefaultProperty) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE assignDefaultProperty Procedure 
PROCEDURE assignDefaultProperty :
/*------------------------------------------------------------------------------
  Purpose:    Assigns attributes defaults in the temp table  
  Parameters: phCallingProc     Calling window handle
              pcContainerName   Name of container
              pcObjectName      Object name used in registerObject
              pcAttributeList   CHR(3) delimited List of Attributes defaults  
                                and their values of the Master object in the format:
                                 attribute |  result code | value
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER phCallingProc    AS HANDLE    NO-UNDO.
DEFINE INPUT PARAMETER pcContainerName  AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER pcObjectName     AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER pcAttributeList  AS CHARACTER NO-UNDO.

DEFINE VARIABLE cLabel          AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cValue          AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cResultCode     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE iLoop           AS INTEGER    NO-UNDO.
DEFINE VARIABLE cEventAction    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE iObjectID       AS INTEGER  NO-UNDO.

/* Set the attribute values  */
DO iLoop = 1 TO NUM-ENTRIES(pcAttributeList,CHR(3)) BY 3:
  ASSIGN cLabel      = ENTRY(iLoop,pcAttributeList,CHR(3))
         cResultCode = ENTRY(iLoop + 1,pcAttributeList,CHR(3))
         cResultCode = IF cResultCode = "{&DEFAULT-RESULT-CODE}":U
                          OR cResultCode = "{&NO-RESULT-CODE}":U
                       THEN ""
                       ELSE cResultCode 
         cValue      = ENTRY(iLoop + 2,pcAttributeList,CHR(3))
         NO-ERROR.
  
  FIND ttAttribute WHERE ttAttribute.callingProc   = phCallingProc
                     AND ttAttribute.containerName = pcContainerName
                     AND ttAttribute.resultCode    = cResultCode
                     AND ttAttribute.ObjectName    = pcObjectName
                     AND ttAttribute.attrLabel     = cLabel 
                     NO-ERROR.
  IF AVAILABLE(ttAttribute) THEN
  DO:
     ASSIGN ttAttribute.defaultValue    = cValue
            ttAttribute.setValue        = IF ttAttribute.RowModified OR ttAttribute.RowOverride
                                          THEN ttAttribute.setValue
                                          ELSE cValue
                       iObjectID        = ttAttribute.ObjectID.
             
    /* If the value being set is for the master or default result code, assign the
   default value for the non-default result codes equal to this value */
     IF cResultCode = "" THEN
     FOR EACH ttAttribute WHERE ttAttribute.ObjectID    = iobjectID
                           AND ttAttribute.resultCode  > ""
                           AND ttAttribute.attrLabel   = cLabel:

        ASSIGN ttAttribute.defaultValue = cValue
               ttAttribute.setValue        = IF ttAttribute.RowModified 
                                             THEN ttAttribute.setValue
                                             ELSE cValue.
    END. /* END For Each ttAttribute */
  END.   /* END IF AVAILABLE */
END. /* END DO iLoop */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-assignMultiplePropValues) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE assignMultiplePropValues Procedure 
PROCEDURE assignMultiplePropValues :
/*------------------------------------------------------------------------------
  Purpose:    Assigns attributes and events in the temp table  
  Parameters: phCallingProc     Calling window handle
              pcContainerName   Name of container
              pcObjectNames     CHR(4) delimited list of object names used in registerObject
              pcAttributeList   CHR(4) and CHR(3) delimited List of Attributes defaults  
                                and their values of the Master object in the format:
                                attribute | result code | value CHR(4) attribute | ...
             pcEventList        CHR(4) CHR(3) delimited List of Label, ResultCode, EventAction   
                                EventType. EventTarget, EventParam. EventDisabled
            plModified          YES Sets the attribute/event as modified (displays asterisk)
                                NO  Doesn't set attribute/event as modified
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER phCallingProc    AS HANDLE    NO-UNDO.
DEFINE INPUT PARAMETER pcContainerName  AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER pcObjectNames    AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER pcAttributeList  AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER pcEventList      AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER plModified       AS LOGICAL   NO-UNDO.

DEFINE VARIABLE cLabel          AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cValue          AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cResultCode     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE iLoop           AS INTEGER    NO-UNDO.
DEFINE VARIABLE iLoopObject     AS INTEGER    NO-UNDO.
DEFINE VARIABLE cEventAction    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cEventType      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cEventTarget    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cEventParam     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cEventDisabled  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE lEventDisabled  AS LOGICAL    NO-UNDO.
DEFINE VARIABLE iObjectID       AS INTEGER    NO-UNDO.
DEFINE VARIABLE lRefresh        AS LOGICAL    NO-UNDO.
DEFINE VARIABLE cObjectName     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cAttributes     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cEvents         AS CHARACTER  NO-UNDO.

/* Set the attribute values  */
DO iLoopObject = 1 TO NUM-ENTRIES(pcObjectNames,CHR(4)):
  ASSIGN cObjectName = ENTRY(iLoopObject,pcObjectNames,CHR(4))
         cAttributes = ENTRY(iLoopObject,pcAttributeList,CHR(4)).
  DO iLoop = 1 TO NUM-ENTRIES(cAttributes,CHR(3)) BY 3:
    ASSIGN cLabel      = ENTRY(iLoop,cAttributes,CHR(3))
           cResultCode = ENTRY(iLoop + 1,cAttributes,CHR(3))
           cResultCode = IF cResultCode = "{&DEFAULT-RESULT-CODE}":U
                            OR cResultCode = "{&NO-RESULT-CODE}":U
                         THEN ""
                         ELSE cResultCode
           cValue      = ENTRY(iLoop + 2,cAttributes,CHR(3))
           NO-ERROR.
    
    FIND ttAttribute WHERE ttAttribute.callingProc   = phCallingProc
                       AND ttAttribute.containerName = pcContainerName
                       AND ttAttribute.resultCode    = cResultCode
                       AND ttAttribute.ObjectName    = cObjectName
                       AND ttAttribute.attrLabel     = cLabel 
                       NO-ERROR.
    IF AVAILABLE(ttAttribute) THEN 
    DO:
       ASSIGN ttAttribute.setValue    = cValue
              ttAttribute.RowOverride = plModified
              iObjectID               = ttAttribute.ObjectID.

      /* If the object being assigned is the current displayed object,
         refresh the browse contents */
       IF phCallingProc = ghLastCallingProc   
          AND  pcContainerName = gcLastContainerName 
          AND  cObjectName     = gcLastObjectName THEN
       DO:
          FIND FIRST ttSelectedAttribute 
               WHERE ttSelectedAttribute.resultCode = cResultCode 
                 AND ttSelectedAttribute.attrLabel  = cLabel NO-ERROR.
          IF AVAIL ttSelectedAttribute THEN
             ASSIGN ttSelectedAttribute.setValue  = cValue
                    ttSelectedAttribute.Override  = " *":U
                    lRefresh                      = TRUE.
       END.


      /* If the value being set is for the master or default result code, assign the
     default value for the non-default result codes equal to this value */
       IF cResultCode = "" THEN
       FOR EACH ttAttribute WHERE ttAttribute.ObjectID    = iobjectID
                              AND ttAttribute.resultCode  > ""
                              AND ttAttribute.attrLabel   = cLabel:

          ASSIGN ttAttribute.defaultValue = cValue
                 ttAttribute.setValue     = IF ttAttribute.RowOverride <> TRUE 
                                            THEN cValue ELSE ttAttribute.setValue .
       END. /* End For each */

    END.    /* END if Avail */
  END.      /* END DO iLoop */
END.

/* Set the event values  */
DO iLoopObject = 1 TO NUM-ENTRIES(pcObjectNames,CHR(4)):
   ASSIGN cObjectName = ENTRY(iLoopObject,pcObjectNames,CHR(4))
          cEvents = ENTRY(iLoopObject,pcEventList,CHR(4)).
   DO iLoop = 1 TO NUM-ENTRIES(cEvents,CHR(3)) BY 7:
     ASSIGN cLabel         = ENTRY(iLoop,cEvents,CHR(3))
            cResultCode    = ENTRY(iLoop + 1,cEvents,CHR(3))
            cResultCode    = IF cResultCode = "{&DEFAULT-RESULT-CODE}":U
                             OR cResultCode = "{&NO-RESULT-CODE}":U
                             THEN ""
                             ELSE cResultCode
            cEventAction   = ENTRY(iLoop + 2,cEvents,CHR(3))
            cEventType     = ENTRY(iLoop + 3,cEvents,CHR(3))
            cEventTarget   = ENTRY(iLoop + 4,cEvents,CHR(3))
            cEventParam    = ENTRY(iLoop + 5,cEvents,CHR(3))
            cEventDisabled = ENTRY(iLoop + 6,cEvents,CHR(3))
            lEventDisabled = IF cEventDisabled = "yes" OR cEventDisabled = "true"
                             THEN TRUE
                             ELSE FALSE
            NO-ERROR.

     FIND ttEvent WHERE ttEvent.callingProc   = phCallingProc
                    AND ttEvent.containerName = pcContainerName
                    AND ttEvent.resultCode    = cResultCode
                    AND ttEvent.ObjectName    = cObjectName
                    AND ttEvent.eventName     = cLabel NO-ERROR.

     IF AVAILABLE(ttEvent) THEN 
     DO:
        ASSIGN ttEvent.eventAction     = cEventAction
               ttEvent.eventType       = cEventType
               ttEvent.eventTarget     = cEventTarget
               ttEvent.eventParameter  = ceventParam
               ttEvent.eventDisabled   = lEventDisabled
               ttEvent.RowOverride     = plModified
               iObjectID               = ttEvent.ObjectID
               NO-ERROR.

        /* If the object being assigned is the current displayed object,
          refresh the event browse contents */
        IF phCallingProc       = ghLastCallingProc   
           AND pcContainerName = gcLastContainerName 
           AND cObjectName     = gcLastObjectName THEN
        DO:
           FIND FIRST ttSelectedEvent 
                WHERE ttSelectedEvent.resultCode = cResultCode 
                  AND ttSelectedEvent.eventName  = cLabel NO-ERROR.
           IF AVAIL ttSelectedEvent THEN
              ASSIGN ttSelectedEvent.EventAction   = cEventAction
                     ttSelectedEvent.Override       = " *":U
                     ttSelectedEvent.eventType      = cEventType
                     ttSelectedEvent.eventTarget    = cEventTarget
                     ttSelectedEvent.eventParameter = ceventParam
                     ttSelectedEvent.eventDisabled  = lEventDisabled
                     lRefresh                       = TRUE.
        END.


     /* If the value being set is for the master or default result code, assign the
      default value for the non-default result codes equal to this value */
        IF cResultCode = "" THEN
        FOR EACH ttEvent WHERE ttEvent.ObjectID    = iobjectID
                           AND ttEvent.resultCode  > ""
                           AND ttEvent.eventName   = cLabel:

           ASSIGN ttEvent.defaultAction    = cEventAction
                  ttEvent.defaultType      = cEventType
                  ttEvent.defaultTarget    = cEventTarget
                  ttEvent.defaultParameter = cEventParam
                  ttEvent.defaultDisabled  = lEventDisabled
                  ttEvent.eventAction    = IF ttEvent.RowOverride <> TRUE THEN cEventAction ELSE ttEvent.eventAction
                  ttEvent.eventType      = IF ttEvent.RowOverride <> TRUE THEN cEventType   ELSE ttEvent.eventType
                  ttEvent.eventTarget    = IF ttEvent.RowOverride <> TRUE THEN cEventTarget ELSE ttEvent.eventAction
                  ttEvent.eventParameter = IF ttEvent.RowOverride <> TRUE THEN cEventParam  ELSE ttEvent.eventParameter
                  ttEvent.eventDisabled  = IF ttEvent.RowOverride <> TRUE THEN lEventDisabled ELSE ttEvent.eventDisabled
                  NO-ERROR.
        END.
     END.
   END.
  
END.

IF lRefresh AND VALID-HANDLE(ghPropSheet) THEN
 RUN refreshBrowse IN ghpropsheet.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-assignPropertySensitive) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE assignPropertySensitive Procedure 
PROCEDURE assignPropertySensitive :
/*------------------------------------------------------------------------------
  Purpose:    Sets specified attributes or events as being sensitive or
              insensitive
  Parameters: phCallingProc     Calling window handle
              pcContainerName   Name of container
              pcObjectName      Object name used in registerObject
              pcAttributeList   CHR(3) delimited List of Attributes
              pcEventList       CHR(3) delimited List of Events
              plDisabled        YES  Attribute/Event is disabled
                                NO   Attribute/Event is enabled
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER phCallingProc    AS HANDLE    NO-UNDO.
DEFINE INPUT PARAMETER pcContainerName  AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER pcObjectName     AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER pcResultCode     AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER pcAttributeList  AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER pcEventList      AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER plDisabled       AS LOGICAL   NO-UNDO.

DEFINE VARIABLE iLoop  AS INTEGER    NO-UNDO.
DEFINE VARIABLE cLabel AS CHARACTER  NO-UNDO.

DO iLoop = 1 TO NUM-ENTRIES(pcAttributeList,CHR(3)):
  ASSIGN cLabel      = ENTRY(iLoop,pcAttributeList,CHR(3)) NO-ERROR.

  IF pcObjectName = "*"  THEN
  DO:
    IF pcResultCode = "*":U THEN
    DO:
      FOR EACH ttAttribute WHERE ttAttribute.callingProc   = phCallingProc
                             AND ttAttribute.containerName = pcContainerName
                             AND ttAttribute.attrLabel     = cLabel :

        IF AVAILABLE(ttAttribute) THEN
            ASSIGN ttAttribute.isDisabled    = plDisabled.

      END.

    END.
    ELSE 
    DO:
      FOR EACH ttAttribute WHERE ttAttribute.callingProc   = phCallingProc
                             AND ttAttribute.containerName = pcContainerName
                             AND ttAttribute.resultCode    = pcResultCode
                             AND ttAttribute.attrLabel     = cLabel :
                         

        IF AVAILABLE(ttAttribute) THEN
           ASSIGN ttAttribute.isDisabled    = plDisabled.
      END.
    END.
  END. /* End pcObjectName = "*" */
  ELSE 
  DO:
    IF pcResultCode = "*":U THEN
    DO:
      FOR EACH ttAttribute WHERE ttAttribute.callingProc   = phCallingProc
                             AND ttAttribute.containerName = pcContainerName
                             AND ttAttribute.ObjectName    = pcObjectName
                             AND ttAttribute.attrLabel   = cLabel :

        IF AVAILABLE(ttAttribute) THEN
            ASSIGN ttAttribute.isDisabled    = plDisabled.
      END.

    END.
    ELSE 
    DO:
      FIND ttAttribute WHERE ttAttribute.callingProc   = phCallingProc
                         AND ttAttribute.containerName = pcContainerName
                         AND ttAttribute.resultCode    = pcResultCode
                         AND ttAttribute.ObjectName    = pcObjectName
                         AND ttAttribute.attrLabel     = cLabel 
                         NO-ERROR.

      IF AVAILABLE(ttAttribute) THEN
         ASSIGN ttAttribute.isDisabled    = plDisabled.
    END.

  END.

END.


/* Set the event values  */
DO iLoop = 1 TO NUM-ENTRIES(pcEventList,CHR(3)):
  ASSIGN cLabel         = ENTRY(iLoop,pcEventList,CHR(3))
         NO-ERROR.

  IF pcObjectName = "*"  THEN
  DO:
     IF pcResultCode = "*":U THEN
     DO:
       FOR EACH ttEvent WHERE ttEvent.callingProc   = phCallingProc
                          AND ttEvent.containerName = pcContainerName
                          AND ttEvent.eventName     = cLabel :

         IF AVAILABLE(ttEvent) THEN
             ASSIGN ttEvent.isDisabled     = plDisabled.
       END.
     END.
     ELSE 
     DO:
       FOR EACH ttEvent WHERE ttEvent.callingProc   = phCallingProc
                          AND ttEvent.containerName = pcContainerName
                          AND ttEvent.resultCode    = pcResultCode
                          AND ttEvent.eventName     = cLabel :

         IF AVAILABLE(ttEvent) THEN
            ASSIGN ttEvent.isDisabled     = plDisabled.
       END.
     END.
  END.
  ELSE
  DO:
    IF pcResultCode = "*":U THEN
    DO:
      FOR EACH ttEvent WHERE ttEvent.callingProc   = phCallingProc
                         AND ttEvent.containerName = pcContainerName
                         AND ttEvent.ObjectName    = pcObjectName
                         AND ttEvent.eventName     = cLabel :

        IF AVAILABLE(ttEvent) THEN
            ASSIGN ttEvent.isDisabled     = plDisabled.
      END.
    END.
    ELSE 
    DO:
      FIND ttEvent WHERE ttEvent.callingProc   = phCallingProc
                     AND ttEvent.containerName = pcContainerName
                     AND ttEvent.resultCode    = pcResultCode
                     AND ttEvent.ObjectName    = pcObjectName
                     AND ttEvent.eventName     = cLabel NO-ERROR.

      IF AVAILABLE(ttEvent) THEN
           ASSIGN ttEvent.isDisabled     = plDisabled.
    END.
  END.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-assignPropertyValues) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE assignPropertyValues Procedure 
PROCEDURE assignPropertyValues :
/*------------------------------------------------------------------------------
  Purpose:    Assigns attributes and events in the temp table  
  Parameters: phCallingProc     Calling window handle
              pcContainerName   Name of container
              pcObjectName      Object name used in registerObject
              pcAttributeList   CHR(3) delimited List of Attributes defaults  
                                and their values of the Master object in the format:
                                attribute |  result code | value
             pcEventList        CHR(3) delimited List of Label, ResultCode, EventAction   
                                EventType. EventTarget, EventParam. EventDisabled
            plModified          YES Sets the attribute/event as modified (displays asterisk)
                                NO  Doesn't set attribute/event as modified
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER phCallingProc    AS HANDLE    NO-UNDO.
DEFINE INPUT PARAMETER pcContainerName  AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER pcObjectName     AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER pcAttributeList  AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER pcEventList      AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER plModified       AS LOGICAL   NO-UNDO.

DEFINE VARIABLE cLabel          AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cValue          AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cResultCode     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE iLoop           AS INTEGER    NO-UNDO.
DEFINE VARIABLE cEventAction    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cEventType      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cEventTarget    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cEventParam     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cEventDisabled  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE lEventDisabled  AS LOGICAL    NO-UNDO.
DEFINE VARIABLE iObjectID       AS INTEGER    NO-UNDO.
DEFINE VARIABLE lRefresh        AS LOGICAL    NO-UNDO.

/* Set the attribute values  */
DO iLoop = 1 TO NUM-ENTRIES(pcAttributeList,CHR(3)) BY 3:
  ASSIGN cLabel      = ENTRY(iLoop,pcAttributeList,CHR(3))
         cResultCode = ENTRY(iLoop + 1,pcAttributeList,CHR(3))
         cResultCode = IF cResultCode = "{&DEFAULT-RESULT-CODE}":U
                          OR cResultCode = "{&NO-RESULT-CODE}":U
                       THEN ""
                       ELSE cResultCode
         cValue      = ENTRY(iLoop + 2,pcAttributeList,CHR(3))
         NO-ERROR.
  
  FIND ttAttribute WHERE ttAttribute.callingProc   = phCallingProc
                     AND ttAttribute.containerName = pcContainerName
                     AND ttAttribute.resultCode    = cResultCode
                     AND ttAttribute.ObjectName    = pcObjectName
                     AND ttAttribute.attrLabel     = cLabel 
                     NO-ERROR.
  IF AVAILABLE(ttAttribute) THEN 
  DO:
     ASSIGN ttAttribute.setValue    = cValue
            ttAttribute.RowOverride = plModified
            iObjectID               = ttAttribute.ObjectID.

    /* If the object being assigned is the current displayed object,
       refresh the browse contents */
     IF phCallingProc = ghLastCallingProc   
        AND  pcContainerName = gcLastContainerName 
        AND  pcObjectName    = gcLastObjectName THEN
     DO:
        FIND FIRST ttSelectedAttribute 
             WHERE ttSelectedAttribute.resultCode = cResultCode 
               AND ttSelectedAttribute.attrLabel  = cLabel NO-ERROR.
        IF AVAIL ttSelectedAttribute THEN
           ASSIGN ttSelectedAttribute.setValue  = cValue
                  ttSelectedAttribute.Override  = " *":U
                  lRefresh                      = TRUE.
     END.


    /* If the value being set is for the master or default result code, assign the
   default value for the non-default result codes equal to this value */
     IF cResultCode = "" THEN
     FOR EACH ttAttribute WHERE ttAttribute.ObjectID    = iobjectID
                            AND ttAttribute.resultCode  > ""
                            AND ttAttribute.attrLabel   = cLabel:

        ASSIGN ttAttribute.defaultValue = cValue
               ttAttribute.setValue     = IF ttAttribute.RowOverride <> TRUE 
                                          THEN cValue ELSE ttAttribute.setValue .
     END. /* End For each */

  END.    /* END if Avail */
END.      /* END DO iLoop */

/* Set the event values  */
DO iLoop = 1 TO NUM-ENTRIES(pcEventList,CHR(3)) BY 7:
  ASSIGN cLabel         = ENTRY(iLoop,pcEventList,CHR(3))
         cResultCode    = ENTRY(iLoop + 1,pcEventList,CHR(3))
         cResultCode    = IF cResultCode = "{&DEFAULT-RESULT-CODE}":U
                          OR cResultCode = "{&NO-RESULT-CODE}":U
                          THEN ""
                          ELSE cResultCode
         cEventAction   = ENTRY(iLoop + 2,pcEventList,CHR(3))
         cEventType     = ENTRY(iLoop + 3,pcEventList,CHR(3))
         cEventTarget   = ENTRY(iLoop + 4,pcEventList,CHR(3))
         cEventParam    = ENTRY(iLoop + 5,pcEventList,CHR(3))
         cEventDisabled = ENTRY(iLoop + 6,pcEventList,CHR(3))
         lEventDisabled = IF cEventDisabled = "yes" OR cEventDisabled = "true"
                          THEN TRUE
                          ELSE FALSE
         NO-ERROR.

  FIND ttEvent WHERE ttEvent.callingProc   = phCallingProc
                 AND ttEvent.containerName = pcContainerName
                 AND ttEvent.resultCode    = cResultCode
                 AND ttEvent.ObjectName    = pcObjectName
                 AND ttEvent.eventName     = cLabel NO-ERROR.

  IF AVAILABLE(ttEvent) THEN 
  DO:
     ASSIGN ttEvent.eventAction     = cEventAction
            ttEvent.eventType       = cEventType
            ttEvent.eventTarget     = cEventTarget
            ttEvent.eventParameter  = ceventParam
            ttEvent.eventDisabled   = lEventDisabled
            ttEvent.RowOverride     = plModified
            iObjectID               = ttEvent.ObjectID
            NO-ERROR.

     /* If the object being assigned is the current displayed object,
       refresh the event browse contents */
     IF phCallingProc       = ghLastCallingProc   
        AND pcContainerName = gcLastContainerName 
        AND pcObjectName    = gcLastObjectName THEN
     DO:
        FIND FIRST ttSelectedEvent 
             WHERE ttSelectedEvent.resultCode = cResultCode 
               AND ttSelectedEvent.eventName  = cLabel NO-ERROR.
        IF AVAIL ttSelectedEvent THEN
           ASSIGN ttSelectedEvent.EventAction   = cEventAction
                  ttSelectedEvent.Override       = " *":U
                  ttSelectedEvent.eventType      = cEventType
                  ttSelectedEvent.eventTarget    = cEventTarget
                  ttSelectedEvent.eventParameter = ceventParam
                  ttSelectedEvent.eventDisabled  = lEventDisabled
                  lRefresh                       = TRUE.
     END.


  /* If the value being set is for the master or default result code, assign the
   default value for the non-default result codes equal to this value */
     IF cResultCode = "" THEN
     FOR EACH ttEvent WHERE ttEvent.ObjectID    = iobjectID
                        AND ttEvent.resultCode  > ""
                        AND ttEvent.eventName   = cLabel:

        ASSIGN ttEvent.defaultAction    = cEventAction
               ttEvent.defaultType      = cEventType
               ttEvent.defaultTarget    = cEventTarget
               ttEvent.defaultParameter = cEventParam
               ttEvent.defaultDisabled  = lEventDisabled
               ttEvent.eventAction    = IF ttEvent.RowOverride <> TRUE THEN cEventAction ELSE ttEvent.eventAction
               ttEvent.eventType      = IF ttEvent.RowOverride <> TRUE THEN cEventType   ELSE ttEvent.eventType
               ttEvent.eventTarget    = IF ttEvent.RowOverride <> TRUE THEN cEventTarget ELSE ttEvent.eventAction
               ttEvent.eventParameter = IF ttEvent.RowOverride <> TRUE THEN cEventParam  ELSE ttEvent.eventParameter
               ttEvent.eventDisabled  = IF ttEvent.RowOverride <> TRUE THEN lEventDisabled ELSE ttEvent.eventDisabled
               NO-ERROR.
     END.
  END.

  
END.

IF lRefresh AND VALID-HANDLE(ghPropSheet) THEN
 RUN refreshBrowse IN ghpropsheet.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-cacheProperties) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE cacheProperties Procedure 
PROCEDURE cacheProperties :
/*------------------------------------------------------------------------------
  Purpose:    Caches the ttAttribute table with all possible
              attributes with default values from a specified class (object type)
  Parameters: pcClass     Classes to build (Object_type_code)
              
  Notes:      
------------------------------------------------------------------------------*/
 DEFINE INPUT  PARAMETER pcClass    AS CHARACTER  NO-UNDO.

 DEFINE VARIABLE cValue           AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE hAttributeBuffer AS HANDLE     NO-UNDO.
 DEFINE VARIABLE hUIEventBuffer   AS HANDLE     NO-UNDO.
 DEFINE VARIABLE hColumn          AS HANDLE     NO-UNDO.
 DEFINE VARIABLE iColumn          AS INTEGER    NO-UNDO.
 DEFINE VARIABLE cName            AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE hQuery           AS HANDLE     NO-UNDO.                                                       
 DEFINE VARIABLE cWhereConstant   AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE iConstant        AS INTEGER    NO-UNDO.
 DEFINE VARIABLE cRunTimeList     AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cSystemList      AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cClassList       AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cMasterList      AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE hDesignClassAttr AS HANDLE     NO-UNDO.
 DEFINE VARIABLE cNarrative       AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cLookupType      AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE clookupValue     AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cGroupName       AS CHARACTER  NO-UNDO.

 RUN fetchAttributes IN THIS-PROCEDURE (INPUT  pcClass,
                                        OUTPUT hAttributeBuffer,
                                        OUTPUT hUIEventBuffer).

 /* Create the default attributes for the class */
 IF VALID-HANDLE(hAttributeBuffer) THEN
 DO:
   hAttributeBuffer:BUFFER-CREATE().
   ASSIGN
     cWhereConstant = hAttributeBuffer:BUFFER-FIELD("tWhereConstant"):BUFFER-VALUE
     /* Attribute settings are returned as lists of field numbers */ 
     cRunTimeList = trim(hAttributeBuffer:BUFFER-FIELD("tRuntimeList":U):BUFFER-VALUE)
     cSystemList  = trim(hAttributeBuffer:BUFFER-FIELD("tSystemList":U):BUFFER-VALUE)
     cClassList   = trim(hAttributeBuffer:BUFFER-FIELD("tClassList":U):BUFFER-VALUE)
     cMasterList  = trim(hAttributeBuffer:BUFFER-FIELD("tMasterList":U):BUFFER-VALUE) NO-ERROR.

   DO iColumn = 1 TO hAttributeBuffer:NUM-FIELDS:
     /* Skip runtime attributes */
     IF CAN-DO(cRunTimeList,STRING(iColumn)) THEN
        NEXT.
     /* Skip system attributes  */
     IF CAN-DO(cSystemList,STRING(iColumn)) THEN
        NEXT.
     
     ASSIGN
        hColumn          = hAttributeBuffer:BUFFER-FIELD(iColumn)
        cName            = hColumn:NAME
        cValue           = hColumn:BUFFER-VALUE
        iConstant        = 0  
        hDesignClassAttr = DYNAMIC-FUNCTION("getCacheClassExtBuffer" IN ghRepositoryDesignManager,
                                                 INPUT pcClass, cName) 
        NO-ERROR.
    IF VALID-HANDLE(hDesignClassAttr) AND hDesignClassAttr:AVAILABLE THEN
       ASSIGN cNarrative   = hDesignClassAttr:BUFFER-FIELD("tNarrative":U):BUFFER-VALUE
              cLookupType  = IF hDesignClassAttr:BUFFER-FIELD("tLookupType":U):BUFFER-VALUE = "" 
                               AND hColumn:DATA-TYPE BEGINS "LOG":U 
                             THEN "LIST":U 
                             ELSE hDesignClassAttr:BUFFER-FIELD("tLookupType":U):BUFFER-VALUE
              cLookupValue = IF hDesignClassAttr:BUFFER-FIELD("tLookupValue":U):BUFFER-VALUE = "" 
                                AND hColumn:DATA-TYPE BEGINS "LOG":U 
                             THEN "Yes" + CHR(3) + "Yes":U + CHR(3) + "No" + CHR(3) + "No":U
                             ELSE hDesignClassAttr:BUFFER-FIELD("tLookupValue":U):BUFFER-VALUE
              cGroupName   = hDesignClassAttr:BUFFER-FIELD("tGroupName":U):BUFFER-VALUE
              NO-ERROR.
     /* Extract the integer entry of the constant level from the tWhereConstant field 
        1 - Class, 2 - Master, 3 - Master and class, 4 - Instance */
     IF iColumn <= NUM-ENTRIES(cWhereConstant) THEN
        ASSIGN iConstant = INT(ENTRY(iColumn,cWhereConstant)) NO-ERROR.

     CREATE ttAttribute.
     ASSIGN ttAttribute.objectID      = 0
            ttAttribute.resultCode    = ""
            ttAttribute.objectClass   = pcClass
            ttAttribute.attrLabel     = cName
            ttAttribute.setValue      = IF hColumn:DATA-TYPE BEGINS "LOG":U AND (cValue = "TRUE" OR cValue = "YES") THEN "Yes" 
                                        ELSE IF hColumn:DATA-TYPE BEGINS "LOG":U AND (cValue = "FALSE" OR cValue = "NO") THEN "No"
                                        ELSE cValue
            ttAttribute.defaultValue  = ttAttribute.setValue
            ttAttribute.dataType      = hColumn:DATA-TYPE
            ttAttribute.narrative     = cNarrative
            ttAttribute.lookupType    = cLookupType
            ttAttribute.lookupValue   = cLookupValue
            ttAttribute.attrGroup     = cGroupName
            ttAttribute.RowModified   = FALSE
            ttAttribute.RowOverride   = FALSE
            /* set constantlevel from the lists */ 
            ttAttribute.constantLevel = IF CAN-DO(cClassList,STRING(iColumn)) 
                                        THEN "CLASS":U
                                        ELSE IF CAN-DO(cMasterList,STRING(iColumn)) 
                                             THEN "MASTER":U
                                             ELSE ""
            ttAttribute.constantLevel = IF iconstant = 1 
                                        THEN "CLASS":U
                                        ELSE IF iconstant >= 2 AND iconstant <= 3 
                                             THEN "MASTER":U
                                             ELSE IF iconstant >=4 
                                                  THEN "INSTANCE":U
                                                  ELSE ttAttribute.constantLevel
                                            
            NO-ERROR.
            
   END. /* END  DO iColumn = 1 TO hAttributeBuffer:NUM-FIELDS: */
   hAttributeBuffer:BUFFER-DELETE().
 END. /* END if VALID-HANDLE hAttribute */

 /* Create the UI events for the class */
 IF VALID-HANDLE(hUIEventBuffer) THEN
 DO:
    CREATE QUERY hQuery.                                                                                
    hQuery:SET-BUFFERS(hUIEventBuffer).                                                              
    hQUery:QUERY-PREPARE("FOR each " + hUIEventBuffer:NAME + " WHERE trecordIdentifier = '0' AND tClassName = '"  + pcClass + "'").                                         
    hQuery:QUERY-OPEN().                                                                                
    hQuery:GET-FIRST().                                                                                 
    DO WHILE hUIEventBuffer:AVAILABLE:                                                               
       CREATE ttEvent.                       
       ASSIGN ttEvent.objectID         = 0        
              ttEvent.resultCode       = ""       
              ttEvent.objectClass      = pcClass  
              ttEvent.EventName        = hUIEventBuffer:BUFFER-FIELD("tEventName"):BUFFER-VALUE 
              ttEvent.EventType        = hUIEventBuffer:BUFFER-FIELD("tActionType"):BUFFER-VALUE
              ttEvent.EventTarget      = hUIEventBuffer:BUFFER-FIELD("tActionTarget"):BUFFER-VALUE
              ttEvent.EventAction      = hUIEventBuffer:BUFFER-FIELD("tEventAction"):BUFFER-VALUE
              ttEvent.EventParameter   = hUIEventBuffer:BUFFER-FIELD("tEventParameter"):BUFFER-VALUE
              ttEvent.eventDisabled    = hUIEventBuffer:BUFFER-FIELD("tEventDisabled"):BUFFER-VALUE     
              ttEvent.defaultAction    = ttEvent.EventAction
              ttEvent.defaultType      = ttEvent.EventType
              ttEvent.defaultTarget    = ttEvent.EventTarget
              ttEvent.defaultParameter = ttEvent.EventParameter
              ttEvent.defaultDisabled  = ttEvent.EventDisabled
              NO-ERROR.
       hQuery:GET-NEXT().                                                                               
    END.                                                                                                
    DELETE OBJECT hQuery.                                                                               
 END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-changeContainerLabel) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE changeContainerLabel Procedure 
PROCEDURE changeContainerLabel :
/*------------------------------------------------------------------------------
  Purpose:    Changes the label of the container which appears in the top fill-in 
              field in the property sheet.
  Parameters: phCallingProc       Calling window handle
              pcContainerName     Name of container
              pcNewContainerLabel New label for container
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER phCallingProc       AS HANDLE    NO-UNDO.
DEFINE INPUT PARAMETER pcContainerName     AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER pcNewContainerLabel AS CHARACTER NO-UNDO.

FOR EACH ttObject WHERE ttObject.callingProc   = phCallingProc 
                    AND ttObject.containerName = pcContainerName :
    ASSIGN ttObject.ContainerLabel = pcNewContainerLabel.
END.
 
IF phCallingProc = ghLastCallingProc   AND
   pcContainerName = gcLastContainerName AND 
   VALID-HANDLE(ghPropSheet) THEN
DO:
   DYNAMIC-FUNCTION("setContainerLabel":U IN ghPropSheet, pcNewContainerLabel).
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-changeContainerName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE changeContainerName Procedure 
PROCEDURE changeContainerName :
/*------------------------------------------------------------------------------
  Purpose:     Changes the name or ID of a container.
  Parameters:  phCallingProc        Calling window handle
               pcContainerName      Name of container
               pcNewContainerName   New Container Name 
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER phCallingProc      AS HANDLE    NO-UNDO.
DEFINE INPUT PARAMETER pcContainerName    AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER pcNewContainerName AS CHARACTER NO-UNDO.

DEFINE BUFFER BUFttObject FOR ttObject.

/* Check that new name doesn't already exist */
IF CAN-FIND(FIRST ttObject 
            WHERE ttObject.callingProc   = phCallingProc 
              AND ttObject.containerName = pcNewContainerName ) THEN
DO:
   MESSAGE "Object Name " pcNewContainerName + " already exists." 
      VIEW-AS ALERT-BOX INFO BUTTONS OK.
   RETURN "ERROR":U.
END.

FOR EACH ttObject WHERE ttObject.callingProc   = phCallingProc 
                    AND ttObject.containerName = pcContainerName :
 
     FIND BUFttObject WHERE RECID(BUFttObject) = RECID(ttObject) NO-ERROR.
     ASSIGN BUFttObject.containerName    =  pcNewContainerName.
     FOR EACH ttAttribute WHERE ttAttribute.ObjectID = ttObject.ObjectID:
        ASSIGN ttAttribute.containerName = pcNewContainerName.
     END.
     FOR EACH ttEvent WHERE ttEvent.ObjectID = ttObject.ObjectID:
        ASSIGN ttEvent.containerName = pcNewContainerName.
     END.
   
END.

/* If the container itself is a registered object,changeit. */
RUN changeObjectName IN THIS-PROCEDURE
   (INPUT phCallingProc,       /*    Calling window handle   */
    INPUT pcNewContainerName,  /*    Name of container       */
    INPUT pcContainerName,     /*    Previous registered Object */
    INPUT pcNewContainerName).  /*    New ObjectName          */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-changeObjectClass) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE changeObjectClass Procedure 
PROCEDURE changeObjectClass :
/*------------------------------------------------------------------------------
  Purpose:   Changes the attribute class of an object   
  Parameters: phCallingProc     Calling window handle
              pcContainerName   Name of container
              pcObjectName      Object name used in registerObject
              pcNewClassCode    New class code for the  object.
  Notes:      
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER phCallingProc    AS HANDLE    NO-UNDO.
DEFINE INPUT PARAMETER pcContainerName  AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER pcObjectName     AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER pcNewClassCode   AS CHARACTER  NO-UNDO.

DEFINE BUFFER BUFttAttribute FOR ttAttribute.
DEFINE BUFFER BUFttEvent     FOR ttEvent.

DEFINE VARIABLE cOriginalObjectClass AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cResultCode          AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cResultCodeList      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE iLoop                AS INTEGER    NO-UNDO.

IF NOT CAN-FIND(FIRST ttAttribute WHERE ttAttribute.objectClass = pcNewClassCode
                                    AND ttAttribute.ObjectID    = 0) THEN
      RUN cacheProperties IN THIS-PROCEDURE (INPUT pcNewClassCode).


FIND FIRST ttObject WHERE ttObject.callingProc   = phCallingProc 
                      AND ttObject.containerName = pcContainerName 
                      AND ttObject.ObjectName    = pcObjectName NO-ERROR.
 
IF AVAILABLE ttObject THEN 
DO:
  ASSIGN cOriginalObjectClass     = ttObject.ObjectClassCode
         ttObject.ObjectClassCode = pcNewClassCode.
         
 
  ASSIGN cResultCodeList =  getResultCodeList(phCallingProc, pcContainerName,pcObjectName ).
         
  IF cResultCodeList = "" OR cResultCodeList = ? THEN
       cResultCodeList = "{&DEFAULT-RESULT-CODE}":U.

  /* Loop through each attribute for the new class,  */
  FOR EACH ttAttribute WHERE ttAttribute.objectClass = pcNewClassCode
                         AND ttAttribute.ObjectID    = 0:
     /* Add all attributes for each possible result code */
    DO iLoop = 1 TO NUM-ENTRIES(cResultCodeList):
      ASSIGN cResultCode = TRIM(ENTRY(iLoop,cResultCodeList))
             cResultCode = IF cResultCode = "{&DEFAULT-RESULT-CODE}":U
                             OR cResultCode = "{&NO-RESULT-CODE}":U
                           THEN ""
                           ELSE cResultCode. 
      FIND FIRST BUFttAttribute WHERE BUFttAttribute.objectID    = ttObject.objectID
                                  AND BUFttAttribute.resultCode  = cResultCode
                                  AND BUFttAttribute.objectClass = cOriginalObjectClass
                                  AND BUFttAttribute.attrLabel   = ttAttribute.attrLabel NO-ERROR.
      IF AVAILABLE(BUFttAttribute) THEN
         ASSIGN BUFttAttribute.objectClass = pcNewClassCode.
      ELSE
      DO:
        CREATE BUFttAttribute.
        BUFFER-COPY ttAttribute TO  BUFttAttribute
             ASSIGN BUFttAttribute.objectID      = ttObject.objectID
                    BUFttAttribute.callingProc   = phCallingProc
                    BUFttAttribute.containerName = pcContainerName
                    BUFttAttribute.objectName    = pcObjectName
                    BUFttAttribute.resultCode    = cResultCode.
      END.
    END. /* End Do iLoop = 2 to ... */
  END. /* END FOR Each ttAttribute */

  FOR EACH ttAttribute WHERE ttAttribute.objectID     = ttObject.ObjectID
                         AND ttAttribute.objectClass = cOriginalObjectClass:
     DELETE ttAttribute.
  END.

  /* Add new Events and delete old events */
  FOR EACH ttEvent WHERE ttEvent.objectClass = pcNewClassCode
                     AND ttEvent.ObjectID    = 0:
     /* Add all attributes for each possible result code */
    DO iLoop = 1 TO NUM-ENTRIES(cResultCodeList):
      ASSIGN cResultCode = TRIM(ENTRY(iLoop,cResultCodeList))
             cResultCode = IF cResultCode = "{&DEFAULT-RESULT-CODE}":U
                             OR cResultCode = "{&NO-RESULT-CODE}":U
                           THEN ""
                           ELSE cResultCode. 
      FIND FIRST BUFttEvent WHERE BUFttEvent.objectID        = ttObject.objectID
                                  AND BUFttEvent.resultCode  = cResultCode
                                  AND BUFttEvent.objectClass = cOriginalObjectClass
                                  AND BUFttEvent.eventName   = ttEvent.eventName NO-ERROR.
      IF AVAILABLE(BUFttEvent) THEN
         ASSIGN BUFttEvent.objectClass = pcNewClassCode.
      ELSE
      DO:
        CREATE BUFttEvent.
        BUFFER-COPY ttEvent TO  BUFttEvent
             ASSIGN BUFttEvent.objectID      = ttObject.objectID
                    BUFttEvent.callingProc   = phCallingProc
                    BUFttEvent.containerName = pcContainerName
                    BUFttEvent.objectName    = pcObjectName
                    BUFttEvent.resultCode    = cResultCode.
      END.
    END. /* End Do iLoop = 2 to ... */
  END. /* END FOR Each ttAttribute */

  FOR EACH ttEvent WHERE ttEvent.objectID     = ttObject.ObjectID
                     AND ttEvent.objectClass = cOriginalObjectClass:
     DELETE ttEvent.
  END.



END.




END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-changeObjectLabel) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE changeObjectLabel Procedure 
PROCEDURE changeObjectLabel :
/*------------------------------------------------------------------------------
  Purpose:     Changes the label of an object.
  Parameters:  phCallingProc     Calling window handle
               pcContainerName   Name of container
               pcObjectName      Object name used in registerObject
               pcNewObjectLabel  New Label for object which appears in the Object
                                 combo-box in the property sheet.
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER phCallingProc    AS HANDLE    NO-UNDO.
DEFINE INPUT PARAMETER pcContainerName  AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER pcObjectName     AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER pcNewObjectLabel AS CHARACTER NO-UNDO.

FIND FIRST ttObject WHERE ttObject.callingProc   = phCallingProc 
                      AND ttObject.containerName = pcContainerName 
                      AND ttObject.ObjectName    = pcObjectName NO-ERROR.
 
IF AVAILABLE ttObject THEN 
  ASSIGN ttObject.ObjectLabel = pcNewObjectLabel.
         
IF VALID-HANDLE(ghPropSheet) THEN
  DYNAMIC-FUNCTION("setObjectList":U IN ghPropSheet, INPUT phCallingProc, 
                                                     INPUT pcContainerName).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-changeObjectName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE changeObjectName Procedure 
PROCEDURE changeObjectName :
/*------------------------------------------------------------------------------
  Purpose:     Changes the name or ID of an object.
  Parameters:  phCallingProc     Calling window handle
               pcContainerName   Name of container
               pcObjectName      Previous Object name used in registerObject
               pcNewObjectName   New ObjectName 
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER phCallingProc    AS HANDLE    NO-UNDO.
DEFINE INPUT PARAMETER pcContainerName  AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER pcObjectName     AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER pcNewObjectName  AS CHARACTER NO-UNDO.

/* Check that new name doesn't already exist */
IF CAN-FIND(FIRST ttObject 
            WHERE ttObject.callingProc   = phCallingProc 
              AND ttObject.containerName = pcContainerName 
              AND ttObject.ObjectName    = pcNewObjectName ) THEN
DO:
   MESSAGE "Object Name " pcNewObjectName + " already exists." 
      VIEW-AS ALERT-BOX INFO BUTTONS OK.
   RETURN "ERROR":U.
END.

FIND FIRST ttObject WHERE ttObject.callingProc   = phCallingProc 
                      AND ttObject.containerName = pcContainerName 
                      AND ttObject.ObjectName    = pcObjectName NO-ERROR.
 
IF AVAILABLE ttObject THEN 
DO ON ERROR UNDO,LEAVE:
  ASSIGN ttObject.ObjectName = pcNewObjectName.
  FOR EACH ttAttribute WHERE ttAttribute.ObjectID = ttObject.ObjectID:
     ASSIGN ttAttribute.ObjectName = pcNewObjectName.
  END.
  FOR EACH ttEvent WHERE ttEvent.ObjectID = ttObject.ObjectID:
     ASSIGN ttEvent.ObjectName = pcNewObjectName.
  END.
END.
  
         

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-DeleteObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE DeleteObject Procedure 
PROCEDURE DeleteObject :
/*------------------------------------------------------------------------------
  Purpose:    Sets the Delete status of an object. 
  Parameters: phCallingProc     Handle of calling procedure
              pcContainerName   Name of container or master object (Required)
              pcObjectName      Name of Object that is being deleted. 
              
  Notes:      The calling procedure would need to register the master object, 
              and if the master object has child containing objects, each one of those 
              objects would also have to be registered. 
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER phCallingProc        AS HANDLE  NO-UNDO.
DEFINE INPUT  PARAMETER pcContainerName      AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER pcObjectName         AS CHARACTER  NO-UNDO.

FOR EACH ttObject WHERE ttObject.callingProc   = phCallingProc
                    AND ttObject.containerName = pcContainerName
                    AND ttObject.objectName    = pcObjectName:

   ASSIGN ttObject.isDeleted = YES.
END.




END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-destroyObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE destroyObject Procedure 
PROCEDURE destroyObject :
/*------------------------------------------------------------------------------
  Purpose:     Destroys the procedure only if no objects are registered
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
IF NOT CAN-FIND(FIRST ttObject) THEN 
DO:
   IF VALID-HANDLE(ghPropSheet) THEN  DO:
      RUN destroyObject IN ghPropSheet.
      ghPropSheet = ?.
   END.
      
   IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END.
   


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-displayProperties) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE displayProperties Procedure 
PROCEDURE displayProperties :
/*------------------------------------------------------------------------------
  Purpose:     Displays all attributes for the selected objects of the
               specified container and window
  Parameters:  phCallingProc     Calling window handle
               pcContainerName   Name of container
               pcObjectNameList  CHR(3) delimited list of object names
               pcResultCode      Specify to force the property sheet to display
                                 selected result code
               plResultCodeDisabled  If Yes, the specified result code is
                                     forced and the combo-box is disabled.                  
               piPageView        0 - Display both attribute and event pages
                                 1 - Display Attribute page and Hide event page
                                 2 - Display Event page and hide Attribute page
                                                       
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER phCallingProc        AS HANDLE    NO-UNDO.
DEFINE INPUT PARAMETER pcContainerName      AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER pcObjectNameList     AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER pcResultCode         AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAMETER plResultCodeDisabled AS LOGICAL    NO-UNDO.
DEFINE INPUT PARAMETER piPageView           AS INTEGER    NO-UNDO.

DEFINE VARIABLE iCount           AS INTEGER    NO-UNDO.
DEFINE VARIABLE cCommonValue     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE lOverride        AS LOGICAL    NO-UNDO.
DEFINE VARIABLE cObjectIDList    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cUniqueAttribute AS CHARACTER  NO-UNDO INIT "(NAME)":U.
DEFINE VARIABLE cFirstAttributes AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cContainerLabel  AS CHARACTER  NO-UNDO.

DEFINE BUFFER BUFttAttribute FOR ttAttribute.
DEFINE BUFFER BUFttObject    FOR ttObject.
DEFINE BUFFER BUFttEvent     FOR ttEvent.

EMPTY TEMP-TABLE ttSelectedAttribute.
EMPTY TEMP-TABLE ttSelectedEvent.


ASSIGN phCallingProc       = IF phCallingProc    = ? THEN ghLastCallingProc   ELSE phCallingProc
       pcContainerName     = IF pcContainerName  = ? THEN gcLastContainerName ELSE pcContainerName
       pcObjectNameList    = IF pcObjectNameList = ? THEN gcLastObjectName    ELSE pcObjectNameList
       ghLastCallingProc   = phCallingProc
       gcLastContainerName = pcContainerName
       gcLastObjectName    = pcObjectNameList.
/* If only 1 object is selected retrieve it's attributes and copy to table
   bound to browser (ttSelectedAttribute)  */
IF NUM-ENTRIES(pcObjectNameList,CHR(3)) = 1 THEN
DO:
  FIND FIRST ttObject WHERE ttObject.callingProc   = phCallingProc
                        AND ttObject.containerName = pcContainerName
                        AND ttObject.objectName    = pcObjectNameList NO-ERROR.

  IF AVAILABLE ttObject THEN
  DO:
    ASSIGN cContainerLabel = ttObject.ContainerLabel.
    FOR EACH ttAttribute WHERE ttAttribute.objectID   = ttObject.ObjectID:
      CREATE ttSelectedAttribute.
      BUFFER-COPY ttAttribute TO ttSelectedAttribute  
         ASSIGN ttSelectedAttribute.objectList = STRING(ttObject.ObjectID)
                ttSelectedAttribute.Override   = IF ttAttribute.RowOverride 
                                                 THEN " *":U 
                                                 ELSE "".
      cFirstAttributes = getAttributeFirst(phCallingProc).
      IF LOOKUP(ttAttribute.attrLabel,cFirstAttributes,CHR(2)) > 0 THEN
         ASSIGN ttSelectedAttribute.attrLabel = "(" +  ttAttribute.attrLabel + ")".
    END.

    FOR EACH ttEvent WHERE ttEvent.ObjectID  = ttObject.objectID:
        CREATE ttSelectedEvent.
        BUFFER-COPY ttEvent TO ttSelectedEvent
           ASSIGN ttSelectedEvent.objectList  = STRING(ttObject.ObjectID)
                  ttSelectedEvent.Override    = IF ttEvent.RowOverride 
                                                 THEN " *":U 
                                                 ELSE "".
    END.
    FIND FIRST ttSelectedAttribute NO-ERROR.
    FIND FIRST ttSelectedEvent NO-ERROR.

  END.
END.
ELSE IF NUM-ENTRIES(pcObjectNameList,CHR(3)) > 1 THEN
DO:  /* If more than one object is selected, calculate the common attributes and copy to table 
        bound to browser (ttSelectedAttribute) Also calculate common attribute values*/
  
  /* Build a delimited list of Object IDs from the list of object names */
  DO icount = 1 TO  NUM-ENTRIES(pcObjectNameList,CHR(3)):
    FIND FIRST ttObject WHERE ttObject.callingProc   = phCallingProc
                          AND ttObject.containerName = pcContainerName
                          AND ttObject.objectName    = ENTRY(icount,pcObjectNameList,CHR(3)) NO-ERROR.
    IF AVAILABLE(ttObject) THEN
      ASSIGN cObjectIDList   = cObjectIDList + (IF cObjectIDList = "" THEN "" ELSE ",") 
                                           + STRING(ttObject.ObjectID)
             cContainerLabel = ttObject.ContainerLabel.
  END.

  Attr-Loop:
  FOR EACH ttAttribute  WHERE ttAttribute.ObjectID = INTEGER(ENTRY(1,cObjectIDList)):
    IF lookup(ttAttribute.attrLabel,cUniqueAttribute) > 0  THEN  /* Skip unique attributes */
       NEXT Attr-Loop.
    ASSIGN cCommonValue    = ttAttribute.setValue
           lOverride       = ttAttribute.RowOverride.
    DO iCount = 2 TO NUM-ENTRIES(cObjectIDList):
      FIND FIRST BUFttAttribute
           WHERE BUFttAttribute.ObjectID  = INTEGER(ENTRY(icount,cObjectIDList))
             AND BUFttAttribute.resultcode = ttAttribute.resultCode
             AND BUFttAttribute.attrLabel = ttAttribute.attrLabel NO-ERROR.
      IF NOT AVAILABLE BUFttAttribute THEN
      DO:
        ASSIGN cCommonValue = ""
               lOverride    = NO.
        NEXT Attr-Loop.
      END.
      IF BUFttAttribute.setValue <> cCommonValue  THEN
         cCommonValue = "".

    END. /* END icount = 2 to  NUM-ENTRIES(pcObjectNameList) */
    CREATE ttSelectedAttribute.
    BUFFER-COPY ttAttribute TO ttSelectedAttribute
      ASSIGN ttSelectedAttribute.objectList = cObjectIDList
             ttSelectedAttribute.setValue  =  cCommonValue
             ttSelectedAttribute.OVERRIDE  = IF lOverride THEN " *" ELSE "".
    cFirstAttributes = getAttributeFirst(phCallingProc).
    IF LOOKUP(ttAttribute.attrLabel,cFirstAttributes,CHR(2)) > 0 THEN
         ASSIGN ttSelectedAttribute.attrLabel = "(" +  ttAttribute.attrLabel + ")".
  END. /* END FOR EACH ttAttribute */
  FIND FIRST ttSelectedAttribute NO-ERROR.

  Event-Loop:
  FOR EACH ttEvent  WHERE ttEvent.ObjectID = INTEGER(ENTRY(1,cObjectIDList)):
    ASSIGN cCommonValue = ttEvent.eventAction
           lOverride    = ttEvent.RowOverride.
    DO iCount = 2 TO NUM-ENTRIES(cObjectIDList):
      FIND FIRST BUFttEvent
           WHERE BUFttEvent.ObjectID   = INTEGER(ENTRY(icount,cObjectIDList))
             AND BUFttEvent.resultCode = ttEvent.ResultCode
             AND BUFttEvent.eventName  = ttEvent.eventName NO-ERROR.
      IF NOT AVAILABLE BUFttEvent THEN
      DO:
        ASSIGN cCommonValue = ""
               lOverride    = NO.
        NEXT Event-Loop.
      END.
      IF BUFttEvent.eventAction <> cCommonValue  THEN
         cCommonValue = "".

    END. /* END icount = 2 to  NUM-ENTRIES(pcObjectNameList) */
    CREATE ttSelectedEvent.
    BUFFER-COPY ttEvent TO ttSelectedEvent
      ASSIGN ttSelectedEvent.objectList   = cObjectIDList
             ttSelectedEvent.eventAction  =  cCommonValue
             ttSelectedEvent.OVERRIDE  = IF lOverride THEN " *" ELSE "".
  END. /* END FOR EACH ttEvent */
  FIND FIRST ttSelectedEvent NO-ERROR.
END.

IF VALID-HANDLE(ghPropSheet) THEN 
DO:
 
  DYNAMIC-FUNC("setResultCode":U IN ghPropSheet, pcResultCode,plResultCodeDisabled).
  IF piPageView <> ? THEN
    RUN folderVisible IN ghPropSheet (piPageView).
  
  RUN refreshQuery IN ghPropSheet (phCallingProc,pcContainerName,cContainerLabel,pcObjectNameList).
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fetchAttributes) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE fetchAttributes Procedure 
PROCEDURE fetchAttributes :
/*------------------------------------------------------------------------------
  Purpose:     Uses repsitory API to retrieve attributes and return attribute
               and event from 
               
  Parameters:  pcObjectClass      Name of class object
      OUTPUT   phAttributeBuffer  Handle of attribute buffer 
      OUTPUT   phUIEventBuffer    Handle of event buffer
  
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER pcObjectClass     AS CHARACTER   NO-UNDO.
DEFINE OUTPUT PARAMETER phAttributeBuffer AS HANDLE      NO-UNDO.
DEFINE OUTPUT PARAMETER phUIEventBuffer   AS HANDLE      NO-UNDO.

DEFINE VARIABLE httClassBuffer      AS HANDLE            NO-UNDO.
DEFINE VARIABLE hClassTable         AS HANDLE  EXTENT 32 NO-UNDO.
DEFINE VARIABLE hAttributeBuffer    AS HANDLE            NO-UNDO.
  
/* Fetch the repository class*/
httClassBuffer = DYNAMIC-FUNCTION("getCacheClassBuffer":U IN gshRepositoryManager,
                                    pcObjectClass).

/* Retrieve design time info into client-side cache  */
IF NOT VALID-HANDLE(ghRepositoryDesignManager) THEN
   ASSIGN ghRepositoryDesignManager = DYNAMIC-FUNCTION("getManagerHandle":U, INPUT "RepositoryDesignManager":U).

DYNAMIC-FUNCTION("cacheClassExtInfo":U IN ghRepositoryDesignManager, pcObjectClass).

IF VALID-HANDLE(httClassBuffer) THEN
DO:
  ASSIGN phAttributeBuffer = httClassBuffer:BUFFER-FIELD("classBufferHandle":U):BUFFER-VALUE.   
  
    /* Get and find the UIEvent buffer */
  phUIEventBuffer = DYNAMIC-FUNCTION("getCacheUIEventBuffer":U IN gshRepositoryManager).
  phUIEventBuffer:FIND-FIRST (" WHERE " + phUIEventBuffer:NAME + ".tClassName = '" + pcObjectClass + "'") NO-ERROR.
END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getLastObjectDetails) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getLastObjectDetails Procedure 
PROCEDURE getLastObjectDetails :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE OUTPUT PARAMETER phLastCallingProc   AS HANDLE     NO-UNDO.
  DEFINE OUTPUT PARAMETER pcLastContainerName AS CHARACTER  NO-UNDO.
  DEFINE OUTPUT PARAMETER pcLastObjectName    AS CHARACTER  NO-UNDO.

  ASSIGN
      phLastCallingProc   = ghLastCallingProc
      pcLastContainerName = gcLastContainerName
      pcLastObjectName    = gcLastObjectName.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-launchPropertyWindow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE launchPropertyWindow Procedure 
PROCEDURE launchPropertyWindow :
/*------------------------------------------------------------------------------
  Purpose:    Launches the Property window 
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE hWIndow AS HANDLE     NO-UNDO.
IF NOT VALID-HANDLE(ghPropSheet) THEN
DO:
   RUN ry/uib/ryvobpropw.w PERSISTENT SET ghPropSheet.  
      
   RUN initializeObject IN ghPropSheet.
     
END.
ELSE DO:
  {get COntainerHandle hWindow ghPropSheet}.
  IF VALID-HANDLE(hWindow) THEN
  DO:
     hWIndow:MOVE-TO-TOP().
     IF hWIndow:WINDOW-STATE = WINDOW-MINIMIZED  THEN
        hWIndow:WINDOW-STATE = WINDOW-NORMAL.

  END.

END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-rebuildObjects) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE rebuildObjects Procedure 
PROCEDURE rebuildObjects :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
IF VALID-HANDLE(ghPropSheet) THEN
   RUN rebuildObjects IN ghPropSheet.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-refreshProperty) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE refreshProperty Procedure 
PROCEDURE refreshProperty :
/*------------------------------------------------------------------------------
  Purpose:     Refreshes the cache of a specified class
  Parameters:  pcClass     Name of class to refresh
               pcAttribute Name of attribute label
               pcMode      ADD     Attribute was added
                           MODIFY  Attribute was modified
                           DELETE  Attribute was deleted
               pcType      ATTRIBUTE   An Attribute was effected
                           EVENT       An event was effected            
                           
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER pcClass     AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER pcAttribute AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER pcMode      AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER pcType      AS CHARACTER  NO-UNDO.

DEFINE VARIABLE cGroupList       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE iLoop            AS INTEGER    NO-UNDO.
DEFINE VARIABLE httClassBuffer   AS HANDLE     NO-UNDO.
DEFINE VARIABLE hUIEventBuffer   AS HANDLE     NO-UNDO.
DEFINE VARIABLE hAttributeBuffer AS HANDLE     NO-UNDO.
DEFINE VARIABLE hAttribute       AS HANDLE     NO-UNDO.
DEFINE VARIABLE cWhereConstant   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE iConstant        AS INTEGER    NO-UNDO.
DEFINE VARIABLE cRunTimeList     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cSystemList      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cClassList       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cMasterList      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE hDesignClassAttr AS HANDLE     NO-UNDO.
DEFINE VARIABLE cNarrative       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cLookupType      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE clookupValue     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cGroupName       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cName            AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cValue           AS CHARACTER  NO-UNDO.
DEFINE VARIABLE iCOlumn          AS INTEGER    NO-UNDO.
DEFINE VARIABLE cResultCode      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE hQuery           AS HANDLE     NO-UNDO.

DEFINE BUFFER BUFttAttribute FOR  ttAttribute.
DEFINE BUFFER BUFttEvent     FOR  ttEvent.

/* If deleting an attribute or event, remove from DPS temp tables */
IF pcMode = "DELETE":U THEN 
DO:
   IF pcType = "Attribute":U THEN
   DO:
      FOR EACH ttAttribute WHERE ttAttribute.objectClass = pcClass
                             AND ttAttribute.attrLabel   = pcAttribute:
         DELETE ttAttribute.
      END.

   END.
   ELSE IF pcType = "Event":U THEN 
   DO:
      FOR EACH ttEvent WHERE ttEvent.objectClass = pcClass
                         AND ttEvent.EventName   = pcAttribute:
         DELETE ttEvent.
      END.
   END.
   RUN destroyClassCache IN gshRepositoryManager.
   httClassBuffer = DYNAMIC-FUNCTION("getCacheClassBuffer":U IN gshRepositoryManager,
                                     pcClass).

/* Refresh the DPS */
   RUN displayProperties IN THIS-PROCEDURE  (?,?,?,?,?,?). 
   
   RETURN.
END.


 /* Recreate cache for specified class */
RUN destroyClassCache IN gshRepositoryManager.
httClassBuffer = DYNAMIC-FUNCTION("getCacheClassBuffer":U IN gshRepositoryManager,
                                   pcClass).
/* Get and find the UIEvent buffer */
hUIEventBuffer = DYNAMIC-FUNCTION("getCacheUIEventBuffer":U IN gshRepositoryManager).
hUIEventBuffer:FIND-FIRST (" WHERE " + hUIEventBuffer:NAME + ".tClassName = '" + pcClass + "'") NO-ERROR.

/* Retrieve design time info into client-side cache  */
IF NOT VALID-HANDLE(ghRepositoryDesignManager) THEN
   ASSIGN ghRepositoryDesignManager = DYNAMIC-FUNCTION("getManagerHandle":U, INPUT "RepositoryDesignManager":U).
DYNAMIC-FUNCTION("cacheClassExtInfo":U IN ghRepositoryDesignManager, pcClass).

IF pcType = "Attribute":U THEN
DO:
   IF VALID-HANDLE(httClassBuffer) THEN
      ASSIGN hAttributeBuffer = httClassBuffer:BUFFER-FIELD("classBufferHandle":U):BUFFER-VALUE.   
   ASSIGN hAttribute = hAttributeBuffer:BUFFER-FIELD(pcAttribute) NO-ERROR.
   /* Create the default attributes for the class */
   IF VALID-HANDLE(hAttributeBuffer) AND VALID-HANDLE(hAttribute) THEN
   DO:
      /* Delete default values for attributes for the specified class, having ObjectID = 0  */
      FIND FIRST ttAttribute WHERE ttAttribute.resultCode   = ""
                               AND ttAttribute.ObjectID     = 0
                               AND ttAttribute.objectClass  = pcClass
                               AND ttAttribute.AttrLabel    = pcAttribute NO-ERROR.

      IF AVAILABLE ttAttribute THEN
         DELETE ttAttribute.

      hAttributeBuffer:BUFFER-CREATE().
      ASSIGN
        cWhereConstant = hAttributeBuffer:BUFFER-FIELD("tWhereConstant"):BUFFER-VALUE
        /* Attribute settings are returned as lists of field numbers */ 
        cRunTimeList = trim(hAttributeBuffer:BUFFER-FIELD("tRuntimeList":U):BUFFER-VALUE)
        cSystemList  = trim(hAttributeBuffer:BUFFER-FIELD("tSystemList":U):BUFFER-VALUE)
        cClassList   = trim(hAttributeBuffer:BUFFER-FIELD("tClassList":U):BUFFER-VALUE)
        cMasterList  = trim(hAttributeBuffer:BUFFER-FIELD("tMasterList":U):BUFFER-VALUE) 
        NO-ERROR.
      /* Skip runtime attributes */
      IF CAN-DO(cRunTimeList,hAttribute:NAME) THEN NEXT.
      /* Skip system attributes  */
      IF CAN-DO(cSystemList,hAttribute:NAME) THEN NEXT.
       
      ASSIGN
        iColumn          = hAttribute:POSITION - 1
        cName            = hAttribute:NAME
        cValue           = hAttribute:BUFFER-VALUE
        iConstant        = 0  
        hDesignClassAttr = DYNAMIC-FUNCTION("getCacheClassExtBuffer" IN ghRepositoryDesignManager,
                                                 INPUT pcClass, cName) 
        NO-ERROR.
      IF VALID-HANDLE(hDesignClassAttr) AND hDesignClassAttr:AVAILABLE THEN
         ASSIGN cNarrative   = hDesignClassAttr:BUFFER-FIELD("tNarrative":U):BUFFER-VALUE
                cLookupType  = IF hDesignClassAttr:BUFFER-FIELD("tLookupType":U):BUFFER-VALUE = "" 
                                AND hAttribute:DATA-TYPE BEGINS "LOG":U 
                               THEN "LIST":U 
                               ELSE hDesignClassAttr:BUFFER-FIELD("tLookupType":U):BUFFER-VALUE
                cLookupValue = IF hDesignClassAttr:BUFFER-FIELD("tLookupValue":U):BUFFER-VALUE = "" 
                                 AND hAttribute:DATA-TYPE BEGINS "LOG":U 
                               THEN "Yes" + CHR(3) + "Yes":U + CHR(3) + "No" + CHR(3) + "No":U
                               ELSE hDesignClassAttr:BUFFER-FIELD("tLookupValue":U):BUFFER-VALUE
                cGroupName   = hDesignClassAttr:BUFFER-FIELD("tGroupName":U):BUFFER-VALUE
                NO-ERROR.
      /* Extract the integer entry of the constant level from the tWhereConstant field 
          1 - Class, 2 - Master, 3 - Master and class, 4 - Instance */
      IF iColumn <= NUM-ENTRIES(cWhereConstant) THEN
         ASSIGN iConstant = INT(ENTRY(iColumn,cWhereConstant)) NO-ERROR.

      CREATE ttAttribute.
      ASSIGN ttAttribute.objectID      = 0
             ttAttribute.resultCode    = ""
             ttAttribute.objectClass   = pcClass
             ttAttribute.attrLabel     = cName
             ttAttribute.setValue      = IF hAttribute:DATA-TYPE BEGINS "LOG":U AND (cValue = "TRUE" OR cValue = "YES") THEN "Yes" 
                                         ELSE IF hAttribute:DATA-TYPE BEGINS "LOG":U AND (cValue = "FALSE" OR cValue = "NO") THEN "No"
                                         ELSE cValue
             ttAttribute.defaultValue  = ttAttribute.setValue
             ttAttribute.dataType      = hAttribute:DATA-TYPE
             ttAttribute.narrative     = cNarrative
             ttAttribute.lookupType    = cLookupType
             ttAttribute.lookupValue   = cLookupValue
             ttAttribute.attrGroup     = cGroupName
             ttAttribute.RowModified   = FALSE
             ttAttribute.RowOverride   = FALSE
             /* set constantlevel from the lists */ 
             ttAttribute.constantLevel = IF CAN-DO(cClassList,STRING(iColumn)) 
                                         THEN "CLASS":U
                                         ELSE IF CAN-DO(cMasterList,STRING(iColumn)) 
                                              THEN "MASTER":U
                                              ELSE ""
             ttAttribute.constantLevel = IF iconstant = 1 
                                         THEN "CLASS":U
                                         ELSE IF iconstant >= 2 AND iconstant <= 3 
                                              THEN "MASTER":U
                                              ELSE IF iconstant >=4 
                                                   THEN "INSTANCE":U
                                                   ELSE ttAttribute.constantLevel
             NO-ERROR.
              
      hAttributeBuffer:BUFFER-DELETE().
   END. /* END if VALID-HANDLE hAttribute */

   /* Fetch all objects having the refreshed class and reset the default values */
   FOR EACH ttAttribute WHERE ttAttribute.objectClass = pcClass
                          AND ttAttribute.ObjectID    = 0
                          AND ttAttribute.AttrLabel   = pcAttribute:

     /* Fetch attributes that have been modified */
     FOR EACH BUFttAttribute WHERE BUFttAttribute.objectClass = pcClass
                               AND BUFttAttribute.ObjectID    > 0
                               AND BUFttAttribute.attrLabel   = ttAttribute.attrLabel:
        ASSIGN BUFttAttribute.dataType     = ttAttribute.dataType
               BUFttAttribute.lookupType   = ttATtribute.LookupType
               BUFttAttribute.lookupValue  = ttAttribute.LookupValue
               BUFttAttribute.narrative    = ttAttribute.narrative
               BUFttAttribute.AttrGroup    = ttAttribute.attrGroup.

        IF BUFttAttribute.resultCode > "" THEN
        DO:
          IF NOT BUFttAttribute.RowModified  AND NOT BUFttAttribute.RowOverride THEN
              ASSIGN BUFttAttribute.setValue     = ttAttribute.setValue.
        END.
        ELSE DO:   
          IF NOT BUFttAttribute.RowModified  AND NOT BUFttAttribute.RowOverride THEN
              ASSIGN BUFttAttribute.defaultValue = ttAttribute.defaultValue
                     BUFttAttribute.setValue     = ttAttribute.setValue.

        END.

     END. /* END FOR EACH BUFttAttribute */

     /* Add attribute record for newly added attributes */
     IF pcMode = "ADD":U 
        AND NOT CAN-FIND(FIRST BUFttAttribute 
                         WHERE BUFttAttribute.objectClass = pcClass
                           AND BUFttAttribute.ObjectID   > 0
                           AND BUFttAttribute.attrLabel   = ttAttribute.attrLabel ) THEN
        /* Add a new attribute for every registered object and every result code */
        FOR EACH ttObject :
           DO iLoop = 1 TO NUM-ENTRIES(ttObject.resultCodes):
             ASSIGN cResultCode = TRIM(ENTRY(iLoop,ttObject.resultCodes))
                    cResultCode = IF cResultCode = "{&DEFAULT-RESULT-CODE}":U
                                  OR cResultCode = "{&NO-RESULT-CODE}":U
                                  THEN ""
                                  ELSE cResultCode. 
             CREATE BUFttAttribute.
             BUFFER-COPY ttAttribute TO BUFttAttribute
                 ASSIGN BUFttAttribute.objectID      = ttObject.objectID
                        BUFttAttribute.callingProc   = ttObject.CallingProc
                        BUFttAttribute.containerName = ttObject.ContainerName
                        BUFttAttribute.objectName    = ttObject.ObjectName
                        BUFttAttribute.resultCode    = cResultCode
                        NO-ERROR.
             CASE ttObject.ObjectLevel:
               WHEN "MASTER":U THEN
                  IF ttAttribute.constantLevel = "CLASS":U THEN
                     BUFttAttribute.isDisabled = TRUE.
               WHEN "INSTANCE":U THEN
                  IF ttAttribute.constantLevel = "CLASS":U 
                       OR ttAttribute.constantLevel = "MASTER":U   THEN
                     BUFttAttribute.isDisabled = TRUE.
             END CASE.
           END.
        END. /* End For each ttObject */
       /* Recalculate the groups for the class */
     IF ttAttribute.attrGroup > "" AND LOOKUP(ttAttribute.attrGroup,cGroupList,CHR(3)) = 0 THEN
          cGroupList = cGroupList + (IF cGroupList = "" THEN "" ELSE CHR(3)) + ttAttribute.attrGroup.
   END. /* END FOR EACH ttAttribute */

   FOR EACH ttObject WHERE ttObject.ObjectClassCode = pcClass:
      ASSIGN ttObject.groupList = cGroupList.
   END.
END. /* End if pcType = Attribute */
ELSE IF pcType = "Event":U AND VALID-HANDLE(hUIEventBuffer) THEN
DO:
  /* Delete default values for Events for the specified class, having ObjectID = 0  */
   FIND FIRST ttEvent WHERE ttEvent.resultCode   = ""
                        AND ttEvent.ObjectID     = 0
                        AND ttEvent.objectClass  = pcClass
                        AND ttEvent.EventName    = pcAttribute NO-ERROR.

   IF AVAILABLE ttEvent THEN
      DELETE ttEvent.

   /* Create the UI events for the class */
   CREATE QUERY hQuery.                                                                                
   hQuery:SET-BUFFERS(hUIEventBuffer).                                                              
   hQUery:QUERY-PREPARE("FOR each " + hUIEventBuffer:NAME + " WHERE trecordIdentifier = '0' AND tClassName = '"  + pcClass + "'").                                         
   hQuery:QUERY-OPEN().                                                                                
   hQuery:GET-FIRST().                                                                                 
   DO WHILE hUIEventBuffer:AVAILABLE:                                                               
      CREATE ttEvent.                       
      ASSIGN ttEvent.objectID         = 0        
             ttEvent.resultCode       = ""       
             ttEvent.objectClass      = pcClass  
             ttEvent.EventName        = hUIEventBuffer:BUFFER-FIELD("tEventName"):BUFFER-VALUE 
             ttEvent.EventType        = hUIEventBuffer:BUFFER-FIELD("tActionType"):BUFFER-VALUE
             ttEvent.EventTarget      = hUIEventBuffer:BUFFER-FIELD("tActionTarget"):BUFFER-VALUE
             ttEvent.EventAction      = hUIEventBuffer:BUFFER-FIELD("tEventAction"):BUFFER-VALUE
             ttEvent.EventParameter   = hUIEventBuffer:BUFFER-FIELD("tEventParameter"):BUFFER-VALUE
             ttEvent.eventDisabled    = hUIEventBuffer:BUFFER-FIELD("tEventDisabled"):BUFFER-VALUE     
             ttEvent.defaultType      = ttEvent.EventType
             ttEvent.defaultTarget    = ttEvent.EventTarget
             ttEvent.defaultParameter = ttEvent.EventParameter
             ttEvent.defaultDisabled  = ttEvent.EventDisabled
             NO-ERROR.
      hQuery:GET-NEXT().                                                                               
   END.                                                                                                
   DELETE OBJECT hQuery.      

   /* Copy Events for this object */
   FOR EACH ttEvent WHERE ttEvent.objectClass = pcClass
                      AND ttEvent.ObjectID    = 0
                      AND ttEvent.EventName   = pcAttribute:

     FOR EACH BUFttEvent WHERE BUFttEvent.objectClass = pcClass
                               AND BUFttEvent.ObjectID   > 0
                               AND BUFttEvent.eventName   = pcAttribute:
        ASSIGN ttEvent.defaultType      = ttEvent.EventType
               ttEvent.defaultTarget    = ttEvent.EventTarget
               ttEvent.defaultParameter = ttEvent.EventParameter
               ttEvent.defaultDisabled  = ttEvent.EventDisabled.
     END.
     IF pcMode = "ADD":U 
        AND NOT CAN-FIND(FIRST BUFttEvent 
                         WHERE BUFttEvent.objectClass = pcClass
                           AND BUFttEvent.ObjectID   > 0
                           AND BUFttEvent.eventName   = pcAttribute ) THEN
       FOR EACH ttObject :
           /* Add all events for each possible result code */
          DO iLoop = 1 TO NUM-ENTRIES(ttObject.resultCodes):
            ASSIGN cResultCode = TRIM(ENTRY(iLoop,ttObject.resultCodes))
                   cResultCode = IF cResultCode = "{&DEFAULT-RESULT-CODE}":U
                                   OR cResultCode = "{&NO-RESULT-CODE}":U
                                 THEN ""
                                 ELSE cResultCode. 
            CREATE BUFttEvent.
            BUFFER-COPY ttEvent TO  BUFttEvent
                 ASSIGN BUFttEvent.objectID      = ttObject.objectID
                        BUFttEvent.callingProc   = ttObject.CallingProc
                        BUFttEvent.containerName = ttObject.ContainerName
                        BUFttEvent.objectName    = ttObject.ObjectName
                        BUFttEvent.resultCode    = cResultCode
                        NO-ERROR.

          END. /* END DO iLoop */
       END.
  END.
END.
 /* Refresh the DPS */
RUN displayProperties IN THIS-PROCEDURE  (?,?,?,?,?,?). 
  

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-refreshResultCodes) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE refreshResultCodes Procedure 
PROCEDURE refreshResultCodes :
/*------------------------------------------------------------------------------
  Purpose:     Refreshes the result codes
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-registerObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE registerObject Procedure 
PROCEDURE registerObject :
/*------------------------------------------------------------------------------
  Purpose:    Registers an object in the ttObject and ttAttribute
              temp tables. Also creates all default attributes for a 
              specified class, if not previously created. 
  Parameters: phCallingProc      Handle of calling procedure
              pcContainerName    Name of container or master object (Required)
              pcContainerLabel   Label of Container (Displays in prop sheet)
              pcObjectName       Name of Object that is being registered. If this is 
                                 a master object, specify the name as the containing object
              pcObjectLabel      Label of Object. (Is displayed in Object combo-box)                  
              pcObjectClassCode  Object type code of registered object (i.e. DYNFILLIN)
              pcObjectClassList  Comma delimtied list of supported classes
              pcObjectlevel      "MASTER"  The object being registered is a master object such
                                 as a DynViewer or DynBrowser.
                                 "INSTANCE" The  object being registered is an instance such
                                 as a DataField in a DynViewer, A Smarttoolbar in a container, etc..
              pcAttributeList    CHR(3) delimited list of attribute, result code and
                                 value
              pcEventList        CHR(3) delimited list of Label, ResultCode, EventAction   
                                       EventType. EventTarget, EventParam. EventDisabled 
              pcAttributeDefault CHR(s) delimited List of Attributes defaults  
                                 and their values of the Master object in the format:
                                    attribute |  result code | value
              pcEventDefault     CHR(3) delimited list of default values for events. Same 
                                 list as pcEventList                      
              pcResultCodeList   Comma delimited list of Result Codes that apply to this object
                                                    
  Notes:      The calling procedure would need to register the master object, 
              and if the master object has child containing objects, each one of those 
              objects would also have to be registered. 
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER phCallingProc        AS HANDLE     NO-UNDO.
DEFINE INPUT  PARAMETER pcContainerName      AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER pcContainerLabel     AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER pcObjectName         AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER pcObjectLabel        AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER pcObjectClassCode    AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER pcObjectClassList    AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER pcObjectLevel        AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER pcAttributeList      AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER pcEventList          AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER pcAttributeDefault   AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER pcEventDefault       AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER pcResultCodeList     AS CHARACTER  NO-UNDO.


DEFINE VARIABLE iLoop           AS INTEGER    NO-UNDO.
DEFINE VARIABLE cPropertyList   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cLabel          AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cValue          AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cResultCode     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cGroupList      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cEventAction    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cEventType      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cEventTarget    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cEventParam     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cEventDisabled  AS CHARACTER  NO-UNDO.     
DEFINE VARIABLE lEventDisabled  AS LOGICAL    NO-UNDO.

DEFINE BUFFER BUFttAttribute FOR  ttAttribute.
DEFINE BUFFER BUFttEvent     FOR  ttEvent.


/* Check that the object has not already been registered */
IF CAN-FIND(FIRST ttObject WHERE ttObject.callingProc   = phCallingProc
                             AND ttObject.containerName = pcContainerName
                             AND ttObject.objectName    = pcObjectName) THEN
DO:
   MESSAGE SUBSTITUTE("The object name '&1' has already been registered for container '&2' .",pcObjectName,pcContainerName) SKIP
           "Please specify a unique name."
      VIEW-AS ALERT-BOX INFO BUTTONS OK.
   RETURN.
END.

/* If the objectclasscode is blank, the system would retrieve every class in the 
   repository. Restrict this. */
IF pcObjectClassCode = "" THEN  RETURN.

/* If no result code is set, assume the default */

IF pcResultCodeList = "" OR pcResultCodeList = ? OR pcResultCodeList = "?":U THEN
     pcResultCodeList = "{&DEFAULT-RESULT-CODE}":U.

/* Cache all attributes per object class once in the ttAttribute table. Upon registering
   an object, the cached attributes will be copied to the specified object */
IF NOT CAN-FIND(FIRST ttAttribute WHERE ttAttribute.objectClass = pcObjectClassCode ) THEN 
   RUN cacheProperties IN THIS-PROCEDURE (INPUT pcObjectClassCode).

/* If the object hasn't yet been registered, create the object in temp table ttObject */
CREATE ttObject.
ASSIGN ttObject.objectID         = getNextID()
       ttObject.callingProc      = phCallingProc
       ttObject.containerName    = pcContainerName
       ttObject.containerLabel   = IF pcContainerLabel = "" THEN  pcContainerName ELSE pcContainerLabel
       ttObject.objectName       = pcObjectName
       ttObject.objectLabel      = IF pcObjectLabel = "" THEN pcObjectName ELSE pcObjectLabel
       ttObject.objectClassCode  = pcObjectClassCode
       ttObject.classList        = IF pcObjectClassList = "" THEN pcObjectClassCode ELSE pcObjectClassList
       ttObject.ResultCodes      = pcResultCodeList
       ttObject.IsDeleted        = NO
       ttObject.ObjectLevel      = pcObjectLevel
       NO-ERROR.
  
/* Copy attributes of the objects' class for this object*/
FOR EACH ttAttribute WHERE ttAttribute.objectClass = pcObjectClassCode
                       AND ttAttribute.ObjectID    = 0:
   /* Add all attributes for each possible result code */
  DO iLoop = 1 TO NUM-ENTRIES(pcResultCodeList):
    ASSIGN cResultCode = TRIM(ENTRY(iLoop,pcResultCodeList))
           cResultCode = IF cResultCode = "{&DEFAULT-RESULT-CODE}":U
                           OR cResultCode = "{&NO-RESULT-CODE}":U
                         THEN ""
                         ELSE cResultCode. 
    CREATE BUFttAttribute.
    BUFFER-COPY ttAttribute TO  BUFttAttribute
         ASSIGN BUFttAttribute.objectID     = ttObject.objectID
                BUFttAttribute.callingProc  = phCallingProc
                BUFttAttribute.containerName = pcContainerName
                BUFttAttribute.objectName    = pcObjectName
                BUFttAttribute.resultCode    = cResultCode
                .
    CASE pcObjectLevel:
       WHEN "MASTER":U THEN
          IF ttAttribute.constantLevel = "CLASS":U THEN
             BUFttAttribute.isDisabled = TRUE.
       WHEN "INSTANCE":U THEN
          IF ttAttribute.constantLevel = "CLASS":U 
               OR ttAttribute.constantLevel = "MASTER":U   THEN
             BUFttAttribute.isDisabled = TRUE.

    END CASE.


  END. /* END DO iLoop */
  /* Get the attribute group, create a string of all groups associates with this object 
     and assign it to the temp table */
  IF ttAttribute.attrGroup > "" AND LOOKUP(ttAttribute.attrGroup,cGroupList,CHR(3)) = 0 THEN
       cGroupList = cGroupList + (IF cGroupList = "" THEN "" ELSE CHR(3)) + ttAttribute.attrGroup.
END. /* END FOR EACH ttAttribute */
ASSIGN ttObject.groupList = cGroupList.

/* Copy Events for this object */
FOR EACH ttEvent WHERE ttEvent.objectClass = pcObjectClassCode
                   AND ttEvent.ObjectID    = 0:
   /* Add all attributes for each possible result code */
  DO iLoop = 1 TO NUM-ENTRIES(pcResultCodeList):
    ASSIGN cResultCode = TRIM(ENTRY(iLoop,pcResultCodeList))
           cResultCode = IF cResultCode = "{&DEFAULT-RESULT-CODE}":U
                           OR cResultCode = "{&NO-RESULT-CODE}":U
                         THEN ""
                         ELSE cResultCode. 
    CREATE BUFttEvent.
    BUFFER-COPY ttEvent TO  BUFttEvent
         ASSIGN BUFttEvent.objectID      = ttObject.objectID
                BUFttEvent.callingProc   = phCallingProc
                BUFttEvent.containerName = pcContainerName
                BUFttEvent.objectName    = pcObjectName
                BUFttEvent.resultCode    = cResultCode
                NO-ERROR.

  END. /* END DO iLoop */
END. /* END FOR EACH ttAttribute */

/* Set the attribute default values for the specified object */
DO iLoop = 1 TO NUM-ENTRIES(pcAttributeDefault,CHR(3)) BY 3:
   ASSIGN  cLabel      = TRIM(ENTRY(iLoop,pcAttributeDefault,CHR(3)))
           cResultCode = TRIM(ENTRY(iLoop + 1,pcAttributeDefault,CHR(3)))
           cValue      = TRIM(ENTRY(iLoop + 2,pcAttributeDefault,CHR(3)))
           NO-ERROR.
   FIND ttAttribute WHERE ttAttribute.ObjectID    = ttObject.objectID
                    AND ttAttribute.resultCode  = cResultCode
                    AND ttAttribute.attrLabel   = cLabel NO-ERROR.

   IF AVAILABLE(ttAttribute) THEN
      ASSIGN ttAttribute.defaultValue    = cValue
             ttAttribute.setValue        = cValue.
  

END.

/* Set the event default values for the registered object */
DO iLoop = 1 TO NUM-ENTRIES(pcEventDefault,CHR(3)) BY 7:
   ASSIGN cLabel         = ENTRY(iLoop,pcEventDefault,CHR(3))
          cResultCode    = ENTRY(iLoop + 1,pcEventDefault,CHR(3))
          cEventAction   = ENTRY(iLoop + 2,pcEventDefault,CHR(3))
          cEventType     = ENTRY(iLoop + 3,pcEventDefault,CHR(3))
          cEventTarget   = ENTRY(iLoop + 4,pcEventDefault,CHR(3))
          cEventParam    = ENTRY(iLoop + 5,pcEventDefault,CHR(3))
          cEventDisabled = ENTRY(iLoop + 6,pcEventDefault,CHR(3))
          NO-ERROR.
 

   FIND ttEvent WHERE ttEvent.ObjectID      = ttObject.ObjectID
                  AND ttEvent.resultCode    = cResultCode
                  AND ttEvent.eventName     = cLabel NO-ERROR.

 
   IF AVAILABLE(ttEvent) THEN
       ASSIGN ttEvent.defaultAction     = cEventAction
              ttEvent.eventAction       = cEventAction
              ttEvent.defaultType       = cEventType
              ttEvent.eventType         = cEventType
              ttEvent.defaultTarget     = cEventTarget
              ttEvent.eventTarget       = cEventTarget
              ttEvent.defaultParameter  = cEventParam
              ttEvent.eventParameter    = cEventParam
              ttEvent.defaultDisabled   = IF cEventDisabled = "yes":U OR cEventDisabled = "true":U
                                          THEN TRUE
                                          ELSE FALSE
              ttEvent.eventDisabled     = ttEvent.defaultDisabled
              NO-ERROR.

END.

/* Set the attribute values  */
DO iLoop = 1 TO NUM-ENTRIES(pcAttributeList,CHR(3)) BY 3:
  ASSIGN  cLabel      = TRIM(ENTRY(iLoop,pcAttributeList,CHR(3)))
          cResultCode = TRIM(ENTRY(iLoop + 1,pcAttributeList,CHR(3)))
          cValue      = TRIM(ENTRY(iLoop + 2,pcAttributeList,CHR(3)))
          NO-ERROR.
  IF cResultCode > "" THEN  /* Skip custom assignments for now */
     NEXT.
  FIND ttAttribute WHERE ttAttribute.ObjectID    = ttObject.objectID
                     AND ttAttribute.resultCode  = cResultCode
                     AND ttAttribute.attrLabel   = cLabel NO-ERROR.

  IF AVAILABLE(ttAttribute) THEN 
      ASSIGN ttAttribute.setValue    = cValue
             ttAttribute.RowOverride = TRUE.
  /* Since the value being set is for the master or default result code, assign the
     default value for the non-default result codes equal to this value */
  FOR EACH ttAttribute WHERE ttAttribute.ObjectID    = ttObject.objectID
                         AND ttAttribute.resultCode  > ""   
                         AND ttAttribute.attrLabel   = cLabel:
       ASSIGN ttAttribute.defaultValue = cValue
              ttAttribute.setValue     = IF ttAttribute.RowOverride <> TRUE 
                                         THEN cValue ELSE ttAttribute.setValue .
    END.
  
END. /* END set the attribute values */
DO iLoop = 1 TO NUM-ENTRIES(pcAttributeList,CHR(3)) BY 3:
  ASSIGN  cLabel      = TRIM(ENTRY(iLoop,pcAttributeList,CHR(3)))
          cResultCode = TRIM(ENTRY(iLoop + 1,pcAttributeList,CHR(3)))
          cValue      = TRIM(ENTRY(iLoop + 2,pcAttributeList,CHR(3)))
          NO-ERROR.
  IF cResultCode = "" THEN  /* Skip default assignmenets */
     NEXT.
  FIND ttAttribute WHERE ttAttribute.ObjectID    = ttObject.objectID
                     AND ttAttribute.resultCode  = cResultCode
                     AND ttAttribute.attrLabel   = cLabel NO-ERROR.

  IF AVAILABLE(ttAttribute) THEN DO:
      ASSIGN ttAttribute.setValue    = cValue
             ttAttribute.RowOverride = TRUE.
  END.
      
END. /* END set the attribute values */


 /* Set the event values  */
DO iLoop = 1 TO NUM-ENTRIES(pcEventList,CHR(3)) BY 7:
  ASSIGN cLabel         = ENTRY(iLoop,pcEventList,CHR(3))
         cResultCode    = ENTRY(iLoop + 1,pcEventList,CHR(3))
         cEventAction   = ENTRY(iLoop + 2,pcEventList,CHR(3))
         cEventType     = ENTRY(iLoop + 3,pcEventList,CHR(3))
         cEventTarget   = ENTRY(iLoop + 4,pcEventList,CHR(3))
         cEventParam    = ENTRY(iLoop + 5,pcEventList,CHR(3))
         cEventDisabled = ENTRY(iLoop + 6,pcEventList,CHR(3))
         lEventDisabled = IF cEventDisabled = "yes":U OR cEventDisabled = "true":U
                          THEN TRUE
                          ELSE FALSE
         NO-ERROR.
 
  FIND ttEvent WHERE ttEvent.ObjectID      = ttObject.ObjectID
                 AND ttEvent.resultCode    = cResultCode
                 AND ttEvent.eventName     = cLabel NO-ERROR.

  IF AVAILABLE(ttEvent) THEN
      ASSIGN ttEvent.eventAction     = cEventAction
             ttEvent.eventType       = cEventType
             ttEvent.eventTarget     = cEventTarget
             ttEvent.eventParameter  = cEventParam
             ttEvent.eventDisabled   = IF cEventDisabled = "yes":U OR cEventDisabled = "true":U
                                       THEN TRUE
                                       ELSE FALSE
             ttEvent.RowOverride = TRUE
             NO-ERROR.
 
  /* If the value being set is for the master or default result code, assign the
     default value for the non-default result codes equal to this value */
  IF cResultCode = "" THEN
    FOR EACH ttEvent WHERE ttEvent.ObjectID    = ttObject.objectID
                       AND ttEvent.resultCode  > ""
                       AND ttEvent.eventName   = cLabel:

      ASSIGN ttEvent.defaultAction    = cEventAction
             ttEvent.defaultType      = cEventType
             ttEvent.defaultTarget    = cEventTarget
             ttEvent.defaultParameter = cEventParam
             ttEvent.defaultDisabled  = lEventDisabled
             ttEvent.eventAction    = IF ttEvent.RowOverride <> TRUE THEN cEventAction ELSE ttEvent.eventAction
             ttEvent.eventType      = IF ttEvent.RowOverride <> TRUE THEN cEventType   ELSE ttEvent.eventType
             ttEvent.eventTarget    = IF ttEvent.RowOverride <> TRUE THEN cEventTarget ELSE ttEvent.eventAction
             ttEvent.eventParameter = IF ttEvent.RowOverride <> TRUE THEN cEventParam  ELSE ttEvent.eventParameter
             ttEvent.eventDisabled  = IF ttEvent.RowOverride <> TRUE THEN lEventDisabled ELSE ttEvent.eventDisabled
             NO-ERROR.
    END.


END.   /* END Set the event values (iLoop = 1 to ..*/



END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-unDeleteObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE unDeleteObject Procedure 
PROCEDURE unDeleteObject :
/*------------------------------------------------------------------------------
  Purpose:    Sets the Delete status of an object to No. 
  Parameters: phCallingProc     Handle of calling procedure
              pcContainerName   Name of container or master object (Required)
              pcObjectName      Name of Object that is being deleted. 
              
  Notes:      The calling procedure would need to register the master object, 
              and if the master object has child containing objects, each one of those 
              objects would also have to be registered. 
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER phCallingProc        AS HANDLE  NO-UNDO.
DEFINE INPUT  PARAMETER pcContainerName      AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER pcOldObjectLabel     AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER pcNewObjectName      AS CHARACTER  NO-UNDO.


FIND FIRST ttObject WHERE ttObject.callingProc  = phCallingProc
                     AND ttObject.containerName = pcContainerName
                     AND ttObject.objectLabel   = pcOldObjectLabel
                     AND ttObject.isDeleted     = YES NO-ERROR.

IF AVAILABLE(ttObject) THEN
DO:
   ASSIGN ttObject.isDeleted = NO.
   RUN changeObjectName IN THIS-PROCEDURE
         (INPUT phCallingProc,
          INPUT pcContainerName,
          INPUT ttObject.ObjectName,
          INPUT pcNewObjectName).
END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-unregisterObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE unregisterObject Procedure 
PROCEDURE unregisterObject :
/*------------------------------------------------------------------------------
  Purpose:    Un-registers an object from the ttObject, ttAttribute and
              ttEvent temp tables. 
  Parameters: phCallingProc     Handle of calling procedure
              pcContainerName   Name of container or master object (Required)
              pcObjectName      Name of Object that is being un registered. 
              
  Notes:      The calling procedure would need to register the master object, 
              and if the master object has child containing objects, each one of those 
              objects would also have to be registered. 
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER phCallingProc        AS HANDLE  NO-UNDO.
DEFINE INPUT  PARAMETER pcContainerName      AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER pcObjectName         AS CHARACTER  NO-UNDO.

IF pcObjectName = "*" THEN
DO:
  FOR EACH ttObject WHERE ttObject.callingProc   = phCallingProc
                     AND ttObject.containerName = pcContainerName:

    FOR EACH ttAttribute WHERE ttAttribute.ObjectID = ttObject.ObjectID:
       DELETE ttAttribute.
    END.

    FOR EACH ttEvent WHERE ttEvent.ObjectID = ttObject.ObjectID:
       DELETE ttEvent.
    END.

    DELETE ttObject.
  END.
END.
ELSE
DO:
  FOR EACH ttObject WHERE ttObject.callingProc   = phCallingProc
                      AND ttObject.containerName = pcContainerName
                      AND ttObject.objectName    = pcObjectName:

     FOR EACH ttAttribute WHERE ttAttribute.ObjectID = ttObject.ObjectID:
        DELETE ttAttribute.
     END.

     FOR EACH ttEvent WHERE ttEvent.ObjectID = ttObject.ObjectID:
        DELETE ttEvent.
     END.

     DELETE ttObject.
  END.
END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-extractProperty) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION extractProperty Procedure 
FUNCTION extractProperty RETURNS CHARACTER
  ( pcPropertyList AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose:  Returns only the attribute labels
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cPropList AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE i AS INTEGER    NO-UNDO.


  DO i = 1 TO NUM-ENTRIES(pcPropertyList,CHR(3)):
    cPropList = cPropList + (IF cPropList = "" THEN "" ELSE CHR(3)) + ENTRY(1,ENTRY(i,pcPropertyList,chr(3)),CHR(4)).
  END.
  
  RETURN cPropList.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getAttributeFirst) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getAttributeFirst Procedure 
FUNCTION getAttributeFirst RETURNS CHARACTER
  ( phProc AS HANDLE ) :
/*------------------------------------------------------------------------------
  Purpose:   Returns a list of attributes that have been set using the 
             setAttributeFirst function
    Notes:  
------------------------------------------------------------------------------*/
DEFINE VARIABLE iPos AS INTEGER   NO-UNDO.

iPos = LOOKUP(STRING(phProc),gcAttributeFirst,CHR(3)).
IF iPos > 0 THEN
    RETURN ENTRY(iPos + 1,gcAttributeFirst,CHR(3)).
ELSE
     RETURN "".

  RETURN "".   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getBuffer) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getBuffer Procedure 
FUNCTION getBuffer RETURNS HANDLE
  ( pcTable AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the buffer handle of the specified temp table
    Notes:  
------------------------------------------------------------------------------*/
 
/* Set handles to the temp table buffers */
 CASE pcTable:
   WHEN "ttSelectedAttribute":U THEN
       RETURN  BUFFER ttSelectedAttribute:HANDLE.
   WHEN "ttAttribute":U THEN
       RETURN  BUFFER ttAttribute:HANDLE.
   WHEN "ttObject":U THEN
       RETURN  BUFFER ttObject:HANDLE.
   WHEN "ttEvent":U THEN
       RETURN  BUFFER ttEvent:HANDLE.
   WHEN "ttSelectedEvent":U THEN
       RETURN  BUFFER ttSelectedEvent:HANDLE.
   

 END CASE.
 
 
 

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getClassList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getClassList Procedure 
FUNCTION getClassList RETURNS CHARACTER
( INPUT  phCallingProc AS HANDLE,
  INPUT  pcContainerName AS CHAR, 
  INPUT  pcObject        AS CHAR,
  OUTPUT pcClassList AS CHAR) :
/*------------------------------------------------------------------------------
    Purpose: Returns the class for a specified object. Also outputs a delimited 
             list of class Names
 Parameters: phCallingProc   Handle of calling procedure
             pcContainerName Name of container for registered objects
             pcObjectName
     OUTPUT  pcClassList  (Comma delimited list of classes)        
     RETURNS cObjectClass Name of class for specified object
     Notes:   
------------------------------------------------------------------------------*/
 FIND FIRST ttObject WHERE ttObject.callingProc   = phCallingProc 
                       AND ttObject.containerName = pcContainerName 
                       AND ttObject.ObjectName    = pcObject NO-ERROR.
 
 IF AVAILABLE ttObject THEN DO:
    ASSIGN pcClassList = ttObject.ClassList.
    RETURN ttObject.objectClassCode.
 END.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getGroupList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getGroupList Procedure 
FUNCTION getGroupList RETURNS CHARACTER
  ( phCallingProc    AS HANDLE,
    pcContainerName  AS CHAR,
    pcObjectNameList AS CHAR):
/*------------------------------------------------------------------------------
    Purpose: Returns the list-item value for the specified container and window handle 
             corresponding to the Object combo-box in the property sheet. Also
             outputs a delimited list of object Names
 Parameters: phCallingProc   Handle of calling procedure
             pcContainerName Name of container for registered objects
             pcObjectNameList chr(3) delimtied list of objects
     RETURNS cgroupList     CHR(3) delimtied list of groups
     Notes:   Returned string is in the form 'ObjectName' + "(ClassName) + chr(3) + ...
            i.e.  CustNum (DynFillIn)  
------------------------------------------------------------------------------*/
 DEFINE VARIABLE cGroupList AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE iCount     AS INTEGER    NO-UNDO.
 DEFINE VARIABLE cObjectName AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE iLoop       AS INTEGER    NO-UNDO.
 
 DO iLoop = 1 TO NUM-ENTRIES(pcObjectNameList,CHR(3)):
   cObjectName = ENTRY(iLoop,pcObjectNameList,CHR(3)).
   FOR EACH ttObject WHERE ttObject.callingProc  = phCallingProc 
                       AND ttObject.containerName = pcContainerName 
                       AND ttObject.ObjectName    = cObjectName 
                       AND ttObject.IsDeleted     = NO:
      IF cGroupList = "" THEN
         cGroupList = ttObject.GroupList.
      ELSE
      DO iCount = 1 TO NUM-ENTRIES(ttObject.GroupList,CHR(3)):
         IF LOOKUP(ENTRY(icount,ttObject.GroupList,CHR(3)),cGroupList,CHR(3)) = 0 THEN
            cGroupList = cGroupList + CHR(3) + ENTRY(icount,ttObject.GroupList,CHR(3)).
      END.
   END.
 END.
 
 RETURN cGroupList.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getNextID) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getNextID Procedure 
FUNCTION getNextID RETURNS INTEGER
  ( ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns a unique objectID for use in the ttObject temp table
    Notes:  
------------------------------------------------------------------------------*/
  giObjectID = giObjectID + 1.
  RETURN giObjectID.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getObjectList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getObjectList Procedure 
FUNCTION getObjectList RETURNS CHARACTER
  ( phCallingProc AS HANDLE,
    pcContainerName AS CHAR,
    OUTPUT pcObjectLabels AS CHAR) :
/*------------------------------------------------------------------------------
    Purpose: Returns the list-item value for the specified container and window 
             handle corresponding to the Object combo-box in the property sheet. 
             Also outputs a delimited list of object Names
 Parameters: phCallingProc   Handle of calling procedure
             pcContainerName Name of container for registered objects
     RETURNS cObjectName     Comma delimtied list of object names
     Notes:   Returned string is in the form 'ObjectName' + "(ClassName) + chr(3) + ...
            i.e.  CustNum (DynFillIn)  
------------------------------------------------------------------------------*/
 DEFINE VARIABLE cObjectNames   AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cLabel         AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE iSuffix        AS INTEGER    NO-UNDO.
 DEFINE VARIABLE iLastSuffix    AS INTEGER    NO-UNDO.
 DEFINE VARIABLE iEntry         AS INTEGER    NO-UNDO.
 DEFINE VARIABLE cEntryLabel    AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE iDashPos       AS INTEGER    NO-UNDO.

 DEFINE BUFFER BUFObject FOR ttObject.
 
 ASSIGN pcObjectLabels = "".
 FOR EACH ttObject WHERE ttObject.callingProc   = phCallingProc 
                     AND ttObject.containerName = pcContainerName 
                     AND ttObject.Isdeleted     = NO 
                  BY ttObject.ObjectID :
    ASSIGN cObjectNames   = cObjectNames + (IF cObjectNames = "" THEN "" ELSE CHR(3)) 
                                        +  ttObject.objectName
           cLabel         = ttObject.ObjectLabel.

    /* If Object Label is not unique, append an integer to each label */
    IF CAN-FIND(FIRST BufObject 
                WHERE BufObject.callingProc   = phCallingProc 
                 AND BufObject.containerName = pcContainerName 
                 AND BufObject.ObjectName   <> ttObject.ObjectName
                 AND BufObject.ObjectLabel   = ttObject.ObjectLabel
                 AND BufObject.isDeleted     = FALSE)
    THEN DO:
       ASSIGN iSuffix = 1.
       DO iEntry = 1 TO NUM-ENTRIES(pcObjectLabels,CHR(3)):
          ASSIGN cEntryLabel   = ENTRY(iEntry,pcObjectLabels,CHR(3))
                 iDashPos      = R-INDEX(cEntryLabel,"-":U).
          IF iDashPos > 1 AND SUBSTRING(cLabel,1,iDashpos - 1 ) = cLabel THEN
          DO:
             ASSIGN ilastSuffix  = INTEGER(SUBSTRING(cEntryLabel,iDashpos + 1)) NO-ERROR.
             IF iLastSuffix > 0 THEN
                ASSIGN iSuffix = MAX(iLastSuffix + 1,iSuffix).
          END.
       END.
       ASSIGN cLabel = cLabel + "-":U + STRING(iSuffix).
    END.

    ASSIGN  pcObjectLabels = pcObjectLabels + (IF pcObjectLabels = "" THEN "" ELSE CHR(3)) 
                           +  cLabel.
 END.
 
 RETURN cObjectNames.   

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getPropSheet) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getPropSheet Procedure 
FUNCTION getPropSheet RETURNS HANDLE
  (  ) :
/*------------------------------------------------------------------------------
  Purpose: returns the handle of the property sheet 
    Notes:  
------------------------------------------------------------------------------*/
  
  RETURN ghPropSheet.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getRepostionQuery) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getRepostionQuery Procedure 
FUNCTION getRepostionQuery RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lRepositionQuery AS LOGICAL    NO-UNDO.
  IF VALID-HANDLE(ghPropSheet) THEN
     lRepositionQuery =  DYNAMIC-FUNCTION("getRepositionQuery":U IN ghPropSheet).
  ELSE
     lRepositionQuery =  ?.
  RETURN lRepositionQuery.   /* Function return value. */
  

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getResultCodeList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getResultCodeList Procedure 
FUNCTION getResultCodeList RETURNS CHARACTER
  ( INPUT  phCallingProc AS HANDLE,
    INPUT  pcContainerName AS CHAR, 
    INPUT  pcObject        AS CHAR):
  
/*------------------------------------------------------------------------------
    Purpose: Returns the class for a specified object. Also outputs a delimited 
             list of class Names
 Parameters: phCallingProc   Handle of calling procedure
             pcContainerName Name of container for registered objects
             pcObject
    RETURNS  List of result codes for specified object
     Notes:   
------------------------------------------------------------------------------*/
 FIND FIRST ttObject WHERE ttObject.callingProc   = phCallingProc 
                       AND ttObject.containerName = pcContainerName 
                       AND ttObject.ObjectName    = pcObject NO-ERROR.
 
 IF AVAILABLE ttObject THEN DO:
    RETURN ttObject.ResultCodes.
 END.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setAttributeFirst) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setAttributeFirst Procedure 
FUNCTION setAttributeFirst RETURNS LOGICAL
  ( phProc      AS HANDLE,
    pcAttribute AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  Encases the attribute name in parenthesis so that it is displayed
            first in the list of attributes.
    Notes:  
------------------------------------------------------------------------------*/
DEFINE VARIABLE iLoop   AS INTEGER    NO-UNDO.
DEFINE VARIABLE iPos    AS INTEGER    NO-UNDO.
DEFINE VARIABLE iPos2   AS INTEGER    NO-UNDO.
DEFINE VARIABLE cString AS CHARACTER  NO-UNDO.
  


IF gcAttributeFirst = "" THEN
   gcAttributeFirst = STRING(phProc) + CHR(3) + pcAttribute.
ELSE DO:
  iPos = LOOKUP(STRING(phProc),gcAttributeFirst,CHR(3)).
  IF iPos = 0 THEN
     gcAttributeFirst = gcAttributeFirst + CHR(3) + STRING(phProc) 
                              +  CHR(3) + pcAttribute.
  DO:
   ASSIGN cString = ENTRY(iPos + 1,gcAttributeFirst,CHR(3)).
          iPos2   = LOOKUP(cString,pcAttribute,CHR(2)).
   IF iPos2 = 0 THEN
      cString = cString + CHR(2) + pcAttribute.
   
   ENTRY(iPos + 1,gcAttributeFirst,CHR(3)) = cString.

     
  END.
END.
RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setPropSheet) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setPropSheet Procedure 
FUNCTION setPropSheet RETURNS LOGICAL
  ( phPropertySheet AS HANDLE) :
/*------------------------------------------------------------------------------
  Purpose: Sets the Property Sheet to the global variable containing  
    Notes:  
------------------------------------------------------------------------------*/
  ASSIGN ghPropSheet = phPropertySheet.
  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setRepositionQuery) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setRepositionQuery Procedure 
FUNCTION setRepositionQuery RETURNS LOGICAL
  ( plRepositionQuery AS LOG ) :
/*------------------------------------------------------------------------------
  Purpose:  Wrapper for setRepositionQuery in Property sheet window
    Notes:  
------------------------------------------------------------------------------*/
  IF VALID-HANDLE(ghPropSheet) THEN
     DYNAMIC-FUNCTION("setRepositionQuery":U IN ghPropSheet,plRepositionQuery).

  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setResultCodeList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setResultCodeList Procedure 
FUNCTION setResultCodeList RETURNS LOGICAL
 (  INPUT  phCallingProc AS HANDLE,
    INPUT  pcContainerName AS CHAR, 
    INPUT  pcObject        AS CHAR,
    INPUT  pcResultCode    AS CHAR  ) :
/*------------------------------------------------------------------------------
  Purpose: Sets the result code for the specified object
   Params: phCallingProc   Handle of calling procedure
           pcContainerName Name of container for registered objects
           pcObject        Name of Object
           pcResultCOde    New ResultCode to be added
           
------------------------------------------------------------------------------*/
  FIND FIRST ttObject WHERE ttObject.callingProc  = phCallingProc 
                       AND ttObject.containerName = pcContainerName 
                       AND ttObject.ObjectName    = pcObject NO-ERROR.
 
 IF AVAILABLE ttObject THEN 
 DO:
   IF LOOKUP(pcResultCode,ttObject.ResultCodes) = 0 THEN
      ttObject.ResultCodes = ttObject.ResultCodes 
                             + (IF ttObject.ResultCodes = "" THEN "" ELSE ",") 
                             + pcResultCode.
                               
 END.
         

  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

