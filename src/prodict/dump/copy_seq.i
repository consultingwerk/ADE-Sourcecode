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

file: prodict/dump/copy_seq.i

-------------------------------------------------------------*/

ASSIGN
  {&to}._Cycle-Ok    = {&from}._Cycle-Ok
  {&to}._Db-recid    = {&from}._Db-recid
  {&to}._Seq-Incr    = {&from}._Seq-Incr
  {&to}._Seq-Init    = {&from}._Seq-Init
  {&to}._Seq-Max     = {&from}._Seq-Max
  {&to}._Seq-Min     = {&from}._Seq-Min
  {&to}._Seq-Name    = {&from}._Seq-Name
  {&to}._Seq-Num     = {&from}._Seq-Num
  {&to}._Seq-Misc[1] = {&from}._Seq-Misc[1]
  {&to}._Seq-Misc[2] = {&from}._Seq-Misc[2]
  {&to}._Seq-Misc[3] = {&from}._Seq-Misc[3]
  {&to}._Seq-Misc[4] = {&from}._Seq-Misc[4]
  {&to}._Seq-Misc[5] = {&from}._Seq-Misc[5]
  {&to}._Seq-Misc[6] = {&from}._Seq-Misc[6]
  {&to}._Seq-Misc[7] = {&from}._Seq-Misc[7]
  {&to}._Seq-Misc[8] = {&from}._Seq-Misc[8].

/*-----------------------------------------------------------*/
