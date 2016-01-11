/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*------------------------------------------------------------- 

file: prodict/dump/copy_idx.i

-------------------------------------------------------------*/

ASSIGN
  {&to}._Active     = {&from}._Active
  {&to}._Desc       = {&from}._Desc
  {&to}._File-recid = {&from}._File-recid
  {&to}._Index-Name = {&from}._Index-Name
  {&to}._Unique     = {&from}._Unique
  {&to}._Wordidx    = {&from}._Wordidx
  {&to}._ianum      = {&from}._ianum
  {&to}._idx-num    = {&from}._idx-num
  {&to}._num-comp   = {&from}._num-comp

  {&to}._For-Name   = {&from}._For-Name
  {&to}._For-Type   = {&from}._For-Type

  {&to}._I-misc1[1] = {&from}._I-misc1[1]  
  {&to}._I-misc1[2] = {&from}._I-misc1[2]  
  {&to}._I-misc1[3] = {&from}._I-misc1[3]  
  {&to}._I-misc1[4] = {&from}._I-misc1[4]  
  {&to}._I-misc1[5] = {&from}._I-misc1[5]  
  {&to}._I-misc1[6] = {&from}._I-misc1[6]  
  {&to}._I-misc1[7] = {&from}._I-misc1[7]  
  {&to}._I-misc1[8] = {&from}._I-misc1[8]

  {&to}._I-misc2[1] = {&from}._I-misc2[1]  
  {&to}._I-misc2[2] = {&from}._I-misc2[2]  
  {&to}._I-misc2[3] = {&from}._I-misc2[3]  
  {&to}._I-misc2[4] = {&from}._I-misc2[4]  
  {&to}._I-misc2[5] = {&from}._I-misc2[5]  
  {&to}._I-misc2[6] = {&from}._I-misc2[6]  
  {&to}._I-misc2[7] = {&from}._I-misc2[7]  
  {&to}._I-misc2[8] = {&from}._I-misc2[8]

  {&to}._I-res1[1]  = {&from}._I-res1[1]  
  {&to}._I-res1[2]  = {&from}._I-res1[2]  
  {&to}._I-res1[3]  = {&from}._I-res1[3]  
  {&to}._I-res1[4]  = {&from}._I-res1[4]  
  {&to}._I-res1[5]  = {&from}._I-res1[5]  
  {&to}._I-res1[6]  = {&from}._I-res1[6]  
  {&to}._I-res1[7]  = {&from}._I-res1[7]  
  {&to}._I-res1[8]  = {&from}._I-res1[8]

  {&to}._I-res2[1]  = {&from}._I-res2[1]  
  {&to}._I-res2[2]  = {&from}._I-res2[2]  
  {&to}._I-res2[3]  = {&from}._I-res2[3]  
  {&to}._I-res2[4]  = {&from}._I-res2[4]  
  {&to}._I-res2[5]  = {&from}._I-res2[5]  
  {&to}._I-res2[6]  = {&from}._I-res2[6]  
  {&to}._I-res2[7]  = {&from}._I-res2[7]  
  {&to}._I-res2[8]  = {&from}._I-res2[8]
  
  {&to}._index-attributes[1] = {&from}._index-attributes[1]. /* To copy is-local index value */
/*-----------------------------------------------------------*/
