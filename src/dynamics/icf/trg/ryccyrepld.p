/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*               PSC                                                  *
*                                                                    *
*********************************************************************/
TRIGGER PROCEDURE FOR REPLICATION-DELETE OF ryc_customization_type.

{af/sup/afreplicat.i  &TABLE-NAME   = "ryc_customization_type"
                      &TABLE-FLA    = "ryccy"
                      &TABLE-PK     = "customization_type_obj"
                      &ACTION       = "DELETE"
                      
                      
                      &VERSION-DATA = "YES"
}
