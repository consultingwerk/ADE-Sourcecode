&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*------------------------------------------------------------------------
    File        : viewlog.p
    Purpose     : Show current logs
    Author(s)   : Per S Digre (pdigre@progress.com)
    Updated     : 03/15/2001 pdigre@progress.com
                    Initial version
                  05/23/2001 (adams@progress.com)
                    WebSpeed integration
                  06/26/2001 (mbaker@progress.com)
                    WebSpeed standardization
    Notes       :
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

{ src/web/method/cgidefs.i }
{ webtools/plus.i }

DEFINE VARIABLE c1    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cID   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cLog  AS CHARACTER  NO-UNDO.

DEFINE STREAM s1.

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
         HEIGHT             = 15
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

fHeader().
{&OUT} 
  '<TEXTAREA NAME="log" WRAP="off" COLS="80" ROWS="20">~n'.

ASSIGN
  cLog = DYNAMIC-FUNCTION ("getLogFile" IN web-utilities-hdl) NO-ERROR.

IF SEARCH(cLog) > "" THEN DO:
  INPUT STREAM s1 FROM VALUE(cLog).
  REPEAT:
    IMPORT STREAM s1 UNFORMATTED c1.
    IF c1 = "" THEN
      {&OUT} SKIP(1).
    ELSE 
      {&OUT} c1 SKIP.
  END.
  INPUT STREAM s1 CLOSE.
END.
ELSE DO:
  IF DYNAMIC-FUNCTION ("getSessionId" IN web-utilities-hdl) = "" THEN
    {&OUT} 
      'No logs found! (' cLog ')~n'
      'You have to enable the logging feature first (LogTypes = run).'.
  ELSE 
    {&OUT} 
      'SessionID not set! (' cID ')~n'
      'You have to enable the session logging feature first. ' skip
      '(Messenger - session connection id)'.
  {&OUT} '~n~nPlease look at help --> Index --> Application Framework.'.
END.

{&OUT} '</TEXTAREA>~n'.

fFooter().

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


