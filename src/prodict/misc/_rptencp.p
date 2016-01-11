/*********************************************************************
* Copyright (C) 2008 by Progress Software Corporation. All rights    *
* reserved.                                                          *
*                                                                    *
*********************************************************************/
/*--------------------------------------------------------------------

File: prodict/misc/_rptencp.p

Description:
    Report for encryption policies

Input-Parameters:
    user_env[9] =  Numeric Identifier of the report being called.
                   1 = quick report
                   2 = detailed report

Output-Parameters:
    none
    
History:
    10/27/08  fernando   created

--------------------------------------------------------------------*/
&GLOBAL-DEFINE NOTTCACHE 1
{ prodict/dictvar.i }
{ prodict/user/uservar.i }
{ prodict/misc/misc-funcs.i }

DEFINE VARIABLE lAsk AS LOGICAL NO-UNDO.

IF NOT dbAdmin(USERID("DICTDB")) THEN DO:
  MESSAGE "You must be a Security Administrator to use this option."
      VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  RETURN "".
END.

IF DBTYPE("DICTDB") NE "PROGRESS" THEN DO:
    MESSAGE "Cannot use this option with this database type."
        VIEW-AS ALERT-BOX ERROR BUTTONS OK.
    RETURN "".
END.

IF NUM-ENTRIES(user_env[9]) = 2 THEN DO:
    /* called from adedict */
    ASSIGN user_filename =  ENTRY(2,user_env[9])
           user_env[9] =  ENTRY(1,user_env[9])
           lAsk = YES. /* ask if user wants selected table or all */
END.

RUN adecomm/_encprpt.p
   (INPUT INTEGER(user_env[9]),
    INPUT LDBNAME("DICTDB"),
    INPUT user_filename,
    INPUT lAsk).

