/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
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

OUTPUT STREAM outstream TO wsprefs.dat.

PUT STREAM outstream UNFORMATTED
  '~/* WebSpeed Workshop Files Preferences *~/':U SKIP
  'version= ':U _VERSION-NO SKIP
  'suppress_db= ':U (IF _suppress_dbname THEN 'true':U ELSE 'false':U) SKIP
  'reset_joins= ':U (IF _reset_joins THEN 'true':U ELSE 'false':U) SKIP
  'timeout_period= ':U _timeout_period SKIP.
  
OUTPUT STREAM outstream CLOSE.

/* _putpref.p - end of file */
