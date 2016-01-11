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
  File: afsdocrdbp.p

  Description:  Create SDO records in GSCOB and RYCS0

  Purpose:      Create SDO records in GSCOB (gsc_object) and RYCS0 (ryc_smartobject).

  Parameters:   input full object name including path
                input procedure type if known, e.g. SmartDataObject
                input product module code if known
                input object description if known
                input prompt user yes/no
                output error text (Always filled in - caller can display it or not)

  History:
  --------
  (v:010000)    Task:        6430   UserRef:    
                Date:   11/08/2000  Author:     Jenny Bond

  Update Notes: Created from Template rytemprocp.p.  Inital coding.

  (v:010001)    Task:        6844   UserRef:    
                Date:   16/10/2000  Author:     Marcia Bouwman

  Update Notes: Add error messages.

  (v:010002)    Task:        6844   UserRef:    
                Date:   16/10/2000  Author:     Marcia Bouwman

  Update Notes: Add return-value to error message to cater for errors returning from the versioning
                system.

  (v:010003)    Task:        6517   UserRef:    
                Date:   28/11/2000  Author:     Jenny Bond

  Update Notes: REMOVE some validation.
                Improve error checking.
                Validate rtb_object.module exists, rather than rtb_object.pmod.  (Pmod is the
                product module, module is the workspace module.  Different product modules
                can point to the same workspace module.)

  (v:010004)    Task:        7361   UserRef:    
                Date:   22/12/2000  Author:     Anthony Swindells

  Update Notes: Allow product module changes in RV and track changes. Bug where product
                module does not match workspace module - as is the case for partner sites.

  (v:010005)    Task:           0   UserRef:    IZ 2381
                Date:   10/12/2001  Author:     John Palazzo

  Update Notes: IZ 2381 : Repository always asks to save static object.
                Fix: Several updates here. Code no longer returns immediately when object
                is found in repository. This allows updates of objects to take place. pcError
                was only being updated when prompt was yes. Now value is always set. It is
                up to caller to decide to show error messages or not related to pcError. Added
                coding for getting propath relative pathname to store in object_path. File
                may not always be stored in the same path as the product module. Also allow
                a blank relative path. Don't know why that was considered invalid.

-----------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       afsdocrdbp.p
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000


/* Astra object identifying preprocessor */
&glob   AstraProcedure    yes

{af/sup2/afglobals.i}

DEFINE INPUT  PARAMETER pcFullFileName  AS CHARACTER    NO-UNDO.
DEFINE INPUT  PARAMETER pcObjectType    AS CHARACTER    NO-UNDO.
DEFINE INPUT  PARAMETER pcModuleCode    AS CHARACTER    NO-UNDO.
DEFINE INPUT  PARAMETER pcDescription   AS CHARACTER    NO-UNDO.
DEFINE INPUT  PARAMETER plPromptUser    AS LOGICAL      NO-UNDO.
DEFINE OUTPUT PARAMETER pcError         AS CHARACTER    NO-UNDO.

DEFINE VARIABLE cErrorMessage       AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cButton             AS CHARACTER    NO-UNDO.

/* &IF "{&scmTool}" = "RTB":U */
/* Define required RTB global shared variables - used for RTB integration hooks (if installed) */
DEFINE NEW GLOBAL SHARED VARIABLE grtb-wspace-id    AS CHARACTER    NO-UNDO.

{af/sup2/afcheckerr.i
    &define-only=YES
}

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
         HEIGHT             = 7.95
         WIDTH              = 46.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

DEFINE VARIABLE cObjectName     AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cObjectExt      AS CHARACTER    NO-UNDO. /* File extension */
DEFINE VARIABLE cObjectFileName AS CHARACTER    NO-UNDO. /* Filename without the path and extension */ 
DEFINE VARIABLE cAnswer         AS CHARACTER    NO-UNDO.
DEFINE VARIABLE lCreateObject   AS LOGICAL      NO-UNDO.
DEFINE VARIABLE cDescription    AS CHARACTER    NO-UNDO.
DEFINE VARIABLE iLoop           AS INTEGER      NO-UNDO.
DEFINE VARIABLE rRowid          AS ROWID        NO-UNDO.
DEFINE VARIABLE cRelativePath   AS CHARACTER    NO-UNDO.

DEFINE VARIABLE hScmTool        AS HANDLE       NO-UNDO.

/*  none layout must exist */
FIND ryc_layout NO-LOCK
    WHERE ryc_layout.layout_name = "None":U NO-ERROR.
IF  NOT AVAILABLE ryc_layout THEN
DO:
  ASSIGN pcError = "Not added to repository. Layout name 'None' does not exist".
  RETURN.
END.

/* If dynamic object, then do not ask to add it to repository as it should
   already be there. */
IF INDEX(pcFullFileName, ".ado") > 0 THEN
DO:
  ASSIGN pcError = "Not added to repository. Object has .ado extension".
  RETURN.
END.

/* see if object already exists in repository */
/* strip off object path */
ASSIGN
    cObjectName = REPLACE(pcFullFileName, "\", "/")
    cObjectName = TRIM(ENTRY(NUM-ENTRIES(cObjectName, "/":U), cObjectName, "/")).
    IF R-INDEX(cObjectName,".") > 0 THEN DO:
       cObjectExt = ENTRY(NUM-ENTRIES(cObjectName,"."),cObjectName,".").
       cObjectFileName = REPLACE(cObjectName,("." + cObjectExt),"").
    END.
/* First Assume that filename includes the extension for gsc_object */

/* IZ 2381 : Why can't we save again? Description and path may have changed. Commenting out. jep-icf */
/*
IF CAN-FIND(FIRST gsc_object WHERE gsc_object.OBJECT_filename = cObjectName) AND
   CAN-FIND(FIRST ryc_smartobject WHERE ryc_smartobject.OBJECT_filename = cObjectName) THEN
  RETURN. /* already exists ok */
/* Now check with the file extension as a separate field */
IF cObjectExt <> "" THEN
    IF CAN-FIND(FIRST gsc_object WHERE gsc_object.OBJECT_filename = cObjectFileName
                AND gsc_object.OBJECT_Extension = cObjectExt) AND
       CAN-FIND(FIRST ryc_smartobject WHERE ryc_smartobject.OBJECT_filename = cObjectName) THEN
      RETURN. /* already exists ok */
*/

/* If object type not passed in, request the user for it. */
IF (pcObjectType = "":U OR  
    NOT CAN-FIND(FIRST gsc_object_type WHERE gsc_object_type.object_type_code = pcObjectType) )
    AND plPromptUser =  YES THEN
  RUN getObjectType (INPUT-OUTPUT pcObjectType).

/* set-up real object type as defined in repository */
CASE pcObjectType:
  WHEN "SmartDataObject":U THEN
    ASSIGN pcObjectType = "SDO":U.
  WHEN "SmartBusinessObject":U THEN
    ASSIGN pcObjectType = "SBO":U.
  WHEN "SmartDataViewer":U THEN
    ASSIGN pcObjectType = "StaticSDV":U.
  WHEN "SmartDataBrowser":U THEN
    ASSIGN pcObjectType = "StaticSDB":U.
  WHEN "SmartObject":U THEN
    ASSIGN pcObjectType = "StaticSO":U.
END CASE.

/* See if valid repository object type and if not, just exit */
FIND FIRST gsc_object_type NO-LOCK
     WHERE gsc_object_type.OBJECT_type_code = pcObjectType
     NO-ERROR.
IF NOT AVAILABLE gsc_object_type THEN
DO:
  ASSIGN pcError = "Not added to repository. Object type: " + pcObjectType + " does not exist".
  RETURN.
END.

/* If we get here, then it is an object we are interested in and it does not exist */

/* Run SCM API Procedure */

IF NOT VALID-HANDLE(hScmTool)
AND CONNECTED("rtb":U)
AND (SEARCH("rtb/prc/afrtbprocp.p":U) <> ?
  OR SEARCH("rtb/prc/afrtbprocp.p":U) <> ?)
THEN
  RUN rtb/prc/afrtbprocp.p PERSISTENT SET hScmTool.

/* work out product module */
ASSIGN
  cRelativePath = "":U.

IF pcModuleCode = "":U THEN
DO:

  IF VALID-HANDLE(hScmTool) THEN
  DO:
    RUN scmGetObjectModule IN hScmTool (INPUT grtb-wspace-id,
                                        INPUT cObjectName,
                                        INPUT pcObjectType /* "PCODE":U */ ,
                                        OUTPUT pcModuleCode,
                                        OUTPUT cRelativePath).  
  END.

  /* try and work out product module from path of object */
  IF pcModuleCode = "":U THEN RUN getModule (INPUT pcFullFileName, OUTPUT pcModuleCode).
END.

/* check product module is valid and if not blank it so we will ask for it */
IF pcModuleCode <> "":U AND  
   NOT CAN-FIND(FIRST gsc_product_module WHERE gsc_product_module.product_module_code = pcModuleCode) THEN
  ASSIGN pcModuleCode = "":U.


IF VALID-HANDLE(hScmTool)
AND pcModuleCode <> "":U
AND cRelativePath = "":U
THEN
  RUN scmGetModuleDir IN hScmTool (INPUT pcModuleCode,
                                   OUTPUT cRelativePath).  

ASSIGN
  cButton = "":U.

module-loop:
DO WHILE pcModuleCode = "":U AND plPromptUser = YES:
  RUN askQuestion IN gshSessionManager (INPUT        "Specify the product module code for object: " + cObjectName + " to add object to repository database", 
                                                                          /* message to display */
                                        INPUT        "&OK,&Cancel":U,     /* button list */
                                        INPUT        "&OK":U,             /* default button */ 
                                        INPUT        "&Cancel":U,         /* cancel button */
                                        INPUT        "Enter Product Module":U, /* window title */
                                        INPUT        "character":U,                /* data type of question */ 
                                        INPUT        "x(10)":U,                /* format mask for question */ 
                                        INPUT-OUTPUT pcModuleCode,             /* character value of answer to question */ 
                                              OUTPUT cButton              /* button pressed */
                                        ).
  IF cButton = "&Cancel" THEN LEAVE module-loop.

    IF pcModuleCode <> "":U
    AND NOT CAN-FIND(FIRST gsc_product_module WHERE gsc_product_module.product_module_code = pcModuleCode
                                              AND gsc_product_module.relative_path <> "":U)
    THEN
      ASSIGN
        pcModuleCode = "":U.

  IF VALID-HANDLE(hScmTool)
  AND pcModuleCode <> "":U
  AND NOT CAN-FIND(FIRST gsc_product_module WHERE gsc_product_module.product_module_code = pcModuleCode)
  THEN
    ASSIGN
      pcModuleCode = "":U.

END.
IF cButton = "&Cancel" THEN 
DO:
  IF VALID-HANDLE(hScmTool) THEN RUN killPlip IN hScmTool.
  ERROR-STATUS:ERROR = NO.
  RETURN.
END.

/* now have a valid product module code */
FIND FIRST gsc_product_module NO-LOCK
     WHERE gsc_product_module.product_module_code = pcModuleCode NO-ERROR.
IF NOT AVAILABLE gsc_product_module THEN
DO:
  ASSIGN pcError = "Not added to repository. Product module does not exist".
  IF VALID-HANDLE(hScmTool) THEN RUN killPlip IN hScmTool.
  ERROR-STATUS:ERROR = NO.
  RETURN.
END.

/* get correct object path */
IF cRelativePath = "":U THEN
DO:
  /* IZ 2381 : If the relative path hasn't been determined by now, 
     defer to the PROPATH relative path in case file is saved in path
     other than the product module's path. jep-icf */
  RUN getRelativePath (INPUT pcFullFileName, OUTPUT cRelativePath).

  /* IZ 2381 : Propath is better judge of where the object is. Commetning out. jep-icf
  ASSIGN cRelativePath = gsc_product_module.relative_path. */
END.

/* IZ 2381 : Why is a blank path not valid? Files don't have to be
   in a subdirectory. Commenting this out. jep-icf */
/*
IF cRelativePath = "":U THEN
DO:
  ASSIGN pcError = "Not added to repository. Could not evaulate relative path for product module".
  IF VALID-HANDLE(hScmTool) THEN RUN killPlip IN hScmTool.
  ERROR-STATUS:ERROR = NO.
  RETURN.
END.
*/

/* Only ask if want to continue if not already asked for a product module */
IF cButton = "":U  AND plPromptUser = YES THEN
DO:
  RUN askQuestion IN gshSessionManager (INPUT         "Do you want to add object: " + cObjectName + " to the repository database", 
                                                                          /* message to display */
                                        INPUT        "&YES,&NO":U,        /* button list */
                                        INPUT        "&YES":U,            /* default button */ 
                                        INPUT        "&NO":U,             /* cancel button */
                                        INPUT        "":U,                /* window title */
                                        INPUT        "":U,                /* data type of question */ 
                                        INPUT        "":U,                /* format mask for question */ 
                                        INPUT-OUTPUT cAnswer,             /* character value of answer to question */ 
                                              OUTPUT cButton              /* button pressed */
                                        ).

  IF  cButton = "&NO" THEN
  DO:
    IF VALID-HANDLE(hScmTool) THEN RUN killPlip IN hScmTool.
    ERROR-STATUS:ERROR = NO.
    RETURN.
  END.
END.

FIND FIRST gsc_object NO-LOCK
     WHERE gsc_object.OBJECT_filename = cObjectName NO-ERROR.
IF NOT AVAILABLE gsc_object THEN
    FIND FIRST gsc_object NO-LOCK WHERE gsc_object.Object_filename = cObjectFileName
                AND gsc_object.Object_Extension = cObjectExt NO-ERROR.
FIND FIRST ryc_smartobject NO-LOCK
     WHERE ryc_smartobject.object_filename = gsc_object.Object_filename NO-ERROR.

IF pcDescription = "":U THEN
  RUN getDescription (INPUT pcFullFileName, OUTPUT pcDescription). 

/* Update description in SCM if can */
IF VALID-HANDLE(hScmTool)
AND pcDescription <> "":U
THEN DO:
  RUN scmUpdateObjectDescription IN hScmTool (INPUT grtb-wspace-id,
                                              INPUT cObjectName,
                                              INPUT "PCODE":U,
                                              INPUT NO,
                                              INPUT pcDescription).  
END.


IF pcDescription = "":U THEN ASSIGN pcDescription = cObjectName.

DEFINE BUFFER bugsc_object      FOR gsc_object.
DEFINE BUFFER buryc_smartobject FOR ryc_smartobject.

ASSIGN cMessageList = "":U.
trn-block:
DO FOR bugsc_object, buryc_smartobject TRANSACTION ON ERROR UNDO trn-block, LEAVE trn-block:
    FIND bugsc_object EXCLUSIVE-LOCK
        WHERE bugsc_object.object_filename = cObjectName NO-ERROR.
    IF NOT AVAILABLE bugsc_object AND cObjectExt <> "" THEN
        FIND bugsc_object EXCLUSIVE-LOCK
            WHERE bugsc_object.OBJECT_filename = cObjectFileName AND
                  bugsc_object.OBJECT_Extension = cObjectExt
                  NO-ERROR.
    IF  NOT AVAILABLE bugsc_object THEN
    DO:
      CREATE bugsc_object NO-ERROR.
      {af/sup2/afcheckerr.i &no-return = YES}    
      IF cMessageList <> "":U THEN UNDO trn-block, LEAVE trn-block.
      
      /* Only update name for new records, and now always use name without an extension */
      ASSIGN
        bugsc_object.object_filename         = (IF pcObjectType = "SDO":U OR pcObjectType = "StaticSDV" THEN
                                                cObjectFileName ELSE cObjectName)
        bugsc_object.Object_Extension        = (IF pcObjectType = "SDO":U OR pcObjectType = "StaticSDV" THEN
                                                cObjectExt ELSE "")
        .
    END.

    ASSIGN
        bugsc_object.object_type_obj         = gsc_object_type.object_type_obj
        bugsc_object.product_module_obj      = gsc_product_module.product_module_obj
        bugsc_object.object_description      = pcDescription
        bugsc_object.object_path             = cRelativePath
        bugsc_object.toolbar_multi_media_obj = 0
        bugsc_object.toolbar_image_filename  = "":U
        bugsc_object.tooltip_text            = pcDescription
        bugsc_object.runnable_from_menu      = NO
        bugsc_object.disabled                = NO
        bugsc_object.run_persistent          = YES
        bugsc_object.run_when                = "ANY":U
        bugsc_object.security_object_obj     = bugsc_object.object_obj
        bugsc_object.container_object        = NO
        bugsc_object.physical_object_obj     = 0
        bugsc_object.logical_object          = NO
        bugsc_object.generic_object          = NO
        bugsc_object.required_db_list        = "":U NO-ERROR.

    {af/sup2/afcheckerr.i &no-return = YES}    
    IF cMessageList <> "":U THEN UNDO trn-block, LEAVE trn-block.

    VALIDATE bugsc_object NO-ERROR.
    {af/sup2/afcheckerr.i &no-return = YES}    
    IF cMessageList <> "":U THEN UNDO trn-block, LEAVE trn-block.

    FIND buryc_smartobject EXCLUSIVE-LOCK
        WHERE buryc_smartobject.object_filename = bugsc_object.object_filename NO-ERROR.
    IF  NOT AVAILABLE buryc_smartobject THEN
    DO:
      CREATE buryc_smartobject NO-ERROR.
      {af/sup2/afcheckerr.i &no-return = YES}    
      IF cMessageList <> "":U THEN UNDO trn-block, LEAVE trn-block.
    END.

    ASSIGN
        buryc_smartobject.layout_obj             = IF  AVAILABLE ryc_layout THEN ryc_layout.layout_obj ELSE 0
        buryc_smartobject.object_type_obj        = bugsc_object.object_type_obj
        buryc_smartobject.object_obj             = bugsc_object.object_obj
        buryc_smartobject.object_filename        = bugsc_object.object_filename
        buryc_smartobject.product_module_obj     = bugsc_object.product_module_obj
        buryc_smartobject.static_object          = YES
        buryc_smartobject.custom_super_procedure = "":U
        buryc_smartobject.system_owned           = NO
        buryc_smartobject.shutdown_message_text  = "":U
        buryc_smartobject.sdo_smartobject_obj    = ?
        buryc_smartobject.template_smartobject   = NO NO-ERROR.

    {af/sup2/afcheckerr.i &no-return = YES}    
    IF cMessageList <> "":U THEN UNDO trn-block, LEAVE trn-block.

    VALIDATE buryc_smartobject NO-ERROR.
    {af/sup2/afcheckerr.i &no-return = YES}    
    IF cMessageList <> "":U THEN UNDO trn-block, LEAVE trn-block.

END. /* transaction block */

IF cMessageList <> "":U THEN
DO:
  IF plPromptUser = NO THEN
    ASSIGN pcError = "Object not added to repository. " + cMessageList.
  ELSE
    RUN showMessages IN gshSessionManager (INPUT  cMessageList,                             /* message to display */
                                           INPUT  "ERR":U,                                  /* error type */
                                           INPUT  "&OK":U,                                  /* button list */
                                           INPUT  "&OK":U,                                  /* default button */ 
                                           INPUT  "&OK":U,                                  /* cancel button */
                                           INPUT  "Repository Update Failed":U,             /* error window title */
                                           INPUT  YES,                                      /* display if empty */ 
                                           INPUT  ?,                                        /* container handle */ 
                                           OUTPUT cButton                                   /* button pressed */
                                          ).
END.
ELSE IF plPromptUser = YES THEN
DO:
  RUN showMessages IN gshSessionManager (INPUT  "Repository records created succesfully", /* message to display */
                                         INPUT  "INF":U,                                  /* error type */
                                         INPUT  "&OK":U,                                  /* button list */
                                         INPUT  "&OK":U,                                  /* default button */ 
                                         INPUT  "&OK":U,                                  /* cancel button */
                                         INPUT  "Information":U,                          /* error window title */
                                         INPUT  YES,                                      /* display if empty */ 
                                         INPUT  ?,                                        /* container handle */ 
                                         OUTPUT cButton                                   /* button pressed */
                                        ).
END.

IF VALID-HANDLE(hScmTool) THEN RUN killPlip IN hScmTool.
ERROR-STATUS:ERROR = NO.
RETURN.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-getDescription) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDescription Procedure 
PROCEDURE getDescription :
/*------------------------------------------------------------------------------
  Purpose:     Try and work out object description by reading file
  Parameters:  input filename with full path
               output description
  Notes:       assumes Astra standards for code 
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER pcFileName                 AS CHARACTER    NO-UNDO.
DEFINE OUTPUT PARAMETER pcFileDesc                AS CHARACTER    NO-UNDO.

DEFINE VARIABLE cFullFileName                     AS CHARACTER    NO-UNDO.

ASSIGN cFullFileName = SEARCH(pcFullFileName).
IF cFullFileName = ? THEN RETURN.

/* We have a file, check file contents */
DEFINE VARIABLE iLineCount      AS INTEGER      NO-UNDO INITIAL 1.
DEFINE VARIABLE cProcedureType  AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cLine           AS CHARACTER    NO-UNDO.

INPUT FROM VALUE(cFullFileName).

REPEAT:
    IMPORT UNFORMATTED cLine.

    IF INDEX(cLine, "Description:":U) > 0 THEN
    DO:
      ASSIGN
          pcFileDesc = TRIM(SUBSTRING(cLine, R-INDEX(cLine, ":") + 1)).
      LEAVE.
    END.

    iLineCount = iLineCount + 1.
    IF   iLineCount > 100 THEN
        LEAVE.
END.

INPUT CLOSE.

RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getModule) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getModule Procedure 
PROCEDURE getModule :
/*------------------------------------------------------------------------------
  Purpose:     Try and work out product module using filename
  Parameters:  input filename with full path
               output module
  Notes:       assumes Astra naming conventions for modules 
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER pcFileName                 AS CHARACTER    NO-UNDO.
DEFINE OUTPUT PARAMETER pcModule                  AS CHARACTER    NO-UNDO.

DEFINE VARIABLE iPos1                             AS INTEGER      NO-UNDO.
DEFINE VARIABLE iPos2                             AS INTEGER      NO-UNDO.
DEFINE VARIABLE iPos3                             AS INTEGER      NO-UNDO.
DEFINE VARIABLE iLen                              AS INTEGER      NO-UNDO.

ASSIGN
  pcFileName = REPLACE(pcFileName,"\":U,"/":U)
  iPos1 = INDEX(pcFileName,"/obj":U).

IF iPos1 > 2 THEN
  ASSIGN iPos2 = R-INDEX(pcFileName,"/":U,iPos1 - 1).

IF iPos1 > 2 THEN
  ASSIGN iPos3 = INDEX(pcFileName,"/":U,iPos1 + 1).

ASSIGN
  iLen = iPos3 - iPos2.

IF iLen > 0 THEN
  ASSIGN pcModule = REPLACE(SUBSTRING(pcFileName,iPos2 + 1,iLen),"/":U,"-":U).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getObjectType) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getObjectType Procedure 
PROCEDURE getObjectType :
/*------------------------------------------------------------------------------
  Purpose:     Request Object Type.
  Parameters:  input-output pcobject_type_code
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT-OUTPUT PARAMETER pcObject_type_code  AS CHARACTER    NO-UNDO.
    
    ASSIGN
      cButton = "":U.
    
    type-loop:
    DO WHILE pcObject_type_code = "":U AND plPromptUser = YES:
      RUN askQuestion IN gshSessionManager (INPUT        "Specify the object type code for object: " + cObjectName + " to add object to repository database", 
                                                                              /* message to display */
                                            INPUT        "&OK,&Cancel":U,     /* button list */
                                            INPUT        "&OK":U,             /* default button */ 
                                            INPUT        "&Cancel":U,         /* cancel button */
                                            INPUT        "Enter Object Type Code":U, /* window title */
                                            INPUT        "character":U,       /* data type of question */ 
                                            INPUT        "x(20)":U,           /* format mask for question */ 
                                            INPUT-OUTPUT pcObject_type_code,  /* character value of answer to question */ 
                                                  OUTPUT cButton              /* button pressed */
                                            ).
      IF cButton = "&Cancel" THEN LEAVE type-loop.
    
      IF pcObject_type_code <> "":U AND 
         NOT CAN-FIND(FIRST gsc_object_type WHERE gsc_object_type.object_type_code = pcObject_type_code) THEN
        ASSIGN pcObject_type_code = "":U.
    END.
    IF cButton = "&Cancel" THEN 
    DO:
      IF VALID-HANDLE(hScmTool) THEN RUN killPlip IN hScmTool.
    END.
    
    ERROR-STATUS:ERROR = NO.
    ASSIGN cButton ="".
    RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getRelativePath) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getRelativePath Procedure 
PROCEDURE getRelativePath :
/*------------------------------------------------------------------------------
  Purpose:     Given a filename, returns the propath relative path.
  Parameters:  pFullFilename
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pFullFilename   AS CHARACTER  NO-UNDO.
    DEFINE OUTPUT PARAMETER pRelativePath   AS CHARACTER  NO-UNDO.

    DEFINE VARIABLE cFilename        AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cSavedPath       AS CHARACTER  NO-UNDO.
    
    RUN adecomm/_relfile.p
        (INPUT pFullFilename, INPUT NO /* plCheckRemote */,
         INPUT "" /* pcOptions */, OUTPUT pRelativePath).
    RUN adecomm/_osprefx.p
        (INPUT pRelativePath, OUTPUT pRelativePath, OUTPUT cFilename).
    /* Trim trailing directory slashes (\ or /) and replace remaining ones with
       forward slash for portability with how repository stores paths. */
    ASSIGN pRelativePath = REPLACE(LC(RIGHT-TRIM(pRelativePath, '~\/')), "~\", "/").
    RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

