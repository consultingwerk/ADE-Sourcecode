&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12
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
* Copyright (C) 2001 by Progress Software Corporation ("PSC"),       *
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
  File: _chsPM.p

  Description:  adeuib/_chsPM.p

  Purpose:      Runs 'Save As Dynamic Object' dialog and saves file to repository.
                Called directly by AB in choose_file_save_as_dynamic in uibmproa.i.
                
                This program utilizes shared AppBuilder temp-tables and 
                variables, callers other than AppBuilder must define those 
                shared elements as NEW to avoid data conflicts with the AppBuilder.

  Parameters:   INPUT  phWindow        AS HANDLE
                INPUT  pPrecid         AS RECID
                INPUT  pcProductModule AS CHARACTER
                INPUT  pcFileName      AS CHARACTER
                INPUT  pcType          AS CHARACTER
                OUTPUT pressedOK       AS LOGICAL

  History:
  --------
  (v:010000)  
                Date:   03/08/2002  Author:     Ross Hunter

  Update Notes: Created from Template adeuib/_reposaddfl.p

---------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       _chspm.p
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000


/* object identifying preprocessor */
&glob   AstraProcedure    yes

{src/adm2/globals.i}

DEFINE INPUT  PARAMETER phWindow        AS HANDLE       NO-UNDO.
DEFINE INPUT  PARAMETER pPrecid         AS RECID        NO-UNDO.
DEFINE INPUT  PARAMETER pcProductModule AS CHARACTER    NO-UNDO.
DEFINE INPUT  PARAMETER pcFileName      AS CHARACTER    NO-UNDO.
DEFINE INPUT  PARAMETER pcType          AS CHARACTER    NO-UNDO.
DEFINE OUTPUT PARAMETER pressedOK       AS LOGICAL      NO-UNDO.

/*  Need to use AppBuilder temp-tables and shared variables. They are defined 
    shared here so the caller can define the data values as new and this routine 
    pickes up the correct shared versions - when the caller is AppBuilder or 
    external caller. */
{adeuib/sharvars.i}.
{adeuib/uniwidg.i}.

DEFINE VARIABLE gcFilename     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcSavedPath    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcError        AS CHARACTER  NO-UNDO.
DEFINE VARIABLE grRyObject     AS RECID      NO-UNDO.
DEFINE VARIABLE cRootDirectory AS CHARACTER  NO-UNDO.

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
         HEIGHT             = 8.1
         WIDTH              = 48.4.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

DO ON STOP UNDO, LEAVE:
    /* Call the Add to Repository dialog. Passes data back in an _RyObject record. */
    RUN ry/prc/rytoReposw.w
        (INPUT phWindow,                /* Parent Window    */
         INPUT pcProductModule,         /* Product Module   */
         INPUT pcFileName,              /* Object to add    */
         INPUT pcType,                  /* File type        */
         INPUT pPrecid,                  /* _P recID */
         OUTPUT grRyObject,             /* RyObject created */
         OUTPUT pressedOK).

    IF pressedOK THEN
    DO:
        /* We need the base filename only to find the _RyObject record. */

        FIND _RyObject WHERE RECID(_RyObject) = grRyObject NO-ERROR.
        IF NOT AVAILABLE _RyObject THEN LEAVE.
/****************************************************************
        MESSAGE "Saving object..." SKIP(1)
                "File:  " pcFileName                      SKIP
                "Name:  " _RyObject.object_filename       SKIP
                "PMCode:" _RyObject.product_module_code   SKIP
                "OType: " _RyObject.object_type_code      SKIP
                "Path:  " _RyObject.object_path           SKIP
                "Desc:  " _RyObject.object_description    SKIP
                "Action:" _RyObject.design_action         SKIP
                "RyObj?:" _RyObject.design_ryobject       SKIP.
****************************************************************/

        /* If _P is available, the Add came from the AppBuilder. Otherwise, it
           came from Procedure Editor or a Procedure Window or some other call. */
        FIND _P WHERE RECID(_P) = pPrecid NO-ERROR.
        FIND _U WHERE RECID(_U) = _P._u-recid NO-ERROR.
        FIND _C WHERE RECID(_C) = _U._x-recid NO-ERROR.
        IF AVAILABLE _P THEN
          RUN save_ab_file_to_repos.
        ELSE
          RUN save_file_to_repos.
        
        IF (gcError <> "") THEN
        DO ON  STOP UNDO, LEAVE ON ERROR UNDO, LEAVE:
          IF gcError NE "Shown":U THEN
            MESSAGE "Object not added to repository." SKIP(1)
                    gcError
              VIEW-AS ALERT-BOX.
        END.
        ELSE IF (gcError = "") THEN
        DO ON STOP UNDO, LEAVE ON ERROR UNDO, LEAVE:
            MESSAGE "Object was added to repository."
              VIEW-AS ALERT-BOX INFORMATION.
        END.
    END. /* pressedOK */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-save_ab_file_to_repos) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE save_ab_file_to_repos Procedure 
PROCEDURE save_ab_file_to_repos :
/*------------------------------------------------------------------------------
  Purpose:     Saves an AppBuilder file as a dynamic repository object.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE h_title_win   AS WIDGET    NO-UNDO.
DEFINE VARIABLE OldTitle      AS CHARACTER NO-UNDO.


AB-BLOCK:
DO TRANSACTION ON ERROR UNDO, LEAVE:
    RUN adecomm/_setcurs.p ("WAIT":U).
    /* Get the info we need to complete the add and save the window
       as a static repository object. */
    BUFFER-COPY _RyObject TO _P.
    
    _ryObject.design_precid = RECID(_P).
    /* save_window_static is a misnomer.  It now does both dynamic and static */
    RUN save_window_static  IN _h_uib (INPUT RECID(_P), OUTPUT gcError).
  
    /* save_window_static has displayed the error message, indicate that it has 
       been shown */
    IF gcError NE "" THEN 
    DO:
      gcError = "Shown":U.
      DELETE _RyObject.
      UNDO AB-BLOCK, LEAVE AB-BLOCK.
    END.
    /* Don't need this anymore. It's passed back the info we needed. */
    DELETE _RyObject.
    
    IF gcError = "" THEN
    DO:
      ASSIGN
          h_title_win        = _P._WINDOW-HANDLE:WINDOW
          OldTitle           = h_title_win:TITLE
          h_title_win:TITLE  = _P._type + "(" 
                                   + _P.OBJECT_type_code + ") - " 
                                   + _P.OBJECT_filename
         _P._Save-as-file    = _P.OBJECT_filename.
      
      /* RUN adeuib/_wintitl.p (h_title_win, _U._LABEL, _U._LABEL-ATTR, 
                                 _P._SAVE-AS-FILE).  */                                 

     /* Change the active window title on the Window menu. */
      IF (h_title_win:TITLE <> OldTitle) AND VALID-HANDLE(_h_WinMenuMgr) THEN
        RUN WinMenuChangeName IN _h_WinMenuMgr
         (_h_WindowMenu, OldTitle, h_title_win:TITLE). 
      /* Notify the Section Editor of the window title change. Data after 
        "SE_PROPS" added for 19990910-003. */
      RUN call_sew IN _h_UIB ( "SE_PROPS":U ). 

      /* Update most recently used filelist */    
      IF LOOKUP("NEW":U,_P.design_action) > 1  AND _mru_filelist THEN 
        RUN adeshar/_mrulist.p (_save_file, IF _remote_file THEN _BrokerURL ELSE "").

      /* IZ 776 Redisplay current filename in AB Main window. */
      RUN display_current IN _h_uib.
    END.

END.
RUN adecomm/_setcurs.p ("":U).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-save_file_to_repos) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE save_file_to_repos Procedure 
PROCEDURE save_file_to_repos :
/*------------------------------------------------------------------------------
  Purpose:     Saves a file as a static repository object.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VARIABLE lPrompt     AS LOGICAL   NO-UNDO.

DO ON ERROR UNDO, LEAVE:
    RUN adecomm/_setcurs.p ("WAIT":U).
    
    /* Prompt for Product Module if for some reason we don't have it. */
    ASSIGN lPrompt = (_RyObject.product_module_code = "":u).

    /* Call Dynamics procedure to save static object to repository. You'll see
       a similar call in save_window_static  IN _h_uib. */
    RUN af/sup2/afsdocrdbp.p
        (INPUT pcFileName,
         INPUT _RyObject.object_type_code,
         INPUT _RyObject.product_module_code,
         INPUT "" /* Description */, 
         INPUT _Ryobject.deployment_type,
         INPUT _Ryobject.design_only,
         INPUT lPrompt /* prompt for PM */, 
         OUTPUT gcError).

    /* Don't need this anymore. It's passed back the info we needed. */
    DELETE _RyObject.

    RUN adecomm/_setcurs.p ("":U).
END. /* DO ON ERROR */
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

