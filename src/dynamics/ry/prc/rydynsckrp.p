/* Copyright (C) 1984-2007 by Progress Software Corporation. All rights
   reserved. Prior versions of this work may contain portions
   contributed by participants of Possenet. */
/*---------------------------------------------------------------------------------
  File: ry/prc/rydynsckrp.p

  Description:  Guts of code moved to adeuib/_dynsckr.p
    
  NOTE:         This file should always be called so that customers can
                continue to use their customisations. They'd need to replace
                this file with their customised version of rydynsckr.p.

  Parameters:   open_file   File name (should be a dynamic object name) to suck in.
                import_mode  Mode for operation.
                             "WINDOW" - open a .w file (Window or Dialog Box)
-------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER open_file    AS CHARACTER NO-UNDO.   /* File to open */
DEFINE INPUT PARAMETER import_mode  AS CHARACTER NO-UNDO.   /* "WINDOW"  */

run adeuib/_dynsckr.p (open_file, import_mode).

/* EOF */