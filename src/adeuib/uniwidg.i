/***********************************************************************
* Copyright (C) 2005-2015,2017 by Progress Software Corporation. All   *
* rights reserved.  Prior versions of this work may contain portions   *
* contributed by participants of Possenet.                             *
*                                                                      *
***********************************************************************/
/*----------------------------------------------------------------------------

File: uniwidg.i

Description:
    Universal widget temp-table definition.
    Note: most fields correspond to widget Attributes. 

Input Parameters:
   <None>

Output Parameters:
   <None>

Author: D. Ross Hunter,  Wm.T.Wood

Date Created: 1992 
Modified: 06/17/99 SLK Added _U._PRIVATE-DATA-ATTR, 
                             _F._INITIAL-DATA-ATTR,
                             _F._PRIVATE-DATA,
                             _F._PRIVATE-DATA-ATTR,
          06/16/99 TSM Added _NO-AUTO-VALIDATE
          06/11/99 TSM Changed _ALLOW-COL-SCROLLING to _COLUMN-SEARCHING
          06/10/99 TSM Added _AUTO-COMPLETION and _UNIQUE-MATCH
          06/08/99 TSM Added _ALLOW-COL-SCROLLING
          06/07/99 TSM Added _CONTEXT-HELP-ID
          06/03/99 TSM Added _CONTEXT-HELP and _CONTEXT-HELP-FILE
          06/02/99 TSM Added _STRETCH-TO-FIT, _RETAIN-SHAPE and _TRANSPARENT
          10/7/98  GFS Added _LIST-ITEM-PAIRS
          7/15/98  HD  Added _UF table for User Fields
          4/20/98  GFS Added _ROW-RESIZABLE for browse
          1/06/98  GFS Removed _REFRESHABLE
          1/97     SLK Added _vbx2ocx temp table
       11/13/2001  MAD Changed reference for ryobject.i to ttobject.i
       07/21/2017  RKUMAR Updated MaxFields to 511- Case 00408829  
----------------------------------------------------------------------------*/
/* _U - Universal Widget
          Contains the attributes that are commonly found in most widgets */

/* Max tables in query definition */
&Glob MaxTbl 20 
/* Max tables in query definition */
&Glob MaxFld 511
/* Max User defined lists */
&Glob MaxUserLists 6

&IF DEFINED(EXCLUDE_U) = 0 &THEN

DEFINE {1} SHARED TEMP-TABLE _U
   FIELD _ALIGN                   AS CHAR     INITIAL "L"  /* "L"eft "C"olon "R"ight */
   FIELD _HANDLE                  AS WIDGET   LABEL "Handle"
   FIELD _COM-HANDLE              AS COMPONENT-HANDLE LABEL "Com Handle"
   FIELD _NAME                    AS CHAR     LABEL "Name"            FORMAT "X(32)"
   FIELD _BUFFER                  AS CHAR     LABEL "Buffer"          INITIAL ?
   FIELD _CLASS-NAME              AS CHAR     LABEL "Class Name"      /* Dynamics Class */
   FIELD _CONTEXT-HELP-ID         AS INTEGER  LABEL "Context Help ID" INITIAL ?
   FIELD _DBNAME                  AS CHAR     LABEL "DB Name"         INITIAL ?
   FIELD _DEFINED-BY              AS CHAR     LABEL "DB,User,Tool"    INITIAL "Tool"
   FIELD _DELETED                 AS LOGICAL  LABEL "Deleted"         INITIAL FALSE
         /* _DELETED is turned on when a widget is deleted from dynamics repository */
   FIELD _DROP-TARGET             AS LOGICAL  LABEL "Drop Target"     INITIAL FALSE
   FIELD _DISPLAY                 AS LOGICAL  LABEL "DISPLAY"         INITIAL TRUE
   FIELD _ENABLE                  AS LOGICAL  LABEL "ENABLE"          INITIAL TRUE
   FIELD _HELP                    AS CHAR     LABEL "Help"            FORMAT "X(78)"
   FIELD _HELP-ATTR               AS CHAR     FORMAT "X(5)"           INITIAL ""
   					LABEL "HELP String Attributes" 
   FIELD _HELP-SOURCE             AS CHAR     LABEL "HELP Source"     INITIAL "E" 
   FIELD _HIDDEN                  AS LOGICAL  LABEL "HIDDEN"          INITIAL FALSE
   FIELD _LABEL                   AS CHAR     LABEL "Label"           INITIAL ?
                                        FORMAT "X(256)"
   FIELD _LABEL-ATTR              AS CHAR     FORMAT "X(5)" INITIAL ""
   					LABEL "Label String Attributes" 
   FIELD _LABEL-SOURCE            AS CHAR     LABEL "Label Source"    INITIAL "E" 
   FIELD _LAYOUT-UNIT             AS LOGICAL  LABEL "Layout Unit"     INITIAL TRUE
                                        FORMAT "Columns/Pixels"
   FIELD _LAYOUT-NAME             AS CHAR     INITIAL "Master Layout"
   FIELD _lo-recid                AS RECID
   FIELD _LOCAL-NAME              AS CHAR
   FIELD _MANUAL-HIGHLIGHT        AS LOGICAL  /* at runtime */
   FIELD _MENU-KEY                AS CHAR     LABEL "Menu Key"        INITIAL ?
   FIELD _MENU-MOUSE              AS CHAR     LABEL "Menu Mouse"      INITIAL ?
   FIELD _MOUSE-POINTER           AS CHAR     LABEL "Mouse Pointer"   FORMAT "X(40)"
                                                                INITIAL ?
   FIELD _MOVABLE                 AS LOGICAL  
   FIELD _NO-TAB-STOP             AS LOGICAL  LABEL "No-Tab-Stop"     INITIAL FALSE
   FIELD _OBJECT-OBJ              AS DECIMAL  LABEL "Object_obj"   
   FIELD _OBJECT-NAME             AS CHAR     LABEL "Object FileName"
   FIELD _OCX-NAME                AS CHAR     LABEL "OCX Name"        INITIAL ?
   FIELD _PARENT                  AS WIDGET   LABEL "Parent"
   FIELD _PARENT-RECID            AS RECID    LABEL "Parent RECID"
   FIELD _POPUP-RECID             AS RECID    LABEL "Popup Menu"
   FIELD _PRIVATE-DATA            AS CHAR     LABEL "Private Data"
   FIELD _PROC-HANDLE             AS HANDLE
   FIELD _RESIZABLE               AS LOGICAL  
   FIELD _SCROLLBAR-V             AS LOGICAL  LABEL "Vertical Scrollbar"
   FIELD _SELECTABLE              AS LOGICAL 
   FIELD _SELECTED                AS LOGICAL 
   FIELD _SELECTEDib              AS LOGICAL  LABEL "Selected in UIB" INITIAL ?
   FIELD _SENSITIVE               AS LOGICAL  
   FIELD _SHARED                  AS LOGICAL  LABEL "SHARED"          INITIAL FALSE
   FIELD _SHOW-POPUP              AS LOGICAL  LABEL "ShowPopup"       INITIAL TRUE
   FIELD _SIZE-TO-PARENT          AS LOGICAL
   FIELD _STATUS                  AS CHAR     LABEL "Status"          INITIAL "NORMAL"
   FIELD _SUBTYPE                 AS CHAR     LABEL "Subtype"         INITIAL ?
   FIELD _TABLE                   AS CHAR     LABEL "Table"           INITIAL ?
   FIELD _TAB-ORDER               AS INTEGER  LABEL "Tab Order"
   FIELD _TOOLTIP                 AS CHAR     LABEL "Tooltip"
   FIELD _TOOLTIP-ATTR            AS CHAR     FORMAT "X(5)" INITIAL ""
   					LABEL "Tooltip String Attributes" 
   FIELD _TYPE                    AS CHAR     LABEL "Type"            INITIAL ?
   FIELD _User-List               AS LOGICAL  EXTENT {&MaxUserLists}  INITIAL NO
                            /* Array of User defined lists.  */
   FIELD _VISIBLE                 AS LOGICAL 
   FIELD _WHERE-STORED            AS CHAR     
   FIELD _WIDGET-ID               AS INTEGER  LABEL "Widget ID"       INITIAL ?
   FIELD _WINDOW-HANDLE           AS WIDGET   LABEL "Window Handle"
   FIELD _WIN-TYPE                AS LOGICAL  LABEL "Window Type"     INITIAL ?
   FIELD _l-recid                 AS RECID    LABEL "RECID of Linked UW"
                                                         /* eg. FILLIN LABELS */
   FIELD _x-recid	                AS RECID    LABEL "RECID of eXtension _U, _F or _M"
   FIELD _PRIVATE-DATA-ATTR       AS CHAR     LABEL "Private Data String Attributes"
 INDEX _HANDLE     IS PRIMARY UNIQUE _HANDLE
 INDEX _NAME       _NAME _TYPE
 INDEX _OUTPUT     _WINDOW-HANDLE _TYPE _NAME
 INDEX _x-recid    _x-recid
 INDEX _SELECTEDib _SELECTEDib
 INDEX _STATUS     _STATUS
 .

&ENDIF

&IF DEFINED(EXCLUDE_C) = 0 &THEN

/* _C - Container Widget (extension of _U record)
              Contains attributes found in the container widgets
              (Windows, Browse Widgets, and Frames)                       */
DEFINE {1} SHARED TEMP-TABLE _C
   FIELD _ALWAYS-ON-TOP           AS LOGICAL  INITIAL FALSE
   FIELD _BACKGROUND              AS WIDGET   LABEL "Background"
   FIELD _BLOCK-ITERATION-DISPLAY AS LOGICAL  LABEL "BLOCK ITERATION DISPLAY"
                                        INITIAL TRUE VIEW-AS TOGGLE-BOX
   FIELD _BOX-SELECTABLE          AS LOGICAL  LABEL "BOX-SELECTABLE *" /* at runtime */
                                        VIEW-AS TOGGLE-BOX
   FIELD _cancel-btn-recid        AS RECID    /* Recid of Cancel Button */
   FIELD _COLUMN-MOVABLE          AS LOGICAL
   FIELD _COLUMN-RESIZABLE        AS LOGICAL
   FIELD _COLUMN-SCROLLING        AS LOGICAL  INITIAL TRUE
   FIELD _COLUMN-SEARCHING        AS LOGICAL  INITIAL FALSE
   FIELD _CONTEXT-HELP            AS LOGICAL  INITIAL FALSE 
   FIELD _CONTEXT-HELP-FILE       AS CHARACTER INITIAL ""
   FIELD _CONTROL-BOX             AS LOGICAL  INITIAL TRUE
   FIELD _CURRENT-ITERATION       AS WIDGET
   FIELD _CUSTOM-SUPER-PROC       AS CHARACTER
   FIELD _CUSTOM-SUPER-PROC-PATH  AS CHAR     LABEL "Relative Path" INITIAL ?
   FIELD _CUSTOM-SUPER-PROC-PMOD  AS CHAR     LABEL "Product Module" INITIAL ?
   FIELD _CUSTOM-SUPER-PROC-TYPE  AS CHARACTER INITIAL "Procedure":U
   FIELD _DATA-LOGIC-PROC         AS CHARACTER
   FIELD _DATA-LOGIC-PROC-BUFF-SUFFIX AS CHARACTER
   FIELD _DATA-LOGIC-PROC-INCLUDE AS CHARACTER
   FIELD _DATA-LOGIC-PROC-PATH    AS CHAR     LABEL "Relative Path" INITIAL ?
   FIELD _DATA-LOGIC-PROC-PMOD    AS CHAR     LABEL "Product Module" INITIAL ?
   FIELD _DATA-LOGIC-PROC-NEW     AS LOG      INITIAL  ?
   FIELD _DATA-LOGIC-PROC-TABLE-BUFF AS CHARACTER
   FIELD _DATA-LOGIC-PROC-TYPE    AS CHAR     INITIAL "DLProc":U
   FIELD _DATA-LOGIC-PROC-TEMPLATE AS CHARACTER
   FIELD _DATAFIELD-MAPPING       AS CHARACTER
   FIELD _default-btn-recid       AS RECID    /* Recid of Default Button */
   FIELD _DOWN                    AS LOGICAL  LABEL "DOWN"
   FIELD _EXPANDABLE              AS LOGICAL  LABEL "Expandable"
   FIELD _EXPLICIT_POSITION       AS LOGICAL 
   FIELD _FIT-LAST-COLUMN         AS LOGICAL  LABEL "Fit Last Column"
   FIELD _FOLDER-WINDOW-TO-LAUNCH AS CHAR LABEL "Folder Window to Launch"
   FIELD _FRAME-BAR               AS WIDGET   
   FIELD _HIDE                    AS LOGICAL  INITIAL TRUE
   FIELD _ICON                    AS CHAR     INITIAL ""   FORMAT "X(40)"
   FIELD _SMALL-ICON              AS CHAR     INITIAL ""   FORMAT "X(40)"
   FIELD _ITERATION-POS           AS INTEGER  LABEL "1st Iteration Height"
   FIELD _KEEP-TAB-ORDER          AS LOGICAL  INITIAL TRUE
   FIELD _KEEP-FRAME-Z-ORDER      AS LOGICAL  INITIAL TRUE
   FIELD _NUM-LOCKED-COLUMNS      AS INTEGER  
   FIELD _MAX-BUTTON              AS LOGICAL  INITIAL TRUE
   FIELD _MAX-DATA-GUESS          AS INTEGER  INITIAL 100
   FIELD _menu-recid              AS RECID    LABEL "Menubar"
   FIELD _MESSAGE-AREA            AS LOGICAL  LABEL "MESSAGE-AREA"
   FIELD _MESSAGE-AREA-FONT       AS INTEGER  INITIAL ?
   FIELD _MIN-BUTTON              AS LOGICAL  INITIAL TRUE
   FIELD _MIN-HEIGHT              AS DECIMAL  
   FIELD _MIN-WIDTH               AS DECIMAL  
   FIELD _MULTIPLE                AS LOGICAL  INITIAL FALSE
   FIELD _NO-ASSIGN               AS LOGICAL
   FIELD _NO-AUTO-VALIDATE        AS LOGICAL
   FIELD _NO-EMPTY-SPACE          AS LOGICAL
   FIELD _NO-HELP                 AS LOGICAL
   FIELD _NO-ROW-MARKERS          AS LOGICAL  INITIAL TRUE
   FIELD _OVERLAY                 AS LOGICAL  INITIAL TRUE
   FIELD _PAGE-BOTTOM             AS LOGICAL  LABEL "PAGE-BOTTOM"
   FIELD _PAGE-TOP                AS LOGICAL  LABEL "PAGE-TOP"
   FIELD _q-recid                 AS RECID
   FIELD _RETAIN                  AS INTEGER  LABEL "Retain"           INITIAL ?
   FIELD _ROW-HEIGHT              AS DECIMAL
   FIELD _ROW-RESIZABLE           AS LOGICAL
   FIELD _ROWOBJECT-NO-UNDO       AS LOGICAL  INITIAL FALSE
   FIELD _SCREEN-LINES            AS INTEGER  
   FIELD _SCROLLABLE              AS LOGICAL  LABEL "SCROLLABLE"
   FIELD _SCROLL-BARS             AS LOGICAL  LABEL "Scroll-bars"  
   FIELD _SHOW-IN-TASKBAR         AS LOGICAL  INITIAL TRUE
   FIELD _SIDE-LABELS             AS LOGICAL  LABEL "SIDE-LABELS"      INITIAL TRUE
   FIELD _size-to-fit             AS LOGICAL  LABEL "Size to fit"
   FIELD _SMALL-TITLE             AS LOGICAL  LABEL "Small Title"      INITIAL FALSE    
   FIELD _STATUS-AREA             AS LOGICAL  LABEL "Status Area"      INITIAL TRUE
   FIELD _STATUS-AREA-FONT        AS INTEGER  INITIAL ?
   FIELD _SUPPRESS-WINDOW         AS LOGICAL  LABEL "Suppress Window"  INITIAL FALSE
   FIELD _tabbing                 AS CHAR     LABEL "Tabbing Mode"     INITIAL "Default"
   FIELD _TITLE                   AS LOGICAL  INITIAL TRUE
   FIELD _TOP-ONLY                AS LOGICAL  LABEL "TOP-ONLY"
   FIELD _USE-DICT-EXPS           AS LOGICAL
   FIELD _VALIDATE                AS LOGICAL  LABEL "VALIDATE"         INITIAL TRUE
   FIELD _WINDOW-STATE            AS CHAR     LABEL "Window State"     INITIAL ?
   FIELD _WINDOW-TITLE-FIELD      AS CHAR    LABEL "Window Title Field"
   .

&ENDIF

&IF DEFINED(EXCLUDE_F) = 0 &THEN

/* _F - Field Widget (extension of _U record)
           Contains attributes found in the field level widgets              */
DEFINE {1} SHARED TEMP-TABLE _F
   FIELD _AUTO-COMPLETION         AS LOGICAL  LABEL "Auto Completion"
   FIELD _AUTO-ENDKEY             AS LOGICAL  LABEL "AUTO-ENDKEY"
   FIELD _AUTO-GO                 AS LOGICAL  LABEL "AUTO-GO"
   FIELD _AUTO-INDENT             AS LOGICAL  LABEL "AUTO-INDENT"
   FIELD _AUTO-RESIZE             AS LOGICAL  LABEL "AUTO-RESIZE"
   FIELD _AUTO-RETURN             AS LOGICAL  LABEL "AUTO-RETURN"
   FIELD _BLANK                   AS LOGICAL  LABEL "BLANK"
   /* Datatype is important.  All variables have a datatype. All non-variables
      have _DATA-TYPE = ?.  This lets us see if we have two widgets that 
      refer to the same variable */
   FIELD _DATA-TYPE               AS CHAR     LABEL "Data Type"       INITIAL ?  
   FIELD _DEBLANK                 AS LOGICAL  LABEL "DEBLANK"
   FIELD _DEFAULT                 AS LOGICAL  LABEL "DEFAULT"         INITIAL FALSE
   FIELD _DELIMITER               AS CHAR                             INITIAL ","
                            /* For Radio-sets, Selection-Lists and Combos  */
   FIELD _DICT-VIEW-AS            AS LOGICAL
   FIELD _DISABLE-AUTO-ZAP        AS LOGICAL  LABEL "Disable-Auto-Zap" INITIAL FALSE
   FIELD _DISPOSITION             AS CHAR     /* Can be "", "FIELD", "LOCAL" or "LIKE" */
   FIELD _DRAG-ENABLED            AS LOGICAL  LABEL "DRAG ENABLED"
   FIELD _EXPAND                  AS LOGICAL  LABEL "EXPAND"          INITIAL FALSE
   FIELD _FLAT                    AS LOGICAL  LABEL "Flat"            INITIAL FALSE
   FIELD _FORMAT                  AS CHAR     LABEL "Format"          INITIAL ?
                                        FORMAT "X(40)"
   FIELD _FORMAT-ATTR             AS CHAR     FORMAT "X(5)" INITIAL "U"
   					LABEL "FORMAT String Attributes" 
   FIELD _FORMAT-SOURCE           AS CHAR     LABEL "FORMAT Source"   INITIAL "E" 
   FIELD _FRAME                   AS WIDGET   LABEL "Frame"
   FIELD _FREQUENCY               AS INTEGER  LABEL "Freq"            INITIAL 0
   FIELD _HORIZONTAL              AS LOGICAL  LABEL "HORIZONTAL"
   FIELD _IMAGE-DOWN-FILE         AS CHAR     LABEL "Image (Down)"    INITIAL ""
   FIELD _IMAGE-FILE              AS CHAR     LABEL "Image File"      INITIAL ""
   FIELD _IMAGE-INSENSITIVE-FILE
                                  AS CHAR     LABEL "Image (Insensitive)" INITIAL ""
   FIELD _INITIAL-DATA            AS CHAR     LABEL "Initial Data"
   FIELD _INNER-CHARS             AS INTEGER  LABEL "Inner Characters"
   FIELD _INNER-LINES             AS INTEGER  LABEL "Inner Lines"
   FIELD _LARGE                   AS LOGICAL  LABEL "LARGE"           INITIAL FALSE
   FIELD _LARGE-TO-SMALL          AS LOGICAL  LABEL "Large to small"  INITIAL FALSE
   FIELD _LIKE-FIELD              AS CHAR     LABEL "Like Field"
   FIELD _LIST-ITEM-PAIRS         AS CHAR     LABEL "List Item Pairs"
   FIELD _LIST-ITEMS              AS CHAR     LABEL "List Items"
   FIELD _MAX-CHARS               AS INTEGER  LABEL "Max Chars"       INITIAL ?
   FIELD _MAX-VALUE               AS INTEGER  LABEL "Max Value"       INITIAL 100
   FIELD _MIN-VALUE               AS INTEGER  LABEL "Min Value"       INITIAL 0
   FIELD _MULTIPLE                AS LOGICAL  LABEL "MULTIPLE"
   FIELD _NATIVE                  AS LOGICAL  LABEL "NATIVE"          INITIAL FALSE
   FIELD _NO-CURRENT-VALUE        AS LOGICAL  LABEL "No current value" INIT   FALSE
   FIELD _NUM-ITEMS               AS INTEGER  LABEL "Number of Items" INITIAL ?
   FIELD _PASSWORD-FIELD          AS LOGICAL  LABEL "PASSWORD-FIELD"
   FIELD _READ-ONLY               AS LOGICAL  LABEL "READ-ONLY"
   FIELD _RETAIN-SHAPE            AS LOGICAL  LABEL "Retain Shape"    INITIAL FALSE
   FIELD _RETURN-INSERTED         AS LOGICAL  LABEL "RETURN-INSERTED"
   FIELD _SCREEN-VALUE            AS CHAR     LABEL "Screen Value"    INITIAL ""
   FIELD _SCREEN-VALUE-ATTR       AS CHAR     FORMAT "X(5)" INITIAL ""
   					LABEL "Screen VALUE String Attributes" 
   FIELD _SCROLLBAR-H             AS LOGICAL  LABEL "Horizontal Scrollbar"
   FIELD _SIZE-SOURCE             AS CHAR     LABEL "SIZE Source"     INITIAL "E" 
   FIELD _SORT                    AS LOGICAL  LABEL "SORT"
   FIELD _SOURCE-DATA-TYPE        AS CHAR     LABEL "Source Data Type" INITIAL ?
   FIELD _SPECIAL-DATA            AS CHAR     LABEL "Special Data"    INITIAL ?
   FIELD _STACK-LBL-HDL           AS WIDGET   LABEL "Stacked Labels"  EXTENT {&MaxTbl}
   FIELD _STRETCH-TO-FIT          AS LOGICAL  LABEL "Stretch to Fit"  INITIAL FALSE
   FIELD _SUBSCRIPT               AS INTEGER  LABEL "Subscript"       INITIAL ?
   FIELD _TIC-MARKS               AS CHAR     LABEL "Tic Marks"       INITIAL "NONE"
   FIELD _TRANSPARENT             AS LOGICAL  LABEL "Transparent"     INITIAL FALSE
   FIELD _UNDO                    AS LOGICAL  LABEL "UNDO"            INITIAL FALSE
   FIELD _UNIQUE-MATCH            AS LOGICAL  LABEL "Unique Match"  
   FIELD _WORD-WRAP               AS LOGICAL  LABEL "Word Wrap"
   FIELD _VBX-BINARY              AS CHAR     LABEL "Temporary OCX Binary" INITIAL ?
   FIELD _INITIAL-DATA-ATTR       AS CHAR     FORMAT "x(5)" INITIAL ""
                                        LABEL "Initial Data String Attribute"
   FIELD _PRIVATE-DATA            AS CHAR     LABEL "Private Data"
   FIELD _PRIVATE-DATA-ATTR       AS CHAR     FORMAT "x(5)" INITIAL "U"
                                        LABEL "Private Data String Attribute"
   .

&ENDIF

&IF DEFINED(EXCLUDE_M) = 0 &THEN

/* _M - Menu Widget (extension of _U record)
              Contains attributes found in the menu widgets
              (Windows, Browse Widgets , and Frames)                       */
DEFINE {1} SHARED TEMP-TABLE _M
   FIELD _parent-recid	          AS RECID    LABEL "RECID of parent menu"  INITIAL ?
   FIELD _child-recid	            AS RECID    LABEL "RECID of 1st child"    INITIAL ?
   FIELD _sibling-recid           AS RECID	LABEL "RECID of next sibling" INITIAL ?
   FIELD _ACCELERATOR             AS CHAR     LABEL "Accelerator"  FORMAT "X(40)" 
   FIELD _SUB-MENU-HELP           AS LOGICAL  LABEL "SUB-MENU-HELP"  
   .


&ENDIF

&IF DEFINED(EXCLUDE_P) = 0 &THEN

/* jep-icf: This preprocessor instructs adeuib/ryobject.i to define its fields only. */
/*          Doing this allows adeuib/ryobject.i to be used again to define _RyObject */
/*          temp-table and share its field definitions with _P.                      */
&SCOPED-DEFINE RYOBJECT-FIELDS-ONLY  YES
   
/* _P - Procedure Record 
           Contains fields related to a the .w (procedure) file              */ 
DEFINE {1} SHARED TEMP-TABLE _P
   FIELD _add-fields              AS CHAR     LABEL "Add Fields to"
                             INITIAL "FRAME-QUERY"
   FIELD _allow                   AS CHAR     LABEL "Allow Adding"
                             INITIAL "Basic,Browse,DB-Fields"
   FIELD _adm-version             AS CHARACTER LABEL "ADM version"
   FIELD _app-srv-aware           AS LOGICAL  LABEL "AppServer Aware"
   FIELD _broker-url              AS CHAR     LABEL "Broker URL"
   FIELD _compile                 AS LOGICAL  LABEL "Compile on Save" 
   FIELD _compile-into            AS CHAR     LABEL "Compile into"     INITIAL ?
   FIELD _comp_temp_file     AS CHAR     LABEL "Compile unique temporary file"     INITIAL ?
   FIELD _data-object             AS CHAR     LABEL "Associated Data Object" FORMAT "X(80)"
   FIELD _db-aware                AS LOGICAL  LABEL "DB Aware"
   FIELD _desc                    AS CHAR     LABEL "Description"
   FIELD _editing                 AS CHAR     LABEL "Editing Features"
   FIELD _events                  AS CHAR     LABEL "Special Events"
   FIELD _file-saved              AS LOGICAL  LABEL "File Saved"       INITIAL TRUE
   FIELD _file-type               AS CHAR     LABEL "File Type"        INITIAL "w":U
   FIELD _file-version            AS CHAR     LABEL "File Version"
   FIELD _frame-name-recid        AS RECID    LABEL "FRAME-NAME recid"
   FIELD _hSecEd                  AS HANDLE   LABEL "Section Editor Handle"
   FIELD _html-file               AS CHAR     LABEL "HTML File"
   FIELD _links                   AS CHAR     LABEL "Supported Links"
   FIELD _lists                   AS CHAR     LABEL "Lists"         
                             INITIAL "List-1,List-2,List-3,List-4,List-5,List-6"
   FIELD _max-frame-count         AS INTEGER  LABEL "Max. Frames" INITIAL ? /* infinite */
   FIELD _no-proxy                AS LOGICAL  LABEL "No Proxy is created" INITIAL FALSE
   FIELD _page-current            AS INTEGER  LABEL "Current Page"
   FIELD _page-select             AS INTEGER  LABEL "First (runtime) Page"
   FIELD _partition               AS CHAR     LABEL "Partition"
   FIELD _persistent-only         AS LOGICAL  LABEL "Persistent Only"  INITIAL FALSE
   FIELD _reserved-names          AS CHAR     /* Reserved Variable Names */
   FIELD _reserved-procs          AS CHAR     /* Reserved Procedure Names */
   FIELD _run-persistent          AS LOGICAL  LABEL "Run Persistent"
   FIELD _save-as-file            AS CHAR     LABEL "Save As File"     INITIAL ?
   FIELD _save-as-path            AS CHAR     LABEL "Relative Path"    INITIAL ?
   FIELD _template                AS LOGICAL  LABEL "Template"         INITIAL FALSE
   FIELD _u-recid                 AS RECID    LABEL "RECID of Linked _U"
   FIELD _tv-proc                 AS HANDLE   LABEL "Treeview Procedure Handle"
   FIELD _TYPE                    AS CHAR     LABEL ".w type"
   FIELD _WINDOW-HANDLE           AS WIDGET   LABEL "Window Handle"
   FIELD _vbx-file                AS CHAR     LABEL "Serialized OCX file" INITIAL ?
   FIELD _xTblList                AS CHAR     LABEL "External Tables"
   FIELD _widgetid-file-name      AS CHAR     LABEL "Widget-id File name" INITIAL ?

  /* jep-icf: Fields used for ICF repository object data. See adeuib/ryobject.i for details. */
  {adeuib/ttobject.i}

 INDEX _u-recid        _u-recid   
 INDEX _WINDOW-HANDLE  _WINDOW-HANDLE
 .
 
&UNDEFINE RYOBJECT-FIELDS-ONLY

&ENDIF

&IF DEFINED(EXCLUDE_Q) = 0 &THEN

/* _Q - Query Record 
           Contains fields related to a Query                               */ 
DEFINE {1} SHARED TEMP-TABLE _Q
   FIELD _OpenQury                AS LOGICAL  LABEL "Open Query Automatically"
                                        INITIAL YES
   					VIEW-AS TOGGLE-BOX   					 
   FIELD _4GLQury                 AS CHAR     /* 4GL code defining query           */
   FIELD _TblList                 AS CHAR     /* List of tables in query           */
   FIELD _FldList                 AS CHAR     /* List of fields selected for browse*/
   FIELD _FldNameList             AS CHAR     EXTENT {&MaxFld}         INITIAL ?
                                  /* List of fields names selected for browse*/
   FIELD _FldEnableList           AS CHAR     EXTENT {&MaxFld}         INITIAL ?
                                  /* List of fields enabled for editting     */
   FIELD _FldLabelList            AS CHAR     EXTENT {&MaxFld}         INITIAL ?
                                  /* List of fields labels selected for browse*/
   FIELD _FldFormatList	          AS CHAR     EXTENT {&MaxFld}         INITIAL ?
                                 /* List of fields formats selected for browse*/
   FIELD _OrdList                 AS CHAR     /* List of fields in BREAK BY phrase */
   FIELD _OptionList              AS CHAR     /* Query/Browse Options eg. INDEX-REP */
   FIELD _JoinCode                AS CHAR     EXTENT {&MaxTbl}         INITIAL ?
                                        /* 4GL Join Code                     */
   FIELD _TblOptList              AS CHAR     /* List of Options, by table (eg. "FIRST") */
   FIELD _Where                   AS CHAR     EXTENT {&MaxTbl}         INITIAL ?
                                        /* 4GL Where Code  */
   FIELD _TuneOptions             AS CHAR     /* Query Tuning parameters           */
   .

&ENDIF

&IF DEFINED(EXCLUDE_S) = 0 &THEN

/* _S - SmartObject Widget (extension of _U record)
              Contains attributes found in the SmartObjects.              */
DEFINE {1} SHARED TEMP-TABLE _S
   FIELD _affordance-handle       AS WIDGET   LABEL "Affordance Handle"
   FIELD _external-tables         AS CHAR     LABEL "External Tables"
   FIELD _FILE-NAME               AS CHAR     LABEL "File Name"
   FIELD _HANDLE                  AS HANDLE   LABEL "Procedure Handle"
   FIELD _internal-tables         AS CHAR     LABEL "Internal Tables"
   FIELD _links                   AS CHAR     LABEL "Supported Links"
   FIELD _page-number             AS INTEGER  LABEL "Page Number" INITIAL 0 /* i.e. base page */
   FIELD _settings                AS CHAR     LABEL "Settings"
   FIELD _valid-object            AS LOGICAL  LABEL "Object is Valid"
   FIELD _var-name                AS CHAR     LABEL "Substitution Variable"
   FIELD _visual                  AS LOGICAL  LABEL "Object contains Visual UI"
   .

&ENDIF

&IF DEFINED(EXCLUDE_TT) = 0 &THEN

/* _TT - Temp-Table info (children of _P record)
              Contains attributes of temp-tables for each procedure.      */
DEFINE {1} SHARED TEMP-TABLE _TT
   FIELD _p-recid                 AS RECID
   FIELD _NAME                    AS CHARACTER INITIAL ?
   FIELD _TABLE-TYPE              AS CHARACTER INITIAL "T":U /* OR B */
   FIELD _SHARE-TYPE              AS CHARACTER
   FIELD _UNDO-TYPE               AS CHARACTER INITIAL "NO-UNDO":U /* OR "" */
   FIELD _LIKE-DB                 AS CHARACTER
   FIELD _LIKE-TABLE              AS CHARACTER
   FIELD _ADDITIONAL_FIELDS       AS CHARACTER
   FIELD _START-BYTE              AS INTEGER   /* For syntax checking messages */
 INDEX _p-recid IS PRIMARY UNIQUE _p-recid _name
 INDEX _LIKE-TABLE _LIKE-TABLE
 INDEX _p-start-byte _p-recid _START-BYTE.

&ENDIF

&IF DEFINED(EXCLUDE_UF) = 0 &THEN

/* _UF - User Fields info (children of _P record)
         Contains free form definitions for each procedure.      */
DEFINE {1} SHARED TEMP-TABLE _UF
   FIELD _p-recid                 AS RECID
   FIELD _DEFINITIONS             AS CHARACTER 
 INDEX _p-recid IS PRIMARY UNIQUE _p-recid.

&ENDIF

&IF DEFINED(EXCLUDE_vbx2ocx) = 0 &THEN

/* _vbx2ocx - Temp-Table info (vb.ini file records */
DEFINE {1} SHARED TEMP-TABLE _vbx2ocx  NO-UNDO
   FIELD _vbxFile                 AS CHAR     LABEL "Vbx File"    FORMAT "X(256)"
   FIELD _classId                 AS CHAR     LABEL "Class Id"
   FIELD _ocxFile                 AS CHAR     LABEL "Ocx File"    FORMAT "X(256)"
   FIELD _ocxPath                 AS CHAR     LABEL "Path to Ocx File"    FORMAT "X(256)"
   FIELD _shortName               AS CHAR     LABEL "Short Name"
 INDEX _vbxFile IS PRIMARY _vbxFile.

&ENDIF

&IF DEFINED(EXCLUDE_PDP) = 0 &THEN


/* _PDP - Temp-Table to track Persistent Design Procedures                */
/*        When the AB starts a persistent procedure to be used for design */
/*        purposes, a record is made in this table.  When the the AB      */
/*        shutsdown, the AB should shutdown all of the procedures for     */
/*        which there are records.  Before starting a persistent proc,    */
/*        the AB should check this table so       AS to reuse the procedure and */
/*        not start another instance.                                     */
DEFINE {1} SHARED TEMP-TABLE _PDP NO-UNDO
   FIELD _procFileName            AS CHARACTER
   FIELD _hInstance               AS HANDLE
 INDEX _procFileName IS PRIMARY _procFileName.

&ENDIF

&IF DEFINED(EXCLUDE_RyObject) = 0 &THEN

/* jep-icf: _RyObject - Temp-Table to track repository object information. */
/* Definition is:                                                          */
/* DEFINE {1} SHARED TEMP-TABLE _RyObject NO-UNDO, etc..                   */

{adeuib/ttobject.i {1} }

&ENDIF
