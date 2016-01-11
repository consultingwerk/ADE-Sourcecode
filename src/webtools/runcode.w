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

  File: runcode.w

  Description: Runs a small amount of WebSpeed Scripting code and displays
               the results. 
               
               All code is prefaces with src/web/method/cgidefs.i
               and 'OUTPUT TO "WEB"', and "<PRE>".

  Modifications:
               All code is prefaces with PUT "<PRE>"            sjf 8/30/96
               With an option to change back

               Add the ability to save/open scripts             sjf 9/4/96
               With an option to change back
               
               Error messages now access the            wood 9/6/96

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author:  Wm. T. Wood
  Created: August 10, 1996

------------------------------------------------------------------------*/
/*           This .W file was created with WebSpeed Workshop.           */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
DEFINE VAR output-type AS CHAR INITIAL "Preformatted" NO-UNDO.

/* Stream to save file into. */
DEFINE STREAM P_4GL.
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

/* Handle the WEB event. */
RUN process-web-request.
&ANALYZE-RESUME
/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _CODE-BLOCK _PROCEDURE process-web-request 
PROCEDURE process-web-request :
/*------------------------------------------------------------------------------
  Purpose:     Process Web Request.
  Parameters:  <none>
  Notes:       Note that this file does not actually output anything directly.
               It calls the WebTools utility function util/_run4gl.w which does
               the output.
------------------------------------------------------------------------------*/
  DEFINE VAR codeField  AS CHAR NO-UNDO.
  DEFINE VAR code       AS CHAR NO-UNDO.
  
  /* Get the name of the codeField  */
  RUN GetField IN web-utilities-hdl (INPUT "codeField", OUTPUT codeField).
  IF codeField eq "":U OR codeField eq ? THEN codeField = "code".

  /* Get the code itself. */
  RUN GetField IN web-utilities-hdl (INPUT codeField, OUTPUT code).
  
  /* Run this code. */
  RUN webtools/util/_run4gl.w
    (code, 
     "WebSpeed 4GL Run Window", /* Title of window. */
     "PRE,COMPACT":U            /* Options: Preformat output, & don't show wordy heading */
     ).

END PROCEDURE.
&ANALYZE-RESUME
 

