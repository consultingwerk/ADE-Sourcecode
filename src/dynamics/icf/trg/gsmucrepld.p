/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*               PSC                                                  *
*                                                                    *
*********************************************************************/
TRIGGER PROCEDURE FOR REPLICATION-DELETE OF gsm_user_category.

{af/sup/afreplicat.i  &TABLE-NAME   = "gsm_user_category"
                      &TABLE-FLA    = "gsmuc"
                      &TABLE-PK     = "user_category_obj"
                      &ACTION       = "DELETE"
                      
                      
                      &VERSION-DATA = "YES"
}
