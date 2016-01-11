&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*----------------------------------------------------------------------------
File: _undsmar.p

Description: Undelete a SmartObject

Input Parameters:  uRecId - RecID of object of interest.

Output Parameters: <None>

Author: William T. Wood

Date Created: 15 February 1995
Modified: 09/99 HD  Moved logic to _realizesmart.p. 
          04/99 HD  TreeView support (Used for the SDO in html-mapping)           
          01/99 JEP Use undsmar.i for placeholder creation. Part of
                    fixes for bug 98-12-28-020.
          02/98 SLK Handle ADM2 
----------------------------------------------------------------------------*/
/* ***************************  Definitions  ************************** */

DEFINE INPUT PARAMETER uRecId AS RECID NO-UNDO.

DEFINE VARIABLE hSmart AS HANDLE NO-UNDO.
DEFINE VARIABLE cRet   AS CHAR   NO-UNDO.

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
         HEIGHT             = 15
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

RUN adeuib/_realizesmart.p PERSISTENT SET hSmart. 

RUN realizeSMO IN hSmart (uRecid, YES /* initializeObject  */ ).
cRet = RETURN-VALUE.

DELETE PROCEDURE hSmart.

IF cRet = "error":U THEN
  RETURN "error":u.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


