&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
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
/*---------------------------------------------------------------------------------
  File: afconttdef.i

  Description:  Connection manager temp-table defs

  Purpose:      Connection manager temp-table definitions

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   11/18/2002  Author:     

  Update Notes: Created from Template ryteminclu.i

---------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* object identifying preprocessor */
&glob   AstraInclude    yes

/* List of service types */
DEFINE TEMP-TABLE tt{&ttPrefix}ServiceType NO-UNDO RCODE-INFORMATION
  FIELD cServiceType        AS CHARACTER FORMAT "X(30)" LABEL "Service Type"
  FIELD cSTProcName         AS CHARACTER FORMAT "X(50)" LABEL "Manager Procedure Name"
  FIELD hSTManager          AS HANDLE    
  FIELD lUseHandle          AS LOGICAL
  INDEX pudx IS PRIMARY UNIQUE
    cServiceType
  .

/* List of services  */
DEFINE TEMP-TABLE tt{&ttPrefix}Service NO-UNDO RCODE-INFORMATION
  FIELD cServiceName       AS CHARACTER FORMAT "X(30)":U LABEL "Service Name"
  FIELD cPhysicalService   AS CHARACTER FORMAT "X(30)":U LABEL "Physical Service"
  FIELD cServiceType       AS CHARACTER FORMAT "X(30)":U LABEL "Service Type"
  FIELD cConnectParams     AS CHARACTER FORMAT "X(60)":U LABEL "Connection Parameters"
  FIELD lDefaultService    AS LOGICAL FORMAT "Yes/No" LABEL "Default Service"
  FIELD lConnectAtStartup  AS LOGICAL FORMAT "Yes/No" LABEL "Connect At Startup" INITIAL YES
  INDEX pudx IS PRIMARY UNIQUE
    cServiceName
  INDEX dxPhysServ
    cPhysicalService
  INDEX dxServType
    cServiceType
    cServiceName
  .

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
         HEIGHT             = 5.24
         WIDTH              = 46.6.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


