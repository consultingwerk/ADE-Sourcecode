/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*               PSC                                                  *
*                                                                    *
*********************************************************************/
TRIGGER PROCEDURE FOR REPLICATION-WRITE OF gsc_scm_tool OLD BUFFER lb_old.

{af/sup/afreplicat.i  &TABLE-NAME   = "gsc_scm_tool"
                      &TABLE-FLA    = "gscsm"
                      &TABLE-PK     = "scm_tool_obj"
                      &OLD-BUFFER   = "lb_old"
                      &ACTION       = "WRITE"
                      
                      
                      &VERSION-DATA = "YES"
}


