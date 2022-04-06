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
  File: inicfdbsitep.p

  Description:  Sets the site number for ICFDB

  Purpose:      Sets the site number for ICFDB

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   02/17/2002  Author:     Bruce Gruenbaum

  Update Notes: Created from Template rytemprocp.p

---------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */
DEFINE OUTPUT PARAMETER piSiteNo  AS INTEGER  NO-UNDO.
DEFINE OUTPUT PARAMETER piSeq1    AS INTEGER    NO-UNDO.
DEFINE OUTPUT PARAMETER piSeq2    AS INTEGER    NO-UNDO.
DEFINE OUTPUT PARAMETER piSess    AS INTEGER    NO-UNDO.

&scop object-name       inicfdbgetseqp.p
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000

DEFINE VARIABLE iSiteRev AS INTEGER    NO-UNDO.

DEFINE VARIABLE cSiteFwd AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cSiteRev AS CHARACTER  NO-UNDO.
DEFINE VARIABLE iCount   AS INTEGER    NO-UNDO.
DEFINE VARIABLE cFormat  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cDivisor AS CHARACTER  NO-UNDO.


/* object identifying preprocessor */
&glob   AstraProcedure    yes

{src/adm2/globals.i}

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
         HEIGHT             = 16.1
         WIDTH              = 49.6.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
cDivisor = STRING(CURRENT-VALUE(seq_site_division,ICFDB)).

IF LENGTH(cDivisor) > 1 THEN
DO iCount = 2 TO LENGTH(cDivisor):
  cFormat = cFormat + "9":U.
END.
ELSE
  cFormat = "9":U.


ASSIGN
  cSiteRev = STRING(CURRENT-VALUE(seq_site_reverse,ICFDB),cFormat)
  piSeq1   = CURRENT-VALUE(seq_obj1)
  piSeq2   = CURRENT-VALUE(seq_obj2)
  piSess   = CURRENT-VALUE(seq_session_id)
  cSiteFwd = "":U
  .

DO iCount = LENGTH(cSiteRev) TO 1 BY -1:
  cSiteFwd = cSiteFwd + SUBSTRING(cSiteRev,iCount,1).
END.

ASSIGN
  piSiteNo = INTEGER(cSiteFwd)
  .

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


