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

/*------------------------------------------------------------------------
    File        : _rsdocol.p 
    Purpose     : Fetch columns and column properties from a remote 
                  SmartDataObject.
    Syntax      : RUN adeweb/_rsdocol.p ("d-cust.w",
                                         "*",
                                         "Datatype,format",
                                         OUTPUT cProps).

    Description : This calls webutil/_sdoinfo.p on the server. 
                  which starts the SmartDataObject and calls the 
                  columnProps function with PCols and PProps as input 
                  parameters.

    Author(s)   : Haavard Danielsen                   
    Created     : April 1998

Input Parameters: pProc     - Name of SmartDataObject to get properties from 
                  pCols     - Comma separated list with columns . * = ALL. 
                  pProps    - Comma separated list of properties.   
Output Parameters:    
                  pColProps - List of Columns and respective properties.
                              Each columns with properties are CHR(3) separated.
                              Columns and properties       are CHR(4) separated.
    Notes       : Because of the nature of the OCX HTTP communication this has
                  a WAIT-FOR and subsequently cannot be called from a function. 
                  I tried a do while somevariable loop, but that did not catch 
                  the event from the OCX. PROCESS EVENTS is considered a input 
                  blocking statement and cannnot be used from a function either.
                    
------------------------------------------------------------------------*/
/*       This .W file was created with the Progress AppBuilder.         */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
DEFINE INPUT  PARAMETER pProc       AS CHAR NO-UNDO.
DEFINE INPUT  PARAMETER pCols       AS CHAR NO-UNDO.
DEFINE INPUT  PARAMETER pProps      AS CHAR NO-UNDO.
DEFINE OUTPUT PARAMETER pColProps   AS CHAR NO-UNDO.

DEFINE VARIABLE         xFunction AS CHAR NO-UNDO INIT "ColumnProps":U.

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
RUN initializeObject.

Run ConnectServer.

DO ON ERROR UNDO,LEAVE
   ON END-KEY UNDO,LEAVE:
  WAIT-FOR "CLOSE" OF THIS-PROCEDURE.
END.

Run destroyObject.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject Procedure 
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
  DEFINE VARIABLE        hProc      AS HANDLE    NO-UNDO.
  DEFINE VARIABLE        BrokerURL  AS CHAR      NO-UNDO.
  
  /** Must test more before we allow sharing of this 
  hProc = SESSION:FIRST-PROCEDURE.
  DO WHILE VALID-HANDLE(hProc) AND hProc:FILE-NAME NE cHTTPProc:
    hProc = hProc:NEXT-SIBLING.
  END.
  IF NOT VALID-HANDLE(hProc) THEN
  ****/
  
  RUN adeweb/_cihttp.p PERSISTENT SET hProc.
  THIS-PROCEDURE:ADD-SUPER-PROCEDURE(hProc).

  RUN adeuib/_uibinfo.p(?,"SESSION","BrokerURL", OUTPUT BrokerURL).
  
  DYNAMIC-FUNCTION("setBROKERURL", BrokerURL).      
  DYNAMIC-FUNCTION("setParseIncomingdata", true).
  
  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE OCX.FileClosed Procedure 
PROCEDURE OCX.FileClosed :
/*------------------------------------------------------------------------------
  Purpose:    Get the data from the WebServer   
  Parameters: 
  Notes:      This is depending on that ParseURL is set to true. 
------------------------------------------------------------------------------*/
  DEFINE VAR htmText  AS CHAR NO-UNDO.
  DEFINE VAR ErrorMsg AS CHAR NO-UNDO.  

  RUN SUPER NO-ERROR.
  
  IF ERROR-STATUS:ERROR THEN 
    ASSIGN pColProps = "":U.
    
  ELSE  
    ASSIGN
      htmText   = DYNAMIC-FUNCTION("GetHTMLPageTextWithTags")
      pcolProps = ENTRY(3,htmText,CHR(10)).  

  APPLY "CLOSE":U TO THIS-PROCEDURE. 
   
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE OCX.HTTPServerConnection Procedure 
PROCEDURE OCX.HTTPServerConnection :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  Run GetData ("webutil/_sdoinfo.p",
                "?function="     + xFunction
                + "&procedure="  + pProc
                + "&Columns="    + pCols
                + "&Properties=" + pProps ).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

