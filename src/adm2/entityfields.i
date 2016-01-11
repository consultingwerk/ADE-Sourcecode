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
    File        : src/adm2/entityfields.i 
    Purpose     : Populate the entityfields 
                  This is separated out as an include because it is
                  used by both transferDbRow and transferRows. 
                  transferRows is a performance version. We DO NOT want 
                  to put this into an EXTRA procedure as this adds an
                  unacceptable performance cost. 
                  
    Notes:        We may separate this into a internal procedure if the call 
                  does NOT need to call any more procedures and move all the
                  logic in getRecordUserProp into it.
                  (Or move all of this into getRecordUserProp if it can do 
                   direct access to the sdo props)  
                   
  Parameters:  The variables that need to be defined on the outside of this 
               need to be defined as the following preprocessors:   
        &RowObject    - Rowobject handle - already populated
        &RowUserProp  - Char variable that is in effect the returned value
        &entityfields - Optional char var for entityfields                         
                        If NOT defined this include will do the get
                        If defined we assume that the get is done.
                       (the latter allows transferRows to only do the get once)
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/
  DEFINE VARIABLE cKeyTableId       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cKeyFields        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cKeyValue         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iKeyLoop          AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hKeyField         AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lFetchHasAudit    AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lFetchHasComment  AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lFetchAutoComment AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE iHasAudit         AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iHasComment       AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iAutoComment      AS INTEGER    NO-UNDO.

&IF '{&EntityFields}' = '':U &THEN
  DEFINE VARIABLE cEntityFields AS CHARACTER  NO-UNDO.
  {get EntityFields cEntityFields}.
  &SCOPED-DEFINE EntityFields cEntityFields
&ENDIF

/* - Update of the RowUserProp field  */
IF {&EntityFields} > '':U AND VALID-HANDLE(gshGenManager)  THEN 
DO:
  {get KeyTableId cKeyTableId}. /* Key Table Entity Mnemonic / _dump-name */
  {get KeyFields cKeyFields}.     
  cKeyValue = '':U.
  DO iKeyLoop = 1 TO NUM-ENTRIES(cKeyFields):
    ASSIGN 
      hKeyField = {&RowObject}:BUFFER-FIELD(ENTRY(iKeyLoop,cKeyFields)) NO-ERROR.
      IF VALID-HANDLE(hKeyField) THEN
        ASSIGN
        cKeyValue = cKeyValue + CHR(1) WHEN cKeyValue <> "":U
        cKeyValue = cKeyValue + hKeyField:BUFFER-VALUE.
  END.
  ASSIGN
    iHasAudit    = LOOKUP('HasAudit':U,{&EntityFields})
    iHasComment  = LOOKUP('HasComment':U,{&EntityFields})
    iAutoComment = LOOKUP('AutoComment':U,{&EntityFields}).
  IF iHasAudit > 0 THEN
  DO:
    {get FetchHasAudit lFetchHasAudit}.
    IF NOT (lFetchHasAudit = TRUE) THEN
      ENTRY(iHasAudit,{&EntityFields}) = '':U.
  END.
  IF iHasComment > 0 THEN
  DO:
   {get FetchHasComment lFetchHasComment}.
   IF NOT (lFetchHasComment = TRUE) THEN
     ENTRY(iHasComment,{&EntityFields}) = '':U.
  END.
  IF iAutoComment > 0 THEN
  DO:
   {get FetchAutoComment lFetchAutoComment}.
   IF NOT (lFetchAutoComment = TRUE) THEN
     ENTRY(iAutoComment,{&EntityFields}) = '':U.
  END.
        
  /* Comments were changed to use CHR(2) instead of CHR(1) due
     to clashes with the ADM-PROPS delimiter of CHR(1). Now testing
    for both CHR(1) and CHR(2) for backward compatibility. */
   
  IF TRIM({&EntityFields},',':U) <> '':U THEN
  DO:    
    IF cKeyValue <> "":U THEN
      RUN getRecordUserProp IN gshGenManager
                               (INPUT  cKeyTableId,
                                INPUT  {&EntityFields},
                                INPUT  cKeyValue,
                                OUTPUT {&RowUserProp} ) NO-ERROR.
    IF NUM-ENTRIES(cKeyValue,CHR(1)) > 1 THEN
       RUN getRecordUserProp IN gshGenManager
                               (INPUT  cKeyTableId,
                                INPUT  {&EntityFields},
                                INPUT  REPLACE(cKeyValue,CHR(1),CHR(2)),
                                OUTPUT {&RowUserProp} ) NO-ERROR.          
  END.
END.
