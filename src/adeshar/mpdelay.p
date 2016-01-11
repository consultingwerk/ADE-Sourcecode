/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*
 * MPDELAY.P
 *
 * Delays for given number of milliseconds. Not really accurate,
 *    but as accurate as Progress' internal timer.
 *
 * NOTE: This procedure is internal to mp.  You should not call
 *       it directly.  First, it will not remove the time it 
 *       uses from the timers.  Second it will not comment itself
 *       out if {&MP-DOTIMING} is not defined.  This procedure
 *       has an identically name include file.  Reference that
 *       through mp.i.
 *
 * Parameters: mp-delayamt: number of milliseconds to delay.
 */
 
  /*Parmaeter*/
  define input parameter mp-delayamt as int.

  /*Local Var*/
  define var mp-startdelay as int.

  mp-startdelay = eTime.
  do while mp-startdelay + mp-delayamt > eTime: 
  end.
