/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*               PSC                                                  *
*                                                                    *
*********************************************************************/
TRIGGER PROCEDURE FOR REPLICATION-CREATE OF gsc_error.

{af/sup/afreplicat.i  &TABLE-NAME   = "gsc_error"
                      &TABLE-FLA    = "gscer"
                      &TABLE-PK     = "error_group,
                                       error_number,
                                       language_obj"
                      &ACTION       = "CREATE"
                      
                      
                      &VERSION-DATA = "YES"
}
