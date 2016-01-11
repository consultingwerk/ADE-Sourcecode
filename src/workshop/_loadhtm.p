&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r2 GUI
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

  File: _loadhtm.p

  Description: Call tagext32.dll to parse .htm file and pass back a list of
               .htm fields, buttons, and offsets in the .htm file.  
                              
               This file has been processed for DBE and string translation.

  Input Parameters:
               p_proc-id  - Context Id of the Procedure
               p_htmlName - Fully-qualified HTML filename to process

  Output Parameters:
               p_Return - True if load was successful. False otherwise.

  Author: D.M.Adams

  Created: March 1996

------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER p_proc-id  AS INTEGER   NO-UNDO.
DEFINE INPUT  PARAMETER p_htmlName AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER p_Return   AS LOGICAL   NO-UNDO.

/* Shared variables --                                                       */
{ webutil/tagextr.i }       /* TagExtract DLL procedures                     */
{ workshop/htmwidg.i }      /* Design time Web _HTM TEMP-TABLE.              */
{ workshop/objects.i }      /* Web Objects TEMP-TABLE definition             */
{ workshop/uniwidg.i }      /* Universal Widget TEMP-TABLE definition        */
{ workshop/errors.i  }      /* Standard Error handle and procedures          */

DEFINE VARIABLE b-scrap     AS CHARACTER NO-UNDO. /* scrap */
DEFINE VARIABLE c-scrap     AS CHARACTER NO-UNDO. /* scrap */
DEFINE VARIABLE i-scrap     AS INTEGER   NO-UNDO. /* scrap */
DEFINE VARIABLE l-scrap     AS LOGICAL   NO-UNDO. /* scrap */
DEFINE VARIABLE offFile     AS CHARACTER NO-UNDO. /* offset filename */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure



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
         HEIGHT             = 2
         WIDTH              = 40.
                                                                        */
&ANALYZE-RESUME
 



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* Look for offset file with the HTML file */
ASSIGN
  offFile   = SUBSTRING(p_htmlName,1,R-INDEX(p_htmlName,".":U),"CHARACTER":U)
            + "off":U.

/* If offset file not found with the HTML file, then look in the PROPATH */
IF SEARCH(offFile) = ? THEN DO:
  RUN adecomm/_osprefx.p (offFile, OUTPUT b-scrap, OUTPUT c-scrap).
  ASSIGN offFile = SEARCH(c-scrap).

  /* Generate offset file always. */
  IF SEARCH(c-scrap) = ? THEN DO:
    RUN webutil/_genoff.p (p_htmlName, OUTPUT offFile).
    IF offFile eq ? THEN DO:
      RUN Add-Error IN _err-hdl
              ("ERROR":U, ?, "TagExtract could not generate the offset file.").
      RETURN.
    END.
  END.
END.

/* Store the HTML file name in the _P record. */
FIND _P WHERE RECID(_P) eq p_proc-id.
/* Store the PROPATH relative html file path. */
RUN webutil/_relname (p_htmlName, "MUST-BE-REL":U, OUTPUT _P._html-file).
/* If the name is not in propath, just get the file name w/o the path.
   (The directory path will be scrap, just save the file name. */
IF _P._html-file eq ? THEN
  RUN adecomm/_osprefx.p (p_htmlName, OUTPUT c-scrap, OUTPUT _P._html-file).
 
/* Load the HTM records from the offset file. Exit if there were errors.*/
RUN workshop/_rdoffd.p (INPUT p_proc-id, INPUT offFile).
IF RETURN-VALUE eq "Error":U  THEN p_return = FALSE.
ELSE DO: 
 
  /* Draw the Progress objects associated with this file. */
  RUN workshop/_drwhtml.p (p_proc-id, FALSE /* No Messages */, OUTPUT l-scrap).  

  /* To be safe...
     Delete any HTM records that were created, but did not draw an associated
     Progress Widget.  This should never happen, but lets be good citizens. */
  FOR EACH _HTM WHERE _HTM._U-recid eq ?:
    DELETE _HTM.
  END.

  /* Made sure everything is now an HTML Mapping file. */
  IF LOOKUP('Html-Mapping':U, _P._type-list) eq 0 THEN 
    _P._type-list = _P._type-list + ',Html-Mapping':U.

  /* Return successful load output parameter. */
  ASSIGN p_return = TRUE.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* _loadhtm.p - end-of-file */
