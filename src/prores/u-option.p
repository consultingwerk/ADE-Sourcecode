/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation ("PSC"),       *
* 14 Oak Park, Bedford, MA 01730, and other contributors as listed   *
* below.  All Rights Reserved.                                       *
*                                                                    *
* The Initial Developer of the Original Code is PSC.  The Original   *
* Code is Progress IDE code released to open source December 1, 2000.*
*                                                                    *
* The contents of this file are subject to the Possenet Public       *
* License Version 1.0 (the "License"); you may not use this file     *
* except in compliance with the License.  A copy of the License is   *
* available as of the date of this notice at                         *
* http://www.possenet.org/license.html                               *
*                                                                    *
* Software distributed under the License is distributed on an "AS IS"*
* basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. You*
* should refer to the License for the specific language governing    *
* rights and limitations under the License.                          *
*                                                                    *
* Contributors:                                                      *
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
