/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*----------------------------------------------------------------------------

File: repname.i

Description:
   The name of a schema object has been changed.  Reflect this change in
   the appropriate selection list.
 
Arguments:
   &OldName - The old object name
   &NewName - The new object name.
   &List    - The list to change the name in.
   &Fill    - The fill-in associated with the list in the browse window.
   &Curr    - The current value variable for this object type.

Author: Laura Stern

Date Created: 04/24/92

----------------------------------------------------------------------------*/

Define var ret as integer.

/* 09-08-92 mikep fix for bug 92-09-01-118

*/

s_Res = {&List}:replace({&NewName}, {&OldName}) in frame browse.
if s_Res = no then 
do:
   ret = lookup({&OldName}, {&List}:list-items in frame browse).
   if ret > 0 then 
      s_Res = {&List}:replace({&NewName},  
                              entry(ret, {&List}:list-items in frame browse))
              in frame browse.
end.

if s_Res = yes then 
do:
    {&List}:screen-value in frame browse = {&NewName}.
    {&Curr} = {&NewName}.

    /* Note - we can't use display here.  We want to change the value of the
       widget whether it's visible right now or not.  Display will make it
       appear and we may not want it to. When it becomes visible we'll 
       see the change.
    */
    {&Fill}:screen-value in frame browse = {&NewName}.
end.

