&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Check Version Notes Wizard" Include _INLINE
/* Actions: af/cod/aftemwizcw.w ? ? ? ? */
/* MIP Update Version Notes Wizard
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
  File: ryplipmain.i

  Description:  Main block of PLIP procedures

  Purpose:      Standard include for main block of Astra 2 PLIP procedures

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:        6065   UserRef:    
                Date:   20/06/2000  Author:     Anthony Swindells

  Update Notes: Created from Template afteminclu.i

  (v:010001)    Task:        7205   UserRef:    
                Date:   20/12/2000  Author:     Peter Judge

  Update Notes: MOD/ Add function "getInternalEntries". This function will return the internal
                entries of a procedure. This is needed because the internal-entries attribute is
                not readable over an AppServer boundary.

-----------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

PROCEDURE getObjectVersion :
/*------------------------------------------------------------------------------
  Purpose:     To return the current object name and version for this object
  Parameters:  OUTPUT object name
               OUTPUT object version
  Notes:       
------------------------------------------------------------------------------*/
DEFINE OUTPUT PARAMETER pcObjectName      AS CHARACTER INITIAL "":U NO-UNDO.
DEFINE OUTPUT PARAMETER pcObjectVersion   AS INTEGER INITIAL 0 NO-UNDO.

&IF DEFINED (object-name) <> 0 &THEN
    ASSIGN pcObjectName = TRIM(LC("{&object-name}":U)).
&ENDIF

&IF DEFINED (object-version) <> 0 &THEN
    ASSIGN pcObjectVersion = {&object-version}.
&ENDIF

END PROCEDURE.

/* Astra 2 global shared variables */
{af/sup2/afglobals.i NEW GLOBAL}

/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       ryplipmain.i
&scop object-version    010001


/* MIP object identifying preprocessor */
&glob   mip-structured-include  yes

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getInternalEntries Include 
FUNCTION getInternalEntries RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

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
         HEIGHT             = 11.91
         WIDTH              = 40.4.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME




&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */

CREATE WIDGET-POOL NO-ERROR.

ON CLOSE OF THIS-PROCEDURE 
DO:
    DELETE WIDGET-POOL NO-ERROR.

    RUN plipShutdown.

    DELETE PROCEDURE THIS-PROCEDURE.
    RETURN.
END.   

ON DELETE OF THIS-PROCEDURE 
DO:
    DELETE WIDGET-POOL NO-ERROR.

    RUN plipShutdown.

    DELETE PROCEDURE THIS-PROCEDURE.
    RETURN.
END.   

RUN plipSetup.

THIS-PROCEDURE:PRIVATE-DATA = cObjectName.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getPLIPInfo Include 
PROCEDURE getPLIPInfo :
/*------------------------------------------------------------------------------
  Purpose:     Returns the PLIP description, version number and list of internal
               entries.  This procedure is mainly used to get all the PLIP information
               in one Appserver hit when running Appserver.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE OUTPUT PARAMETER pcObjectDescription AS CHARACTER  NO-UNDO.
DEFINE OUTPUT PARAMETER pdObjectVersion     AS DECIMAL    NO-UNDO.
DEFINE OUTPUT PARAMETER pcInternalEntries   AS CHARACTER  NO-UNDO.

/* Get the object description */

IF LOOKUP("objectDescription":U, THIS-PROCEDURE:INTERNAL-ENTRIES) > 0 THEN
    RUN objectDescription (OUTPUT pcObjectDescription).
ELSE
    IF LOOKUP("mip-object-description":U, THIS-PROCEDURE:INTERNAL-ENTRIES) > 0 THEN
        RUN mip-object-description (OUTPUT pcObjectDescription).

/* Get the version number */

RUN getObjectVersion (OUTPUT pcObjectDescription,
                      OUTPUT pdObjectVersion).

/* Get the procedure internal entries */

ASSIGN pcInternalEntries = DYNAMIC-FUNCTION("getInternalEntries":U IN THIS-PROCEDURE).

ASSIGN ERROR-STATUS:ERROR = NO.
RETURN "":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getInternalEntries Include 
FUNCTION getInternalEntries RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    RETURN THIS-PROCEDURE:INTERNAL-ENTRIES.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

