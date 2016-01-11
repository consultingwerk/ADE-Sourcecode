/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
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

