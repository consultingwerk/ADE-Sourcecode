/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* u-logo.p - default RESULTS logo */

HIDE ALL NO-PAUSE.

FORM
  " " SKIP
  WITH FRAME qbf-ps1 NO-ATTR-SPACE WIDTH 80 ROW 1 CENTERED OVERLAY 18 DOWN.
VIEW FRAME qbf-ps1.
PAUSE 0.
DISPLAY SKIP(1)
"@@@@@@@@     @@@@@@@@@   @@@@@@@ @@@@    @@@ @@@@    @@@@@@@@@@  @@@@@@@" SKIP
" @@    @@     @@     @  @@    @@  @@      @   @@     @   @@   @ @@    @@" SKIP
" @@     @@    @@     @ @@      @  @@      @   @@         @@    @@      @" SKIP
" @@     @@    @@       @@      @  @@      @   @@         @@    @@      @" SKIP
" @@     @@    @@       @@@        @@      @   @@         @@    @@"        SKIP
" @@     @     @@   @    @@@       @@      @   @@         @@     @@@"      SKIP
" @@@@@@@      @@@@@@     @@@@     @@      @   @@         @@      @@@@"    SKIP
" @@@@@        @@   @      @@@@    @@      @   @@         @@       @@@@"   SKIP
" @@ @@@       @@            @@@   @@      @   @@         @@         @@@"  SKIP
" @@  @@@      @@             @@@  @@      @   @@         @@          @@@" SKIP
" @@   @@@     @@       @      @@  @@      @   @@         @@    @      @@" SKIP
" @@    @@@    @@     @ @      @@  @@@     @   @@     @   @@    @      @@" SKIP
" @@     @@@   @@     @ @@    @@    @@@@@@@    @@     @   @@    @@    @@"  SKIP
"@@@@     @@@ @@@@@@@@@ @@@@@@@      @@@@@    @@@@@@@@@ @@@@@@  @@@@@@@"
  SKIP(1)
  WITH FRAME qbf-ps2 ROW 2 WIDTH 76 OVERLAY CENTERED ATTR-SPACE NO-LABELS.

PUT SCREEN ROW 19 COLUMN 46 COLOR MESSAGES " Progress Software Corporation ".

/* the next two lines make things look prettier on terminals with
cursors that are always active (such as "shelltool" under sunview) */
PUT CURSOR ROW SCREEN-LINES + 3 COLUMN 1.
PUT CURSOR OFF.

PAUSE 0. /* To suppress continue message before returning to edit mode */

RETURN.
