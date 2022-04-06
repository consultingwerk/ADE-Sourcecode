/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* adetran/pm/ckfilter.i
 */
  /*
  ** Check to see if there are inclusion filters
  */
  IF pUseFilters THEN DO:
    find first xlatedb.XL_SelectedFilter no-error.
    if not available xlatedb.XL_SelectedFilter then do: 
  
      ThisMessage = "You haven't defined any include filters. Defining now...".
      run adecomm/_s-alert.p (input-output ErrorStatus, "w":u,"ok":u, ThisMessage). 

      run adetran/pm/_wizard.w.
      find first xlatedb.XL_SelectedFilter no-error.
      if not available xlatedb.XL_SelectedFilter THEN return no-apply.
    end.
  END.  /* If intending to filter */ 
  
