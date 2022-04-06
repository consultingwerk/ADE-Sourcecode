/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*               PSC                                                  *
*                                                                    *
*********************************************************************/
TRIGGER PROCEDURE FOR REPLICATION-DELETE OF gsm_scm_xref.

{af/sup/afreplicat.i  &TABLE-NAME   = "gsm_scm_xref"
                      &TABLE-FLA    = "gsmsx"
                      &TABLE-PK     = "scm_xref_obj"
                      &ACTION       = "DELETE"
                      
                      
                      &VERSION-DATA = "YES"
}
