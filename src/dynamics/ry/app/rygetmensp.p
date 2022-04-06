&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*------------------------------------------------------------------------
  File        : ry/app/rygetmensp.p  
  Description:  To get bands, actions and categories as well as
                toolbarBands and objectBands from the repository. 
                
  Parameters:   pcToolbarList    - Comma-separated list of toolbars
                                   * wildcard to extract all toolbars
                pcObjectList     - Comma-separated list of objects 
                                   (optional semi-colon separated Runattribute)
                pcband           - A band  (menu_structure_reference)
                pdUserObj        - user key
                pdOrganisationOBj - org key                     
                ttToolbarBand    = gsm_toolbar_menu_structure
                ttObjectBand     = gsm_object_menu_structure
                ttBand           = gsm_menu_structure   
                ttBandAction     = gsm_menu_structure_item
                ttAction         = gsm_menu_item 
                ttCategory       = gsc_item_category
  
   Notes:      The three first parameters are independent of each other. 
               All three may be used or just one of them. 
 -----------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

&scop object-name       rygetmensp.p
&scop object-version    010204

/* MIP object identifying preprocessor */
&glob   mip-structured-procedure    yes

{defrescd.i}              /* Default Result Code */
{af/sup2/afglobals.i}     /* Astra global shared variables */

{src/adm2/ttaction.i}
{src/adm2/tttoolbar.i}

DEFINE INPUT PARAMETER  pcToolbarList               AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAMETER  pcObjectList            AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAMETER  pcBandList              AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAMETER  pdUserObj               AS DECIMAL    NO-UNDO.
DEFINE INPUT PARAMETER  pdOrganisationObj       AS DECIMAL    NO-UNDO.

DEFINE OUTPUT PARAMETER TABLE FOR ttToolbarBand.
DEFINE OUTPUT PARAMETER TABLE FOR ttObjectBand.
DEFINE OUTPUT PARAMETER TABLE FOR ttBand. 
DEFINE OUTPUT PARAMETER TABLE FOR ttBandAction. 
DEFINE OUTPUT PARAMETER TABLE FOR ttAction.
DEFINE OUTPUT PARAMETER TABLE FOR ttCategory.

&IF DEFINED(server-side) = 0 &THEN
   {ry/app/rymenufunc.i}
&ENDIF

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
DEFINE VARIABLE iObject                         AS INTEGER    NO-UNDO.
DEFINE VARIABLE iBand                           AS INTEGER    NO-UNDO.
DEFINE VARIABLE cObjectName                     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cRunAttribute                   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cClientResultCodes              AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cCurrentResultCode              AS CHARACTER  NO-UNDO.
DEFINE VARIABLE hCustomizationManager                  AS HANDLE     NO-UNDO.
DEFINE VARIABLE iResultCode                     AS INTEGER    NO-UNDO.
DEFINE VARIABLE dCustomizationResultObj         AS DECIMAL    NO-UNDO.
DEFINE VARIABLE lSecurityEnabled                AS LOGICAL    NO-UNDO.
DEFINE VARIABLE cSecurityModel                  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE lGSMMSSecurityExists            AS LOGICAL    NO-UNDO.
DEFINE VARIABLE lGSMMISecurityExists            AS LOGICAL    NO-UNDO.
DEFINE VARIABLE lRYCSOSecurityExists            AS LOGICAL    NO-UNDO.
DEFINE VARIABLE cProperties                     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE lTranslationEnabled             AS LOGICAL    NO-UNDO.
DEFINE VARIABLE dLoginLanguageObj               AS DECIMAL    NO-UNDO.

EMPTY TEMP-TABLE ttToolbarBand.
EMPTY TEMP-TABLE ttObjectBand.
EMPTY TEMP-TABLE ttBand.
EMPTY TEMP-TABLE ttBandAction.
EMPTY TEMP-TABLE ttAction.
EMPTY TEMP-TABLE ttCategory.

/* We need user specific information, find the record here so we don't need to refind it later. */
FIND gsm_user NO-LOCK
     WHERE gsm_user.user_obj = pdUserObj
     NO-ERROR.

IF NOT AVAILABLE gsm_user THEN
    RETURN.

ASSIGN hCustomizationManager = DYNAMIC-FUNCTION("getManagerHandle":U, "CustomizationManager":U)
       cClientResultCodes    = IF VALID-HANDLE(hCustomizationManager) 
                               THEN DYNAMIC-FUNCTION("getClientResultCodes":U IN hCustomizationManager)
                               ELSE "":U
       cProperties           = DYNAMIC-FUNCTION("getPropertyList":U IN gshSessionManager, INPUT "SecurityEnabled,SecurityModel,GSMMSSecurityExists,GSMMISecurityExists,RYCSOSecurityExists,translationEnabled,currentLanguageObj":U, INPUT YES)
       lSecurityEnabled      = ENTRY(1, cProperties, CHR(3)) <> "NO":U
       cSecurityModel        = ENTRY(2, cProperties, CHR(3))
       lGSMMSSecurityExists  = ENTRY(3, cProperties, CHR(3)) <> "NO":U
       lGSMMISecurityExists  = ENTRY(4, cProperties, CHR(3)) <> "NO":U
       lRYCSOSecurityExists  = ENTRY(5, cProperties, CHR(3)) <> "NO":U
       lTranslationEnabled   = ENTRY(6, cProperties, CHR(3))  = "YES":U
       dLoginLanguageObj     = DECIMAL(ENTRY(7, cProperties, CHR(3)))
       NO-ERROR.

IF cClientResultCodes = ? 
OR cClientResultCodes = "?":U
OR cClientResultCodes = "":U THEN
    ASSIGN cClientResultCodes = "{&DEFAULT-RESULT-CODE}":U.

/* If we want all toolbars, get all the toolbar names. Cycling through the       *
 * gsm_toolbar_menu_structure table is much easier than finding the smartToolbar *
 * class and all its sub-classes and then toolbar objects from those. */
IF pcToolbarList = "*":U 
THEN DO:
    ASSIGN pcToolbarList = "":U.
    FOR EACH gsm_toolbar_menu_structure NO-LOCK
       BREAK BY gsm_toolbar_menu_structure.object_obj:

        IF FIRST-OF(gsm_toolbar_menu_structure.object_obj) 
        THEN DO:
            FIND ryc_smartobject NO-LOCK
                 WHERE ryc_smartobject.smartobject_obj = gsm_toolbar_menu_structure.object_obj
                 NO-ERROR.

            IF AVAILABLE ryc_smartobject THEN
                ASSIGN pcToolbarList = pcToolbarList + ",":U + ryc_smartobject.object_filename.
        END.
    END.
    ASSIGN pcToolbarList = SUBSTRING(pcToolbarList, 2) NO-ERROR.
END.

/* Cycle through all the result codes for the session, building our toolbars by overlaying result code toolbar items over each other */
result-code-block:
DO iResultCode = NUM-ENTRIES(cClientResultCodes) TO 1 BY -1:

    ASSIGN cCurrentResultCode      = ENTRY(iResultCode, cClientResultCodes)
           dCustomizationResultObj = 0.

    /* The &DEFAULT-RESULT-CODE does not really exist, so trying to find it is not possible, so check to get the correct *
     * customization_result_obj to be used to find the ryc_smartobject record with                                       */
    IF cCurrentResultCode <> "{&DEFAULT-RESULT-CODE}":U
    THEN DO:
        FIND ryc_customization_result NO-LOCK
             WHERE ryc_customization_result.customization_result_code = cCurrentResultCode 
             NO-ERROR.

        IF AVAILABLE ryc_customization_result THEN
            ASSIGN dCustomizationResultObj = ryc_customization_result.customization_result_obj.
    END.

    /* Extract toolbar bands and actions */
    IF pcToolbarList <> "":U THEN
        toolbar-blk:
        DO iObject = 1 TO NUM-ENTRIES(pcToolbarList):
            ASSIGN cObjectName = ENTRY(iObject, pcToolbarList).

            IF cObjectName = "":U THEN
                NEXT toolbar-blk.

            RUN extractBandsAndActions IN TARGET-PROCEDURE (INPUT cObjectName,
                                                            INPUT dCustomizationResultObj,
                                                            INPUT cCurrentResultCode,
                                                            INPUT "toolbar":U,
                                                            INPUT "":U, /* No run attribute for toolbars */
                                                            INPUT gsm_user.development_user,
                                                            INPUT lSecurityEnabled,
                                                            INPUT cSecurityModel,
                                                            INPUT lGSMMSSecurityExists,
                                                            INPUT lGSMMISecurityExists,
                                                            INPUT lRYCSOSecurityExists,
                                                            INPUT lTranslationEnabled,
                                                            INPUT dLoginLanguageObj,
                                                            INPUT pdUserObj,
                                                            INPUT pdOrganisationObj).
        END.

  /* Extract object specific bands and actions */
  IF pcObjectList <> '':U THEN
      object-blk:
      DO iObject = 1 TO NUM-ENTRIES(pcObjectList):
          ASSIGN cObjectName   = ENTRY(iObject,pcObjectList)
                 cRunattribute = IF NUM-ENTRIES(cObjectName,';':U) > 1 THEN ENTRY(2,cObjectName,';':U) ELSE '':U
                 cObjectName   = ENTRY(1,cObjectName,';':U).

          IF cObjectName = "":U THEN
              NEXT object-blk.

          RUN extractBandsAndActions IN TARGET-PROCEDURE (INPUT cObjectName,
                                                          INPUT dCustomizationResultObj,
                                                          INPUT cCurrentResultCode,
                                                          INPUT "container":U,
                                                          INPUT cRunAttribute,
                                                          INPUT gsm_user.development_user,
                                                          INPUT lSecurityEnabled,
                                                          INPUT cSecurityModel,
                                                          INPUT lGSMMSSecurityExists,
                                                          INPUT lGSMMISecurityExists,
                                                          INPUT lRYCSOSecurityExists,
                                                          INPUT lTranslationEnabled,
                                                          INPUT dLoginLanguageObj,
                                                          INPUT pdUserObj,
                                                          INPUT pdOrganisationObj).
      END.
END.

IF pcBandList <> "":U THEN
    band-blk:
    DO iBand = 1 TO NUM-ENTRIES(pcBandList):
      
        IF ENTRY(iBand,pcBandList) = "":U THEN
            NEXT band-blk.

        RUN extractBand IN TARGET-PROCEDURE (INPUT ENTRY(iBand,pcBandList),
                                             INPUT gsm_user.development_user,
                                             INPUT lSecurityEnabled,
                                             INPUT cSecurityModel,
                                             INPUT lGSMMSSecurityExists,
                                             INPUT lGSMMISecurityExists,
                                             INPUT lRYCSOSecurityExists,
                                             INPUT lTranslationEnabled,
                                             INPUT dLoginLanguageObj,
                                             INPUT pdUserObj,
                                             INPUT pdOrganisationObj).
    END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


