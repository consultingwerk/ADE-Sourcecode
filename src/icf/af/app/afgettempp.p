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
  File: afgettempp.p

  Description:  Get temp table procedure

  Purpose:      Get temp table procedure

  Parameters:

  History:
  --------
  (v:010000)    Task:        7065   UserRef:    
                Date:   17/11/2000  Author:     Anthony Swindells

  Update Notes: Astra 2 dynamic lookups

  (v:010002)    Task:        7772   UserRef:    
                Date:   31/01/2001  Author:     Anthony Swindells

  Update Notes: Fix outer-join issues with lookups

-----------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       afgettempp.p
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    010002


/* MIP object identifying preprocessor */
&glob   mip-structured-procedure    yes

/* input-output temp-table for combo boxes / selection lists whose list items pairs
   need to be built
*/
{af/sup2/afttlkctrl.i}
{af/sup2/afglobals.i}

DEFINE INPUT-OUTPUT PARAMETER TABLE FOR ttLookCtrl. /* lookup control information */
DEFINE OUTPUT PARAMETER TABLE-HANDLE ohttLookup.    /* table handle for lookup Data dynamic temp-table */

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
         HEIGHT             = 5.38
         WIDTH              = 40.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME




&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

DEFINE VARIABLE hTT                         AS HANDLE     NO-UNDO.
DEFINE VARIABLE hTTBuff                     AS HANDLE     NO-UNDO.
DEFINE VARIABLE hQuery                      AS HANDLE     NO-UNDO.
DEFINE VARIABLE cBufferHdlList              AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cFieldHdlList               AS CHARACTER  NO-UNDO.
DEFINE VARIABLE hBuffer                     AS HANDLE     NO-UNDO.
DEFINE VARIABLE iRow                        AS INTEGER    NO-UNDO.
DEFINE VARIABLE iLoop                       AS INTEGER    NO-UNDO.
DEFINE VARIABLE iLoop2                      AS INTEGER    NO-UNDO.
DEFINE VARIABLE iBuffer                     AS INTEGER    NO-UNDO.
DEFINE VARIABLE cField                      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cBuffer                     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE hField                      AS HANDLE     NO-UNDO.
DEFINE VARIABLE hFromField                  AS HANDLE     NO-UNDO.
DEFINE VARIABLE cValue                      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cEmptyValue                 AS CHARACTER  NO-UNDO.
DEFINE VARIABLE lOk                         AS LOGICAL    NO-UNDO.
DEFINE VARIABLE cRowid                      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE iStartRow                   AS INTEGER    NO-UNDO.
DEFINE VARIABLE cStartRowId                 AS CHARACTER  NO-UNDO.
DEFINE VARIABLE rRowIDs                     AS ROWID EXTENT 10 NO-UNDO.
DEFINE VARIABLE lOffEnd                     AS LOGICAL    NO-UNDO.

/* 1st find lookup control information */
ASSIGN
  ohttLookup = ?
  .
FIND FIRST ttLookCtrl NO-ERROR.
IF NOT AVAILABLE ttLookCtrl THEN RETURN.

/* See if appending to an existing result set */ 
IF ttLookCtrl.cLastResultRow <> "":U THEN
  ASSIGN
    iStartRow = INTEGER(ENTRY(1,ttLookCtrl.cLastResultRow,";":U))
    cStartRowId = ENTRY(2,ttLookCtrl.cLastResultRow,";":U).
ELSE
  ASSIGN
    iStartRow = 0
    cStartRowId = "":U.

/* Create a query */
CREATE QUERY hQuery NO-ERROR.

/* Add buffers */
buffer-loop:
DO iLoop = 1 TO NUM-ENTRIES(ttLookCtrl.cQueryTables):
  CREATE BUFFER hBuffer FOR TABLE ENTRY(iLoop,ttLookCtrl.cQueryTables) NO-ERROR.
  IF ERROR-STATUS:ERROR THEN NEXT buffer-loop.
  cBufferHdlList = cBufferHdlList + (IF cBufferHdlList <> "":U THEN ",":U ELSE "":U) + STRING(hBuffer).
  hQuery:ADD-BUFFER(hBuffer) NO-ERROR.
END. /* buffer-loop */

/* Get Field Handles, assuming all fields in table.field format */
DO iLoop = 1 TO NUM-ENTRIES(ttLookCtrl.cAllFields):
  cBuffer = ENTRY(iLoop,ttLookCtrl.cAllFields).
  cField = ENTRY(2,cBuffer,".":U).
  cBuffer = ENTRY(1,cBuffer,".":U).
  hBuffer = WIDGET-HANDLE(ENTRY(LOOKUP(cBuffer,ttLookCtrl.cQueryTables),cBufferHdlList)).
  hField = hBuffer:BUFFER-FIELD(cField).
  cFieldHdlList = cFieldHdlList + (IF cFieldHdlList <> "":U THEN ",":U ELSE "":U) + STRING(hField).
END.

/* Create the dynamic temp-table */
CREATE TEMP-TABLE hTT.

/* Add fields - static ones first */
hTT:ADD-NEW-FIELD("RowNum":U,"INTEGER":U).      /* Row number for sequencing */
hTT:ADD-NEW-FIELD("RowIdent":U,"CHARACTER":U).  /* string of Rowid of correspding record, comma delimited for multiple tables */

/* Add selected fields */
DO iLoop = 1 TO NUM-ENTRIES(cFieldHdlList):
  hField = WIDGET-HANDLE(ENTRY(iLoop,cFieldHdlList)).
  hTT:ADD-LIKE-FIELD(hField:NAME,hField).
END.

/* Add indexes to the temp-table */
hTT:ADD-NEW-INDEX("idxRowNum":U,FALSE,FALSE).
hTT:ADD-INDEX-FIELD("idxRowNum":U,"RowNum":U,"asc":U).
hTT:ADD-NEW-INDEX("idxRowIdent":U,FALSE,FALSE).
hTT:ADD-INDEX-FIELD("idxRowIdent":U,"RowIdent":U,"asc":U).

/* Prepare the temp-table with the name the user chose */
hTT:TEMP-TABLE-PREPARE("RowObject":U).

/* Store the handle to the buffer for the temp-table */
hTTBuff = hTT:DEFAULT-BUFFER-HANDLE.

/* Prepare a query using the string the user provided */

/* remove decimals with commas for Europe */
ttLookCtrl.cBaseQueryString = DYNAMIC-FUNCTION("fixQueryString":U IN gshSessionManager, INPUT ttLookCtrl.cBaseQueryString).

hQuery:QUERY-PREPARE(ttLookCtrl.cBaseQueryString).
/* Open the query */
hQuery:QUERY-OPEN() NO-ERROR.

/* position to desired record */
IF ttLookCtrl.iFirstRowNum = 0 OR cStartRowId = "":U THEN
DO:
  /* Get the first result in the result set and indicate query started */
  hQuery:GET-FIRST() NO-ERROR.
END.
ELSE
DO: /* Restart from after the last record read */
  ASSIGN rRowIDs = ?.       /* Fill in this array with all the rowids. */
  DO iLoop = 1 TO NUM-ENTRIES(cStartRowId):
    rRowIDs[iLoop] = TO-ROWID(ENTRY(iLoop, cStartRowId)).
  END.        /* END DO iCnt */
  lOffEnd = hQuery:QUERY-OFF-END. 
  lOk = hQuery:REPOSITION-TO-ROWID(rRowIDs) NO-ERROR.
  IF lOk OR (lOffEnd AND NOT ERROR-STATUS:ERROR) THEN 
  DO:
    hQuery:GET-NEXT() NO-ERROR. /* get row repositioned to */
    hQuery:GET-NEXT() NO-ERROR. /* get next record */
  END.
END.

/* Iterate for as many rows as the user has chosen, or until the query is 
   off-end */
REPEAT iRow = (iStartRow + 1) TO (ttLookCtrl.iRowsToBatch + iStartRow) WHILE NOT hQuery:QUERY-OFF-END:

  /* Create a temp-table record */
  hTTBuff:BUFFER-CREATE().
  /* Iterate through the fields in the temp table */

  DO iLoop = 1 TO hTTBuff:NUM-FIELDS:
    /* Get the handle to the current field */
    hField = hTTBuff:BUFFER-FIELD(iLoop).
    /* If this is the first field, we just increment the counter */
    IF iLoop = 1 THEN
      hField:BUFFER-VALUE = iRow.
    ELSE IF iLoop = 2 THEN /* rowident list */
    DO:
      hField:BUFFER-VALUE = "":U.
      DO iLoop2 = 1 TO NUM-ENTRIES(cBufferHdlList):
        ASSIGN hBuffer = WIDGET-HANDLE(ENTRY(iLoop2, cBufferHdlList)).
        IF VALID-HANDLE(hbuffer) THEN
          cRowid = STRING(hBuffer:ROWID).
        ELSE
          cRowid = "?":U.
        ASSIGN
          hField:BUFFER-VALUE = hField:BUFFER-VALUE +
                                (IF iLoop2 = 1 THEN "":U ELSE ",":U) +
                                (IF cRowid = ? THEN "?":U ELSE cRowId).
      END.

      /* Store first row details */
      IF ttLookCtrl.iFirstRowNum = 0 AND iRow = 1 THEN
      DO:
        ASSIGN 
          ttLookCtrl.iFirstRowNum = 1
          ttLookCtrl.cFirstResultRow = "1;":U + hField:BUFFER-VALUE
          .
      END.

      /* Store last result row details */
      ASSIGN
        ttLookCtrl.cLastResultRow = STRING(iRow) + ";":U + (IF hField:BUFFER-VALUE = ? THEN "?":U ELSE hField:BUFFER-VALUE)
        .
    END.  /* iloop = 2 */
    ELSE
    DO:
      /* Otherwise get the handle of the corresponding field in the 
         cFieldHdlList list */
      hFromField = WIDGET-HANDLE(ENTRY(iLoop - 2,cFieldHdlList)).
      /* Set the value of the temp-table field to the value of the 
         database table field */
      hField:BUFFER-VALUE = hFromField:BUFFER-VALUE.
    END.
  END.

  /* Release the temp-table record */
  hTTBuff:BUFFER-RELEASE().
  /* Get the next result in the query */
  hQuery:GET-NEXT().

END. /* repeat */

/* See if reached last record and store last row if we have */
IF hQuery:QUERY-OFF-END THEN
  ASSIGN
    ttLookCtrl.iLastRowNum = iRow. 
ELSE
  ASSIGN
    ttLookCtrl.iLastRowNum = 0.   /* more to come, reached batch count */ 

/* Cleanup */
DELETE OBJECT hQuery NO-ERROR.
ASSIGN hQuery = ?.

buffer-loop2:
DO iLoop = 1 TO NUM-ENTRIES(cBufferHdlList):
  hBuffer = WIDGET-HANDLE(ENTRY(iLoop,cBufferHdlList)).
  DELETE OBJECT hBuffer NO-ERROR.
  ASSIGN hBuffer = ?.
END. /* buffer-loop2 */

ASSIGN
  ohttLookup = hTT
  .

/* delete temp-table object */
DELETE OBJECT hTT.
hTT = ?.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


