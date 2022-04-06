/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*--------------------------------------------------------------------------
  dfile.i
  File Commands-Related Defines for Editor 
--------------------------------------------------------------------------*/

DEFINE VARIABLE  File_Name AS CHARACTER LABEL "Filename" FORMAT "x(50)" NO-UNDO.
  /*  OS file name currently being edited.  */

DEFINE VARIABLE Search_File AS CHAR NO-UNDO.
  /* Stores PROPATH search pathname for a file to be opened. */
