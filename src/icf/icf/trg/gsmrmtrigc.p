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

TRIGGER PROCEDURE FOR CREATE OF gsm_required_manager .

/* generic trigger override include file to disable trigger if required */
{af/sup2/aftrigover.i &DB-NAME      = "ICFDB"
                      &TABLE-NAME   = "gsm_required_manager"
                      &TRIGGER-TYPE = "CREATE"}

/* Created automatically using ERwin ICF Trigger template db/af/erw/afercustrg.i
   Do not change manually. Customisations to triggers should be placed in separate
   include files pulled into the trigger. ICF auto generates write trigger custom
   include files. Delete or create customisation include files need to be created
   manually. Be sure to put the hook in ERwin directly so as not to have you changes
   overwritten.
   User defined Macro (UDP) Summary (case sensitive)
   gsm_required_manager           Expands to full table name, e.g. gsm_user
   %TableFLA            Expands to table unique code, e.g. gsmus
   %TableObj            If blank or not defined expands to table_obj with no prefix (framework standard)
                        If defined, uses this field as the object field
                        If set to "none" then indicates table does not have an object field
   XYZ                  Do not define so we can compare against an empty string

   See docs for explanation of replication macros 
*/   

&SCOPED-DEFINE TRIGGER_TABLE gsm_required_manager
&SCOPED-DEFINE TRIGGER_FLA gsmrm
&SCOPED-DEFINE TRIGGER_OBJ required_manager_obj


DEFINE BUFFER lb_table FOR gsm_required_manager.      /* Used for recursive relationships */
DEFINE BUFFER lb1_table FOR gsm_required_manager.     /* Used for lock upgrades */

DEFINE BUFFER o_gsm_required_manager FOR gsm_required_manager.

/* Standard top of CREATE trigger code */
{af/sup/aftrigtopc.i}

  



/* Generated by ICF ERwin Template */
/* gsc_object is the procedure object for gsm_required_manager ON CHILD INSERT RESTRICT */
IF 
    ( gsm_required_manager.object_obj <> 0 ) THEN
  DO:
    IF NOT(CAN-FIND(FIRST gsc_object WHERE
        gsm_required_manager.object_obj = gsc_object.object_obj)) THEN
        DO:
          /* Cannot create child because parent does not exist ! */
          ASSIGN lv-error = YES lv-errgrp = "AF ":U lv-errnum = 102 lv-include = "gsm_required_manager|gsc_object":U.
          RUN error-message (lv-errgrp, lv-errnum, lv-include).
        END.
    
    
  END.

/* Generated by ICF ERwin Template */
/* gsm_session_type is responsible for starting gsm_required_manager ON CHILD INSERT RESTRICT */
IF 
    ( gsm_required_manager.session_type_obj <> 0 ) THEN
  DO:
    IF NOT(CAN-FIND(FIRST gsm_session_type WHERE
        gsm_required_manager.session_type_obj = gsm_session_type.session_type_obj)) THEN
        DO:
          /* Cannot create child because parent does not exist ! */
          ASSIGN lv-error = YES lv-errgrp = "AF ":U lv-errnum = 102 lv-include = "gsm_required_manager|gsm_session_type":U.
          RUN error-message (lv-errgrp, lv-errnum, lv-include).
        END.
    
    
  END.

/* Generated by ICF ERwin Template */
/* gsc_manager_type describes gsm_required_manager ON CHILD INSERT RESTRICT */
IF 
    ( gsm_required_manager.manager_type_obj <> 0 ) THEN
  DO:
    IF NOT(CAN-FIND(FIRST gsc_manager_type WHERE
        gsm_required_manager.manager_type_obj = gsc_manager_type.manager_type_obj)) THEN
        DO:
          /* Cannot create child because parent does not exist ! */
          ASSIGN lv-error = YES lv-errgrp = "AF ":U lv-errnum = 102 lv-include = "gsm_required_manager|gsc_manager_type":U.
          RUN error-message (lv-errgrp, lv-errnum, lv-include).
        END.
    
    
  END.






ASSIGN gsm_required_manager.{&TRIGGER_OBJ} = getNextObj().





/* Update Audit Log */
IF CAN-FIND(FIRST gsc_entity_mnemonic
            WHERE gsc_entity_mnemonic.entity_mnemonic = 'gsmrm':U
              AND gsc_entity_mnemonic.auditing_enabled = YES) THEN
  RUN af/app/afauditlgp.p (INPUT "CREATE":U, INPUT "gsmrm":U, INPUT BUFFER gsm_required_manager:HANDLE, INPUT BUFFER o_gsm_required_manager:HANDLE).

/* Standard bottom of CREATE trigger code */
{af/sup/aftrigendc.i}


/* Place any specific CREATE trigger customisations here */