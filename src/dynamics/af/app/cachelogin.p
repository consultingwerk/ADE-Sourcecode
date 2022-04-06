&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12
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
/*************************************************************/  
/* Copyright (c) 1984-2005 by Progress Software Corporation  */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from PROGRESS Software Corporation. */
/*************************************************************/
/*---------------------------------------------------------------------------------
  File: logincache.p
  Description:  Fetches info needed by client for login
  Purpose:      This procedure retrieves all information needed by the client session for login.

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   05/28/2002  Author:     

  Update Notes: Created from Template rytemprocp.p
                Created from Template logincache.p

---------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       cachelogin.p
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000


/* object identifying preprocessor */
&glob   AstraProcedure    yes

{src/adm2/globals.i}

/* This is some of the stuff we're going to send back to the client session */

{af/sup2/afttcombo.i}       /* Combo data            */
{af/app/afttglobalctrl.i}   /* Global control cache  */
{af/app/afttsecurityctrl.i} /* Security Cache        */
{af/app/gsttenmn.i}         /* Entity Mnemonic Cache */
{af/app/aftttranslate.i}    /* Translations */
{af/app/logintt.i}

/* These TABLE-HANDLEs are needed to call retrieveClassCache, but are not passed back to the client. *
 * On login, they should be empty.                                                                   */

DEFINE VARIABLE hClassAttributeTable25 AS HANDLE NO-UNDO.
DEFINE VARIABLE hClassAttributeTable26 AS HANDLE NO-UNDO.
DEFINE VARIABLE hClassAttributeTable27 AS HANDLE NO-UNDO.
DEFINE VARIABLE hClassAttributeTable28 AS HANDLE NO-UNDO.
DEFINE VARIABLE hClassAttributeTable29 AS HANDLE NO-UNDO.
DEFINE VARIABLE hClassAttributeTable30 AS HANDLE NO-UNDO.
DEFINE VARIABLE hClassAttributeTable31 AS HANDLE NO-UNDO.
DEFINE VARIABLE hClassAttributeTable32 AS HANDLE NO-UNDO.

&SCOPED-DEFINE CLASSES-TO-CACHE-ON-STARTUP DataField,DynBrow,DynButton,DynCombo,~
DynComboBox,DynEditor,DynFillin,DynFold,DynImage,DynLookup,~
DynMenc,DynObjc,DynRadioSet,DynRectangle,DynSdf,DynText,DynToggle,DynTree,DynView,SDO,SBO,SmartToolbar,SmartFolder,staticSDV,smartViewer

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
   Compile into: dynamics/af/app
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
         HEIGHT             = 21.05
         WIDTH              = 94.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

DEFINE OUTPUT PARAMETER TABLE-HANDLE httTranslate.           

DEFINE OUTPUT PARAMETER pcNumericDecimalPoint  AS CHARACTER  NO-UNDO.
DEFINE OUTPUT PARAMETER pcNumericSeparator     AS CHARACTER  NO-UNDO.
DEFINE OUTPUT PARAMETER pcNumericFormat        AS CHARACTER  NO-UNDO.
DEFINE OUTPUT PARAMETER pcDateFormat           AS CHARACTER  NO-UNDO.

DEFINE OUTPUT PARAMETER TABLE-HANDLE httEntityMnemonic.              
DEFINE OUTPUT PARAMETER TABLE-HANDLE httLoginUser.                         
DEFINE OUTPUT PARAMETER TABLE-HANDLE httGlobalControl.                
DEFINE OUTPUT PARAMETER TABLE-HANDLE httSecurityControl.              
DEFINE OUTPUT PARAMETER TABLE-HANDLE httComboData.

DEFINE VARIABLE hTableHandleDummy AS HANDLE     NO-UNDO.
DEFINE VARIABLE hQuery            AS HANDLE     NO-UNDO.
DEFINE VARIABLE hField            AS HANDLE     NO-UNDO.
DEFINE VARIABLE iCnt              AS INTEGER    NO-UNDO.
DEFINE VARIABLE cLoginFilename    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cLoginFileRcode   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cAbbrUserTab      AS CHARACTER  NO-UNDO.


/*-----------------------------------------------------------------------------------------------------------*
 * This procedure will be run on the Appserver, and will return all information needed by the login process. *
 *-----------------------------------------------------------------------------------------------------------*/

/* 1 - Cache entity mnemonic records, the gen manager wants these. (redundant, these are now fetched as repository objects by the rep manager)

RUN gsgetenmnp IN gshGenManager (OUTPUT TABLE ttEntityMnemonic).

ASSIGN httEntityMnemonic = TEMP-TABLE ttEntityMnemonic:HANDLE.
*/

/* 2 - Cache user information, the login viewer wants this. */

/* We only cache the user information if the the "abbreviatedUserTable" session
   parameter has been set for the AppServer. If it has been set, we won't 
   cache this data now. */
cAbbrUserTab = DYNAMIC-FUNCTION("getSessionParam":U IN THIS-PROCEDURE,
                                "abbreviatedUserTable":U).
IF cAbbrUserTab <> "YES":U OR
   cAbbrUserTab = ? THEN
  RUN getLoginUserInfo IN gshSessionManager (OUTPUT TABLE ttLoginUser).

ASSIGN httLoginUser = TEMP-TABLE ttLoginUser:HANDLE NO-ERROR.

/* 7 - Retrieve global control and security info.             *
 *     This information is requested from the login procedure */

RUN af/app/afgetgansp.p (OUTPUT TABLE ttGlobalControl,
                         OUTPUT TABLE ttSecurityControl).

ASSIGN httGlobalControl = TEMP-TABLE ttGlobalControl:HANDLE.

/* 4 & 5 - Find out if translations have been enabled and set the translationsEnabled property. */

RUN getSecurityControl IN gshSecurityManager (OUTPUT TABLE ttSecurityControl).

FIND FIRST ttSecurityControl NO-ERROR.

IF NOT AVAILABLE ttSecurityControl OR ttSecurityControl.translation_enabled = YES THEN
    DYNAMIC-FUNCTION("setPropertyList":U IN gshSessionManager,
                                   INPUT "translationEnabled":U,
                                   INPUT "YES":U,
                                   INPUT NO).
ELSE
    DYNAMIC-FUNCTION("setPropertyList":U IN gshSessionManager,
                                   INPUT "translationEnabled":U,
                                   INPUT "NO":U,
                                   INPUT NO).

ASSIGN httSecurityControl = TEMP-TABLE ttSecurityControl:HANDLE.

/* 6 - Get the Appserver date and time formats, the login window wants these. */

ASSIGN pcNumericDecimalPoint = SESSION:NUMERIC-DECIMAL-POINT
       pcNumericSeparator    = SESSION:NUMERIC-SEPARATOR
       pcNumericFormat       = SESSION:NUMERIC-FORMAT
       pcDateFormat          = SESSION:DATE-FORMAT.

/* 8 - Resolve the login combo query.                                               *
 *     This information is requested from the login procedure, from populateCombos. */

EMPTY TEMP-TABLE ttComboData.

CREATE ttComboData.
ASSIGN ttComboData.cWidgetName        = "coLanguage":U
       ttComboData.hWidget            = ?
       ttComboData.cForEach           = "FOR EACH gsc_language NO-LOCK BY gsc_language.language_name":U
       ttComboData.cBufferList        = "gsc_language":U
       ttComboData.cKeyFieldName      = "gsc_language.language_obj":U
       ttComboData.cDescFieldNames    = "gsc_language.language_name,gsc_language.language_code":U
       ttComboData.cDescSubstitute    = "&1 (":U + CHR(1) + "&2":U + CHR(1) + ")":U /* Put the language code in entry 2, we're going to use it elsewhere */
       ttComboData.cFlag              = "N":U
       ttComboData.cCurrentKeyValue   = "":U
       ttComboData.cListItemDelimiter = CHR(3)
       ttComboData.cListItemPairs     = "":U
       ttComboData.cCurrentDescValue  = "":U.

CREATE ttComboData.
ASSIGN ttComboData.cWidgetName        = "coCompany":U
       ttComboData.hWidget            = ?
       ttComboData.cForEach           = "FOR EACH gsm_login_company NO-LOCK 
                                            WHERE gsm_login_company.login_company_disabled = NO 
                                               BY gsm_login_company.login_company_name":U 
       ttComboData.cBufferList        = "gsm_login_company":U
       ttComboData.cKeyFieldName      = "gsm_login_company.login_company_obj":U
       ttComboData.cDescFieldNames    = "gsm_login_company.login_company_name,gsm_login_company.login_company_code":U
       ttComboData.cDescSubstitute    = "&1 (&2)":U
       ttComboData.cFlag              = "N":U
       ttComboData.cCurrentKeyValue   = "":U
       ttComboData.cListItemDelimiter = CHR(3)
       ttComboData.cListItemPairs     = "":U
       ttComboData.cCurrentDescValue  = "":U.

RUN af/app/afcobuildp.p (INPUT-OUTPUT TABLE ttComboData).

ASSIGN httComboData = TEMP-TABLE ttComboData:HANDLE.

/* 9 - Translate the login screen.  
       If the login window name conforms to the standard of having "lognw" in its name, then we assume it is a standard
       login window with a standard set of known widgets, and can then pre-do the translation for the login window as part
       of the upfront login work, saving an appserver hit.
       If the login window is not standard, then it must not contain "lognw" in its name, and then the pre-translation work
       will be skipped, causing an extra appserver hit to translate the login window as part of rendering the login window
       via a call to the translation manager from within the login window itself.
       Note that the standard Dynamics login window is called "aftemlognw.w". If the widgets on this window change, then the 
       code below will not work and will need to be revisited or the translations for the login window will not function
       correctly.
*/
ASSIGN cLoginFilename = (DYNAMIC-FUNCTION("getSessionParam":U IN TARGET-PROCEDURE, INPUT "login_procedure":U)) NO-ERROR.
IF cLoginFilename = ? OR cLoginFilename = "":U THEN
  ASSIGN cLoginFilename = ttSecurityControl.login_filename.

/* get name of login filename, and replace .w with .r and remove path - to get object name
   that must be passed to translation, e.g. turn af/cod2/aftemlognw.w into aftemlognw.r
*/
ASSIGN
  cLoginFileRcode = REPLACE(cLoginFilename,".w":U,".r":U)
  cLoginFileRcode = LC(TRIM(REPLACE(cLoginFileRcode,"~\":U,"/":U)))
  cLoginFileRcode = SUBSTRING(cLoginFileRcode,R-INDEX(cLoginFileRcode,"/":U) + 1)
  NO-ERROR
  .

IF  ttSecurityControl.translation_enabled = YES 
AND INDEX(cLoginFilename,"lognw":U) > 0 /* This is a standard Dynamics login window */
THEN DO:
    EMPTY TEMP-TABLE ttTranslate.

    DEFINE VARIABLE cLoginWidgets AS CHARACTER  NO-UNDO EXTENT 10.

    ASSIGN cLoginWidgets[1]  = cLoginFileRcode + ',BUTTON,&Cancel,&Cancel,Abort login':U
           cLoginWidgets[2]  = cLoginFileRcode + ',BUTTON,&OK,&OK,Login to application':U
           cLoginWidgets[3]  = cLoginFileRcode + ',BUTTON,&Password,&Password,Change user password':U
           cLoginWidgets[4]  = cLoginFileRcode + ',BUTTON,...,...,':U
           cLoginWidgets[5]  = cLoginFileRcode + ',COMBO-BOX,Company,Company,':U
           cLoginWidgets[6]  = cLoginFileRcode + ',COMBO-BOX,Language,Language,':U
           cLoginWidgets[7]  = cLoginFileRcode + ',FILL-IN,Login Name,Login Name,User login name for authentication':U
           cLoginWidgets[8]  = cLoginFileRcode + ',FILL-IN,Password,Password,User password - (case sesnsitive)':U
           cLoginWidgets[9]  = cLoginFileRcode + ',FILL-IN,Processing Date,Processing Date,The date to use for processing transactions, etc.':U
           cLoginWidgets[10] = cLoginFileRcode + ',TITLE,TITLE,Application Login,':U.

    DO iCnt = 1 TO 10:
        CREATE ttTranslate.
        ASSIGN ttTranslate.cObjectName      = ENTRY(1, cLoginWidgets[iCnt])
               ttTranslate.cWidgetType      = ENTRY(2, cLoginWidgets[iCnt])
               ttTranslate.cWidgetName      = ENTRY(3, cLoginWidgets[iCnt])
               ttTranslate.cOriginalLabel   = ENTRY(4, cLoginWidgets[iCnt])
               ttTranslate.cOriginalTooltip = ENTRY(5, cLoginWidgets[iCnt]).
    END.

    /* Now run multiTranslation in the translation manager, which will translate the table */

    RUN multiTranslation IN gshTranslationManager (INPUT YES,
                                                   INPUT-OUTPUT TABLE ttTranslate).
END.

ASSIGN httTranslate = TEMP-TABLE ttTranslate:HANDLE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


