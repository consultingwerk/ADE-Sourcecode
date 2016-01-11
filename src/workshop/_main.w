&ANALYZE-SUSPEND _VERSION-NUMBER WDT_v2r1 Workshop-Object
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
  Web Object: _main.w
  
  Description: Main WebSpeed Workshop routine
  
    This is the main routine for the WebSpeed WorkBench. It is intended
    to run as a State-Aware application. All Workshop commands are filtered
    through this routine, encoded in the QUERY_STRING
  
  Main Fields:
    html: name of HTML screen to return (when called from a Browser)
    command: name of command to execute (when called from a Java applet)
       
  Author:  Wm. T. Wood
  Created: Dec. 9, 1996
------------------------------------------------------------------------*/
/*           This .W file was created with WebSpeed WorkBench.          */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

{ webutil/wstyle.i "NEW" }      /* Standard style definitions.          */
{ workshop/j-define.i "NEW GLOBAL" } /* Shared table join temp-table.   */
{ workshop/sharvars.i "NEW" }   /* Standard shared variables.           */
{ workshop/errors.i "NEW" }     /* Error handler and functions.         */
{ workshop/dirnode.i "NEW" }    /* Shared directory node temp-tables.   */
{ workshop/objects.i "NEW" }    /* Shared web-object temp-tables.       */
{ workshop/uniwidg.i "NEW" }    /* Shared widget temp-tables.           */
{ workshop/htmwidg.i "NEW" }    /* Shared HTML Field temp-tables.       */
{ workshop/code.i "NEW" }       /* Shared code temp-table.              */
{ workshop/property.i "NEW" }   /* Widget Property temp-table.          */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE no-license AS LOGICAL NO-UNDO.

&ANALYZE-RESUME
&ANALYZE-SUSPEND _PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Workshop-Object

&ANALYZE-RESUME

/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

&ANALYZE-SUSPEND _INCLUDED-LIBRARIES
/* ************************* Included-Libraries *********************** */
{src/web/method/wrap-cgi.i}

&ANALYZE-RESUME _END-INCLUDED-LIBRARIES

&ANALYZE-SUSPEND _CODE-BLOCK _CUSTOM "Main Code Block" 

/* ************************  Main Code Block  *********************** */

/* Check for Development mode. */
{ webutil/devcheck.i }

/* This is the Workshop tool. */
_h_tool = THIS-PROCEDURE.

/* Initialize the Workshop. */
RUN workshop/_startup.p.
IF RETURN-VALUE ne "NO-LICENSE":U THEN DO:
  /* If this object ever times out, we just want to restart. */
  RUN set-attribute-list ('Web-Timeout-Handler = workshop/_timeout.w':U). 

  /* Process the first WEB event. */
  RUN process-web-request.
END.
ELSE DO:
  RUN outputContentType IN web-utilities-hdl ("text/html":U).
  {&OUT} 
    { workshop/html.i &SEGMENTS = "head,open-body"
                      &FRAME    = "WS_index" 
                      &AUTHOR   = "D.M.Adams"
                      &TITLE    = "License Message" }.

  /* Output the remaining errors. */
  IF {&Workshop-Errors} THEN DO:
    {&OUT} '<UL>~n':U.
    RUN Output-Errors IN _err-hdl ("ALL":U, ? /* Use default template */ ).
    {&OUT} '</UL>~n':U.
  END.

  {&OUT} 
    '</BODY>~n':U
    '</HTML>~n':U.
END.

&ANALYZE-RESUME
/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _CODE-BLOCK _PROCEDURE local-destroy 
PROCEDURE local-destroy :
/*------------------------------------------------------------------------------
  Purpose:     Shutdown the Workshop
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  /* Shutdown other global objects. */
  RUN workshop/_shutdwn.p.
  
  /* Perform standard destroy procedure. */
  RUN dispatch IN THIS-PROCEDURE ('destroy':U).

END PROCEDURE.
&ANALYZE-RESUME

&ANALYZE-SUSPEND _CODE-BLOCK _PROCEDURE process-web-request 
PROCEDURE process-web-request :
/*------------------------------------------------------------------------------
  Purpose:     Process the web request.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE c_command AS CHAR NO-UNDO.
  DEFINE VARIABLE c_field   AS CHAR NO-UNDO.
  DEFINE VARIABLE c_html    AS CHAR NO-UNDO.
           
  /* Determine Context - default is "FRAMESET" */
  RUN GetField IN web-utilities-hdl (INPUT "html":U,    OUTPUT c_html).
  RUN GetField IN web-utilities-hdl (INPUT "command":U, OUTPUT c_command).

  /* Check for hard exit - otherwise, refresh for 5 minutes. */
  IF c_html ne "shutdown" THEN
    RUN set-web-state IN web-utilities-hdl (THIS-PROCEDURE, _timeout_period).

  /* Check for html or commands. Let HTML handle errors, if no command.*/
  IF (c_html ne "":U) OR (c_command eq "":U) THEN DO:
    CASE c_html:  
      /* Pass ? to the _create.w file so that it looks for html fields. */
      WHEN "createFile":U        THEN RUN workshop/_create.w (?, ?, "":U).
      WHEN "editSection":U       THEN RUN workshop/_sectact.w ("Edit":U).
      WHEN "fileAction":U        THEN RUN workshop/_fileact.w.
      WHEN "fileNew":U           THEN RUN workshop/_new.r. /* E4GL file */
      WHEN "keysearch":U         THEN RUN webtools/helpsrch.w. /* Redirect to WebTools */
      WHEN "mainProject":U       THEN RUN workshop/_project.w.
      WHEN "mainFile":U          THEN RUN workshop/_file.w ("MainMenu":U, "":U).
      WHEN "openedFiles":U       THEN RUN workshop/_opened.r. /* E4GL file */
      WHEN "preferences":U       THEN RUN workshop/_prefers.w (THIS-PROCEDURE).
      WHEN "propertySheet":U     THEN RUN workshop/_proprty.w.
      WHEN "procedureFrameset":U THEN RUN workshop/_file.w ("FrameSet":U, "":U).
      WHEN "saveSection":U       THEN RUN workshop/_sectact.w ("Save":U).    
      WHEN "shutdown":U THEN DO:
        /* Remove State-Aware and stop the Workshop. */
        RUN set-web-state IN web-utilities-hdl (THIS-PROCEDURE, 0).
        RUN workshop/_exit.r.
      END.
      OTHERWISE
        RUN htmlError IN web-utilities-hdl 
          ('Invalid Workshop HTML page requested:' + c_html).
    END CASE.
  END. /* HTML page requested. */
  ELSE DO:  
    /* A command was given. */
    CASE c_command:
      /* Section Editor specific commands (dealing with code sections) */
      WHEN "checkSection":U OR
      WHEN "deleteSection":U OR
      WHEN "getEventOptions":U OR 
      WHEN "getSection":U OR 
      WHEN "getSectionList":U OR 
      WHEN "newSection":U OR 
      WHEN "putSection":U         THEN RUN workshop/_secomm.w. 
      /* SectionEditor commands returning static information. */
      WHEN "getUtilityCallList":U OR
      WHEN "sectionTemplate"      THEN RUN workshop/_seinfo.w.    
      /* Command to run another web object. */
      WHEN "run":U THEN DO:
        /* Get the name of the webOject to run. */
        RUN GetField IN web-utilities-hdl ("webObject":U, OUTPUT c_field).         
        RUN run-web-object IN web-utilities-hdl (c_field).
      END.
      
      OTHERWISE
        RUN htmlError IN web-utilities-hdl 
          ('Invalid Workshop command received:' + c_command).
    END CASE.
  END. /* COMMAND requested. */
  
  /* Output the remaining errors. */
  IF {&Workshop-Errors} THEN
    RUN Output-Errors IN _err-hdl ("ALL":U, ? /* Use default template */ ).
END PROCEDURE.
&ANALYZE-RESUME
 
/* _main.w - end of file */
