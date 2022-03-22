/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* 
 * MPD.I
 *
 * This file defines all of the globals that mp uses.
 * Include this file when you want to reference some of the 
 * generic globals, and you don't have a timer declared.
 */

&IF "{&MPGLOBALSDEFD}" EQ "" &THEN   /*   globalsdef'd is not defined then... */
  DEFINE new global SHARED VARIABLE mpMessOn     AS LOGICAL no-undo. 
  DEFINE new global SHARED VARIABLE mpOutFile    AS CHAR    no-undo.
  DEFINE new global SHARED VARIABLE mpTime       AS INT     no-undo.
  DEFINE new global SHARED VARIABLE mpSavedEtime AS INT     no-undo.
  DEFINE new global SHARED VARIABLE mpOutFile    AS CHAR    no-undo.
  DEFINE new global SHARED STREAM   mpOut.
&ENDIF
&global-define MPGLOBALSDEFD true  /* Scoped so that vars are decl'd in each file. */
