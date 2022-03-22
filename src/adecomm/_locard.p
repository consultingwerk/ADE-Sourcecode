/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
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
