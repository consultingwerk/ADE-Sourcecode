/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*               PSC                                                  *
*                                                                    *
*********************************************************************/
TRIGGER PROCEDURE FOR REPLICATION-CREATE OF gsc_multi_media_type.

{af/sup/afreplicat.i  &TABLE-NAME   = "gsc_multi_media_type"
                      &TABLE-FLA    = "gscmm"
                      &TABLE-PK     = "multi_media_type_obj"
                      &ACTION       = "CREATE"
                      
                      
                      &VERSION-DATA = "YES"
}
