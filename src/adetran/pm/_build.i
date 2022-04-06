/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*

Procedure:    adetran/pm/_build.i
Author:       R. Ryan/F. Chang
Created:      4/94
Updated:      4/96 DRH
		12/96 SLK TOOLTIP & :U for format statements
Purpose:      Include file for pm/_build.p
Background:   Include file that has the temp-file definitions
Notes:        The temp-tables are as follows:

                _tpfield    field-level definitions for each object
                _frame      frame definition for each frame
                _tpmnufld   field-level definitions for menus
                _tpbrw      top-level definitions for browser
                _tpbrwfld   field-level definitions for browser

Called by:    pm/_build.p
*/


DEFINE TEMP-TABLE _tpmnufld   NO-UNDO
  FIELD _fldseq               AS INTEGER
  FIELD _mnuname              AS CHARACTER
  FIELD _parmnu               AS CHARACTER
  FIELD _type                 AS CHARACTER FORMAT "x":U
  FIELD _mnufld               AS CHARACTER.

DEFINE TEMP-TABLE _tpbrw      NO-UNDO
  FIELD _fldseq               AS INTEGER
  FIELD _brwname              AS CHARACTER
  FIELD _brwh                 AS DECIMAL
  FIELD _brww                 AS DECIMAL
  FIELD _tooltip	      AS CHARACTER FORMAT "x(256)":U.

DEFINE TEMP-TABLE _tpbrwfld   NO-UNDO
  FIELD _fldseq               AS INTEGER
  FIELD _brwname              AS CHARACTER
  FIELD _brwfld               AS CHARACTER.

DEFINE TEMP-TABLE _tpfield    NO-UNDO
  FIELD _seq-num              AS INTEGER
  FIELD _frame                AS CHARACTER
  FIELD _type                 AS CHARACTER FORMAT "x(2)":U
  FIELD _name                 AS CHARACTER FORMAT "x(50)":U

  FIELD _bgcolor              AS INTEGER
  FIELD _col-label            AS CHARACTER FORMAT "x(256)":U
  FIELD _color-mode           AS CHARACTER
  FIELD _data-type            AS INTEGER
  FIELD _edge-pixels          AS INTEGER
  FIELD _expand               AS LOGICAL
  FIELD _fgcolor              AS INTEGER
  FIELD _font                 AS INTEGER
  FIELD _format               AS CHARACTER FORMAT "x(50)":U
  FIELD _height               AS DECIMAL
  FIELD _help                 AS CHARACTER FORMAT "x(256)":U
  FIELD _image-up             AS CHARACTER FORMAT "x(256)":U
  FIELD _initial              AS CHARACTER FORMAT "x(256)":U
  FIELD _inner-lines          AS INTEGER
  FIELD _label                AS CHARACTER FORMAT "x(256)":U
  FIELD _list-items           AS CHARACTER FORMAT "x(256)":U
  FIELD _literal-value        AS CHARACTER FORMAT "X(256)":U
  FIELD _max-value            AS INTEGER
  FIELD _min-value            AS INTEGER
  FIELD _multiple             AS LOGICAL
  FIELD _no-fill              AS LOGICAL
  FIELD _no-label             AS LOGICAL
  FIELD _orientation          AS CHARACTER FORMAT "x(1)":U
  FIELD _position-unit        AS CHARACTER
  FIELD _scrollbar-h          AS LOGICAL
  FIELD _scrollbar-v          AS LOGICAL
  FIELD _size-unit            AS CHARACTER
  FIELD _sort                 AS LOGICAL
  FIELD _table                AS CHARACTER FORMAT "x(30)":U
  FIELD _valid-expr           AS CHARACTER FORMAT "x(30)":U
  FIELD _valid-msg            AS CHARACTER FORMAT "x(30)":U
  FIELD _widget               AS CHARACTER FORMAT "x(30)":U
  FIELD _width                AS DECIMAL
  FIELD _x                    AS DECIMAL
  FIELD _y                    AS DECIMAL
  FIELD _dbname               AS CHARACTER
  FIELD _tblname              AS CHARACTER
  FIELD _numdown              AS INTEGER
  FIELD _separators           AS LOGICAL
  FIELD _numcell              AS INTEGER
  FIELD _fld-title            AS CHARACTER
  FIELD _fld-no-box           AS LOGICAL
  FIELD _tooltip	            AS CHARACTER FORMAT "x(256)":U
  FIELD _style                AS CHARACTER
  FIELD _list-item-pairs      AS LOGICAL
   INDEX sequence  IS UNIQUE PRIMARY _seq-num
   INDEX FrameName _frame _x _y.
  
DEFINE TEMP-TABLE _frame      NO-UNDO
  FIELD _frame_seq-num        AS INTEGER
  FIELD _frame                AS CHARACTER
  FIELD _name                 AS CHARACTER FORMAT "x(50)"
  FIELD _widget               AS CHARACTER FORMAT "x(50)"

  FIELD _bgcolor              AS INTEGER
  FIELD _browse               AS LOGICAL
  FIELD _color-mode           AS CHARACTER
  FIELD _dialog-box           AS LOGICAL
  FIELD _down                 AS INTEGER
  FIELD _fgcolor              AS INTEGER
  FIELD _font                 AS INTEGER
  FIELD _header-height        AS INTEGER
  FIELD _height               AS DECIMAL
  FIELD _iteration-height     AS INTEGER
  FIELD _keep-tab-order       AS LOGICAL
  FIELD _no-attr-space        AS LOGICAL
  FIELD _no-box               AS LOGICAL
  FIELD _no-hide              AS LOGICAL
  FIELD _no-labels            AS LOGICAL
  FIELD _no-underline         AS LOGICAL
  FIELD _no-validate          AS LOGICAL
  FIELD _overlay              AS LOGICAL
  FIELD _page-bottom          AS LOGICAL
  FIELD _page-top             AS LOGICAL
  FIELD _position-unit        AS CHARACTER
  FIELD _scrollable           AS LOGICAL
  FIELD _side-labels          AS LOGICAL
  FIELD _size-to-fit          AS LOGICAL
  FIELD _size-unit            AS CHARACTER
  FIELD _three-d              AS LOGICAL
  FIELD _title                AS CHARACTER FORMAT "x(256)"
  FIELD _title-bgcolor        AS INTEGER
  FIELD _title-color-mode     AS CHARACTER
  FIELD _title-fgcolor        AS INTEGER
  FIELD _title-font           AS INTEGER
  FIELD _top-only             AS LOGICAL
  FIELD _width                AS DECIMAL
  FIELD _x                    AS DECIMAL
  FIELD _y                    AS DECIMAL
   INDEX sequence  IS UNIQUE PRIMARY _frame_seq-num
   INDEX FrameName _frame.
