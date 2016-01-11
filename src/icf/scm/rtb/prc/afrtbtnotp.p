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
  File: afrtbtnotp.p

  Description:  Task Notes take-on procedure

  Purpose:      To create task notes for all existing tasks - for take-on purposes.

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:        1687   UserRef:    
                Date:   19/07/1999  Author:     Anthony Swindells

  Update Notes: Created from Template aftemprocp.p

  (v:010001)    Task:    90000067   UserRef:    
                Date:   25/04/2001  Author:     Anthony Swindells

  Update Notes: Remove RTB dependancy, so code does not break if RTB not connected / in
                use.

--------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       afrtbtnotp.p
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    010001


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
         HEIGHT             = 2
         WIDTH              = 40.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME




&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

{af/sup/afproducts.i}

DEFINE VARIABLE lv_loop AS INTEGER NO-UNDO.

FOR EACH rtb_task NO-LOCK
   WHERE rtb_task.task-status = "w":U:

  IF NOT CAN-FIND(FIRST rtb_tnot 
                  WHERE rtb_tnot.task-num = rtb_task.task-num
                    AND rtb_tnot.obj-type = "pcode":U) THEN
    DO:

        CREATE rtb_tnot.
        ASSIGN
          rtb_tnot.pmod = "DEV":U
          rtb_tnot.obj-type = "pcode":U
          rtb_tnot.OBJECT = "1-OPN":U
          rtb_tnot.task-num = rtb_task.task-num
          rtb_tnot.act-hours = 0
          rtb_tnot.compltd-by = "":U
          rtb_tnot.compltd-when = ?
          rtb_tnot.entered-when = rtb_task.entered-when
          rtb_tnot.est-hours = 0
          rtb_tnot.note-priority = 0
          rtb_tnot.note-status = "":U
          rtb_tnot.note-type = "":U
          rtb_tnot.user-name = rtb_task.programmer
          rtb_tnot.version = 1
          .

        DO lv_loop = 1 TO 15:
          ASSIGN rtb_tnot.description[lv_loop] = rtb_task.description[lv_loop].
        END.

    END.

END.

FOR EACH rtb_task NO-LOCK
   WHERE rtb_task.task-status = "c":U:

  IF NOT CAN-FIND(FIRST rtb_tnot 
                  WHERE rtb_tnot.task-num = rtb_task.task-num
                    AND rtb_tnot.obj-type = "pcode":U) THEN
    DO:

        CREATE rtb_tnot.
        ASSIGN
          rtb_tnot.pmod = "V1X":U
          rtb_tnot.obj-type = "pcode":U
          rtb_tnot.OBJECT = "7-DEP":U
          rtb_tnot.task-num = rtb_task.task-num
          rtb_tnot.act-hours = 0
          rtb_tnot.compltd-by = rtb_task.compltd-by
          rtb_tnot.compltd-when = rtb_task.compltd-when
          rtb_tnot.entered-when = rtb_task.entered-when
          rtb_tnot.est-hours = 0
          rtb_tnot.note-priority = 0
          rtb_tnot.note-status = "":U
          rtb_tnot.note-type = "":U
          rtb_tnot.user-name = rtb_task.compltd-by
          rtb_tnot.version = 1
          .

        DO lv_loop = 1 TO 15:
          ASSIGN rtb_tnot.description[lv_loop] = rtb_task.description[lv_loop].
        END.

    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


