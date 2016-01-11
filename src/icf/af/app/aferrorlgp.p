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
/*---------------------------------------------------------------------------------
  File: aferrorlgp.p

  Description:  Update Astra Error Log

  Purpose:      Update Astra Error Log

  Parameters:   INPUT CHR(3) delimited list of summary messages
                INPUT CHR(3) delimited list of full messages

  History:
  --------
  (v:010000)    Task:        5958   UserRef:    
                Date:   09/06/2000  Author:     Anthony Swindells

  Update Notes: Add Error Handling to Session Manager

  (v:010001)    Task:        6153   UserRef:    
                Date:   26/06/2000  Author:     Pieter Meyer

  Update Notes: Add Web check in Managers

--------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       aferrorlgp.p
&scop object-version    010001


/* MIP object identifying preprocessor */
&glob   mip-structured-procedure    yes


{af/sup2/afglobals.i}     /* Astra global shared variables */

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
         HEIGHT             = 4.48
         WIDTH              = 40.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME




&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

DEFINE INPUT PARAMETER  pcSummaryList           AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAMETER  pcFullList              AS CHARACTER  NO-UNDO.

DEFINE VARIABLE iLoop                           AS INTEGER    NO-UNDO.
DEFINE VARIABLE cMessage1                       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cMessage2                       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cUserObj                        AS CHARACTER  NO-UNDO.
DEFINE VARIABLE dUserObj                        AS DECIMAL INITIAL 0 NO-UNDO.
DEFINE VARIABLE cErrorGroup                     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE iErrorCode                      AS INTEGER    NO-UNDO.
DEFINE VARIABLE cErrorCode                      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cTable                          AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cField                          AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cProgram                        AS CHARACTER  NO-UNDO.
DEFINE VARIABLE iStart                          AS INTEGER    NO-UNDO.
DEFINE VARIABLE iPos1                           AS INTEGER    NO-UNDO.
DEFINE VARIABLE iPos2                           AS INTEGER    NO-UNDO.
DEFINE VARIABLE iLen                            AS INTEGER    NO-UNDO.

/* get current user */
cUserObj = DYNAMIC-FUNCTION("getPropertyList":U IN gshSessionManager,
                                                INPUT "currentUserObj":U,
                                                INPUT NO).
ASSIGN dUserObj = DECIMAL(cUserObj) NO-ERROR.
ERROR-STATUS:ERROR = NO.

DEFINE BUFFER bgst_error_log FOR gst_error_log.

trn-block:
DO FOR bgst_error_log TRANSACTION ON ERROR UNDO trn-block, LEAVE trn-block
   iLoop = 1 TO NUM-ENTRIES(pcSummaryList):

  ASSIGN
    cMessage1 = ENTRY(iLoop, pcSummaryList)
    cMessage2 = ENTRY(iLoop, pcFullList)
    .

  ASSIGN
    cErrorGroup = "":U
    cErrorCode = "":U
    iErrorCode = 0
    cTable = "":U
    cField = "":U
    cProgram = "":U
    .

  /* work out table, field, error code, error group and program from message text */
  ASSIGN iStart = INDEX(cMessage2, CHR(10) + CHR(10) + "*** Error: ":U).
  IF iStart > 0 THEN
    ASSIGN iStart = INDEX(cMessage2, "*** Error: ":U, iStart).

  IF iStart > 0 THEN
  DO:
    /* Work out error group and code */
    ASSIGN iPos1 = 0 iPos2 = 0.
    iPos1 = INDEX(cMessage2, "-":U, iStart).    /* look for hyphen */    
    IF iPos1 > iStart THEN iPos2 = INDEX(cMessage2, " ":U, ipos1).    /* look for space */ 
    IF iPos1 > iStart AND iPos2 = 0 THEN iPos2 = LENGTH(cMessage2) + 1.
    IF iPos1 > iStart AND iPos2 > iPos1 THEN
    DO:
      ASSIGN
        cErrorGroup = SUBSTRING(cMessage2, iStart + 11, iPos1 - (iStart + 11))
        cErrorCode  = SUBSTRING(cMessage2, iPos1 + 1, iPos2 - (iPos1 + 1))
      .
      ASSIGN iErrorCode = INTEGER(cErrorCode) NO-ERROR.
    END.

    /* work out table */
    ASSIGN iPos1 = 0 iPos2 = 0.
    iPos1 = INDEX(cMessage2, "table: ":U, iStart).    /* look for placeholder */    
    IF iPos1 > iStart THEN iPos2 = INDEX(cMessage2, " ":U, ipos1 + 7).    /* look for space */ 
    IF iPos1 > iStart AND iPos2 = 0 THEN iPos2 = LENGTH(cMessage2) + 1.
    IF iPos1 > iStart AND iPos2 > iPos1 THEN
    DO:
      ASSIGN
        ctable = SUBSTRING(cMessage2, iPos1 + 7, iPos2 - (iPos1 + 7))
      .
    END.

    /* work out field */
    ASSIGN iPos1 = 0 iPos2 = 0.
    iPos1 = INDEX(cMessage2, "field: ":U, iStart).    /* look for placeholder */    
    IF iPos1 > iStart THEN iPos2 = INDEX(cMessage2, " ":U, ipos1 + 7).    /* look for space */ 
    IF iPos1 > iStart AND iPos2 = 0 THEN iPos2 = LENGTH(cMessage2) + 1.
    IF iPos1 > iStart AND iPos2 > iPos1 THEN
    DO:
      ASSIGN
        cfield = SUBSTRING(cMessage2, iPos1 + 7, iPos2 - (iPos1 + 7))
      .
    END.

    /* work out program */
    ASSIGN iPos1 = 0 iPos2 = 0.
    iPos1 = INDEX(cMessage2, "program: ":U, iStart).    /* look for placeholder */    
    IF iPos1 > iStart THEN iPos2 = INDEX(cMessage2, " ":U, ipos1 + 9).    /* look for space */ 
    IF iPos1 > iStart AND iPos2 = 0 THEN iPos2 = LENGTH(cMessage2) + 1.
    IF iPos1 > iStart AND iPos2 > iPos1 THEN
    DO:
      ASSIGN
        cProgram = SUBSTRING(cMessage2, iPos1 + 9, iPos2 - (iPos1 + 9))
      .
    END.

  END.

  /* write to error log */
  CREATE bgst_error_log NO-ERROR.
  IF ERROR-STATUS:ERROR THEN UNDO trn-block, LEAVE trn-block.

  ASSIGN
    bgst_error_log.business_logic_error = IF SESSION:REMOTE OR SESSION:PARAM = "REMOTE":U THEN YES ELSE NO
    bgst_error_log.error_group = cErrorGroup
    bgst_error_log.error_number = iErrorCode
    bgst_error_log.error_date = TODAY
    bgst_error_log.error_time = TIME
    bgst_error_log.error_message = cMessage1
    bgst_error_log.error_in_program = cProgram
    bgst_error_log.owning_entity_mnemonic = "":U
    bgst_error_log.owning_obj = 0
    bgst_error_log.user_obj = dUserObj
    NO-ERROR.
  IF ERROR-STATUS:ERROR THEN UNDO trn-block, LEAVE trn-block.

  VALIDATE bgst_error_log NO-ERROR.
  IF ERROR-STATUS:ERROR THEN UNDO trn-block, LEAVE trn-block.

END.
{af/sup2/afcheckerr.i}   /* check for errors */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


