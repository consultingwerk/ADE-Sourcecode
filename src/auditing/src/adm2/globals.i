&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Include 
/*********************************************************************
* Copyright (C) 2005 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*---------------------------------------------------------------------------------
  File: globals.i

  Description:  ICF Global Shared Variables

  Purpose:      ICF Global Shared Variables
                The global shared variables available within the Dynamics environment.
                
                NOTE: (Dynamic Only )
                Shared variables do not span the client / server boundary. On the
                client these are set-up in afstartupp.p and on the server in the agent
                as_startup.p
                Also note if we include the guts of a procedure as an internal
                procedure for shared client/server code, we sometime need to
                ensure the shared variables are not redefined.

  Parameters:   <none>

  History:
  --------

  Modified: 11/08/2001 - Mark Davies (MIP)
            Copied code for ICF afglobals.i and added here to allow
            ICF changed adm code to compile. afglobals.i now includes
            this file for definitions.
            Any ADM code will now reference globals.i which excludes any other
            ICF specific includes.
-----------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

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
         HEIGHT             = 5.57
         WIDTH              = 64.4.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */
/* Used whereever Crystal is used and when defining the tt_datasource temp-table 
   to define the maximum columns supported when printing to crystal.
   See browsercustom.p and afcrpplip2p.p for example uses
*/
&GLOBAL-DEFINE max-crystal-fields 65

/* Used for filter checks */
&GLOBAL-DEFINE HIGH-CHARACTER CHR(127)

/* The table delimiter used in assignlist, *ColumnsByTable props */
&GLOBAL-DEFINE adm-tabledelimiter ";":U

DEFINE NEW GLOBAL SHARED VARIABLE  gshAstraAppserver     AS HANDLE    NO-UNDO.    /* Handle to Astra Application Server Partition */
DEFINE NEW GLOBAL SHARED VARIABLE  gshSessionManager     AS HANDLE    NO-UNDO.    /* Handle Astra Session Manager */
DEFINE NEW GLOBAL SHARED VARIABLE  gshRIManager          AS HANDLE    NO-UNDO.    /* Handle Astra Session Manager */
DEFINE NEW GLOBAL SHARED VARIABLE  gshSecurityManager    AS HANDLE    NO-UNDO.    /* Handle Astra Security Manager */
DEFINE NEW GLOBAL SHARED VARIABLE  gshProfileManager     AS HANDLE    NO-UNDO.    /* Handle Astra Profile Manager */
DEFINE NEW GLOBAL SHARED VARIABLE  gshRepositoryManager  AS HANDLE    NO-UNDO.    /* Handle Astra Repository Manager */
DEFINE NEW GLOBAL SHARED VARIABLE  gshTranslationManager AS HANDLE    NO-UNDO.    /* Handle Astra Translation Manager */
DEFINE NEW GLOBAL SHARED VARIABLE  gshWebManager         AS HANDLE    NO-UNDO.    /* Handle Astra Web Manager */
DEFINE NEW GLOBAL SHARED VARIABLE  gscSessionId          AS CHARACTER NO-UNDO.    /* Unique session id */
DEFINE NEW GLOBAL SHARED VARIABLE  gsdSessionObj         AS DECIMAL DECIMALS 9 NO-UNDO.    /* Unique session id */
DEFINE NEW GLOBAL SHARED VARIABLE  gshFinManager         AS HANDLE    NO-UNDO.    /* Handle AstraFin Generic Manager */
DEFINE NEW GLOBAL SHARED VARIABLE  gshGenManager         AS HANDLE    NO-UNDO.    /* Handle AstraFramework Generic Manager */
DEFINE NEW GLOBAL SHARED VARIABLE  gshAgnManager         AS HANDLE    NO-UNDO.    /* Handle AstraGen Generic Manager */
DEFINE NEW GLOBAL SHARED VARIABLE  gsdTempUniqueID       AS DECIMAL DECIMALS 9  NO-UNDO.    /* A number for unique objects */
DEFINE NEW GLOBAL SHARED VARIABLE  gsdUserObj            AS DECIMAL DECIMALS 9  NO-UNDO.    /* User Object ID */
DEFINE NEW GLOBAL SHARED VARIABLE  gsdRenderTypeObj      AS DECIMAL DECIMALS 9  NO-UNDO.    /* Render Type Object ID */
DEFINE NEW GLOBAL SHARED VARIABLE  gsdSessionScopeObj    AS DECIMAL DECIMALS 9  NO-UNDO.    /* Render Type Object ID */


{src/adm2/custom/globalscustom.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


