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

    DEFINE BUFFER b_ryc_smartobject FOR ryc_smartobject.
    DEFINE BUFFER ryc_smartObject   FOR ryc_smartObject.

    FIND FIRST ryc_smartobject NO-LOCK
         WHERE ryc_smartobject.OBJECT_filename          = pcObjectName
           AND ryc_smartobject.customization_result_obj = 0
         NO-ERROR.

    IF NOT AVAILABLE ryc_smartobject THEN
        IF R-INDEX(pcObjectName,".") > 0 
        THEN DO:
           ASSIGN cObjectExt      = ENTRY(NUM-ENTRIES(pcObjectName,"."),pcObjectName,".")
                  cObjectFileName = REPLACE(pcObjectName,("." + cObjectExt),"").
           FIND FIRST ryc_smartobject NO-LOCK
                WHERE ryc_smartobject.Object_FileName          = cObjectFileName 
                  AND ryc_smartobject.Object_Extension         = cObjectExt
                  AND ryc_smartobject.customization_result_obj = 0
                NO-ERROR.
        END.

    IF NOT AVAILABLE ryc_smartobject THEN 
        RETURN ERROR "Physical object " + pcObjectName + " not available".

    IF (NOT ryc_smartobject.static_object)
    THEN DO:
        FIND FIRST b_ryc_smartobject NO-LOCK
             WHERE b_ryc_smartobject.smartobject_obj = ryc_smartobject.physical_smartobject_obj 
             NO-ERROR.

        IF NOT AVAILABLE b_ryc_smartobject THEN 
            RETURN ERROR "Logical object for " + pcObjectName + " not available".

        ASSIGN pcLogicalName  = pcObjectName
               cFullPath      = LC(TRIM(REPLACE(b_ryc_smartobject.object_path,"~\":U,"/":U)))
               cFullPath      = cFullPath 
                              + (IF LENGTH(cFullPath) > 0 AND SUBSTRING(cFullPath,LENGTH(cFullPath)) <> "/":U THEN "/":U ELSE "":U) 
                              + LC(TRIM(b_ryc_smartobject.OBJECT_filename) 
                              + (IF b_ryc_smartobject.Object_Extension <> "" THEN ".":U + b_ryc_smartobject.Object_Extension ELSE "":U))
               pcPhysicalName = cFullPath.
    END.
    ELSE
        ASSIGN pcLogicalName  = ""
               cFullPath      = LC(TRIM(REPLACE(ryc_smartobject.object_path,"~\":U,"/":U)))
               cFullPath      = cFullPath 
                              + (IF LENGTH(cFullPath) > 0 AND SUBSTRING(cFullPath,LENGTH(cFullPath)) <> "/":U THEN "/":U ELSE "":U) 
                              + LC(TRIM(ryc_smartobject.OBJECT_filename) 
                              + (IF ryc_smartobject.Object_Extension <> "" THEN ".":U + ryc_smartobject.Object_Extension ELSE "":U))
               pcPhysicalName = cFullPath.

    /* Neil B start */
    DEFINE BUFFER bryc_smartobject FOR ryc_smartobject.

    DEFINE VARIABLE cCustomObjectPath AS CHARACTER  NO-UNDO.

    IF  ryc_smartobject.custom_smartobject_obj <> 0
    AND ryc_smartobject.custom_smartobject_obj <> ? 
    THEN DO:
       FIND bryc_smartobject NO-LOCK
            WHERE bryc_smartobject.smartobject_obj = ryc_smartobject.custom_smartobject_obj
            NO-ERROR.
    
       IF AVAILABLE bryc_smartobject
       THEN DO:
           ASSIGN cCustomObjectPath = REPLACE(bryc_smartobject.object_path, "~\":U, "/":U).

           IF R-INDEX(cCustomObjectPath, "/":U) <> LENGTH(cCustomObjectPath) THEN
               ASSIGN cCustomObjectPath = cCustomObjectPath + "/":U.

           ASSIGN pcCustomSuperProc = cCustomObjectPath + bryc_smartobject.object_filename
                                    + (IF bryc_smartobject.object_extension <> "":U AND bryc_smartobject.object_extension <> ?
                                       THEN ".":U + bryc_smartobject.object_extension
                                       ELSE "":U).
       END.
    END.
    /* Neil B end */

    RETURN.

    /*--   EOF  --*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


