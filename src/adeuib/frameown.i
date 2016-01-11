/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* frameown.i */

/* File containing definition of frame owning frames temptable */
DEFINE {1} SHARED TEMP-TABLE _frame_owner_tt NO-UNDO
  FIELD _child  AS CHAR
  FIELD _parent AS CHAR
  INDEX _child IS PRIMARY UNIQUE _child.
