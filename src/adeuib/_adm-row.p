&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r2
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation ("PSC"),       *
* 14 Oak Park, Bedford, MA 01730, and other contributors as listed   *
* below.  All Rights Reserved.                                       *
*                                                                    *
* The Initial Developer of the Original Code is PSC.  The Original   *
* Code is Progress IDE code released to open source December 1, 2000.*
*                                                                    *
* The contents of this file are subject to the Possenet Public       *
* License Version 1.0 (the "License"); you may not use this file     *
* except in compliance with the License.  A copy of the License is   *
* available as of the date of this notice at                         *
* http://www.possenet.org/license.html                               *
*                                                                    *
* Software distributed under the License is distributed on an "AS IS"*
* basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. You*
* should refer to the License for the specific language governing    *
* rights and limitations under the License.                          *
*                                                                    *
* Contributors:                                                      *
*                                                                    *
*********************************************************************/
/*----------------------------------------------------------------------------

File: _adm-row.p

Description:
    Generate the code needed in an adm-row-available procedure.
    
Input Parameters:
    p_context-id - (INTEGER) Context ID of the current procedure
    
Output Parameters:
    p_Code - (CHAR) code to return. (Including "END PROCEDURE." ). 
    
NOTES: In ADM V1.0 (v8.0a), the row-head.i and row-end.i were only included
       if there were ANY external tables. In v8.1, these need to be included
       regardless to handle foriegn KEYS in the record-source. 
 
Author: Wm.T.Wood

Date Created: March, 1996

Modified: <none>
----------------------------------------------------------------------------*/

DEFINE INPUT  PARAMETER  p_context-id AS INTEGER    NO-UNDO.
DEFINE OUTPUT PARAMETER  p_code       AS CHAR       NO-UNDO.
{adeuib/uniwidg.i}           /* Definition of Universal Widget TEMP-TABLE    */
{adeuib/sharvars.i}          /* Standard Shared Variables. */

/* FUNCTION PROTOTYPE */
FUNCTION db-tbl-name RETURNS CHARACTER
  (INPUT db-tbl AS CHARACTER) IN _h_func_lib.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure



/* _UIB-PREPROCESSOR-BLOCK-END */
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
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


DEFINE VAR  i           AS INTEGER    NO-UNDO.
DEFINE VAR  cnt         AS INTEGER    NO-UNDO.
DEFINE VAR  db_tbl      AS CHARACTER  NO-UNDO.

&Scoped-define COMMENT-LINE ------------------------------------------------------------------------------

/* Standard End-of-line character - adjusted in 7.3A to be just chr(10) */
&Scoped-define EOL CHR(10)

/* Get the current procedure. */
FIND _P WHERE RECID(_P) eq p_context-id. 

p_code =   
"/*{&COMMENT-LINE}" + {&EOL} +
"  Purpose:     Dispatched to this procedure when the Record-" + {&EOL} +
"               Source has a new row available.  This procedure" + {&EOL} + 
"               tries to get the new row (or foriegn keys) from" + {&EOL} +
"               the Record-Source and process it." + {&EOL} + 
"  Parameters:  <none>" + {&EOL} + 
"{&COMMENT-LINE}*/" + {&EOL} + {&EOL} +
"  /* Define variables needed by this internal procedure.             */" + {&EOL} +            
"  ~{src/adm/template/row-head.i}" + {&EOL}.

cnt = NUM-ENTRIES (_P._xTblList).
IF cnt > 0 THEN DO:
  p_code = p_code + {&EOL} +
  "  /* Create a list of all the tables that we need to get.            */" +
  {&EOL}
  . 

  DO i = 1 TO cnt:
    ASSIGN db_tbl = db-tbl-name(ENTRY(i,_P._xTblList))
           p_code = p_code +
                    "  ~{src/adm/template/row-list.i """ + db_tbl + """}" +
                    {&EOL} .
  END.

  p_code = p_code + {&EOL} +
  "  /* Get the record ROWID's from the RECORD-SOURCE.                  */" + {&EOL} +            
  "  ~{src/adm/template/row-get.i}"  +  {&EOL} +
  {&EOL} +
  "  /* FIND each record specified by the RECORD-SOURCE.                */" + {&EOL}          
  . 
  
  DO i = 1 TO cnt:
    ASSIGN db_tbl = db-tbl-name(ENTRY(i,_P._xTblList))
           p_code = p_code +
                    "  ~{src/adm/template/row-find.i """ + db_tbl + """}" +
                    {&EOL} .
  END.  
  
END. /* IF cnt > 0... */
  
p_code = p_code  + {&EOL} +
"  /* Process the newly available records (i.e. display fields," + {&EOL} + 
"     open queries, and/or pass records on to any RECORD-TARGETS).    */" + {&EOL} +            
"  ~{src/adm/template/row-end.i}" + {&EOL} + {&EOL}. 

/* Close the procedure. */
p_code = p_code +  "END PROCEDURE.".

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


