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

/* userpik.i - definitions for flexible 'pick' program _usrpick.p */
/*
pik_chosen - list of chosen element ids (was pik_choice)
pik_column - column position of frame   (0 for default)
pik_count  - number of elements in      (was pik_chextent)
pik_down   - iterations of down frame   (usually 0 for default)
pik_first  - first element out or ?     (same as pik_list[pik_chosen[1]])
pik_hide   - hide frame when done?
pik_init   - initial value to position cursor
pik_list   - list of elements in        (was pik_chlist)
pik_multi  - can pick multiple?         (was pik_multiple)
pik_number - number the elements?       (only with pik_multi)
pik_return - number of elements chosen  (was pik_chcnt)
pik_row    - row position of frame      (0 for default)
pik_skip   - use 'skip number' option   (only with pik_number)
pik_start  - set true/false from values in pik_chosen
pik_title  - title of frame             (spaces prepended and appended)
pik_wide   - use wide frame?
pik_text   - instructional text 
pik_help   - a help context Id to explain this use of the picker.
*/

/*input:*/
DEFINE {1} SHARED VARIABLE pik_column AS INTEGER                NO-UNDO.
DEFINE {1} SHARED VARIABLE pik_count  AS INTEGER                NO-UNDO.
DEFINE {1} SHARED VARIABLE pik_down   AS INTEGER                NO-UNDO.
DEFINE {1} SHARED VARIABLE pik_hide   AS LOGICAL   INITIAL TRUE NO-UNDO.
DEFINE {1} SHARED VARIABLE pik_init   AS CHARACTER INITIAL  ""	NO-UNDO.
DEFINE {1} SHARED VARIABLE pik_list   AS CHARACTER EXTENT 2000	NO-UNDO.
DEFINE {1} SHARED VARIABLE pik_multi  AS LOGICAL   INIT FALSE   NO-UNDO.
DEFINE {1} SHARED VARIABLE pik_number AS LOGICAL		NO-UNDO.
DEFINE {1} SHARED VARIABLE pik_row    AS INTEGER		NO-UNDO.
DEFINE {1} SHARED VARIABLE pik_skip   AS LOGICAL   INIT FALSE   NO-UNDO.
DEFINE {1} SHARED VARIABLE pik_title  AS CHARACTER		NO-UNDO.
DEFINE {1} SHARED VARIABLE pik_wide   AS LOGICAL		NO-UNDO.
DEFINE {1} SHARED VARIABLE pik_text   AS CHARACTER INITIAL ?	NO-UNDO.
DEFINE {1} SHARED VARIABLE pik_help   AS INTEGER 	        NO-UNDO.

/*output:*/
DEFINE {1} SHARED VARIABLE pik_chosen AS INTEGER   EXTENT 2000  NO-UNDO.
DEFINE {1} SHARED VARIABLE pik_first  AS CHARACTER              NO-UNDO.
DEFINE {1} SHARED VARIABLE pik_return AS INTEGER   INITIAL 0    NO-UNDO.

/*local:*/
DEFINE VARIABLE p_mark  AS CHARACTER NO-UNDO.
DEFINE VARIABLE p_recid AS INTEGER   NO-UNDO.
DEFINE VARIABLE nextnum AS INTEGER   NO-UNDO.

/*frames:*/
DEFINE {1} SHARED FRAME pick1.
DEFINE {1} SHARED FRAME pick2.

/*forms:*/
FORM
  p_mark            FORMAT "x(3)" NO-ATTR-SPACE SPACE(0)
  pik_list[p_recid] FORMAT "x(32)"   ATTR-SPACE SPACE(0)
  WITH FRAME pick1 SCROLL 1 OVERLAY NO-LABELS NO-ATTR-SPACE
  pik_down DOWN ROW pik_row COLUMN pik_column
  COLOR DISPLAY VALUE(pick-fg) PROMPT VALUE(pick-bg)
  TITLE COLOR VALUE(pick-fg) pik_title
  USE-TEXT.
FORM
  p_mark            FORMAT "x(3)" NO-ATTR-SPACE SPACE(0)
  pik_list[p_recid] FORMAT "x(40)"   ATTR-SPACE SPACE(0)
  WITH FRAME pick2 SCROLL 1 OVERLAY NO-LABELS NO-ATTR-SPACE
  pik_down DOWN ROW pik_row COLUMN pik_column
  COLOR DISPLAY VALUE(pick-fg) PROMPT VALUE(pick-bg)
  TITLE COLOR VALUE(pick-fg) pik_title
  USE-TEXT. 
  
/* This frame is used to display the next number in the
 * flagging sequence when 'skip' is turned on. Otherwise,
 * it is hidden.
 */
FORM
  nextnum FORMAT ">,>>9" NO-ATTR-SPACE SPACE(0)
  WITH FRAME fskip NO-LABELS TITLE "Next Num" USE-TEXT.
