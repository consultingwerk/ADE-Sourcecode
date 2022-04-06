/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*               PSC                                                  *
*                                                                    *
*********************************************************************/
TRIGGER PROCEDURE FOR REPLICATION-WRITE OF gsc_dataset_entity OLD BUFFER lb_old.

{af/sup/afreplicat.i  &TABLE-NAME   = "gsc_dataset_entity"
                      &TABLE-FLA    = "gscde"
                      &TABLE-PK     = "dataset_entity_obj"
                      &OLD-BUFFER   = "lb_old"
                      &ACTION       = "WRITE"
                      
                      
                      &VERSION-DATA = "YES"
}


