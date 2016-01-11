/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* adeuib/tool.i  -- defines the TOOL preprocessor.  Include this first. */
&IF "{&TOOL}" eq "" &THEN
  &Global-define TOOL ab
&ENDIF
