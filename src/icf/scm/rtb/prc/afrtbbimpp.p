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
  File: afrtbbimpp.p

  Description:  Roundtable before import hook

  Purpose:      This procedure will be run automatically from Roundtable when an import is
                started. It's purpose is to automatically exclude any objects that have not been
                tested, e.g. that do not have a status of 3-COM or 6-TOK.

  Parameters:   ip_workspace = The RTB workspace
                op_ok = NO will prevent the import being done at all

  History:
  --------
  (v:010000)    Task:        2951   UserRef:    
                Date:   20/09/1999  Author:     Anthony Swindells

  Update Notes: New RTB before import hook. Added a new hook to Roundtable to
                automatically exclude any objects whose task notes are not set as being
                tested ok, e.g. the status must be set to 3-COM or 6-TOK to be included in an
                import.

  (v:010001)    Task:        3168   UserRef:    
                Date:   14/10/1999  Author:     Anthony Swindells

  Update Notes: Allow tasks with bugs to be included in import unless they have been
                subsequently checked out, e.g. a bug task has been assigned and the
                object is being worked on.

  (v:010002)    Task:        3281   UserRef:    
                Date:   25/10/1999  Author:     Anthony Swindells

  Update Notes: Test status mods - prevent 6-bug being imported.
                As per the discussions recently, prevent objects in a task with status 6-bug
                from being included in imports. The status of a task must be set to 7-bas, a
                new task created, and bug objects checked out under it. The objects that
                did
                not have bugs in will then be imported, and the objects checked out with
                bugs in will be excluded.

---------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       afrtbbimpp.p
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    010001


/* MIP object identifying preprocessor */
&glob   mip-structured-procedure    yes

DEFINE INPUT PARAMETER  ip_workspace        AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER op_ok               AS LOGICAL INITIAL YES NO-UNDO.

{af/sup/afproducts.i}

{rtb/inc/afrtbglobs.i} /* pull in Roundtable global variables */

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
         HEIGHT             = 6.52
         WIDTH              = 43.6.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME




&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

ASSIGN op_ok = YES NO-ERROR.

IF NOT CAN-FIND(FIRST rtb_import WHERE rtb_import.wspace-id = ip_workspace AND rtb_import.done = NO) THEN RETURN.

DEFINE VARIABLE lv_new_area                         AS CHARACTER    NO-UNDO.
DEFINE VARIABLE lv_valid_status                     AS CHARACTER    NO-UNDO.
DEFINE VARIABLE lv_bug_status                       AS CHARACTER    NO-UNDO.
DEFINE VARIABLE lv_choice                           AS LOGICAL INITIAL YES NO-UNDO.
DEFINE VARIABLE lh_rtbprocp                         AS HANDLE       NO-UNDO.
DEFINE VARIABLE lv_tnot_rowid                       AS ROWID        NO-UNDO.
DEFINE VARIABLE lv_rejection                        AS CHARACTER    NO-UNDO.
DEFINE VARIABLE lv_old_task                         AS INTEGER      NO-UNDO.

ASSIGN
    lv_new_area = CAPS(ENTRY(2, ip_workspace, "-":U))
    lv_valid_status = "3-COM,6-TOK,7-BAS,7-DEP":U
    lv_bug_status = "7-BAS":U
    .

IF LENGTH(lv_new_area) > 3 THEN
  ASSIGN lv_new_area = SUBSTRING(lv_new_area,1,3).  /* cope with DEV2 workspace */

ASSIGN lv_choice = YES.
MESSAGE "MIP Enhancement:" SKIP(1)
        "Do you wish to exclude any objects in tasks that have not been tested, plus" SKIP
        "any objects subsequently checked out for tasks that resulted in bugs, i.e." SKIP
        "the programs with bugs in them." SKIP(1)
        VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE lv_choice.
IF lv_choice = NO THEN RETURN.

MESSAGE "Have you remembered to update the status of tested tasks ?" SKIP(1)
        VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE lv_choice.
IF lv_choice = NO THEN 
  DO:
    ASSIGN op_ok = NO.
    RETURN.
  END.

RUN rtb/prc/afrtbprocp.p PERSISTENT SET lh_rtbprocp.
IF NOT VALID-HANDLE(lh_rtbprocp) THEN
  DO:
    ASSIGN op_ok = NO.
    MESSAGE "Failed to start plip rtb/prc/afrtbprocp.p"
        VIEW-AS ALERT-BOX INFORMATION.
    RETURN.
  END.

FOR EACH rtb_import EXCLUSIVE-LOCK
   WHERE rtb_import.wspace-id = ip_workspace
     AND rtb_import.done = NO
      BY rtb_import.task-num:

    FIND FIRST rtb_tnot NO-LOCK
         WHERE rtb_tnot.task-num = rtb_import.task-num
           AND rtb_tnot.obj-type = "pcode":U
         NO-ERROR.

    IF AVAILABLE rtb_tnot AND 
       NOT CAN-DO(lv_valid_status, rtb_tnot.object) THEN
      ASSIGN
        rtb_import.imp-status = "EXC":U.

    IF AVAILABLE rtb_tnot AND
       CAN-DO(lv_bug_status, rtb_tnot.object) THEN
      DO:   /* test if object checked out and exclude it if it is */
        IF CAN-FIND(FIRST rtb_ver
                    WHERE rtb_ver.object = rtb_import.object
                      AND rtb_ver.pmod = rtb_import.pmod
                      AND rtb_ver.obj-type = rtb_import.obj-type
                      AND rtb_ver.obj-status = "w":U) THEN
          ASSIGN rtb_import.imp-status = "EXC":U.
      END.

END.

IF VALID-HANDLE( lh_rtbprocp ) THEN DELETE PROCEDURE lh_rtbprocp.

RETURN.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


