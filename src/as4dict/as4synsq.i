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
/*-------------------------------------------------------------
File: as4synsq.i

Description:  These are the field assignments for the _Sequence 
       file, which load the values stored in the p__Seq record
       (AS/400) to _Sequence (PROGRESS Schema file).  
       
       ***Note that there are some fields that we may
       not want to overlay with AS/400 information.  Recid fields
       will never be overlayed.  
       
History:

      nhorn     12/12/94   Created   
      DMcMann   03/12/97   Changed assignment of _Seq-Misc fields since the p__Seq
                           file has blanks and the Data Admin dump program looks
                           for ?, information was being dumped that the PROGRESS/400
                           Data Dictionary could not handle Bug 97-03-12-040
                           
------------------------------------------------------------------------*/


/* ======================= Main Line Code  ============================ */

ASSIGN _Sequence._Cycle-OK   = (If as4dict.p__Seq._Cycle-OK = "Y" then yes else no).

if _Sequence._Seq-Incr <> as4dict.p__Seq._Seq-Incr then 
     _Sequence._Seq-Incr     =     as4dict.p__Seq._Seq-Incr.

if _Sequence._Seq-Init <> as4dict.p__Seq._Seq-Init then     
       _Sequence._Seq-Init   =  as4dict.p__Seq._Seq-Init. 

if _Sequence._Seq-Max <> as4dict.p__Seq._Seq-Max  AND as4dict.p__Seq._Seq-max > 0 
  then     
      _Sequence._Seq-Max    =  as4dict.p__Seq._Seq-Max. 

if _Sequence._Seq-Min <> as4dict.p__Seq._Seq-Min then     
      _Sequence._Seq-Min    =  as4dict.p__Seq._Seq-Min. 

IF as4dict.p__seq._Seq-Misc[1] = "" THEN 
   ASSIGN _Sequence._Seq-Misc[1] = ?.
ELSE if _Sequence._Seq-Misc[1] <> as4dict.p__Seq._Seq-Misc[1] then 
         _Sequence._Seq-Misc[1]   =     as4dict.p__Seq._Seq-Misc[1].
         
IF as4dict.p__seq._Seq-Misc[2] = "" THEN 
   ASSIGN _Sequence._Seq-Misc[2] = ?.
ELSE if _Sequence._Seq-Misc[2] <> as4dict.p__Seq._Seq-Misc[2] then        
       _Sequence._Seq-Misc[2]   =     as4dict.p__Seq._Seq-Misc[2].
       
IF as4dict.p__seq._Seq-Misc[3] = "" THEN 
  ASSIGN _Sequence._Seq-Misc[3] = ?.
ELSE if _Sequence._Seq-Misc[3] <> as4dict.p__Seq._Seq-Misc[3] then 
       _Sequence._Seq-Misc[3]   =     as4dict.p__Seq._Seq-Misc[3].

IF as4dict.p__seq._Seq-Misc[4] = "" THEN 
  ASSIGN _Sequence._Seq-Misc[4] = ?.
ELSE if _Sequence._Seq-Misc[4] <> as4dict.p__Seq._Seq-Misc[4] then 
       _Sequence._Seq-Misc[4]   =     as4dict.p__Seq._Seq-Misc[4].
       
IF as4dict.p__seq._Seq-Misc[5] = "" THEN 
  ASSIGN _Sequence._Seq-Misc[5] = ?.
ELSE if _Sequence._Seq-Misc[5] <> as4dict.p__Seq._Seq-Misc[5] then 
       _Sequence._Seq-Misc[5]   =     as4dict.p__Seq._Seq-Misc[5].
       
IF as4dict.p__seq._Seq-Misc[6] = "" THEN 
  ASSIGN _Sequence._Seq-Misc[6] = ?.
ELSE if _Sequence._Seq-Misc[6] <> as4dict.p__Seq._Seq-Misc[6] then 
       _Sequence._Seq-Misc[6]   =     as4dict.p__Seq._Seq-Misc[6].
       
IF as4dict.p__seq._Seq-Misc[7] = "" THEN 
  ASSIGN _Sequence._Seq-Misc[7] = ?.
ELSE if _Sequence._Seq-Misc[7] <> as4dict.p__Seq._Seq-Misc[7] then 
       _Sequence._Seq-Misc[7]   =     as4dict.p__Seq._Seq-Misc[7].

IF as4dict.p__seq._Seq-Misc[8] = "" THEN 
  ASSIGN _Sequence._Seq-Misc[8] = ?.
ELSE if _Sequence._Seq-Misc[8] <> as4dict.p__Seq._Seq-Misc[8] then 
       _Sequence._Seq-Misc[8]   =     as4dict.p__Seq._Seq-Misc[8].    

