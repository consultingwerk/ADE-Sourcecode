/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*----------------------------------------------------------------------------

File: qviwdata.p

Description:
   Display _View information for the quick view report.  It will go to 
   the currently set output device (e.g., a file, the printer).
 
Input Parameters:
   p_DbId - Id of the _Db record for this database.
   p_View - The name of the view to report on or "ALL".

Author: Tony Lavinio, Laura Stern

Date Created: 10/05/92

Modified on 06/14/94 by Gerry Seidl. Added NO-LOCKs to file accesses.
----------------------------------------------------------------------------*/

/* This isn't used because there is no db id in _View record
   but there should be!!! */
DEFINE INPUT PARAMETER p_DbId AS RECID NO-UNDO.
DEFINE INPUT PARAMETER p_View AS CHAR  NO-UNDO.

DEFINE BUFFER b_View FOR _View.
DEFINE SHARED STREAM rpt.

DEFINE VAR lbls AS CHAR EXTENT 6 NO-UNDO INITIAL
   [ /* 1 */ "   View Name: ",
     /* 2 */ " Base Tables: ",
     /* 3 */ "Where Clause: ",
     /* 4 */ "    View Def: ",
     /* 5 */ "              "
   ].

&GLOBAL-DEFINE LBL_NAME    1
&GLOBAL-DEFINE LBL_BTBLS   2
&GLOBAL-DEFINE LBL_WHERE   3
&GLOBAL-DEFINE LBL_DEF     4
&GLOBAL-DEFINE LBL_EMPTY   5

DEFINE VAR line    AS CHAR    NO-UNDO.
DEFINE VAR groupby AS LOGICAL NO-UNDO.
DEFINE VAR checkop AS LOGICAL NO-UNDO.

FORM
  b_View._View-name FORMAT "x(30)"  COLUMN-LABEL "View Name"
  b_View._Updatable FORMAT "yes/no" COLUMN-LABEL "Update-!able"
  groupby	    FORMAT "yes/no" COLUMN-LABEL "Group!By?"
  checkop	    FORMAT "yes/no" COLUMN-LABEL "Check!Option?"
  WITH FRAME shoviews DOWN USE-TEXT STREAM-IO.

FORM
  line AT 1  FORMAT "x(77)" NO-LABEL
  WITH FRAME shoviewdef NO-ATTR-SPACE DOWN USE-TEXT STREAM-IO.

FORM
  b_View._Can-read   FORMAT "x(64)" LABEL "Can-Read"   COLON 13 SKIP
  b_View._Can-write  FORMAT "x(64)" LABEL "Can-Write"  COLON 13 SKIP
  b_View._Can-create FORMAT "x(64)" LABEL "Can-Create" COLON 13 SKIP
  b_View._Can-delete FORMAT "x(64)" LABEL "Can-Delete" COLON 13 SKIP(1)
  WITH FRAME shoviewsec SIDE-LABELS USE-TEXT STREAM-IO.

FORM
  _View-Col._Vcol-Order FORMAT ">>>>9" COLUMN-LABEL "Order" AT 2
  _View-Col._Col-Name   FORMAT "x(30)" COLUMN-LABEL "View Column Name" 
  _View-Col._Base-Col   FORMAT "x(38)" COLUMN-LABEL "Base Columns"
  WITH FRAME shoviewcols DOWN USE-TEXT STREAM-IO.


/*==========================Internal Procedures==============================*/

/*--------------------------------------------------------------
   Display the value of a comma delimited list or a 
   where clause, splitting it apart if it is longer
   than will fit and making sure to split on a delimiter
   boundary.  Don't display anything if the value is blank.

   Input Parameter:
      p_Str   - The string to display
      p_Label - Label to display on the first line
      p_Delim - The delimiter to split at (e.g., comma or blank)
----------------------------------------------------------------*/
PROCEDURE Display_Value:

&GLOBAL-DEFINE TEXTLEN	63  /* 77 - Max length of label in bytes */

   DEFINE INPUT PARAMETER p_Str   AS CHAR NO-UNDO.
   DEFINE INPUT PARAMETER p_Label AS CHAR NO-UNDO.
   DEFINE INPUT PARAMETER p_Delim AS CHAR NO-UNDO.
   
   DEFINE VAR frst AS LOGICAL NO-UNDO INIT yes.
   DEFINE VAR val  AS CHAR    NO-UNDO.
   DEFINE VAR ix   AS INTEGER NO-UNDO.

   IF p_Str = "" THEN RETURN.

   DO WHILE LENGTH(p_Str,"RAW":U) > {&TEXTLEN}:
      /* Find the last delimiter within the length of text that will fit. */
      ASSIGN
      	 ix    = R-INDEX(SUBSTRING(p_Str,1,{&TEXTLEN},"FIXED":u), p_Delim)
      	 val   = SUBSTRING(p_Str,1,ix - 1,"CHARACTER":u)
      	 p_Str = TRIM(SUBSTRING(p_Str,ix + 1,-1,"CHARACTER":u))
         .

      DISPLAY STREAM rpt 
      	 (IF frst THEN p_Label ELSE lbls[{&LBL_EMPTY}]) + val @ line
      	 WITH FRAME shoviewdef.
      DOWN STREAM rpt WITH FRAME shoviewdef.
      frst = no.
   END.
   DISPLAY STREAM rpt 
      (IF frst THEN p_Label ELSE lbls[{&LBL_EMPTY}]) + p_Str @ line
      WITH FRAME shoviewdef.
   DOWN STREAM rpt WITH FRAME shoviewdef.
END.

/*--------------------------------------------------------------
   Display information for current view in table format.
----------------------------------------------------------------*/
PROCEDURE Display_View_In_Table:
   ASSIGN 
      /* This is based on a kludge - the _Group-By field is used
      	 for two things.  Since views with the group by option cannot
      	 be updateable, if group-by is not null and the view is 
      	 updateable, it means check-option is yes!
      */
      groupby = (IF b_View._Group-by <> ? AND NOT b_View._Updatable 
      	       	THEN yes ELSE no)
      checkop =	(IF b_View._Group-By <> ? AND     b_View._Updatable 
      	        THEN yes ELSE no).
   DISPLAY STREAM rpt 
      	   b_View._View-name
      	   b_View._Updatable
      	   groupby
      	   checkop
      	   WITH FRAME shoviews.
   DOWN STREAM rpt WITH FRAME shoviews.
END.


/*--------------------------------------------------------------
   Display remaining information for current view.
----------------------------------------------------------------*/
PROCEDURE Display_View_Other:
   DISPLAY STREAM rpt lbls[{&LBL_NAME}] + b_View._View-name 
      @ line WITH frame shoviewdef.
   DOWN STREAM rpt WITH FRAME shoviewdef.

   /* Display base tables */
   RUN Display_Value (INPUT b_View._Base-tables, INPUT lbls[{&LBL_BTBLS}],
      	       	      INPUT ",").

   /* Now display the where clause */
   if b_View._Where-cls <> ? THEN
      RUN Display_Value (INPUT b_View._Where-cls, INPUT lbls[{&LBL_WHERE}], 
      	       	      	 INPUT " ").

   /* Now display the whole view definition */
   if b_View._View-def <> ? THEN
      RUN Display_Value (INPUT b_View._View-def, INPUT lbls[{&LBL_DEF}], 
      	       	      	 INPUT " ").

   DISPLAY STREAM rpt
      b_View._Can-read 
      b_View._Can-write 
      b_View._Can-create 
      b_View._Can-delete
      WITH FRAME shoviewsec.

   FOR EACH _View-Col OF b_View NO-LOCK:
      DISPLAY STREAM rpt
      	 _View-Col._Vcol-Order
      	 _View-Col._Col-Name
      	 _View-Col._Base-Col
      	 WITH FRAME shoviewcols.
      DOWN WITH FRAME shoviewcols.
   END.
END.

/*=============================Mainline Code=================================*/

/* First show name and flags for each view in table format */
IF p_View = "ALL" THEN 
   FOR EACH b_View NO-LOCK:
      RUN Display_View_In_Table.
   END.
ELSE DO:
   FIND b_View NO-LOCK WHERE b_View._View-name = p_View.
   RUN Display_View_In_Table.
END.   

DISPLAY STREAM rpt "" @ line with frame shoviewdef.
DOWN STREAM rpt WITH FRAME shoviewdef.

/* Now show details about the view definitions in sections with side labels */
IF p_View = "ALL" THEN 
   FOR EACH b_View NO-LOCK:
      RUN Display_View_Other.
   END.
ELSE 
   RUN Display_View_Other.





