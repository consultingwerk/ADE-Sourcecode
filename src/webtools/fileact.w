&ANALYZE-SUSPEND _VERSION-NUMBER WDT_v2r1 WebTool
&ANALYZE-RESUME
&ANALYZE-SUSPEND _CODE-BLOCK _CUSTOM Definitions 
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
/*------------------------------------------------------------------------
  File: fileact.w
  
  Description: Perform an action on a file in the current directory.
  
  Parameters:  <none>
  
  Fields: This checks for the following CGI fields:
  
    directory: The full pathname of the directory where the file can be found.
    Filename : The Filename of the file
    
    One of the following actions will have a non-zero value.
      action, FileAction
    
  Author:  Wm. T. Wood
  Created: Oct 23, 1996

  Modifications  Support multiple filename (comma separated   nhorn 1/16/97
                   list) for Compile and Delete.    
                 Support multiple filename (comma-separated   adams 3/31/97
                   list) for TagExtract.

------------------------------------------------------------------------*/
/*           This .W file was created with WebSpeed WorkBench.          */
/*----------------------------------------------------------------------*/


/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
&ANALYZE-RESUME
&ANALYZE-SUSPEND _PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE WebTool


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
  DEFINE VARIABLE action     AS CHARACTER NO-UNDO.
  DEFINE VARIABLE c_field    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE directory  AS CHARACTER NO-UNDO.
  DEFINE VARIABLE filename   AS CHARACTER NO-UNDO.
  DEFINE VARIABLE fullpath   AS CHARACTER NO-UNDO.
  DEFINE VARIABLE options    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE s_filename AS CHARACTER NO-UNDO.
  DEFINE VARIABLE i          AS INTEGER   NO-UNDO.
  DEFINE VARIABLE y          AS INTEGER   NO-UNDO.
  
  /* What is the context of this request?  Look at "directory" and "filename". */
  RUN GetField IN web-utilities-hdl ('filename':U,  OUTPUT filename).
  RUN GetField IN web-utilities-hdl ('directory':U, OUTPUT directory).
  
  /* Make sure filename is specified. */
  IF filename eq "" THEN DO:
    RUN OutputContentType IN web-utilities-hdl ('text/html':U).
    RUN HtmlError IN web-utilities-hdl ('File not specified.').
    RETURN.
  END.
  
  /* Figure out what the action should be. */
  action = get-value('action':U).
  IF action eq '':U THEN action = get-value('FileAction':U).
  /* There are other checks as well. */ 
  IF action eq "":U THEN DO:
    RUN GetField IN web-utilities-hdl ('CompileFile.x':U, OUTPUT c_field).
    IF c_field ne "":U THEN action = "Compile":U.
    ELSE DO:
      RUN GetField IN web-utilities-hdl ('OpenFile.x':U, OUTPUT c_field).
      IF c_field ne "":U THEN action = "Open":U.
      ELSE IF action eq "":U THEN DO:
        RUN GetField IN web-utilities-hdl ('RunFile.x':U, OUTPUT c_field).
        IF c_field ne "":U THEN action = "Run":U.
        ELSE IF action eq "":U THEN DO:
          RUN GetField IN web-utilities-hdl ('DeleteFile.x':U, OUTPUT c_field).
          IF c_field ne "":U THEN action = "Delete":U.
          ELSE IF action eq "" THEN DO:
            RUN GetField IN web-utilities-hdl ('TagExtract.x':U, OUTPUT c_field).
            IF c_field ne "":U THEN action = "TagExtract":U.
          END. 
        END. /* ELSE IF <not Run>... */
      END. /* ELSE IF <not Open>... */
    END.  /* ELSE IF <not Compile>... */
  END. /* IF action eq ""... */
 
  /* View is the default action. */
  IF action eq "":U THEN action = "View":U.

  /* Process the file based on the action. Allow for multiple files in the 
     filename. Process 1 file only if the action is not Compile, Delete or
     TagExtract. */
  IF CAN-DO("Compile,CheckSyntax,Delete,TagExtract":U,action) THEN
    y = NUM-ENTRIES(filename). 
  ELSE 
    y = 1.

  DO i = 1 to y:
    IF i > 1 THEN 
      ASSIGN options = "no-head":U.
	  
    ASSIGN 
      s_filename          = ENTRY(i, filename)
      
      /* Combine these into a full pathname. */
      FILE-INFO:FILE-NAME = (IF directory ne "" THEN directory + "~/":U ELSE "") 
                            + s_filename
      fullpath            = FILE-INFO:FULL-PATHNAME.

    IF fullpath eq ? THEN DO:
      RUN OutputContentType IN web-utilities-hdl ('text/html':U).
      RUN HtmlError IN web-utilities-hdl ('File "' + s_filename + '" not found.').
      RETURN.
    END.

    IF i > 1 THEN DO: 
	  ASSIGN options = "no-head":U.
	  {&OUT}
	    '<HR WIDTH=80%>~n':U.
    END.

    RUN webtools/util/_fileact.w (s_filename, fullpath, action, options). 
  END. /* End File Process */

  /* If we had more than 1 file, close body */                 
  IF i > 1 THEN 
  {&OUT}
    '</BODY>~n':U
    '</HTML>':U
    .

END PROCEDURE.
&ANALYZE-RESUME
 

