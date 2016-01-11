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
/* 
 * MPDISP.P 
 *
 * This procedure writes 'data' to the output stream, if its messages are on (mpMessOn)
 *    or the data is message'd
 *
 * NOTE: This procedure is internal to mp.  You should not call
 *       it directly.  First, it will not remove the time it 
 *       uses from the timers.  Second it will not comment itself
 *       out if {&MP-DOTIMING} is not defined.  This procedure
 *       has an identically name include file.  Reference that
 *       through mp.i.
 *
 * Parameters: data - string data to be writtin to outfile or message'd
 */                                                               
           
define input parameter data as char.        /* String to write to file */

{adeshar/mpd.i} /* Include global vars */

if mpMessOn then do:
  if mpoutfile = ? then 
    message data.
  else do:
    /* Is there no way to test if the stream is avail? */
    /*
    if Not available stream mpOut then
       message "Mp macro error.  Tried to write to unopened file.  Use mpinit.p"
    else
    */
    put stream mpOut unformatted SKIP data.
  end.
end.
