/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*----------------------------------------------------------------------------

File: delwin.i

Description:
   Close the given property window.
 
Argument
   &Win - handle of window to close.
   &Obj - the object # for this object

Author: Laura Stern

Date Created: 05/13/92 

----------------------------------------------------------------------------*/

if {&Win} <> ? then
do:
   assign
      s_x_Win[{&Obj}] = {&Win}:x
      s_y_Win[{&Obj}] = {&Win}:y.
   
   delete widget {&Win}.
   {&Win} = ?.
end.

