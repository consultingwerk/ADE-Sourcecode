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
/* fbdefine.i - form and browse specific defines */

/* Form and browse frame properties */
DEFINE {1} SHARED TEMP-TABLE qbf-frame /* NOT NO-UNDO */
  FIELD qbf-ftbl AS CHARACTER /* table list (matches qbf-section.qbf-stbl) */
  FIELD qbf-frow AS DECIMAL   EXTENT 2 INIT 0  /* frame row */
  FIELD qbf-fflg AS CHARACTER EXTENT 2 INIT "" /* flags "r,t"- read-only,top */
  FIELD qbf-fbht AS INTEGER                    /* browse height */
  FIELD qbf-fwdt AS DECIMAL            INIT 0. /* frame width - only for form */

/* Indexes into qbf-frame array fields for Form and Browse */
&GLOBAL-DEFINE F_IX  1
&GLOBAL-DEFINE B_IX  2

/* Default # of rows for browse (browse height) for 1 section views and 
   master-detail views.
*/
&IF "{&WINDOW-SYSTEM}" BEGINS "MS-WIN" &THEN
&GLOBAL-DEFINE BRW_HT_1	   9
&ELSE
&GLOBAL-DEFINE BRW_HT_1	   8
&ENDIF
&GLOBAL-DEFINE BRW_HT_2	   5

/* Widgets handles for each field in each of the form frames (1 field/record) */
DEFINE {1} SHARED TEMP-TABLE qbf-fwid NO-UNDO /* form widgets */
  FIELD qbf-fwix    AS INTEGER  /* associated index in qbf-rcx arrays */
  FIELD qbf-fwfram  AS INTEGER  /* the frame suffix for this field. */
  FIELD qbf-fwmain  AS HANDLE   /* handle in main frame */
  FIELD qbf-fwdlg   AS HANDLE   /* handle in add/update dialog  */
  FIELD qbf-fwqbe   AS HANDLE   /* handle in the qbe dialog */
  INDEX qbf-fwid-ix IS UNIQUE qbf-fwix.

/* Height of a fill-in based on fixed-pitch font (FONT 0). 
   ** Keep ROW_GAP in sync with f-fixup.p which can't include this **
*/
DEFINE {1} SHARED VARIABLE qbf-fillht AS DECIMAL NO-UNDO. 
&IF "{&WINDOW-SYSTEM}" BEGINS "MS-WIN" &THEN
  &GLOBAL-DEFINE ROW_GAP  .08  /* extra row spacing needed on Windows */
&ELSE
  &GLOBAL-DEFINE ROW_GAP  0 
&ENDIF

/* minimum row so frame doesn't overlap toolbar */
&GLOBAL-DEFINE FB_MINROW (IF lGlbToolbar THEN (FRAME fToolbar:HEIGHT + 1) ELSE 1)

/* To remember the current rowids between form and browse views.
   [1] = master, [2] = detail
   Each entry is a comma separated list.  The first entry is the query
   row and the remaining entries are rowids representing the
   current record (one rowid per table in the query).
   qbf-use-rowids indicates whether we want the code that form or
   browse will generate next time to use these.
*/
DEFINE {1} SHARED VARIABLE qbf-rowids     AS CHARACTER EXTENT 2 NO-UNDO 
      	   INITIAL [?,?].
DEFINE {1} SHARED VARIABLE qbf-use-rowids AS LOGICAL NO-UNDO INIT NO.

/* Some macros for code generation */
/* # of components in frame name (separated by "-") */
&GLOBAL-DEFINE FNAM_COMP  3   

/* Is this a calculated (etc.) field? */
&GLOBAL-DEFINE CALCULATED  qbf-rcc[qbf_i] <> "":u
&GLOBAL-DEFINE TEXT_LIT    CAN-DO(qbf-o,STRING(qbf_i))
&GLOBAL-DEFINE NOT_SUPPORTED_IN_BROWSE ~
  CAN-DO("c,e,p,x,r":u, SUBSTRING(qbf-rcc[qbf_i],1,1,"CHARACTER":u))
&GLOBAL-DEFINE NOT_SUPPORTED_IN_FORM ~
  CAN-DO("c,e,p,r":u, SUBSTR(qbf-rcc[qbf_i],1,1,"CHARACTER":u))

/* This code supports outer joins where you'd have more than one
   section (e.g., two queries) corresponding to a single frame.
   This is not supported for now and probably never will be for
   browse.  Leave for possible change in future.  For now outer joins
   are only supported when there's a master-detail split.
*/
&GLOBAL-DEFINE GET_FRAME_SECTIONS ~
  FOR EACH qbf_sbuffer WHERE qbf_sbuffer.qbf-sfrm = qbf-section.qbf-sfrm: ~
    qbf_l = qbf_l + (IF qbf_l = "" THEN "" ELSE ",":u) ~
	    + qbf_sbuffer.qbf-sout. ~
  END.

/* If at least one member of qbf_l (list of sections) is in qbf-rcs[qbf_i] 
   then proceed. 
*/
&GLOBAL-DEFINE IF_NOT_IN_FRAME_THEN_NEXT ~
    DO qbf_k = 1 TO NUM-ENTRIES(qbf-rcs[qbf_i]): ~
      IF CAN-DO(qbf_l,ENTRY(qbf_k,qbf-rcs[qbf_i])) THEN LEAVE. ~
    END. ~
    IF qbf_k > NUM-ENTRIES(qbf-rcs[qbf_i]) THEN NEXT.

/* When formats are store, CR's are stored as single exclamations ("!")
   and each exclamation that the user types is doubled and stored as "!!". 
   This works great for column labels since this is what Progress 
   expects.  But for form and browse, we want to translate the single
   "!"'s (which were CR's) into spaces and translate each double "!"
   to a single "!" which is what the user typed in the first place.
   (Use CHR(10) here as just a temp replacement character.)
*/
&GLOBAL-DEFINE FB_FIX_LABEL ~
   lbl = REPLACE(lbl, "!!", CHR(10)) ~
   lbl = REPLACE(lbl, "!":u, " ") ~
   lbl = REPLACE(lbl, CHR(10), "!")

/* There is a limit of 320 on the row, col, width, height of widgets 
   and frames.  We deal with widget widths > 320 in other ways since
   they may want a format of x(350) for example. 
   However to prevent other horrible errors, don't let the user enter
   a form row or column that's bigger than 280 which still allows for
   the row of buttons and margins etc.  I think 290 is the real limit
   but I feel safer with this.
*/   
&GLOBAL-DEFINE MAX-FORM-ROW 280

/* fbdefine.i - end of file */

