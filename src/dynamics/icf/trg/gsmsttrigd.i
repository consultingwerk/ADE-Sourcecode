&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Include 
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
* Contributors: MIP Holdings (Pty) Ltd ("MIP")                       *
*               PSC                                                  *
*                                                                    *
*********************************************************************/
/*--------------------------------------------------------------------------
    File        : 
    Purpose     :

    Syntax      :

    Description :

    Author(s)   :
    Created     :
    Notes       :
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Include
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: INCLUDE-ONLY
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Include ASSIGN
         HEIGHT             = 2
         WIDTH              = 40.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME




&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */

/* 1st get the user performing the action */
/* get user the new way */
DEFINE VARIABLE cUserObj                  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE dUserObj                  AS DECIMAL    NO-UNDO.

cUserObj = DYNAMIC-FUNCTION("getPropertyList":U IN gshSessionManager,
                                                 INPUT "currentUserObj":U,
                                                 INPUT NO).
ASSIGN dUserObj = DECIMAL(cUserObj) NO-ERROR.

FIND FIRST gsm_user NO-LOCK
     WHERE gsm_user.user_obj = dUserObj
     NO-ERROR.
IF AVAILABLE gsm_user AND gsm_user.maintain_system_data = NO AND gsm_status.system_owned = YES THEN
  DO:
    /* Cannot delete as user is not allowed to maintain system data ! */
    ASSIGN lv-error = YES lv-errgrp = "AF ":U lv-errnum = 17 lv-include = "You are not authorised to delete system owned gsm_status records.":U.
    RUN error-message (lv-errgrp, lv-errnum, lv-include).
  END.

&IF "{&astrapen}":U <> "":U &THEN
  {pa/trg/pagsmsttrd.i}
&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


