/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation ("PSC"),       *
* 14 Oak Park, Bedford, MA 01730, and other contributors as listed   *
* below.  All Rights Reserved.                                       *
*                                                                    *
* The Initial Developer of the Original Code is PSC.  The Original   *
* Code is Progress IDE code released to open source December 1, 2000.*
*                                                                    *
* The contents of this file are subject to the Possenet Public       *
* License Version 1.0 (the "License"); you may not use this file     *
* except in compliance with the License.  A copy of the License is   *
* available as of the date of this notice at                         *
* http://www.possenet.org/license.html                               *
*                                                                    *
* Software distributed under the License is distributed on an "AS IS"*
* basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. You*
* should refer to the License for the specific language governing    *
* rights and limitations under the License.                          *
*                                                                    *
* Contributors:                                                      *
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
