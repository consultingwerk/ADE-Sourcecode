/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*               PSC                                                  *
*                                                                    *
*********************************************************************/
TRIGGER PROCEDURE FOR REPLICATION-WRITE OF ryc_page OLD BUFFER lb_old.

{af/sup/afreplicat.i  &TABLE-NAME   = "ryc_page"
                      &TABLE-FLA    = "rycpa"
                      &TABLE-PK     = "page_obj"
                      &OLD-BUFFER   = "lb_old"
                      &ACTION       = "WRITE"
                      &PRIMARY-FLA  = "rycso"
                      &PRIMARY-KEY  = "container_smartobject_obj"
                      &VERSION-DATA = "YES"
}


