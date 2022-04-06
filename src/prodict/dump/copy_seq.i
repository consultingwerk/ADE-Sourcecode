/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
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
