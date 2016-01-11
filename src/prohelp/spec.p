/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
define variable line as character format "x(76)".


input from value(search("prohelp/indata/specs")) no-echo.

repeat with 19 down no-labels attr-space centered
  title " P R O G R E S S   D E S I G N   S P E C I F I C A T I O N S ".
  set line.
  display line.
end.
