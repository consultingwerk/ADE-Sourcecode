/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*----------------------------------------------------------------------------

File: _bstname.p

Description:
    Checks if a name of a wiget is OK (i.e. not used by another widget in the
    window.  If it is, then we convert it to a better name that will work.
    
    This file differs from _ok_name.p in the following ways:
      1) It always returns a good name
      2) It never reports an error
      3) It always gets a unique name. That is, it is unconcerned about
         the case of two variables in different frames with the same data-type
         (which can have the same name).  It always assumes a different variable.

Input Parameters:
   p_test  : The name to start testing.
   p_base  : The base name to use for a new name.
   p_proc-id: The procedure where this is defined

Output Parameters:
   p_best  : the best name - p_best = p_test if the name is valid; otherwise
             it is a new best name.

Author: Wm.T.Wood

Date Created: June 25, 1993   

Modified:
  wood 7/10/95 - Support "_" as seperator between base name and number.  
  wood 2/07/98 - Modified for 2mars to pass in the _P recid, and not the 
                 _h_win (also moved from adeshar to workshop).  Also
                 removed the p_type and p_index parameters

----------------------------------------------------------------------------*/
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
