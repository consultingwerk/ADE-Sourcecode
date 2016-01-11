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
/*
 * y-define.i - window defines for main and persistent popup windows
 */

DEFINE {1} SHARED VARIABLE qbf-win AS HANDLE NO-UNDO.

DEFINE {1} SHARED WORK-TABLE qbf-wsys
  FIELD qbf-wwin  AS HANDLE             /* window */
  FIELD qbf-wfrm  AS HANDLE             /* frame */
  FIELD wStatus   AS HANDLE
  FIELD qbf-wfld  AS HANDLE    EXTENT 4 /* "page", num#1, "of", num#2 */
  FIELD qbf-wbut  AS HANDLE    EXTENT 8 /* prt,goto,lst,prev,nxt,frst,ok,help */
  FIELD qbf-wedi  AS HANDLE             /* editor widget */
  FIELD qbf-wrect AS HANDLE             /* rectangle widget */
  FIELD qbf-wfile AS CHARACTER          /* filename */
  FIELD qbf-wsize AS INTEGER            /* from qbf-rsys.qbf-page-size) */
  FIELD qbf-wpage AS INTEGER            /* page number */
  FIELD qbf-wlast AS INTEGER            /* last page */
  FIELD qbf-wback AS INTEGER            /* seek back position */
  FIELD qbf-wseek AS INTEGER   EXTENT 1024.   /* page offsets into file */
  /*INDEX qbf-wsys-index IS PRIMARY UNIQUE
    qbf-wwin.*/

/*
This is a shared stream for the first report opened only.  It is used
as an optimization to keep from having to open and close streams.  For
the second and subsequent reports, local viewing streams must be opened
and closed within the triggers.
*/
DEFINE {1} SHARED STREAM qbf-wio.

/* y-define.i - end of file */

