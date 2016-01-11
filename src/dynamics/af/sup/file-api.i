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

