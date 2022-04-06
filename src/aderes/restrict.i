/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* restrict.i - Sub-Procedures that check for various restricted case.  
    For example, combining certain features causes us to generate code 
    that won't compile.  We may restrict these combinations.
*/

/*------------------------------------------------------------------
   If you do a totals-only summary based on a child sort field, and
   then do a master-detail split we end up with non-compilable code e.g.
   
   FOR EACH customer:
      ...
      /* This next line doesn't compile because there is no FOR, FIND or
         CREATE for an order record at this level.
      */
      IF LAST-OF(order.Odate) THEN
        DISPLAY customer.name.
      FOR EACH order OF customer BREAK BY order.ODate:
        ...
      END.
   END.

   The truth is that a master-detail report is really meaningless for
   any totals-only summary because there will always be only 1 parent
   record shown and only 1 child record shown so what's the point in
   splitting it.  Therefore, we decided to restrict this altogether 
   instead of bothering to figure out if we have this one special case.

   Input Parameters:    
     p_split - true if the user is trying to do a master-detail split now.
               If ?, this routine will determine if we have a split 
               from the queries current settings.  
     p_totals- true if user is trying to add a totals-only summary 
               field now.  If ?, this routine has to figure out
               if there is a totals-only summary field from the queries
               current settings.

   Returns: "error" - If we discover restriction situation.  The error
                      message is displayed here.
            ""      - Go ahead and do your thing.
------------------------------------------------------------------*/
PROCEDURE master_detail_and_totals_only:
  DEFINE INPUT PARAMETER p_split  AS LOGICAL.
  DEFINE INPUT PARAMETER p_totals AS LOGICAL.

  DEFINE VAR ix  AS INTEGER NO-UNDO.
  DEFINE VAR ans AS LOGICAL NO-UNDO.

  IF p_split = ? THEN
    p_split = (qbf-detail <> 0). /* true if we have master-detail split */
  IF NOT p_split THEN
     RETURN "".  

  IF p_totals = ? THEN DO:
    DO ix = 1 TO qbf-rc# WHILE p_totals = ?:
      IF INDEX(qbf-rcg[ix], "$":u) > 0 THEN
        p_totals = true.
    END.
  END.

  IF p_totals = true THEN DO:
    RUN adecomm/_s-alert.p (INPUT-OUTPUT ans, "error":u, "ok":u,
      "Defining a totals only summary with a master-detail split is not supported.").
    RETURN "error".
  END.
  ELSE
    RETURN "".  
END.






