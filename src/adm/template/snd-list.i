/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* snd-list - 8/21/95 */
    WHEN "{1}":U THEN p-rowid-list = p-rowid-list + 
        IF AVAILABLE {1} THEN STRING(ROWID({1}))
        ELSE "?":U.
   
