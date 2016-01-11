/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*
** Cleans up after compiling a gateway
*/

FIND FIRST DICTDB._Db WHERE DICTDB._Db._Db-name = "DICTDBG" EXCLUSIVE-LOCK NO-ERROR.
IF AVAILABLE DICTDB._Db THEN DO:
    FOR EACH DICTDB._File OF DICTDB._Db:
	FOR EACH DICTDB._Field OF DICTDB._File:
	    DELETE DICTDB._Field.
	END.
	DELETE DICTDB._File.
    END.
    DELETE DICTDB._Db.
END.
