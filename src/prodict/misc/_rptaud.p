/*************************************************************/  
/* Copyright (c) 1984-2006,2008 by Progress Software Corporation  */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from PROGRESS Software Corporation. */
/*************************************************************/
/*----------------------------------------------------------------------------

File: _rptaud.p

Description:
   Pass through program from tty dict menu to adecomm/_audrpt.p.  Converts 
   Dictionary pertinent shared variable values into parameters.

Input:
   drec_db     = RECID of current database
   user_env[9] = Numeric Identifier of the report being called.
                 1    = Audit Policy Changes Report
                 2    = Database Schema Changes Report
                 3    = Audit Data Administration Report
                 4    = Application Data Administration Report
                 5    = User Account Changes Report
                 6    = Audit Permissions Changes Report
                 7    = Database Administration Changes Report
                 8    = Authentication System Changes Report
                 9    = Client Session Authentication
                10    = Application/Database Access Report (Logins/Logouts/etc.)
                11    = Database Access Report
                12    = Custom Report
                13    = Encryption Policy Changes
                14    = Key-store Changes 
                15    = Database Encryption Administration (Utilities)
 
Author: Kenneth S. McIntosh

Date Created: June 8, 2005

History: 
    kmcintos Aug 2, 2005  Changed permission check 20050721-007.
    kmcintos Jan 4, 2006  Changed permission list to audit reader and audit 
                          admin 20051108-060.
    fernando Dec 23,2008  Adding encryption related reports                     
----------------------------------------------------------------------------*/

&GLOBAL-DEFINE NOTTCACHE 1

{ prodict/dictvar.i }
{ prodict/user/uservar.i }
{ prodict/sec/sec-func.i }

DEFINE VARIABLE cRoles  AS CHARACTER   NO-UNDO
            INITIAL "_sys.audit.read,_sys.audit.admin".

DEFINE VARIABLE iRole   AS INTEGER     NO-UNDO.

DEFINE VARIABLE lCanRun AS LOGICAL     NO-UNDO.

/* Check for privileges */
DO iRole = 1 TO NUM-ENTRIES(cRoles):
  lCanRun = hasRole(USERID("DICTDB"),
                    ENTRY(iRole,cRoles),
                    FALSE).
  IF lCanRun THEN LEAVE.
END.

IF NOT lCanRun THEN DO:
  user_env = "".
  MESSAGE "You must have a minimum of Audit Reader permissions to access " +
          "this option."
      VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  RETURN.
END.

IF user_env[9] EQ "12" THEN
  RUN adecomm/_cust-flt.p ( INPUT  LDBNAME("DICTDB"),
                            OUTPUT user_env[1] ).
ELSE 
  RUN adecomm/_auddfilt.p ( INPUT user_env[9],
                            OUTPUT user_env[1] ).

IF user_env[1] EQ ? THEN DO:
  user_env  = "".
  user_path = "".
  RETURN.
END.

RUN adecomm/_audrpt.p ( INPUT drec_db,
                        INPUT LDBNAME("DICTDB"),
                        INPUT INTEGER(user_env[9]),
                        INPUT user_env[1] ).
