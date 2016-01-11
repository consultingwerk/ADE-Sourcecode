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
  File: fetchdefs.p 

 Description: Stateless retrieval of data definitions from a SmartDataObject  
 Purpose:     Allow a client to retrieve data definition from the server 
              with ONE appserver call.
 Parameters: 
   input        pcObject    - physical object name of an sdo       
                              Will be extended to support logical icf SDOs 
   input-output piocContext - Context from client to server 
                              Will return new context to client.                               
                              In this case that would be only be first time                              
                              properties.
   output table phRowObject - RowObject table  
   output       pocMessages - error messages in adm format
                       
 Notes:     Standard ADM needs this for a completely dynamic data object when 
            for example openOnInit is false. 
            Dynamics need this in all cases when OpenOnInit is false.    
            It will also be used in design time 
------------------------------------------------------------------------------*/
 
/* ***************************  Definitions  ************************** */
&scop object-name       fetchdatadef.p
&scop object-version    000000
 
 DEFINE INPUT PARAMETER pcObject AS CHARACTER  NO-UNDO.
 
 DEFINE INPUT-OUTPUT PARAMETER piocContext  AS CHARACTER  NO-UNDO.
 
 DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject.
 DEFINE OUTPUT PARAMETER pocMessages AS CHARACTER  NO-UNDO.

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
DEFINE VARIABLE lDynamic   AS LOGICAL NO-UNDO. 

DO ON STOP UNDO, LEAVE:   
  RUN VALUE(pcObject) PERSISTENT SET hObject NO-ERROR.   
END.

IF NOT VALID-HANDLE(hObject) THEN
DO:
  pocMessages = ERROR-STATUS:GET-MESSAGE(1).
  RETURN.
END.

RUN setPropertyList IN hObject (piocContext).

{get DynamicData lDynamic hObject}.

IF lDynamic THEN 
DO:
  CREATE TEMP-TABLE phRowObject.
  {set RowObjectTable phRowObject hObject}.
  RUN createObjects IN hObject.
END.
ELSE DO:
  RUN fetchRowObjectTable IN hObject( OUTPUT TABLE-HANDLE phRowObject ).
END.

IF {fn anyMessage hObject} THEN
    pocMessages = {fn fetchMessages hObject}.

RUN getContextAndDestroy IN hObject (OUTPUT piocContext).

IF lDynamic AND VALID-HANDLE(phRowObject) THEN
  DELETE OBJECT phRowObject.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


