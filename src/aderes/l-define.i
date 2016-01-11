/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* l-define.i - label definitions */

DEFINE {1} SHARED TEMP-TABLE qbf-lsys NO-UNDO
  /* FIELD qbf-live      AS LOGICAL   /* true=query, false=template */  */
  FIELD qbf-type      AS CHARACTER /* label type */
  FIELD qbf-dimen     AS CHARACTER /* label dimension */
  FIELD qbf-across    AS INTEGER   /* number labels across */
  FIELD qbf-copies    AS INTEGER   /* copies of each */
  FIELD qbf-label-ht  AS INTEGER   /* label height */
  FIELD qbf-label-wd  AS INTEGER   /* label width */
  FIELD qbf-omit      AS LOGICAL   /* omit blank lines */
  FIELD qbf-origin-hz AS INTEGER   /* horiz origin on paper */
  FIELD qbf-space-hz  AS INTEGER   /* horiz space between labels */
  FIELD qbf-space-vt  AS INTEGER.  /* vert space between labels */

DEFINE {1} SHARED VARIABLE qbf-l-wh   AS HANDLE    NO-UNDO.
DEFINE {1} SHARED VARIABLE lbl-custom AS LOGICAL   NO-UNDO.
DEFINE {1} SHARED VARIABLE qbf-l-cat  AS CHARACTER NO-UNDO EXTENT 64.
/*
Each element in qbf-l-cat[] contains entries which are one or more of
the following codes, in any order:
  a= qbf-across    - number labels across       [default 1]
  c=               - comments
  d=               - dimensions (width x height) in inches
  h= qbf-label-ht  - label height in lines
  l= qbf-space-vt  - vert space between labels  [default 1]
  s= qbf-space-hz  - horiz space between labels [default 0]
  w= qbf-label-wd  - label width in chars
  x= qbf-origin-hz - horiz origin on paper      [default 0]

Typical standard values for qbf-l-cat[]
  'd=3-1/2"x15/16",x=0,w=35,h=5,a=1,s=0,l=1,c=1-wide',
  'd=3-1/2"x15/16",x=0,w=35,h=5,a=2,s=2,l=1,c=2-wide',
  'd=3-1/2"x15/16",x=0,w=35,h=5,a=3,s=2,l=1,c=3-wide',
  'd=3-1/2"x15/16",x=0,w=35,h=5,a=4,s=2,l=1,c=4-wide',
  'd=4"x1-7/16",x=0,w=40,h=8,a=1,l=1,s=0,c=',
  'd=3-2/10"x11/12",x=0,w=32,h=5,a=3,l=1,s=2,c=Cheshire',
  'd=6-1/2"x3-5/8",x=0,w=65,h=14,a=1,l=8,s=0,c=Envelope',
  'd=9-7/8"x7-1/8",x=0,w=78,h=17,a=1,l=8,s=0,c=Envelope',
  'd=4"x6",x=0,w=60,h=24,a=1,l=1,s=0,c=Post Cards',
  'd=3"x5",x=0,w=50,h=14,a=1,l=4,s=0,c=Rolodex',
  'd=4"x2-1/4",x=0,w=40,h=10,a=1,l=1,s=0,c=Rolodex',
  ''
*/

/*
for converion from V6 results:
  qbf-lsys.qbf-space-hz  = 0
  qbf-lsys.qbf-origin-hz = qbf-l-attr[1]
  qbf-lsys.qbf-label-wd  = qbf-l-attr[2]
  qbf-lsys.qbf-label-ht  = qbf-l-attr[3]
  qbf-lsys.qbf-space-vt  = qbf-l-attr[4]
  qbf-lsys.qbf-across    = qbf-l-attr[5]
  qbf-lsys.qbf-omit      = qbf-l-attr[6] <> 0
  qbf-lsys.qbf-copies    = qbf-l-attr[7]
*/

/*
for the future:
  FIELD qbf-down      AS INTEGER   /* number labels down */
  FIELD qbf-origin-vt AS INTEGER   /* vert origin on paper */
  FIELD qbf-paper-ht  AS INTEGER   /* paper height */
  FIELD qbf-paper-wd  AS INTEGER   /* paper width */
  FIELD qbf-shape     AS CHARACTER /* shape */
  FIELD qbf-sheet     AS CHARACTER /* sheet type */
  FIELD qbf-units     AS CHARACTER /* units */

qbf-shape - r=rounded rectangle, s=squared rectangle, c=circle (ellipse)
qbf-sheet - c=continuous roll, f=fanfold, i=individual sheets
qbf-units - i=inches, m=millimeters, c=characters/lines
*/

/*
comments from s-define.i regarding V6 labels info

qbf-l-attr[1]:     l-x-lm (int) left margin
qbf-l-attr[2]:     l-x-ls (int) label width
qbf-l-attr[3]:     l-y-th (int) total height
qbf-l-attr[4]:     l-y-tm (int) top margin
qbf-l-attr[5]:     l-x-na (int) number across
qbf-l-attr[6]:     l-omit (int, 0=false, 1=true) omit blank lines
qbf-l-attr[7]:     copies (int)
qbf-l-auto[1..10]: can-do style patterns for selecting fields:
                   name,addr1,addr2,addr3,city,state,zip,zip+4,csz,country
qbf-l-text[1..66]: label text and fields (note UNDO-able!)
*/

/* l-define.i - end of file */

