/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*-----------------------------------------------------------------------------

  File: _locdwb.p

  Description: Locates Actuate Developer Workbench on a system.

  Input Parameters:
      <none>

  Output Parameters:
      locdwb (char) - locates DWB and returns its full pathname. If it is
                      not installed, locdwb = ?

  Author: Gerry Seidl

  Modified on 
     05/04/99 by gfs - Created
 *---------------------------------------------------------------------------*/
DEFINE OUTPUT PARAMETER locdwb AS CHARACTER INITIAL ? NO-UNDO.

/* If it's installed, it's location is in the Registry */
LOAD "Software\Actuate\Actuate Developer Workbench":U BASE-KEY "HKEY_LOCAL_MACHINE":U NO-ERROR.
IF NOT ERROR-STATUS:ERROR THEN DO:
  USE "Software\Actuate\Actuate Developer Workbench":U.
  GET-KEY-VALUE SECTION "File Path":U KEY DEFAULT VALUE locdwb.
  USE "".
  /* If there is something in the registry, make sure it's really there */
  IF locdwb <> ? THEN DO:
    ASSIGN FILE-INFO:FILE-NAME = locdwb.
    IF FILE-INFO:FULL-PATHNAME <> ? THEN 
      ASSIGN locdwb = FILE-INFO:FULL-PATHNAME. /* It's installed */
    ELSE 
      ASSIGN locdwb = ?. /* Not found */
  END.
END.
RETURN. 
