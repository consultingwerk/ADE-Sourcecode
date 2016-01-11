/**********************************************************************
* Copyright (C) 2000,2006 by Progress Software Corporation. All rights*
* reserved.  Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                            *
*                                                                     *
**********************************************************************/

/*----------------------------------------------------------------------------

File: _qseqdat.p

Description:
   Display _Sequence information for the quick sequence report.  It will go 
   to the currently set output device (e.g., a file, the printer).
 
Input Parameters:
   p_DbId - Id of the _Db record for this database.

Author: Tony Lavinio, Laura Stern

Date Created: 10/05/92

Modified on 06/14/94 by Gerry Seidl. Added NO-LOCKs to file accesses.
            08/08/02 D. McMann Eliminated any sequences whose name begins "$" - Peer Direct
            05/25/06 fernando  Added support for large sequences
----------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER p_DbId  AS RECID NO-UNDO.

DEFINE SHARED STREAM rpt.
DEFINE VAR max_min AS INT64 NO-UNDO.
DEFINE VAR large_seq AS LOGICAL NO-UNDO.

FORM
  _Sequence._Seq-Name  FORMAT "x(32)"  	    COLUMN-LABEL "Sequence Name"
  _Sequence._Seq-init  FORMAT "->>>>>>>>9"  COLUMN-LABEL "Initial!Value"
  _Sequence._Seq-incr  FORMAT "->>>>>>>>9"  COLUMN-LABEL "Increment"
  max_min              FORMAT "->>>>>>>>>9" COLUMN-LABEL "Max/Min!Value"
  _Sequence._Cycle-Ok  FORMAT "yes/no"	    COLUMN-LABEL "Cycle?"
  WITH FRAME shoseqs 
  DOWN USE-TEXT STREAM-IO.

FORM
  _Sequence._Seq-Name  FORMAT "x(32)"  	    COLUMN-LABEL "Sequence Name"
  _Sequence._Seq-init  FORMAT "->,>>>,>>>,>>>,>>>,>>>,>>9"  COLUMN-LABEL "Initial Value" SKIP
  _Sequence._Seq-incr  FORMAT "->,>>>,>>>,>>>,>>>,>>>,>>9"  
                       COLUMN-LABEL "Increment"
  max_min              AT 30 FORMAT "->,>>>,>>>,>>>,>>>,>>>,>>9" COLUMN-LABEL "Max/Min Value"
  _Sequence._Cycle-Ok  FORMAT "yes/no"	    COLUMN-LABEL "Cycle?" SKIP(1)
  WITH FRAME shoseqsl
  DOWN USE-TEXT STREAM-IO.

FIND FIRST _db WHERE RECID(_Db) = p_DbId.

/* let's see if we can use the old format based on the values */
IF _Db._db-res1[1] = 1 THEN DO: 
    /* large sequence support is turned on */

    FIND FIRST _Sequence NO-LOCK WHERE _Sequence._Db-recid = p_DbId
                                 AND NOT _Sequence._Seq-name BEGINS "$" AND
         (_Sequence._Seq-incr > 999999999 OR
          _Sequence._Seq-max  > 999999999 OR
          _Sequence._Seq-min  > 999999999 OR
          _Sequence._Seq-init > 999999999) NO-ERROR.

    IF AVAILABLE _Sequence THEN
       /* we will need the expanded report format */
       ASSIGN large_seq = YES.
END.

FOR EACH _Sequence NO-LOCK WHERE _Sequence._Db-recid = p_DbId
                             AND NOT _Sequence._Seq-name BEGINS "$":
   max_min = (IF _Sequence._Seq-incr > 0 THEN _Sequence._Seq-max
      	       	     	      	       	 ELSE _Sequence._Seq-min).
   IF large_seq THEN DO:
       DISPLAY STREAM rpt
          _Sequence._Seq-Name 
          _Sequence._Seq-init 
          _Sequence._Seq-incr 
          max_min
          _Sequence._Cycle-Ok 
          WITH FRAME shoseqsl.
      DOWN STREAM rpt WITH FRAME shoseqsl.
   END.
   ELSE DO:
       DISPLAY STREAM rpt
          _Sequence._Seq-Name 
          _Sequence._Seq-init 
          _Sequence._Seq-incr 
          max_min
          _Sequence._Cycle-Ok 
          WITH FRAME shoseqs.
      DOWN STREAM rpt WITH FRAME shoseqs.
   END.
END.

