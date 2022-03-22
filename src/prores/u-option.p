/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* u-option.p - sample "User" option for RESULTS */

DEFINE SHARED VARIABLE qbf-module  AS CHARACTER NO-UNDO.
DEFINE SHARED VARIABLE qbf-product AS CHARACTER NO-UNDO.

DISPLAY SKIP(1)
  "This is an example of a ~"User~" option.  It can be called" SKIP
  "from any of the modules, such as Query, Report or Labels."  SKIP(1)
  "Value may be added to this product by including linking"    SKIP
  "procedures to connect this product with any PROGRESS"       SKIP
  "developers product, making a general purpose, integrated"   SKIP
  "query tool."                                                SKIP(1)
  "This User option escapes to the operating system when the"  SKIP
  "[space bar] is pressed."                                    SKIP(1)
  WITH FRAME qbf-option ROW 3 CENTERED OVERLAY NO-ATTR-SPACE
  TITLE COLOR NORMAL " " + qbf-product + " - User Option ".

READKEY.
HIDE FRAME qbf-option NO-PAUSE.

IF KEYFUNCTION(LASTKEY) <> " " THEN .
ELSE IF OPSYS = "BTOS"  THEN BTOS.
ELSE IF OPSYS = "MSDOS" THEN DOS.
ELSE IF OPSYS = "OS2"   THEN OS2.
ELSE IF OPSYS = "UNIX"  THEN UNIX.
ELSE IF OPSYS = "VMS"   THEN VMS.

IF qbf-module = "u" THEN qbf-module = ?.

RETURN.
