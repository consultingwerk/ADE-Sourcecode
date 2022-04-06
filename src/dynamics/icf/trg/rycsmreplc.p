/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*               PSC                                                  *
*                                                                    *
*********************************************************************/
TRIGGER PROCEDURE FOR REPLICATION-CREATE OF ryc_smartlink.

{af/sup/afreplicat.i  &TABLE-NAME   = "ryc_smartlink"
                      &TABLE-FLA    = "rycsm"
                      &TABLE-PK     = "smartlink_obj"
                      &ACTION       = "CREATE"
                      &PRIMARY-FLA  = "rycso"
                      &PRIMARY-KEY  = "container_smartobject_obj"
                      &VERSION-DATA = "YES"
}
