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

file: prodict/dump/copy_fld.i

-------------------------------------------------------------*/

IF {&all} THEN
  ASSIGN
    {&to}._Field-Name    = {&from}._Field-Name
    {&to}._File-recid    = {&from}._File-recid
    {&to}._Data-Type     = {&from}._Data-Type
    {&to}._dtype         = {&from}._dtype
    {&to}._Format        = {&from}._Format
    {&to}._Initial       = {&from}._Initial
    {&to}._Order         = {&from}._Order
    {&to}._field-rpos    = {&from}._field-rpos
    {&to}._sys-field     = {&from}._sys-field.
    
ASSIGN
  {&to}._Can-Read      = {&from}._Can-Read
  {&to}._Can-Write     = {&from}._Can-Write
  {&to}._Col-label     = {&from}._Col-label
  {&to}._Col-label-SA  = {&from}._Col-label-SA
  {&to}._Decimals      = {&from}._Decimals
  {&to}._Desc          = {&from}._Desc
  {&to}._Extent        = {&from}._Extent
  {&to}._Fld-case      = {&from}._Fld-case
  {&to}._Format-SA     = {&from}._Format-SA
  {&to}._Help          = {&from}._Help
  {&to}._Help-SA       = {&from}._Help-SA
  {&to}._Initial-SA    = {&from}._Initial-SA
  {&to}._Label         = {&from}._Label
  {&to}._Label-SA      = {&from}._Label-SA
  {&to}._Mandatory     = {&from}._Mandatory
  {&to}._Valexp        = {&from}._Valexp
  {&to}._Valmsg        = {&from}._Valmsg
  {&to}._Valmsg-SA     = {&from}._Valmsg-SA
  {&to}._View-As       = {&from}._View-As

  {&to}._Fld-stdtype   = {&from}._Fld-stdtype
  {&to}._Fld-stlen     = {&from}._Fld-stlen
  {&to}._Fld-stoff     = {&from}._Fld-stoff

  {&to}._For-Allocated = {&from}._For-Allocated
  {&to}._For-Id        = {&from}._For-Id
  {&to}._For-Itype     = {&from}._For-Itype
  {&to}._For-Maxsize   = {&from}._For-Maxsize
  {&to}._For-Name      = {&from}._For-Name
  {&to}._For-Retrieve  = {&from}._For-Retrieve
  {&to}._For-Scale     = {&from}._For-Scale
  {&to}._For-Separator = {&from}._For-Separator
  {&to}._For-Spacing   = {&from}._For-Spacing
  {&to}._For-Type      = {&from}._For-Type
  {&to}._For-Xpos      = {&from}._For-Xpos

  {&to}._Fld-misc1[1]  = {&from}._Fld-misc1[1]
  {&to}._Fld-misc1[2]  = {&from}._Fld-misc1[2]
  {&to}._Fld-misc1[3]  = {&from}._Fld-misc1[3]
  {&to}._Fld-misc1[4]  = {&from}._Fld-misc1[4]
  {&to}._Fld-misc1[5]  = {&from}._Fld-misc1[5]
  {&to}._Fld-misc1[6]  = {&from}._Fld-misc1[6]
  {&to}._Fld-misc1[7]  = {&from}._Fld-misc1[7]
  {&to}._Fld-misc1[8]  = {&from}._Fld-misc1[8]
  
  {&to}._Fld-misc2[1]  = {&from}._Fld-misc2[1]
  {&to}._Fld-misc2[2]  = {&from}._Fld-misc2[2] 
  {&to}._Fld-misc2[3]  = {&from}._Fld-misc2[3]
  {&to}._Fld-misc2[4]  = {&from}._Fld-misc2[4]
  {&to}._Fld-misc2[5]  = {&from}._Fld-misc2[5]
  {&to}._Fld-misc2[6]  = {&from}._Fld-misc2[6]
  {&to}._Fld-misc2[7]  = {&from}._Fld-misc2[7]
  {&to}._Fld-misc2[8]  = {&from}._Fld-misc2[8].

/*-----------------------------------------------------------*/
