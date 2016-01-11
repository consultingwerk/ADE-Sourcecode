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
DEFINE VARIABLE hObject    AS HANDLE  NO-UNDO.
DEFINE VARIABLE hRowObject AS HANDLE  NO-UNDO.
DEFINE VARIABLE lStatic    AS LOGICAL NO-UNDO.

DO ON STOP UNDO, LEAVE:   
  RUN VALUE(pcObject) PERSISTENT SET hObject NO-ERROR.   
END.
IF NOT VALID-HANDLE(hObject) THEN
DO:
  pocMessages = ERROR-STATUS:GET-MESSAGE(1).
  RETURN.
END.

lStatic = CAN-DO(hObject:INTERNAL-ENTRIES,'Data.Calculate':U).
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

END.
ELSE DO:
  CREATE TEMP-TABLE phRowObject.
  {fnarg prepareRowObject phRowObject hObject}.

  RUN setContextAndInitialize IN hObject (piocContext). 

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

IF NOT lStatic AND VALID-HANDLE(phRowObject) THEN
  DELETE OBJECT phRowObject.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


