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
  File: afobjschkp.p

  Description:  Object Security Check Procedure

  Purpose:      Object Security Check Procedure
                Check user security for object permitted access to
                The procedure is run on the Appserver as an external procedure non
                persistently from the Client Security Manager, and is included as in internal
                procedre in the Server Security Manager.

  Parameters:   input string object name
                input decimal _obj of object
                output flag indicating access is restricted or otherwise

  History:
  --------
  (v:010100)    Task:    90000045   UserRef:    POSSE
                Date:   21/04/2001  Author:     Phil Magnay

  Update Notes: Logic changes due to new security allocations

  (v:010000)    Task:    90000045   UserRef:    POSSE
                Date:   21/04/2001  Author:     Phil Magnay

  Update Notes: New Object Security check function

-----------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       afobjschkp.p
&scop object-version    010000


/* MIP object identifying preprocessor */
&glob   mip-structured-procedure    yes


{af/sup2/afglobals.i}     /* Astra global shared variables */

DEFINE INPUT-OUTPUT PARAMETER pcObjectName                      AS CHARACTER    NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER pdObjectObj                       AS DECIMAL      NO-UNDO.
DEFINE OUTPUT       PARAMETER plSecurityRestricted               AS LOGICAL      NO-UNDO.

DEFINE VARIABLE         cSecurityValue1                   AS CHARACTER    NO-UNDO.
DEFINE VARIABLE         cSecurityValue2                   AS CHARACTER    NO-UNDO.
DEFINE VARIABLE         cUserProperties                   AS CHARACTER    NO-UNDO.
DEFINE VARIABLE         cUserValues                       AS CHARACTER    NO-UNDO.

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
         HEIGHT             = 11.91
         WIDTH              = 52.6.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME




&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

ASSIGN plSecurityRestricted = YES.

FIND FIRST gsc_security_control NO-LOCK NO-ERROR.
IF AVAILABLE gsc_security_control AND gsc_security_control.security_enabled = NO THEN 
DO:
  plSecurityRestricted = NO.
  RETURN. /* Security off */
END.

/* Get current up-to-date user information to be sure */
ASSIGN cUserProperties = "currentUserObj,currentOrganisationObj".
cUserValues = DYNAMIC-FUNCTION("getPropertyList":U IN gshSessionManager,
                              INPUT cUserProperties,
                              INPUT NO).

IF (pdObjectObj NE 0.0 AND CAN-FIND(FIRST gsc_object
                                    WHERE gsc_object.object_obj          EQ pdObjectObj
                                      AND gsc_object.security_object_obj NE 0))
OR
   (pcObjectName NE "":U AND CAN-FIND(FIRST gsc_object
                                      WHERE gsc_object.OBJECT_filename     EQ pcObjectName
                                        AND gsc_object.security_object_obj NE 0)) 
THEN
DO: /* security is turned on for this object */
    IF pdObjectObj NE 0.0 THEN
       FIND FIRST gsc_object NO-LOCK
            WHERE gsc_object.OBJECT_obj      = pdObjectObj
            NO-ERROR.
    ELSE
    IF pcObjectName NE "":U THEN
       FIND FIRST gsc_object NO-LOCK
            WHERE gsc_object.object_filename = pcObjectName 
            NO-ERROR.    
    IF AVAILABLE gsc_object THEN
    DO:
        RUN userSecurityCheck IN gshSecurityManager (INPUT  DECIMAL(ENTRY(1,cUserValues,CHR(3))),  /* logged in as user */
                                                     INPUT  DECIMAL(ENTRY(2,cUserValues,CHR(3))),  /* logged into organisation */
                                                     INPUT  "gscob":U,                      /* Security Structure FLA */
                                                     INPUT  gsc_object.OBJECT_obj,
                                                     INPUT  NO,                             /* Return security values - NO */
                                                     OUTPUT plSecurityRestricted,           /* Restricted yes/no ? */
                                                     OUTPUT cSecurityValue1,                /* clearance value 1 */
                                                     OUTPUT cSecurityValue2).               /* clearance value 2 */
        ASSIGN
            pcObjectName = gsc_object.OBJECT_filename
            pdObjectObj  = gsc_object.OBJECT_obj
            .
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


