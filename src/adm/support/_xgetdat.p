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

File: _xgetdat.p

Description:
    Gets "structured", or "tagged" data from an XFTR Section. This procedure:
      1) gets the contents of  XFTR code section (with name 'p_xftr-name') 
         from the indicated procedure
      2) searches this section for code between
         <p_tag-name> and </p_tag-name>. 
      3) This string is TRIMMED and returned as p_data.
    -------------------------------------------------------------------     
    This routine calls adm/support/_tagdat.p.  Look at this routine for
    a complete description of behavior.
    -------------------------------------------------------------------     

Notes:
  * If the XFTR is not found, or if <p_tag-name> is not found then the
    returned p_data will be "".
    
  * If the closing token, </p_tag-name> is not found then a run-time
    error will be given, and the procedure will return ERROR.
   
Input Parameters:
    p_context-id - (INTEGER) Context ID of the current procedure
    p_xftr-name  - (CHAR) Name of the XFTR
    p_tab-name   - (CHAR) Name of data to return [i.e. the first token
                    in the lines returned must equal this parameter.
    
Output Parameters:
    p_data       - (CHAR) List of data in lines that match the p_tab-name
 
Author: Wm.T.Wood
Created: March, 1996

Modified: <not yet>
----------------------------------------------------------------------------*/

DEFINE INPUT  PARAMETER p_context-id AS INTEGER NO-UNDO.
DEFINE INPUT  PARAMETER p_xftr-name  AS CHAR    NO-UNDO.
DEFINE INPUT  PARAMETER p_tag-name   AS CHAR    NO-UNDO.
DEFINE OUTPUT PARAMETER p_data       AS CHAR    NO-UNDO.

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


DEFINE VAR code    AS CHAR    NO-UNDO.
DEFINE VAR id_code AS INTEGER NO-UNDO INITIAL ?. 
DEFINE VAR iend    AS INTEGER NO-UNDO.
DEFINE VAR istart  AS INTEGER NO-UNDO.
DEFINE VAR token   AS CHAR    NO-UNDO.

/* Get the code for the desired XFTR section. */
RUN adeuib/_accsect.p 
      ('GET':U, p_context-id,'XFTR:':U + p_xftr-name,
       INPUT-OUTPUT id_code,
       INPUT-OUTPUT code).
IF code ne ? THEN DO:
  RUN adm/support/_tagdat.p ("GET":U, p_tag-name, 
                              INPUT-OUTPUT p_data, 
                              INPUT-OUTPUT code).
END. /* code ne ? */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


