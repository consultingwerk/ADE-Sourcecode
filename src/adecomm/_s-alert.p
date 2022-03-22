/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* s-alert.p - alert box routine */

/*
Input text comes in 'pi_text' parameter, and may be any length.
This program splits it up into 45-character chunks, breaking at
spaces.  Embedded '^' marks get translated into line-feeds (like
in column-labels).

pi_type the the type of alert box to use.
  pi_type = "e*" -> error
  pi_type = "i*" -> information
  pi_type = "m*" -> message
  pi_type = "q*" -> question
  pi_type = "w*" -> warning

pi_butn is the type of button(s) to use.
pio_ans is the initial value and also the result.
  pi_butn = "YES-NO"        -> pio_ans = TRUE/FALSE
  pi_butn = "YES-NO-CANCEL" -> pio_ans = TRUE/FALSE/?
  pi_butn = "OK"            -> pio_ans = TRUE
  pi_butn = "OK-CANCEL"     -> pio_ans = TRUE/?
  pi_butn = "RETRY-CANCEL"  -> pio_ans = TRUE/?

End-error handling:
  If there is a "CANCEL" button, then the result will be as if the user
  pressed the "CANCEL" button.  If there is NO "CANCEL" button but
  there is a "NO" button, then the result will be as if the user
  pressed the "NO" button.  If there is only the "OK" button, then the
  result will be as if the user selected the "OK" button.
*/

/* Moved this code to _s-alert2.p for PDSAB integration. By- Rajinder Kamboj */
&Scoped-define IDE-IS-SUPPORTED         
{adecomm/oeideservice.i}  
{adecomm/_s-alert2.p}  