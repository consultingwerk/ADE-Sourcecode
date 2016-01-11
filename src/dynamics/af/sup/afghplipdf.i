&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Check Version Notes Wizard" Include _INLINE
/* Actions: af/cod/aftemwizcw.w ? ? ? ? */
/* MIP Update Version Notes Wizard
Check object version notes.
af/cod/aftemwizpw.w
*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Update-Object-Version" Include _INLINE
/* Actions: ? ? ? ? af/sup/afverxftrp.p */
/* This has to go above the definitions sections, as that is what it modifies.
   If its not, then the definitions section will have been saved before the
   XFTR code kicks in and changes it */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Definition Comments Wizard" Include _INLINE
/* Actions: ? af/cod/aftemwizcw.w ? ? ? */
/* Program Definition Comment Block Wizard
Welcome to the Program Definition Comment Block Wizard. Press Next to proceed.
af/cod/aftemwizpw.w
*/
/* _UIB-CODE-BLOCK-END */
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
* Contributors:                                                      *
*                                                                    *
*********************************************************************/
/*---------------------------------------------------------------------------------
  File: afghplipdf.i

  Description:  definitions of PLIP handle shared vars

  Purpose:      definitions of PLIP handle shared variables

  Parameters:   {1} = NEW or "" depending on where used.

  History:
  --------
  (v:010000)    Task:         155   UserRef:    AS
                Date:   14/04/1998  Author:     Anthony Swindells

  Update Notes: Created from Template afteminclu.i

  (v:010003)    Task:        4289   UserRef:    
                Date:   08/02/2000  Author:     Pieter Meyer

  Update Notes: design web plipp and menus for webspeed

  (v:010004)    Task:        5124   UserRef:    
                Date:   23/03/2000  Author:     Pieter Meyer

  Update Notes: WEB - Framework Programs

  (v:010006)    Task:        5957   UserRef:    
                Date:   06/06/2000  Author:     Anthony Swindells

  Update Notes: Add Astra 2 stuff

------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       afghplipdf.i
&scop object-version    010006


/* MIP object identifying preprocessor */
&glob   mip-structured-include  yes

DEFINE {1} {2} SHARED VARIABLE  gh_appserver            AS HANDLE   NO-UNDO.    /* Handle to Application Server */
DEFINE {1} {2} SHARED VARIABLE  gh_local_app_plip       AS HANDLE   NO-UNDO.    /* Handle of local Appserver PLIP */
DEFINE {1} {2} SHARED VARIABLE  gh_remote_app_plip      AS HANDLE   NO-UNDO.    /* Handle of remote Appserver PLIP */
DEFINE {1} {2} SHARED VARIABLE  gh_usi_plip             AS HANDLE   NO-UNDO.    /* Handle of User Interface PLIP */
DEFINE {1} {2} SHARED VARIABLE  gh_chr_usi_plip         AS HANDLE   NO-UNDO.    /* Handle of User Interface PLIP */
DEFINE {1} {2} SHARED VARIABLE  gh_web_app_plip         AS HANDLE   NO-UNDO.    /* Handle of Web Appserver PLIP */

DEFINE {1} {2} SHARED VARIABLE  gh_parameter_controller AS HANDLE   NO-UNDO.    /* Handle of Parameter Controller PLIP */
DEFINE {1} {2} SHARED VARIABLE  gh_systembar            AS HANDLE   NO-UNDO.    /* Handle of Toolbar PLIP */

{af/sup2/afglobals.i NEW GLOBAL}

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
         HEIGHT             = 7.57
         WIDTH              = 50.2.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME




&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


