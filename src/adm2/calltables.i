&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Include 
/***********************************************************************
* Copyright (C) 2000,2007 by Progress Software Corporation. All rights *
* reserved. Prior versions of this work may contain portions           *
* contributed by participants of Possenet.                             *
*                                                                      *
***********************************************************************/
/*---------------------------------------------------------------------------------
  File: callparam.i

  Description:  Dynamic Call Parameter Temp-Tables

  Purpose:      This file contains definitions of the temp-tables that are supported for making
                calls using the Dynamic Call Wrapper.

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   03/29/2002  Author:     Bruce S Gruenbaum

  Update Notes: Created from Template ryteminclu.i

---------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* object identifying preprocessor */
&glob   AstraInclude    yes

&IF DEFINED(PARAM-TABLE-TYPE) = 0 &THEN
  &SCOPED-DEFINE PARAM-TABLE-TYPE 1
  &SCOPED-DEFINE PARAM-TABLE-TYPE-DEF THIS-FILE
&ENDIF

&IF DEFINED(PARAM-TABLE-NAME) = 0 &THEN
  &SCOPED-DEFINE PARAM-TABLE-NAME ttCallParam
  &SCOPED-DEFINE PARAM-TABLE-NAME-DEF THIS-FILE
&ENDIF

&IF {&PARAM-TABLE-TYPE} = 1 AND DEFINED(tableType1Defined) = 0 &THEN

  &GLOBAL-DEFINE tableType1Defined YES

  /* Position Native Datatype */
  DEFINE TEMP-TABLE {&PARAM-TABLE-NAME}{&PARAM-NAME-MODIFIER} NO-UNDO
    FIELD iParamNo       AS INTEGER
    FIELD cParamName     AS CHARACTER
    FIELD cDataType      AS CHARACTER
    FIELD cIOMode        AS CHARACTER
    FIELD cCharacter     AS CHARACTER
    FIELD tDate          AS DATE
    FIELD lLogical       AS LOGICAL
    FIELD iInteger       AS INTEGER
    FIELD dDecimal       AS DECIMAL
    FIELD hHandle        AS HANDLE
    FIELD dtDateTime     AS DATETIME
    FIELD dzDateTime     AS DATETIME-TZ
    FIELD rRowid         AS ROWID
    FIELD rRaw           AS RAW
    INDEX pudx IS UNIQUE PRIMARY
      iParamNo
    .
&ENDIF

&IF {&PARAM-TABLE-TYPE} = 2 AND DEFINED(tableType2Defined) = 0 &THEN

  &GLOBAL-DEFINE tableType2Defined YES
  
  /* Position Character */
  DEFINE TEMP-TABLE {&PARAM-TABLE-NAME}{&PARAM-NAME-MODIFIER} NO-UNDO
    FIELD iParamNo       AS INTEGER
    FIELD cParamName     AS CHARACTER
    FIELD cDataType      AS CHARACTER
    FIELD cIOMode        AS CHARACTER
    FIELD cValue         AS CHARACTER
    INDEX pudx IS UNIQUE PRIMARY
      iParamNo
    .
&ENDIF

&IF {&PARAM-TABLE-TYPE} = 3 AND DEFINED(tableType3Defined) = 0 &THEN

  &GLOBAL-DEFINE tableType3Defined YES
    
  /* Name Native Datatype */
  DEFINE TEMP-TABLE {&PARAM-TABLE-NAME}{&PARAM-NAME-MODIFIER} NO-UNDO
    FIELD cParamName     AS CHARACTER
    FIELD cCharacter     AS CHARACTER
    FIELD tDate          AS DATE
    FIELD lLogical       AS LOGICAL
    FIELD iInteger       AS INTEGER
    FIELD dDecimal       AS DECIMAL
    FIELD hHandle        AS HANDLE
    INDEX pudx IS UNIQUE PRIMARY
      cParamName
    .
&ENDIF

&IF {&PARAM-TABLE-TYPE} = 4 AND DEFINED(tableType4Defined) = 0 &THEN

  &GLOBAL-DEFINE tableType4Defined YES
    
  /* Name Character */
  DEFINE TEMP-TABLE {&PARAM-TABLE-NAME}{&PARAM-NAME-MODIFIER} NO-UNDO
    FIELD cParamName     AS CHARACTER
    FIELD cValue         AS CHARACTER
    INDEX pudx IS UNIQUE PRIMARY
      cParamName
    .
&ENDIF


&IF "{&PARAM-TABLE-TYPE-DEF}" = "THIS-FILE":U &THEN
  &UNDEFINE PARAM-TABLE-TYPE-DEF
  &UNDEFINE PARAM-TABLE-TYPE
&ENDIF
  
&IF "{&PARAM-TABLE-NAME-DEF}" = "THIS-FILE":U &THEN
  &UNDEFINE PARAM-TABLE-NAME-DEF
  &UNDEFINE PARAM-TABLE-NAME
&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Include
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: INCLUDE-ONLY
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Include ASSIGN
         HEIGHT             = 12.81
         WIDTH              = 40.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


