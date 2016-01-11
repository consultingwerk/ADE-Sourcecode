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
  File: rycoiplipp.p

  Description:  gsc_object Plip

  Purpose:      Contains procedures for reading/updating gsc_object into a temp-table and
                passing temp-table back and forth to calling procedure.

  Parameters:   input-output table for gsc_object defined like rowobjupd

  History:
  --------
  (v:010000)    Task:        6962   UserRef:    
                Date:   14/11/2000  Author:     Jenny Bond

  Update Notes: Created from Template rytemplipp.p

  (v:010100)    Task:    90000052   UserRef:    POSSE
                Date:   03/05/2001  Author:     Phil Magnay

  Update Notes: OK

--------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       rycoiplipp.p
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    010100

/* Astra object identifying preprocessor */
&glob   AstraPlip    yes

DEFINE VARIABLE cObjectName         AS CHARACTER NO-UNDO.

ASSIGN cObjectName = "{&object-name}":U.

&scop   mip-notify-user-on-plip-close   NO

{af/sup2/afglobals.i}

&SCOPED-DEFINE ttName ttRycObjectInstance
{ry/inc/rycoittdef.i}
&UNDEFINE ttName

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
         HEIGHT             = 10.24
         WIDTH              = 47.8.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB Procedure 
/* ************************* Included-Libraries *********************** */

{src/adm/method/attribut.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME





&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  ******************************* */

{ry/app/ryplipmain.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-fetchDBRecords) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE fetchDBRecords Procedure 
PROCEDURE fetchDBRecords :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT        PARAMETER pcForEach     AS CHARACTER    NO-UNDO.
DEFINE INPUT        PARAMETER pcAction      AS CHARACTER    NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER phTTHandle    AS HANDLE       NO-UNDO.

RUN ry/app/rydynqrytt.p (INPUT pcForEach, INPUT pcAction, INPUT-OUTPUT phTTHandle).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-killPlip) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE killPlip Procedure 
PROCEDURE killPlip :
/*------------------------------------------------------------------------------
  Purpose:     entry point to instantly kill the plip if it should get lost in memory
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

{ry/app/ryplipkill.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-objectDescription) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE objectDescription Procedure 
PROCEDURE objectDescription :
/*------------------------------------------------------------------------------
  Purpose:     Pass out a description of the PLIP, used in Plip temp-table
  Parameters:  <none>
  Notes:       This should be changed manually for each plip
------------------------------------------------------------------------------*/

DEFINE OUTPUT PARAMETER cDescription AS CHARACTER NO-UNDO.

ASSIGN cDescription = "Dynamics gsc_object PLIP".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-plipSetup) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE plipSetup Procedure 
PROCEDURE plipSetup :
/*------------------------------------------------------------------------------
  Purpose:    Run by main-block of PLIP at startup of PLIP
  Parameters: <none>
  Notes:       
------------------------------------------------------------------------------*/

{ry/app/ryplipsetu.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-plipShutdown) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE plipShutdown Procedure 
PROCEDURE plipShutdown :
/*------------------------------------------------------------------------------
  Purpose:     This procedure will be run just before the calling program 
               terminates
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

{ry/app/ryplipshut.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-readGscObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE readGscObject Procedure 
PROCEDURE readGscObject :
/*------------------------------------------------------------------------------
  Purpose:      Populate temp table with DB record
  Parameters:   INPUT  PARAMETER pcBufferList
                    list of buffers for query
                INPUT  PARAMETER pcForEach   
                    query to read DB    
                INPUT-OUTPUT PARAMETER TABLE FOR ttGscObject
                    table defined like rowobjupd table for gscobfullo.w
  Notes:       
------------------------------------------------------------------------------*/
/*DEFINE INPUT  PARAMETER pcBufferList    AS CHARACTER    NO-UNDO.*/
/*DEFINE INPUT  PARAMETER pcForEach       AS CHARACTER    NO-UNDO.*/
/*DEFINE INPUT-OUTPUT PARAMETER TABLE FOR ttGscObject.*/
/*DEFINE INPUT-OUTPUT PARAMETER TABLE FOR ttRycAttributeValue.*/
/**/
/**/
/*DEFINE VARIABLE plAdd               AS LOGICAL      NO-UNDO.*/
/**/
/*DEFINE VARIABLE hQuery              AS HANDLE       NO-UNDO.*/
/*DEFINE VARIABLE hBufferList         AS HANDLE       NO-UNDO EXTENT 20.*/
/*DEFINE VARIABLE hBuffer             AS HANDLE       NO-UNDO.*/
/*DEFINE VARIABLE iLoop               AS INTEGER      NO-UNDO.*/
/*DEFINE VARIABLE iBuffer             AS INTEGER      NO-UNDO.*/
/*DEFINE VARIABLE lOk                 AS LOGICAL      NO-UNDO.*/
/*DEFINE VARIABLE httGscObject        AS HANDLE       NO-UNDO.*/
/*DEFINE VARIABLE hdbGscObject        AS HANDLE       NO-UNDO.*/
/*DEFINE VARIABLE httColumn           AS HANDLE       NO-UNDO.*/
/*DEFINE VARIABLE hdbColumn           AS HANDLE       NO-UNDO.*/
/**/
/*    /* Create a query */*/
/*    CREATE QUERY hQuery NO-ERROR.*/
/*    */
/*    buffer-loop:*/
/*    DO iLoop = 1 TO NUM-ENTRIES(pcBufferList):*/
/*        CREATE BUFFER hBufferList[iLoop] FOR TABLE ENTRY(iLoop, pcBufferList) NO-ERROR.*/
/*        IF ERROR-STATUS:ERROR THEN NEXT buffer-loop.*/
/*        hQuery:ADD-BUFFER(hBufferList[iLoop]) NO-ERROR.*/
/*        {af/sup2/afcheckerr.i}*/
/*    END. /* buffer-loop */*/
/**/
/*    /* Prepare the query */*/
/*    IF pcForEach <> "" THEN DO:*/
/*        lOk = hQuery:QUERY-PREPARE(pcForEach) NO-ERROR.*/
/*        {af/sup2/afcheckerr.i}*/
/*    END.*/
/*    ELSE lOk = NO.*/
/*  */
/*    IF lOk THEN DO:*/
/*    /* Open the query */*/
/*        hQuery:QUERY-OPEN() NO-ERROR.*/
/*        {af/sup2/afcheckerr.i}*/
/*    END.*/
/**/
/*    QueryLoop:*/
/*    REPEAT:*/
/*        IF  lOk THEN*/
/*            hQuery:GET-NEXT().*/
/**/
/*        IF  NOT VALID-HANDLE(hBufferList[1]) THEN*/
/*            LEAVE QueryLoop.*/
/**/
/*        IF  VALID-HANDLE(hBufferList[1]) AND NOT hBufferList[1]:AVAILABLE THEN*/
/*            ASSIGN*/
/*                plAdd = YES.*/
/**/
/*        IF  ((VALID-HANDLE(hBufferList[1]) AND NOT hBufferList[1]:AVAILABLE)*/
/*        OR  hQuery:QUERY-OFF-END) AND NOT plAdd THEN*/
/*            LEAVE QueryLoop.*/
/**/
/*        CREATE ttGscObject.*/
/**/
/*        httGscObject = BUFFER ttGscObject:HANDLE.*/
/*        hdbGscObject = hQuery:GET-BUFFER-HANDLE.*/
/**/
/*        FieldsLoop:*/
/*        DO iLoop = 1 TO httGscObject:NUM-FIELDS:*/
/*            httColumn = httGscObject:BUFFER-FIELD(iLoop) NO-ERROR.*/
/*            hdbColumn = hdbGscObject:BUFFER-FIELD(httColumn:NAME) NO-ERROR.*/
/**/
/*            IF httColumn = ? OR hdbColumn = ? THEN NEXT FieldsLoop.*/
/*            */
/*            IF NOT plAdd THEN*/
/*                httColumn:BUFFER-VALUE = hdbColumn:BUFFER-VALUE.*/
/*            ELSE*/
/*                httColumn:BUFFER-VALUE = IF httColumn:INITIAL = ? THEN "":U*/
/*                    ELSE IF httColumn:DATA-TYPE = "DATE":U AND httColumn:INITIAL = "TODAY":U THEN STRING(TODAY)*/
/*                    ELSE httColumn:INITIAL NO-ERROR.*/
/*        END.*/
/*        */
/*        ttGscObject.RowIdent       = STRING(hdbGscObject:ROWID).*/
/*        ttGscObject.changedFields = "gsc_object.container_object     */
/*                                     gsc_object.DISABLED             */
/*                                     gsc_object.generic_object       */
/*                                     gsc_object.logical_object       */
/*                                     gsc_object.object_description   */
/*                                     gsc_object.object_filename      */
/*                                     gsc_object.object_obj           */
/*                                     gsc_object.object_path          */
/*                                     gsc_object.object_type_obj      */
/*                                     gsc_object.physical_object_obj  */
/*                                     gsc_object.product_module_obj   */
/*                                     gsc_object.required_db_list     */
/*                                     gsc_object.runnable_from_menu   */
/*                                     gsc_object.run_persistent       */
/*                                     gsc_object.run_when             */
/*                                     gsc_object.security_object_obj  */
/*                                     gsc_object.toolbar_image_filename*/
/*                                     gsc_object.toolbar_multi_media_obj*/
/*                                     gsc_object.tooltip_text".*/
/**/
/*        IF  plAdd THEN*/
/*            LEAVE QueryLoop.*/
/*    END.*/
/**/
/*    DELETE OBJECT hQuery.*/
/*    ASSIGN*/
/*        hQuery = ?*/
/*        ERROR-STATUS:ERROR = NO.*/
/**/
/**/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-updateRycObjectInstance) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updateRycObjectInstance Procedure 
PROCEDURE updateRycObjectInstance :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT-OUTPUT PARAMETER TABLE FOR ttRycObjectInstance.

DEFINE VARIABLE cErrorMessage   AS CHARACTER    NO-UNDO INITIAL "":u.
DEFINE VARIABLE iLoop           AS INTEGER      NO-UNDO.
DEFINE VARIABLE cUndoRowIds     AS CHARACTER    NO-UNDO.
DEFINE VARIABLE hSDO            AS HANDLE       NO-UNDO.

DEFINE BUFFER bttRycObjectInstance FOR ttRycObjectInstance.

FOR EACH ttRycObjectInstance
    WHERE ttRycObjectInstance.rowMod = "D":u:
    FIND bttRycObjectInstance
        WHERE bttRycObjectInstance.rowIdent = ttRycObjectInstance.rowIdent 
        AND   bttRycObjectInstance.rowMod = "":u NO-ERROR.
    IF  AVAILABLE bttRycObjectInstance THEN
        DELETE bttRycObjectInstance.
    ELSE DO:
        /***DIAG***/
        MESSAGE {&line-number} PROGRAM-NAME(1) SKIP
            "ERROR-STATUS:GET-MESSAGE(1) " ERROR-STATUS:GET-MESSAGE(1)
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
    END.
END.


RUN ry/obj/rycoifullo.w PERSISTENT SET hSDO ON gshAstraAppserver NO-ERROR.
IF  ERROR-STATUS:ERROR OR RETURN-VALUE <> "":u  THEN DO:
    cErrorMessage = IF cErrorMessage = "":u THEN RETURN-VALUE ELSE cErrorMessage + CHR(3) + RETURN-VALUE.

    IF ERROR-STATUS:ERROR THEN DO iLoop = 1 TO ERROR-STATUS:NUM-MESSAGES:
        cErrorMessage = IF cErrorMessage = "":u THEN ERROR-STATUS:GET-MESSAGE(iLoop)
                        ELSE cErrorMessage + CHR(3) + ERROR-STATUS:GET-MESSAGE(iLoop).
    END.
    RETURN ERROR cErrorMessage.
END.

RUN initializeObject IN hSDO NO-ERROR.
IF  ERROR-STATUS:ERROR OR RETURN-VALUE <> "":u  THEN DO:
    cErrorMessage = IF cErrorMessage = "":u THEN RETURN-VALUE ELSE cErrorMessage + CHR(3) + RETURN-VALUE.

    IF ERROR-STATUS:ERROR THEN DO iLoop = 1 TO ERROR-STATUS:NUM-MESSAGES:
        cErrorMessage = IF cErrorMessage = "":u THEN ERROR-STATUS:GET-MESSAGE(iLoop)
                        ELSE cErrorMessage + CHR(3) + ERROR-STATUS:GET-MESSAGE(iLoop).
    END.
    RUN destroyObject IN hSDO.
    RETURN ERROR cErrorMessage.
END.

DYNAMIC-FUNCTION("setCheckCurrentChanged":U IN hSDO, INPUT FALSE).

RUN serverCommit IN hSDO (INPUT-OUTPUT TABLE ttRycObjectInstance, OUTPUT cErrorMessage, OUTPUT cUndoRowIds) NO-ERROR.
IF  ERROR-STATUS:ERROR OR RETURN-VALUE <> "":u  THEN DO:
    cErrorMessage = IF cErrorMessage = "":u THEN RETURN-VALUE ELSE cErrorMessage + CHR(3) + RETURN-VALUE.

    IF ERROR-STATUS:ERROR THEN DO iLoop = 1 TO ERROR-STATUS:NUM-MESSAGES:
        cErrorMessage = IF cErrorMessage = "":u THEN ERROR-STATUS:GET-MESSAGE(iLoop)
                        ELSE cErrorMessage + CHR(3) + ERROR-STATUS:GET-MESSAGE(iLoop).
    END.
    RUN destroyObject IN hSDO.
    RETURN ERROR cErrorMessage.
END.

RUN destroyObject IN hSDO.

RETURN cErrorMessage.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF
