&ANALYZE-SUSPEND _VERSION-NUMBER WDT_v2r12 WebTool
/* Maps: HTML */
&ANALYZE-RESUME
&ANALYZE-SUSPEND _CODE-BLOCK _CUSTOM Definitions 
/*********************************************************************
* Copyright (C) 2005 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*
  File: _weblist.w
  
  Description: List the files in a remote Web directory. If no directory 
               is specified then use the current directory.
  Parameters:  <none>
  
  Fields: This checks for the following CGI fields:
  
    directory: The directory to search. This can be relative to PROPATH.
               The default is ".".
    filter: the file filter to use in searching
    
  Author:  D.M.Adams, Wm.T.Wood
  Created: November 1997

  Modifications:  
   hdaniels 08/17/98  Quote directory name (support long filenames)  
   hdaniels 07/18/98  1. Added logic to use filter as directory also when
                         there is no slash in filter.  This was done to 
                         support windows functionality in adeweb/_webfile.w.
                      2. Return ? if entered directory is a file.  "dlc/get/"
                         would be returned as dir even if get is a file. 
                         
   nhorn    01/08/97  Cleaned up HTML, add style, consistency changes.
   nhorn    01/15/97  Multiple file selection
   wood     04/20/97  Use "*" as the "All File" filter on NT               
------------------------------------------------------------------------*/
/*           This .W file was created with WebSpeed WorkBench.          */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE counter      AS INTEGER   NO-UNDO.
DEFINE VARIABLE dirpath      AS CHARACTER NO-UNDO.
DEFINE VARIABLE filter       AS CHARACTER NO-UNDO.
DEFINE VARIABLE iFiles       AS INTEGER   NO-UNDO.
DEFINE VARIABLE isIE         AS LOGICAL   NO-UNDO.
DEFINE VARIABLE lEditor      AS LOGICAL   NO-UNDO.
DEFINE VARIABLE optList      AS CHARACTER NO-UNDO.

/* Read the entire directory and store it in a temp-table. */
DEFINE TEMP-TABLE tt NO-UNDO
  FIELD name   AS CHARACTER 
  FIELD is-dir AS LOGICAL
  FIELD iSeq   AS INTEGER
  FIELD x-row  AS INTEGER
  FIELD y-col  AS INTEGER
  
  INDEX name   IS PRIMARY is-dir name
  INDEX iSeq   iSeq
  INDEX coord  x-row y-col.
  
/* Define a stream for inputting OS-DIR. */
DEFINE STREAM instream. 

/* Included Files ---                                                   */
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
  DEFINE VARIABLE directory     AS CHARACTER NO-UNDO.
  DEFINE VARIABLE dft-filter    AS CHARACTER NO-UNDO
    INITIAL "*.w~;*.p~;*.i~;*.htm*":U.

  DEFINE VARIABLE workshop-file AS CHARACTER NO-UNDO
    INITIAL "workshop/_main.*":U.
  DEFINE VARIABLE iPos          AS INTEGER   NO-UNDO.
  DEFINE VARIABLE iCol          AS INTEGER   NO-UNDO.
  DEFINE VARIABLE iCols         AS INTEGER   NO-UNDO.
  DEFINE VARIABLE iCount        AS INTEGER   NO-UNDO. /* scrap */
  DEFINE VARIABLE iRemainder    AS INTEGER   NO-UNDO.
  DEFINE VARIABLE iRow          AS INTEGER   NO-UNDO.
  DEFINE VARIABLE iSeq          AS INTEGER   NO-UNDO.
  DEFINE VARIABLE ix            AS INTEGER   NO-UNDO.
  DEFINE VARIABLE iy            AS INTEGER   NO-UNDO.
  DEFINE VARIABLE slash-os      AS CHARACTER NO-UNDO.
  DEFINE VARIABLE slash-nos     AS CHARACTER NO-UNDO.
  DEFINE VARIABLE tdIndent      AS CHARACTER NO-UNDO INITIAL "    ":U.
  DEFINE VARIABLE trIndent      AS CHARACTER NO-UNDO INITIAL "  ":U.
    
  /* Output the MIME header. */
  RUN outputContentType IN web-utilities-hdl ("text/plain":U).  
  {&out} "<!-- Generated by Webspeed: http://www.webspeed.com/ -->~n~n" .
 
  ASSIGN
    filter    = get-field("filter":U)
    directory = get-field("directory":U)
    optList   = get-field("options":U)
    lEditor   = CAN-DO(optList,"editor":U).
      
  IF filter eq "":U    THEN filter    = dft-filter. 
  IF directory eq "":U THEN directory = ".":U.

  /* If the filter contains a directory name, add it to the directory. */
  ASSIGN 
    slash-os  = (IF OPSYS = "UNIX":U THEN "~/":U ELSE "~\":U)
    slash-nos = (IF OPSYS = "UNIX":U THEN "~\":U ELSE "~/":U)
    filter    = REPLACE(filter, slash-nos, slash-os) 
    iPos      = R-INDEX(filter, slash-os).
    
  IF iPos > 0 THEN DO:
    /* If the filter starts with '/' then go to the root directory. */
    IF SUBSTRING(filter, 1, 1, "CHARACTER":U) eq slash-os THEN 
      directory = slash-os.
    /* Add the directory part of the filter to the directory. */
    directory = (IF directory eq ".":U THEN "" ELSE
                  RIGHT-TRIM(directory, slash-os) + slash-os)
              + TRIM(SUBSTRING(filter, 1, iPos, "CHARACTER":U), slash-os).
    /* Remove the directory from the filter. */
    IF LENGTH(filter, "CHARACTER":U) eq iPos THEN filter = "".
    ELSE filter = SUBSTRING (filter, iPos + 1, -1, "CHARACTER":U).
  END.
  
  /* If first filter without slash is a directory add this to the directory */ 
  FILE-INFO:FILE-NAME =  RIGHT-TRIM(directory, slash-os) + slash-os
                         + ENTRY(1,filter,";").
  
  IF FILE-INFO:FILE-TYPE BEGINS "D" THEN DO:
    ASSIGN directory = FILE-INFO:FILE-NAME.   
    
    /* If list of filters remove the one with the directory */
    IF NUM-ENTRIES(filter,";":U) > 1 THEN  
      filter = LEFT-TRIM(filter, ENTRY(1,filter,";":U) + ";":U).
    ELSE IF filter = "":U THEN 
      filter = dft-filter. 
  END.
 
  /* Get the remote, full directory path. */
  ASSIGN 
    directory           = ".":U WHEN (directory eq ?)
    FILE-INFO:FILE-NAME = directory 
    dirpath             = FILE-INFO:FULL-PATHNAME
    iPos                = R-INDEX(dirpath, slash-os).
   
  /* Make sure a filename not is returned as a directory.
    (This only happens if a slash is entered behind the filename)       
  */   
        
  IF iPos > 0 AND NOT FILE-INFO:FILE-TYPE BEGINS "D":U THEN
    ASSIGN dirpath  = ?.
           
  /* Output a blank line, then a list of directories and files. The blank line
     signifies success.  If an error is generated, the error message response
     will start on this line.  Add quotes to support long filenames. The 
     concatination is intentionall so that ? dirpath returns "?" */
  IF NOT lEditor THEN
    {&OUT} CHR(10) '"' + dirpath + '"' CHR(10).

  /* Get the full pathname for the directory. Blank p_dirname counts as the
     current directory. */
  ASSIGN 
    FILE-INFO:FILE-NAME = (IF dirpath eq "":U THEN ".":U ELSE dirpath)
    dirpath             = FILE-INFO:FULL-PATHNAME.
  IF dirpath eq ? OR (NOT FILE-INFO:FILE-TYPE BEGINS "D":U) THEN RETURN.
  ELSE DO:
    /* Make sure the directory path used portable slashes, and ends in a slash. */
    ASSIGN
      dirpath = REPLACE (dirpath, '~\':U, '~/':U)
      dirpath = RIGHT-TRIM(dirpath, '~/':U) + '~/':U
      iFiles  = 0.
  
    /* Read the contents of this directory. */
    RUN read-dir (dirpath).

    /* Output table cell coordinate data for the Editor WebTool. */
    IF lEditor THEN DO:
      iCols = TRUNCATE(iFiles / 8, 0).
      
      /* Check for partially filled columns. */
      IF (iFiles MODULO 8) > 0 THEN
        iCols = iCols + 1.
      
      /* Set the sequence counter tt.iSeq for each file. */
      FOR EACH tt BY (NOT tt.is-dir) BY tt.name /* WHERE NOT tt.is-dir */ :
        ASSIGN
          iCount     = iCount + 1
          tt.iSeq    = iCount.
      END.
      iCount = 0.
    
      /* Set the table cell row-col coordinates. */
      DO iy = 1 TO iCols:  /* columns */
        DO ix = 1 TO 8:    /* rows    */
          FIND tt WHERE tt.iSeq = ix + ((iy - 1) * 8) NO-ERROR.
          IF AVAILABLE tt THEN DO:

            ASSIGN
              tt.x-row = ix
              tt.y-col = iy.
          END.
        END.
      END.
    
      /* Set the web browser flags. */
      IF INDEX(get-cgi('HTTP_USER_AGENT':U), " MSIE ":U) > 0 THEN
        isIE = TRUE.
  
      /* Output the web page header stuff. */
      {&OUT}
        '<HTML>':U SKIP
        '<HEAD>':U SKIP
        '<STYLE TYPE="text/css">':U SKIP
        '  ILAYER ~{ position:absolute; font-family:sans-serif; font-size:9pt } ':U SKIP
        '  TD     ~{ font-family:sans-serif; font-size:8pt } ':U SKIP
        '</STYLE>':U SKIP
        '<SCRIPT LANGUAGE="JavaScript1.2" SRC="' RootURL '/script/common.js">':U SKIP
        '  document.write("Included common.js file not found.");':U SKIP
        '</SCRIPT>':U SKIP
        '<SCRIPT LANGUAGE="JavaScript1.2" SRC="' RootURL '/script/weblist.js">':U SKIP
        '  document.write("Included weblist.js file not found.");':U SKIP
        '</SCRIPT>':U SKIP
        '</HEAD>':U SKIP
        '<BODY onLoad="init()">':U SKIP
        '<SCRIPT LANGUAGE="JavaScript1.2">':U SKIP
        '  var cNewDir = "' dirpath '";':U SKIP
        '</SCRIPT>':U SKIP.
        
      IF isIE THEN
        {&OUT}
          '<FORM ID="flist0" onSubmit="autoGo()">':U SKIP
          '<TABLE ID="fileList" STYLE="position:absolute" BGCOLOR="white">':U SKIP.
        
      /* Output the cell data for each IE TABLE row or Nav LAYER. */
      DO iRow = 1 TO 8:
        /* Create new row */
        IF isIE THEN
          {&OUT} '  <TR ID="row':U iRow '">':U SKIP.
        ELSE
          {&OUT} '<LAYER NAME="row':U iRow '" VISIBILITY="hide" TOP='
                 (((iRow - 1) * 18) + 5) '>':U SKIP.
        
        DO iCol = 1 TO iCols:
          FIND tt WHERE tt.x-row = iRow AND tt.y-col = iCol NO-ERROR.
          IF AVAILABLE tt THEN DO:
            IF isIE THEN
              {&OUT} '    <TD onClick="updateName(this)" onDblClick="dblClick(this)">':U 
                     '<NOBR>' tt.name '&nbsp;&nbsp;&nbsp;</NOBR></TD>':U SKIP.
            ELSE
              {&OUT} '  <ILAYER NAME="' tt.name '">':U tt.name 
                     '</ILAYER></TD>':U SKIP.
          END.
          ELSE IF isIE THEN
            {&OUT} '    <TD>&nbsp;</TD>':U SKIP.
        END. /* columns */
        
        /* Close the TABLE row or LAYER. */
        IF isIE THEN
          {&OUT} trIndent '</TR>':U SKIP.
        ELSE
          {&OUT} '</LAYER>':U SKIP.
      END. /* rows */
      
      /* Close the TABLE. */
      IF isIE THEN
      {&OUT} 
        '</TABLE>':U SKIP
        '</FORM>':U SKIP.
      ELSE
      {&OUT} 
        '<LAYER NAME="dummy">'
        '<TABLE WIDTH=' (iCols * 120) '><TR><TD>&nbsp;</TD></TR></TABLE>'
        '</LAYER>':U SKIP.
        
      {&OUT}
        '</BODY>':U SKIP
        '</HTML>':U.
        
    END. /* Editor WebTool */
    
    ELSE DO:
      FOR EACH tt:
        counter = counter + 1.
    
        IF counter > 1 THEN
          {&OUT} CHR(10). 
      
        {&OUT} '"':U tt.name '"':U (IF tt.is-dir THEN ' D':U ELSE ' F':U).
      END.
    END.
  END.

  /* Output an extra blank line, since Progress has a problem reading the last
     line of a file. */
  {&OUT} CHR(10) CHR(10).

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
  DEFINE INPUT PARAMETER p_dir AS CHARACTER NO-UNDO.
 
  DEFINE VARIABLE tmpFilter AS CHARACTER NO-UNDO.
  DEFINE VARIABLE next-name AS CHARACTER NO-UNDO.
  DEFINE VARIABLE next-path AS CHARACTER NO-UNDO.
  DEFINE VARIABLE next-type AS CHARACTER NO-UNDO.
  DEFINE VARIABLE proFilter AS CHARACTER NO-UNDO.
  DEFINE VARIABLE ix        AS INTEGER   NO-UNDO.

  /* Convert the input filter into a PROGRESS 4GL MATCHES filter. */
  IF filter ne ? THEN  
    ASSIGN 
      proFilter = REPLACE (filter,  '.':u, CHR(10))
      proFilter = REPLACE (proFilter, '?':U, '.':U)
      proFilter = REPLACE (proFilter, CHR(10), '~~.').
           
  /* Create ".." entry if we're NOT at the root directory level. */
  IF lEditor THEN DO:
    CREATE tt.
    ASSIGN
      tt.name   = ".."
      tt.is-dir = TRUE
      iFiles    = iFiles + 1.
  END.
    
  /* Output the datafile. */ 
  INPUT STREAM instream FROM OS-DIR(p_dir) NO-ECHO.

  Read-Block:
  REPEAT ON ENDKEY UNDO Read-Block, LEAVE Read-Block:
    IMPORT STREAM instream next-name next-path next-type.
    IF next-name = ".":U OR next-name = "..":U THEN NEXT.
    
    DO ix = 1 TO NUM-ENTRIES(proFilter,";":U):
      tmpFilter = ENTRY(ix, proFilter,";":U).
      IF INDEX(next-type,"D":U) > 0 OR (INDEX(next-type,"F":U) > 0 AND
        (tmpFilter EQ "":U OR LC(next-name) MATCHES LC(tmpFilter))) THEN DO:

        IF lEditor AND (INDEX(next-type,"D":U) > 0) AND ix = 1 THEN
          next-name = next-name + "&nbsp;(DIR)".
        IF CAN-FIND(FIRST tt WHERE tt.is-dir EQ (INDEX(next-type,"D":U) > 0)
          AND tt.name MATCHES next-name) THEN NEXT.
        
        CREATE tt.
        ASSIGN
          tt.name   = next-name
          tt.is-dir = (INDEX(next-type,"D":U) > 0)
          ifiles    = iFiles + (IF (tt.is-dir AND NOT lEditor) THEN 0 ELSE 1).
      END.
    END.
  END. /* Read-Block: */
  
  INPUT STREAM instream CLOSE.
  
END PROCEDURE.
&ANALYZE-RESUME
