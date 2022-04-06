/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/* dictnext.i - executes the next simple entry in user_path */
/* {1} = the name of a temp char variable */

IF user_path <> ""
  AND INDEX(ENTRY(1,user_path),"=") = 0
  AND INDEX(ENTRY(1,user_path),"*") = 0
  AND INDEX(ENTRY(1,user_path),"!") = 0
  AND INDEX(ENTRY(1,user_path),"?") = 0 THEN DO:
  ASSIGN
    {1}       = ENTRY(1,user_path)
    user_path = SUBSTRING(user_path,LENGTH({1},"character") + 2,-1,"character").
  IF {1} <> "*N" THEN DO:
    IF      {1} BEGINS "_dct" THEN .
    ELSE IF {1} BEGINS "_usr" THEN {1} = "user/" + {1}.
    ELSE IF {1} BEGINS "_gui" THEN {1} = "gui/"  + {1}.
    ELSE IF {1} BEGINS "_dmp"
         OR {1} BEGINS "_lod" THEN {1} = "dump/" + {1}.
    ELSE IF {1} BEGINS "_gat" THEN {1} = "gate/" + {1}.
    ELSE IF {1} BEGINS "_as4" THEN {1} = "as4/"  + {1}.  /* AS400 */
    ELSE IF {1} BEGINS "_bti" THEN {1} = "bti/"  + {1}.  /* CTOS-ISAM */
    ELSE IF {1} BEGINS "_gen" THEN {1} = "gen/"  + {1}.  /* Generic */
    ELSE IF {1} BEGINS "_oag" THEN {1} = "oag/"  + {1}.  /* Object Access */
    ELSE IF {1} BEGINS "_ora" THEN {1} = "ora/"  + {1}.  /* Oracle */
    ELSE IF {1} BEGINS "_pro" THEN {1} = "pro/"  + {1}.  /* PROGRESS */
    ELSE IF {1} BEGINS "_rdb" THEN {1} = "rdb/"  + {1}.  /* VMS Rdb */
    ELSE IF {1} BEGINS "_syb" THEN {1} = "syb/"  + {1}.  /* SYBASE */
    ELSE IF {1} BEGINS "_odb" THEN {1} = "odb/"  + {1}.  /* ODBC */
    ELSE                           {1} = "misc/" + {1}.
    RUN VALUE("prodict/" + {1} + ".p").
  END.
END.
