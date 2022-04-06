/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* updparam.i */
&IF DEFINED(UpdTable{1}) NE 0 &THEN
  DEFINE {2} PARAMETER TABLE FOR {&UpdTable{1}}.
&ELSE
  DEFINE {2} PARAMETER TABLE-HANDLE phDummy{1}.
  ghUpdTables[{1}] = phDummy{1}.
&ENDIF
