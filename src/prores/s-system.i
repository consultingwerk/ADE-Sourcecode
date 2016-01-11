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
/* s-system.i - system-wide lookup tables */

/*--------------------------------------------------------------------------*/
/*
  qbf-dir-nam: local report directory
  qbf-ftbang:  true="-! $DLCFT/ftmsgs" set, false=no, ?=untested
  qbf-goodbye: true=quit, false=return
  qbf-left:    left labels/report header delimiter (default "{")
  qbf-module:  current module (see usage in results.p/s-module.p)
  qbf-name:    name from directory of current item
  qbf-product: current product name
  qbf-qcfile:  name/location of .qc file (sans ".qc")
  qbf-right:   right labels/report header delimiter (default "}")
  qbf-secure:  available modules
  qbf-signon:  signon program
  qbf-tempdir: location and "_qbf" prefix of temp _qbf*.* files
  qbf-time:    elapsed execution time for last report/label/export run
  qbf-toggle1: field - true=show label, false=show fieldname
  qbf-toggle2: file -  true=show desc, false=show filename
  qbf-toggle3: form -  1=show filename, 2=show prog name, 3=show desc
  qbf-toggle4: dir -   1=show desc, 2=databases, 3=show prog name
  qbf-total:   used for counts on exports and label prints
  qbf-vers:    revision level (see a-load.p)
*/
DEFINE {1} SHARED VARIABLE qbf-dir-nam AS CHARACTER                NO-UNDO.
DEFINE {1} SHARED VARIABLE qbf-ftbang  AS LOGICAL   INITIAL      ? NO-UNDO.
DEFINE {1} SHARED VARIABLE qbf-goodbye AS LOGICAL                  NO-UNDO.
DEFINE {1} SHARED VARIABLE qbf-left    AS CHARACTER INITIAL   "~{" NO-UNDO.
DEFINE {1} SHARED VARIABLE qbf-module  AS CHARACTER                NO-UNDO.
DEFINE {1} SHARED VARIABLE qbf-name    AS CHARACTER                NO-UNDO.
DEFINE {1} SHARED VARIABLE qbf-product AS CHARACTER                NO-UNDO.
DEFINE {1} SHARED VARIABLE qbf-qcfile  AS CHARACTER INITIAL      ? NO-UNDO.
DEFINE {1} SHARED VARIABLE qbf-right   AS CHARACTER INITIAL   "~}" NO-UNDO.
DEFINE {1} SHARED VARIABLE qbf-secure  AS CHARACTER INITIAL     "" NO-UNDO.
DEFINE {1} SHARED VARIABLE qbf-signon  AS CHARACTER INITIAL      ? NO-UNDO.
DEFINE {1} SHARED VARIABLE qbf-tempdir AS CHARACTER INITIAL "_qbf" NO-UNDO.
DEFINE {1} SHARED VARIABLE qbf-time    AS CHARACTER INITIAL     "" NO-UNDO.
DEFINE {1} SHARED VARIABLE qbf-toggle1 AS LOGICAL   INITIAL  FALSE NO-UNDO.
DEFINE {1} SHARED VARIABLE qbf-toggle2 AS LOGICAL   INITIAL  FALSE NO-UNDO.
DEFINE {1} SHARED VARIABLE qbf-toggle3 AS INTEGER   INITIAL      3 NO-UNDO.
DEFINE {1} SHARED VARIABLE qbf-toggle4 AS INTEGER   INITIAL      1 NO-UNDO.
DEFINE {1} SHARED VARIABLE qbf-total   AS INTEGER                  NO-UNDO.
DEFINE {1} SHARED VARIABLE qbf-vers    AS CHARACTER                NO-UNDO.

/*--------------------------------------------------------------------------*/
/*
  qbf-boolean: standard yes/no values for dialog box s-box.p
  qbf-continu: standard "Continue" value for dialog box s-error.p
  qbf-dtype:   datatypes
  qbf-etype:   calc field types
  qbf-xofy:    word "of" for "xxx of yyy" on scrolling lists
*/
DEFINE {1} SHARED VARIABLE qbf-boolean AS CHARACTER           NO-UNDO.
DEFINE {1} SHARED VARIABLE qbf-continu AS CHARACTER           NO-UNDO.
DEFINE {1} SHARED VARIABLE qbf-dtype   AS CHARACTER           NO-UNDO.
DEFINE {1} SHARED VARIABLE qbf-etype   AS CHARACTER           NO-UNDO.
DEFINE {1} SHARED VARIABLE qbf-xofy    AS CHARACTER           NO-UNDO.

/*--------------------------------------------------------------------------*/
/* color settings
  qbf-dhi: dialog box highlight
  qbf-dlo: dialog box normal
  qbf-mhi: menu highlight
  qbf-mlo: menu normal
  qbf-phi: pick list highlight
  qbf-plo: pick list normal
*/

DEFINE {1} SHARED VARIABLE qbf-dhi AS CHARACTER INITIAL "MESSAGES" NO-UNDO.
DEFINE {1} SHARED VARIABLE qbf-dlo AS CHARACTER INITIAL "NORMAL"   NO-UNDO.
DEFINE {1} SHARED VARIABLE qbf-mhi AS CHARACTER INITIAL "MESSAGES" NO-UNDO.
DEFINE {1} SHARED VARIABLE qbf-mlo AS CHARACTER INITIAL "NORMAL"   NO-UNDO.
DEFINE {1} SHARED VARIABLE qbf-phi AS CHARACTER INITIAL "MESSAGES" NO-UNDO.
DEFINE {1} SHARED VARIABLE qbf-plo AS CHARACTER INITIAL "NORMAL"   NO-UNDO.
