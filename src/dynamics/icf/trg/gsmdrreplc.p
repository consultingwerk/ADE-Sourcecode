/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*               PSC                                                  *
*                                                                    *
*********************************************************************/
TRIGGER PROCEDURE FOR REPLICATION-CREATE OF gsm_default_report_format.

{af/sup/afreplicat.i  &TABLE-NAME   = "gsm_default_report_format"
                      &TABLE-FLA    = "gsmdr"
                      &TABLE-PK     = "default_report_format_obj"
                      &ACTION       = "CREATE"
                      
                      
                      &VERSION-DATA = "YES"
}
