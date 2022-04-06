/*********************************************************************
* Copyright (C) 2005 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

TRIGGER PROCEDURE FOR DELETE OF gst_audit .

/* Created automatically using ERwin ICF Trigger template db/af/erw/afercustrg.i
   Do not change manually. Customisations to triggers should be placed in separate
   include files pulled into the trigger. ICF auto generates write trigger custom
   include files. Delete or create customisation include files need to be created
   manually. Be sure to put the hook in ERwin directly so as not to have you changes
   overwritten.
   User defined Macro (UDP) Summary (case sensitive)
   gst_audit           Expands to full table name, e.g. gsm_user
   %TableFLA            Expands to table unique code, e.g. gsmus
   %TableObj            If blank or not defined expands to table_obj with no prefix (framework standard)
                        If defined, uses this field as the object field
                        If set to "none" then indicates table does not have an object field
   XYZ                  Do not define so we can compare against an empty string

   See docs for explanation of replication macros 
*/   

&SCOPED-DEFINE TRIGGER_TABLE gst_audit
&SCOPED-DEFINE TRIGGER_FLA gstad
&SCOPED-DEFINE TRIGGER_OBJ audit_obj


DEFINE BUFFER lb_table FOR gst_audit.      /* Used for recursive relationships */
DEFINE BUFFER lb1_table FOR gst_audit.     /* Used for lock upgrades */

DEFINE BUFFER o_gst_audit FOR gst_audit.

/* Standard top of DELETE trigger code */
{af/sup/aftrigtopd.i}

/* NO audit log updates for the Auditing table - will get us in a bunch of recursion trouble. */

/* Standard bottom of DELETE trigger code */
{af/sup/aftrigendd.i}


/* Place any specific DELETE trigger customisations here */
