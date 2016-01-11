&ANALYZE-SUSPEND _VERSION-NUMBER WDT_v2r1 Workshop-Object
&ANALYZE-RESUME
&ANALYZE-SUSPEND _CODE-BLOCK _CUSTOM Definitions 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*------------------------------------------------------------------------

  File: _errproc.w

  Description: This web object holds errors for the Workshop created by 
               different programs. The user can run procedures or functions.
                  add errors
                  output errors to the WEBSTREAM
                  clear errors

               To use the functions in this procedure, you should include
               workshop/errors.i.
  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: Wm.T.Wood

  Created: Jan.30, 1997

------------------------------------------------------------------------*/
/*           This .W file was created with WebSpeed Workshop.           */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Temp-Table to store errors ---                                       */
DEFINE TEMP-TABLE tt
  FIELD number  AS INTEGER
  FIELD type    AS CHAR
  FIELD msg     AS CHAR
  .
&ANALYZE-RESUME
&ANALYZE-SUSPEND _PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Workshop-Object


&ANALYZE-RESUME


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

&ANALYZE-SUSPEND _INCLUDED-LIBRARIES
/* ************************* Included-Libraries *********************** */

{src/web/method/wrap-cgi.i}
&ANALYZE-RESUME _END-INCLUDED-LIBRARIES

&ANALYZE-SUSPEND _CODE-BLOCK _CUSTOM "Main Code Block" 


/* ************************  Main Code Block  *********************** */

/* This procedure does nothing except run itself persistently. */
RUN set-attribute-list IN THIS-PROCEDURE ("Web-State=persistent":U).

/* ******************************  Functions ************************ */

&IF "{&WINDOW-SYSTEM}" ne "MS-WINDOWS" &THEN /* Allow compiling in 1mars */

/* Return TRUE if any errors exist. */
FUNCTION errors-exist RETURNS LOGICAL (p_types AS CHAR) :
  RETURN CAN-FIND (FIRST tt WHERE (p_types eq "ALL":U OR LOOKUP(tt.type, p_types) > 0)).
END FUNCTION.

&ENDIF
&ANALYZE-RESUME
/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _CODE-BLOCK _PROCEDURE Add-Error 
PROCEDURE Add-Error :
/*------------------------------------------------------------------------------
  Purpose:     Add an error to the temp-table
  Parameters:  p_type   -- type of error ("WARNING", "ERROR", etc)
               p_number -- number (or ?)
               p_msg    -- text
              
  Notes:       
------------------------------------------------------------------------------*/
  def input parameter p_type as char    no-undo.
  def input parameter p_number as integer no-undo.
  def input parameter p_msg as char    no-undo.
  
  /* Create a new record. */
  CREATE tt.
  ASSIGN tt.number = p_number
         tt.type   = p_type
         tt.msg    = p_msg
         .
END PROCEDURE.
&ANALYZE-RESUME
&ANALYZE-SUSPEND _CODE-BLOCK _PROCEDURE Clear-Errors 
PROCEDURE Clear-Errors :
/*------------------------------------------------------------------------------
  Purpose:     Initializes the temp-table by deleting all errors.
  Parameters:  p_type: type to output (or "ALL").
  Notes:       
------------------------------------------------------------------------------*/
  def input parameter p_type    as char    no-undo.

  FOR EACH tt WHERE (p_type eq "ALL":U) OR (p_type eq tt.type) :
    DELETE tt.
  END.

END PROCEDURE.
&ANALYZE-RESUME
&ANALYZE-SUSPEND _CODE-BLOCK _PROCEDURE Output-Errors 
PROCEDURE Output-Errors :
/*------------------------------------------------------------------------------
  Purpose:     Outputs all the errors
  Parameters:  p_types -- types to output (or "ALL")
               p_template -- the error is substituted into this message
                 &1 is the text of the message
                 &2 is the message # in parenthese, plus a space eg. " (102)"
                 &3 is the type
               If no template is provided, then a default template of:
                 "<li>&1&2</li>~n" 
               is used.
               
               
  Notes: Messages are deleted after they are output.     
------------------------------------------------------------------------------*/
  def input parameter p_types    as char    no-undo.
  def input parameter p_template as char    no-undo.
  
  def var c_number as char no-undo.
  
  /* Is the default template needed? */
  IF p_template eq "":U OR p_template eq ?
  THEN p_template = "<li>~&1~&2</li>~n".
  
  /* Output and delete the message. */
  FOR EACH tt WHERE (p_types eq "ALL":U OR LOOKUP(tt.type, p_types) > 0):
    /* Output the message. */
    IF tt.number eq ? THEN c_number = "":U.
    ELSE c_number = " (":U + TRIM(STRING(tt.number)) + ")":U.
    {&OUT} SUBSTITUTE (p_template, tt.msg, c_number, tt.type).
    /* Delete the message record. */
    DELETE tt.
  END.
END PROCEDURE.
&ANALYZE-RESUME
 

