/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*               PSC                                                  *
*                                                                    *
*********************************************************************/
TRIGGER PROCEDURE FOR REPLICATION-CREATE OF gsc_data_tag.

{af/sup/afreplicat.i  &TABLE-NAME   = "gsc_data_tag"
                      &TABLE-FLA    = "gsctg"
                      &TABLE-PK     = "data_tag_obj"
                      &ACTION       = "CREATE"
                      
                      
                      &VERSION-DATA = "YES"
}
