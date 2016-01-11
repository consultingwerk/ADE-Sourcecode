/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*----------------------------------------------------------------------------

File: code.i

Description:
    This include file defines the Code Section TEMP-TABLE.  Mostly this contains
    procedures but it could also contain any code block.
    
    This stores code sections with one of the following variables:
      _section can be:
          _HIDDEN    -- don't show the user
               _special options:
          _CUSTOM    -- user editable code section
               _special options: 
                 _DEFINITIONS, _INCLUDED-LIB _MAIN-BLOCK
          _WORKSHOP  -- Workshop special sections    
          _PROCEDURE -- user-editable code
          _FUNCTION  -- user-editable code
          _CONTROL   -- user-editable event procedure associated with a field
    
Input Parameters:
   <None>

Output Parameters:
   <None>

Author: Wm. T. Wood

Date Created: Dec. 13, 1996 [Friday the 13th]

----------------------------------------------------------------------------*/

DEFINE {1} SHARED TEMP-TABLE _CODE
    FIELD _p-recid           AS RECID    /* Proceudre Object      */
    FIELD _l-recid           AS RECID    /* Linked Object         */
    FIELD _next-id           AS RECID    /* Next Section          */
    FIELD _prev-id           AS RECID    /* Previous Section       */
    FIELD _xftr-id           AS RECID    /* XFTR Recid [unused]   */
    FIELD _text-id           AS RECID    /* Record for code-text  */

    FIELD _footer            AS CHAR     LABEL "Footer" /* eg. ~n&ANALYSE-RESUME ~n */
    FIELD _header            AS CHAR     LABEL "Header" /* eg. ~n~n&ANALYSE-SUSPEND */
    FIELD _name              AS CHAR     LABEL "Name"
    FIELD _offset            AS INTEGER  LABEL "Code Offset"
    FIELD _offset-end        AS INTEGER  LABEL "End Code Offset"
    FIELD _section           AS CHAR     LABEL "Major Section"
    FIELD _special           AS CHAR     LABEL "Special Handler"
    FIELD _status            AS CHAR     INITIAL "NORMAL" LABEL "Status"
  INDEX _ID IS PRIMARY _p-recid _prev-id
  INDEX _OWNER  _l-recid 
  INDEX _OFFSET _offset
  .

DEFINE {1} SHARED TEMP-TABLE _CODE-TEXT
    FIELD _code-id           AS RECID  INITIAL ?  /* Linked code block          */
    FIELD _next-id           AS RECID  INITIAL ?  /* Extra record for long code */
    FIELD _text              AS CHAR     LABEL "Code Text"
  .
