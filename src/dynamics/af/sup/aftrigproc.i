&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Check Version Notes Wizard" Include _INLINE
/* Actions: af/cod/aftemwizcw.w ? ? ? ? */
/* ICF Update Version Notes Wizard
Check object version notes.
af/cod/aftemwizpw.w
*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Update-Object-Version" Include _INLINE
/* Actions: ? ? ? ? af/sup/afverxftrp.p */
/* This has to go above the definitions sections, as that is what it modifies.
   If its not, then the definitions section will have been saved before the
   XFTR code kicks in and changes it */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Definition Comments Wizard" Include _INLINE
/* Actions: ? af/cod/aftemwizcw.w ? ? ? */
/* Program Definition Comment Block Wizard
Welcome to the Program Definition Comment Block Wizard. Press Next to proceed.
af/cod/aftemwizpw.w
*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Include 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*---------------------------------------------------------------------------------
  File: aftrigproc.i

  Description:  Trigger procedures include file

  Purpose:      Standard trigger procedures included in aftrigendc.i, aftrigendd.i, aftrigendw.i

  Parameters:

  History:
  --------
  (v:010000)    Task:          29   UserRef:    
                Date:   18/12/1997  Author:     Anthony Swindells

  Update Notes: Move osm- modules to af- modules

  (v:010106)    Task:    90000034   UserRef:    
                Date:   26/03/2001  Author:     Anthony Swindells

  Update Notes: fix triggers not to use Astra 1 code

---------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       aftrigproc.i
&scop object-version    000000

{af/sup/afproducts.i} /* Installed products include */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getNextObj Include 
FUNCTION getNextObj RETURNS DECIMAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getString Include 
FUNCTION getString RETURNS CHARACTER
  ( INPUT ip_text  AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Include
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: INCLUDE-ONLY
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Include ASSIGN
         HEIGHT             = 15.05
         WIDTH              = 43.2.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE clear-return-value Include 
PROCEDURE clear-return-value :
/*------------------------------------------------------------------------------
  Purpose:     To clear the RETURN-VALUE
  Parameters:  <none>
  Notes:       This procedure is used when validation is performed to ensure that
               prior to the validation there is nothing in the RETURN-VALUE. The 
               ADM uses the RETURN-VALUE a lot for error handling so it is 
               important to ensure that the RETURN-VALUE you are testing for is
               yours.
               See the include files used for validation in triggers afvalidtrg.i and viewers
               afvalidvew.i to see example usage of this procedure.       
------------------------------------------------------------------------------*/

RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE error-message Include 
PROCEDURE error-message :
/*------------------------------------------------------------------------------
  Purpose:     Standard trigger error message handler    
  Parameters:  INPUT message number
               INPUT message insertion text (pipe | delimited)
  Notes: Error messages are returned to the caller in the RETURN-VALUE and the
         ERROR-STATUS is raised. The program name the error occurred in is also
         returned in the RETURN-VALUE as the third entry delimited by a "^" so
         that the message display can report where the error came from.
         In addition, an optional fourth entry is added to pass in a pipe delimited
         list of insertion texts to insert into the standard error message, e.g. to
         display the customer name, etc. The error message text must contain ampersand
         (e.g &1 &2) insertion hooks where the text is to be inserted.
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER ip_error_group   AS CHARACTER                NO-UNDO.
DEFINE INPUT PARAMETER ip_error_number  AS INTEGER                  NO-UNDO.
DEFINE INPUT PARAMETER ip_insert        AS CHARACTER                NO-UNDO.

DO ON ERROR UNDO, RETURN ERROR:
    DEFINE VARIABLE lv_program_name AS CHARACTER FORMAT "X(60)":U NO-UNDO.
    RUN get-program-name (OUTPUT lv_program_name).
    RETURN ERROR ip_error_group + "^":U + STRING(ip_error_number) + "^":U + LC(TRIM(lv_program_name)) + "^":U + ip_insert.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE get-program-name Include 
PROCEDURE get-program-name :
/*------------------------------------------------------------------------------
  Purpose:     To return the program name of the calling program the error has occurred in
  Parameters:  OUTPUT program name
  Notes:       This is used by error-message to append the program name to the 
               message to facilitate the displaying of where the error occurred
               in the title of the alert-box.
------------------------------------------------------------------------------*/

DEFINE OUTPUT PARAMETER op_program AS CHARACTER NO-UNDO.

DEFINE VARIABLE lv_program_loop AS INTEGER NO-UNDO.
ASSIGN lv_program_loop = 2 /* Ignore 1 which is a temporary file */
       op_program = PROGRAM-NAME(lv_program_loop).

/*/* Find the originating calling routine */
 * DO WHILE LENGTH(op_program) > 10:
 *     ASSIGN lv_program_loop = lv_program_loop + 1
 *            op_program = PROGRAM-NAME(lv_program_loop).
 * 
 * END.*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE get-trigger-procedure Include 
PROCEDURE get-trigger-procedure :
/*------------------------------------------------------------------------------
  Purpose:     To return the trigger name plus the procedure that called the trigger
  Parameters:  op_trigger_name
               op_procedure_name
  Notes:       
------------------------------------------------------------------------------*/

DEFINE OUTPUT PARAMETER op_trigger_name     AS CHARACTER    NO-UNDO.
DEFINE OUTPUT PARAMETER op_procedure_name   AS CHARACTER    NO-UNDO.

DEFINE VARIABLE lv_program_loop             AS INTEGER      NO-UNDO.

ASSIGN lv_program_loop = 2 /* Ignore 1 which is a temporary file */
       op_trigger_name = PROGRAM-NAME(lv_program_loop).

ASSIGN lv_program_loop = 3. 

/* Find the originating calling routine */
DO WHILE LENGTH(op_procedure_name) = 0 AND lv_program_loop < 5:
    IF NUM-ENTRIES(PROGRAM-NAME(lv_program_loop), " ":U) > 1 THEN
        ASSIGN op_procedure_name = ENTRY(2, PROGRAM-NAME(lv_program_loop), " ":U).
    ELSE
        ASSIGN op_procedure_name = PROGRAM-NAME(lv_program_loop).
    ASSIGN lv_program_loop = lv_program_loop + 1.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getNextObj Include 
FUNCTION getNextObj RETURNS DECIMAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  To return the next available unique object number - used in create
            triggers.
    Notes:  
------------------------------------------------------------------------------*/

    DEFINE VARIABLE dSeqNext    AS DECIMAL  NO-UNDO.

    DEFINE VARIABLE iSeqObj1    AS INTEGER  NO-UNDO.
    DEFINE VARIABLE iSeqObj2    AS INTEGER  NO-UNDO.

    DEFINE VARIABLE iSeqSiteDiv AS INTEGER  NO-UNDO.
    DEFINE VARIABLE iSeqSiteRev AS INTEGER  NO-UNDO.
    
    DEFINE VARIABLE iSessnId    AS INTEGER  NO-UNDO.

    /* use external procedure to avoid rvdb from having to be there at all
       when not required 
    */
    IF CONNECTED("RVDB") THEN
      RUN rv/app/rvgetnobjp.p (INPUT YES,           /* increment */
                               OUTPUT iSeqObj1,
                               OUTPUT iSeqObj2,
                               OUTPUT iSeqSiteDiv,
                               OUTPUT iSeqSiteRev,
                               OUTPUT iSessnId).
    ELSE 
      RUN ry/app/rygetnobjp.p (INPUT YES,           /* increment */
                               OUTPUT iSeqObj1,
                               OUTPUT iSeqObj2,
                               OUTPUT iSeqSiteDiv,
                               OUTPUT iSeqSiteRev,
                               OUTPUT iSessnId).
    
    ASSIGN
        dSeqNext = DECIMAL((iSeqObj2 * 1000000000.0) + iSeqObj1)
        .

    IF  iSeqSiteDiv <> 0
    AND iSeqSiteRev <> 0
    THEN
        ASSIGN
            dSeqNext = dSeqNext + (iSeqSiteRev / iSeqSiteDiv).

    RETURN dSeqNext. /* Function return value */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getString Include 
FUNCTION getString RETURNS CHARACTER
  ( INPUT ip_text  AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose: Return the string of the passed in text, or blank if the passed in text
           is null (?).
    Notes: This is to avoid the problem of adding null values to a string causing the
           entire string to be null.
------------------------------------------------------------------------------*/

IF ip_text = ? THEN
  RETURN "":U.
ELSE
  RETURN ip_text.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

