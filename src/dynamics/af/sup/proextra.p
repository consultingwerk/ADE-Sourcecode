/*********************************************************************
* Copyright (C) 2005 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

&if '{&OPSYS}' ne 'Unix' &then
/* ====================================================================
   file      ProExtra.p
   by        Jurjen Dijkstra, 1997
             mailto:jurjen.dijkstra@wxs.nl
             http://www.pugcentral.org/api
   language  Progress 8.2A
   purpose   interface to ProExtra.DLL containing some extra routines.
   note      ProExtra.DLL is not part of Progress, it's custom made
             by myself using Delphi 2.01 (but might have used C)
   ==================================================================== */

    DEFINE VARIABLE lv_dll_path AS CHARACTER NO-UNDO.

{af/sup/windows.i}

&IF "{&OPSYS}":U="WIN32":U &THEN
   &GLOB ProExtra "ProExtra.DLL"   
&ELSE   
   &GLOB ProExtra "ProExt16.DLL"   
   &MESSAGE "Have no 16-bit version of ProExtra.DLL, sorry"
&ENDIF

def var hProExtraDLL as integer no-undo.
hProExtraDLL = ?.

ASSIGN
    lv_dll_path = SEARCH( "af/sup/" + {&ProExtra} ).

RUN LoadLibrary{&A} in hpApi( lv_dll_path, output hProExtraDLL).

ON CLOSE OF THIS-PROCEDURE
DO:                       
  /* very important memory cleaner */
  if hProExtraDLL<>? then
     run FreeLibrary /* not in hpApi! */ (hProExtraDLL).
  hProExtraDLL = ?.
END.

/* define FreeLibrary again. It is called ON CLOSE and we can not
   be sure that hpApi is still valid at that time */
PROCEDURE FreeLibrary EXTERNAL {&KERNEL} :
  define input parameter hproc as {&HINSTANCE}.
END.

/* -------------- exported functions: ------------------- */

PROCEDURE Bit_Remove EXTERNAL {&PRoExtra} :
  define input-output parameter Flags   as LONG.
  define input        parameter OldFlag as LONG.
END PROCEDURE.

PROCEDURE Bit_Or EXTERNAL {&PRoExtra} :
  define input-output parameter Flags   as LONG.
  define input        parameter NewFlag as LONG.
END PROCEDURE.

PROCEDURE Bit_Xor EXTERNAL {&PRoExtra} :
  define input-output parameter Flags   as LONG.
  define input        parameter NewFlag as LONG.
END PROCEDURE.

PROCEDURE Bit_And EXTERNAL {&PRoExtra} :
  define input  parameter Flags        as LONG.
  define input  parameter TestFlag     as LONG.
  define return parameter FlagsAndTest as LONG.
END PROCEDURE.

&endif    /* OPSYS <> UNIX */
