/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
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
