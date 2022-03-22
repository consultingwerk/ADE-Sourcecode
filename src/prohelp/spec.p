/***********************************************************************
* Copyright (C) 2000,2007 by Progress Software Corporation. All rights *
* reserved. Prior versions of this work may contain portions           *
* contributed by participants of Possenet.                             *
*                                                                      *
***********************************************************************/
define variable line as character format "x(76)".
DEFINE VARIABLE cInputFrom AS CHARACTER NO-UNDO.

ASSIGN cInputFrom = SEARCH("prohelp/indata/specs").
IF cInputFrom = ? THEN
DO:
    MESSAGE "The procedure 'prohelp/indata/specs' required for this option was not found" 
            VIEW-AS ALERT-BOX.
    RETURN.
END.

input from value(cInputFrom) no-echo.

repeat with 19 down no-labels attr-space centered
  title " P R O G R E S S   D E S I G N   S P E C I F I C A T I O N S ".
  set line.
  display line.
end.
