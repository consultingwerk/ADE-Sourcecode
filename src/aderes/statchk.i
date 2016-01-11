/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* statchk.i - When we're about to set the height of a form or browse
      	       frame, make sure this doesn't cause overwrite of the
      	       status bar.  If so, change height to a smaller value.
*/

(IF lGlbStatus AND 
    ({&row} + {&ht} > qbf-win:HEIGHT - wGlbStatus:HEIGHT + 1)
   THEN qbf-win:HEIGHT - {&row} - wGlbStatus:HEIGHT + 1
   ELSE {&ht})

/* statchk.i - end of file */

