/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
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




