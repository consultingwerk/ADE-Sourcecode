&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
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
  File: sendrows.p 

 Description: Stateless retrieval of data from a SamrtDataObject  
 Purpose:     Allow a client to retrieve data from the server with 
              ONE appserver call  

 Parameters: 
   input        pcObject    - physical object name of an sdo       
                              Will be extended to support logical icf SDOs 
   input-output piocContext - Context from client to server 
                              Will return new context to client  
                              See data.p   
  sendRows    
  | input        piStartRow     -  See sendrows
  | input        pcRowIdent     -   - " -
  | input        plNext         -   - " -   
  | input        piRowsToReturn -   - " - 
  | output       piROwsReturned -   - " -                               
  | output table phRowObject    - RowObject table
                                  We add this as dynamic definition to the 
                                  SDO.                                    
   
   output        pocMessages    - error messages in adm format
                       
                                        
 Notes:  The only difference from the remoteSendrows method in data.p is 
         the first parameter objectname.     
 
 History:
------------------------------------------------------------------------------*/
 
/* ***************************  Definitions  ************************** */
&scop object-name       sendrows.p
&scop object-version    000000
 
 DEFINE INPUT PARAMETER pcObject AS CHARACTER  NO-UNDO.

 DEFINE INPUT-OUTPUT PARAMETER piocContext  AS CHARACTER  NO-UNDO.
 
 DEFINE INPUT  PARAMETER piStartRow     AS INTEGER   NO-UNDO.
 DEFINE INPUT  PARAMETER pcRowIdent     AS CHARACTER NO-UNDO.
 DEFINE INPUT  PARAMETER plNext         AS LOGICAL   NO-UNDO.
 DEFINE INPUT  PARAMETER piRowsToReturn AS INTEGER   NO-UNDO.
 DEFINE OUTPUT PARAMETER piRowsReturned AS INTEGER   NO-UNDO.
 
 DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject.
 
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
         HEIGHT             = 5
         WIDTH              = 80.4.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
DEFINE VARIABLE hObject           AS HANDLE     NO-UNDO.
DEFINE VARIABLE hRowObject        AS HANDLE     NO-UNDO.
DEFINE VARIABLE lStatic           AS LOGICAL    NO-UNDO. 
DEFINE VARIABLE iEntry            AS INTEGER    NO-UNDO.
DEFINE VARIABLE iEntry2           AS INTEGER    NO-UNDO.
DEFINE VARIABLE cLogicalName      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cLocalContext     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE lDestroyStateless AS LOGICAL    NO-UNDO.

ASSIGN
  cLocalContext = REPLACE(piocContext, CHR(3), CHR(4))
  iEntry = LOOKUP('LogicalObjectName':U, cLocalContext, CHR(4))
  iEntry2 = LOOKUP('DestroyStateless':U, cLocalContext, CHR(4)).
IF iEntry > 0 THEN
  cLogicalName = ENTRY(iEntry + 1, cLocalContext, CHR(4)).
IF iEntry2 > 0 THEN
  lDestroyStateless = LOOKUP(ENTRY(iEntry2 + 1, cLocalContext, CHR(4)), 
                             'YES,TRUE':U) > 0.

IF cLogicalName > '':U THEN
DO:                                     /* look for running object */
  PUBLISH "searchCache" + cLogicalName (OUTPUT hObject).
  /* if found, use it */
  IF VALID-HANDLE(hObject) THEN
    RUN removeFromCache IN hObject.
END.

IF NOT VALID-HANDLE(hObject) THEN       /* start a new instance */
DO ON STOP UNDO, LEAVE:   
  RUN VALUE(pcObject) PERSISTENT SET hObject NO-ERROR.   
END.
IF NOT VALID-HANDLE(hObject) THEN
DO:
  pocMessages = ERROR-STATUS:GET-MESSAGE(1).
  RETURN.
END.

{get UseStaticOnFetch lStatic hObject}.
IF lStatic THEN 
DO:
  RUN remoteSendRows IN hObject
          (INPUT-OUTPUT piocContext,
           piStartRow, 
           pcRowIdent, 
           plNext,
           piRowsToReturn, 
           OUTPUT piRowsReturned,
           OUTPUT TABLE-HANDLE phRowObject,
           OUTPUT pocMessages).

  RUN destroyObject IN hObject.
END.
ELSE DO:
  IF lDestroyStateless THEN
  DO:
    CREATE TEMP-TABLE phRowObject.
    {set RowObjectTable phRowObject hObject}.
  END.

  RUN setContextAndInitialize IN hObject (piocContext).
  {get RowObjectTable phRowObject hObject}.

  RUN sendRows IN hObject
          (piStartRow, 
           pcRowIdent, 
           plNext,
           piRowsToReturn,
           OUTPUT piRowsReturned).
  IF {fn anyMessage hObject} THEN
    pocMessages = {fn fetchMessages hObject}.

  RUN getContextAndDestroy IN hObject (OUTPUT piocContext).
END.

IF NOT lStatic AND VALID-HANDLE(phRowObject) AND lDestroyStateless THEN
  DELETE OBJECT phRowObject.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


