/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*               PSC                                                  *
*                                                                    *
*********************************************************************/
TRIGGER PROCEDURE FOR REPLICATION-DELETE OF gsm_report_definition.

{af/sup/afreplicat.i  &TABLE-NAME   = "gsm_report_definition"
                      &TABLE-FLA    = "gsmrd"
                      &TABLE-PK     = "report_definition_obj"
                      &ACTION       = "DELETE"
                      
                      
                      &VERSION-DATA = "YES"
}
