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
  
