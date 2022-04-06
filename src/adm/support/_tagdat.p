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

File: _tagdat.p

Description:
    Gets "tagged", or "structured" data from an string. This procedure:
      1) searches this input string for code between
         <p_tag-name> and </p_tag-name>. 
      2) The value of p_mode is checked:
           if "GET" then this string is trimmed and returned as p_data
           if "SET" then this substring is replaced by the contents of p_data.

Notes:
  * If the <p_tag-name> is not found then "GET" will set p_data to "".

  * If the <p_tag-name> is not found on a "SET", then the tag is added
    on the line after the word "STRUCTURED-DATA", if found.  
    If the value of STRUCTURED-DATA is not found, then we add the following
    at the beginning of p_string:
      /* STRUCTURED-DATA
      <p_tag-name>
      p_data
      </p_tag-name> */
      
  * If the closing token, </p_tag-nam> is not found then a run-time
    error will be given, and the procedure will return ERROR.
   
Input Parameters:
    p_mode      - (CHAR) "GET" or "SET"
    p_tag-name  - (CHAR) Name of data to return [i.e. the first token
                    in the lines returned must equal this parameter.
    
Input-Output Parameters:
    p_data      - (CHAR) Data string found or set in the p_string. This is
                  TRIMMED before setting.
    p_string    - (CHAR) Input, or output string
 
Author: Wm.T.Wood
Created: March, 1996

Modified: <not yet>
----------------------------------------------------------------------------*/

DEFINE INPUT        PARAMETER p_mode      AS CHAR NO-UNDO.
DEFINE INPUT        PARAMETER p_tag-name  AS CHAR NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER p_data      AS CHAR NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER p_string    AS CHAR NO-UNDO.

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
DEFINE VAR data    AS CHAR    NO-UNDO.
DEFINE VAR iend    AS INTEGER NO-UNDO.
DEFINE VAR ilength AS INTEGER NO-UNDO.
DEFINE VAR istart  AS INTEGER NO-UNDO.
DEFINE VAR token   AS CHAR    NO-UNDO.

/* Copy input-output parameters into local variables as a safety check that
   prevents us from inadvertently changing a value that will be returned. */
ASSIGN code    = p_string     WHEN p_string ne ?  /* Handle degenerate cases */
       data    = TRIM(p_data) WHEN p_data ne ?    /* Handle degenerate cases */
       .
       
/* Look for the starting token of the output string. */
ASSIGN token   = "<":U + p_tag-name + ">":U
       istart  = INDEX(code, token)
       ilength = 0
       .
IF istart > 0 THEN DO:
  /* Start of section found (skip past the token, and look for the end
     of section. */
  istart = istart + LENGTH(token,"CHARACTER":U).
  IF istart <= LENGTH(code, "CHARACTER":U) THEN DO:
    /* Look for the starting token of the output string. */
    ASSIGN token   = "</":U + p_tag-name + ">":U
           iend    = INDEX(code, token)
           ilength =  iend - istart.
    /* If the closing token is not found, then that is an error. */
    IF iend eq 0 THEN DO:
      IF p_mode eq "GET" THEN p_data = "".
      RETURN "Error". 
    END.
  END. /* istart <= LENGTH(...) */
END. /* istart > 0 */

/* Either return the desired data, or set it. */
CASE p_mode:
  WHEN "GET":U THEN DO:
    /* Return all the code between the start and end token, or return "" if
       no tag was found. */
    p_data = IF ilength eq 0 THEN ""
             ELSE TRIM (SUBSTRING(code, istart, ilength, "CHARACTER":U)).
  END.
  WHEN "SET":U THEN DO:
    /* Put the data on its own line in the output string. */
    IF data ne "" THEN data = CHR(10) + TRIM(data) + CHR(10).   
    /* Replace the tagged area in the code, and return it. */
    IF istart > 0 
    THEN SUBSTRING(code, istart, ilength, "CHARACTER":U) = data.
    ELSE DO:
      /* Create a structured tag around the data. */
      data = CHR(10) + SUBSTITUTE ("<&1>&2</&1>":U, p_tag-name, data).
      /* The token string was not found in the string. So add it. */
      istart = INDEX (code, "STRUCTURED-DATA":U).
      IF istart > 0 
      THEN SUBSTRING(code, istart + LENGTH("STRUCTURED-DATA", "CHARACTER":U), 0, 
                     "CHARACTER":U) = data.
      ELSE code = "/* STRUCTURED-DATA " + data + " */" + CHR(10) + code.
    END.
    /* Return the new code. */
    p_string = code.
  END.
  OTHERWISE DO:
    MESSAGE "ADM Support Code Error [in call to '{&FILE-NAME}']:" SKIP 
            "Invalid mode :" p_mode SKIP (1)
            "Valid modes are GET and SET."         
            VIEW-AS ALERT-BOX ERROR.
    RETURN "Error". 
  END.
END CASE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


