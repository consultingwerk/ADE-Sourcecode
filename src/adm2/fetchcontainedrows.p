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

/*-----------------------------------------------------------------------------
  File: fetchcontainedrows.p 

 Description: Stateless retrieval of data from a SmartBusinessObject  
 Purpose:     Allow a client to retrieve data from the server with 
              ONE appserver call  

 Parameters: 
   input        pcObject    - physical object name of an sdo       
                              Will be extended to support logical icf SDOs 
   input-output piocContext - Context from client to server 
                              Will return new context to client  
                              See data.p   
  fetchcontaimedRows  
 DEFINE INPUT  PARAMETER pcQueries      AS CHARACTER NO-UNDO.
  | input        pcQueries      -  See fetchcontainedRows
  | input        piStartRow     -   - " -
  | input        pcRowIdent     -   - " -
  | input        plNext         -   - " -   
  | input        piRowsToReturn -   - " - 
  | output       piROwsReturned -   - " -                               
  | output table phRowObject1-20 - RowObject table
                                  We add this as dynamic definition to the 
                                  SDOs.                                    
   
   output        pocMessages    - error messages in adm format
                                                               
 Notes:      
 
 History:
------------------------------------------------------------------------------*/
 
/* ***************************  Definitions  ************************** */
&scop object-name       fetchcontainedrows.p
&scop object-version    000000
 
 DEFINE INPUT PARAMETER pcObject AS CHARACTER  NO-UNDO.

 DEFINE INPUT-OUTPUT PARAMETER piocContext  AS CHARACTER  NO-UNDO.
 
 DEFINE INPUT  PARAMETER pcQueries      AS CHARACTER NO-UNDO.
 DEFINE INPUT  PARAMETER piStartRow     AS INTEGER   NO-UNDO.
 DEFINE INPUT  PARAMETER pcRowIdent     AS CHARACTER NO-UNDO.
 DEFINE INPUT  PARAMETER plNext         AS LOGICAL   NO-UNDO.
 DEFINE INPUT  PARAMETER piRowsToReturn AS INTEGER   NO-UNDO.
 DEFINE OUTPUT PARAMETER piRowsReturned AS INTEGER   NO-UNDO.
 
 DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject1.
 DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject2.
 DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject3.
 DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject4.
 DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject5.
 DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject6.
 DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject7.
 DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject8.
 DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject9.
 DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject10.
 DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject11.
 DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject12.
 DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject13.
 DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject14.
 DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject15.
 DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject16.
 DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject17.
 DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject18.
 DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject19.
 DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject20.

 DEFINE OUTPUT PARAMETER pocMessages AS CHARACTER  NO-UNDO.                                                                       
                                                                           

/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       
&scop object-version

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
         HEIGHT             = 4.71
         WIDTH              = 80.4.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
DEFINE VARIABLE hObject        AS HANDLE     NO-UNDO.
DEFINE VARIABLE hRowObject     AS HANDLE     NO-UNDO.
DEFINE VARIABLE cSDOs          AS CHARACTER  NO-UNDO.
DEFINE VARIABLE iSDO           AS INTEGER    NO-UNDO.
DEFINE VARIABLE hSDO           AS HANDLE     NO-UNDO.
DEFINE VARIABLE lStatic        AS LOGICAL    NO-UNDO.

DO ON STOP UNDO, LEAVE:   
  RUN VALUE(pcObject) PERSISTENT SET hObject NO-ERROR.   
END.
IF NOT VALID-HANDLE(hObject) THEN
DO:
  pocMessages = ERROR-STATUS:GET-MESSAGE(1).
  RETURN.
END.

RUN setContextAndInitialize IN hObject (piocContext). 
{get ContainedDataObjects cSDOs hObject}.
DO iSDO = 1 TO NUM-ENTRIES(cSDOs):
  hSDO = WIDGET-HANDLE(ENTRY(iSDO,cSDOs)).
  lStatic = CAN-DO(hSDO:INTERNAL-ENTRIES,'Data.Calculate':U).
  IF lStatic THEN LEAVE.
END.

IF lStatic THEN
DO:
   RUN serverFetchContainedRows IN hObject
            (pcQueries,
             piStartRow, 
             pcRowIdent, 
             plNext,
             piRowsToReturn, 
             OUTPUT piRowsReturned,
             OUTPUT TABLE-HANDLE phRowObject1,
             OUTPUT TABLE-HANDLE phRowObject2,
             OUTPUT TABLE-HANDLE phRowObject3,
             OUTPUT TABLE-HANDLE phRowObject4,
             OUTPUT TABLE-HANDLE phRowObject5,
             OUTPUT TABLE-HANDLE phRowObject6,
             OUTPUT TABLE-HANDLE phRowObject7,
             OUTPUT TABLE-HANDLE phRowObject8,
             OUTPUT TABLE-HANDLE phRowObject9,
             OUTPUT TABLE-HANDLE phRowObject10,
             OUTPUT TABLE-HANDLE phRowObject11,
             OUTPUT TABLE-HANDLE phRowObject12,
             OUTPUT TABLE-HANDLE phRowObject13,
             OUTPUT TABLE-HANDLE phRowObject14,
             OUTPUT TABLE-HANDLE phRowObject15,
             OUTPUT TABLE-HANDLE phRowObject16,
             OUTPUT TABLE-HANDLE phRowObject17,
             OUTPUT TABLE-HANDLE phRowObject18,
             OUTPUT TABLE-HANDLE phRowObject19,
             OUTPUT TABLE-HANDLE phRowObject20).
END.
ELSE 
DO:
  DO iSDO = 1 TO NUM-ENTRIES(cSDOs):
    hSDO = WIDGET-HANDLE(ENTRY(iSDO,cSDOs)).
    CASE iSDO:
      WHEN 1 THEN
      DO:
        CREATE TEMP-TABLE phRowObject1.
        {fnarg prepareRowObject phRowObject1 hSDO}.
      END.
      WHEN 2 THEN
      DO:
        CREATE TEMP-TABLE phRowObject2.
        {fnarg prepareRowObject phRowObject2 hSDO}.
      END.
      WHEN 3 THEN
      DO:
        CREATE TEMP-TABLE phRowObject3.
        {fnarg prepareRowObject phRowObject3 hSDO}.
      END.
      WHEN 4 THEN
      DO:
        CREATE TEMP-TABLE phRowObject4.
        {fnarg prepareRowObject phRowObject4 hSDO}.
      END.
      WHEN 5 THEN
      DO:
        CREATE TEMP-TABLE phRowObject5.
        {fnarg prepareRowObject phRowObject5 hSDO}.
      END.
      WHEN 6 THEN
      DO:
        CREATE TEMP-TABLE phRowObject6.
        {fnarg prepareRowObject phRowObject6 hSDO}.
      END.
      WHEN 7 THEN
      DO:
        CREATE TEMP-TABLE phRowObject7.
        {fnarg prepareRowObject phRowObject7 hSDO}.
      END.
      WHEN 8 THEN
      DO:
        CREATE TEMP-TABLE phRowObject8.
        {fnarg prepareRowObject phRowObject8 hSDO}.
      END.
      WHEN 9 THEN
      DO:
        CREATE TEMP-TABLE phRowObject9.
        {fnarg prepareRowObject phRowObject9 hSDO}.
      END.
      WHEN 10 THEN
      DO:
        CREATE TEMP-TABLE phRowObject10.
        {fnarg prepareRowObject phRowObject10 hSDO}.
      END.
      WHEN 11 THEN
      DO:
        CREATE TEMP-TABLE phRowObject11.
        {fnarg prepareRowObject phRowObject11 hSDO}.
      END.
      WHEN 12 THEN
      DO:
        CREATE TEMP-TABLE phRowObject12.
        {fnarg prepareRowObject phRowObject12 hSDO}.
      END.
      WHEN 13 THEN
      DO:
        CREATE TEMP-TABLE phRowObject13.
        {fnarg prepareRowObject phRowObject13 hSDO}.
      END.
      WHEN 14 THEN
      DO:
        CREATE TEMP-TABLE phRowObject14.
        {fnarg prepareRowObject phRowObject14 hSDO}.
      END.
      WHEN 15 THEN
      DO:
        CREATE TEMP-TABLE phRowObject15.
        {fnarg prepareRowObject phRowObject15 hSDO}.
      END.
      WHEN 16 THEN
      DO:
        CREATE TEMP-TABLE phRowObject16.
        {fnarg prepareRowObject phRowObject16 hSDO}.
      END.
      WHEN 17 THEN
      DO:
        CREATE TEMP-TABLE phRowObject17.
        {fnarg prepareRowObject phRowObject17 hSDO}.
      END.
      WHEN 18 THEN
      DO:
        CREATE TEMP-TABLE phRowObject18.
        {fnarg prepareRowObject phRowObject18 hSDO}.
      END.
      WHEN 19 THEN
      DO:
        CREATE TEMP-TABLE phRowObject19.
        {fnarg prepareRowObject phRowObject19 hSDO}.
      END.
      WHEN 20 THEN
      DO:
        CREATE TEMP-TABLE phRowObject20.
        {fnarg prepareRowObject phRowObject20 hSDO}.
      END.
    END CASE.    
  END.

  RUN bufferFetchContainedRows IN hObject
           (pcQueries,
            piStartRow, 
            pcRowIdent, 
            plNext,
            piRowsToReturn, 
            OUTPUT piRowsReturned).
 
END.

IF {fn anyMessage hObject} THEN
   pocMessages = {fn fetchMessages hObject}.

RUN getContextAndDestroy IN hObject (OUTPUT piocContext).

IF NOT lStatic THEN
DO:
  IF VALID-HANDLE(phRowObject1) THEN
      DELETE OBJECT phRowObject1.
  IF VALID-HANDLE(phRowObject2) THEN
      DELETE OBJECT phRowObject2.
  IF VALID-HANDLE(phRowObject3) THEN
      DELETE OBJECT phRowObject3.
  IF VALID-HANDLE(phRowObject4) THEN
      DELETE OBJECT phRowObject4.
  IF VALID-HANDLE(phRowObject5) THEN
      DELETE OBJECT phRowObject5.
  IF VALID-HANDLE(phRowObject6) THEN
      DELETE OBJECT phRowObject6.
  IF VALID-HANDLE(phRowObject7) THEN
      DELETE OBJECT phRowObject7.
  IF VALID-HANDLE(phRowObject8) THEN
      DELETE OBJECT phRowObject8.
  IF VALID-HANDLE(phRowObject9) THEN
      DELETE OBJECT phRowObject9.
  IF VALID-HANDLE(phRowObject10) THEN
      DELETE OBJECT phRowObject10.
  IF VALID-HANDLE(phRowObject11) THEN
      DELETE OBJECT phRowObject11.
  IF VALID-HANDLE(phRowObject12) THEN
      DELETE OBJECT phRowObject12.
  IF VALID-HANDLE(phRowObject13) THEN
      DELETE OBJECT phRowObject13.
  IF VALID-HANDLE(phRowObject14) THEN
      DELETE OBJECT phRowObject14.
  IF VALID-HANDLE(phRowObject15) THEN
      DELETE OBJECT phRowObject15.
  IF VALID-HANDLE(phRowObject16) THEN
      DELETE OBJECT phRowObject16.
  IF VALID-HANDLE(phRowObject17) THEN
      DELETE OBJECT phRowObject17.
  IF VALID-HANDLE(phRowObject18) THEN
      DELETE OBJECT phRowObject18.
  IF VALID-HANDLE(phRowObject19) THEN
      DELETE OBJECT phRowObject19.
  IF VALID-HANDLE(phRowObject20) THEN
      DELETE OBJECT phRowObject20.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


