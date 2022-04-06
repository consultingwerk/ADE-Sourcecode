/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*               PSC                                                  *
*                                                                    *
*********************************************************************/
TRIGGER PROCEDURE FOR REPLICATION-CREATE OF gsc_deploy_dataset.

{af/sup/afreplicat.i  &TABLE-NAME   = "gsc_deploy_dataset"
                      &TABLE-FLA    = "gscdd"
                      &TABLE-PK     = "deploy_dataset_obj"
                      &ACTION       = "CREATE"
                      
                      
                      &VERSION-DATA = "YES"
}
