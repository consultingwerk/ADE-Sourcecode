&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r2 GUI
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*----------------------------------------------------------------------------

File: _keygus2.p

NOTE: 
   This file uses the QBF$1 alias, which must be set before this program is
   run. This alias is set in _keygues.p, which calls this program. You should
   not call this program directly.
   
    ********************************************************************
         THE ONLY FILE THAT SHOULD CALL THIS ONE IS ADEUIB/_KEYQUES.P
    ********************************************************************
    
Description:
   Takes a "_FILE" and tries to find the likely foriegn keys in the
   rest of the database.  This is done by finding all the UNIQUE indices
   in the database that have only a single field. If there are any field
   in the _FILE with the same name and data-type as these fields, then 
   we assume that they are foriegn keys.
   
   Two lists are returned:
     1) fields that are in _FILE and are _INDEX-FIELDS of _FILE.
     2) fields in _FILE that are not necessarily index fields.
    
Parameters Buffers:
    p_table  - The name of the table (including database name) eg. sports.item
    
Output Parameters:
    p_unique-list -- the list of foreign keys that are UNIQUE indices in p_FILE
                     (i.e. the field is the only element of a UNIQUE index).
    p_index-list  -- the list of foreign keys that are indices in p_FILE
    p_field-list  -- the list of foreign keys that are fields in p_FILE
    
Author: Wm.T.Wood

Date Created: April 1996

Modified: <none>

---------------------------------- Test Code --------------------------------
 
  DEFINE VAR unique-list AS CHAR NO-UNDO.
  DEFINE VAR index-list  AS CHAR NO-UNDO.
  DEFINE VAR field-list  AS CHAR NO-UNDO.
  DEFINE VAR ans         AS LOGICAL NO-UNDO.
  
  FOR EACH _DB,
      EACH _FILE OF _DB WHERE NOT _FILE._FILE-NAME BEGINS ('_':U):
    IF INTEGER(DBVERSION("DICTDB":U)) > 8 THEN DO:
      IF LOOKUP(DICTDB._FILE._OWNER,"PUB,_FOREIGN":U) > 0 THEN NEXT.
    END.
                                
    RUN adeuib/_keygues.p (SDBNAME(1) + ".":U + _FILE._FILE-NAME, 
                           OUTPUT unique-list, OUTPUT index-list,
                           OUTPUT field-list).
    MESSAGE "Best Guess for Foriegn Keys in" _FILE._FILE-NAME SKIP
            "    =============================" SKIP
            "Unique Matches: " unique-list SKIP
            "Index Matches:  " index-list SKIP
            "Field Matches:  " field-list
            VIEW-AS ALERT-BOX BUTTONS OK-CANCEL 
                    TITLE SDBNAME(1) UPDATE ans . 
    IF NOT ans THEN LEAVE.
  END.

----------------------------------------------------------------------------*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Procedure
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 2
         WIDTH              = 40.
                                                                        */
&ANALYZE-RESUME
 



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


DEFINE INPUT  PARAMETER p_table       AS CHAR NO-UNDO.
DEFINE OUTPUT PARAMETER p_unique-list AS CHAR NO-UNDO.
DEFINE OUTPUT PARAMETER p_index-list  AS CHAR NO-UNDO.
DEFINE OUTPUT PARAMETER p_field-list  AS CHAR NO-UNDO.

DEFINE VAR db-name  AS CHAR NO-UNDO.
DEFINE VAR tbl-name AS CHAR NO-UNDO.

/* Get the best guess. */
RUN key-guess.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE add-item Procedure 
PROCEDURE add-item :
/*------------------------------------------------------------------------------
  Purpose:     Adds p_item into p_list (if it is not there already).   
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER        p_item AS CHAR NO-UNDO.
  DEFINE INPUT-OUTPUT PARAMETER p_list AS CHAR NO-UNDO.
  
  /* Add the item to the list (checking for duplicate entries). */
  IF LOOKUP (p_item, p_list) eq 0 THEN DO:
    IF p_list eq "":U THEN p_list = p_item.
    ELSE p_list = p_list + ',':U + p_item.
  END.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE key-guess Procedure 
PROCEDURE key-guess :
/*------------------------------------------------------------------------------
  Purpose:     Create the guesses about keys. This is called seperately to
               allow the main code block to use the QBF$1 alias.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE BUFFER xFIELD       FOR QBF$1._FIELD.
  DEFINE BUFFER xFILE        FOR QBF$1._FILE.
  DEFINE BUFFER xINDEX       FOR QBF$1._INDEX.
  DEFINE BUFFER xINDEX-FIELD FOR QBF$1._INDEX-FIELD.

  DEFINE VAR db-name  AS CHAR NO-UNDO.
  DEFINE VAR tbl-name AS CHAR NO-UNDO.

  /* Parse the p_table (eg. sports.customer) into its db and table name. */
  ASSIGN db-name = ENTRY(1, p_table, ".":U)
         tbl-name = ENTRY (2, p_table, ".":U)
         .
   
  /* Get the correct _DB and _FILE. */
  IF DBTYPE(db-name) eq "PROGRESS":U
  THEN FIND FIRST QBF$1._DB WHERE QBF$1._DB._DB-NAME eq ? NO-LOCK NO-ERROR.
  ELSE FIND FIRST QBF$1._DB WHERE QBF$1._DB._DB-NAME eq db-name NO-LOCK NO-ERROR.
  
  IF AVAILABLE (QBF$1._DB) THEN DO:
    IF INTEGER(DBVERSION("DICTDB":U)) > 8 THEN   
      FIND xFILE OF QBF$1._DB WHERE LOOKUP(xFILE._OWNER,"PUB,_FOREIGN":U) > 0 AND
                                      xFILE._FILE-NAME = tbl-name NO-ERROR.
    ELSE
      FIND xFILE OF QBF$1._DB WHERE xFILE._FILE-NAME = tbl-name NO-ERROR.
  END.
 
  /* IF the db.tbl does not exist in this database, just return. */
  IF NOT AVAILABLE (xFILE) THEN RETURN.
  ELSE DO:
    /* Look for all the indexes in all the files. */
    FOR EACH QBF$1._FILE OF QBF$1._DB,
        EACH QBF$1._INDEX OF QBF$1._FILE WHERE QBF$1._INDEX._UNIQUE AND NOT QBF$1._INDEX._INDEX-NAME BEGINS "_":U:
      /* Look for a unique field in the index. */
      FIND QBF$1._INDEX-FIELD OF QBF$1._INDEX NO-ERROR.
      IF AVAILABLE (QBF$1._INDEX-FIELD) THEN DO:
        FIND QBF$1._FIELD OF QBF$1._INDEX-FIELD.  
    
        /* Is this an index in the xFILE? */
        FIND xFIELD OF xFILE WHERE xFIELD._FIELD-NAME eq QBF$1._FIELD._FIELD-NAME 
                               AND xFIELD._DATA-TYPE  eq QBF$1._FIELD._DATA-TYPE 
                             NO-ERROR.
        IF AVAILABLE (xFIELD) THEN DO: 
          RUN add-item (QBF$1._FIELD._FIELD-NAME, INPUT-OUTPUT p_field-list).
          /* Is there an INDEX-FIELD that uses this FIELD as its first element? 
             If so, treat the field as a valid index field for FOREIGN KEYS. */
          FIND xINDEX-FIELD WHERE xINDEX-FIELD._FIELD-recid eq RECID(xFIELD) 
                              AND xINDEX-FIELD._INDEX-SEQ eq 1 
                            NO-ERROR.  
          IF AVAILABLE (xINDEX-FIELD) THEN DO:
            RUN add-item (QBF$1._FIELD._FIELD-NAME, INPUT-OUTPUT p_index-list). 
            /* Is this index field the ONLY field in a UNIQUE index? If so,
               it is unique. NOTE that even if the index is UNIQUE, if there
               are other elements in the index, then we don't add it to the
               unique list. */   
            FIND xINDEX WHERE xINDEX-FIELD._INDEX-recid eq RECID(xINDEX) 
                          AND xINDEX._UNIQUE NO-ERROR.
            IF AVAILABLE (xINDEX) AND
               NOT CAN-FIND (_INDEX-FIELD WHERE _INDEX-FIELD._INDEX-RECID eq RECID(xINDEX)
                                            AND _INDEX-FIELD._INDEX-SEQ > 1)
            THEN RUN add-item (QBF$1._FIELD._FIELD-NAME, INPUT-OUTPUT p_unique-list).   
          END. /* IF AVAILAVBLE (xINDEX-FIELD) ... */
        END. /* IF AVAILABLE (xFIELD) ... */
      END. /* IF AVAILABLE (_INDEX-FIELD) ... */
    END. /* FOR EACH _INDEX ... */
  END. /* IF...AVAILABLE (xFILE)... */
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


