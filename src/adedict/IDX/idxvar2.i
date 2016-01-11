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

/*----------------------------------------------------------------------------

File: idxvar2.i

Description:   
   Browser Needed for the IDX properties screen
Arguments:
   {1} - this is either "new shared" or "shared".

Author: Kathy Kelley

Date Created: 12/03/96 
----------------------------------------------------------------------------*/

Define {1} temp-table idx-list
            Field fld-nam as character format "x(32)"
            field fld-typ as character format "x(20)"
            field asc-desc as character format "x(1)"
            field comp-seq as integer
        INDEX comp-seq AS PRIMARY comp-seq.

define {1} buffer b_idx-list for idx-list.
define {1} query q-idx-list for b_idx-list scrolling.




