/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*---------------------------------------------------------------------------
  Include   : minitdbg.i
  Purpose   : Editor Menu Initialize for Compile->Debug.
  Syntax    : { adeedit/minitdbg.i }

  Description : Used in an include because its encrypted in $DLC/src/adeedit
                to protect reference to GET-LICENSE.
----------------------------------------------------------------------------*/

  ASSIGN MENU-ITEM _Debug:SENSITIVE IN MENU mnu_Compile
                   = ( GET-LICENSE("DEBUGGER") = 0 )
  . /* END ASSIGN. */
