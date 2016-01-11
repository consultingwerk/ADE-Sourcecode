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
/* r-define.i - report definitions */

DEFINE {1} SHARED WORK-TABLE qbf-rsys NO-UNDO
  FIELD qbf-live         AS LOGICAL   /* TRUE=live data or FALSE=template */
  FIELD qbf-format       AS CHARACTER /* page size format name */
  FIELD qbf-dimen        AS CHARACTER /* */
  FIELD qbf-origin-hz    AS INTEGER   /* left margin */
  FIELD qbf-origin-vt    AS INTEGER   /* top margin */
  FIELD qbf-page-size    AS INTEGER   /* page size (# lines) */
  FIELD qbf-space-hz     AS INTEGER   /* column spacing */
  FIELD qbf-space-vt     AS INTEGER   /* line spacing */
  FIELD qbf-header-body  AS INTEGER   /* header-body spacing */
  FIELD qbf-body-footer  AS INTEGER   /* body-footer spacing */
  FIELD qbf-page-eject   AS CHARACTER /* page-eject field */
  FIELD qbf-width        AS INTEGER.  /* report width - internal use only! */

DEFINE {1} SHARED WORK-TABLE qbf-hsys NO-UNDO
  FIELD qbf-hpos AS INTEGER
  FIELD qbf-htxt AS CHARACTER EXTENT 8  /* up to 8 header/footer lines */
  FIELD qbf-hgen AS CHARACTER EXTENT 8  /* space for generated code */
  FIELD qbf-hwid AS INTEGER   EXTENT 8  /* width of generated code */
  FIELD qbf-hmax AS INTEGER.            /* max width of generated code */
  /*INDEX qbf-hsys-index IS PRIMARY UNIQUE qbf-hpos.*/
/*
qbf-hpos = 1 for Left Header   | =  6 for Right Footer
         = 2 for Center Header | =  7 for First-page-only Header
         = 3 for Right Header  | =  8 for Last-page-only Footer
         = 4 for Left Footer   | =  9 for Cover Page Text
         = 5 for Center Footer | = 10 for Final Page Text

Use negative qbf-hpos for system defaults, positive for current query.
qbf-hgen & qbf-hwid for internal use only!  used when r-write.p running.
*/

DEFINE {1} SHARED VARIABLE qbf-p-cat  AS CHARACTER EXTENT 64 NO-UNDO.
/*
Each element in qbf-p-cat[] contains entries which are one or more of
the following codes, in any order:
  c=                 comments
  d=                 dimensions (width x height), in. or mm.
  h= qbf-page-size   page height in lines @ 6 lpi
  w= qbf-width       page width in chars @ 10 cpi

Typical standard page size values for qbf-p-cat[]
  "d=8-1/2 x 11 in"|w=85|h=66|c=Letter"
  "d=8-1/2 x 14 in"|w=85|h=84|c=Legal"
  "d=11 x 17 in"|w=110|h=102|c=Tabloid"
  "d=9-1/2 x 4-1/8 in"|w=95|h=24|c=Envelope-#10"
  "d=229 x 162 mm"|w=90|h=38|c=Envelope-C5"
  "d=220 x 110 mm"|w=86|h=26|c=Envelope-DL"
  "d=7-1/2 x 3-7/8 in"|w=75|h=23|c=Envelope-Monarch"
  "d=7-1/4 x 10-1/2 in"|w=72|h=63|c=Executive"
  "d=297 x 420 mm"|w=117|h=99|c=A3"
  "d=210 x 297 mm"|w=82|h=70|c=A4"
  "d=148 x 210 mm"|w=58|h=49|c=A5"
  "d=182 x 257 mm"|w=71|h=60|c=B5"
  "d=7-1/3 x 11 in"|w=73|h=66|c=35mm-Slide"
*/

/*
for converion from V6 results:
  qbf-rsys.qbf-origin-hz   = qbf-r-attr[1]
  qbf-rsys.qbf-page-size   = qbf-r-attr[2]
  qbf-rsys.qbf-space-hz    = qbf-r-attr[3]
  qbf-rsys.qbf-space-vt    = qbf-r-attr[4]
  qbf-rsys.qbf-origin-vt   = qbf-r-attr[5]
  qbf-rsys.qbf-header-body = qbf-r-attr[6]
  qbf-rsys.qbf-body-footer = qbf-r-attr[7]
  qbf-summary              = qbf-r-attr[8] <> 0
  qbf-rsys.qbf-page-eject  = qbf-r-attr[9]
  qbf-rsys.qbf-detail      = 0
*/

/*
comments from s-define.i regarding V6 reports info

qbf-r-attr[ 1]:     rml (integer initial 1)  left margin
qbf-r-attr[ 2]:     rps (integer initial 66) page size
qbf-r-attr[ 3]:     rbs (integer initial 1)  column spacing
qbf-r-attr[ 4]:     rls (integer initial 1)  line spacing
qbf-r-attr[ 5]:     new (integer initial 1)  starting line
qbf-r-attr[ 6]:     integers initial 0 header-body spacing
qbf-r-attr[ 7]:     integers initial 0 body-footer spacing
qbf-r-attr[ 8]:     =0 for regular, =1 for summary report
qbf-r-attr[ 9]:     number of order-by to page-eject at, or 0
qbf-r-attr[10]:     <available>
qbf-r-head[ 1.. 3]: first-page-only header lines 1 to 3
qbf-r-head[ 4.. 6]: last-page-only  footer lines 1 to 3
qbf-r-head[ 7.. 9]: top-left   header lines 1 to 3
qbf-r-head[10..12]: top-center header lines 1 to 3
qbf-r-head[13..15]: top-right  header lines 1 to 3
qbf-r-head[16..18]: bot-left   footer lines 1 to 3
qbf-r-head[19..21]: bot-center footer lines 1 to 3
qbf-r-head[22..24]: bot-right  footer lines 1 to 3
*/

/* r-define.i - end of file */

