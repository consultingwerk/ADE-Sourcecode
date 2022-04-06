/***********************************************************************
* Copyright (C) 2005-2006 by Progress Software Corporation. All rights *
* reserved.  Prior versions of this work may contain portions          *
* contributed by participants of Possenet.                             *
*                                                                      *
***********************************************************************/
/*----------------------------------------------------------------------------

File: brwscols.i

Description: This include file defines the browse column TEMP-TABLE.  

Input Parameters:
   <None>

Output Parameters:
   <None>

Author: D. Ross Hunter

Date Created: 2/14/1995
Modified: SLK 12/97 Added PDO fields
          GFS 01/98 Added _AUTO-RETURN & _USE-AUTOZAP
          GFS 02/98 Changed _USE-AUTOZAP to _DISABLE-AUTOZAP
          GFS 02/98 Changed _DISABLE-AUTOZAP to _DISABLE-AUTO-ZAP          
          SLK 06/98 Added _USER-LIST
          SLK 06/98 Added _DESCRIPTION, VALIDATION
          TSM 05/99 Added _VISIBLE
          TSM 06/99 Added _COLUMN-READ-ONLY and _AUTO-RESIZE
          SLK 06/99 Added _HELP-ATTR, _LABEL-ATTR, _FORMAT-ATTR
          SLK 06/99 Added _PRIVATE-DATA, _PRIVATE-DATA-ATTR
                          _INITIAL-DATA, _INITIAL-DATA-ATTR
----------------------------------------------------------------------------*/
/* Max User defined lists */
&Glob MaxUserLists 6

DEFINE {1} SHARED TEMP-TABLE _BC
   FIELD _x-recid        AS RECID                    /* RECID of _U of browse    */
   FIELD _NAME           AS CHARACTER                /* Like _U._NAME            */
   FIELD _BGCOLOR        AS INTEGER   INITIAL ?      /* Like _L._BGCOLOR         */
   FIELD _COL-LABEL      AS CHARACTER CASE-SENSITIVE /* SDO column label         */
   FIELD _DATA-TYPE      AS CHARACTER INITIAL ?      /* ? if calc field          */
   FIELD _DBNAME         AS CHARACTER                /* Like _U._DBNAME          */
   FIELD _DEF-COLLABEL   AS CHARACTER CASE-SENSITIVE /* SDO default column label */
   FIELD _DEF-FORMAT     AS CHARACTER CASE-SENSITIVE /* Like _U._FORMAT          */
   FIELD _DEF-HELP       AS CHARACTER CASE-SENSITIVE /* Like _U._HELP            */
   FIELD _DEF-LABEL      AS CHARACTER CASE-SENSITIVE /* Like _U._LABEL           */
   FIELD _DEF-WIDTH      AS DECIMAL                  /* from _chkfmt.p           */
   FIELD _DISABLE-AUTO-ZAP AS LOGICAL INITIAL NO
   FIELD _DISP-NAME      AS CHARACTER                /* Display name in browse   */
                                                     /* format db.table.field    */
                                                     /* or calc expression       */
   FIELD _COL-HANDLE     AS HANDLE                   /* Browse Column handle     */
   FIELD _ENABLED        AS LOGICAL                  /* True if field is enabled */
   FIELD _FGCOLOR        AS INTEGER   INITIAL ?      /* Like _L._FGCOLOR         */
   FIELD _FONT           AS INTEGER   INITIAL ?      /* Like _L._FONT            */
   FIELD _FORMAT         AS CHARACTER CASE-SENSITIVE /* Like _U._FORMAT          */
   FIELD _FORMAT-ATTR    AS CHARACTER FORMAT "X(5)" INITIAL "U"
   		LABEL "FORMAT String Attributes"     /* Like _U._FORMAT-ATTR */
   FIELD _HAS-DATAFIELD-MASTER  AS LOGICAL           /* Has datafield master defined */
   FIELD _HELP           AS CHARACTER CASE-SENSITIVE /* Like _U._HELP            */
   FIELD _HELP-ATTR      AS CHARACTER FORMAT "X(5)" INITIAL ""
   		LABEL "HELP String Attributes"       /* Like _U._HELP-ATTR */
   FIELD _INSTANCE-LEVEL AS LOGICAL                  /* Store DataField Instance */
   FIELD _STATUS         AS CHARACTER                /* Status of calc field column (STATIC or NEWCALC with new calc field data) */
   FIELD _LABEL          AS CHARACTER CASE-SENSITIVE /* Like  _U._LABEL          */
   FIELD _LABEL-ATTR     AS CHARACTER   FORMAT "X(5)" INITIAL ""
   		LABEL "Label String Attributes"       /* Like _F._LABEL-ATTR */
   FIELD _LABEL-BGCOLOR  AS INTEGER   INITIAL ?      /* Like _L._LABEL-BGCOLOR   */
   FIELD _LABEL-FGCOLOR  AS INTEGER   INITIAL ?      /* Like _L._LABEL-FGCOLOR   */
   FIELD _LABEL-FONT     AS INTEGER   INITIAL ?      /* Like _L._LABEL-FONT      */
   FIELD _SEQUENCE       AS INTEGER                  /* Position in browse       */
   FIELD _TABLE          AS CHARACTER                /* Like _U._TABLE           */
   FIELD _MANDATORY      AS LOGICAL                  /* True if mandatory        */
   FIELD _WIDTH          AS DECIMAL                  /* field width              */
   FIELD _INHERIT-VALIDATION AS LOGICAL              /* Inherit Dict Validation  */
   FIELD _DEF-DESC       AS CHARACTER                /* Field Description */
   FIELD _DEF-VALEXP     AS CHARACTER CASE-SENSITIVE /* Field DataDic Validation          */
   FIELD _AUTO-RETURN    AS LOGICAL   INITIAL NO   
   /* MaxUserLists defined in uniwidg.i */
   FIELD _User-List      AS LOGICAL  EXTENT {&MaxUserLists}  INITIAL NO
                                                     /* Array of User defined lists.  */
   FIELD _VISIBLE        AS LOGICAL   INITIAL YES    /* True if field is visible */
   FIELD _AUTO-RESIZE    AS LOGICAL   INITIAL NO     
   FIELD _COLUMN-READ-ONLY AS LOGICAL INITIAL NO 
   FIELD _DEF-FORMAT-ATTR  AS CHARACTER FORMAT "x(5)" 
                           LABEL "Default Format String Attribute"
   FIELD _DEF-HELP-ATTR    AS CHARACTER FORMAT "x(5)"
                           LABEL "Default Help String Attribute"
   FIELD _DEF-LABEL-ATTR   AS CHARACTER FORMAT "x(5)"
                           LABEL "Default Label String Attribute"
   /*Fields for the view-as support introduced in 10.1B*/
   FIELD _VIEW-AS-TYPE AS CHARACTER FORMAT "X(15)"     /*View-as type: ?=Fill-in; FI=Fill-in; DD=Drop-down-; DDL=drop-down-list; TB=Toggle-box*/
   FIELD _VIEW-AS-DELIMITER AS CHARACTER FORMAT "X(1)" /*View-as delimiter (Combo-box only)*/
   FIELD _VIEW-AS-ITEM-PAIRS AS CHARACTER              /*View-as list-item-pairs (Combo-box only)*/
   FIELD _VIEW-AS-ITEMS AS CHARACTER                   /*View-as list-items (Combo-box only)*/
   FIELD _VIEW-AS-INNER-LINES AS INTEGER               /*View-as inner-lines (Combo-box only)*/
   FIELD _VIEW-AS-SORT AS LOGICAL                      /*View-as sort (Combo-box only)*/
   FIELD _VIEW-AS-MAX-CHARS AS INTEGER                 /*View-as Max-chars (Combo-box only)*/
   FIELD _VIEW-AS-AUTO-COMPLETION AS LOGICAL           /*View-as auto-completion (Combo-box only)*/
   FIELD _VIEW-AS-UNIQUE-MATCH AS LOGICAL              /*View-as unique-match (Combo-box only)*/
  INDEX _x-recid-seq  IS PRIMARY UNIQUE _x-recid _SEQUENCE
  INDEX _x-recid-col  _x-recid _COL-HANDLE.
