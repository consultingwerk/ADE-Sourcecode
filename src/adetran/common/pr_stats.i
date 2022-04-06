/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* pr_stats  include file to print off statistics from both TM and PM 
 *                                                                   
 *    This is included in both pm/_pmstats.p and vt/_stats.w        
 * PROCEDURE print_statistics:   (This is in the calling programs)           
 *
 * Created:
 * Updated: 11/96 SLK Added handling printing of strings longer than 
 *	expected. Deals with both item, itemValue and now itemIndenet 
 */

  DEFINE INPUT PARAMETER flnm   AS CHARACTER                            NO-UNDO.
  DEFINE INPUT PARAMETER fnt    AS INTEGER                              NO-UNDO.
  DEFINE INPUT PARAMETER LPP    AS INTEGER                              NO-UNDO.
  DEFINE INPUT PARAMETER PrFlag AS INTEGER                              NO-UNDO.
  DEFINE INPUT PARAMETER Mode   AS LOGICAL                              NO-UNDO.
  
  DEFINE VARIABLE prt-status    AS LOGICAL                              NO-UNDO.

  DEFINE VARIABLE t-itemRest 	AS CHARACTER				NO-UNDO.
  DEFINE VARIABLE t-itemValueRest AS CHARACTER				NO-UNDO.
  DEFINE VARIABLE t-item 	AS CHARACTER				NO-UNDO.
  DEFINE VARIABLE t-itemValue	AS CHARACTER				NO-UNDO.
  DEFINE VARIABLE t-firstPass	AS LOGICAL				NO-UNDO.
  DEFINE VARIABLE t-itemSpaceCnt	AS INTEGER			NO-UNDO.
  DEFINE VARIABLE t-itemValueSpaceCnt	AS INTEGER			NO-UNDO.
  

  DEFINE VARIABLE tContd AS CHARACTER INIT "~~" NO-UNDO.

  IF NOT Mode THEN /* Output to Printer - change flnm to a temporary filename */
    RUN adecomm/_tmpfile.p ("T2":U, ".tmp":U, OUTPUT flnm).

  OUTPUT TO VALUE(flnm) PAGE-SIZE VALUE(LPP).


  IF PrFlag < 2 THEN DO:  /* Not Landscape */  
    FORM HEADER SKIP (1)
                "Project:" {1} FORMAT "X(25)"
                TODAY  AT 37
                "Page" AT 72 PAGE-NUMBER FORMAT ">>9" SKIP (1)
           WITH NO-BOX PAGE-TOP NO-UNDERLINE FRAME pgtop WIDTH 90.
    VIEW FRAME pgtop.
    FORM
      stats.item  FORMAT "x(41)"
      stats.ItemValue FORMAT "x(43)" AT 44
    WITH FRAME prstats90 WIDTH 90 NO-BOX NO-LABELS DOWN.

    FOR EACH stats NO-LOCK:
      ASSIGN t-firstPass = TRUE
	     t-item = stats.item
	     t-itemValue = stats.itemValue
		.
      
      REPEAT:
         IF LENGTH(t-item) > 41 THEN
             ASSIGN t-itemRest = SUBSTRING(t-item,42)
		    t-item = SUBSTRING(t-item,1,41) .
         ELSE ASSIGN t-itemRest = "":U.

         IF LENGTH(t-itemValue) > 43 THEN
             ASSIGN 
		  t-itemValueRest = SUBSTRING(t-itemValue,44)
                  t-itemValue = SUBSTRING(t-itemValue,1,43).
         ELSE ASSIGN t-itemValueRest = "":U.

         DISPLAY t-item @ stats.item  FORMAT "x(41)"
              t-itemValue @ stats.ItemValue FORMAT "x(43)"
         WITH FRAME prstats90.
         DOWN WITH FRAME prstats90.

	 ASSIGN
           t-item = IF t-itemRest <> "":U THEN FILL(" ":U,stats.itemIndent) + FILL(" ":U,1) + tContd + t-itemRest ELSE "":U
	   t-itemValue = IF t-itemValueRest <> "":U THEN FILL(" ":U,1) + tContd + t-itemValueRest ELSE "":U
	   t-itemRest = "":U
	   t-itemValueRest = "":U
           t-firstPass = FALSE
	.
        IF (TRIM(t-item) = tContd and TRIM(t-itemValue) = tContd )
           OR (TRIM(t-item) = tContd and TRIM(t-itemValue) = "":U) 
           OR (TRIM(t-item) = "":U and TRIM(t-itemValue) = tContd) 
           OR (TRIM(t-item) = "":U and TRIM(t-itemValue) = "":U) 
	THEN LEAVE.
      END. /* repeat until we have printed all of the string */
    END.  /* For each stats */
  END.
  ELSE DO:  /* This is Landscape */
    FORM HEADER SKIP (1)
                "Project: " AT 10
                {1} FORMAT "X(28)"
                TODAY AT 55
                "Page" AT 97 PAGE-NUMBER FORMAT ">>9" SKIP (1)
           WITH NO-BOX PAGE-TOP NO-UNDERLINE FRAME pgtopl WIDTH 121.
    VIEW FRAME pgtopl.
    FORM stats.item FORMAT "X(45)" AT 10
              stats.ItemValue FORMAT "X(60)" AT 57
    WITH FRAME prstats121 WIDTH 121 NO-BOX NO-LABELS DOWN.


    FOR EACH stats NO-LOCK:
      ASSIGN t-firstPass = TRUE
	t-item = stats.item
	t-itemValue = stats.itemValue
.

      REPEAT:
         IF LENGTH(t-item) > 45 THEN
             ASSIGN 
		  t-itemRest = SUBSTRING(t-item,46)
	          t-item = SUBSTRING(t-item,1,45)
  	   .
         ELSE ASSIGN t-itemRest = "":U.

         IF LENGTH(t-itemValue) > 60 THEN
             ASSIGN 
		  t-itemValueRest = SUBSTRING(t-itemValue,61)
	          t-itemValue = SUBSTRING(t-itemValue,1,60)
  	   .
         ELSE ASSIGN t-itemValueRest = "":U.

         DISPLAY t-item @ stats.item 
              t-itemValue @ stats.ItemValue 
         WITH FRAME prstats121.
         DOWN WITH FRAME prstats121.

	 ASSIGN
           t-item = IF t-itemRest <> "":U THEN FILL(" ":U,stats.itemIndent) + FILL(" ":U,1) + tContd + t-itemRest ELSE "":U
	   t-itemValue = IF t-itemValueRest <> "":U THEN FILL(" ":U,1) + tContd + t-itemValueRest ELSE "":U
	   t-itemRest = "":U
	   t-itemValueRest = "":U
           t-firstPass = FALSE
	.
        IF (TRIM(t-item) = tContd and TRIM(t-itemValue) = tContd )
           OR (TRIM(t-item) = tContd and TRIM(t-itemValue) = "":U) 
           OR (TRIM(t-item) = "":U and TRIM(t-itemValue) = tContd) 
           OR (TRIM(t-item) = "":U and TRIM(t-itemValue) = "":U) 
	THEN LEAVE.
    END. /*Repeat */
    END. /*For Each */
  END. /* Landscape */
  OUTPUT CLOSE.
  
  IF NOT Mode THEN DO:  /* Send output to the printer and delete flnm */
    RUN adecomm/_osprint.p (INPUT CURRENT-WINDOW,
                            INPUT flnm,
                            INPUT fnt,
                            INPUT PrFlag + 
                               (IF SESSION:CPSTREAM = "utf-8":U THEN 512 ELSE 0),
                            INPUT LPP,
                            INPUT 0,
                            OUTPUT prt-status).
    OS-DELETE VALUE(flnm).  
  END.
 
/* END PROCEDURE. (This is in the calling programs) */
