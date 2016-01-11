&ANALYZE-SUSPEND _VERSION-NUMBER WDT_v2r1 WebTool
&ANALYZE-RESUME

&ANALYZE-SUSPEND _CODE-BLOCK _CUSTOM Definitions 
/*********************************************************************
* Copyright (C) 2000-2003 by Progress Software Corporation ("PSC"),  *
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
  File: search.w
  
  Description: Searches for a particular file-name in the PROPATH.  R-code
               is searched, as well as .w/.p source fields.

  Parameters:  <none>
  
  Fields: This checks for "FileName" as a CGI field.  If this exists, then 
  	      this message is displayed.  This can therefore be called from 
  	      another URL as:
             URL: .../webtools/searchs.w?FileName=abc.w

  Author:  Wm. T. Wood
  Created: Sept 10, 1996
  
  Modifications:
    adams 01/17/03  Support for .pl files with relative path in PROPATH
    adams 08/19/98  Support for .pl files on UNIX
    adams 06/19/97  UTC and translation support
    nhorn 01/08/97  Added Header and cleaned up HTML

------------------------------------------------------------------------*/
/*           This .W file was created with WebSpeed Workshop.           */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE slash-os  AS CHARACTER NO-UNDO.
DEFINE VARIABLE slash-nos AS CHARACTER NO-UNDO.

&SCOPED-DEFINE debug FALSE
  
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

&ANALYZE-SUSPEND _CODE-BLOCK _PROCEDURE make-Rcode-name 
PROCEDURE make-Rcode-name :
/*------------------------------------------------------------------------------
  Purpose:     Get a file name and turn it into an r-code name.
  Parameters:  fName     -- INPUT the user-entered filename to test
               fPath     -- INPUT the base path 
               rName     -- OUTPUT the r-code name found (or ?)
  Notes:       
    fName is assumed to be using "/" as the directory delimeter.
 ------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER fName     AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER fPath     AS CHARACTER  NO-UNDO.
  DEFINE OUTPUT PARAMETER rName     AS CHARACTER  NO-UNDO INITIAL ?.
   
  DEFINE VARIABLE cEntry     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFirst     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cString    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cOldPath   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cPath      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSearch    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lIsLibrary AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE ipos       AS INTEGER    NO-UNDO.
  DEFINE VARIABLE ix         AS INTEGER    NO-UNDO.

  /* Is there a file extension?  Check only the file name, and not any
     directory entries. */
  ASSIGN
    cString    = (IF NUM-ENTRIES(fName, slash-os) > 1 THEN
                    ENTRY(NUM-ENTRIES(fName, slash-os), fName, slash-os)
                  ELSE fName)
    lIsLibrary = (R-INDEX(fPath,".pl":U) EQ LENGTH(fPath, "CHARACTER":U) - 2).
  
  IF INDEX (cString, ".":U) EQ 0 THEN 
    cString = fName + ".r":U.
  ELSE
    ASSIGN
      ipos    = R-INDEX(fName, ".":U)
      cString = SUBSTRING(fName, 1, ipos - 1, "CHARACTER":U) + ".r":U.

  IF lIsLibrary THEN DO:
    ASSIGN
      cOldPath            = PROPATH
      cPath               = PROPATH
      FILE-INFO:FILE-NAME = ENTRY(1,cPath).
    
    &if {&debug} &then
    {&out} "[search.w] make-Rcode-name<br>fPath " fPath "<br>".
    &endif
      
    IF fPath NE FILE-INFO:FULL-PATHNAME THEN DO:
      /* Temporarily reorder PROPATH to move the .pl file to the beginning of
         the list.  Move the first item to the bottom of the stack, until the
         .pl is the first item.  Then we can use SEARCH to see if file to test
         is a member of this .pl file. */
      DO ix = 1 TO NUM-ENTRIES(cPath):
        ASSIGN
        	FILE-INFO:FILE-NAME = ENTRY(1,cPath)
          cFirst              = FILE-INFO:FULL-PATHNAME
          cPath               = cPath + ",":U + cFirst
          cPath               = SUBSTRING(cPath,INDEX(cPath,",":U) + 1,-1,"CHARACTER":U)
          FILE-INFO:FILE-NAME = ENTRY(1,cPath).
          
        IF fPath EQ FILE-INFO:FULL-PATHNAME THEN DO:
        	ENTRY(1, cPath) = FILE-INFO:FULL-PATHNAME.
        	LEAVE.
        END.
      END.
      PROPATH = cPath.
    END.
    
    ASSIGN
      cSearch = SEARCH(cString)
      PROPATH = cOldPath.

    &if {&debug} &then
    {&out} "cSearch " cSearch "<br><br>" skip.
    &endif
      
    /* Direct hit: rcode found in this .pl file. */
    IF fPath EQ LIBRARY(cSearch) AND cSearch NE ? THEN
      rname = cSearch.
  END. /* lIsLibrary */
  ELSE DO:
    /* Search for the r-code name. */
    ASSIGN
      cString             = fPath + slash-os + cString
      FILE-INFO:FILE-NAME = cString.

    /* Direct hit: rcode found in this directory. */
    IF FILE-INFO:PATHNAME <> ? AND FILE-INFO:PATHNAME = cString THEN 
      rName = cString.
  END.

END PROCEDURE.

&ANALYZE-RESUME

&ANALYZE-SUSPEND _CODE-BLOCK _PROCEDURE process-web-request 
PROCEDURE process-web-request :
/*------------------------------------------------------------------------------
  Purpose:     Process the web request.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE description  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE imsg         AS INTEGER    NO-UNDO.
  DEFINE VARIABLE filename     AS CHARACTER  NO-UNDO.
  
  /* What is the context of this request?  Look at "FileName". */
  RUN GetField IN web-utilities-hdl ('FileName':U, OUTPUT FileName).
  
  /* Output the MIME header */
  RUN outputContentType IN web-utilities-hdl ("text/html":U).  

  ASSIGN   
    slash-os  = (IF OPSYS = "UNIX":U THEN "~/":U ELSE "~\":U)
    slash-nos = (IF OPSYS = "UNIX":U THEN "~\":U ELSE "~/":U).

  {&OUT}
   { webtools/html.i 
      &SEGMENTS = "head,open-body,title-line"
      &TITLE    = "Search PROPATH"
      &AUTHOR   = "Wm.T.Wood"
      &FRAME    = "WS_main" 
      &CONTEXT  = "{&Webtools_Search_Help}" }
      .

  {&OUT}
    '<CENTER>~n':U
    '<FORM METHOD = "POST" ACTION = "search.w" ~n':U
    '      onSubmit="if ((this.FileName.value == ~'~')) ~{ ~n ':U
    '                   window.alert(~'':U 'Please enter a filename.' '~')~; ~n':U
    '                   return false;~n':U
    '                }   "> ~n':U
    format-label ('Find File', 'INPUT':U, "":U) 
    '<INPUT TYPE = "TEXT" NAME = "FileName" SIZE = "30"':U
       (IF FileName NE "" THEN ' VALUE = "':U + FileName + '">~n':U ELSE '>~n':U)
    '<INPUT TYPE = "SUBMIT" VALUE = "':U 'Submit Query' '">~n<BR>~n':U
    '<FONT SIZE="-1">(':U 'Type name as it would appear in a SpeedScript <I>RUN</I> statement. Wildcards are not allowed.' 
    ')</FONT>~n':U
    '</FORM>~n':U
    .
  
  /* Report results of search. */
  IF FileName NE "":U THEN RUN SEARCH(FileName).
   
  {&OUT}
    '</CENTER>~n':U
    '</BODY>~n':U
    '</HTML>':U
     .
  
END PROCEDURE.
&ANALYZE-RESUME

&ANALYZE-SUSPEND _CODE-BLOCK _PROCEDURE search 
PROCEDURE search :
/*------------------------------------------------------------------------------
  Purpose:     Search each entry of PROPATH for a file.  Report each find
               as an HTML list-item.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER fName AS CHARACTER NO-UNDO.
  
  DEFINE VARIABLE cList     AS CHARACTER NO-UNDO.
  DEFINE VARIABLE full-path AS CHARACTER NO-UNDO.
  DEFINE VARIABLE ix        AS INTEGER   NO-UNDO.
  DEFINE VARIABLE num-found AS INTEGER   NO-UNDO.
  DEFINE VARIABLE path-dir  AS CHARACTER NO-UNDO.
  DEFINE VARIABLE rCodeName AS CHARACTER NO-UNDO.
  DEFINE VARIABLE line-item AS CHARACTER NO-UNDO.
  DEFINE VARIABLE plib-item AS CHARACTER NO-UNDO.

  /* Use the UNIX-style separators. */
  ASSIGN 
    line-item = '<LI><A HREF="dirlist.w?filter=&1">&2</A></LI>~n':U
    plib-item = '<LI>&1</LI>~n':U
    fName     = REPLACE(TRIM(fName), slash-nos, slash-os).
  
  /* Look at each item in the PROPATH for the item. */
  IF INDEX(fName,">>":U) EQ 0 AND INDEX(fName,"<<":U) EQ 0 THEN
  DO ix = 1 TO NUM-ENTRIES(PROPATH):
    /* Get the directory out of PROPATH and adjust empty entries. */
    ASSIGN 
      path-dir = ENTRY(ix, PROPATH)
      path-dir = IF path-dir EQ "" THEN ".":U
                 ELSE REPLACE (path-dir,slash-nos,slash-os).
    
    /* Check that the PROPATH entry really exists as a directory. */
    ASSIGN
      FILE-INFO:FILE-NAME = path-dir
      full-path           = FILE-INFO:FULL-PATHNAME.

    IF full-path NE ? THEN DO:
      /* Look for r-code, if it is not already r-code, or if it might be found
         in a .pl file. */
      IF (R-INDEX(fName, ".r":U) NE LENGTH(fName, "CHARACTER":U) - 1) OR
         (R-INDEX(full-path,".pl":U) EQ LENGTH(full-path, "CHARACTER":U) - 2) 
        THEN DO:
        RUN make-RCode-name (fName, full-path, OUTPUT rCodeName).
        IF rCodeName <> ? THEN 
          cList = cList + 
                  (IF rCodeName MATCHES "*<<*>>":U THEN
                     SUBSTITUTE(plib-item,html-encode(rCodeName)) + '~n':U
                   ELSE
                     SUBSTITUTE(line-item,url-encode(rCodeName, "query":U),
                                          html-encode(rCodeName)) + '~n':U).
      END.
      full-path = full-path + slash-os + fName.

      /* Look for the original file name. */
      IF SEARCH(full-path) NE ? THEN 
        cList = cList + SUBSTITUTE(line-item,url-encode(full-path, "query":U),
                                             html-encode(full-path)) + '~n':U.
    END.   
  END.

  /* Report if the file cannot be found. */
  IF cList EQ '' THEN
    {&OUT}
       '<HR><B>':U 'The file' ' ':U format-filename (fName, '&1':U, '') 
       ' ':U 'cannot be found anywhere in your PROPATH.' '</B>~n':U.
  ELSE DO:
    num-found = NUM-ENTRIES(TRIM(cList), '~n':U).
    {&OUT}
      '<HR><B>':U 'The file' ' ':U format-filename (fName, '&1':U, '')
      ' ':U 'can be found at the following<BR>location'
      IF num-found > 1 THEN 's ' ELSE ' ':U
      'in the <FONT COLOR="RED">Web</FONT>Speed PROPATH' ':</B><BR>~n':U
      '<TABLE BORDERS = "0"><TR><TD><OL>~n':U
      cList
      '</OL></TD></TR></TABLE>~n':U
      IF num-found > 1 THEN
        format-text('Note: ', 'Highlight,B':U) + 'The first occurrence will be used when the Web object is run.'
      ELSE ''
      .
  END. /* IF c-list NE ''...*/
  
END PROCEDURE.
&ANALYZE-RESUME
