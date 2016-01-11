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
/*-----------------------------------------------------------------------------

  File: _locard.p

  Description: Locates Actuate Report Designer on a system.

  Input Parameters:
      <none>

  Output Parameters:
      locard (char) - locates ARD and returns its full pathname. If it is
                      not installed, locdwb = ?

  Author: Gerry Seidl

  Modified on 
     10/15/99 by gfs - Changed name to "Actuate e.Report Designer"
     05/07/99 by gfs - Created

 *---------------------------------------------------------------------------*/
DEFINE OUTPUT PARAMETER locard AS CHARACTER INITIAL ? NO-UNDO.

/* If it's installed, it's location is in the Registry */
LOAD "Software\Actuate\Actuate e.Report Designer":U BASE-KEY "HKEY_LOCAL_MACHINE":U NO-ERROR.
IF NOT ERROR-STATUS:ERROR THEN DO:
  USE "Software\Actuate\Actuate e.Report Designer":U.
  GET-KEY-VALUE SECTION "File Path":U KEY DEFAULT VALUE locard.
  USE "".
  /* If there is something in the registry, make sure it's really there */
  IF locard <> ? THEN DO:
    ASSIGN FILE-INFO:FILE-NAME = locard.
    IF FILE-INFO:FULL-PATHNAME <> ? THEN 
      ASSIGN locard = FILE-INFO:FULL-PATHNAME. /* It's installed */
    ELSE 
      ASSIGN locard = ?. /* Not found */
  END.
END.
RETURN. 
