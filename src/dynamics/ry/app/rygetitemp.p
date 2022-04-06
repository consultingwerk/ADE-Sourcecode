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
                
  Parameters:   pcCategories     - Comma-separated list of Categories to load.  
                pcActionList     - Comma-separated list of Actions to load. 
                ttAction         = gsm_menu_item 
                ttCategory       = gsc_item_category
  
   Notes:      The two first parameters are independent of each other. 
 -----------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

&scop object-name       rygetitemp.p
&scop object-version    010200

/* MIP object identifying preprocessor */
&glob   mip-structured-procedure    yes

{af/sup2/afglobals.i}     /* Astra global shared variables */

{src/adm2/ttaction.i}


DEFINE INPUT PARAMETER  pcCategories            AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAMETER  pcActions               AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAMETER  pdUserObj               AS DECIMAL    NO-UNDO.
DEFINE INPUT PARAMETER  pdOrganisationObj       AS DECIMAL    NO-UNDO.

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
DEFINE VARIABLE cCategory AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cAction   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE iCategory AS INTEGER    NO-UNDO.
DEFINE VARIABLE iAction   AS INTEGER    NO-UNDO.

/* These variable and buffer definitions are used in {ry/app/rymenuitmc.i} */
DEFINE VARIABLE lSecured              AS LOGICAL    NO-UNDO.
DEFINE VARIABLE cSecurityDummyValue   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE dContainerObjectObj   AS DECIMAL    NO-UNDO.
DEFINE VARIABLE cContainerName        AS CHARACTER  NO-UNDO.
DEFINE VARIABLE lPersistent           AS LOGICAL    NO-UNDO.
DEFINE VARIABLE cLogicalObject        AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cRequiredDBList       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cAttribute            AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cProperties           AS CHARACTER  NO-UNDO.
DEFINE VARIABLE dTransLanguageObj     AS DECIMAL    NO-UNDO.
DEFINE VARIABLE plDevelopmentUser     AS LOGICAL    NO-UNDO.
DEFINE VARIABLE plSecurityEnabled     AS LOGICAL    NO-UNDO.
DEFINE VARIABLE pcSecurityModel       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE plGSMMSSecurityExists AS LOGICAL    NO-UNDO.
DEFINE VARIABLE plGSMMISecurityExists AS LOGICAL    NO-UNDO.
DEFINE VARIABLE plRYCSOSecurityExists AS LOGICAL    NO-UNDO.
DEFINE VARIABLE plTranslationEnabled  AS LOGICAL    NO-UNDO.
DEFINE VARIABLE pdLoginLanguageObj    AS DECIMAL    NO-UNDO.

DEFINE BUFFER gsm_menu_item            FOR gsm_menu_item.
DEFINE BUFFER bgsm_menu_item           FOR gsm_menu_item.
DEFINE BUFFER parent_item_category     FOR gsc_item_category.
DEFINE BUFFER gsc_item_category        FOR gsc_item_category.
DEFINE BUFFER ryc_smartobject          FOR ryc_smartobject.
DEFINE BUFFER gsm_user                 FOR gsm_user.
DEFINE BUFFER gsc_instance_attribute   FOR gsc_instance_attribute.
DEFINE BUFFER gsm_translated_menu_item FOR gsm_translated_menu_item.

FIND gsm_user NO-LOCK
     WHERE gsm_user.user_obj = pdUserObj
     NO-ERROR.

IF NOT AVAILABLE gsm_user THEN
    RETURN.

ASSIGN plDevelopmentUser      = gsm_user.development_user
       cProperties            = DYNAMIC-FUNCTION("getPropertyList":U IN gshSessionManager, INPUT "SecurityEnabled,SecurityModel,GSMMSSecurityExists,GSMMISecurityExists,RYCSOSecurityExists,translationEnabled,currentLanguageObj":U, INPUT YES)       
       plSecurityEnabled      = ENTRY(1, cProperties, CHR(3)) <> "NO":U
       pcSecurityModel        = ENTRY(2, cProperties, CHR(3))
       plGSMMSSecurityExists  = ENTRY(3, cProperties, CHR(3)) <> "NO":U
       plGSMMISecurityExists  = ENTRY(4, cProperties, CHR(3)) <> "NO":U
       plRYCSOSecurityExists  = ENTRY(5, cProperties, CHR(3)) <> "NO":U
       plTranslationEnabled   = ENTRY(6, cProperties, CHR(3))  = "YES":U
       pdLoginLanguageObj     = DECIMAL(ENTRY(7, cProperties, CHR(3)))
       NO-ERROR.

EMPTY TEMP-TABLE ttAction.
EMPTY TEMP-TABLE ttCategory.

IF pcCategories <> '':U THEN
    category-blk:
    DO iAction = 1 TO NUM-ENTRIES(pcCategories):

        ASSIGN cCategory = ENTRY(iAction,pcCategories).

        FIND gsc_item_category NO-LOCK 
             WHERE gsc_item_category.item_category_label = cCategory 
             NO-ERROR.
      
        IF AVAILABLE gsc_item_category THEN
            FOR EACH bgsm_menu_item NO-LOCK 
               WHERE bgsm_menu_item.item_category_obj = gsc_item_category.item_category_obj:

                FIND ttAction
                     WHERE ttAction.menu_item_obj = bgsm_menu_item.menu_item_obj
                     NO-ERROR.

                IF NOT AVAILABLE ttAction 
                THEN DO:
                    {
                     ry/app/rymenuitmc.i &MENU-ITEM-OBJ = bgsm_menu_item.menu_item_obj
                                         &UNDO-PHRASE   = "NEXT category-blk"
                    }
                END.
            END.
    END.

IF pcActions <> '':U THEN
    action-blk:
    DO iAction = 1 TO NUM-ENTRIES(pcActions): 

        ASSIGN cAction = ENTRY(iAction,pcActions).

        FIND ttAction NO-LOCK
             WHERE ttAction.action = cAction
             NO-ERROR.

        IF NOT AVAILABLE ttAction 
        THEN DO:
            FIND bgsm_menu_item NO-LOCK 
                 WHERE bgsm_menu_item.menu_item_reference = cAction 
                 NO-ERROR.
    
            IF AVAILABLE bgsm_menu_item 
            THEN DO:
                {
                 ry/app/rymenuitmc.i &MENU-ITEM-OBJ = bgsm_menu_item.menu_item_obj
                                     &UNDO-PHRASE   = "NEXT action-blk"
                }
            END.
        END.
    END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


