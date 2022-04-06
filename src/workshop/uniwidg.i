/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*----------------------------------------------------------------------------

File: uniwidg.i

Description:
    Universal Progress widget temp-table definition.

    This is based on the UIB's internal temp-table (although it is much simpler).

Input Parameters:
   <None>

Output Parameters:
   <None>

Author: D. Ross Hunter,  Wm.T.Wood

Date Created: 1996



----------------------------------------------------------------------------*/


/* _U - Universal Widget
          Contains the attributes that are commonly found in most widgets */

/* Max tables in query definition */
&Glob MaxTbl 20 
/* Max tables in query definition */
&Glob MaxFld 50 
/* Max User defined lists */
&Glob MaxUserLists 6

DEFINE {1} SHARED TEMP-TABLE _U
   FIELD _NAME              AS CHAR     LABEL "Name"            FORMAT "X(32)"

   FIELD _ASSIGN            AS LOGICAL  LABEL "ASSIGN"          INITIAL TRUE
   FIELD _BUFFER            AS CHAR     LABEL "Buffer"          INITIAL ?
   FIELD _DBNAME            AS CHAR     LABEL "DB Name"         INITIAL ?
   FIELD _DEFINED-BY        AS CHAR     LABEL "DB,User,Tool"    INITIAL "Tool"
   FIELD _DISPLAY           AS LOGICAL  LABEL "DISPLAY"         INITIAL TRUE
   FIELD _ENABLE            AS LOGICAL  LABEL "ENABLE"          INITIAL TRUE
   FIELD _HELP              AS CHAR     LABEL "Help"            FORMAT "X(78)"
   FIELD _PRIVATE-DATA      AS CHAR     LABEL "Private-Data"    FORMAT "X(78)"
   FIELD _SELECTEDib        AS LOGICAL  LABEL "Selected in UIB" INITIAL ?
   FIELD _STATUS            AS CHAR     LABEL "Status"          INITIAL "NORMAL"
   FIELD _TABLE             AS CHAR     LABEL "Table"           INITIAL ?
   FIELD _TYPE              AS CHAR     LABEL "Type"            INITIAL ?
   FIELD _User-List         AS LOGICAL  EXTENT {&MaxUserLists}  INITIAL NO
                            
   FIELD _P-recid           AS RECID    LABEL "ID of procedure" INITIAL ?  
   FIELD _parent-recid      AS RECID    LABEL "ID of container" INITIAL ?  
   FIELD _x-recid           AS RECID    LABEL "extension id"    INITIAL ?
   
 INDEX _OUTPUT     IS PRIMARY _P-recid _TYPE _NAME
 INDEX _NAME       _NAME _TYPE
 INDEX _x-recid    _x-recid
 INDEX _SELECTEDib _SELECTEDib
 INDEX _STATUS     _STATUS
 .

/* _F - Field Widget (extension of _U record)
           Contains attributes found in the field level widgets              */
DEFINE {1} SHARED TEMP-TABLE _F
   /* Datatype is important.  All variables have a datatype. All non-variables
      have _DATA-TYPE = ?.  This lets us see if we have two widgets that 
      refer to the same variable */
   FIELD _COL               AS DECIMAL  LABEL "Column"
   FIELD _DATA-TYPE         AS CHAR     LABEL "Data Type"       INITIAL ?
   FIELD _FORMAT            AS CHAR     LABEL "Format"          INITIAL ?
                                        FORMAT "X(40)"
   FIELD _FORMAT-ATTR       AS CHAR     FORMAT "X(5)" INITIAL "U"
   					LABEL "FORMAT String Attributes" 
   FIELD _FORMAT-SOURCE     AS CHAR     LABEL "FORMAT Source"   INITIAL "E" 
   FIELD _HEIGHT            AS DECIMAL  LABEL "Height"
   FIELD _INITIAL-DATA      AS CHAR     LABEL "Initial Data"
   FIELD _LIST-ITEMS        AS CHAR     LABEL "List Items"
   FIELD _MULTIPLE          AS LOGICAL  LABEL "Multiple"
   FIELD _READ-ONLY         AS LOGICAL  LABEL "Read-Only"
   FIELD _ROW               AS DECIMAL  LABEL "Row"
   FIELD _SORT              AS LOGICAL  LABEL "SORT"
   FIELD _SUBSCRIPT         AS INTEGER  LABEL "Subscript"
   FIELD _WIDTH             AS DECIMAL  LABEL "Width"
   FIELD _WORD-WRAP         AS LOGICAL  LABEL "Word Wrap"
   .

/* _Q - Query Record 
           Contains fields related to a Query                               */ 
DEFINE {1} SHARED TEMP-TABLE _Q
   FIELD _OpenQury          AS LOGICAL  LABEL "Open Query Automatically"
                                        INITIAL YES
   					VIEW-AS TOGGLE-BOX   					 
   FIELD _4GLQury           AS CHAR     /* 4GL code defining query           */
   FIELD _TblList           AS CHAR     /* List of tables in query           */
   FIELD _FldList           AS CHAR     /* List of fields selected for browse*/
   FIELD _FldNameList       AS CHAR     EXTENT {&MaxFld}         INITIAL ?
                                  /* List of fields names selected for browse*/
   FIELD _FldEnableList     AS CHAR     EXTENT {&MaxFld}         INITIAL ?
                                  /* List of fields enabled for editting     */
   FIELD _FldLabelList      AS CHAR     EXTENT {&MaxFld}         INITIAL ?
                                  /* List of fields labels selected for browse*/
   FIELD _FldFormatList	    AS CHAR     EXTENT {&MaxFld}         INITIAL ?
                                 /* List of fields formats selected for browse*/
   FIELD _OrdList           AS CHAR     /* List of fields in BREAK BY phrase */
   FIELD _OptionList        AS CHAR     /* Query/Browse Options eg. INDEX-REP */
   FIELD _JoinCode          AS CHAR     EXTENT {&MaxTbl}         INITIAL ?
                                        /* 4GL Join Code                     */
   FIELD _TblOptList        AS CHAR     /* List of Options, by table (eg. "FIRST") */
   FIELD _Where             AS CHAR     EXTENT {&MaxTbl}         INITIAL ?
                                        /* 4GL Where Code  */
   FIELD _TuneOptions       AS CHAR     /* Query Tuning parameters           */
   .
