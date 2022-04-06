/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*               PSC                                                  *
*                                                                    *
*********************************************************************/
TRIGGER PROCEDURE FOR REPLICATION-CREATE OF %TableName.

{af/sup/afreplicat.i  &TABLE-NAME   = "%TableName"
                      &TABLE-FLA    = "%EntityProp(TableFLA)"
                      &TABLE-PK     = "%PK(",")"
                      &ACTION       = "CREATE"
                      %If(%!=(%EntityProp("ReplicateFLA"),%EntityProp("XYZ"))){&PRIMARY-FLA  = "%EntityProp(ReplicateFLA)"}
                      %If(%!=(%EntityProp("ReplicateKey"),%EntityProp("XYZ"))){&PRIMARY-KEY  = "%EntityProp(ReplicateKey)"}
                      &VERSION-DATA = "%EntityProp(VersionData)"
}
