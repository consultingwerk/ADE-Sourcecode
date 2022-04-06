/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*               PSC                                                  *
*                                                                    *
*********************************************************************/
TRIGGER PROCEDURE FOR REPLICATION-DELETE OF gsc_scm_tool.

{af/sup/afreplicat.i  &TABLE-NAME   = "gsc_scm_tool"
                      &TABLE-FLA    = "gscsm"
                      &TABLE-PK     = "scm_tool_obj"
                      &ACTION       = "DELETE"
                      
                      
                      &VERSION-DATA = "YES"
}
