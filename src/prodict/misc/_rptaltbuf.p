/*********************************************************************
* Copyright (C) 2009 by Progress Software Corporation. All rights    *
* reserved.                                                          *
*                                                                    *
*********************************************************************/
/*--------------------------------------------------------------------

File: prodict/misc/_rptaltbuf.p

Description:
    Report for alternate buffer pools

Input-Parameters:
    none
    
Output-Parameters:
    none
    
History:
    04/07/09  fernando   created

--------------------------------------------------------------------*/
&GLOBAL-DEFINE NOTTCACHE 1
{ prodict/dictvar.i }
{ prodict/user/uservar.i }
{ prodict/misc/misc-funcs.i }

DEFINE VARIABLE lAsk AS LOGICAL NO-UNDO.

IF NOT dbAdmin(USERID("DICTDB")) THEN DO:
  MESSAGE "You must be a Security Administrator to run this report."
      VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  RETURN "".
END.

IF DBTYPE("DICTDB") NE "PROGRESS" THEN DO:
    MESSAGE "Cannot use this option with this database type."
        VIEW-AS ALERT-BOX ERROR BUTTONS OK.
    RETURN "".
END.

RUN adecomm/_altbufrpt.p
   (INPUT drec_db).

