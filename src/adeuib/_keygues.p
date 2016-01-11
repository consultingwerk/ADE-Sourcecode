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

File: _keygues.p

Description:
   Uses adeuib/_keygus2.p to find the likely foreign keys in the
   rest of the database.  See that file for a description of the values
   returned.
   
   This file is a wrapper for adeuib/_keygus2.p, that sets the ALIASES needed
   for that routine.
    
Parameters Buffers:
    p_table  - The name of the table (including database name) eg. sports.item
    
Output Parameters:
    p_unique-list -- the list of foreign keys that are UNIQUE indices in p_FILE
    p_index-list  -- the list of foreign keys that are indices in p_FILE
    p_field-list  -- the list of foreign keys that are fields in p_FILE
    
Author: Wm.T.Wood

Date Created: May 1996

Modified: <none>
----------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER p_table       AS CHAR NO-UNDO.
DEFINE OUTPUT PARAMETER p_unique-list AS CHAR NO-UNDO.
DEFINE OUTPUT PARAMETER p_index-list  AS CHAR NO-UNDO.
DEFINE OUTPUT PARAMETER p_field-list  AS CHAR NO-UNDO.

DEFINE VAR db-name  AS CHAR NO-UNDO.
DEFINE VAR tbl-name AS CHAR NO-UNDO.

/* **********************  Database/Alias Check *********************** */

/* Make sure we have the correct alias. (I am using the "QBF$1" alias that
   would be used in adecomm/_j-test.p.) The alias must be correctly set before
   the call to this program, so this section checks the alias and recursively
   calls itself if there is a problem. */
ASSIGN db-name = ENTRY(1, p_table, ".":U)
       tbl-name = ENTRY (2, p_table, ".":U)
       .
IF LDBNAME("QBF$1":U) ne SDBNAME(db-name) THEN DO:
  CREATE ALIAS "QBF$1":U FOR DATABASE VALUE(SDBNAME(db-name)).
  RUN VALUE(THIS-PROCEDURE:FILE-NAME) 
        (INPUT p_table,
         OUTPUT p_unique-list, OUTPUT p_index-list, OUTPUT p_field-list).
END.

/* Get the best guess. */
RUN adeuib/_keygus2.p (INPUT p_table,
                       OUTPUT p_unique-list,
                       OUTPUT p_index-list,
                       OUTPUT p_field-list).

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


/* All Code is in Definition Section */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


