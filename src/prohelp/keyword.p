/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
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
