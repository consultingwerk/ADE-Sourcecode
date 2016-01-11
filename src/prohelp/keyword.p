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
define variable choice as character format "x".
define variable line as character format "x(44)" label "Usage".
define variable abbrev as character format "x(14)" label "Abbreviation".
define variable xkeyword as character format "x(14)" label "Keyword".
define variable position as integer.
define variable i as integer.

GETCHOICE:
repeat with no-label attr-space centered:

  display
    skip(1)
    "Enter the first letter (A-Z) of the keyword you want or # for symbols:"
    with title " P R O G R E S S   K E Y W O R D S ".

  update choice auto-return.

  choice = caps(choice).
  if (choice < "A" and choice <> "#") or choice > "Z" then next GETCHOICE.

  if choice = "#" then position = 1.
  else position = asc(choice) - asc("A") + 2.

  hide all.

  input from value(search("prohelp/indata/kwlist")) no-echo.

  do i = 1 to position - 1:
    repeat:
      prompt-for ^.
    end.
  end.

  repeat with frame window1 down attr-space:
    set xkeyword abbrev line.
    display xkeyword abbrev line.
  end.

  input close.

end. /* getchoice */
