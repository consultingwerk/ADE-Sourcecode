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
/* as4dict/load/copy_flt.i */

ASSIGN
  {&to}._Event       = {&from}._Event          
  {&to}._Fld-number = {&from}._fld-number
  {&to}._Field-Recid = {&from}._Field-recid
  {&to}._Field-Rpos  = {&from}._Field-Rpos
  {&to}._File-Recid  = {&from}._File-Recid            
  {&to}._File-number = {&from}._File-number
  {&to}._Override    = {&from}._Override
  {&to}._Proc-Name   = {&from}._Proc-Name
  {&to}._Trig-Crc    = {&from}._Trig-Crc.
