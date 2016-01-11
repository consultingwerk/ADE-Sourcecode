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

/* as4dict/load/copy_idx.i  */

ASSIGN
  {&to}._Active     = {&from}._Active 
  {&to}._AS4-File = {&from}._AS4-File     
  {&to}._AS4-Library = {&from}._AS4-Library     
  {&to}._Desc       = {&from}._Desc
  {&to}._File-number = {&from}._File-number
  {&to}._Index-Name = {&from}._Index-Name
  {&to}._Unique     = {&from}._Unique
  {&to}._Wordidx    = {&from}._Wordidx
  {&to}._idx-num    = {&from}._idx-num
  {&to}._num-comp   = {&from}._num-comp

  {&to}._For-Name   = {&from}._For-Name
  {&to}._For-Type   = {&from}._For-Type
  
  {&to}._I-misc1[1] = {&from}._I-misc1[1]
  {&to}._I-misc2[4] = {&from}._I-misc2[4]
  {&to}._I-misc2[6] = {&from}._I-misc2[6].
