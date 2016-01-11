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
File: as4synfd.i

Description:  These are the field assignments for the _Field
       file, which load the values stored in the p__Field record
       (AS/400) to the _Field (PROGRESS Schema file).  
       
       ***Note that there are some fields that we may
       not want to overlay with AS/400 information.  Recid fields
       will never be overlayed.  
       
History:

      nhorn     10/28/94   Created   
      DMcMann   02/16/96   Added assign of _Fld-number for sql null support.
      DMcMann   08/14/96   Changed how field number was determined for
                           null support.
-------------------------------------------------------------*/


/* ==================== Main Line Code  ===================== */

if _Field._For-name <> as4dict.p__Field._For-name 
   AND as4dict.p__Field._For-name <> "" then 
     _Field._For-name = as4dict.p__Field._For-name.

if _Field._Col-Label <> as4dict.p__Field._Col-Label 
AND as4dict.p__Field._Col-label <> "" then
     _Field._Col-Label = as4dict.p__Field._Col-Label.

if _Field._Col-Label-SA <> as4dict.p__Field._Col-Label-SA 
AND as4dict.p__Field._Col-Label-SA  <> "" then
     _Field._Col-Label-SA = as4dict.p__Field._Col-Label-SA.
     
if _Field._Decimals <> as4dict.p__Field._Decimals
AND as4dict.p__Field._Data-type = "decimal"   then
    _Field._Decimals = as4dict.p__Field._Decimals.

if _Field._Data-Type <> as4dict.p__Field._Data-Type 
AND as4dict.p__Field._Data-Type <> "" then
    _Field._Data-Type = as4dict.p__Field._Data-Type.
   
if _Field._Desc <> as4dict.p__Field._Desc 
AND as4dict.p__Field._Desc <> "" then     
    _Field._Desc  =  as4dict.p__Field._Desc. 

if _Field._Extent <> as4dict.p__Field._Extent
AND as4dict.p__Field._Extent <> 0 then
     _Field._Extent = as4dict.p__Field._Extent.
                                            
assign _Field._Fld-case = (if as4dict.p__Field._Fld-case = "Y" then yes else no).

/* Numbering fields for client to match how server is returning field
   number.  This value should be how the fields are positioned in the
   actual field.  This was needed for sql null support.          
*/
ASSIGN _Field._Fld-Misc1[1] = fldcnt.
IF as4dict.p__field._extent > 0 THEN
    ASSIGN fldcnt = fldcnt + as4dict.p__field._extent.
ELSE    
    ASSIGN fldcnt = fldcnt + 1.

if _Field._Fld-Misc1[2] <> as4dict.p__Field._Fld-Misc1[2] 
      AND as4dict.p__Field._Fld-Misc1[2] <> 0 then        
       _Field._Fld-Misc1[2]   =     as4dict.p__Field._Fld-Misc1[2].     
       
if _Field._Fld-Misc1[3] <> as4dict.p__Field._Fld-Misc1[3] 
      AND as4dict.p__Field._Fld-Misc1[3] <> 0 then 
       _Field._Fld-Misc1[3]   =     as4dict.p__Field._Fld-Misc1[3].   
       
if _Field._Fld-Misc1[4] <> as4dict.p__Field._Fld-Misc1[4]
      AND as4dict.p__Field._Fld-Misc1[4] <> 0 then 
       _Field._Fld-Misc1[4]   =     as4dict.p__Field._Fld-Misc1[4].   
       
if _Field._Fld-Misc1[5] <> as4dict.p__Field._Fld-Misc1[5] 
      AND as4dict.p__Field._Fld-Misc1[5] <> 0 then 
       _Field._Fld-Misc1[5]   =     as4dict.p__Field._Fld-Misc1[5].  
          
if _Field._Fld-Misc1[6] <> as4dict.p__Field._Fld-Misc1[6]
      AND as4dict.p__Field._Fld-Misc1[6] <> 0 then 
       _Field._Fld-Misc1[6]   =     as4dict.p__Field._Fld-Misc1[6].  

if _Field._Fld-Misc1[7] <> as4dict.p__Field._Fld-Misc1[7] 
      AND as4dict.p__Field._Fld-Misc1[7] <> 0 then 
       _Field._Fld-Misc1[7]   =     as4dict.p__Field._Fld-Misc1[7]. 
       
if _Field._Fld-Misc1[8] <> as4dict.p__Field._Fld-Misc1[8]
      AND as4dict.p__Field._Fld-Misc1[8] <> 0  then 
       _Field._Fld-Misc1[8]   =     as4dict.p__Field._Fld-Misc1[8].   
       

if _Field._Fld-Misc2[1] <> as4dict.p__Field._Fld-Misc2[1] 
      AND as4dict.p__Field._Fld-Misc2[1] <> "" then 
       _Field._Fld-Misc2[1]   =     as4dict.p__Field._Fld-Misc2[1].    
       
if _Field._Fld-Misc2[2] <> as4dict.p__Field._Fld-Misc2[2]
      AND as4dict.p__Field._Fld-Misc2[2] <> "" then        
       _Field._Fld-Misc2[2]   =     as4dict.p__Field._Fld-Misc2[2].   
       
if _Field._Fld-Misc2[3] <> as4dict.p__Field._Fld-Misc2[3]
      AND as4dict.p__Field._Fld-Misc2[3] <> "" then 
       _Field._Fld-Misc2[3]   =     as4dict.p__Field._Fld-Misc2[3].   
       
if _Field._Fld-Misc2[4] <> as4dict.p__Field._Fld-Misc2[4]
      AND as4dict.p__Field._Fld-Misc2[4] <> "" then 
       _Field._Fld-Misc2[4]   =     as4dict.p__Field._Fld-Misc2[4].   
       
if _Field._Fld-Misc2[5] <> as4dict.p__Field._Fld-Misc2[5]
      AND as4dict.p__Field._Fld-Misc2[5] <> "" then 
       _Field._Fld-Misc2[5]   =     as4dict.p__Field._Fld-Misc2[5].  
       
if _Field._Fld-Misc2[6] <> as4dict.p__Field._Fld-Misc2[6]
      AND as4dict.p__Field._Fld-Misc2[6] <> "" then 
       _Field._Fld-Misc2[6]   =     as4dict.p__Field._Fld-Misc2[6]. 
       
if _Field._Fld-Misc2[7] <> as4dict.p__Field._Fld-Misc2[7]
      AND as4dict.p__Field._Fld-Misc2[7] <> "" then 
       _Field._Fld-Misc2[7]   =     as4dict.p__Field._Fld-Misc2[7].  
       
if _Field._Fld-Misc2[8] <> as4dict.p__Field._Fld-Misc2[8]
      AND as4dict.p__Field._Fld-Misc2[8] <> "" then 
       _Field._Fld-Misc2[8]   =     as4dict.p__Field._Fld-Misc2[8].

if _Field._Fld-stdtype <> as4dict.p__Field._Fld-stdtype then 
       _Field._Fld-stdtype    =    as4dict.p__Field._Fld-stdtype. 
       
if _Field._Fld-stlen <> as4dict.p__Field._Fld-stlen then 
       _Field._Fld-stlen      =    as4dict.p__Field._Fld-stlen.

if _Field._Fld-stoff <> as4dict.p__Field._Fld-stoff then 
       _Field._Fld-stoff      =    as4dict.p__Field._Fld-stoff.    
       
if _Field._For-Allocated <> as4dict.P__Field._For-allocated 
      AND as4dict.p__Field._For-allocated <> 0 then
       _Field._For-allocated  =     as4dict.P__Field._For-allocated.       

if _Field._For-Id <> as4dict.p__Field._For-Id  then 
       _Field._For-Id         =     as4dict.p__Field._For-Id.
                          
if _Field._For-Itype <> as4dict.p__Field._For-Itype
      AND as4dict.p__Field._For-Itype <> 0  then 
       _Field._For-Itype      =     as4dict.p__Field._For-Itype.

if _Field._For-Maxsize <> as4dict.p__Field._For-Maxsize
      AND as4dict.p__Field._For-Maxsize <> 0  then 
       _Field._For-Maxsize    =     as4dict.p__Field._For-Maxsize.
       
if _Field._For-Primary <> as4dict.p__Field._For-Primary
      AND as4dict.p__Field._For-Primary <> 0   then 
       _Field._For-Primary     =     as4dict.p__Field._For-Primary.
       
if _Field._For-Scale <> as4dict.p__Field._For-Scale
      AND as4dict.p__Field._For-Scale <> 0   then 
       _Field._For-Scale      =     as4dict.p__Field._For-Scale.

if _Field._For-Separator <> as4dict.p__Field._For-Separator
      AND as4dict.p__Field._For-Separator <> ""  then 
       _Field._For-Separator      =     as4dict.p__Field._For-Separator.
       
if _Field._For-Spacing <> as4dict.p__Field._For-Spacing
      AND as4dict.p__Field._For-Spacing <> 0   then 
       _Field._For-Spacing       =     as4dict.p__Field._For-Spacing.
       
if _Field._For-Type <> as4dict.p__Field._For-Type then 
       _Field._For-Type       =     as4dict.p__Field._For-Type.
       
if _Field._For-Xpos <> as4dict.p__Field._For-Xpos then 
       _Field._For-Xpos       =     as4dict.p__Field._For-Xpos.

if _Field._Format <> as4dict.p__Field._Format then 
       _Field._Format         =     as4dict.p__Field._Format.

if _Field._Format-SA <> as4dict.p__Field._Format-SA
      AND as4dict.p__Field._Format-SA <> ""   then 
       _Field._Format-SA      =     as4dict.p__Field._Format-SA.

if _Field._Help <> as4dict.p__Field._Help
      AND as4dict.p__Field._Help <> ""  then 
       _Field._Help           =     as4dict.p__Field._Help.

if _Field._Help-SA <> as4dict.p__Field._Help-SA
      AND as4dict.p__Field._Help-SA <> ""  then 
       _Field._Help-SA      =     as4dict.p__Field._Help-SA.

if _Field._Initial <> as4dict.p__Field._Initial AND as4dict.p__Field._Initial <> "" then DO:
   IF _Field._dtype = 2 and as4dict.p__field._Initial = "0" THEN.
   ELSE  _Field._Initial =  as4dict.p__Field._Initial.
END.

if _Field._Initial-SA <> as4dict.p__Field._Initial-SA
      AND as4dict.p__Field._Initial <> ""  then 
       _Field._Initial-SA      =     as4dict.p__Field._Initial-SA.

if _Field._Label <> as4dict.p__Field._Label
      AND as4dict.p__Field._Label <> ""  then 
       _Field._Label     =     as4dict.p__Field._Label.

if _Field._Label-SA <> as4dict.p__Field._Label-SA 
      AND as4dict.p__Field._Label-SA <> "" then 
       _Field._Label-SA  =     as4dict.p__Field._Label-SA.

Assign _Field._Mandatory = (if as4dict.p__Field._Mandatory = "Y" then yes else no).

if _Field._Order <> as4dict.p__Field._Order then 
       _Field._Order         =     as4dict.p__Field._Order.       

if _Field._Valexp <> as4dict.p__Field._Valexp
      AND as4dict.p__Field._Valexp <> "" then 
       _Field._Valexp         =     as4dict.p__Field._Valexp.

if _Field._Valmsg <> as4dict.p__Field._Valmsg
      AND as4dict.p__Field._Valmsg <> "" then 
       _Field._Valmsg         =     as4dict.p__Field._Valmsg.

if _Field._Valmsg-SA <> as4dict.p__Field._Valmsg-SA
      AND as4dict.p__Field._Valmsg <> "" then 
       _Field._Valmsg-SA      =     as4dict.p__Field._Valmsg-SA. 
                                                      
if _Field._View-As <> as4dict.p__Field._View-As
      AND as4dict.p__Field._View-as <> "" then 
       _Field._View-As         =     as4dict.p__Field._View-As.
   
    
       
