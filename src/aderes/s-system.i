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
 * s-system.i - system-wide lookup tables and variables
 */

/*--------------------------------------------------------------------------*/
/*
  qbf-awrite:   write fastload files: true=after dialog,false=when exiting 
  qbf-count:    used for counts on exports and label prints (was qbf-total)
  qbf-depth:    depth for master-detail searches (>0 for auto, =0 for manual)
  qbf-detail:   table id of "parent" for child section, or 0 if no split
  qbf-dirty:    query has been altered since the last save
  qbf-field:    reselect field list, since table was deleted in label view
  qbf-goodbye:  should RESULTS return to calling program or quit?
  qbf-governor: number of records to process for reports, latbels, export
  qbf-govergen: include Governor in generate code
  qbf-hidedb:   hide (dbname) after tablename when only one db available
  qbf-horiz:    horizontal offset for browse/report
  qbf-left:     left labels/report header delimiter (default "{")
  qbf-index:    index to field list, used to link form and field properties
  qbf-loctyp:   type of locking: false=no-lock, true=share-lock, ?=excl-lock
  qbf-module:   module a.k.a. view (see usage in results.p/s-module.p)
  qbf-name:     name from directory of current item
  qbf-preview:  count of Print Preview windows
  qbf-product:  product name
  qbf-qcfile:   name/location of .qc file (sans ".qc")
  qbf-qdfile:   local query directory
  qbf-qdhome:   initial local query directory
  qbf-qdpubl:   public query directory
  qbf-qdshow:   show qd entries requiring disconnected db's?
  qbf-redraw:   redraw screen
  qbf-report:   report opsys filename (used only for report-writer)
  qbf-right:    right labels/report header delimiter (default "}")
  qbf-summary:  true for summary (totals-only) report
  qbf-threed:   display RESULTS in 3D
  qbf-tempdir:  location and "qbf" prefix of temp qbf*.* files
  qbf-timing:   elapsed execution time for last report/label/export run
  qbf-toggle1:  field - true=show label, false=show fieldname
  qbf-toggle2:  file -  true=show desc, false=show filename
  qbf-toggle3:  form -  1=show filename, 2=show prog name, 3=show desc
  qbf-toggle4:  dir -   true=show desc, false=show prog name
  qbf-vers:     revision level (see results.p)
  qbf-widxit:   handle for form/browse exit button
  def-win-hit:  default window height
  def-win-wid:  default window width
  qbf-wlogo:    logo window handle
*/			   
DEFINE {1} SHARED VARIABLE lGlbStatus    AS LOGICAL   INITIAL TRUE  NO-UNDO.
DEFINE {1} SHARED VARIABLE lGlbToolbar   AS LOGICAL   INITIAL TRUE  NO-UNDO.
DEFINE {1} SHARED VARIABLE lGlbTooltext  AS LOGICAL   INITIAL FALSE NO-UNDO.
DEFINE {1} SHARED VARIABLE wGlbStatus    AS HANDLE                  NO-UNDO.
DEFINE {1} SHARED VARIABLE wGlbMainLoop  AS HANDLE                  NO-UNDO.

DEFINE {1} SHARED VARIABLE def-win-wid   AS INTEGER                 NO-UNDO.
DEFINE {1} SHARED VARIABLE qbf-count     AS INTEGER                 NO-UNDO.
DEFINE {1} SHARED VARIABLE qbf-depth     AS INTEGER   INITIAL     0 NO-UNDO.
DEFINE {1} SHARED VARIABLE qbf-detail    AS INTEGER   INITIAL     0 NO-UNDO.
DEFINE {1} SHARED VARIABLE qbf-dirty     AS LOGICAL                 NO-UNDO.
DEFINE {1} SHARED VARIABLE qbf-field     AS LOGICAL                 NO-UNDO.
DEFINE {1} SHARED VARIABLE qbf-goodbye   AS LOGICAL   INITIAL FALSE.
DEFINE {1} SHARED VARIABLE qbf-governor  AS INTEGER   INITIAL     0.
DEFINE {1} SHARED VARIABLE qbf-govergen  AS LOGICAL   INITIAL FALSE NO-UNDO.
DEFINE {1} SHARED VARIABLE qbf-hidedb    AS LOGICAL                 NO-UNDO.
DEFINE {1} SHARED VARIABLE qbf-horiz     AS INTEGER   INITIAL     1 NO-UNDO.
DEFINE {1} SHARED VARIABLE qbf-index     AS INTEGER   INITIAL     1 NO-UNDO.
DEFINE {1} SHARED VARIABLE qbf-left      AS CHARACTER INITIAL "~{".
DEFINE {1} SHARED VARIABLE qbf-loctyp    AS LOGICAL   INITIAL FALSE NO-UNDO.
DEFINE {1} SHARED VARIABLE qbf-module    AS CHARACTER INITIAL     ? NO-UNDO.
DEFINE {1} SHARED VARIABLE qbf-name      AS CHARACTER               NO-UNDO.
DEFINE {1} SHARED VARIABLE qbf-product   AS CHARACTER INIT "RESULTS".
DEFINE {1} SHARED VARIABLE qbf-preview   AS INTEGER                 NO-UNDO.
DEFINE {1} SHARED VARIABLE _minLogo      AS C INIT "adeicon/results%".
DEFINE {1} SHARED VARIABLE qbf-qcfile    AS CHARACTER INITIAL     ? NO-UNDO.
DEFINE {1} SHARED VARIABLE qbf-qdfile    AS CHARACTER               NO-UNDO.
DEFINE {1} SHARED VARIABLE qbf-qdhome    AS CHARACTER               NO-UNDO.
DEFINE {1} SHARED VARIABLE qbf-qdpubl    AS CHARACTER               NO-UNDO.
DEFINE {1} SHARED VARIABLE qbf-qdshow    AS LOGICAL   INITIAL FALSE NO-UNDO.
DEFINE {1} SHARED VARIABLE qbf-redraw    AS LOGICAL   INITIAL FALSE NO-UNDO.
DEFINE {1} SHARED VARIABLE qbf-report    AS CHARACTER INITIAL     ? NO-UNDO.
DEFINE {1} SHARED VARIABLE qbf-right     AS CHARACTER INITIAL  "~}".
DEFINE {1} SHARED VARIABLE qbf-summary   AS LOGICAL   INITIAL FALSE NO-UNDO.
DEFINE {1} SHARED VARIABLE qbf-tempdir   AS CHARACTER INITIAL "qbf" NO-UNDO.
DEFINE {1} SHARED VARIABLE qbf-threed    AS LOGICAL   INITIAL TRUE.
DEFINE {1} SHARED VARIABLE qbf-timing    AS CHARACTER INITIAL    "" NO-UNDO.
DEFINE {1} SHARED VARIABLE qbf-toggle1   AS LOGICAL   INITIAL FALSE NO-UNDO.
DEFINE {1} SHARED VARIABLE qbf-toggle2   AS LOGICAL   INITIAL FALSE NO-UNDO.
DEFINE {1} SHARED VARIABLE qbf-toggle3   AS INTEGER   INITIAL     3 NO-UNDO.
DEFINE {1} SHARED VARIABLE qbf-toggle4   AS LOGICAL   INITIAL TRUE  NO-UNDO.
DEFINE {1} SHARED VARIABLE qbf-widxit    AS HANDLE                  NO-UNDO.
DEFINE {1} SHARED VARIABLE qbf-wlogo     AS HANDLE                  NO-UNDO.
DEFINE {1} SHARED VARIABLE glbCharWidth  AS INTEGER                 NO-UNDO.
DEFINE {1} SHARED VARIABLE glbCharHeight AS INTEGER                 NO-UNDO.
DEFINE {1} SHARED VARIABLE _iconPath     AS CHARACTER INITIAL ""    NO-UNDO.
DEFINE {1} SHARED VARIABLE _flagRebuild  AS LOGICAL   INITIAL FALSE NO-UNDO.
DEFINE {1} SHARED VARIABLE qbf-awrite    AS LOGICAL   INITIAL FALSE NO-UNDO.
DEFINE {1} SHARED VARIABLE qbf-checkdb   AS LOGICAL   INITIAL TRUE  NO-UNDO.
DEFINE {1} SHARED VARIABLE _configDirty  AS LOGICAL   INITIAL FALSE NO-UNDO.
DEFINE {1} SHARED VARIABLE _featDirty    AS LOGICAL   INITIAL FALSE NO-UNDO.
DEFINE {1} SHARED VARIABLE _uiDirty      AS LOGICAL   INITIAL FALSE NO-UNDO.
DEFINE {1} SHARED VARIABLE _writeReport  AS LOGICAL   INITIAL FALSE NO-UNDO.
DEFINE {1} SHARED VARIABLE _newConfig    AS LOGICAL   INITIAL FALSE NO-UNDO.
DEFINE {1} SHARED VARIABLE _qdWritable   AS LOGICAL   INITIAL TRUE  NO-UNDO.
DEFINE {1} SHARED VARIABLE _qdReadable   AS LOGICAL   INITIAL TRUE  NO-UNDO.
DEFINE {1} SHARED VARIABLE _wPublic      AS LOGICAL   INITIAL ?     NO-UNDO.
DEFINE {1} SHARED VARIABLE _rPublic      AS LOGICAL   INITIAL ?     NO-UNDO.
DEFINE {1} SHARED VARIABLE _wOther       AS LOGICAL   INITIAL ?     NO-UNDO.
DEFINE {1} SHARED VARIABLE _rOther       AS LOGICAL   INITIAL ?     NO-UNDO.

/* 2.1A is for V8 release
 * 2.0I support for status-area, toolbar
 * 2.0H supports default export types in results.l
 * 2.0G is for file -> table and outer join work and export changes
 * 2.0F is for tweeks to export/labels and user hooks
 * 2.0E is for labels changes
 * 2.0D is for new header/footer code
 * 2.0C contains second phase of join rewrite for 1:M etc.
 * 2.0B contains first phase of join rewrite for 1:M etc.
 * 2.0A is for major V7 rewrite
 
 * 1.3D is V6 for translation support
 * 1.3C is FCS V6 before translation changes
 * 1.3B for V6 beta development
 * 1.3A for V6 beta development
 * 1.2? for V6 development
 * 1.1F for V6 early development
 * 1.1E for V6 early development
 * 1.1D is last V5 customer shipment of RESULTS
 * 1.0? for V5 RESULTS development
 */
DEFINE {1} SHARED VARIABLE qbf-vers      AS CHARACTER INITIAL "2.1A":u NO-UNDO.

/* Window width must take into account PPU size and readjust especially for
   unusual, i.e. Japanese VGA 12, screen/font combinations -dma */
def-win-wid = IF "{&WINDOW-SYSTEM}":u BEGINS "MS-WIN":u THEN
                (IF SESSION:PIXELS-PER-COLUMN < 7 THEN
                INTEGER(7 / SESSION:PIXELS-PER-COLUMN * 90) ELSE 90)
                ELSE 95.

/* Minimum height must be big enough for toolbar, status bar, 
   label header and a bit more. */
&GLOBAL-DEFINE DEF_WIN_HEIGHT 16
&GLOBAL-DEFINE MIN_WIN_WIDTH  50
&GLOBAL-DEFINE MIN_WIN_HEIGHT 8

/* default size of window in pixels.  Set before user has a chance 
   to resize. */
DEFINE {1} SHARED VARIABLE def-wid-pix AS DECIMAL NO-UNDO. 
DEFINE {1} SHARED VARIABLE def-hit-pix  AS DECIMAL NO-UNDO.

/* dialog box shrinkage factor (in PPUs) for wierd screen/font */
DEFINE {1} SHARED VARIABLE shrink-hor   AS DECIMAL NO-UNDO. /* 20 */
DEFINE {1} SHARED VARIABLE shrink-hor-2 AS DECIMAL NO-UNDO. /* {&shrink-hor} / 2 - 1 */
DEFINE {1} SHARED VARIABLE shrink-ver   AS DECIMAL NO-UNDO. /* 5 */

/*--------------------------------------------------------------------------*/
/* qbf-dtype: datatypes
   qbf-etype: calc field types
*/
DEFINE {1} SHARED VARIABLE qbf-dtype       AS CHARACTER NO-UNDO.
DEFINE {1} SHARED VARIABLE qbf-etype       AS CHARACTER NO-UNDO.
DEFINE {1} SHARED VARIABLE qbf-day-names   AS CHARACTER NO-UNDO.
DEFINE {1} SHARED VARIABLE qbf-month-names AS CHARACTER NO-UNDO.

/*--------------------------------------------------------------------------*/
/* This table holds the list of features, both RESULTS core and admin 
   defined. */
DEFINE {1} SHARED TEMP-TABLE _feature
  FIELD _id           AS CHARACTER
  FIELD _allowedUsers AS CHARACTER
  FIELD _state        AS LOGICAL
  FIELD _adminDefined AS LOGICAL 
  INDEX _id IS PRIMARY UNIQUE _id
  .

/*
 * The secure functions that RESULTS provides a default function. The
 * admin can can override it. This is the variables that hold the
 * function that will be run. Qbf-u-hook holds the name of the
 * functions provided by the user.
 */
DEFINE {1} SHARED VARIABLE _sfCheckSecurity AS CHARACTER NO-UNDO INITIAL ?.
DEFINE {1} SHARED VARIABLE _whereSecurity   AS CHARACTER NO-UNDO INITIAL ?.
DEFINE {1} SHARED VARIABLE _menuCheck       AS CHARACTER NO-UNDO INITIAL ?.
DEFINE {1} SHARED VARIABLE _tableCheck      AS CHARACTER NO-UNDO INITIAL ?.
DEFINE {1} SHARED VARIABLE _fieldCheck      AS CHARACTER NO-UNDO INITIAL ?.
DEFINE {1} SHARED VARIABLE _dirSwitch       AS CHARACTER NO-UNDO INITIAL ?.

/* The names of the files that hold the admin defined features and the 
 * admin designed menus. */
DEFINE {1} SHARED VARIABLE _adminFeatureFile AS CHARACTER.
DEFINE {1} SHARED VARIABLE _adminMenuFile    AS CHARACTER.

/* administration hooks */
&GLOBAL-DEFINE ahLogo           1 
&GLOBAL-DEFINE ahFeatCheckCode  2
&GLOBAL-DEFINE ahLogin          3
&GLOBAL-DEFINE ahSharedVar      4
&GLOBAL-DEFINE ahSecFeatCode    5
&GLOBAL-DEFINE ahSecWhereCode   6
&GLOBAL-DEFINE ahSecTableCode   7
&GLOBAL-DEFINE ahSecFieldCode   8
&GLOBAL-DEFINE ahUserMenu       9
&GLOBAL-DEFINE ahDirSwitchCode 10
&GLOBAL-DEFINE ahHookSize      16

DEFINE {1} SHARED VARIABLE qbf-u-hook 
  AS CHARACTER EXTENT {&ahHookSize} NO-UNDO.

/* configuration file name extension */
&GLOBAL-DEFINE qcUqExt          .qc7
&GLOBAL-DEFINE qcExt            "{&qcUqExt}":u
&GLOBAL-DEFINE qdUqExt          .qd7
&GLOBAL-DEFINE qdExt            "{&qdUqExt}":u

&GLOBAL-DEFINE ahQcNames "logo,sens,login,define,menu,where,table,field,option,direct":u

/*--------------------------------------------------------------------------*/
&GLOBAL-DEFINE mdir            adeshar
&GLOBAL-DEFINE TURN-OFF-CURSOR 1

/* s-system.i - end of file */

