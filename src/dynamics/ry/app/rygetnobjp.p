&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Check Version Notes Wizard" Procedure _INLINE
/* Actions: af/cod/aftemwizcw.w ? ? ? ? */
/* MIP Update Version Notes Wizard
Check object version notes.
af/cod/aftemwizpw.w
*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Update-Object-Version" Procedure _INLINE
/* Actions: ? ? ? ? af/sup/afverxftrp.p */
/* This has to go above the definitions sections, as that is what it modifies.
   If its not, then the definitions section will have been saved before the
   XFTR code kicks in and changes it */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Definition Comments Wizard" Procedure _INLINE
/* Actions: ? af/cod/aftemwizcw.w ? ? ? */
/* Program Definition Comment Block Wizard
Welcome to the Program Definition Comment Block Wizard. Press Next to proceed.
af/cod/aftemwizpw.w
*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*---------------------------------------------------------------------------------
  File: rygetnobjp.p

  Description:  Get next object number from ICFDB

  Purpose:      Get next object number from ICFDB
                used by getnextobj function in aftrigproc.i included into
                all create triggers.

  Parameters:   input increment flag yes or no
                output seq_obj1 next value
                output seq_obj2 current value
                output seq_site_division current value
                output seq_site_reverse current value
                output seq_session_id current value
                

  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   11/20/2001  Author:     Anthony Swindells

  Update Notes: Created from Template rytemprocp.p

---------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       rygetnobjp.p
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000


/* object identifying preprocessor */
&glob   AstraProcedure    yes

{src/adm2/globals.i}

DEFINE INPUT PARAMETER  plIncrement  AS LOGICAL  NO-UNDO.
DEFINE OUTPUT PARAMETER piSeqObj1    AS INTEGER  NO-UNDO.
DEFINE OUTPUT PARAMETER piSeqObj2    AS INTEGER  NO-UNDO.
DEFINE OUTPUT PARAMETER piSeqSiteDiv AS INTEGER  NO-UNDO.
DEFINE OUTPUT PARAMETER piSeqSiteRev AS INTEGER  NO-UNDO.
DEFINE OUTPUT PARAMETER piSessnId    AS INTEGER  NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



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


/* ***************************  Main Block  *************************** */

ASSIGN
    piSeqObj1    = IF plIncrement THEN NEXT-VALUE(seq_obj1,ICFDB) ELSE CURRENT-VALUE(seq_obj1,ICFDB)
    piSeqObj2    = CURRENT-VALUE(seq_obj2,ICFDB)
    piSeqSiteDiv = CURRENT-VALUE(seq_site_division,ICFDB)
    piSeqSiteRev = CURRENT-VALUE(seq_site_reverse,ICFDB)
    piSessnId    = CURRENT-VALUE(seq_session_id,ICFDB)
    .

IF piSeqObj1 = 0 AND plIncrement
THEN
    ASSIGN
        piSeqObj2 = NEXT-VALUE(seq_obj2,ICFDB).

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


