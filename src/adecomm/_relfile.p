&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation ("PSC"),       *
* 14 Oak Park, Bedford, MA 01730, and other contributors as listed   *
* below.  All Rights Reserved.                                       *
*                                                                    *
* The Initial Developer of the Original Code is PSC.  The Original   *
* Code is Progress IDE code released to open source December 1, 2000.*
*                                                                    *
* The contents of this file are subject to the Possenet Public       *
* License Version 1.0 (the "License"); you may not use this file     *
* except in compliance with the License.  A copy of the License is   *
* available as of the date of this notice at                         *
* http://www.possenet.org/license.html                               *
*                                                                    *
* Software distributed under the License is distributed on an "AS IS"*
* basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. You*
* should refer to the License for the specific language governing    *
* rights and limitations under the License.                          *
*                                                                    *
* Contributors:                                                      *
*                                                                    *
*********************************************************************/
/*--------------------------------------------------------------------------
    File        : _relfile.p 
    Purpose     : Check existence of a file 
                  Return relative path if file is in propath.
    Syntax      : 

    Description :
                  
Input Parameters:
   pcFileName     Name of file to test.
   plCheckRemote  logical -  Yes - Check remotely if preferences says so
                             No  - Always check locally 
   pcOptions    Comma separated list of options: 
                - FILE-TYPE Return file-info:file-type after filename with colon                       
                            as separator.
                - One of these "file don't exists" options  
                  YES-NO   - Use yes-no dialog box.                        
                  VERBOSE  - Display error message.                        
                   
                   
                  VERBOSE:<file description>
                          The data after the : will be used instead of "file"
                          in the message.                       
                  YES-NO:<file description>
                          The data after the : will be used instead of "file"
                          in the message.                       
                   
                  MESSAGE:<message>.
                          Complete override of default message.
                          &1 - Will be substituted by URL when remote. 
                          &2 - Will be substituted by filename.       
Output Parameters:
      pcRelname  (OUTPUT CHAR) 
                  The relative pathname. If the file is not
                  found in PROPATH, then this returns pcFileName.
                  
                  If the file does not exist pcRelname will be ?.  
                  
                  _relname.p has the logic that ensures that the filename is 
                  returned with Progress portable slashes.  

    Author(s)   : Haavard Danielsen 
    Created     : 4/1/98
    Notes       : This is a wrapper around adecomm/_relname.p 
                  running it either remotely or locally.                                    
                  
                  Only supports must-exist 
                  
                  If must-be-rel is implemented make sure 
                  must-exist is default.                                      
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

DEFINE INPUT  PARAMETER pcFileName    AS CHARACTER NO-UNDO.
DEFINE INPUT  PARAMETER plCheckRemote AS LOGICAL   NO-UNDO.
DEFINE INPUT  PARAMETER pcOptions     AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER pcRelName     AS CHARACTER NO-UNDO.

DEFINE VARIABLE cInfo           AS CHARACTER NO-UNDO.
DEFINE VARIABLE lRemote         AS LOGICAL   NO-UNDO.
DEFINE VARIABLE lFileinfo       AS LOGICAL   NO-UNDO.
DEFINE VARIABLE cBrokerURL      AS CHARACTER NO-UNDO.
DEFINE VARIABLE cNotUsed        AS CHARACTER NO-UNDO.
DEFINE VARIABLE cMsg            AS CHARACTER NO-UNDO.
DEFINE VARIABLE cNoFileOption   AS CHARACTER NO-UNDO.
DEFINE VARIABLE cFile           AS CHARACTER NO-UNDO.
DEFINE VARIABLE lQuestion       AS LOG       NO-UNDO.
DEFINE VARIABLE lOk             AS LOG       NO-UNDO.
DEFINE VARIABLE i               AS INTEGER   NO-UNDO.
DEFINE VARIABLE cOptionEntry    AS CHARACTER NO-UNDO.

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

IF plCheckRemote THEN
DO:
  RUN adeuib/_uibinfo.p
     (?, 
      "SESSION":U,
      "REMOTE":U, 
      OUTPUT cInfo).
        
  ASSIGN lRemote = CAN-DO("TRUE,YES":U,cInfo).
END.

ASSIGN lFileInfo = CAN-DO(pcOptions,"FILE-INFO":U).        

IF lRemote THEN
DO:   
  RUN adeuib/_uibinfo.p
    (?, 
     "SESSION":U,
     "BrokerURL":U, 
     OUTPUT cBrokerURL).
  
  RUN adeweb/_webcom.w (?,
                        cBrokerURL,
                        pcFileName,
                        "SEARCH":U
                        + (IF lFileInfo THEN ":FILE-INFO":U ELSE "":U),                      
                        OUTPUT pcRelName, 
                        INPUT-OUTPUT cNotUsed).
  OS-DELETE VALUE(cNotUsed). 
  IF RETURN-VALUE BEGINS "ERROR":U THEN RETURN "ERROR":U.   
END.
ELSE
  RUN adecomm/_relname.p (pcFileName, "must-exist":U, OUTPUT pcRelName).


IF pcRelName = ? THEN
DO:
  /* look for the options for file don't exist */ 
  DO i = 1 To NUM-ENTRIES(pcOptions):   
    cOptionEntry = ENTRY(i,pcOptions).
    
    IF cOptionEntry BEGINS "MESSAGE":U
    OR cOptionEntry BEGINS "YES-NO":U
    OR cOptionEntry BEGINS "VERBOSE":U THEN
    DO:
      ASSIGN     
         cNofileOption = cOptionEntry.
      LEAVE.
    END. 
  END. /* do i = 1 to num-entries */
    
  IF cNoFileOption <> "":U THEN     
  DO:
    ASSIGN    /* if "message:<text>" then use <text> */ 
      lQuestion = cNoFileOption BEGINS "YES-NO":U
      cMsg =  IF cOptionEntry BEGINS "MESSAGE":U 
              AND NUM-ENTRIES(cOptionEntry,":":U) > 1 
              THEN ENTRY(2,cOptionEntry,":":U)            
              ELSE "&2 is missing&1."
                   + CHR(10)                   
                   + (IF lQuestion THEN "Do you wish to continue?":U 
                      ELSE "Please enter correct path and filename.":U)   
            
      cFile = /* If there is a : after verbose or yes-no use that instead
                 of 'file' in the message  */
              (IF (cOptionEntry BEGINS "VERBOSE":U OR lQuestion) 
               AND NUM-ENTRIES(cOptionEntry,":":U) > 1 
               THEN ENTRY(2,cOptionEntry,":":U) + " ":U
               ELSE "File ":U)   
               + pcFilename
             
             /* substitute the URL and the filename into the message */  
      cMsg  = SUBSTITUTE(cMsg,
                         IF lRemote 
                         THEN " on URL: " + cBrokerURL
                         ELSE "",
                         cFile).           
   
    IF lQuestion THEN 
    DO:
      MESSAGE 
        cMsg       SKIP      
        VIEW-AS 
        ALERT-BOX 
        WARNING 
        BUTTONS YES-NO
        UPDATE lok.
      IF lOk THEN 
        ASSIGN pcRelName = pcFileName.
       
    END. /* if lquestion */
    ELSE  
      MESSAGE 
        cMsg       SKIP      
          VIEW-AS 
          ALERT-BOX 
          ERROR.             
  END. /* if cNoFileOption  <> '' */
END. /* if pcRelname = ? */
ELSE /* add file-type if file-info is in the optionlist */ 
IF lFileinfo and NOT lRemote THEN
  ASSIGN 
    FILE-INFO:FILE-NAME = pcRelname
    pcRelname = pcRelname + ":"  + FILE-INFO:FILE-TYPE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


