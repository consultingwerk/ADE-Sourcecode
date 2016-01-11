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
  File: commit.p 

 Description: Stateless commit of data to any SmartDataObject  
 Purpose:     Allow a client to commit data to the server with 
               ONE appserver call  

 Parameters: 
   input        pcObject    - physical object name of an sdo       
                              Will be extended to support logical icf SDOs 
   input-output piocContext - Context from client to server 
                                Will return new context to client   
   input-output table phRowObjUpd - RowObjUpd table with changes
   output       pocMessages  - error messages in adm format
   output       pocUndoids   - list of failed rowobjupd ROwnums 
                       
 Notes:  The only difference from the remoteCommit method in data.p is the 
         objectname     
 
 History:
---------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

DEFINE INPUT PARAMETER pcObject            AS CHARACTER  NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER piocContext  AS CHARACTER  NO-UNDO.

DEFINE INPUT-OUTPUT PARAMETER TABLE-HANDLE phRowObjUpd1. 
DEFINE INPUT-OUTPUT PARAMETER TABLE-HANDLE phRowObjUpd2. 
DEFINE INPUT-OUTPUT PARAMETER TABLE-HANDLE phRowObjUpd3. 
DEFINE INPUT-OUTPUT PARAMETER TABLE-HANDLE phRowObjUpd4. 
DEFINE INPUT-OUTPUT PARAMETER TABLE-HANDLE phRowObjUpd5. 
DEFINE INPUT-OUTPUT PARAMETER TABLE-HANDLE phRowObjUpd6. 
DEFINE INPUT-OUTPUT PARAMETER TABLE-HANDLE phRowObjUpd7. 
DEFINE INPUT-OUTPUT PARAMETER TABLE-HANDLE phRowObjUpd8. 
DEFINE INPUT-OUTPUT PARAMETER TABLE-HANDLE phRowObjUpd9. 
DEFINE INPUT-OUTPUT PARAMETER TABLE-HANDLE phRowObjUpd10. 
DEFINE INPUT-OUTPUT PARAMETER TABLE-HANDLE phRowObjUpd11. 
DEFINE INPUT-OUTPUT PARAMETER TABLE-HANDLE phRowObjUpd12. 
DEFINE INPUT-OUTPUT PARAMETER TABLE-HANDLE phRowObjUpd13. 
DEFINE INPUT-OUTPUT PARAMETER TABLE-HANDLE phRowObjUpd14. 
DEFINE INPUT-OUTPUT PARAMETER TABLE-HANDLE phRowObjUpd15. 
DEFINE INPUT-OUTPUT PARAMETER TABLE-HANDLE phRowObjUpd16. 
DEFINE INPUT-OUTPUT PARAMETER TABLE-HANDLE phRowObjUpd17. 
DEFINE INPUT-OUTPUT PARAMETER TABLE-HANDLE phRowObjUpd18. 
DEFINE INPUT-OUTPUT PARAMETER TABLE-HANDLE phRowObjUpd19. 
DEFINE INPUT-OUTPUT PARAMETER TABLE-HANDLE phRowObjUpd20. 

DEFINE OUTPUT PARAMETER pocMessages AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER pocUndoIds  AS CHARACTER NO-UNDO.                                                                           
                                                                           



/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       committransaction.p
&scop object-version    000000

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
         HEIGHT             = 6.81
         WIDTH              = 80.4.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
DEFINE VARIABLE hObject    AS HANDLE  NO-UNDO.
DEFINE VARIABLE hRowObjUpd AS HANDLE  NO-UNDO.

DO ON STOP UNDO, LEAVE:   
  RUN VALUE(pcObject) PERSISTENT SET hObject NO-ERROR.   
END.

IF NOT VALID-HANDLE(hObject) THEN
DO:
  pocMessages = ERROR-STATUS:GET-MESSAGE(1).
  RETURN.
END.

/* As of current we call remoteCommitTransaction since we need to copy this to 
   the static table, but when the logic in bufferCommit becomes dynamic we
   will call setRowObjUpdTable and run bufferCommitTransaction as remoteCommit
   then will become inefficient as it is an extra copy of data */       

/**  Future code for dynamic sdo
loop or add an api to sbo: 
{set RowObjUpdTable phRowObjUpd hObject}.
    
RUN setContextAndInitialize IN hObject (piocContext).

RUN bufferCommitTransaction IN hObject (OUTPUT pocMessages, 
                             OUTPUT pocUndoIds).

RUN getContextAndDestroy IN hObject (OUTPUT piocContext).
***/

RUN remoteCommitTransaction IN hObject (
                             INPUT-OUTPUT piocContext, 
                             INPUT-OUTPUT TABLE-HANDLE phRowObjUpd1, 
                             INPUT-OUTPUT TABLE-HANDLE phRowObjUpd2, 
                             INPUT-OUTPUT TABLE-HANDLE phRowObjUpd3, 
                             INPUT-OUTPUT TABLE-HANDLE phRowObjUpd4, 
                             INPUT-OUTPUT TABLE-HANDLE phRowObjUpd5, 
                             INPUT-OUTPUT TABLE-HANDLE phRowObjUpd6, 
                             INPUT-OUTPUT TABLE-HANDLE phRowObjUpd7, 
                             INPUT-OUTPUT TABLE-HANDLE phRowObjUpd8, 
                             INPUT-OUTPUT TABLE-HANDLE phRowObjUpd9, 
                             INPUT-OUTPUT TABLE-HANDLE phRowObjUpd10,
                             INPUT-OUTPUT TABLE-HANDLE phRowObjUpd11, 
                             INPUT-OUTPUT TABLE-HANDLE phRowObjUpd12, 
                             INPUT-OUTPUT TABLE-HANDLE phRowObjUpd13, 
                             INPUT-OUTPUT TABLE-HANDLE phRowObjUpd14, 
                             INPUT-OUTPUT TABLE-HANDLE phRowObjUpd15, 
                             INPUT-OUTPUT TABLE-HANDLE phRowObjUpd16, 
                             INPUT-OUTPUT TABLE-HANDLE phRowObjUpd17, 
                             INPUT-OUTPUT TABLE-HANDLE phRowObjUpd18, 
                             INPUT-OUTPUT TABLE-HANDLE phRowObjUpd19, 
                             INPUT-OUTPUT TABLE-HANDLE phRowObjUpd20,
                             OUTPUT pocMessages, 
                             OUTPUT pocUndoIds).

RUN destroyObject IN hObject.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


