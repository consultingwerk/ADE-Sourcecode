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

------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER p_Proc-ID AS INTEGER   NO-UNDO.
DEFINE OUTPUT PARAMETER p_code    AS CHARACTER NO-UNDO.

/* Shared variables --                                                  */
{ workshop/htmwidg.i }      /* Design time Web _HTM TEMP-TABLE.         */
{ workshop/sharvars.i }     /* Standard Shared variables                */
{ workshop/uniwidg.i }      /* Universal Widget TEMP-TABLE definition   */

&SCOPED-DEFINE EOL CHR(10)
DEFINE VARIABLE c-name  AS CHARACTER NO-UNDO.
DEFINE VARIABLE i-count AS INTEGER   NO-UNDO.

ASSIGN p_code  =  
    "PROCEDURE htm-offsets :" + {&EOL}
  + "/*------------------------------------------------------------------------------":U + {&EOL}
  + "  Purpose:     Runs procedure to associate each HTML field with its" + {&EOL}
  + "               corresponding widget name and handle." + {&EOL}
  + "  Parameters:  " + {&EOL}
  + "  Notes:       " + {&EOL}
  + "------------------------------------------------------------------------------*/":U + {&EOL}
  + '  RUN web/support/rdoffr.p ("~{&WEB-FILE}":U).':U + {&EOL}.

/* Get all the _HTM records for this window.  NOTE that we want to
   use a unique order for this so that the order does not change on
   a save/load cycle. */
FOR EACH _HTM WHERE _HTM._P-recid eq p_proc-id,
    EACH _U   WHERE RECID(_U) eq _HTM._U-recid AND _U._STATUS ne "DELETED"
      BY _HTM._HTM-NAME BY _U._NAME:

  ASSIGN 
    c-name = { workshop/name_u.i &U_BUFFER = "_U" }
    p_code = p_code + '  RUN htm-associate IN THIS-PROCEDURE':U + {&EOL}
           + '    ("':U + _HTM._HTM-NAME + '":U,"':U + c-name + '":U,':U
           + c-name + ':HANDLE IN FRAME ~{~&FRAME-NAME~}).':U + {&EOL}.
END.
ASSIGN p_code = p_code + "END PROCEDURE.":U  + {&EOL}.

/* _offproc.p - end of file */
