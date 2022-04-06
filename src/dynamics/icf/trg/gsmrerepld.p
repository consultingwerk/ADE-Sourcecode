/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*               PSC                                                  *
*                                                                    *
*********************************************************************/
TRIGGER PROCEDURE FOR REPLICATION-DELETE OF gsm_reporting_tool.

{af/sup/afreplicat.i  &TABLE-NAME   = "gsm_reporting_tool"
                      &TABLE-FLA    = "gsmre"
                      &TABLE-PK     = "reporting_tool_obj"
                      &ACTION       = "DELETE"
                      
                      
                      &VERSION-DATA = "YES"
}
