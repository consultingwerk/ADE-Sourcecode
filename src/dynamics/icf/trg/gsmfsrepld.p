/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*               PSC                                                  *
*                                                                    *
*********************************************************************/
TRIGGER PROCEDURE FOR REPLICATION-DELETE OF gsm_flow_step.

{af/sup/afreplicat.i  &TABLE-NAME   = "gsm_flow_step"
                      &TABLE-FLA    = "gsmfs"
                      &TABLE-PK     = "flow_step_obj"
                      &ACTION       = "DELETE"
                      
                      
                      &VERSION-DATA = "YES"
}
