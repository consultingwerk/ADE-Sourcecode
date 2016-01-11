&ANALYZE-SUSPEND _VERSION-NUMBER WDT_v2r1 Procedure
&ANALYZE-RESUME

&ANALYZE-SUSPEND _CODE-BLOCK _CUSTOM Definitions 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*----------------------------------------------------------------------------

File: _genfind.p

Description:
   Builds the code for a FIND of the table passed in. This code would be
   inserted in a Web Object that is expected to find (and display a record).
              
Input Parameters :
    p_dbtbl    -- The real name of the table (including database name) 
                  eg. sports.item  
    p_name     -- The name to use in the generated code.  This could be
                  a buffer name, a name without the DB, or the same
                  as p_dbtbl. If this is ? or "" then the p_dbtbl will be used
    p_indent   -- Basic indent to use on all lines (eg. "  ")
    p_options  -- Comma-delimited list of options (currently unused)
    
Output Parameters:
    p_code-- the code generated.
     
Author: Wm.T.Wood

Date Created: April 19, 1997 
Modified:   

----------------------------------------------------------------------------
  Testing Code:   
  
  DEF VAR ch AS CHAR.
  RUN webutil/_findtbl.p
    ("sports.customer", "Customer", "  ", "":U, OUTPUT ch).
  UPDATE ch FONT 2 VIEW-AS EDITOR SIZE 75 BY 15 SCROLLBAR-H SCROLLBAR-V.
----------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER p_dbtbl       AS CHAR NO-UNDO.
DEFINE INPUT  PARAMETER p_name        AS CHAR NO-UNDO.
DEFINE INPUT  PARAMETER p_indent      AS CHAR NO-UNDO.
DEFINE INPUT  PARAMETER p_options     AS CHAR NO-UNDO.
DEFINE OUTPUT PARAMETER p_code        AS CHAR NO-UNDO.

DEFINE VAR cnt        AS INTEGER NO-UNDO.
DEFINE VAR i          AS INTEGER NO-UNDO.
DEFINE VAR fld-name   AS CHAR    NO-UNDO.
DEFINE VAR fld-type   AS CHAR    NO-UNDO.
DEFINE VAR key-list   AS CHAR    NO-UNDO.
DEFINE VAR tmp        AS CHAR    NO-UNDO.
DEFINE VAR tmp2       AS CHAR    NO-UNDO.

/* Preprocessor variables used for spacing code. */
&Scoped-define EOL CHR(10)
&Scoped-define NL  {&EOL} + p_indent

/* Compute the list of key fields to use in the find. */
RUN webutil/_keygues.p (p_dbtbl, "no-field":U,
                         OUTPUT key-list, OUTPUT tmp, OUTPUT tmp2).

/* If the table name to use in the code was not given, default to the
   full db.table name. */
IF p_name eq ? OR p_name eq "":U THEN p_name = p_dbtbl.

/* Write the code needed to find the record using ROWID. */
p_code = 
  SUBSTITUTE (
      {&NL} + "/* See if External Table was passed in as a ROWID. */" +
      {&NL} + "IF get-value('ROWID':U) ne '':U THEN ":U +
      {&NL} + "  FIND &1 WHERE ROWID(&1) eq TO-ROWID(get-value('ROWID':U)) NO-ERROR.",  
      p_name).
    
/* Add code to find using keys. */
ASSIGN cnt = NUM-ENTRIES(key-list).
IF cnt > 0 THEN 
  p_code = p_code + {&EOL} +
      {&NL} + "/* Find External Table using key fields */".
DO i = 1 TO cnt:     
  /* Build a string of the form:
     "FIND tbl WHERE tbl.fld eq INTEGER(get-value('fld')) NO-ERROR. */
  ASSIGN fld-name = ENTRY(i, key-list)
         tmp = "get-value('" + fld-name + "':U)". 
  RUN webutil/_fldtype (p_dbtbl + "." + fld-name, OUTPUT fld-type).
  CASE fld-type:
    WHEN "DECIMAL":U OR WHEN "DATE":U OR WHEN "INTEGER":U THEN 
      tmp = SUBSTITUTE('&2(&1)', tmp, CAPS(fld-type)).
    WHEN "RECID":U THEN
      tmp = SUBSTITUTE('INTEGER(&1)', tmp).
    WHEN "ROWID":U THEN
      tmp = SUBSTITUTE('TO-ROWID(&1)', tmp).
  END.
  p_code = p_code + 
    SUBSTITUTE (
      {&NL} + "IF NOT AVAILABLE &1 AND get-value('&2':U) ne '':U THEN" +
      {&NL} + "  FIND FIRST &1" +
      {&NL} + "       WHERE &1.&2 eq &3" +
      {&NL} + "       NO-ERROR.",  
      p_name, fld-name, tmp).
  
END.

/* Finish the code block. */
p_code = p_code + {&EOL} +
  SUBSTITUTE (
      {&NL} + "/* Get the first record in the case were no key is passed in. " +
      {&NL} + "   (This lets the web object be tested and run standalone.) */" +
      {&NL} + "IF NOT AVAILABLE &1 THEN FIND FIRST &1.",  
      p_name).
   
&ANALYZE-RESUME
/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS


