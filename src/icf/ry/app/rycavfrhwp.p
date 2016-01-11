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
  File: rycavfrhwp.p

  Description:  Set Frame Size Attribute Value Procedure

  Purpose:      Set Frame Size Attribute Value Procedure

  Parameters:   pcObjectFilename   -
                pdFrameWidthChars  -
                pdFrameHeightChars -

  History:
  --------
  (v:010000)    Task:   101000006   UserRef:    
                Date:   08/17/2001  Author:     Peter Judge

  Update Notes: Created from Template rytemprocp.p

  (v:010001)    Task:           0   UserRef:    
                Date:   11/02/2001  Author:     Mark Davies (MIP)

  Update Notes: Replaced properties/attributes for FrameMinHeightChars and FrameMinWidthChars with MinHeight and MinWidth

--------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       rycavfrhwp.p
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000


/* Astra object identifying preprocessor */
&glob   AstraProcedure    yes

{af/sup2/afglobals.i}

DEFINE INPUT PARAMETER pdViewerInstanceObj      AS DECIMAL          NO-UNDO.
DEFINE INPUT PARAMETER pdFrameWidthChars        AS DECIMAL          NO-UNDO.
DEFINE INPUT PARAMETER pdFrameHeightChars       AS DECIMAL          NO-UNDO.

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
         HEIGHT             = 10.71
         WIDTH              = 47.6.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
DEFINE BUFFER rycoi         FOR ryc_object_instance.

FIND FIRST rycoi WHERE
           rycoi.object_instance_obj = pdViewerInstanceObj
           NO-LOCK NO-ERROR.
IF AVAILABLE rycoi THEN
DO:
    { af/sup2/afrun2.i
        &PLIP         = 'ry/app/ryreposobp.p'
        &IProc        = 'StoreAttributeValues'
        &PList        = "( INPUT 0,~
                           INPUT rycoi.smartObject_obj,~
                           INPUT rycoi.container_smartObject_obj,~
                           INPUT rycoi.object_instance_obj,~
                           INPUT "'MinHeight,MinWidth,DynamicObject'":U,~
                           INPUT STRING(pdFrameHeightChars) + CHR(3) + STRING(pdFrameWidthChars) + CHR(3) + STRING(YES) )"
        &AutoKill     = YES
        &PlipRunError = "RETURN ERROR cErrorMessage."
    }
END.    /* avail rycoi. */

RETURN.

/** -- EOF -- **/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


