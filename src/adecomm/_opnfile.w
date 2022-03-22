&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*********************************************************************
* Copyright (C) 2005 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*--------------------------------------------------------------------------
    File        : _opnfile.w
    Purpose     : Run system-dialog or remote file open depending on AB 
                  preferences.
    Syntax      :
    Description : The number of filters are dynamic !  
    Parameters  : 
     INPUT        ptitle  - Title of dialog 
     INPUT        pfilter - COMMA separated string with filters.
                            MUST have the real filter in parenthesis.                                                            
                            USE Semicolon to separate filters ! 
                            Example "ALl Source(*.p;*.i;*.w),R-code files (*.r)". 
     INPUT-OUTPUT pfile   - filename, set to "" if nothing is found.
       
    Author(s)   : Haavard Danielsen
    Created     : Feb 1998
    Notes       : Currently maximum 6 filters.
                  Could easily be extended.                   
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

DEFINE INPUT        PARAMETER pTitle  AS CHARACTER NO-UNDO.
DEFINE INPUT        PARAMETER pFilter AS CHARACTER NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER pFile   AS CHARACTER NO-UNDO.
  
DEFINE VAR PickedOne  AS LOGICAL   NO-UNDO.
DEFINE VAR Path       AS CHARACTER NO-UNDO.
DEFINE VAR TempFile   AS CHARACTER NO-UNDO.
DEFINE VAR I          AS INTEGER   NO-UNDO.
DEFINE VAR gDelimiter AS CHARACTER INIT ",":U NO-UNDO.
DEFINE VAR gRemoteStr AS CHARAcTER NO-UNDO.

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

IF SEARCH("adeuib/_uibinfo.r":U) <> ? THEN
  RUN adeuib/_uibinfo.p
      (?, "SESSION":U, "REMOTE":U, OUTPUT gRemoteStr).
        
IF gRemoteStr <> "TRUE":U THEN 
  RUN adecomm/_getfiledialog.w (ptitle,pFilter,INPUT-OUTPUT pFile). 
  
ELSE DO:     
  RUN adeweb/_webfile.w
         ("UIB":U,
          "SEARCH":U,
          pTitle,
          pFilter,
          INPUT-OUTPUT pFile,
          OUTPUT TempFile,
          OUTPUT pickedOne). 
  IF NOT PickedOne THEN ASSIGN pFile = "":U.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


