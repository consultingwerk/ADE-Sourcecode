&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Include 
/*************************************************************/  
/* Copyright (c) 1984-2005 by Progress Software Corporation  */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from PROGRESS Software Corporation. */
/*************************************************************/
/*---------------------------------------------------------------------------------
  File:         inupgrdtt.i

  Description:  Upgrade API temp-tables.

  Purpose:      Upgrade API temp-tables.

  Parameters:

  History:
  --------
  (v:010000)    Task:          29   UserRef:    
                Date:   18/12/1997  Author:     Anthony Swindells

  Update Notes: Move osm- modules to af- modules

---------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* object identifying preprocessor */
&glob   AstraInclude    yes

DEFINE TEMP-TABLE ttPatch NO-UNDO RCODE-INFORMATION
  FIELD dPatchObj       AS DECIMAL      LABEL "dNodeNo":U
  FIELD lDBBuild        AS LOGICAL      LABEL "DBBuild":U
  FIELD iPatchLevel     AS INTEGER      LABEL "PatchLevel":U
  FIELD cNodeURL        AS CHARACTER    LABEL "NodeURL":U
  FIELD lApply          AS LOGICAL      LABEL "Apply":U       /* This gets set at automatically */
  FIELD dParentObj      AS DECIMAL      LABEL "dParent":U
  INDEX pudx  IS UNIQUE PRIMARY
    dPatchObj
  INDEX udx
    dParentObj
    iPatchLevel
  .

DEFINE TEMP-TABLE ttDatabase NO-UNDO RCODE-INFORMATION
  FIELD dDatabaseObj    AS DECIMAL      LABEL "dNodeNo":U
  FIELD cDBName         AS CHARACTER    LABEL "DBName":U
  FIELD cVersionSeq     AS CHARACTER    LABEL "VersionSeq":U
  FIELD iMinimumVersion AS INTEGER      LABEL "MinimumVersion":U
  FIELD cDBDir          AS CHARACTER    LABEL "DBDir":U
  FIELD cPathDump       AS CHARACTER    LABEL "DBDump":U
  FIELD cConnectParams  AS CHARACTER    LABEL "ConnectParams":U
  FIELD lDBCreate       AS LOGICAL      LABEL "CreateDB":U
  FIELD lDBBuild        AS LOGICAL      LABEL "BuildDB":U
  FIELD dParentObj      AS DECIMAL      LABEL "dParent":U
  INDEX pudx  IS UNIQUE PRIMARY
    dDatabaseObj
  INDEX udx01
    dParentObj
    dDatabaseObj
  INDEX udx02
    cDBName
  .

DEFINE TEMP-TABLE ttValue NO-UNDO RCODE-INFORMATION
  FIELD cGroup         AS CHARACTER    LABEL "Group":U
  FIELD cVariable      AS CHARACTER    LABEL "Variable":U
  FIELD cValue         AS CHARACTER    LABEL "Value":U
  FIELD lSiteData      AS LOGICAL      LABEL "SiteData":U
  INDEX pudx IS PRIMARY
    cGroup
    cVariable
  .

/* List of services  */
DEFINE TEMP-TABLE ttService NO-UNDO 
  FIELD cServiceName     AS CHARACTER 
  FIELD cPhysicalService AS CHARACTER 
  FIELD cServiceType     AS CHARACTER 
  FIELD cConnectParams   AS CHARACTER 
  FIELD lDefaultService  AS LOGICAL
  INDEX pudx IS PRIMARY UNIQUE
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
         HEIGHT             = 17.76
         WIDTH              = 48.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


