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
