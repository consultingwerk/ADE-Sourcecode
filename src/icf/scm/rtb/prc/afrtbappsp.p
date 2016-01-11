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
  File: afrtbappsp.p

  Description:  Astra Roundtable Appserver Copy Hook

  Purpose:      Astra Roundtable Appserver Copy Hook
                If object recid not passed in, then tries to find rtb_object
                using object name for current workspace.
                Copies r-code to Appserver if Appserver connected and object
                exists in Roundtable.
                Hook called from RTB object compile and adeevnt object compile.

  Parameters:   input recid of rtb_object table (if known)
                input object name (if known)
                output error message if any

  History:
  --------
  (v:010000)    Task:        5936   UserRef:    
                Date:   06/06/2000  Author:     Anthony Swindells

  Update Notes: Created from Template aftemprocp.p

  (v:010001)    Task:        6145   UserRef:    
                Date:   24/06/2000  Author:     Anthony Swindells

  Update Notes: add web modules

  (v:010002)    Task:        6324   UserRef:    
                Date:   20/07/2000  Author:     Anthony Swindells

  Update Notes: make it work locally as well, i.e. disable in a local environment

  (v:010003)    Task:        6356   UserRef:    
                Date:   26/07/2000  Author:     Pieter Meyer

  Update Notes: Check unloaded objects in gs-dev workspace

  (v:010004)    Task:        7292   UserRef:    
                Date:   11/12/2000  Author:     Pieter Meyer

  Update Notes: Allow compile of ADM objects to Appserver

-----------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       afrtbappsp.p
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    010002


/* MIP object identifying preprocessor */
&glob   mip-structured-procedure    yes

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
         HEIGHT             = 7.71
         WIDTH              = 40.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME




&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

{af/sup/afproducts.i}

DEFINE INPUT PARAMETER  prObjectRecid     AS RECID      NO-UNDO.
DEFINE INPUT PARAMETER  pcObjectName      AS CHARACTER  NO-UNDO.
DEFINE OUTPUT PARAMETER pcErrorMessage    AS CHARACTER  NO-UNDO.

/* define Astra global shared variables */
{af/sup2/afglobals.i NEW GLOBAL}

/* Define RTB global shared variables - used for RTB integration hooks */
DEFINE NEW GLOBAL SHARED VARIABLE grtb-wsroot     AS CHARACTER  NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE grtb-wspace-id  AS CHARACTER  NO-UNDO.

DEFINE VARIABLE cSubType                          AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cObjectName                       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cRemotePath                       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE lCopy                             AS LOGICAL    NO-UNDO.

/* local checks to disable functionality */
IF gshAstraAppserver = SESSION:HANDLE
THEN RETURN.

IF INDEX(grtb-wsroot,"c:") > 0
OR INDEX(grtb-wsroot,"d:") > 0
OR INDEX(grtb-wsroot,"e:") > 0
THEN RETURN.

IF CONNECTED("RTB")
AND VALID-HANDLE(gshAstraAppserver)
AND CAN-QUERY(gshAstraAppserver, "connected":U)
AND gshAstraAppserver:CONNECTED()
THEN DO:

  IF NOT prObjectRecid > 0
  THEN DO:
    /* Strip path from object name if any */
    IF pcObjectName <> "":U
    THEN
      ASSIGN
        cObjectName = LC(TRIM(REPLACE(pcObjectName,"\":U,"/":U)))
        cObjectName = SUBSTRING(cObjectName,R-INDEX(cObjectName,"/":U) + 1)
        .

    IF cObjectName <> "":U
    THEN
      FIND FIRST rtb_object NO-LOCK
           WHERE rtb_object.wspace-id = grtb-wspace-id
           AND   rtb_object.obj-type  = "PCODE":U
           AND   rtb_object.OBJECT    = cObjectName
           NO-ERROR.
    IF cObjectName <> "":U
    AND AVAILABLE rtb_object
    THEN ASSIGN prObjectRecid = RECID(rtb_object).

    IF AVAILABLE rtb_object THEN
      FIND FIRST rtb_ver NO-LOCK
           WHERE rtb_ver.obj-type = rtb_object.obj-type
             AND rtb_ver.OBJECT = rtb_object.OBJECT 
             AND rtb_ver.pmod = rtb_object.pmod
             AND rtb_ver.version = rtb_object.version NO-ERROR.
    IF AVAILABLE rtb_object AND AVAILABLE rtb_ver THEN
      ASSIGN cSubType = rtb_ver.sub-type.

  END.

  ASSIGN
    cRemotePath = "/share/oas/":U + REPLACE(grtb-wspace-id,"-":U,"":U).  

  IF NOT AVAILABLE rtb_object
  AND prObjectRecid > 0
  THEN DO:
    FIND FIRST rtb_object NO-LOCK
         WHERE RECID(rtb_object) = prObjectRecid
         NO-ERROR.
  END.

  ASSIGN
    lCopy = NO.

  IF AVAILABLE rtb_object
  THEN DO:
    IF rtb_object.obj-group = "SDO":U
    OR rtb_object.obj-group = "DLProc":U
    OR rtb_object.obj-group = "Appserver":U
    OR cSubType = "SDO":U
    OR cSubType = "DLProc":U
    OR INDEX(rtb_object.module,"-apsrv":U) > 0
    OR INDEX(rtb_object.module,"-app":U)   > 0
    OR INDEX(rtb_object.module,"-w":U)     > 0
    OR INDEX(rtb_object.module,"-trg":U)   > 0
    OR INDEX(rtb_object.module,"-adm":U)   > 0
    THEN ASSIGN lCopy = YES.
  END.

  IF  prObjectRecid > 0
  AND lCopy
  THEN
    RUN rtb/appsrvr/rtb_assnd.p
      (INPUT prObjectRecid,
       INPUT gshAstraAppserver,
       INPUT cRemotePath,
       INPUT YES,               /* send r-code */
       OUTPUT pcErrorMessage).

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


