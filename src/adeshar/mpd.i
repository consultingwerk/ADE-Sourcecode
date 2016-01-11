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
