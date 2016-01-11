/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
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
