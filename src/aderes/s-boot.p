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
 * s-boot.p - initialize various module settings
 */

{ aderes/s-system.i }
{ aderes/s-define.i }
{ aderes/e-define.i }
{ aderes/s-output.i }
{ aderes/r-define.i }
{ aderes/l-define.i }

DEFINE VARIABLE e_count   AS INTEGER   NO-UNDO. /* export counter */
DEFINE VARIABLE l_count   AS INTEGER   NO-UNDO. /* label counter */
DEFINE VARIABLE p_count   AS INTEGER   NO-UNDO. /* page counter */
DEFINE VARIABLE qbf-c     AS CHARACTER NO-UNDO. /* scrap */
DEFINE VARIABLE qbf-m     AS CHARACTER NO-UNDO EXTENT 2.
DEFINE VARIABLE resdotl   AS CHARACTER NO-UNDO. /* results.l file */

ASSIGN
  qbf-e-cat       = ""
  qbf-l-cat       = ""
  qbf-p-cat       = ""
  resdotl         = SEARCH("aderes/results.l":u)
  .
  
IF resdotl = ? THEN 
  resdotl = SEARCH("results.l":u).

/*--------------------------------------------------------------------------*/
/*
"h" - headers?
"f" - fixed width?
"i" - needs initial prepass to count records?
"b" - base date or ? to export date as char

code    |description/name     |program |h|f|c| beg  end  dlm  sep |typ
--------|---------------------|--------|-|-|-|--------------------|-----
PROGRESS|PROGRESS Export      |e-pro   |n|n|n|- 32,13,10 34 32    |*
ASCII   |Generic ASCII        |e-ascii |n|n|y|- 13,10 34 44       |*
ASCII-H |ASCII w/headers      |e-ascii |y|n|y|- 13,10 34 44       |*
FIXED   |Fixed-width ASCII    |e-ascii |n|y|y|- 13,10 34 44       |*
FIXED-H |Fixed w/headers      |e-ascii |y|y|y|- 13,10 34 44       |*
CSV     |Comma Separated Value|e-ascii |n|n|n|- 13,10 34 44       |123
DBASE-2 |dBASE II             |e-dbase |y|y|n|32 - - -            |*
DBASE-3 |dBASE III            |e-dbase |y|y|n|32 - - -            |*
DBASE-3+|dBASE III+           |e-dbase |y|y|n|32 - - -            |*
DBASE-4 |dBASE IV             |e-dbase |y|y|n|32 - - -            |*
DIF     |DIF                  |e-dif   |n|n|n|- - - -             |*
DIF-DASN|DIF dates as numbers |e-dif   |n|n|n|- - - -             |*
OFISW   |CTOS/BTOS OfisWriter |e-ascii |y|n|n|42,124 10 - 124     |*
SDF     |System Data Format   |e-ascii |n|y|n|- 13,10 - -         |*
SYLK    |SYLK                 |e-sylk  |n|n|n|- - - -             |*
123/1A  |Lotus 1-2-3/1A       |e-wks   |n|n|n|- - - -             |*
123/2   |Lotus 1-2-3/2        |e-wks   |n|n|n|- - - -             |*
SYM/1.0 |Symphony 1.0         |e-wks   |n|n|n|- - - -             |*
SYM/1.1 |Symphony 1.1         |e-wks   |n|n|n|- - - -             |*
WORD    |Microsoft Word       |e-ascii |y|n|n|- 13,10 34 44       |123
WORD4WIN|MS Word for Windows  |e-ascii |y|n|n|- 13,10 - 9         |123
WPERF   |WordPerfect          |e-ascii |n|n|n|- 5,13,10 - 18,13,10|*
WS      |WordStar             |e-ascii |n|n|n|- 13,10 34 44       |123
USER-1  |Sample Export        |u-export|n|n|n|- - - - -           |*
*/

/*--------------------------------------------------------------------------*/
IF resdotl <> ? THEN DO:
  INPUT FROM VALUE(resdotl) NO-ECHO.
  
  REPEAT:
    qbf-m = "".
    
    IMPORT qbf-m.
    
    IF qbf-m[1] BEGINS "#":u 
      OR qbf-m[1] BEGINS "~/*":u 
      OR qbf-m[1] BEGINS "~\*":u 
      OR qbf-m[2] BEGINS "*":u THEN NEXT.

    IF qbf-m[1] BEGINS "export":u 
      AND e_count < (EXTENT(qbf-e-cat) - 1) THEN
      ASSIGN
        e_count            = e_count + 1
        qbf-e-cat[e_count] = qbf-m[2].
        
    ELSE IF qbf-m[1] BEGINS "label":u 
      AND l_count < EXTENT(qbf-l-cat)
      AND NUM-ENTRIES(qbf-m[2],"|":u) > 0 THEN 
      ASSIGN
        l_count            = l_count + 1
        qbf-l-cat[l_count] = REPLACE(qbf-m[2],"|":u,",":u).
        
    ELSE IF qbf-m[1] BEGINS "page":u 
      AND p_count < EXTENT(qbf-p-cat)
      AND NUM-ENTRIES(qbf-m[2],"|":u) > 0 THEN
      ASSIGN
        p_count            = p_count + 1
        qbf-p-cat[p_count] = REPLACE(qbf-m[2],"|":u,",":u).
        
    ELSE IF qbf-m[1] BEGINS "left-delim":u THEN 
      qbf-left = qbf-m[2].
    ELSE IF qbf-m[1] BEGINS "right-delim":u THEN 
      qbf-right = qbf-m[2].
  END.
  
  INPUT CLOSE.
END.

/* add in sample export format */
qbf-c = SEARCH("aderes/u-export.p":u).

IF qbf-c <> ? THEN
  qbf-e-cat[e_count + 1] = "t=USER-1|p=":u
                         + SUBSTRING(qbf-c,1,LENGTH(qbf-c,"CHARACTER":u) - 2,
                                     "CHARACTER":u)
                         + "|h=n|f=n|c=n|i=n|d=*|2=13,10|l=":u
                         + "Sample Export".

/*--------------------------------------------------------------------------*/

FOR EACH qbf-rsys WHERE NOT qbf-rsys.qbf-live:
  DELETE qbf-rsys.
END.
CREATE qbf-rsys.

ASSIGN
  qbf-rsys.qbf-live              = FALSE
  qbf-rsys.qbf-format            = "Letter"
  qbf-rsys.qbf-dimen             = "8-1/2 x 11 in"
  qbf-rsys.qbf-origin-hz         = 1
  qbf-rsys.qbf-page-size         = 60 /* best for laser printers */
  qbf-rsys.qbf-space-hz          = 1
  qbf-rsys.qbf-space-vt          = 1
  qbf-rsys.qbf-origin-vt         = 1
  qbf-rsys.qbf-header-body       = 1
  qbf-rsys.qbf-body-footer       = 1
  qbf-rsys.qbf-page-eject        = ""

  qbf-printer#    = 1
  qbf-printer[1]  = 'Printer':t24
  qbf-pr-dev[1]   = 'PRINTER':u
  qbf-pr-perm[1]  = '*':u
  qbf-pr-type[1]  = 'to':u
  qbf-pr-width[1] = 80
  
  qbf-l-auto[ 1]  = 'name,*name*,contact,*contact*':u     /* name */
  qbf-l-auto[ 2]  = '*street,*addr,*address,*address*1':u /* addr1 */
  qbf-l-auto[ 3]  = '*po*box*,*address*2':u               /* addr2 */
  qbf-l-auto[ 4]  = '*address*3':u                        /* addr3 */
  qbf-l-auto[ 5]  = 'city,*city*':u                       /* city */
  qbf-l-auto[ 6]  = 'st,state,*state*':u                  /* state */
  qbf-l-auto[ 7]  = 'zip,*zip*':u                         /* zip */
  qbf-l-auto[ 8]  = 'zip*4':u                             /* zip+4 */
  qbf-l-auto[ 9]  = '*csz*,*city*st*z*':u                 /* c-s-z */
  qbf-l-auto[10]  = '*country*':u                         /* cntry */

  qbf-u-hook                     = ?
  qbf-u-hook[{&ahLogo}]          = "aderes/u-logo.p":u
  qbf-u-hook[{&ahDirSwitchCode}] = "aderes/u-direct.p":u
  qbf-u-hook[{&ahFeatCheckCode}] = ?                     
  qbf-u-hook[{&ahLogin}]         = "aderes/_slogin.p":u  
  qbf-u-hook[{&ahSharedVar}]     = ?
  qbf-u-hook[{&ahSecFeatCode}]   = ?
  qbf-u-hook[{&ahSecWhereCode}]  = ?
  qbf-u-hook[{&ahSecTableCode}]  = ?                     
  qbf-u-hook[{&ahSecFieldCode}]  = ?
  .

RETURN.

/* s-boot.p - end of file */

