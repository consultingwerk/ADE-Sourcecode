&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
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
  File: aftrigover.i

  Description:  Trigger override include file

  Purpose:      Trigger override include file

  Parameters:   {af/sup2/aftrigover.i &DB-NAME      = "ICFDB":U
                &TABLE-NAME   = "ryc_smartobject"
                &TRIGGER-TYPE = "create"}

  History:
  --------
  (v:010000)    Task:    90000067   UserRef:    
                Date:   29/04/2001  Author:     Anthony Swindells

  Update Notes: Created from Template ryteminclu.i

---------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* Astra 2 object identifying preprocessor */
&glob   AstraInclude    yes

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

DEFINE VARIABLE cDbName           AS CHARACTER INITIAL "{&DB-NAME}":U NO-UNDO.
DEFINE VARIABLE cTableName        AS CHARACTER INITIAL "{&TABLE-NAME}":U NO-UNDO.
DEFINE VARIABLE cTriggerType      AS CHARACTER INITIAL "{&TRIGGER-TYPE}":U NO-UNDO.

DEFINE VARIABLE iTransaction      AS INTEGER NO-UNDO.

ASSIGN iTransaction = DBTASKID(cDbname).

IF iTransaction > 0 AND 
   CAN-FIND(FIRST gst_trigger_override
            WHERE gst_trigger_override.table_name BEGINS cTableName
              AND gst_trigger_override.transaction_id = iTransaction
              AND gst_trigger_override.OVERRIDE_date >= (TODAY - 1)
              AND gst_trigger_override.OVERRIDE_date <= (TODAY + 1)) THEN
DO:
  FIND FIRST gst_trigger_override NO-LOCK
       WHERE gst_trigger_override.table_name BEGINS cTableName
         AND gst_trigger_override.transaction_id = iTransaction
         AND gst_trigger_override.OVERRIDE_date >= (TODAY - 1)
         AND gst_trigger_override.OVERRIDE_date <= (TODAY + 1)
       NO-ERROR.
  ERROR-STATUS:ERROR = NO.
  IF AVAILABLE gst_trigger_override AND
     CAN-DO(gst_trigger_override.override_trigger_list, cTriggerType) THEN
    RETURN. /* abort trigger as it has been overridden */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


