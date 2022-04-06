/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*               PSC                                                  *
*                                                                    *
*********************************************************************/
TRIGGER PROCEDURE FOR REPLICATION-WRITE OF gst_release_version OLD BUFFER lb_old.

{af/sup/afreplicat.i  &TABLE-NAME   = "gst_release_version"
                      &TABLE-FLA    = "gstrl"
                      &TABLE-PK     = "release_version_obj"
                      &OLD-BUFFER   = "lb_old"
                      &ACTION       = "WRITE"
                      
                      
                      &VERSION-DATA = "YES"
}


