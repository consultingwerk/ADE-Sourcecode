/*********************************************************************
* Copyright (C) 2007 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*               PSC                                                  *
*                                                                    *
*********************************************************************/
TRIGGER PROCEDURE FOR REPLICATION-CREATE OF gsc_language_text.

{af/sup/afreplicat.i  &TABLE-NAME   = "gsc_language_text"
                      &TABLE-FLA    = "gsclt"
                      &TABLE-PK     = "language_text_obj"
                      &ACTION       = "CREATE"
                      &VERSION-DATA = "YES"
}
