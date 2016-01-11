/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*------------------------------------------------------------------------

  File: _offproc.p

  Description: Create procedure for holding .htm field offset information.
               This file has been processed for DBE and string translation.

  Input Parameters:
               p_Proc-ID - (INTEGER) Context Id (i.e. RECID) of the
                          current procedure.
                          
  Output Parameters:
               tmp_string - procedure block text

  Author: D.Adams

  Created: 3/28/96
  Updated: 
    adams 4/25/96 adjust for 4096 character statement limitation
    wood  8/21/96 Fix order of code generation. Use {&Web-File}.  
    wood  2/07/97 Updated for version 2.0 of mars
    adams 3/26/98 updated for Skywalker 9.0a
    
------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER p_Proc-ID AS INTEGER   NO-UNDO.
DEFINE OUTPUT PARAMETER p_code    AS CHARACTER NO-UNDO.

/* Shared variables --                                                  */
{ adeweb/htmwidg.i }      /* Design time Web _HTM TEMP-TABLE.         */
{ adeuib/sharvars.i }     /* Standard Shared variables                */
{ adeuib/uniwidg.i }      /* Universal Widget TEMP-TABLE definition   */

&SCOPED-DEFINE EOL CHR(10)

DEFINE VARIABLE cName    AS CHARACTER NO-UNDO.
DEFINE VARIABLE iVersion AS INTEGER   NO-UNDO INITIAL 3.

FIND _P WHERE RECID(_P) eq p_proc-id.
IF _P._file-version ne "" THEN
  iVersion = INTEGER(ENTRY(1,ENTRY(2,_P._file-version,"v":U),"r":U)).

ASSIGN p_code  =  
    "/*------------------------------------------------------------------------------":U + {&EOL}
  + "  Purpose:     Runs procedure to associate each HTML field with its" + {&EOL}
  + "               corresponding widget name and handle." + {&EOL}
  + "  Parameters:  " + {&EOL}
  + "  Notes:       " + {&EOL}
  + "------------------------------------------------------------------------------*/":U + {&EOL}
  + (IF iVersion > 2 THEN "  RUN readOffsets ":U ELSE "  RUN web/support/rdoffr.p ":U)
  + '("~{&WEB-FILE}":U).':U + {&EOL}.

/* Get all the _HTM records for this window.  NOTE that we want to
   use a unique order for this so that the order does not change on
   a save/load cycle. */
FOR EACH _HTM WHERE _HTM._P-recid eq p_proc-id,
    EACH _U   WHERE RECID(_U) eq _HTM._U-recid AND _U._STATUS ne "DELETED"
      BY _HTM._HTM-NAME BY _U._NAME:

  ASSIGN 
    cName  = { adeweb/name_u.i &U_BUFFER = "_U" }
    p_code = p_code 
           + (IF iVersion > 2 THEN '  RUN htmAssociate':U 
              ELSE '  RUN htm-associate IN THIS-PROCEDURE':U) + {&EOL}
           + '    ("':U + _HTM._HTM-NAME + '":U,"':U + cName + '":U,':U
           + cName + ':HANDLE IN FRAME ~{~&FRAME-NAME~}).':U + {&EOL}.
END.
ASSIGN p_code = p_code + "END PROCEDURE.":U  + {&EOL}.

/* _offproc.p - end of file */
