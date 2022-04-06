&ANALYZE-SUSPEND _VERSION-NUMBER WDT_v2r12 WebTool
/* Maps: HTML */
&ANALYZE-RESUME
&ANALYZE-SUSPEND _CODE-BLOCK _CUSTOM Definitions 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*------------------------------------------------------------------------
  File: fileact.w
  
  Description: Perform an action on a file in the current directory.
  
  Parameters:  <none>
  
  Fields: This checks for the following CGI fields:
  
    directory: The full pathname of the directory where the file can be found.
    filename : The filename of the file
    
    One of the following actions will have a non-zero value.
      action, FileAction
    
  History:
    10/23/1996 wood@progress.com
      Initial version
    01/16/1997 nhorn@progress.com
      Support multiple filename (comma separated list) for Compile and Delete.    
    03/31/1997 adams@progress.com
      Support multiple filename (comma-separated list) for TagExtract.
    07/23/2001 adams   
      Adapted to WebTools directory structure
------------------------------------------------------------------------*/
/*           This .W file was created with WebSpeed WorkBench.          */
/*----------------------------------------------------------------------*/


/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

&ANALYZE-RESUME
&ANALYZE-SUSPEND _PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&SCOPED-DEFINE PROCEDURE-TYPE WebTool


/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */
&ANALYZE-RESUME


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

&ANALYZE-SUSPEND _INCLUDED-LIBRARIES
/* Standard WebTool Included Libraries --  */
{ webtools/webtool.i }
&ANALYZE-RESUME _END-INCLUDED-LIBRARIES

&ANALYZE-SUSPEND _CODE-BLOCK _CUSTOM "Main Code Block" 


/* ************************  Main Code Block  *********************** */

/* Process the latest WEB event. */
RUN process-web-request.
&ANALYZE-RESUME
/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _CODE-BLOCK _PROCEDURE process-web-request 
PROCEDURE process-web-request :
/*------------------------------------------------------------------------------
  Purpose:     Process the web request.
  Parameters:  <none>
  Notes:       This call other routines that output the actual HTML. It does
               not set the header or the output itself.
------------------------------------------------------------------------------*/
DEFINE VARIABLE cAction    AS CHARACTER NO-UNDO.
DEFINE VARIABLE cDirectory AS CHARACTER NO-UNDO.
DEFINE VARIABLE cField     AS CHARACTER NO-UNDO.
DEFINE VARIABLE cFilename  AS CHARACTER NO-UNDO.
DEFINE VARIABLE cFullpath  AS CHARACTER NO-UNDO.
DEFINE VARIABLE cOptions   AS CHARACTER NO-UNDO.
DEFINE VARIABLE sFilename  AS CHARACTER NO-UNDO.
DEFINE VARIABLE ix         AS INTEGER   NO-UNDO.
DEFINE VARIABLE jx         AS INTEGER   NO-UNDO.

DEFINE VARIABLE lcFileNameList   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE lhCustomAction   AS HANDLE     NO-UNDO.

/* What is the context of this request?  Look at "cDirectory" and "cFilename". */
RUN GetField IN web-utilities-hdl ('filename':U,  OUTPUT cFilename).
RUN GetField IN web-utilities-hdl ('directory':U, OUTPUT cDirectory).

/* Make sure filename is specified. */
IF cFilename eq "" THEN DO:
  RUN OutputContentType IN web-utilities-hdl ('text/html':U).
  RUN HtmlError IN web-utilities-hdl ('File not specified.').
  RETURN.
END.

/* Figure out what the action should be. */
cAction = get-value('action':U).
IF cAction EQ "" THEN 
  cAction = get-value('FileAction':U).

/* V2.x stuff for browser-based Workshop tool (dma)
/* There are other checks as well. */ 
IF cAction eq "":U THEN DO:
  RUN GetField IN web-utilities-hdl ('CompileFile.x':U, OUTPUT c_field).
  IF c_field ne "":U THEN cAction = "Compile":U.
  ELSE DO:
    RUN GetField IN web-utilities-hdl ('OpenFile.x':U, OUTPUT c_field).
    IF c_field ne "":U THEN cAction = "Open":U.
    ELSE IF cAction eq "":U THEN DO:
      RUN GetField IN web-utilities-hdl ('RunFile.x':U, OUTPUT c_field).
      IF c_field ne "":U THEN cAction = "Run":U.
      ELSE IF cAction eq "":U THEN DO:
        RUN GetField IN web-utilities-hdl ('DeleteFile.x':U, OUTPUT c_field).
        IF c_field ne "":U THEN cAction = "Delete":U.
        ELSE IF cAction eq "" THEN DO:
          RUN GetField IN web-utilities-hdl ('TagExtract.x':U, OUTPUT c_field).
          IF c_field ne "":U THEN cAction = "TagExtract":U.
        END. 
      END. /* ELSE IF <not Run>... */
    END. /* ELSE IF <not Open>... */
  END.  /* ELSE IF <not Compile>... */
END. /* IF cAction eq ""... */
*/
/* View is the default action. */
IF cAction EQ "" THEN 
  cAction = "View":U.

/* Process the file based on the action. Allow for multiple files in the 
   filename. Process 1 file only if the action is not Compile, Delete or
   TagExtract. */
ASSIGN jx = IF CAN-DO("CheckSyntax,Compile,Delete,GenerateE4GL,TagExtract":U, cAction) 
            THEN NUM-ENTRIES(cFilename) ELSE 1.
  
DO ix = 1 TO jx:
  IF ix > 1 THEN 
    ASSIGN cOptions = "no-head":U.
    
  ASSIGN 
    sFilename           = ENTRY(ix, cFilename)
      
    /* Combine these into a full pathname. */
    FILE-INFO:FILE-NAME = (IF cDirectory ne "" THEN cDirectory + "~/":U ELSE "") 
                          + sFilename
    cFullpath           = FILE-INFO:FULL-PATHNAME.
  
  IF cFullpath EQ ? THEN DO:
    RUN OutputContentType IN web-utilities-hdl ('text/html':U).
    RUN HtmlError IN web-utilities-hdl(SUBSTITUTE("File &1 was not found.", sFilename)).
    RETURN.
  END.
  
  IF ix > 1 THEN DO: 
    ASSIGN cOptions = "no-head":U.
    {&OUT} '<HR WIDTH=80%>~n':U.
  END.
  
  RUN webtools/util/_fileact.w (sFilename, cFullpath, cAction, cOptions).
END. 

/* If we had more than 1 file, close body */                 
IF ix > 1 THEN 
{&OUT}
  '</BODY>~n':U
  '</HTML>':U.

END PROCEDURE.
&ANALYZE-RESUME
 

