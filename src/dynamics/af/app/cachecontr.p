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
/*---------------------------------------------------------------------------------
  File: contrcache.p

  Description:  Gets all data to launch container

  Purpose:      This procedure is run on the Appserver to fetch all the necessary data to launch
                a container.

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   05/29/2002  Author:     

  Update Notes: Created from Template rytemprocp.p

  Deprecated.

---------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       cachecontr.p
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000

/* object identifying preprocessor */
&glob   AstraProcedure    yes

{src/adm2/globals.i}

/* Profile table */
{af/app/afttprofiledata.i}

&GLOBAL-DEFINE defineCache /* Will be undefined in the include */
{src/adm2/ttaction.i}

&GLOBAL-DEFINE defineCache /* Will be undefined in the include */
{src/adm2/tttoolbar.i}

/* Defines result codes */

{ry/app/rydefrescd.i}
{ry/app/ryobjretri.i}

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
         HEIGHT             = 13.48
         WIDTH              = 53.8.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

DEFINE INPUT-OUTPUT PARAMETER         plGetObjectDetail       AS LOGICAL   NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER         plGetTokenSecurity      AS LOGICAL   NO-UNDO. /* Redundant */
DEFINE INPUT-OUTPUT PARAMETER         plGetFieldSecurity      AS LOGICAL   NO-UNDO. /* Redundant */
DEFINE INPUT-OUTPUT PARAMETER         plGetToolbars           AS LOGICAL   NO-UNDO. /* Redundant */

DEFINE INPUT PARAMETER pcLogicalObjectName     AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER pcAttributeCode         AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER pdUserObj               AS DECIMAL   NO-UNDO.
DEFINE INPUT PARAMETER pcResultCode            AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER pdLanguageObj           AS DECIMAL   NO-UNDO.
DEFINE INPUT PARAMETER plReturnEntireContainer AS LOGICAL   NO-UNDO.
DEFINE INPUT PARAMETER plDesignMode            AS LOGICAL   NO-UNDO.
DEFINE INPUT PARAMETER pcToolbar               AS CHARACTER NO-UNDO. /* Not used */
DEFINE INPUT PARAMETER pcObjectList            AS CHARACTER NO-UNDO. 
DEFINE INPUT PARAMETER pcBandList              AS CHARACTER NO-UNDO. /* Not used */
DEFINE INPUT PARAMETER pdOrganisationObj       AS DECIMAL   NO-UNDO.

DEFINE OUTPUT PARAMETER pcTokenSecurityString  AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER pcFieldSecurityString  AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER TABLE-HANDLE phObjectTable.
DEFINE OUTPUT PARAMETER TABLE-HANDLE phPageTable.
DEFINE OUTPUT PARAMETER TABLE-HANDLE phPageInstanceTable.
DEFINE OUTPUT PARAMETER TABLE-HANDLE phLinkTable.
DEFINE OUTPUT PARAMETER TABLE-HANDLE phUIEventTable.
DEFINE OUTPUT PARAMETER TABLE-HANDLE phClassAttributeTable01.
DEFINE OUTPUT PARAMETER TABLE-HANDLE phClassAttributeTable02.
DEFINE OUTPUT PARAMETER TABLE-HANDLE phClassAttributeTable03.
DEFINE OUTPUT PARAMETER TABLE-HANDLE phClassAttributeTable04.
DEFINE OUTPUT PARAMETER TABLE-HANDLE phClassAttributeTable05.
DEFINE OUTPUT PARAMETER TABLE-HANDLE phClassAttributeTable06.
DEFINE OUTPUT PARAMETER TABLE-HANDLE phClassAttributeTable07.
DEFINE OUTPUT PARAMETER TABLE-HANDLE phClassAttributeTable08.
DEFINE OUTPUT PARAMETER TABLE-HANDLE phClassAttributeTable09.
DEFINE OUTPUT PARAMETER TABLE-HANDLE phClassAttributeTable10.
DEFINE OUTPUT PARAMETER TABLE-HANDLE phClassAttributeTable11.
DEFINE OUTPUT PARAMETER TABLE-HANDLE phClassAttributeTable12.
DEFINE OUTPUT PARAMETER TABLE-HANDLE phClassAttributeTable13.
DEFINE OUTPUT PARAMETER TABLE-HANDLE phClassAttributeTable14.
DEFINE OUTPUT PARAMETER TABLE-HANDLE phClassAttributeTable15.
DEFINE OUTPUT PARAMETER TABLE-HANDLE phClassAttributeTable16.
DEFINE OUTPUT PARAMETER TABLE-HANDLE phClassAttributeTable17.
DEFINE OUTPUT PARAMETER TABLE-HANDLE phClassAttributeTable18.
DEFINE OUTPUT PARAMETER TABLE-HANDLE phClassAttributeTable19.

DEFINE OUTPUT PARAMETER TABLE-HANDLE phttStoreToolbarsCached.
DEFINE OUTPUT PARAMETER TABLE-HANDLE phttCacheToolbarBand.
DEFINE OUTPUT PARAMETER TABLE-HANDLE phttCacheObjectBand.
DEFINE OUTPUT PARAMETER TABLE-HANDLE phttCacheBand.
DEFINE OUTPUT PARAMETER TABLE-HANDLE phttCacheBandAction.
DEFINE OUTPUT PARAMETER TABLE-HANDLE phttCacheAction.
DEFINE OUTPUT PARAMETER TABLE-HANDLE phttCacheCategory.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


