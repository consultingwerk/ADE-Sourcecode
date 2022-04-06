/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*               PSC                                                  *
*                                                                    *
*********************************************************************/
TRIGGER PROCEDURE FOR REPLICATION-DELETE OF rym_customization.

{af/sup/afreplicat.i  &TABLE-NAME   = "rym_customization"
                      &TABLE-FLA    = "rymcz"
                      &TABLE-PK     = "customization_type_obj,
                                       customization_reference"
                      &ACTION       = "DELETE"
                      
                      
                      &VERSION-DATA = "YES"
}
