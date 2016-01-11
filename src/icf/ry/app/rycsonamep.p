&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12
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
/*------------------------------------------------------------------------
    File        : 
    Purpose     :

    Syntax      :

    Description :

    Author(s)   :
    Created     :
    Notes       :
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

DEFINE INPUT  PARAMETER pcObjectName        AS CHARACTER            NO-UNDO.
DEFINE OUTPUT PARAMETER pcPhysicalName      AS CHARACTER            NO-UNDO.
DEFINE OUTPUT PARAMETER pcLogicalName       AS CHARACTER            NO-UNDO.
DEFINE OUTPUT PARAMETER pcCustomSuperProc   AS CHARACTER            NO-UNDO.

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
         HEIGHT             = 15
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

    DEFINE VARIABLE cFullPath       AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cObjectExt      AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cObjectFileName AS CHARACTER NO-UNDO.

    DEFINE BUFFER b_gsc_object FOR gsc_object.
    DEFINE BUFFER ryc_smartObject               FOR ryc_smartObject.

    FIND FIRST gsc_object NO-LOCK
        WHERE gsc_object.OBJECT_filename = pcObjectName
        NO-ERROR.
    IF NOT AVAILABLE gsc_object THEN DO:
        IF R-INDEX(pcObjectName,".") > 0 THEN DO:
           cObjectExt = ENTRY(NUM-ENTRIES(pcObjectName,"."),pcObjectName,".").
           cObjectFileName = REPLACE(pcObjectName,("." + cObjectExt),"").
           FIND FIRST gsc_object NO-LOCK
               WHERE gsc_object.Object_FileName = cObjectFileName AND
                     gsc_object.Object_Extension = cObjectExt
                     NO-ERROR.
        END.
    END.

    IF NOT AVAILABLE gsc_object THEN RETURN ERROR "Physical object not available".

    IF gsc_object.logical_object THEN
    DO:
        FIND FIRST b_gsc_object NO-LOCK
            WHERE b_gsc_object.Object_obj = gsc_object.physical_object_obj 
            NO-ERROR.

        IF NOT AVAILABLE b_gsc_object THEN RETURN ERROR "Logical object not available".

        pcLogicalName = pcObjectName.
        cFullPath = LC(TRIM(REPLACE(b_gsc_object.object_path,"~\":U,"/":U))).
        cFullPath = cFullPath +
                    (IF LENGTH(cFullPath) > 0 AND SUBSTRING(cFullPath,LENGTH(cFullPath)) <> "/":U THEN "/":U ELSE "":U) +
                     LC(TRIM(b_gsc_object.OBJECT_filename) 
                       + (IF b_gsc_object.Object_Extension <> "" THEN ".":U + b_gsc_object.Object_Extension ELSE "":U) ).
        pcPhysicalName = cFullPath.
    END.
    ELSE DO:
        pcLogicalName = "".
        cFullPath = LC(TRIM(REPLACE(gsc_object.object_path,"~\":U,"/":U))).
        cFullPath = cFullPath +
                    (IF LENGTH(cFullPath) > 0 AND SUBSTRING(cFullPath,LENGTH(cFullPath)) <> "/":U THEN "/":U ELSE "":U) +
                     LC(TRIM(gsc_object.OBJECT_filename) 
                        + (IF gsc_object.Object_Extension <> "" THEN ".":U + gsc_object.Object_Extension ELSE "":U)).
        pcPhysicalName = cFullPath.
    END.

    FIND FIRST ryc_smartObject WHERE
               ryc_smartObject.object_obj = gsc_object.object_obj
               NO-LOCK NO-ERROR.
    IF AVAILABLE ryc_smartObject                   AND
       ryc_smartObject.custom_super_procedure NE ? THEN
        ASSIGN pcCustomSuperProc = ryc_smartObject.custom_super_procedure.

    RETURN.
    /*--   EOF  --*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


