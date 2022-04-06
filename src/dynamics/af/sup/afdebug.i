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
  File: afdebug.i

  Description:  Debug Include File

  Purpose:      Use this file in your code where you want the debugger instantiated.
                Don't forget to take it out later !

  Parameters:

  History:
  --------
  (v:010000)    Task:          29   UserRef:    
                Date:   18/12/1997  Author:     Anthony Swindells

  Update Notes: Move osm- modules to af- modules

  (v:010000)    Task:           6   UserRef:    
                Date:   04/04/1997  Author:     Alec Tucker

  Update Notes: Work on new MIP Templates

  (v:010001)    Task:          47   UserRef:    XFTR
                Date:   16/01/1998  Author:     Alec Tucker

  Update Notes: Applied noddy afnodxftrp.p

  (v:010002)    Task:          51   UserRef:    AS0
                Date:   05/02/1998  Author:     Anthony Swindells

  Update Notes: Added new XFTR to enforce addition of version notes for the current object version on open of an object.

  (v:010003)    Task:         101   UserRef:    
                Date:   20/03/1998  Author:     Anthony Swindells

  Update Notes: Register MIP application framework directory changes

  (v:010004)    Task:         539   UserRef:    Astra
                Date:   12/08/1998  Author:     Alec Tucker

  Update Notes: Put a message into the afdebug include file to ask if the debugger should be
                launched.

  (v:010005)    Task:         549   UserRef:    Astra
                Date:   17/08/1998  Author:     Alec Tucker

  Update Notes: Changed "lanuch" to "launch"!

--------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       afdebug.i
&scop object-version    010006

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */



/* _UIB-PREPROCESSOR-BLOCK-END */
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
         HEIGHT             = 2
         WIDTH              = 40.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME




&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */

DO:
    DEFINE VARIABLE lv_debug AS LOGICAL NO-UNDO.

    MESSAGE "Do you want to launch the debugger ?"
    VIEW-AS ALERT-BOX question BUTTONS YES-NO UPDATE lv_debug.

    IF lv_debug THEN
      DO:
        DEBUGGER:INITIATE().
        PROCESS EVENTS.
        DEBUGGER:SET-BREAK().
      END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


