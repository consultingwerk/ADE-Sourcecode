/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*----------------------------------------------------------------------------

File: uncache.i

Description:
   Clear out one of the browse window selection lists, reset the cached
   flag and set the s_Currxxx variable for a particular object type.

Arguments:
   &List    - The list to clear.
   &Cached  - The cached flag to reset
   &Curr    - The s_Currxxx variable to reset.

Author: Laura Stern

Date Created: 04/26/92 

----------------------------------------------------------------------------*/

/* Clear out the selection list */
{&List}:LIST-ITEMS in frame browse = "".

{&Cached} = false.
{&Curr} = "".
