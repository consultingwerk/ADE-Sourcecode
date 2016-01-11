&ANALYZE-SUSPEND _VERSION-NUMBER WDT_v2r1 Procedure
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
  File: _undercon.w
  
  Description: Return a message saying that the screen is under
               construction 
  
  Parameters:  p_msg -- message to display (in HTML).  The message
               will be centered and in <H2>
    
  Author:  Wm. T. Wood
  Created: Dec. 20, 1996
------------------------------------------------------------------------*/
/*           This .W file was created with WebSpeed WorkBench.          */
/*----------------------------------------------------------------------*/


/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER p_msg AS CHAR NO-UNDO.

/* Local Variable Definitions ---                                       */

/* Included Definitions ---                                             */
{ webutil/wstyle.i }        /* Standard style definitions.    */

&ANALYZE-RESUME
&ANALYZE-SUSPEND _PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure


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

  /* Output the page. */
  RUN OutputContentType IN web-utilities-hdl ('text/html':U).
  {&OUT}
    { workshop/html.i &SEGMENTS = "head,open-body"                      
                      &FRAME    = "WS_main" 
                      &AUTHOR   = "Wm.T.Wood"
                      &TITLE    = "Under Construction"  }
    '<CENTER>~n'
    '<IMG SRC="/webspeed/workshop/undercon.gif">~n'
    '<BR><BR><BR><H2>' p_msg '</H2><BR><BR>~n'
    '<IMG SRC="/webspeed/workshop/undercon.gif">~n'
    '</CENTER>~n'
    '</BODY>~n'
    '</HTML>~n'
    .
    
    
    
    
END PROCEDURE.

&ANALYZE-RESUME
 

