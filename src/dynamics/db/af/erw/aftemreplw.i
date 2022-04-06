/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*               PSC                                                  *
*                                                                    *
*********************************************************************/
TRIGGER PROCEDURE FOR REPLICATION-WRITE OF %TableName OLD BUFFER lb_old.

{af/sup/afreplicat.i  &TABLE-NAME   = "%TableName"
                      &TABLE-FLA    = "%EntityProp(TableFLA)"
                      &TABLE-PK     = "%PK(",")"
                      &OLD-BUFFER   = "lb_old"
                      &ACTION       = "WRITE"
                      %If(%!=(%EntityProp("ReplicateFLA"),%EntityProp("XYZ"))){&PRIMARY-FLA  = "%EntityProp(ReplicateFLA)"}
                      %If(%!=(%EntityProp("ReplicateKey"),%EntityProp("XYZ"))){&PRIMARY-KEY  = "%EntityProp(ReplicateKey)"}
                      &VERSION-DATA = "%EntityProp(VersionData)"
}

%IF(%==(%EntityProp(TableFLA),%EntityProp(ReplicateFLA))){{%DiagramProp(TriggerRel)%EntityProp(TableFLA)replw.i}}
