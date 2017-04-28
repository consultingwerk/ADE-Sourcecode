/********************************************************************* *
* Copyright (C) 2000,2015 by Progress Software Corporation. All rights *
* reserved.  Prior versions of this work may contain portions          *
* contributed by participants of Possenet.                             *
*                                                                      *
***********************************************************************/

/*------------------------------------------------------------- 

file: prodict/dump/copy_fil.i

-------------------------------------------------------------*/

IF {&all} THEN
  ASSIGN
    {&to}._CRC          = {&from}._CRC
    {&to}._Cache        = {&from}._Cache
    {&to}._DB-lang      = {&from}._DB-lang
    {&to}._Db-recid     = {&from}._Db-recid
    {&to}._Dump-name    = {&from}._Dump-name
    {&to}._File-Number  = {&from}._File-Number
    {&to}._ianum        = {&from}._ianum
    {&to}._Frozen       = {&from}._Frozen
    {&to}._Last-change  = {&from}._Last-change
    {&to}._Prime-Index  = {&from}._Prime-Index
    {&to}._Template     = {&from}._Template
    {&to}._dft-pk       = {&from}._dft-pk
    {&to}._numfld       = {&from}._numfld
    {&to}._numkcomp     = {&from}._numkcomp
    {&to}._numkey       = {&from}._numkey
    {&to}._numkfld      = {&from}._numkfld
    {&to}._File-Attributes[1] = {&from}._File-Attributes[1]
    {&to}._File-Attributes[2] = {&from}._File-Attributes[2]
    {&to}._File-Attributes[3] = {&from}._File-Attributes[3].


    
ASSIGN
  {&to}._File-Name     = {&from}._File-Name
  {&to}._Desc	       = {&from}._Desc
  {&to}._File-Label    = {&from}._File-Label
  {&to}._File-Label-SA = {&from}._File-Label-SA
  {&to}._Hidden	       = {&from}._Hidden
  {&to}._Valexp	       = {&from}._Valexp
  {&to}._Valmsg	       = {&from}._Valmsg
  {&to}._Valmsg-SA     = {&from}._Valmsg-SA 
 
  {&to}._For-Cnt1      = {&from}._For-Cnt1
  {&to}._For-Cnt2      = {&from}._For-Cnt2
  {&to}._For-Flag      = {&from}._For-Flag
  {&to}._For-Format    = {&from}._For-Format
  {&to}._For-Id	       = {&from}._For-Id
  {&to}._For-Info      = {&from}._For-Info
  {&to}._For-Name      = {&from}._For-Name
  {&to}._For-Number    = {&from}._For-Number
  {&to}._For-Owner     = {&from}._For-Owner
  {&to}._For-Size      = {&from}._For-Size
  {&to}._For-Type      = {&from}._For-Type
 
  {&to}._Fil-misc1[1]  = {&from}._Fil-misc1[1]
  {&to}._Fil-misc1[2]  = {&from}._Fil-misc1[2]
  {&to}._Fil-misc1[3]  = {&from}._Fil-misc1[3]
  {&to}._Fil-misc1[4]  = {&from}._Fil-misc1[4] 
  {&to}._Fil-misc1[5]  = {&from}._Fil-misc1[5] 
  {&to}._Fil-misc1[6]  = {&from}._Fil-misc1[6]
  {&to}._Fil-misc1[7]  = {&from}._Fil-misc1[7] 
  {&to}._Fil-misc1[8]  = {&from}._Fil-misc1[8]
 
  {&to}._Fil-misc2[1]  = {&from}._Fil-misc2[1]
  {&to}._Fil-misc2[2]  = {&from}._Fil-misc2[2]
  {&to}._Fil-misc2[3]  = {&from}._Fil-misc2[3]
  {&to}._Fil-misc2[4]  = {&from}._Fil-misc2[4] 
  {&to}._Fil-misc2[5]  = {&from}._Fil-misc2[5] 
  {&to}._Fil-misc2[6]  = {&from}._Fil-misc2[6]
  {&to}._Fil-misc2[7]  = {&from}._Fil-misc2[7] 
  {&to}._Fil-misc2[8]  = {&from}._Fil-misc2[8].
  
IF COMPARE({&to}._Can-create,"NE", {&from}._Can-create,"RAW") THEN
    {&to}._Can-Create    = {&from}._Can-Create.
IF COMPARE({&to}._Can-delete,"NE",{&from}._Can-delete,"RAW") THEN
    {&to}._Can-Delete    = {&from}._Can-Delete.
IF COMPARE({&to}._Can-write,"NE",{&from}._Can-write,"RAW") THEN
    {&to}._Can-Write     = {&from}._Can-Write.
IF COMPARE({&to}._Can-read,"NE",{&from}._Can-read,"RAW") THEN
    {&to}._Can-Read      = {&from}._Can-Read.
IF COMPARE({&to}._Can-dump,"NE",{&from}._Can-dump,"RAW") THEN
    {&to}._Can-Dump      = {&from}._Can-Dump.
IF COMPARE({&to}._Can-load,"NE",{&from}._Can-load,"RAW") THEN
    {&to}._Can-Load      = {&from}._Can-Load.

/*-----------------------------------------------------------*/
