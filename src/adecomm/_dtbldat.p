/**********************************************************************
* Copyright (C) 2000,2006 by Progress Software Corporation. All rights*
* reserved.  Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                            *
*                                                                     *
**********************************************************************/
/*----------------------------------------------------------------------------

File: _dtbldat.p

Description:
   Display detailed table,  field and index information to
   the currently set output device (e.g., a file, the printer).
 
Input Parameters:
   p_DbId  - Id of the _Db record for this database.
   p_Tbl   - The name of the table to report on - or ALL for all tables.
   p_Order - Order for field display, "a"- alphabetical or "o" - by order#.

Author: Laura Stern

Date Created: 10/09/92

Modified on 5/31/95 by GFS Allow display of hidden tables (not meta-schema).
            6/07/94 by GFS - 94-05-09-001 - Added NO-LOCKs
            01/07/98 DLM  Added display or current storage area
            04/17/98 DLM  Added check for _field-recid > 0 for default index.
            04/20/98 DLM  change display of area number to area name.
            07/10/98 DLM  Added _owner and DBVERSION syntax for V9 databases
            01/18/00 DLM  Added NO-LOCK where missed.
                          Added display of File Valexp and Valmsg.
            01/31/03 DLM  Added support for Blobs              
            06/15/06 fernando   Adding support for long dump names
----------------------------------------------------------------------------*/
{ prodict/fhidden.i }

DEFINE INPUT PARAMETER p_DbId  AS RECID NO-UNDO.
DEFINE INPUT PARAMETER p_Tbl   AS CHAR  NO-UNDO.
DEFINE INPUT PARAMETER p_Order AS CHAR  NO-UNDO.

DEFINE BUFFER   bField FOR DICTDB._Field.
DEFINE BUFFER   bFile  FOR DICTDB._File.

DEFINE SHARED STREAM rpt.

DEFINE VARIABLE line        AS CHAR                NO-UNDO.
DEFINE VARIABLE name        AS CHAR                NO-UNDO.
DEFINE VARIABLE descrip     AS CHAR    INITIAL ""  NO-UNDO.
DEFINE VARIABLE flags       AS CHAR                   NO-UNDO.
DEFINE VARIABLE fldcnt      AS INTEGER INITIAL -1  NO-UNDO.
DEFINE VARIABLE idx_primary AS LOGICAL                   NO-UNDO.
DEFINE VARIABLE check_crc   AS LOGICAL                   NO-UNDO.
DEFINE VARIABLE word_idx    AS LOGICAL                   NO-UNDO.
DEFINE VARIABLE temp        AS CHAR                NO-UNDO.
DEFINE VARIABLE odbtyp      AS CHARACTER  NO-UNDO. /* list of ODBC-types */
define variable mAreaLabel  as character no-undo.

DEFINE VAR lbls AS CHAR EXTENT 19 NO-UNDO INITIAL
   [ /* 1 */ "        Owner: ",
     /* 2 */ "  Record Size: ",
     /* 3 */ "        Label: ",
     /* 4 */ "    Col-Label: ",
     /* 5 */ "  Description: ",
     /* 6 */ "         Help: ",
     /* 7 */ "      Val-Msg: ",
     /* 8 */ "      Val-Exp: ", 
     /* 9 */ "** Field Name: ",
     /*10 */ "** Index Name: ",
     /*11 */ "               ",
     /*12 */ ""               ,
     /*13 */ "      DB-Link: ",
     /*14 */ " Storage Area: ",
     /*15 */ " Default Area: ",
     /*16 */ "     Lob Size: ",
     /*17 */ "    Code Page: ",
     /*18 */ "    Collation: ",
     /*19*/  "    Dump Name: "
   ].

&GLOBAL-DEFINE LBL_OWNER       1
&GLOBAL-DEFINE LBL_RECSIZE     2
&GLOBAL-DEFINE LBL_LABEL       3
&GLOBAL-DEFINE LBL_COLLABEL    4
&GLOBAL-DEFINE LBL_DESC        5
&GLOBAL-DEFINE LBL_HELP        6
&GLOBAL-DEFINE LBL_VALMSG      7
&GLOBAL-DEFINE LBL_VALEXP      8
&GLOBAL-DEFINE LBL_FLDNAME     9
&GLOBAL-DEFINE LBL_IDXNAME     10
&GLOBAL-DEFINE LBL_EMPTY       11
&GLOBAL-DEFINE LBL_NONE        12
&GLOBAL-DEFINE LBL_DBLINK      13
&GLOBAL-DEFINE LBL_AREA        14
&GLOBAL-DEFINE LBL_DEFAULTAREA 15
&GLOBAL-DEFINE LBL_LSIZE       16
&GLOBAL-DEFINE LBL_CODEPG      17
&GLOBAL-DEFINE LBL_COLL        18
&GLOBAL-DEFINE LBL_DUMPNAME    19

DEFINE VAR separators AS CHAR EXTENT 6 NO-UNDO INITIAL 
[
  "=========================================================================",
  "============================= FIELD SUMMARY =============================", 
  "============================= INDEX SUMMARY =============================",
  "============================= FIELD DETAILS =============================",
  "============================= Table: ",
  "============================= SEQUENCES ================================="
].

&GLOBAL-DEFINE SEP_NEXTTBL    1
&GLOBAL-DEFINE SEP_SUMFIELD   2
&GLOBAL-DEFINE SEP_SUMINDEX   3
&GLOBAL-DEFINE SEP_DETFIELD   4
&GLOBAL-DEFINE SEP_TBLNAME    5
&GLOBAL-DEFINE SEP_SEQUENCE   6

&GLOBAL-DEFINE SEP_TBLEND " " + STRING(separators[{&SEP_NEXTTBL}],   SUBSTITUTE("x(&1)", 35 - LENGTH(bFile._File-name,"RAW":u)))

/*=================================Forms===================================*/

/* For general long text strings.  line is formatted as appropriate. */
FORM
   line FORMAT "x(77)" NO-LABEL
   WITH FRAME rptline NO-ATTR-SPACE DOWN NO-BOX USE-TEXT STREAM-IO.

FORM
   bFile._File-name  FORMAT "x(32)"  COLUMN-LABEL "Table!Name"
   flags             FORMAT "x(5)"   COLUMN-LABEL "Table!Flags" 
   fldcnt            FORMAT ">>>>9"  COLUMN-LABEL "Field!Count"
   bFile._numkey     FORMAT ">>>>9"  COLUMN-LABEL "Index!Count"
   bFile._File-label FORMAT "x(24)"  COLUMN-LABEL "Table!Label"
   WITH FRAME sumtable NO-ATTR-SPACE USE-TEXT STREAM-IO DOWN.

FORM
   dictdb._File-trig._Event         AT 8  FORMAT "x(13)"  COLUMN-LABEL "Trigger Event"
   dictdb._File-trig._Proc-name       FORMAT "x(20)"  COLUMN-LABEL "Trigger Procedure"
   dictdb._File-trig._Override        FORMAT "yes/no" COLUMN-LABEL "Overridable?"
   check_crc                        FORMAT "yes/no" COLUMN-LABEL "Check CRC?"
   WITH FRAME tbltrigs NO-ATTR-SPACE DOWN NO-BOX USE-TEXT STREAM-IO.

FORM
   bField._Order      FORMAT ">>>>9" COLUMN-LABEL "Order"
   bField._Field-name FORMAT "x(32)" COLUMN-LABEL "Field Name"
   bField._Data-type  FORMAT "x(11)" COLUMN-LABEL "Data Type"
   flags              FORMAT "x(4)"  COLUMN-LABEL "Flags"   
   WITH FRAME sumfield NO-ATTR-SPACE DOWN NO-BOX USE-TEXT STREAM-IO.

FORM
  bField._Field-name FORMAT "x(32)" COLUMN-LABEL "Field Name"
  bField._Format     FORMAT "x(29)" COLUMN-LABEL "Format"
  WITH FRAME nsumfield NO-ATTR-SPACE DOWN NO-BOX USE-TEXT STREAM-IO.

FORM
  bField._Field-name FORMAT "x(32)" COLUMN-LABEL "Field Name"
  bField._Initial    FORMAT "x(29)" COLUMN-LABEL "Initial"
  WITH FRAME isumfield NO-ATTR-SPACE DOWN NO-BOX USE-TEXT STREAM-IO.

FORM
  bField._Field-name FORMAT "x(30)"  COLUMN-LABEL "Field Name"
  bField._Label      FORMAT "x(22)"  COLUMN-LABEL "Label"
  bField._Col-label  FORMAT "x(22)"  COLUMN-LABEL "Column Label"
  WITH FRAME fieldlbls NO-ATTR-SPACE DOWN NO-BOX USE-TEXT STREAM-IO.

FORM
   dictdb._Field-trig._Event         AT 8  FORMAT "x(13)"  COLUMN-LABEL "Trigger Event"
   dictdb._Field-trig._Proc-name      FORMAT "x(20)"  COLUMN-LABEL "Trigger Procedure"
   dictdb._Field-trig._Override       FORMAT "yes/no" COLUMN-LABEL "Overridable?"
   check_crc                        FORMAT "yes/no" COLUMN-LABEL "Check CRC?"
   WITH FRAME fldtrigs NO-ATTR-SPACE DOWN NO-BOX USE-TEXT STREAM-IO.

FORM
  flags                   FORMAT "x(5)"  COLUMN-LABEL "Flags"
  dictdb._Index._Index-name      FORMAT "x(32)" COLUMN-LABEL "Index Name"
  dictdb._Index._Num-comp        FORMAT ">>9"   COLUMN-LABEL "Cnt"
  dictdb._Index-field._Ascending FORMAT "+ /- " COLUMN-LABEL "Fi" SPACE(0)
  dictdb._Field._Field-name      FORMAT "x(31)" COLUMN-LABEL "eld Name"
  WITH FRAME sumindex NO-ATTR-SPACE DOWN NO-BOX USE-TEXT STREAM-IO.

FORM
  SKIP(1) 
  SPACE(3) bFile._File-name LABEL "Working on" FORMAT "x(32)" SPACE
  SKIP(1)
  WITH FRAME working_on SIDE-LABELS VIEW-AS DIALOG-BOX 
  TITLE "Generating Report".


/*==========================Internal Procedures==============================*/

/*--------------------------------------------------------------
   Display a line of the report, splitting it apart if it is 
   longer than will fit and making sure to split on a delimiter
   (blank) boundary.  Don't display it if it's blank.

   Input Parameter:
      p_Str   - The string to display
      p_Label - Label to display on the first line
      p_null  - display even if p_Str is null else do nothing.
----------------------------------------------------------------*/
PROCEDURE Display_Value:

&GLOBAL-DEFINE TEXTLEN        60  /* 77 - Max length of label */

   DEFINE INPUT PARAMETER p_Str   AS CHAR    NO-UNDO.
   DEFINE INPUT PARAMETER p_Label AS CHAR    NO-UNDO.
   DEFINE INPUT PARAMETER p_null  AS LOGICAL NO-UNDO.
   
   DEFINE VARIABLE val  AS CHAR    NO-UNDO.
   DEFINE VARIABLE ix   AS INTEGER NO-UNDO.
   DEFINE VARIABLE frst AS LOGICAL NO-UNDO INIT yes.

   IF NOT p_null AND p_Str = "" THEN RETURN.

   DO WHILE LENGTH(p_Str,"RAW":u) > {&TEXTLEN}:
      /* Find the last delimiter within the length of text that will fit. */
      ASSIGN
               ix    = R-INDEX(SUBSTRING(p_Str,1,{&TEXTLEN},"FIXED":u), " ")
               ix    = (IF ix = 0 THEN {&TEXTLEN} ELSE ix)
               val   = SUBSTRING(p_Str,1,ix - 1,"CHARACTER":u)   
               p_Str = TRIM(SUBSTRING(p_Str,ix + 1,-1,"CHARACTER":u)).

      DISPLAY STREAM rpt 
               (IF frst THEN p_Label ELSE lbls[{&LBL_EMPTY}]) + val @ line
               WITH FRAME rptline.
      DOWN STREAM rpt WITH FRAME rptline.
      frst = no.
   END.
   DISPLAY STREAM rpt 
      (IF frst THEN p_Label ELSE lbls[{&LBL_EMPTY}]) + p_Str @ line
      WITH FRAME rptline.
   DOWN STREAM rpt WITH FRAME rptline.
END.

/*--------------------------------------------------------------------
   Display the data for one record of the field summary report which
   is in table format.
--------------------------------------------------------------------*/
PROCEDURE Display_Fld_Summary_Rec:
   DEFINE VARIABLE dspdt   AS CHARACTER NO-UNDO.

   IF bField._Data-type = "DATETIME" THEN
     ASSIGN dspdt = "datetm".
   ELSE IF bField._Data-type = "DATETIME-TZ" THEN
     ASSIGN dspdt = "datetm-tz".
   ELSE 
     ASSIGN dspdt = SUBSTRING(bField._Data-type,1,4,"CHARACTER":u).

   IF bField._Data-type <> "Decimal" OR bField._Decimals = ? THEN.
   ELSE 
     ASSIGN dspdt = dspdt + "-" + STRING(bField._Decimals).

   IF bField._Extent > 0 THEN
     ASSIGN dspdt = dspdt + "[" + STRING(bField._Extent) + "]".

   DISPLAY STREAM rpt
      bField._Order
      bField._Field-name
      dspdt @ bField._Data-type
  
      /* flags */
      (   (IF bField._Fld-case THEN "c" ELSE "")
        + (IF CAN-FIND(FIRST dictdb._Index-field OF bField)
           THEN "i" ELSE "")
        + (IF bField._Mandatory THEN "m" ELSE "")
        + (IF CAN-FIND(FIRST dictdb._View-ref
          WHERE dictdb._View-ref._Ref-Table = bFile._File-name
          AND dictdb._View-ref._Base-col = bField._Field-name)
          THEN "v" ELSE "")
      ) @ flags

      WITH FRAME sumfield.
   DOWN STREAM rpt WITH FRAME sumfield.
END.
/*--------------------------------------------------------------------
   Display the data for one record of the field format report which
   is in table format.
--------------------------------------------------------------------*/
PROCEDURE Display_Fld_Format:

   DISPLAY STREAM rpt
      bField._Field-name
      bField._Format
      WITH FRAME nsumfield.           
   DOWN STREAM rpt WITH FRAME nsumfield.
END.

/*--------------------------------------------------------------------
   Display the data for one record of the field inital value report which
   is in table format.
--------------------------------------------------------------------*/
PROCEDURE Display_Fld_Initial:

   DISPLAY STREAM rpt
      bField._Field-name
      bField._Initial
      WITH FRAME isumfield.           
   DOWN STREAM rpt WITH FRAME isumfield.
END.

/*--------------------------------------------------------------------
   Display the data for one record of the field label report which
   is in table format.
--------------------------------------------------------------------*/
PROCEDURE Display_Fld_Labels:

   DISPLAY STREAM rpt
      bField._Field-name
      bField._Label
      bField._Col-label
      WITH FRAME fieldlbls.           
   DOWN STREAM rpt WITH FRAME fieldlbls.
END.


/*--------------------------------------------------------------------
   Display the data for field in the detail report.  This includes
   stuff that didn't fit in the summary tables.
--------------------------------------------------------------------*/
PROCEDURE Display_Fld_Detail_Rec:
   DEFINE VAR any_vals        AS LOGICAL NO-UNDO.
   DEFINE VAR any_trig        AS LOGICAL NO-UNDO.
   define variable cAreaLabel as character no-undo.
   define buffer bFile for dictdb._file. 
   
   any_vals = (IF (bField._Desc = ?   OR bField._Desc = "")   AND
                               (bField._Help = ?   OR bField._Help = "")   AND
                               (bField._Valmsg = ? OR bField._Valmsg = "") AND
                               (bField._Valexp = ? OR bField._Valexp = "")
                     THEN no else yes).
   any_trig = (IF CAN-FIND(FIRST dictdb._Field-trig OF bField) THEN yes else no).

   IF any_vals OR any_trig THEN
      RUN Display_Value (bField._Field-name, lbls[{&LBL_FLDNAME}], no).

   IF any_vals THEN DO:
      if bField._Desc <> ? THEN DO:
         temp = REPLACE(bField._Desc, CHR(10), " "). /* remove carriage rtrns */
         RUN Display_Value (temp, lbls[{&LBL_DESC}], no).
      END.
      if bField._Help <> ? THEN
         RUN Display_Value (bField._Help, lbls[{&LBL_HELP}], no).
      if bField._Valmsg <> ? THEN
         RUN Display_Value (bField._Valmsg, lbls[{&LBL_VALMSG}], no).
      if bField._Valexp <> ? THEN
         RUN Display_Value (bField._Valexp, lbls[{&LBL_VALEXP}], no).
   
      DOWN STREAM rpt 1 WITH FRAME rptline.
   END.
   
   IF bField._Data-type = "BLOB" OR bField._Data-type = "CLOB"  
   AND dictdb._Db._Db-type = "PROGRESS" THEN DO:
     find bFile of bField no-lock.
     
     if INTEGER(DBVERSION("DICTDB")) > 10 then
     do:
        FIND dictdb._StorageObject WHERE dictdb._StorageObject._Db-recid = bFile._db-Recid
                                     and dictdb._StorageObject._Object-Number = bField._Fld-stlen 
                                     and dictdb._StorageObject._Object-type = 3 
                                     and dictdb._StorageObject._Partitionid = 0
                                     NO-LOCK NO-ERROR.
         /* show label as default area if multi-tenant */
         cAreaLabel = if bFile._File-Attributes[1] 
                      then lbls[{&LBL_DEFAULTAREA}]
                      else lbls[{&LBL_AREA}]. 
     end.
     else do:
         FIND dictdb._StorageObject WHERE dictdb._StorageObject._Db-recid = bFile._db-Recid
                                      and dictdb._StorageObject._Object-Number = bField._Fld-stlen 
                                      and dictdb._StorageObject._Object-type = 3 
                                      NO-LOCK NO-ERROR.
         cAreaLabel = lbls[{&LBL_AREA}].
     end.
       
     IF AVAILABLE _StorageObject THEN 
     do:
         FIND dictdb._Area where dictdb._Area._Area-number = dictdb._StorageObject._Area-number NO-LOCK.
         RUN Display_Value (bField._Field-name, lbls[{&LBL_FLDNAME}], no).
         RUN Display_Value (dictdb._Area._Area-name, cAreaLabel, no). 
         RUN Display_Value (bField._Fld-Misc2[1], lbls[{&LBL_LSIZE}], no).
         IF bField._Data-type = "CLOB" then
         DO: 
           RUN Display_Value (bField._Charset, lbls[{&LBL_CODEPG}], no).
           RUN Display_Value (bField._Collation, lbls[{&LBL_COLL}], no).
         END.
         DOWN STREAM rpt 1 WITH FRAME rptline.   
     end.
   END.
   /*----- Field triggers -----*/
   FOR EACH dictdb._Field-trig OF bField NO-LOCK:
      DISPLAY STREAM rpt 
               dictdb._Field-trig._Event
               dictdb._Field-trig._Proc-name
               dictdb._Field-trig._Override
               (IF dictdb._Field-trig._Trig-Crc <> 0 AND dictdb._Field-trig._Trig-Crc <> ?
                  THEN yes ELSE no) @ check_crc
               WITH FRAME fldtrigs.
      DOWN STREAM rpt WITH FRAME fldtrigs.
   END.

   IF any_trig THEN
      DOWN STREAM rpt 1 WITH FRAME rptline.
END.


/*===========================Mainline code=================================*/

ASSIGN
  odbtyp = {adecomm/ds_type.i &direction = "ODBC" &from-type = "flags"}.
                  
IF p_Tbl = "ALL" THEN
   SESSION:IMMEDIATE-DISPLAY = yes.
   
FIND dictdb._Db NO-LOCK WHERE RECID(_Db) = p_DbId.

/* Summary table data */
IF p_Tbl = "ALL" THEN DO:
   line = STRING("Table Name","x(15)") + "Description".
   DISPLAY STREAM rpt line WITH FRAME rptline.
   DOWN STREAM rpt WITH FRAME rptline.
   line = FILL ("-", 76).
   DISPLAY STREAM rpt line WITH FRAME rptline.
   DOWN STREAM rpt WITH FRAME rptline.

   FOR EACH bFile NO-LOCK 
     WHERE bFile._Db-recid = p_DbId AND (IF NOT fHidden THEN NOT bFile._Hidden ELSE bFile._File-Number > 0)
     BY bFile._File-name:
     
     IF INTEGER(DBVERSION("DICTDB")) > 8 AND (bFile._Owner <> "PUB" AND bFile._Owner <> "_FOREIGN")
       THEN NEXT.

     temp = REPLACE(bFile._Desc, CHR(10), " "). /* remove carriage rtrns */
     RUN Display_Value (temp,
       STRING(SUBSTRING(bFile._File-name,1,14,"FIXED":u),"x(15)"),yes).
   END.
END.

FOR EACH bFile NO-LOCK 
  WHERE bFile._Db-recid = p_DbId 
    AND (IF p_Tbl = "ALL" THEN (IF NOT fHidden THEN NOT bFile._Hidden ELSE bFile._File-Number > 0)
         ELSE bFile._File-name = p_Tbl)
    BY bFile._File-name:

   IF INTEGER(DBVERSION("DICTDB")) > 8 AND (bFile._Owner <> "PUB" AND bFile._Owner <> "_FOREIGN")
       THEN NEXT.

   PAGE STREAM rpt.
   IF p_Tbl = "ALL" THEN
      DISPLAY bFile._File-name WITH FRAME working_on.

   /*----- Table information -----*/

   /* Table separator and flags */
   DOWN STREAM rpt 2 WITH FRAME rptline.
   DISPLAY STREAM rpt separators[{&SEP_NEXTTBL}] @ line WITH FRAME rptline.
   DOWN STREAM rpt WITH FRAME rptline.
   DISPLAY STREAM rpt separators[{&SEP_TBLNAME}] + bFile._File-name + 
      {&SEP_TBLEND} @ line WITH FRAME rptline.
   DOWN STREAM rpt 2 WITH FRAME rptline.

   flags = STRING("", "x(4)") + 
                 "Table Flags: ""m"" = multi-tenant, ""f"" = frozen, ""s"" = a SQL table".
   DISPLAY STREAM rpt flags @ line WITH FRAME rptline.
   DOWN STREAM rpt 2 WITH FRAME rptline.

   /* Table info */      
   ASSIGN
      flags = (if bFile._File-Attributes[1] then "m" else "")
      flags = (flags + IF bFile._Db-lang > 0 THEN "s" ELSE "")
      flags = (flags + IF bFile._Frozen THEN "f" ELSE "").

   DISPLAY STREAM rpt
      bFile._File-name
      flags
      bFile._numkey
      /* Progress Db's have an extra hidden field that holds the table # 
               which gateway Db's don't have.
      */
      (IF dictdb._Db._Db-type = "PROGRESS"
       OR dictdb._Db._Db-type = "AS400" 
       OR CAN-DO(odbtyp,dictdb._Db._Db-type)
       THEN bFile._numfld - 1 
       ELSE bFile._numfld) @ fldcnt
      bFile._File-label
      WITH FRAME sumtable.

  /* IF (bFile._Desc <> ? AND bFile._Desc <> "" AND p_Tbl <> "ALL") OR
      (bFile._For-Owner <> ? AND bFile._For-Owner <> "") OR
      (bFile._For-Size <> ?) THEN */
      DOWN STREAM rpt 1 WITH FRAME rptline.

   RUN Display_Value (bFile._Dump-name, lbls[{&LBL_DUMPNAME}], no).
   IF bFile._Desc <> ? /* AND p_Tbl <> "ALL"*/ THEN DO:
      temp = REPLACE(bFile._Desc, CHR(10), " "). /* remove carriage rtrns */
      RUN Display_Value (temp, lbls[{&LBL_DESC}], no).
   END.   
   if bFile._Valexp <> ? THEN
         RUN Display_Value (bFile._Valexp, lbls[{&LBL_VALEXP}], no).  
   if bFile._Valmsg <> ? THEN
         RUN Display_Value (bFile._Valmsg, lbls[{&LBL_VALMSG}], no).
   IF dictdb._Db._Db-type = "PROGRESS" AND INTEGER(DBVERSION("DICTDB")) > 8 THEN 
   DO:
   
     IF INTEGER(DBVERSION("DICTDB")) > 10 THEN
     DO:
        FIND  dictdb._StorageObject WHERE dictdb._StorageObject._Db-recid = bFile._db-recid
                                     and dictdb._StorageObject._Object-Number = bFile._File-Number 
                                     and dictdb._StorageObject._Object-type = 1 
                                     and dictdb._StorageObject._Partitionid = 0 NO-LOCK NO-ERROR.
        /* show label as default area if multi-tenant */
        mAreaLabel = if bFile._File-Attributes[1] 
                     then lbls[{&LBL_DEFAULTAREA}]
                     else lbls[{&LBL_AREA}]. 
     END.                
     ELSE DO:
        FIND  dictdb._StorageObject WHERE dictdb._StorageObject._Db-recid = bFile._db-recid
                                     and  dictdb._StorageObject._Object-Number = bFile._File-Number 
                                     and  dictdb._StorageObject._Object-type = 1 NO-LOCK NO-ERROR. 
         mAreaLabel = lbls[{&LBL_AREA}].
     
     END.                        
     IF AVAILABLE _StorageObject THEN DO:
       FIND dictdb._Area where dictdb._Area._Area-number = dictdb._StorageObject._Area-number NO-LOCK.                              
       RUN Display_Value (dictdb._Area._Area-name,mAreaLabel, no). 
     END.
     ELSE DO:
       RUN Display_Value (bFile._ianum, lbls[{&LBL_AREA}], no).
     END.    
   END.
   ELSE
       RUN Display_Value ("N/A", lbls[{&LBL_AREA}], no).
   
   if bFile._For-Owner <> ? THEN
      RUN Display_Value (bFile._For-Owner, lbls[{&LBL_OWNER}], no).
   if bFile._For-Size <> ? THEN
      RUN Display_Value (STRING(bFile._For-Size), lbls[{&LBL_RECSIZE}], no).
   if bFile._Fil-misc2[8] <> ? THEN
      RUN Display_Value (bFile._Fil-misc2[8], lbls[{&LBL_DBLINK}], no).

   IF CAN-FIND(FIRST dictdb._File-trig OF bFile) THEN
      DOWN STREAM rpt 1 WITH FRAME rptline.

   /*----- Table triggers -----*/
   FOR EACH dictdb._File-trig OF bFile NO-LOCK:
      DISPLAY STREAM rpt 
               dictdb._File-trig._Event
               dictdb._File-trig._Proc-name
               dictdb._File-trig._Override
               (IF dictdb._File-trig._Trig-Crc <> 0 AND dictdb._File-trig._Trig-Crc <> ?
                  THEN yes ELSE no) @ check_crc
               WITH FRAME tbltrigs.
      DOWN STREAM rpt WITH FRAME tbltrigs.
   END.

   /*----- Field summary -----*/

   /* Field separator and flags */
   DOWN STREAM rpt 2 WITH FRAME rptline.
   DISPLAY STREAM rpt separators[{&SEP_SUMFIELD}] @ line WITH FRAME rptline.
   DOWN STREAM rpt WITH FRAME rptline.
   DISPLAY STREAM rpt separators[{&SEP_TBLNAME}] + bFile._File-name + 
      {&SEP_TBLEND} @ line WITH FRAME rptline.
   DOWN STREAM rpt 2 WITH FRAME rptline.

   flags = "Flags: <c>ase sensitive, <i>ndex component, <m>andatory, " +
           "<v>iew component".
   DISPLAY STREAM rpt flags @ line WITH FRAME rptline.
   DOWN STREAM rpt 2 WITH FRAME rptline.

   /* Field info */
   IF p_Order = "a" THEN
      FOR EACH bField OF bFile NO-LOCK USE-INDEX _Field-Name:
         RUN Display_Fld_Summary_Rec. 
      END.
   ELSE
      FOR EACH bField OF bFile NO-LOCK USE-INDEX _Field-Position:
         RUN Display_Fld_Summary_Rec.
      END.

   DOWN STREAM rpt 1 WITH FRAME rptline.
   
   /* Display format and initial values. */
   IF p_order = "a" THEN
     FOR EACH bField OF bFile NO-LOCK USE-INDEX _File/Field:
        RUN Display_Fld_Format.
     END.
   ELSE
     FOR EACH bField OF bFile NO-LOCK USE-INDEX _Field-Position:
        RUN Display_Fld_Format.
     END.

      DOWN STREAM rpt 1 WITH FRAME rptline.

   IF p_order = "a" THEN
     FOR EACH bField OF bFile NO-LOCK USE-INDEX _File/Field:
        RUN Display_Fld_Initial.
     END.
   ELSE
     FOR EACH bField OF bFile NO-LOCK USE-INDEX _Field-Position:
        RUN Display_Fld_Initial.
     END.

      DOWN STREAM rpt 1 WITH FRAME rptline.

   /* Labels and Col labels */
   IF p_Order = "a" THEN
      FOR EACH bField OF bFile NO-LOCK USE-INDEX _File/Field:
               RUN Display_Fld_Labels.
      END.
   ELSE
      FOR EACH bField OF bFile NO-LOCK USE-INDEX _Field-Position:
               RUN Display_Fld_Labels.
      END.

   /*----- Index Summary -----*/

   /* Index separator and flags */
   DOWN STREAM rpt 2 WITH FRAME rptline.
   DISPLAY STREAM rpt separators[{&SEP_SUMINDEX}] @ line WITH FRAME rptline.
   DOWN STREAM rpt WITH FRAME rptline.
   DISPLAY STREAM rpt separators[{&SEP_TBLNAME}] + bFile._File-name + 
      {&SEP_TBLEND} @ line WITH FRAME rptline.
   DOWN STREAM rpt 2 WITH FRAME rptline.

   flags = "Flags: <p>rimary, <u>nique, <w>ord, <a>bbreviated, <i>nactive, " +
                 "+ asc, - desc".
   DISPLAY STREAM rpt flags @ line WITH FRAME rptline.
   DOWN STREAM rpt 2 WITH FRAME rptline.

   /* Index info */
   FOR EACH dictdb._Index OF bFile NO-LOCK BREAK BY dictdb._Index._Index-name:
      FIND LAST dictdb._Index-field OF dictdb._Index NO-LOCK NO-ERROR.
      flags = 
           ( (IF bFile._Prime-index = RECID(dictdb._Index) 
              THEN "p" ELSE "")
           + (IF dictdb._Index._Unique   
               THEN "u" ELSE "")
           + (IF NOT dictdb._Index._Active
               THEN "i" ELSE "") 
           + (IF dictdb._Index._Wordidx = 1
               THEN "w" ELSE "") 
                 + (IF AVAILABLE dictdb._Index-field AND dictdb._Index-field._Abbreviate
                     THEN "a" ELSE "") ).

      DISPLAY STREAM rpt
                flags
                dictdb._Index._Index-name
                dictdb._Index._Num-comp
                WITH FRAME sumindex.

      /* The default index has no fields! so this loop must be separate
               from the FOR EACH _Index loop or we'll get no output.
      */
      FOR EACH dictdb._Index-field OF dictdb._Index NO-LOCK:
        IF dictdb._Index-field._Field-recid > 0 THEN DO:
          FIND dictdb._Field WHERE RECID(dictdb._Field) = dictdb._Index-field._Field-recid NO-LOCK.
               
          DISPLAY STREAM rpt
              dictdb._Field._Field-name
              dictdb._Index-field._Ascending
              WITH FRAME sumindex.
         END.
         ELSE
           DISPLAY STREAM rpt
             "" @ dictdb._Field._Field-name
             dictdb._Index-field._Ascending
             WITH FRAME sumindex.

         DOWN STREAM rpt WITH FRAME sumindex.    
      END.
      
     /* Put an extra line in between each index. */
     IF LAST-OF(dictdb._Index._Index-name) THEN 
        DOWN STREAM rpt 1 WITH FRAME sumindex.
   END.

   /*----- Index descriptions -----*/
   FOR EACH dictdb._Index OF bFile NO-LOCK:
      IF dictdb._Index._Desc <> ? THEN DO:
         RUN Display_Value (dictdb._Index._Index-Name, lbls[{&LBL_IDXNAME}], no).
         temp = REPLACE(dictdb._Index._Desc, CHR(10), " ").
         RUN Display_Value (temp, lbls[{&LBL_DESC}], no).
      END.
      ELSE 
         RUN Display_Value (dictdb._Index._Index-Name, lbls[{&LBL_IDXNAME}], no).
         
      IF dictdb._Db._Db-type = "PROGRESS"  AND INTEGER(DBVERSION("DICTDB")) > 8 THEN 
      DO:   
         
         IF INTEGER(DBVERSION("DICTDB")) > 10 THEN
         DO:
            /* first in case of multiple collations */ 
            FIND first dictdb._StorageObject WHERE dictdb._StorageObject._Db-recid = bFile._db-recid
                                             and   dictdb._StorageObject._Object-Number = dictdb._Index._Idx-num 
                                             and   dictdb._StorageObject._Object-type = 2 
                                             and   dictdb._StorageObject._Partitionid = 0 
                                      NO-LOCK NO-ERROR.
            /* show label as default area if multi-tenant */
            mAreaLabel = if bFile._File-Attributes[1] 
                         then lbls[{&LBL_DEFAULTAREA}]
                         else lbls[{&LBL_AREA}]. 
        END.                
        ELSE DO:
            FIND  dictdb._StorageObject WHERE dictdb._StorageObject._Db-recid = bFile._db-recid
                                        and   dictdb._StorageObject._Object-Number = dictdb._Index._Idx-num 
                                        and   dictdb._StorageObject._Object-type = 2 
                                         NO-LOCK NO-ERROR. 
             mAreaLabel = lbls[{&LBL_AREA}].
         END.
        
         IF AVAILABLE dictdb._StorageObject THEN DO:
            FIND dictdb._Area where dictdb._Area._Area-number = dictdb._StorageObject._Area-number NO-lock.
            RUN Display_Value (dictdb._Area._Area-name, mAreaLabel, no). 
         END.
         ELSE            
            RUN Display_Value (dictdb._Index._ianum, lbls[{&LBL_AREA}], no).
      END.
      ELSE
        RUN Display_Value ("N/A", lbls[{&LBL_AREA}], no).
           
   END.
   
   /*----- Field details -----*/
   
   /* Detail separator */
   DOWN STREAM rpt 2 WITH FRAME rptline.
   DISPLAY STREAM rpt separators[{&SEP_DETFIELD}] @ line WITH FRAME rptline.
   DOWN STREAM rpt WITH FRAME rptline.
   DISPLAY STREAM rpt separators[{&SEP_TBLNAME}] + bFile._File-name + 
      {&SEP_TBLEND} @ line WITH FRAME rptline.
   DOWN STREAM rpt 2 WITH FRAME rptline.

   /* More field info */
   IF p_Order = "a" THEN
      FOR EACH bField OF bFile NO-LOCK USE-INDEX _Field-Name:
         RUN Display_Fld_Detail_Rec. 
      END.
   ELSE
      FOR EACH bField OF bFile NO-LOCK USE-INDEX _Field-Position:
         RUN Display_Fld_Detail_Rec.
      END.
END.

IF p_Tbl = "ALL" THEN
DO:
   DISPLAY "Sequences" @ bFile._File-name WITH FRAME working_on.
   DOWN STREAM rpt 2 WITH FRAME rptline.
   DISPLAY STREAM rpt separators[{&SEP_SEQUENCE}] @ line WITH FRAME rptline.
   DOWN STREAM rpt WITH FRAME rptline.
   RUN adecomm/_qseqdat.p (INPUT p_DbId).

   HIDE FRAME working_on NO-PAUSE.
   SESSION:IMMEDIATE-DISPLAY = no.
END.

RETURN "".





