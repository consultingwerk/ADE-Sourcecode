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

  File: util/_dirlist.w

  Description: List the files (in a directory) that match the relevant
               filespec.

  Input Parameters:
    p_dirname -- The name of the directory.
    p_filter --  The MATCH expression. with the following changes:
                    ? is the match any one character
                    . is a period
                    * many one or more charactrs
    p_ldir   --  TRUE if only directories are looked at
    p_html -- If this is not blank, then all files will be output with
              this as a form. Within the p_html expression, the
              following values are substituted:
                &1 -- html-encoded version of the file name and extension (optionally cleaned)
                &2 -- html-encoded version of FULL-PATHNAME of the directory (including trailing "/")
                &3 -- html-encoded directory as passed to the procedure (i.e. p_dirname)
                &4 &5 &6- the url-encoded versions of 1, 2
                &6 &7 - the html-encoded versions of 1, 2, and 3

              For example, if you wanted to process the file including "/"
              then you would set p_href to
                '<A HREF ="list.w?file=&5&2">&1</A>'
              If this is blank, then the name will be used standalone (as if
              p_html was "&1".
              
              The following will work as well:
                '<INPUT TYPE="CHECKBOX" NAME="choices" VALUE="&1">&1'
                   -- this will create a checkbox for every field
                '<OPTION>&1'
                   -- this will create a list of OPTIONS (when inside a SELECT)
    p_leader  -- if at least one item is found, lead with this            
    p_trailer -- if at least one item is found, close with this            
    p_empty -- if nothing is found, then this string is output
               (if it is ? or "", then nothing is returned).            
    p_table -- Table Parameters (or "" if not a table).
                 -- this should be a list of up-to-four items
                      # or columns
                      table border
                      cellpadding
                      cellspacing
                    eg. "5,0,0,2"
    p_options -- A comma-delimited list of options 
                  no-dot -- don't show the "." or ".." directories.
                  Clean-Name -- don't show extension on file names and replace "_" with spaces
 
  Output Parameters:
    p_count -- the number of matching items found.

  Author: Wm. T. Wood

  Created: Oct. 26, 1996 

  Modifications  Support multiple filters.  p_filter may     nhorn 1/13/97 
		 contain multiple filters delimited by ";"

------------------------------------------------------------------------*/
/*           This .W file was created with WebSpeed WorkBench.          */
/*----------------------------------------------------------------------*/

/* Parameters Definitions ---                                           */
DEFINE INPUT  PARAMETER p_dirname   AS CHAR NO-UNDO.
DEFINE INPUT  PARAMETER p_filter    AS CHAR NO-UNDO.
DEFINE INPUT  PARAMETER p_ldir      AS LOGICAL NO-UNDO.
DEFINE INPUT  PARAMETER p_html      AS CHAR NO-UNDO.
DEFINE INPUT  PARAMETER p_leader    AS CHAR NO-UNDO.
DEFINE INPUT  PARAMETER p_trailer   AS CHAR NO-UNDO.
DEFINE INPUT  PARAMETER p_empty     AS CHAR NO-UNDO.
DEFINE INPUT  PARAMETER p_table     AS CHAR NO-UNDO.
DEFINE INPUT  PARAMETER p_options   AS CHAR NO-UNDO.
DEFINE OUTPUT PARAMETER p_count     AS INTEGER NO-UNDO.
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

/* ************************  Local Definitions  ************************ */

DEFINE VARIABLE dirpath      AS CHAR NO-UNDO.
/* Read the entire directory and store it in a temp-table. The Primary index 
   on 'name' should not be UNIQUE, since this prevents us from seeing, for 
   example, both 'apple.w' and '[a-umlaut]pple.w' (97-08-13-029). */
DEFINE TEMP-TABLE tt NO-UNDO
  FIELD name     AS CHARACTER CASE-SENSITIVE
  FIELD sort-fld AS CHARACTER                        
  INDEX name     IS PRIMARY /*UNIQUE*/ name
  INDEX sort-fld sort-fld ASCENDING.
  
/* Define a query on this temp-table. */
DEFINE QUERY dir-query FOR tt SCROLLING.

/* Define a stream for inputting OS-DIR. */
DEFINE STREAM instream. 

/* ************************  Main Code Block  *********************** */

/* Get the full pathname for the directory. Blank p_dirname counts as
   the current directory. */
ASSIGN 
  FILE-INFO:FILE-NAME = (IF p_dirname eq "":U THEN ".":U ELSE p_dirname)
  dirpath             = FILE-INFO:FULL-PATHNAME.
  
IF dirpath eq ? OR (NOT FILE-INFO:FILE-TYPE BEGINS "D":U) THEN RETURN.
ELSE DO:
  /* Make sure the directory path used portable slashes, and ends in a slash. */
  ASSIGN
    dirpath = REPLACE (dirpath, '~\':U, '~/':U)
    dirpath = RIGHT-TRIM(dirpath, '~/':U) + '~/':U.
  
  /* Read the contents of this directory. */
  RUN read-dir (dirpath).

  /* Output the file list. */
  /*OPEN QUERY dir-query FOR EACH tt.*/
  &IF "{&OPSYS}":U eq "WIN32":U &THEN 
    /* Sort alphabetically, case-insensitive for Windows users */
    OPEN QUERY dir-query FOR EACH tt USE-INDEX sort-fld.
  &ELSE
    /* Sort alphabetically, case-sensitive for UNIX users */
    OPEN QUERY dir-query FOR EACH tt.
  &ENDIF
  
  RUN out-dir-query.
  
END.
&ANALYZE-RESUME
/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _CODE-BLOCK _PROCEDURE out-dir-query 
PROCEDURE out-dir-query :
/*------------------------------------------------------------------------------
  Purpose:     Output the contents of the directory query to the WEB.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cnt          AS INTEGER NO-UNDO.
  DEFINE VARIABLE fname        AS CHAR    NO-UNDO.
  DEFINE VARIABLE iCol         AS INTEGER NO-UNDO.
  DEFINE VARIABLE l_clean      AS LOGICAL NO-UNDO.
  DEFINE VARIABLE l_table      AS LOGICAL NO-UNDO.
  DEFINE VARIABLE numColumns   AS INTEGER NO-UNDO INITIAL 0.
  DEFINE VARIABLE tBorder      AS CHAR    NO-UNDO INITIAL "0".
  DEFINE VARIABLE tCellpadding AS CHAR    NO-UNDO INITIAL "0".
  DEFINE VARIABLE tCellspacing AS CHAR    NO-UNDO INITIAL "0".
  
  /* Variables to hold html and url encoded versions of character strings. */
  DEFINE VARIABLE h_dirname    AS CHAR NO-UNDO.
  DEFINE VARIABLE u_dirname    AS CHAR NO-UNDO.
  DEFINE VARIABLE h_dirpath    AS CHAR NO-UNDO.
  DEFINE VARIABLE u_dirpath    AS CHAR NO-UNDO.

  GET FIRST dir-query.
  IF NOT AVAILABLE (tt) THEN DO:
    /* No files match the file. */
    IF p_empty ne ? THEN {&OUT} p_empty.
  END.
  ELSE DO:
    /* Output the header. */
    IF p_leader ne ? THEN {&OUT} p_leader.

    /* Check options. */
    IF LOOKUP("Clean-Name", p_options) > 0 THEN l_clean = yes.
    
    /* Parse the table columns. */
    cnt = NUM-ENTRIES(p_table).
    IF cnt > 1 THEN DO:
      ASSIGN numColumns = INTEGER (TRIM (ENTRY(1, p_table))) NO-ERROR.
      IF NOT ERROR-STATUS:ERROR THEN DO:
        l_table = yes.
        IF cnt >= 2 THEN tBorder      = TRIM(ENTRY(2, p_table)).
        IF cnt >= 3 THEN tCellpadding = TRIM(ENTRY(3, p_table)).
        IF cnt >= 4 THEN tCellspacing = TRIM(ENTRY(4, p_table)).
      END. /* IF NOT...ERROR... */
    END. /* IF cnt > 1 ... */
    
    /* Encode the values that won't change over the list. */
    ASSIGN h_dirname = html-encode (p_dirname)
           u_dirname = url-encode  (p_dirname, "QUERY":U)
           h_dirpath = html-encode (dirpath)
           u_dirpath = url-encode  (dirpath, "QUERY":U)
           .

    /* Is this a multi-column table? */
    IF numColumns > 0 THEN
      {&OUT} SUBSTITUTE 
             ('<TABLE BORDER = "&1" CELLPADDING="&2" CELLSPACING="&3">~n',
              tBorder, tCellpadding, tCellspacing).
    
    DO WHILE AVAILABLE (tt):
      /* Remember the count of matching items. */
      p_count = p_count + 1.
      /* Clean up filename (if necessary). */
      IF NOT l_clean THEN fname = tt.name.
      ELSE DO:
        fname = REPLACE (ENTRY(1, tt.name, ".":U), "_":U," ":U).
      END.
      /* Is this a multi-column table? If so, use a table. */
      IF l_table 
      THEN {&OUT} IF iCol eq 0 THEN '<TR><TD>' ELSE '<TD>'.
      IF p_html ne '':U THEN
        {&OUT} 
          SUBSTITUTE(p_html, html-encode(fname), h_dirpath, h_dirname,
                     url-encode(tt.name,"QUERY":U), u_dirpath, u_dirname).
      ELSE 
        {&OUT} 
          html-encode(fname) ~n.
          
      /* Close Table cell/row. */
      IF l_table THEN DO:
        iCol = iCol + 1.
        IF iCol eq numColumns THEN iCol = 0.
        {&OUT} IF iCol eq 0 THEN '</TD></TR>~n' ELSE '</TD>'.
      END.
      
      /* Get the next one. */
      GET NEXT dir-query.
    END. /* DO WHILE AVAILABLE (tt):... */

    /* Close the table? */
    IF l_table THEN {&OUT} '</TABLE>~n'.
    
    /* Output the trailer. */
    IF p_trailer ne ? THEN {&OUT} p_trailer.

  END. /* IF..AVAILABLE tt... */
  
END PROCEDURE.
&ANALYZE-RESUME
&ANALYZE-SUSPEND _CODE-BLOCK _PROCEDURE read-dir 
PROCEDURE read-dir :
/*------------------------------------------------------------------------------
  Purpose:     Input the OS-DIR and create the temp-table of files in the
               directory. 
  Parameters:  p_dir (CHAR) directory to read
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p_dir AS CHAR NO-UNDO.
 
  DEFINE VAR l_no-dot  AS LOGICAL NO-UNDO.
  DEFINE VAR next-name AS CHAR    NO-UNDO.
  DEFINE VAR next-path AS CHAR    NO-UNDO.
  DEFINE VAR next-type AS CHAR    NO-UNDO.
  DEFINE VAR profilter AS CHAR    NO-UNDO.
  DEFINE VAR i         AS INTEGER NO-UNDO.

  /* Check passed in options. */
  IF p_ldir AND LOOKUP("no-dot":U, p_options) > 0 THEN l_no-dot = yes.

  /* Convert the input filter into a PROGRESS 4GL MATCHES filter. */
  IF p_filter ne ? THEN  
    ASSIGN profilter = REPLACE (p_filter,  '.':u, CHR(10))
           profilter = REPLACE (profilter, '?':U, '.':U)
           profilter = REPLACE (profilter, CHR(10), '~~.')
           .
           
  /* Output the datafile. */ 
  INPUT STREAM instream FROM OS-DIR(p_dir) NO-ECHO.
  Read-Block:
  REPEAT ON ENDKEY UNDO Read-Block, LEAVE Read-Block:
    IMPORT STREAM instream next-name next-path next-type.
    /* Exclude files that don't match the filter or are the wrong type (D or F)
       or contain "dots" if the user wants no-dots for directories. */
    IF (profilter eq "":U ) THEN DO: 
      IF ((INDEX (next-type, "D") > 0) eq p_ldir) AND
         NOT (p_ldir AND l_no-dot AND (LEFT-TRIM(next-name, '.':U) eq '':U))
      THEN DO:
        CREATE tt.
        ASSIGN 
          tt.name     = next-name
          tt.sort-fld = LC(next-name).
          
      END. /* IF profilter eq "" */
    END.
    ELSE DO:
      DO i=1 TO NUM-ENTRIES(profilter, ";"):
        IF (LC(next-name) MATCHES LC(ENTRY(i,profilter, ";")) ) AND 
          ((INDEX (next-type, "D") > 0) eq p_ldir) AND 
          NOT (p_ldir AND l_no-dot AND (LEFT-TRIM(next-name, '.':U) eq '':U)) 
        THEN DO:
          CREATE tt.
          ASSIGN 
            tt.name     = next-name
            tt.sort-fld = LC(next-name).
        END.
      END.
    END. /* IF profilter ne "":U ... */
  END. /* Read-Block: */
  
  INPUT STREAM instream CLOSE.
  
END PROCEDURE.
&ANALYZE-RESUME
