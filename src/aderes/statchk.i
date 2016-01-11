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
/* statchk.i - When we're about to set the height of a form or browse
      	       frame, make sure this doesn't cause overwrite of the
      	       status bar.  If so, change height to a smaller value.
*/

(IF lGlbStatus AND 
    ({&row} + {&ht} > qbf-win:HEIGHT - wGlbStatus:HEIGHT + 1)
   THEN qbf-win:HEIGHT - {&row} - wGlbStatus:HEIGHT + 1
   ELSE {&ht})

/* statchk.i - end of file */

