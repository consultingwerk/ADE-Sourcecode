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
