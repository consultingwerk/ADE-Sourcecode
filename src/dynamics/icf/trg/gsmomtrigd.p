/*********************************************************************
* Copyright (C) 2005 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

TRIGGER PROCEDURE FOR DELETE OF gsm_object_menu_structure .

/* Created automatically using ERwin ICF Trigger template db/af/erw/afercustrg.i
   Do not change manually. Customisations to triggers should be placed in separate
   include files pulled into the trigger. ICF auto generates write trigger custom
   include files. Delete or create customisation include files need to be created
   manually. Be sure to put the hook in ERwin directly so as not to have you changes
   overwritten.
   User defined Macro (UDP) Summary (case sensitive)
   gsm_object_menu_structure           Expands to full table name, e.g. gsm_user
   %TableFLA            Expands to table unique code, e.g. gsmus
   %TableObj            If blank or not defined expands to table_obj with no prefix (framework standard)
                        If defined, uses this field as the object field
                        If set to "none" then indicates table does not have an object field
   XYZ                  Do not define so we can compare against an empty string

   See docs for explanation of replication macros 
*/   

&SCOPED-DEFINE TRIGGER_TABLE gsm_object_menu_structure
&SCOPED-DEFINE TRIGGER_FLA gsmom
&SCOPED-DEFINE TRIGGER_OBJ object_menu_structure_obj


DEFINE BUFFER lb_table FOR gsm_object_menu_structure.      /* Used for recursive relationships */
DEFINE BUFFER lb1_table FOR gsm_object_menu_structure.     /* Used for lock upgrades */

DEFINE BUFFER o_gsm_object_menu_structure FOR gsm_object_menu_structure.

/* Standard top of DELETE trigger code */
{af/sup/aftrigtopd.i}

  













/* Update Audit Log */
IF CAN-FIND(FIRST gsc_entity_mnemonic
            WHERE gsc_entity_mnemonic.entity_mnemonic = 'gsmom':U
              AND gsc_entity_mnemonic.auditing_enabled = YES) THEN
  RUN af/app/afauditlgp.p (INPUT "DELETE":U, INPUT "gsmom":U, INPUT BUFFER gsm_object_menu_structure:HANDLE, INPUT BUFFER o_gsm_object_menu_structure:HANDLE).

/* Standard bottom of DELETE trigger code */
{af/sup/aftrigendd.i}


/* Place any specific DELETE trigger customisations here */
