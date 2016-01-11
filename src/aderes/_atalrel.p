/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*
* _atalrel.p
*
*    Creates the "default relationships" between
*    aliases and their referenced tables.
*/

{ aderes/s-system.i }
{ aderes/j-define.i }
{ aderes/reshlp.i }
{ aderes/_jbkjoin.i }

define input  parameter rebuild   as logical   no-undo.
define input  parameter aliasName as character no-undo.
define input  parameter aliasId   as integer   no-undo.
define input  parameter refId     as integer   no-undo.
define input  parameter copyRels  as logical   no-undo.
define input  parameter copySelf  as logical   no-undo.
define output parameter relList   as character no-undo.


DEFINE VARIABLE i             AS INTEGER   NO-UNDO.
DEFINE VARIABLE j             AS INTEGER   NO-UNDO.
DEFINE VARIABLE joinList      AS CHARACTER NO-UNDO.
DEFINE VARIABLE joinIndex     AS INTEGER   NO-UNDO.
DEFINE VARIABLE joinType      AS CHARACTER NO-UNDO.
DEFINE VARIABLE thisJoin      AS CHARACTER NO-UNDO.
DEFINE VARIABLE joinTypeShort AS CHARACTER NO-UNDO.
DEFINE VARIABLE joinWhere     AS INTEGER   NO-UNDO.
DEFINE VARIABLE tid           AS INTEGER   NO-UNDO.
DEFINE VARIABLE lookAhead     AS CHARACTER NO-UNDO.
DEFINE VARIABLE tempList      AS CHARACTER NO-UNDO.


/*
 * Now deal with copying the relationships of referenced
 * table. NOt only do we have to copy the relationships,
 * we have to add the new relationship to all of the other
 * tables in the. But the function takes car of all that.
 * Automatically relate the alias to the refernece table.
 * "Self-joins" was the major reason for this feature.
 */

{&FIND_TABLE_BY_ID} refId.

tempList = IF NOT copySelf THEN ""
                           ELSE ",=":u + STRING(qbf-rel-buf.tid).
                           
IF copyRels THEN DO:

    /*
     * Get the list of relations from the reference table.
     * Walk through each and call the function that builds
     * relationships
     */
    
    joinList = qbf-rel-buf.rels.
    /* Look for WHERE clauses, add relationship to other tables  */
    DO i = 2 TO NUM-ENTRIES(joinList):

        /* 
         * Create the relationship
         */
         
        RUN breakJoinInfo(ENTRY(i, joinList),
                          OUTPUT joinIndex,
                          OUTPUT joinType,
                          OUTPUT joinTypeShort,
                          OUTPUT joinWhere).

        /*
         * The table may not be there, due to security.
         * If we don't find it then continue on.
         */
         {&FIND_TABLE2_BY_ID} joinIndex NO-ERROR.
         IF NOT AVAILABLE qbf-rel-buf2 THEN NEXT.

        /*
         * Just add the new id to the end. We don't have to sort
         * this list because the new id is larger than anything
         * else in the list
         */

        ASSIGN
            qbf-rel-buf2.rels = qbf-rel-buf2.rels
                              + ",":u + joinTypeShort
                              + STRING(aliasId)
            thisJoin          = ",":u + joinTypeShort + STRING(joinIndex)
        .

        IF joinWhere > 0 THEN DO:
            /*
             * To create a new WHERE, just bump up the
             * counter and substitute the alias name for the
             * table name in the text.
             */
             qbf-rel-whr#         = qbf-rel-whr# + 1.
            
             {&FIND_WHERE_BY_ID} qbf-rel-whr# NO-ERROR.
             IF NOT AVAILABLE qbf-rel-whr THEN DO:
                 CREATE qbf-rel-whr.
                 qbf-rel-whr.wid = qbf-rel-whr#.
             END.
             {&FIND_WHERE2_BY_ID} joinWhere. 
            
             ASSIGN
                 qbf-rel-whr.jwhere = qbf-rel-whr2.jwhere
                 joinWhere          = qbf-rel-whr#
                 qbf-rel-whr.jwhere = REPLACE(qbf-rel-whr.jwhere,
                                              qbf-rel-buf.tname,
                                              aliasName)
                 thisJoin           = thisJoin + ":":u 
                                    + STRING(qbf-rel-whr#)
             .
        END.

        tempList = tempList + thisJoin.
    END.
END.


/*
 * Sort the list for the alias. Then add the self join
 * to the referenced table.
 */
RUN aderes/_jsort1.p(tempList, OUTPUT relList).

/*
 * Add the self join to the referenced table *after* the
 * copy is done. If we don't then the new alias id will
 * be in the list. THe list is copied but the record for
 * the new alias hasn't been created.
 */

IF copySelf THEN
    qbf-rel-buf.rels = qbf-rel-buf.rels
                     + ",=":u
                     + STRING(aliasId).

