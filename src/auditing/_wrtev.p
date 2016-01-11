/*************************************************************/
/* Copyright (c) 1984-2005 by Progress Software Corporation  */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from PROGRESS Software Corporation. */
/*************************************************************/
/*------------------------------------------------------------------------

  File: _wrtev.p

  Description: Write an event to the db specifed - for dump/load of policies
              (initially).
               
               
  Input Parameters:
       nID        event id
       pcList     list of policies
       pcDbName   logical db name
       
  Output Parameters:
      pcErrorMsg  Error string

  Author: 

  Created: Feb 25,2005
  
  Modified by: 
------------------------------------------------------------------------*/

{prodict/sec/sec-func.i}
                   
DEFINE INPUT  PARAMETER nId        AS INTEGER NO-UNDO.
DEFINE INPUT  PARAMETER pcList     AS CHAR    NO-UNDO.
DEFINE INPUT  PARAMETER pcDbName   AS CHAR    NO-UNDO.
DEFINE OUTPUT PARAMETER pcErrorMsg AS CHAR    NO-UNDO.

DEFINE VARIABLE phDbName           AS CHAR    NO-UNDO.
DEFINE VARIABLE i                  AS INTEGER NO-UNDO.
DEFINE VARIABLE cTemp              AS CHAR    NO-UNDO.

IF NOT CONNECTED(pcDbName) THEN DO:
    ASSIGN pcErrorMsg = "Database " + pcDbName + " is not connected".
    RETURN.
END.

/* need physical db name */
phDbName = PDBNAME(pcDbName).

IF phDbName = ? OR phDbName = "" THEN DO:
    ASSIGN pcErrorMsg = "Could not get the physical name for database " + pcDbName.
    RETURN.
END.

/* save this for now */
cTemp = LDBNAME("DICTDB").

CREATE ALIAS "DICTDB" FOR DATABASE VALUE(pcDbName).

/* check if the user has privileges */
IF NOT hasRole(USERID(pcDbName),"_sys.audit.admin",FALSE) THEN DO:
    ASSIGN pcErrorMsg = "You do not have permissions to run this option.".
    RETURN.
END.

DELETE ALIAS "DICTDB".

/* reset it back */
IF cTemp NE ? AND cTemp NE "" THEN
   CREATE ALIAS "DICTDB" FOR DATABASE VALUE(cTemp).

IF nId = 10303 THEN DO: /* DUMP OF AUDIT POLICIES */

    REPEAT i = 1 TO NUM-ENTRIES(pcList):
        AUDIT-CONTROL:LOG-AUDIT-EVENT(10303, 
                                      "APM." + ENTRY(i, pcList) /* util-name.policy-name */, 
                                      phDbName + ",XML":U /* detail */).
    END.

END.
ELSE
    ASSIGN pcErrorMsg = "Event ID not implemented".


RETURN.
