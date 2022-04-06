/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
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
