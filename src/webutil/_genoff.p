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
**********************************************************************

  File: _genoff.p
  Description: Call TagExtract to parse .htm file and pass back a list of
               .htm fields and offsets in the .htm file.
               
               This file has been processed for DBE and string translation.

  Input Parameters:
     p_htmlpath - CHAR: the fullpath of the HTML file to convert

  Output Parameters:
     p_offpath -  CHAR: the fullpath of the offset file created 
                  (or ? if it fails).

  NOTE:
    Returns "Error":U and sets error messages in the error handle in
    case this fails.
    
  Author: Wm. T. Wood

  Created: 1/97
  Updated: 12/10/97 adams Updated for 9.0a AppBuilder
           2/18/97  adams Added back old adeweb/_genoff.p functionality.
           2/3/97   wood  Removed old adeweb/_genoff.p and replaced it with
                          a call to the standalone tagmap executable.
------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER  p_htmlpath AS CHARACTER NO-UNDO.           /* Fullpath of html file */
DEFINE OUTPUT PARAMETER p_offpath  AS CHARACTER NO-UNDO INITIAL ?. /* Fullpath of offset file */
                            
&IF "{&WINDOW-SYSTEM}" EQ "TTY":U &THEN
{ src/web/method/cgidefs.i }
&ENDIF
{ webutil/tagextr.i }

/* Local variables --                                                        */
DEFINE STREAM _out_offset.

DEFINE VARIABLE code-page      AS CHARACTER NO-UNDO. /* scrap */
DEFINE VARIABLE endLine        AS INTEGER   NO-UNDO. 
DEFINE VARIABLE endOffset      AS INTEGER   NO-UNDO. 
DEFINE VARIABLE htmlField      AS CHARACTER NO-UNDO. /* HTML field name */
DEFINE VARIABLE htmlTag        AS CHARACTER NO-UNDO. /* HTML field tag */
DEFINE VARIABLE htmlType       AS CHARACTER NO-UNDO. /* HTML field type */
DEFINE VARIABLE i-count        AS INTEGER   NO-UNDO. /* scrap counter */
DEFINE VARIABLE l-scrap        AS LOGICAL   NO-UNDO. /* scrap */
DEFINE VARIABLE pFileBase      AS CHARACTER NO-UNDO.
DEFINE VARIABLE ptr-mem-htmfld AS MEMPTR    NO-UNDO. /* HTML field name */
DEFINE VARIABLE ptr-mem-htmtag AS MEMPTR    NO-UNDO. /* HTML field tag */
DEFINE VARIABLE ptr-mem-htmtyp AS MEMPTR    NO-UNDO. /* HTML field type */
DEFINE VARIABLE ptr-mem-wdttyp AS MEMPTR    NO-UNDO. /* WDT field type */
DEFINE VARIABLE ptr-mem-txt    AS MEMPTR    NO-UNDO.
DEFINE VARIABLE rslt           AS INTEGER   NO-UNDO.
DEFINE VARIABLE startLine      AS INTEGER   NO-UNDO. 
DEFINE VARIABLE startOffset    AS INTEGER   NO-UNDO. 
DEFINE VARIABLE tag-file       AS CHARACTER NO-UNDO. 
DEFINE VARIABLE tmp-file       AS CHARACTER NO-UNDO. 
DEFINE VARIABLE wdtType        AS CHARACTER NO-UNDO. /* WDT field type */

/* _UIB-CODE-BLOCK-END */
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

ASSIGN
  /* Look for tagmap.dat, which TagExtract needs to parse HTML fields. */
  tag-file  = SEARCH("tagmap.dat":U)
  /* Set code-page until UI is implemented to prompt for other type. */
  code-page = CAPS(SESSION:CPINTERNAL).
  
IF tag-file = ? THEN DO:
  &IF "{&WINDOW-SYSTEM}" EQ "TTY":U &THEN
  RUN htmlError IN web-utilities-hdl
    ("Tagmap.dat could not be found. Processing aborted.").
  &ELSE
  MESSAGE "Tagmap.dat could not be found. Processing aborted."
    VIEW-AS ALERT-BOX.
  &ENDIF
  RETURN "Error":U.
END.

/* Allocate memory for TagExtract DLL */ 
ASSIGN
  SET-SIZE (ptr-mem-htmfld)      = 256 
  PUT-STRING (ptr-mem-htmfld, 1) = "htmlField":U
  SET-SIZE (ptr-mem-htmtag)      = 256
  PUT-STRING (ptr-mem-htmtag, 1) = "htmlTag":U
  SET-SIZE (ptr-mem-htmtyp)      = 256
  PUT-STRING (ptr-mem-htmtyp, 1) = "htmlType":U
  SET-SIZE (ptr-mem-wdttyp)      = 256
  PUT-STRING (ptr-mem-wdttyp, 1) = "wdtType":U
  pFileBase                      = SUBSTRING(p_htmlpath,1,
                                    R-INDEX(p_htmlpath,".":U),"CHARACTER":U).

/* open .htm file */  
RUN PE_parse (p_htmlpath,tag-file,code-page,OUTPUT rslt) NO-ERROR.

IF rslt = 0 OR ERROR-STATUS:ERROR THEN DO:
  &IF "{&WINDOW-SYSTEM}" EQ "TTY":U &THEN
  RUN htmlError IN web-utilities-hdl 
    ("The TagExtract DLL or one of its components was not found.").
  &ELSE
  MESSAGE "The TagExtract DLL or one of its components was not found."
    VIEW-AS ALERT-BOX.
  &ENDIF
  
  IF OPSYS = "MSDOS":U THEN
    RUN PE_freeProExtract.

  RETURN "Error":U.
END.

/* Recover if we can't create the offset file */
DO ON STOP  UNDO, RETRY 
   ON ERROR UNDO, RETRY:
  IF RETRY THEN DO:
    pFileBase = pfileBase + "off":U.

    &IF "{&WINDOW-SYSTEM}" EQ "TTY":U &THEN
    RUN htmlError IN web-utilities-hdl 
      (SUBSTITUTE ("An error has occurred while writing to &1.  This file cannot be saved until the problem is resolved.",
                   pFileBase)).
  	&ELSE
    MESSAGE SUBSTITUTE ("An error has occurred while writing to &1.  This file cannot be saved until the problem is resolved.",
                        pFileBase)
      VIEW-AS ALERT-BOX.
    &ENDIF
    
    IF OPSYS = "MSDOS":U THEN
      RUN PE_freeProExtract.

    RETURN "Error":U.
  END.

  /* Send any error messages generated while trying to create the offset file 
     to a temp file using the default stream, then delete. If Progress can't 
     create the file, it raises the STOP condition and flushes error messages 
     to the screen, e.q. web stream.  We'll get a corrupt web page and see the 
     Progress error that the file cannot be created. */
  RUN adecomm/_tmpfile.p ("ws":U, ".tmp":U, OUTPUT tmp-file).
  OUTPUT TO VALUE(tmp-file).
  OUTPUT STREAM _out_offset TO VALUE(pFileBase + "off":U).
  OUTPUT CLOSE.
  OS-DELETE VALUE(tmp-file).
END.

PUT STREAM _out_offset UNFORMATTED
  "/* HTML offsets */":U SKIP
  "htm-file= ":U p_htmlpath SKIP
  "version= {&UIB_VERSION}":U SKIP(1).

/* point to first field */
RUN PE_gotoFirstMapableField (OUTPUT rslt).

/* Process each HTML field */
main-loop:
DO WHILE rslt <> 0:
  /* get next field */
  RUN PE_getNextMapableFieldNoText 
    (OUTPUT ptr-mem-htmfld, OUTPUT ptr-mem-wdttyp, OUTPUT ptr-mem-htmtag, 
     OUTPUT ptr-mem-htmtyp, OUTPUT startLine,      OUTPUT startOffset,
     OUTPUT endLine,        OUTPUT endOffset,      OUTPUT rslt).
                           
  ASSIGN
    i-count   = i-count + 1
    htmlfield = GET-STRING (ptr-mem-htmfld, 1)
    htmlTag   = GET-STRING (ptr-mem-htmtag, 1)
    htmlType  = GET-STRING (ptr-mem-htmtyp, 1)
    wdtType   = GET-STRING (ptr-mem-wdttyp, 1)
    .
  /* Write to offset file */
  PUT STREAM _out_offset UNFORMATTED
    'field[':U i-count ']= "':U
    htmlField ',':U
    htmlTag ',':U
    htmlType ',':U
    wdtType ',':U
    startLine ',':U
    startOffset ',':U
    endLine ',':U
    endOffset '"':U SKIP
    .
END. /* DO WHILE */

/* Add blank line. */
PUT STREAM _out_offset UNFORMATTED " ":U SKIP.
OUTPUT STREAM _out_offset CLOSE.
  
/* Deallocate memory used by tagext32.dll */ 
ASSIGN
  SET-SIZE (ptr-mem-htmfld) = 0
  SET-SIZE (ptr-mem-htmtyp) = 0
  SET-SIZE (ptr-mem-htmtag) = 0
  SET-SIZE (ptr-mem-wdttyp) = 0
  SET-SIZE (ptr-mem-txt)    = 0.

/* Free the 16-bit tagext16.dll. */
IF OPSYS = "MSDOS":U THEN
  RUN PE_freeProExtract.

/* Return the new offset file (or ? if it does not exist) */
ASSIGN 
  FILE-INFO:FILE-NAME = pFileBase + "off":U 
  p_offpath           = FILE-INFO:FULL-PATHNAME
  .  

RETURN.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* _genoff.p - end of file */
