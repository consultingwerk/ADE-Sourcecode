/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*------------------------------------------------------------------------
  File: _getpref.w
  
  Description: Read File Preferences from disk
  
  Parameters:  <none>
  
  Fields:      <none>
  
  Author:  D.M.Adams
  
  Created: April 1997
------------------------------------------------------------------------*/

{ workshop/sharvars.i }      /* The shared workshop variables           */

DEFINE VARIABLE token     AS CHARACTER NO-UNDO.
DEFINE VARIABLE inp-value AS CHARACTER NO-UNDO.
DEFINE VARIABLE file-path AS CHARACTER NO-UNDO.

DEFINE STREAM instream.

file-path = SEARCH("wsprefs.dat":U).

IF file-path <> ? THEN DO:
  INPUT STREAM instream FROM VALUE(file-path) NO-ECHO.

  REPEAT:
    IMPORT STREAM instream token inp-value.
  
    CASE token:
      WHEN "version=":U THEN . /* not used */
      WHEN "suppress_db=":U THEN
        _suppress_dbname = (inp-value = "true":U).
      WHEN "reset_joins=":U THEN
        _reset_joins = (inp-value = "true":U).
      WHEN "timeout_period=":U THEN
        _timeout_period = DECIMAL(inp-value).
    END CASE.
  END.
END.

INPUT STREAM instream CLOSE.

/* _getpref.p - end of file */
