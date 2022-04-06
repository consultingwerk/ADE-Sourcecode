&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
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
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*---------------------------------------------------------------------------------
  File: afdynuser.p

  Description:  Dynamic User Library

  Purpose:      Provides dynamic user creation and passwords to generate authentication
                for AppServer connection where no user name has been established.

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   08/23/2001  Author:     Bruce Gruenbaum

  Update Notes: Created from Template rytemprocp.p

---------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       afdynuser.p
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000

/* Modify these seeds if you want to make this stuff user site specific */
&SCOPED-DEFINE PASSWORD-SEED  "MARYSZEKELY"
&SCOPED-DEFINE PASSWORD-CONST "JOHNSADD"

/* Astra object identifying preprocessor */
&glob   AstraProcedure    yes

{afglobals.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-createPassword) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD createPassword Procedure 
FUNCTION createPassword RETURNS CHARACTER
  (INPUT pcUserName AS CHARACTER) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-decodeUserName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD decodeUserName Procedure 
FUNCTION decodeUserName RETURNS LOGICAL
  ( INPUT pcUserName AS CHARACTER,
    OUTPUT pdDate AS DATE,
    OUTPUT piTime AS INTEGER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-generateUserName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD generateUserName Procedure 
FUNCTION generateUserName RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-intConvert) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD intConvert Procedure 
FUNCTION intConvert RETURNS CHARACTER
  ( INPUT pcString AS CHARACTER )  FORWARD.

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
         HEIGHT             = 18.81
         WIDTH              = 49.8.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-createPassword) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION createPassword Procedure 
FUNCTION createPassword RETURNS CHARACTER
  (INPUT pcUserName AS CHARACTER):
/*------------------------------------------------------------------------------
  Purpose: Creates a password based on a string. 
    Notes:  
------------------------------------------------------------------------------*/

  /* This code is deliberately not commented */

  DEFINE VARIABLE iTime      AS INTEGER    NO-UNDO.
  DEFINE VARIABLE daDate     AS DATE       NO-UNDO.
  DEFINE VARIABLE iCount     AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cChar      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSeed      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cConst     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cUserVal   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE dTotal     AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE cRetVal    AS CHARACTER  NO-UNDO.

  cSeed = intConvert({&PASSWORD-SEED}).
  cConst = intConvert(UPPER({&PASSWORD-CONST})).
  IF NOT decodeUserName(pcUserName, OUTPUT daDate, OUTPUT iTime) OR
     daDate = ? OR
     iTime = ? THEN
    RETURN ?.

  cUserVal = intConvert(pcUserName).
  IF daDate <> ? THEN
    dTotal = (DAY(daDate) * MONTH(daDate) * YEAR(daDate)).

  dTotal = dTotal + DECIMAL(cUserVal) + DECIMAL(cSeed) + DECIMAL(cConst).
  
  cSeed = STRING(dTotal).

  IF LENGTH(cSeed) > LENGTH(cConst) THEN
    cSeed = SUBSTRING(cSeed,1,LENGTH(cConst)).

  DO iCount = 1 TO LENGTH(cConst):
    cChar = SUBSTRING(cSeed,iCount,1).
    cChar = CHR(65 + (INTEGER(cChar) * INTEGER(SUBSTRING(cConst,iCount,1))) MODULO 10).
    cRetVal = cRetVal + cChar.
  END.
  
  RETURN ENCODE(cRetVal).
  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-decodeUserName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION decodeUserName Procedure 
FUNCTION decodeUserName RETURNS LOGICAL
  ( INPUT pcUserName AS CHARACTER,
    OUTPUT pdDate AS DATE,
    OUTPUT piTime AS INTEGER) :
/*------------------------------------------------------------------------------
  Purpose: Decodes a user name generated with generateUserName.  
    Notes:  
------------------------------------------------------------------------------*/

  /* This code is deliberately not commented */

  DEFINE VARIABLE cDateForm AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDate     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iDay      AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iMonth    AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iYear     AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cTime     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cConvStr  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iCount    AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iPos      AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cChar     AS CHARACTER  NO-UNDO.
    
  pcUserName = UPPER(pcUserName).
  cDateForm = SUBSTRING(pcUserName,1,3).

  DO iCount = 4 TO LENGTH(pcUserName):
    cChar = SUBSTRING(pcUserName,iCount,1).
    cConvStr = cConvStr + STRING(INTEGER(ASC(cChar) - 65)).
  END.
  
  cDate = SUBSTRING(cConvStr,1,8).
  cTime = SUBSTRING(cConvStr,9).
  piTime = INTEGER(cTime).
  iPos = 1.
  DO iCount = 1 TO 3:
    cChar = SUBSTRING(cDateForm,iCount,1).
    CASE cChar:
      WHEN "x":U THEN
        ASSIGN
          iDay = INTEGER(SUBSTRING(cDate, iPos, 2))
          iPos = iPos + 2
        .
      WHEN "y":U THEN
        ASSIGN
          iMonth = INTEGER(SUBSTRING(cDate, iPos, 2))
          iPos = iPos + 2
        .
      WHEN "z":U THEN
        ASSIGN
          iYear = INTEGER(SUBSTRING(cDate, iPos, 4))
          iPos = iPos + 4
        .
      OTHERWISE
      DO:
        ASSIGN
          pdDate = ?
          piTime = ?
        .
        RETURN FALSE.
      END.
    END.
  END.
  pdDate = DATE(iMonth, iDay, iYear).

  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-generateUserName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION generateUserName Procedure 
FUNCTION generateUserName RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  Generates a user name.
    Notes:  
------------------------------------------------------------------------------*/

  /* This code is deliberately not commented */

  DEFINE VARIABLE daDate     AS DATE       NO-UNDO.
  DEFINE VARIABLE cDate      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDateForm  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cTime      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cString    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cOutString AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iCount     AS INTEGER    NO-UNDO.

  daDate = TODAY.

  DO iCount = 1 TO LENGTH(SESSION:DATE-FORMAT):
    CASE SUBSTRING(SESSION:DATE-FORMAT,iCount,1):
      WHEN "D":U THEN
        ASSIGN
          cDate = cDate + STRING(DAY(daDate),"99":U)
          cDateForm = cDateForm + "x":U.
      WHEN "M":U THEN
        ASSIGN
          cDate = cDate + STRING(MONTH(daDate),"99":U)
          cDateForm = cDateForm + "y":U.
      WHEN "Y":U THEN
        ASSIGN
          cDate = cDate + STRING(YEAR(daDate),"9999":U)
          cDateForm = cDateForm + "z":U.
    END.
  END.
 
  cTime = STRING(TIME).
  cString = cDate + cTime.
  
  DO iCount = 1 TO LENGTH(cString):
    cOutString = cOutString + CHR(65 + INTEGER(SUBSTRING(cString,iCount,1))).
  END.
  
  RETURN LOWER(cDateForm + cOutString).

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-intConvert) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION intConvert Procedure 
FUNCTION intConvert RETURNS CHARACTER
  ( INPUT pcString AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Converts a character string into an integer string
    Notes:  
------------------------------------------------------------------------------*/
  
  /* This code is deliberately not commented */

  DEFINE VARIABLE iCount     AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iCalc      AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cRetVal    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cChar      AS CHARACTER  NO-UNDO.
  
  pcString = UPPER(pcString).
  
  DO iCount = 1 TO LENGTH(pcString):
    cChar = SUBSTRING(pcString,iCount,1).
    IF ASC(cChar) < 65 THEN
      iCalc = 65 - ASC(cChar).
    ELSE
      iCalc = ASC(cChar) - 65.
    IF iCalc > 9 THEN
      iCalc = iCalc MODULO 10.
    cRetVal = cRetVal + STRING(iCalc,"9":U).
  END.

  RETURN cRetVal.


END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

