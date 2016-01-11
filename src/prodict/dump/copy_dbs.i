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

file: prodict/dump/copy_dbs.i

-------------------------------------------------------------*/

ASSIGN
  {&to}._Db-addr       	= {&from}._Db-addr
  {&to}._Db-comm       	= {&from}._Db-comm
  {&to}._Db-local      	= {&from}._Db-local
  {&to}._Db-name       	= {&from}._Db-name
  {&to}._Db-revision   	= {&from}._Db-revision
  {&to}._Db-slave      	= {&from}._Db-slave
  {&to}._Db-type       	= {&from}._Db-type
  {&to}._Db-xlate[1]   	= {&from}._Db-xlate[1]
  {&to}._Db-xlate[2]   	= {&from}._Db-xlate[2]
  {&to}._Db-xl-name    	= {&from}._Db-xl-name
  {&to}._Db-collate[1]	= {&from}._Db-collate[1]
  {&to}._Db-collate[2]	= {&from}._Db-collate[2]
  {&to}._Db-collate[3]	= {&from}._Db-collate[3]
  {&to}._Db-collate[4]	= {&from}._Db-collate[4]
  {&to}._Db-collate[5]	= {&from}._Db-collate[5]
  {&to}._Db-coll-name   = {&from}._Db-coll-name
  
  {&to}._Db-misc2[1]    = {&from}._Db-misc2[1]
  {&to}._Db-misc2[2]    = {&from}._Db-misc2[2]
  {&to}._Db-misc2[3]    = {&from}._Db-misc2[3]
  {&to}._Db-misc2[4]    = {&from}._Db-misc2[4]
  {&to}._Db-misc2[5]    = {&from}._Db-misc2[5]
  {&to}._Db-misc2[6]    = {&from}._Db-misc2[6]
  {&to}._Db-misc2[7]    = {&from}._Db-misc2[7]
  {&to}._Db-misc2[8]    = {&from}._Db-misc2[8]
  
  {&to}._Db-misc1[1]    = {&from}._Db-misc1[1]
  {&to}._Db-misc1[2]    = {&from}._Db-misc1[2]
  {&to}._Db-misc1[3]    = {&from}._Db-misc1[3]
  {&to}._Db-misc1[4]    = {&from}._Db-misc1[4]
  {&to}._Db-misc1[5]    = {&from}._Db-misc1[5]
  {&to}._Db-misc1[6]    = {&from}._Db-misc1[6]
  {&to}._Db-misc1[7]    = {&from}._Db-misc1[7]
  {&to}._Db-misc1[8]    = {&from}._Db-misc1[8].

/*-----------------------------------------------------------*/
