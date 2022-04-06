&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12
/* Procedure Description
"This procedure is the companion program to the ASInfo PRO*Tool. It runs on the AppServer and reads session information to return back to the caller."
*/
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*------------------------------------------------------------------------
    File        : adecomm/_asread.p
    Purpose     : AppServer session information reader for the
                  ASInfo PRO*Tool

    Syntax      : 

    Description : This procedure must be located where the AppServer
                  can run it.

    Author(s)   : Gerry Seidl
    Created     : 11/19/98
    Notes       : This procedure is run from the ASInfo PRO*Tool
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Define parameters */
DEFINE OUTPUT PARAMETER connid   AS CHARACTER NO-UNDO. /* SESSION:SERVER-CONNECTION-ID */
DEFINE OUTPUT PARAMETER opmode   AS CHARACTER NO-UNDO. /* SESSION:SERVER-OPERATING-MODE */
DEFINE OUTPUT PARAMETER connreq  AS LOGICAL   NO-UNDO. /* SESSION:SERVER-CONNECTION-BOUND-REQUEST */
DEFINE OUTPUT PARAMETER connbnd  AS LOGICAL   NO-UNDO. /* SESSION:SERVER-CONNECTION-BOUND */
DEFINE OUTPUT PARAMETER connctxt AS CHARACTER NO-UNDO. /* SESSION:SERVER-CONNECTION-CONTEXT */
DEFINE OUTPUT PARAMETER ASppath  AS CHARACTER NO-UNDO. /* PROPATH */
DEFINE OUTPUT PARAMETER conndbs  AS CHARACTER NO-UNDO. /* List of Databases */
DEFINE OUTPUT PARAMETER connpps  AS CHARACTER NO-UNDO. /* List of Running Persistent Procedures */

/* Define local variables */
DEFINE VARIABLE i   AS INTEGER NO-UNDO. /* Generic counter */
DEFINE VARIABLE hAS AS HANDLE  NO-UNDO. /* AppServer connection handle */

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

/* Read SESSION data */
ASSIGN 
  connid   = SESSION:SERVER-CONNECTION-ID
  opmode   = SESSION:SERVER-OPERATING-MODE
  connreq  = SESSION:SERVER-CONNECTION-BOUND-REQUEST
  connbnd  = SESSION:SERVER-CONNECTION-BOUND
  connctxt = SESSION:SERVER-CONNECTION-CONTEXT
  ASppath  = PROPATH
  .
  
/* Generate list of connected databases */
IF NUM-DBS > 0 THEN 
DO i = 1 TO NUM-DBS:
  ASSIGN conndbs = conndbs + (IF conndbs NE "" THEN ",":U ELSE "") + LDBNAME(i) + " (":U + PDBNAME(i) + ")":U.
END.

/* Generate a list of running persistent procedures */
hAS = SESSION:FIRST-PROCEDURE.
DO WHILE hAS <> ?:
  IF hAS:PERSISTENT THEN
    ASSIGN connpps = connpps + (IF connpps NE "" THEN ",":U ELSE "") + hAS:FILE-NAME.
  hAS = hAS:NEXT-SIBLING.
END.

/*MESSAGE
 *   connid skip opmode skip connreq skip connbnd skip connctxt skip asppath skip
 *   conndbs skip connpps 
 *   VIEW-AS ALERT-BOX.*/
  
RETURN.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


