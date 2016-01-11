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
DEFINE {&new} SHARED VAR c-pgm-filter      AS CHAR                   NO-UNDO.
DEFINE {&new} SHARED VAR c-filter          AS CHAR                   NO-UNDO.
DEFINE {&new} SHARED VAR c-pgm-break       AS CHAR                   NO-UNDO.
DEFINE {&new} SHARED VAR c-break           AS CHAR                   NO-UNDO.
DEFINE {&new} SHARED VAR c-break-on        AS CHAR                   NO-UNDO.
DEFINE {&new} SHARED VAR cx-event-list     AS CHAR EXTENT 4          NO-UNDO.

DEFINE {&new} SHARED VAR app_handle        AS HANDLE                 NO-UNDO.
DEFINE {&new} SHARED VAR ps_window         AS HANDLE                 NO-UNDO.

DEFINE {&new} SHARED VAR msgcnt            AS INT FORMAT "z9" INIT 1 NO-UNDO.

DEFINE {&new} SHARED TEMP-TABLE pgm-bf
    FIELD cFileName AS CHAR FORMAT "X(35)":U LABEL "Title"
    FIELD cType     AS LOG  FORMAT "Break/Filter"
    FIELD cMethod   AS CHAR FORMAT "X(35)":U LABEL "Break/Filter"
    INDEX cNameType IS PRIMARY cFileName cType 
    INDEX cType     cType
    .               

DEFINE {&new} SHARED TEMP-TABLE pp
    FIELD pHandle    AS WIDGET-HANDLE
    FIELD cFileName  AS CHAR FORMAT "X(35)":U LABEL "Title" 
    FIELD cMethod    AS CHAR FORMAT "X(35)":U LABEL "Methods"
    INDEX cFileName  IS PRIMARY cFileName  
    INDEX cMethod    cMethod
    .

DEFINE {&new} SHARED TEMP-TABLE def-bf
    FIELD cFileName  AS CHAR FORMAT "X(35)":U LABEL "Title" 
    FIELD cMethod    AS CHAR FORMAT "X(35)":U LABEL "Methods"
    INDEX cFileName  IS PRIMARY cFileName cMethod
    .

DEFINE {&new} SHARED TEMP-TABLE adm-methods-bf
    FIELD  slctmethod AS CHAR FORMAT "X(30)":U LABEL "Methods"
    INDEX  slctmethod IS PRIMARY slctmethod
    .
