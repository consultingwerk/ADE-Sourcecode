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
 * u-direct.p - program to switch query directories
 *
 *  This program provides the user interface for the "Switch Directories"
 *  button in the "Open ..." menu.  It is also used by "Application Rebuild"
 *  to locate query directories to rebuild after a schema change.
 */

{ aderes/af-idefs.i }

DEFINE INPUT-OUTPUT PARAMETER qbf-d AS CHARACTER NO-UNDO.
DEFINE OUTPUT       PARAMETER qbf-l AS LOGICAL NO-UNDO.

SYSTEM-DIALOG GET-FILE qbf-d 
  DEFAULT-EXTENSION {&qdExt}
  TITLE "Select Query Directory"
  /* MUST-EXIST */
  SAVE-AS
  UPDATE qbf-l
  FILTERS "Query Directories" "*{&qdUqExt}".

RETURN.

/* u-direct.p -  end of file */

