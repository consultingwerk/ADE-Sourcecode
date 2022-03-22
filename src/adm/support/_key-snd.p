&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r11
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*----------------------------------------------------------------------------

File: _key-snd.p

Description:
    Generate the code needed in an send-key procedure.
    
Input Parameters:
    p_context-id - (INTEGER) Context ID of the current procedure
    
Output Parameters:
    p_Code - (CHAR) code to return. (Including "END PROCEDURE." ). 
 
Author: Wm.T.Wood
Created: March, 1996

Modified: <not yet>
----------------------------------------------------------------------------*/

DEFINE INPUT  PARAMETER  p_context-id AS INTEGER    NO-UNDO.
DEFINE OUTPUT PARAMETER  p_code       AS CHAR       NO-UNDO.

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


/* ***************************** Local Definitions ***************************** */

DEFINE VAR  ch          AS CHAR       NO-UNDO.
DEFINE VAR  cnt         AS INTEGER    NO-UNDO.
DEFINE VAR  db-tbl      AS CHARACTER  NO-UNDO.
DEFINE VAR  db-tbl-fld  AS CHARACTER  NO-UNDO.
DEFINE VAR  fld         AS CHARACTER  NO-UNDO.
DEFINE VAR  i           AS INTEGER    NO-UNDO.
DEFINE VAR  ipos        AS INTEGER    NO-UNDO.
DEFINE VAR  key         AS CHARACTER  NO-UNDO.
DEFINE VAR  key-list    AS CHARACTER  NO-UNDO.
DEFINE VAR  key-name    AS CHARACTER  NO-UNDO.
DEFINE VAR  l_found-one AS LOGICAL    NO-UNDO.
DEFINE VAR  proc-id     AS INTEGER    NO-UNDO.

&Scoped-define COMMENT-LINE ------------------------------------------------------------------------------

/* Standard End-of-line character - adjusted in 7.3A to be just chr(10) */
&Scoped-define EOL CHR(10)

/* ******************************** Main Code ********************************** */

/* Get the context of the current procedure. */
RUN adeuib/_uibinfo.p (INPUT p_context-id, ?, "PROCEDURE", OUTPUT ch).
proc-id = INTEGER (ch).

p_code =   
"/*{&COMMENT-LINE}" + {&EOL} +
"  Purpose:     Sends a requested KEY value back to the calling" + {&EOL} +
"               SmartObject." + {&EOL} + 
"  Parameters:  <see adm/template/sndkytop.i>" + {&EOL} + 
"{&COMMENT-LINE}*/".

/* Get the SUPPLIED-KEYS from the "Foreign Keys" XFTR section. This should be
   a list of the form:
     key-name|y|y|db.table.field
     key-name||y|db.table.field
   Supplied keys are ones with a "y" as the third entry.
 */
RUN adm/support/_xgetdat.p (p_context-id, 'Foreign Keys':U, 'FOREIGN-KEYS':U,
                            OUTPUT key-list).
cnt = NUM-ENTRIES (key-list, CHR(10)).
FOUND-ONE:
DO i = 1 to cnt:
  IF ENTRY(3, ENTRY(i, key-list, CHR(10)), "|":U) eq "y":U THEN DO:
    l_found-one = yes.
    LEAVE FOUND-ONE.
  END.
END.
IF NOT l_found-one THEN DO:  
  p_code = p_code + {&EOL} + {&EOL} +
  "  /* There are no foreign keys supplied by this SmartObject. */" .
END.
ELSE DO:
  p_code = p_code + {&EOL} + {&EOL} +
  "  /* Define variables needed by this internal procedure.             */" + {&EOL} +            
  "  ~{src/adm/template/sndkytop.i}" + {&EOL} + 
  {&EOL} +
  "  /* Return the key value associated with each key case.             */" 
  . 

  /* The "key-list" is of the form "key-name|y|y|db.tbl.fld". Parse this. */
  DO i = 1 TO cnt:
    key = TRIM(ENTRY(i, key-list, CHR(10))).
   /* Is this an SUPPLIED key? */
    IF ENTRY(3, key, '|':U) eq "y":U THEN DO:
      ASSIGN key-name   = TRIM(ENTRY(1, key, '|':U))
             db-tbl-fld = TRIM(ENTRY(4, key, '|':U))
             .
      /* Parse the db-tbl-fld into its basic components. */
      ASSIGN ipos     = R-INDEX(db-tbl-fld, '.':U)
             db-tbl   = SUBSTRING(db-tbl-fld, 1, ipos - 1,  "CHARACTER":U)
             fld      = SUBSTRING(db-tbl-fld, ipos + 1, -1, "CHARACTER":U)
             .
      /* The user may have wanted to suppress the db name in the UIB. Ask the
         UIB to set up the database/table name. */
      RUN adeuib/_dbtbnam.p (proc-id, db-tbl, OUTPUT db-tbl).
   
      p_code = p_code + {&EOL} + 
               SUBSTITUTE ('  ~{src/adm/template/sndkycas.i "&1" "&2" "&3"}':U, 
                           key-name, db-tbl, fld) .
    END. /* IF...y... */
  END.
  p_code = p_code + {&EOL} + {&EOL} + 
  "  /* Close the CASE statement and end the procedure.                 */" + {&EOL} +            
  "  ~{src/adm/template/sndkyend.i}".
END.
/* Close the Procedure. */
p_code = p_code + {&EOL} + {&EOL} + "END PROCEDURE.".

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


