/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* ====================================================================
   file     File-api.i  
   purpose  initializes hFileApi
   by       Jurjen Dijkstra, 1997
   ==================================================================== */

{af/sup/proextra.i}

&IF DEFINED(FILE-API_I)=0 &THEN
&GLOB FILE-API_I

&IF "{&OPSYS}":U="WIN32":U &THEN
   &GLOB LB_DIR  397
&ELSE
   &GLOB LB_DIR 1038
&ENDIF

/* file attributes you might want to check: */   
&GLOB DDL_READWRITE     0
&GLOB DDL_READONLY      1
&GLOB DDL_HIDDEN        2
&GLOB DDL_SYSTEM        4
&GLOB DDL_VOLUMEID      8 /* undocumented */
&GLOB DDL_DIRECTORY    16
&GLOB DDL_ARCHIVE      32
&GLOB DDL_DRIVES    16384
&GLOB DDL_EXCLUSIVE 32768

def new global shared var hpFileApi as handle.
if not valid-handle(hpFileApi) then run af/sup/file-api.p persistent set hpFileApi.

&ENDIF /* if defined FILE-API_I */

