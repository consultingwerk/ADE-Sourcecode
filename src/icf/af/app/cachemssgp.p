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
  File: cachemssgp.p

  Description:  Retrieve info needed to show a message

  Purpose:      Retrieves all Appserver information necessary to display the standard
                Dynamics message dialog.  All the information is retrieved in one Appserver
                hit.  It is then cached and distributed on the client.

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   10/31/2002  Author:     

  Update Notes: Created from Template rytemprocp.p

---------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       cachemssgp.p
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000


/* object identifying preprocessor */
&glob   AstraProcedure    yes

{src/adm2/globals.i}

/* Define afxmlcfgp.p session super temp-tables */
&GLOBAL-DEFINE defineTTParam YES
{af/sup2/afxmlcfgtt.i}
&UNDEFINE defineTTParam

/* Define connection manager temp-tables */
{af/app/afconttdef.i &ttPrefix = con}

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
         HEIGHT             = 5
         WIDTH              = 40.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

DEFINE INPUT  PARAMETER pcMessageList     AS CHARACTER  NO-UNDO. /* afmessagep.p */
DEFINE INPUT  PARAMETER pcInButtonList    AS CHARACTER  NO-UNDO. /* afmessagep.p */
DEFINE INPUT  PARAMETER pcInMessageTitle  AS CHARACTER  NO-UNDO. /* afmessagep.p */
DEFINE INPUT  PARAMETER pcDBList          AS CHARACTER  NO-UNDO. /* getDBVersion */

DEFINE OUTPUT PARAMETER pcSummaryMessages AS CHARACTER  NO-UNDO. /* afmessagep.p */
DEFINE OUTPUT PARAMETER pcFullMessages    AS CHARACTER  NO-UNDO. /* afmessagep.p */
DEFINE OUTPUT PARAMETER pcOutButtonList   AS CHARACTER  NO-UNDO. /* afmessagep.p */
DEFINE OUTPUT PARAMETER pcOutMessageTitle AS CHARACTER  NO-UNDO. /* afmessagep.p */
DEFINE OUTPUT PARAMETER plUpdateErrorLog  AS LOGICAL    NO-UNDO. /* afmessagep.p */
DEFINE OUTPUT PARAMETER plSuppressDisplay AS LOGICAL    NO-UNDO. /* afmessagep.p */

DEFINE OUTPUT PARAMETER pcDBVersions      AS CHARACTER  NO-UNDO. /* getDBVersion */

DEFINE OUTPUT PARAMETER plRemote          AS LOGICAL    NO-UNDO. /* getAppserverInfo */
DEFINE OUTPUT PARAMETER pcConnid          AS CHARACTER  NO-UNDO. /* getAppserverInfo */
DEFINE OUTPUT PARAMETER pcOpmode          AS CHARACTER  NO-UNDO. /* getAppserverInfo */
DEFINE OUTPUT PARAMETER plConnreg         AS LOGICAL    NO-UNDO. /* getAppserverInfo */
DEFINE OUTPUT PARAMETER plConnbnd         AS LOGICAL    NO-UNDO. /* getAppserverInfo */
DEFINE OUTPUT PARAMETER pcConntxt         AS CHARACTER  NO-UNDO. /* getAppserverInfo */
DEFINE OUTPUT PARAMETER pcASppath         AS CHARACTER  NO-UNDO. /* getAppserverInfo */
DEFINE OUTPUT PARAMETER pcConndbs         AS CHARACTER  NO-UNDO. /* getAppserverInfo */
DEFINE OUTPUT PARAMETER pcConnpps         AS CHARACTER  NO-UNDO. /* getAppserverInfo */
DEFINE OUTPUT PARAMETER pcCustInfo1       AS CHARACTER  NO-UNDO. /* getAppserverInfo */
DEFINE OUTPUT PARAMETER pcCustInfo2       AS CHARACTER  NO-UNDO. /* getAppserverInfo */
DEFINE OUTPUT PARAMETER pcCustInfo3       AS CHARACTER  NO-UNDO. /* getAppserverInfo */
DEFINE OUTPUT PARAMETER TABLE-HANDLE phTableHandle1.              /* getAppserverInfo */
DEFINE OUTPUT PARAMETER TABLE-HANDLE phTableHandle2.              /* getAppserverInfo */
DEFINE OUTPUT PARAMETER TABLE-HANDLE phTableHandle3.              /* getAppserverInfo */
DEFINE OUTPUT PARAMETER TABLE-HANDLE phTableHandle4.              /* getAppserverInfo */

DEFINE OUTPUT PARAMETER pcSite            AS CHARACTER  NO-UNDO. /* getSiteNumber    */
DEFINE OUTPUT PARAMETER pcFieldSecurity   AS CHARACTER  NO-UNDO. /* Field Security   */
DEFINE OUTPUT PARAMETER pcTokenSecurity   AS CHARACTER  NO-UNDO. /* Token Security   */

/* Translate the message */

RUN af/app/afmessagep.p (INPUT  pcMessageList,
                         INPUT  pcInButtonList,
                         INPUT  pcInMessageTitle,
                         OUTPUT pcSummaryMessages,
                         OUTPUT pcFullMessages,
                         OUTPUT pcOutButtonList,
                         OUTPUT pcOutMessageTitle,
                         OUTPUT plUpdateErrorLog,
                         OUTPUT plSuppressDisplay).

/* Get Appserver Information */

RUN af/app/afapppingp.p (OUTPUT plRemote,
                         OUTPUT pcConnid,
                         OUTPUT pcOpmode,
                         OUTPUT plConnreg,
                         OUTPUT plConnbnd,
                         OUTPUT pcConntxt,
                         OUTPUT pcASppath,
                         OUTPUT pcConndbs,
                         OUTPUT pcConnpps,
                         OUTPUT pcCustInfo1,
                         OUTPUT pcCustInfo2,
                         OUTPUT pcCustInfo3,
                         OUTPUT TABLE ttParam,
                         OUTPUT TABLE ttManager,
                         OUTPUT TABLE ttConServiceType,
                         OUTPUT TABLE ttConService).

ASSIGN phTableHandle1 = TEMP-TABLE ttParam:HANDLE
       phTableHandle2 = TEMP-TABLE ttManager:HANDLE
       phTableHandle3 = TEMP-TABLE ttConServiceType:HANDLE
       phTableHandle4 = TEMP-TABLE ttConService:HANDLE.

/* Get the site number */

RUN getSiteNumber IN gshGenManager (OUTPUT pcSite).

/* Get db versions */

RUN getDBVersion IN gshGenManager (INPUT  pcDBList,
                                   OUTPUT pcDBVersions).

/* Get field security */

RUN fieldSecurityGet IN gshSecurityManager (INPUT ?,
                                            INPUT "afmessaged.w":U,
                                            INPUT "":U,
                                            OUTPUT pcFieldSecurity).

/* Get token security */

RUN tokenSecurityGet IN gshSecurityManager (INPUT ?,
                                            INPUT "afmessaged.w":U,
                                            INPUT "":U,
                                            OUTPUT pcTokenSecurity).

ASSIGN ERROR-STATUS:ERROR = NO.
RETURN "":U.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


