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

/* Procedure crtmptbl.p
   Donna L. McMann
   June 26, 1997
   
   This procedure creates tempory table entries used in the incremental dump for
   comparasion to determine the needed entries to change the source database to
   the target database.
   
   Modified D. McMann 08/07/97 Removed WHERE from query
            D. McMann 06/04/98 Added assignment of _Fld-misc2[2] for null
                               capable 98-06-04-010
            D. McMann 04/07/00 Added _Prime-index to workfile
*/   

{ as4dict/dump/userpik.i }

DEFINE QUERY pfile FOR as4dict.p__File FIELDS (_Can-create _Can-delete _Can-dump _Can-load
_can-read _can-write _Desc _dump-name _Prime-index _file-label _File-label-sa _file-name _file-number
_Frozen _Hidden _valexp _valmsg _valmsg-sa).

DEFINE QUERY pfield FOR as4dict.p__Field FIELDS (_Fld-number _can-read _can-write _Col-label
_Col-label-sa _Data-type _dtype _Decimals _Desc _Extent _field-name _file-number _fld-case
_Format _Format-sa _Help _Help-sa _Initial _Initial-sa _label _Label-sa _Mandatory _Fld-misc2[5]
_Order _valexp _valmsg _valmsg-sa _view-as).

DEFINE QUERY pindex FOR as4dict.p__Index FIELDS (_Active _Desc _File-number _Index-name _Idx-num
_Unique _Wordidx).

DEFINE QUERY pidxfd FOR as4dict.p__Idxfd FIELDS (_Fld-number _Abbreviate _Ascending _File-number 
_Idx-num _Index-seq).

DEFINE QUERY pseq FOR as4dict.p__Seq FIELDS(_Cycle-ok _Seq-incr _Seq-init _Seq-max _Seq-min 
_Seq-name).

DEFINE QUERY ptrgfl FOR as4dict.p__trgfl FIELDS(_event _file-number _override _Proc-name
_Trig-crc).

DEFINE QUERY ptrgfd FOR as4dict.p__trgfd FIELDS(_Fld-number _Event _File-number _Override
_Proc-name _trig-crc _Field-rpos).

run adecomm/_setcurs.p ("WAIT").

OPEN QUERY pfile FOR EACH as4dict.p__File NO-LOCK.

GET FIRST pfile.
DO WHILE AVAILABLE(as4dict.p__File):

  CREATE wfil.
  ASSIGN wfil._Can-create = as4dict.p__File._Can-create
         wfil._Can-delete = as4dict.p__File._Can-delete
         wfil._Can-dump = as4dict.p__File._Can-dump
         wfil._Can-load = as4dict.p__File._Can-load
         wfil._Can-read = as4dict.p__File._can-read
         wfil._Can-write = as4dict.p__File._can-write
         wfil._Desc = as4dict.p__File._Desc
         wfil._dump-name = as4dict.p__File._Dump-name
         wfil._Prime-Index = as4dict.p__File._Prime-index
         wfil._File-label = as4dict.p__File._file-label
         wfil._File-label-sa = as4dict.p__File._File-label-sa
         wfil._file-name = as4dict.p__File._File-name
         wfil._File-number = as4dict.p__File._file-number
         wfil._Frozen = as4dict.p__File._Frozen
         wfil._Hidden = as4dict.p__File._Hidden
         wfil._Valexp = as4dict.p__File._valexp
         wfil._valmsg = as4dict.p__File._valmsg
         wfil._valmsg-sa = as4dict.p__File._valmsg-sa.
  GET NEXT pfile.
END.
CLOSE QUERY pfile.

OPEN QUERY pfield FOR EACH as4dict.p__Field NO-LOCK.
GET FIRST pfield.
DO WHILE AVAILABLE(as4dict.p__Field):
   IF as4dict.p__Field._Fld-misc2[5] <> "A" THEN DO:
    CREATE wfld.
    ASSIGN wfld._Fld-number = as4dict.p__Field._Fld-number
           wfld._can-read = as4dict.p__Field._can-read
           wfld._can-write = as4dict.p__Field._can-write
           wfld._Col-label = as4dict.p__Field._Col-label
           wfld._Col-label-sa = as4dict.p__Field._Col-label-sa
           wfld._Data-type = as4dict.p__Field._Data-type
           wfld._Dtype = as4dict.p__Field._Dtype 
           wfld._Decimals = as4dict.p__Field._Decimals
           wfld._Desc = as4dict.p__Field._Desc
           wfld._Extent = as4dict.p__Field._Extent
           wfld._field-name = as4dict.p__Field._Field-name
           wfld._file-number = as4dict.p__Field._file-number
           wfld._fld-case = as4dict.p__Field._fld-case
           wfld._Fld-misc2[2] = as4dict.p__Field._Fld-misc2[2]
           wfld._Format = as4dict.p__Field._Format
           wfld._Format-sa = as4dict.p__Field._Format-sa
           wfld._Help = as4dict.p__Field._Help
           wfld._Help-sa = as4dict.p__Field._Help-sa
           wfld._Initial = as4dict.p__Field._Initial
           wfld._Initial-sa = as4dict.p__Field._Initial-sa
           wfld._label = as4dict.p__Field._label
           wfld._Label-sa = as4dict.p__Field._label-sa
           wfld._Mandatory = as4dict.p__Field._mandatory
           wfld._Order = as4dict.p__Field._order
           wfld._valexp = as4dict.p__Field._valexp
           wfld._valmsg = as4dict.p__Field._valmsg
           wfld._valmsg-sa = as4dict.p__Field._valmsg-sa
           wfld._view-as = as4dict.p__Field._view-as.
   END.
   GET NEXT pfield.             
END.
CLOSE QUERY pfield.

OPEN QUERY pindex FOR EACH as4dict.p__Index NO-LOCK.
GET FIRST pindex.
DO WHILE AVAILABLE(as4dict.p__Index):

  CREATE widx.
  ASSIGN widx._Active = as4dict.p__Index._Active
         widx._Desc  = as4dict.p__Index._Desc
         widx._File-number = as4dict.p__Index._File-number
         widx._Index-name = as4dict.p__Index._Index-name
         widx._Idx-num = as4dict.p__Index._Idx-num
         widx._Unique = as4dict.p__Index._Unique
         widx._Wordidx = as4dict.p__Index._Wordidx.
  GET NEXT pindex.
END.   
CLOSE QUERY pindex.

OPEN QUERY pidxfd FOR EACH as4dict.p__Idxfd NO-LOCK.
GET FIRST pidxfd.
DO WHILE AVAILABLE(as4dict.p__Idxfd):
 
  CREATE wixf.
  ASSIGN wixf._Fld-number = as4dict.p__Idxfd._Fld-number
         wixf._Abbreviate = as4dict.p__Idxfd._Abbreviate
         wixf._Ascending = as4dict.p__Idxfd._Ascending
         wixf._File-number = as4dict.p__Idxfd._File-number 
         wixf._Idx-num = as4dict.p__Idxfd._Idx-num
         wixf._Index-seq = as4dict.p__Idxfd._Index-seq.

  GET NEXT pidxfd.
END.
CLOSE QUERY pidxfd.

OPEN QUERY ptrgfl FOR EACH as4dict.p__Trgfl NO-LOCK.
GET FIRST ptrgfl.
DO WHILE AVAILABLE(as4dict.p__Trgfl):
    
    CREATE wfit.
    ASSIGN wfit._event = as4dict.p__Trgfl._event
           wfit._file-number = as4dict.p__Trgfl._File-number
           wfit._override  = as4dict.p__Trgfl._Override
           wfit._Proc-name = as4dict.p__Trgfl._Proc-name
           wfit._Trig-crc = as4dict.p__Trgfl._Trig-crc.

  GET NEXT ptrgfl.
END.
CLOSE QUERY ptrgfl.

OPEN QUERY ptrgfd FOR EACH as4dict.p__Trgfd NO-LOCK.
GET FIRST ptrgfd.
DO WHILE AVAILABLE(as4dict.p__Trgfd):
    
    CREATE wflt.
    ASSIGN wflt._Fld-number = as4dict.p__Trgfd._Fld-number
           wflt._Event = as4dict.p__Trgfd._Event
           wflt._File-number = as4dict.p__Trgfd._File-number
           wflt._Override = as4dict.p__Trgfd._Override
           wflt._Proc-name = as4dict.p__Trgfd._Proc-name
           wflt._trig-crc = as4dict.p__Trgfd._Trig-crc
           wflt._Field-rpos = as4dict.p__Trgfd._Field-rpos.
  GET NEXT ptrgfd.
END.
CLOSE QUERY ptrgfd.

OPEN QUERY pseq FOR EACH as4dict.p__Seq NO-LOCK.
GET FIRST pseq.
DO WHILE AVAILABLE(as4dict.p__seq):
    
    CREATE wseq.
    ASSIGN wseq._Cycle-ok = as4dict.p__Seq._Cycle-ok
           wseq._Seq-incr = as4dict.p__Seq._Seq-incr
           wseq._Seq-init = as4dict.p__Seq._Seq-init
           wseq._Seq-max = as4dict.p__Seq._Seq-max
           wseq._Seq-min = as4dict.p__Seq._Seq-min 
           wseq._Seq-name = as4dict.p__Seq._Seq-name.
  GET NEXT pseq.
END.
CLOSE QUERY pseq.

run adecomm/_setcurs.p ("").

RETURN. 

          

