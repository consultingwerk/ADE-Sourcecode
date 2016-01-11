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
/* &ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12                                                   */
/* &ANALYZE-RESUME                                                                              */
/* &ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Check Version Notes Wizard" Procedure _INLINE        */
/* /* Actions: af/cod/aftemwizcw.w ? ? ? ? */                                                   */
/* /* MIP Update Version Notes Wizard                                                           */
/* Check object version notes.                                                                  */
/* af/cod/aftemwizpw.w                                                                          */
/* */                                                                                           */
/* /* _UIB-CODE-BLOCK-END */                                                                    */
/* &ANALYZE-RESUME                                                                              */
/*                                                                                              */
/* &ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Update-Object-Version" Procedure _INLINE             */
/* /* Actions: ? ? ? ? af/sup/afverxftrp.p */                                                   */
/* /* This has to go above the definitions sections, as that is what it modifies.               */
/*    If its not, then the definitions section will have been saved before the                  */
/*    XFTR code kicks in and changes it */                                                      */
/* /* _UIB-CODE-BLOCK-END */                                                                    */
/* &ANALYZE-RESUME                                                                              */
/*                                                                                              */
/* &ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Definition Comments Wizard" Procedure _INLINE        */
/* /* Actions: ? af/cod/aftemwizcw.w ? ? ? */                                                   */
/* /* Program Definition Comment Block Wizard                                                   */
/* Welcome to the Program Definition Comment Block Wizard. Press Next to proceed.               */
/* af/cod/aftemwizpw.w                                                                          */
/* */                                                                                           */
/* /* _UIB-CODE-BLOCK-END */                                                                    */
/* &ANALYZE-RESUME                                                                              */
/*                                                                                              */
/* &ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure                              */
/* /*---------------------------------------------------------------------------------          */
/*   File: gscobupdtp.p                                                                         */
/*                                                                                              */
/*   Description:  Collect gsc_object info                                                      */
/*                                                                                              */
/*   Purpose:      Collect gsc_object info                                                      */
/*                                                                                              */
/*   Parameters:   <none>                                                                       */
/*                                                                                              */
/*   History:                                                                                   */
/*   --------                                                                                   */
/*   (v:010000)    Task:        6962   UserRef:                                                 */
/*                 Date:   27/10/2000  Author:     Jenny Bond                                   */
/*                                                                                              */
/*   Update Notes: Created from Template aftemprocp.p                                           */
/*                                                                                              */
/* ---------------------------------------------------------------------------------*/          */
/* /*                   This .W file was created with the Progress UIB.             */          */
/* /*-------------------------------------------------------------------------------*/          */
/*                                                                                              */
/* /* ***************************  Definitions  ************************** */                   */
/* /* MIP-GET-OBJECT-VERSION pre-processors                                                     */
/*    The following pre-processors are maintained automatically when the object is              */
/*    saved. They pull the object and version from Roundtable if possible so that it            */
/*    can be displayed in the about window of the container */                                  */
/*                                                                                              */
/* &scop object-name       gscobupdtp.p                                                         */
/* DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.         */
/* &scop object-version    010000                                                               */
/*                                                                                              */
/*                                                                                              */
/* /* MIP object identifying preprocessor */                                                    */
/* &glob   mip-structured-procedure    yes                                                      */
/*                                                                                              */
/* {ry/inc/gscobttdef.i}                                                                        */
/* {af/sup2/afglobals.i}                                                                        */
/*                                                                                              */
/* DEFINE INPUT-OUTPUT PARAMETER TABLE FOR ttGscObject.                                         */
/*                                                                                              */
/*                                                                                              */
/* DEFINE VARIABLE hQuery              AS HANDLE       NO-UNDO.                                 */
/* DEFINE VARIABLE hBufferList         AS HANDLE       NO-UNDO EXTENT 20.                       */
/* DEFINE VARIABLE hBuffer             AS HANDLE       NO-UNDO.                                 */
/* DEFINE VARIABLE iLoop               AS INTEGER      NO-UNDO.                                 */
/* DEFINE VARIABLE iBuffer             AS INTEGER      NO-UNDO.                                 */
/* DEFINE VARIABLE lFirst              AS LOGICAL      NO-UNDO.                                 */
/* DEFINE VARIABLE cEmptyValue         AS CHARACTER    NO-UNDO.                                 */
/* DEFINE VARIABLE lOk                 AS LOGICAL      NO-UNDO.                                 */
/* DEFINE VARIABLE httGscObject        AS HANDLE       NO-UNDO.                                 */
/* DEFINE VARIABLE hdbGscObject        AS HANDLE       NO-UNDO.                                 */
/*                                                                                              */
/* /* _UIB-CODE-BLOCK-END */                                                                    */
/* &ANALYZE-RESUME                                                                              */
/*                                                                                              */
/*                                                                                              */
/* &ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK                                                     */
/*                                                                                              */
/* /* ********************  Preprocessor Definitions  ******************** */                   */
/*                                                                                              */
/* &Scoped-define PROCEDURE-TYPE Procedure                                                      */
/* &Scoped-define DB-AWARE no                                                                   */
/*                                                                                              */
/*                                                                                              */
/*                                                                                              */
/* /* _UIB-PREPROCESSOR-BLOCK-END */                                                            */
/* &ANALYZE-RESUME                                                                              */
/*                                                                                              */
/*                                                                                              */
/*                                                                                              */
/* /* *********************** Procedure Settings ************************ */                    */
/*                                                                                              */
/* &ANALYZE-SUSPEND _PROCEDURE-SETTINGS                                                         */
/* /* Settings for THIS-PROCEDURE                                                               */
/*    Type: Procedure                                                                           */
/*    Allow:                                                                                    */
/*    Frames: 0                                                                                 */
/*    Add Fields to: Neither                                                                    */
/*    Other Settings: CODE-ONLY COMPILE                                                         */
/*  */                                                                                          */
/* &ANALYZE-RESUME _END-PROCEDURE-SETTINGS                                                      */
/*                                                                                              */
/* /* *************************  Create Window  ************************** */                   */
/*                                                                                              */
/* &ANALYZE-SUSPEND _CREATE-WINDOW                                                              */
/* /* DESIGN Window definition (used by the UIB)                                                */
/*   CREATE WINDOW Procedure ASSIGN                                                             */
/*          HEIGHT             = 5.24                                                           */
/*          WIDTH              = 48.2.                                                          */
/* /* END WINDOW DEFINITION */                                                                  */
/*                                                                         */                   */
/* &ANALYZE-RESUME                                                                              */
/*                                                                                              */
/*                                                                                              */
/*                                                                                              */
/*                                                                                              */
/* &ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure                               */
/*                                                                                              */
/*                                                                                              */
/* /* ***************************  Main Block  *************************** */                   */
/*                                                                                              */
/* /* _UIB-CODE-BLOCK-END */                                                                    */
/* &ANALYZE-RESUME                                                                              */
/*                                                                                              */
/*                                                                                              */
/* /* **********************  Internal Procedures  *********************** */                   */
/*                                                                                              */
/* &IF DEFINED(EXCLUDE-readGscObject) = 0 &THEN                                                 */
/*                                                                                              */
/* &ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE readGscObject Procedure                          */
/* PROCEDURE readGscObject :                                                                    */
/* /*------------------------------------------------------------------------------             */
/*   Purpose:                                                                                   */
/*   Parameters:  <none>                                                                        */
/*   Notes:                                                                                     */
/* ------------------------------------------------------------------------------*/             */
/* DEFINE INPUT  PARAMETER pcBufferList    AS CHARACTER    NO-UNDO.                             */
/* DEFINE INPUT  PARAMETER pcForEach       AS CHARACTER    NO-UNDO.                             */
/*                                                                                              */
/*     /* Create a query */                                                                     */
/*     CREATE QUERY hQuery NO-ERROR.                                                            */
/*                                                                                              */
/*     buffer-loop:                                                                             */
/*     DO iLoop = 1 TO NUM-ENTRIES(pcBufferList):                                               */
/*         CREATE BUFFER hBufferList[iLoop] FOR TABLE ENTRY(iLoop,pcBufferList) NO-ERROR.       */
/*         IF ERROR-STATUS:ERROR THEN NEXT buffer-loop.                                         */
/*         hQuery:ADD-BUFFER(hBufferList[iLoop]) NO-ERROR.                                      */
/*     END. /* buffer-loop */                                                                   */
/*                                                                                              */
/*     /* Prepare the query */                                                                  */
/*     pcForEach = DYNAMIC-FUNCTION("fixQueryString":U IN gshSessionManager, INPUT pcForEach).  */
/*     lOk = hQuery:QUERY-PREPARE(pcForEach).                                                   */
/*                                                                                              */
/*     /* Open the query */                                                                     */
/*     hQuery:QUERY-OPEN() NO-ERROR.                                                            */
/*                                                                                              */
/*     /* do a quick check to see if query ok */                                                */
/*     query-loop:                                                                              */
/*     REPEAT:                                                                                  */
/*         hQuery:GET-NEXT().                                                                   */
/*         IF  NOT VALID-HANDLE(hBufferList[1])                                                 */
/*         OR  (VALID-HANDLE(hBufferList[1]) AND NOT hBufferList[1]:AVAILABLE)                  */
/*         OR  hQuery:QUERY-OFF-END THEN                                                        */
/*             LEAVE.                                                                           */
/*                                                                                              */
/*         CREATE ttGscObject.                                                                  */
/*                                                                                              */
/*         httGscObject = BUFFER ttGscObject:HANDLE.                                            */
/*         hdbGscObject = hQuery:GET-BUFFER-HANDLE.                                             */
/*         httGscObject:BUFFER-COPY (hdbGscObject).                                             */
/*     END.                                                                                     */
/*                                                                                              */
/*     DELETE OBJECT hQuery.                                                                    */
/*                                                                                              */
/* END PROCEDURE.                                                                               */
/*                                                                                              */
/* /* _UIB-CODE-BLOCK-END */                                                                    */
/* &ANALYZE-RESUME                                                                              */
/*                                                                                              */
/* &ENDIF                                                                                       */
/*                                                                                              */
/* &IF DEFINED(EXCLUDE-updateGscObject) = 0 &THEN                                               */
/*                                                                                              */
/* &ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updateGscObject Procedure                        */
/* PROCEDURE updateGscObject :                                                                  */
/* /*------------------------------------------------------------------------------             */
/*   Purpose:                                                                                   */
/*   Parameters:  <none>                                                                        */
/*   Notes:                                                                                     */
/* ------------------------------------------------------------------------------*/             */
/* FOR EACH ttGscObject NO-LOCK:                                                                */
/*     FIND gsc_object EXCLUSIVE-LOCK                                                           */
/*         WHERE gsc_object.object_filename = ttGscObject.object_filename NO-ERROR.             */
/*                                                                                              */
/*     IF NOT AVAILABLE gsc_object THEN DO:                                                     */
/*         IF  ttGscObject.object_obj > 0 THEN DO:                                              */
/*             /* some error handling */                                                        */
/*             RETURN ERROR.                                                                    */
/*         END.                                                                                 */
/*         ELSE DO:                                                                             */
/*             CREATE gsc_object NO-ERROR.                                                      */
/*             IF ERROR-STATUS:ERROR THEN                                                       */
/*                 RETURN ERROR.                                                                */
/*         END.                                                                                 */
/*     END.                                                                                     */
/*                                                                                              */
/*     BUFFER-COPY ttGscObject TO gsc_object NO-ERROR.                                          */
/*     IF ERROR-STATUS:ERROR THEN                                                               */
/*         RETURN ERROR "Error encountered while updating Data Base".                           */
/*                                                                                              */
/*     VALIDATE gsc_object NO-ERROR.                                                            */
/*     IF  ERROR-STATUS:ERROR THEN                                                              */
/*         RETURN ERROR "Error encountered while validating gsc_object".                        */
/* END.                                                                                         */
/*                                                                                              */
/* END PROCEDURE.                                                                               */
/*                                                                                              */
/* /* _UIB-CODE-BLOCK-END */                                                                    */
/* &ANALYZE-RESUME                                                                              */
/*                                                                                              */
/* &ENDIF                                                                                       */
/*                                                                                              */
/*                                                                                              */
