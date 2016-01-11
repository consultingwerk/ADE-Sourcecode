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
/* endsess.p */

display
skip(1)
" To end a PROGRESS session, you execute a simple procedure consisting of"
" the single command QUIT.  Just do the following steps:" skip(1)
"  1. Clear any statements that may already be in the editor." format "x(76)"
skip
"  2. Enter the word QUIT in upper or lower case."
skip
"  3. Press the " + kblabel("GO") + " key to execute this one-word procedure."
format "x(76)"
skip(1)
" After doing these steps, you will see the operating system prompt."
with frame instr title " E N D I N G   A   P R O G R E S S   S E S S I O N "
no-attr-space centered.

display
" To return to the PROGRESS editor, press the " + kblabel("END-error") +
" key when the PROGRESS   " format "x(76)"
skip
" HELP menu is next displayed."
with frame lst row 18 no-attr-space centered.
