/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*               PSC                                                  *
*                                                                    *
*********************************************************************/
TRIGGER PROCEDURE FOR REPLICATION-WRITE OF gsc_profile_code OLD BUFFER lb_old.

{af/sup/afreplicat.i  &TABLE-NAME   = "gsc_profile_code"
                      &TABLE-FLA    = "gscpc"
                      &TABLE-PK     = "profile_type_obj,
                                       profile_code_obj"
                      &OLD-BUFFER   = "lb_old"
                      &ACTION       = "WRITE"
                      
                      
                      &VERSION-DATA = "YES"
}


