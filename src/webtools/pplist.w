&ANALYZE-SUSPEND _VERSION-NUMBER WDT_v2r12 WebTool
/* Maps: HTML */
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
  File: pplist.w
  
  Description: List of all Persistent Procedures running in a WebSpeed Agent

  Modifications:  Clean up HTML                    nhorn 1/8/97
                  Add "time remaining" info for    nhorn 1/8/97
                    web-state.  

  Parameters:  <none>

  Author:  Wm. T. Wood
  Created: Aug. 21, 1996
------------------------------------------------------------------------*/
/*           This .W file was created with WebSpeed WorkBench.          */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

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
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE h         AS HANDLE    NO-UNDO.
  DEFINE VARIABLE type      AS CHARACTER NO-UNDO.
  DEFINE VARIABLE web-state AS CHARACTER NO-UNDO.
  DEFINE VARIABLE p_period  AS DECIMAL   NO-UNDO.
  
  RUN outputContentType IN web-utilities-hdl ("text/html":U).
 
  /* Standard Header */
  {&OUT} 
    {webtools/html.i
      &AUTHOR   = "Wm. T. Wood"
      &FRAME    = "WS_main" 
      &TITLE    = "Object State"
      &SEGMENTS = "head,open-body,title-line"  
      &CONTEXT  = "{&Webtools_Persistent_Objects_Help}" }.

  /* Output a Table for the Persistent Procedures. */
  {&OUT} 
    '<CENTER>~n':U
    '<BR><TABLE':U get-table-phrase('') '>~n':U
    '<TR><TH>':U format-label ('Web Object File Name', "COLUMN":U, "") '</TH>~n':U
    '    <TH>':U format-label ('Type', "COLUMN":U, "":U) '</TH>~n':U
    '    <TH>':U format-label ('Web-State', "COLUMN":U, "") '<BR>':U
                 format-text('(Time Left)', 'HighLight':U) '</TH>~n':U
    '</TR>~n':U
    .
 
  h = SESSION:FIRST-PROCEDURE.
  DO WHILE VALID-HANDLE (h):
    
    RUN get-attribute IN h ('WEB-STATE':U) NO-ERROR.
    
    web-state = IF ERROR-STATUS:ERROR THEN "-":U ELSE RETURN-VALUE.
    /*
    /* This is a workaround until 'getObjectType' works in the super procs */
    IF h:file-name begins "adm2/":U
    OR h:file-name begins "web2/":U THEN
      ASSIGN
        type      = "Super Procedure":U 
        web-state = IF web-state = "-" THEN "persistent":U ELSE web-state.    
                
    ElSE */
    IF can-do(h:internal-entries,'getObjectType':U) THEN  
      ASSIGN
        type      = dynamic-function('getObjectType':U in h)
        type      = IF type = "SUPER":U 
                    THEN "Super-Procedure" 
                    ELSE type.
    ELSE DO:    
      RUN get-attribute IN h ('Type':U) NO-ERROR.
      type = IF ERROR-STATUS:ERROR THEN "-":U ELSE RETURN-VALUE.
    END.
    web-state = IF web-state = "-" THEN "persistent":U ELSE web-state.    
    
    IF web-state eq 'State-Aware':U THEN DO:
      RUN get-attribute IN h ('Web-Time-Remaining':U) NO-ERROR.
      p_period = IF ERROR-STATUS:ERROR THEN ? ELSE DECIMAL(RETURN-VALUE).
    END.
    {&OUT} 
      "<TR><TD>":U h:FILE-NAME  "</TD>":U
      "<TD><CENTER>":U Type "</CENTER></TD>":U
      "<TD><CENTER>":U web-state .
	  
    IF (web-state eq 'State-Aware':U) AND (p_period  ne ?) THEN
      {&OUT} '<BR>':U
         format-text ('(':U + STRING(p_period, 
           (IF p_period > 2 THEN ">>>,>>>,>>9":U ELSE ">>>,>>>,>>9.99":U) ) + ' min.~)',
            "HighLight":U)
         '</CENTER></TD></TR>~n':U.
    ELSE
      {&OUT} "</TD></TR>~n":U.

    h = h:NEXT-SIBLING.
  END.
  
  {&OUT} 
    '</TABLE>~n':U
    '</CENTER>~n':U
    '</BODY>~n':U
    '</HTML>~n':U.
  
END PROCEDURE.
&ANALYZE-RESUME
 

