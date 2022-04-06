&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Method-Library 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*-------------------------------------------------------------------------
    File        : caller.i
    Purpose     : Basic Method Library for the ADMClass caller.
  
    Syntax      : {src/adm2/caller.i}

    Description :
  
    Modified    : 04/17/2002
-------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* This variable is here for procedures that deal with the 64
   temp-table issue */
DEFINE VARIABLE ghTempTable AS HANDLE  EXTENT 64   NO-UNDO.

&IF "{&ADMClass}":U = "":U &THEN
  &GLOB ADMClass caller
&ENDIF

&IF "{&ADMClass}":U = "caller":U &THEN
  {src/adm2/callprop.i}
&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-getHandleParam) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getHandleParam Method-Library 
FUNCTION getHandleParam RETURNS HANDLE
  ( INPUT pcHandleType AS CHARACTER,
    INPUT piSubscript  AS INTEGER  ) FORWARD.

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
         HEIGHT             = 8
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB Method-Library 
/* ************************* Included-Libraries *********************** */

{src/adm2/smart.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Method-Library 


/* ***************************  Main Block  *************************** */

&IF DEFINED(ADM-EXCLUDE-STATIC) = 0 &THEN
  /* Starts super procedure */
  IF NOT {&ADM-LOAD-FROM-REPOSITORY} THEN
    RUN start-super-proc("adm2/caller.p":U).
  
  /* _ADM-CODE-BLOCK-START _CUSTOM _INCLUDED-LIB-CUSTOM CUSTOM */

  {src/adm2/custom/callercustom.i}

  /* _ADM-CODE-BLOCK-END */
  
&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-mapArrayToBuffer) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE mapArrayToBuffer Method-Library 
PROCEDURE mapArrayToBuffer :
/*------------------------------------------------------------------------------
  Purpose:     Scans the dynamic temp-table for T: or B: fields and substitutes
               the value of the handle with table handle or the buffer handle.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER phTable AS HANDLE     NO-UNDO.

  DEFINE VARIABLE hBuffer         AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hField          AS HANDLE     NO-UNDO.
  DEFINE VARIABLE iCount          AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cPrefix         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cProperty       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hRetVal         AS HANDLE     NO-UNDO.

  hBuffer = phTable:DEFAULT-BUFFER-HANDLE.

  /* If there are no records in the temp-table create one */
  IF NOT phTable:HAS-RECORDS THEN
    hBuffer:BUFFER-CREATE().
  ELSE
    hBuffer:FIND-FIRST().

  /* Loop through all the fields in the table */
  DO iCount = 1 TO hBuffer:NUM-FIELDS:
    hField = hBuffer:BUFFER-FIELD(iCount).
    
    /* If the label doesn't match the name we have a parameter to set */

    IF hField:LABEL <> hField:NAME 
    OR SUBSTRING(hField:LABEL,1,2) = "T:":U
    OR SUBSTRING(hField:LABEL,1,2) = "B:":U THEN
    DO:
      /* The first two characters are a prefix for the parameter type. */
      cPrefix = SUBSTRING(hField:LABEL,1,2).

      /* Parameter value */
      cProperty = SUBSTRING(hField:LABEL,3).

      /* Obtain the handle to the temp-table that is appropriate */
      hRetVal = ghTempTable[INTEGER(cProperty)].

      CASE cPrefix:
        WHEN "T:":U THEN
        DO:
          hField:BUFFER-VALUE = hRetVal.
        END.
        WHEN "B:":U THEN
        DO:
          IF VALID-HANDLE(hRetVal) THEN
            hField:BUFFER-VALUE = hRetVal:DEFAULT-BUFFER-HANDLE.
          ELSE
            hField:BUFFER-VALUE = ?.
        END.
      END CASE.
    END /* IF hField:LABEL <> hField:NAME */.
  END. /* DO iCount = 1 TO hBuffer:NUM-FIELDS */

  hBuffer:BUFFER-RELEASE().

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-mapBufferToArray) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE mapBufferToArray Method-Library 
PROCEDURE mapBufferToArray :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER phTable AS HANDLE     NO-UNDO.

  DEFINE VARIABLE hBuffer         AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hField          AS HANDLE     NO-UNDO.
  DEFINE VARIABLE iCount          AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cPrefix         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cProperty       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hRetVal         AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cMode           AS CHARACTER  NO-UNDO.

  hBuffer = phTable:DEFAULT-BUFFER-HANDLE.

  /* If there are no records in the temp-table create one */
  IF NOT phTable:HAS-RECORDS THEN
    RETURN.

  hBuffer:FIND-FIRST().

  /* Loop through all the fields in the table */
  DO iCount = 1 TO hBuffer:NUM-FIELDS:
    hField = hBuffer:BUFFER-FIELD(iCount).
    cMode  = ENTRY(2,hField:COLUMN-LABEL,"|":U).

    IF CAN-DO("INPUT-OUTPUT,OUTPUT,OUTPUT-APPEND":U, cMode) THEN

        /* If the label doesn't match the name we have a parameter to set */

        IF SUBSTRING(hField:LABEL,1,2) = "T:":U
        OR SUBSTRING(hField:LABEL,1,2) = "B:":U
        OR hField:NAME <> hField:LABEL THEN
    DO:
      /* The first two characters are a prefix for the parameter type. */
      cPrefix = SUBSTRING(hField:LABEL,1,2).

      /* Parameter value */
      cProperty = SUBSTRING(hField:LABEL,3).

      CASE cPrefix:
        WHEN "T:":U THEN
        DO:
          ghTempTable[INTEGER(cProperty)] = hField:BUFFER-VALUE.
        END.
        WHEN "B:":U THEN
        DO:
          hRetVal = hField:BUFFER-VALUE.
          IF VALID-HANDLE(hRetVal:TABLE-HANDLE) THEN
            ghTempTable[INTEGER(cProperty)] = hRetVal:TABLE-HANDLE.
        END.
      END CASE.
    END /* IF hField:LABEL <> hField:NAME */.
  END. /* DO iCount = 1 TO hBuffer:NUM-FIELDS */

  hBuffer:BUFFER-RELEASE().

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-getHandleParam) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getHandleParam Method-Library 
FUNCTION getHandleParam RETURNS HANDLE
  ( INPUT pcHandleType AS CHARACTER,
    INPUT piSubscript  AS INTEGER  ):
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  IF pcHandleType = "T":U THEN
    RETURN ghTempTable[piSubscript].
  ELSE IF VALID-HANDLE(ghTempTable[piSubscript]:DEFAULT-BUFFER-HANDLE) THEN
    RETURN ghTempTable[piSubscript]:DEFAULT-BUFFER-HANDLE.
  ELSE
    RETURN ?.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

