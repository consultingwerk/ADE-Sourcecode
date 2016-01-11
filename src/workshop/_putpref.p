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
  File: _putpref.w
  
  Description: Write out File Preferences to disk
  
  Parameters:  <none>
  
  Fields:      <none>
  
  Author:  D.M.Adams
  
  Created: April 1997
------------------------------------------------------------------------*/

{ workshop/sharvars.i }      /* The shared workshop variables           */

DEFINE STREAM outstream.

DEFINE VARIABLE dlc-path AS CHARACTER NO-UNDO.

OUTPUT STREAM outstream TO wsprefs.dat.

PUT STREAM outstream UNFORMATTED
  '~/* WebSpeed Workshop Files Preferences *~/':U SKIP
  'version= ':U _VERSION-NO SKIP
  'suppress_db= ':U (IF _suppress_dbname THEN 'true':U ELSE 'false':U) SKIP
  'reset_joins= ':U (IF _reset_joins THEN 'true':U ELSE 'false':U) SKIP
  'timeout_period= ':U _timeout_period SKIP.
  
OUTPUT STREAM outstream CLOSE.

/* _putpref.p - end of file */
