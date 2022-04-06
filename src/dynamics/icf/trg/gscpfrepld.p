/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*               PSC                                                  *
*                                                                    *
*********************************************************************/
TRIGGER PROCEDURE FOR REPLICATION-DELETE OF gsc_profile_type.

{af/sup/afreplicat.i  &TABLE-NAME   = "gsc_profile_type"
                      &TABLE-FLA    = "gscpf"
                      &TABLE-PK     = "profile_type_obj"
                      &ACTION       = "DELETE"
                      
                      
                      &VERSION-DATA = "YES"
}
