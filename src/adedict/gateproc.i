/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
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

