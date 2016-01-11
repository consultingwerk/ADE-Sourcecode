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

/*----------------------------------------------------------------------------

File: gateproc.i

Description:
   Configure the name of a gateway routine to call.

Arguments:
   &Suffix - the routine name suffix (following _ora for example).
   &Name   - the variable to set.

Author: Laura Stern

Date Created: 08/12/93 
     History: 04/04/00 D. McMann Added MSS database type.

----------------------------------------------------------------------------*/

&IF DEFINED(GATEPROC_VAR) = 0 &THEN /* in case someone includes this twice */
   Define var gdb_type  as char NO-UNDO.
   Define var gdb_otype as char NO-UNDO.
   &global-define GATEPROC_VAR ""
&ENDIF

assign
  gdb_type = s_DbCache_Type[s_DbCache_ix]
  gdb_otype = { adecomm/ds_type.i
                  &direction = "ODBC"
                  &from-type = "gdb_type"
                  }
  {&Name} = "prodict/" + 
   (if      gdb_type = "MSS"           then "mss/_mss{&Suffix}.p"
    else if gdb_type = "RDB"           then "rdb/_rdb{&Suffix}.p"
    else if gdb_type = "ORACLE"        then "ora/_ora{&Suffix}.p"
    else if gdb_type = "SYBASE"        then "syb/_syb{&Suffix}.p"
    else if gdb_type = "AS400"         then "as4/_as4{&Suffix}.p"
    else if gdb_type = "CTOSISAM"      then "bti/_bti{&Suffix}.p"
    else if CAN-DO(gdb_otype,gdb_type) then "odb/_odb{&Suffix}.p"
    else "").

