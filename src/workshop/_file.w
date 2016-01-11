&ANALYZE-SUSPEND _VERSION-NUMBER WDT_v2r1 Web-Object
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
  File: workshop/_file.w

  Description: Defines the FRAMESET and MENU html screens
               used by the "File Info" or "Procedure Settings"
  Parameters:
    p_screen -- Sceen to generate.
      "Frameset"  -- divides the main window into two frames
                     WSFI_header, WSFI_main
      "MainMenu" -- create the main menu (for the header)
    p_2ndContents -- The contents of the second (WSFI_main) frame
                     This will be entered as part of a JavaScript code .

  Fields: this checks for
    file-id : The context ID of the file that is open
          if it is not there then it checks for
    filename: the filename
    directory: the directory where filename is located

  Note:
    Originally, you got a different menu if the file was not open or not.
    However, I changed it so the File Menu is now identical in both cases.

  Author:  Wm. T. Wood
  Created: Dec. 9, 1996
------------------------------------------------------------------------*/
/*           This .W file was created with WebSpeed Workshop.           */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER p_screen      AS CHAR NO-UNDO.
DEFINE INPUT PARAMETER p_2ndContents AS CHAR NO-UNDO.

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE l_editable AS LOGICAL NO-UNDO.

/* Included Definitions ---                                             */
{ workshop/help.i }         /* Help Context Strings.                    */
{ workshop/objects.i }      /* Web Objects TEMP-TABLE definition        */
{ workshop/sharvars.i }     /* Standard shared variables                */

{ webutil/wstyle.i }        /* WebSpeed standard style definitions      */

/* Preprocessor Names ---                                               */

/* Name of the JavaScript Function that will communicate with the
   WebSpeed Editor. */
&Scoped-define SEFunction EditorCommand

&ANALYZE-RESUME
&ANALYZE-SUSPEND _PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Web-Object


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


/* ********************  Additional Definitions  ******************** */

DEFINE VARIABLE c_directory  AS CHAR    NO-UNDO.
DEFINE VARIABLE c_filename   AS CHAR    NO-UNDO.
DEFINE VARIABLE u_fullpath   AS CHAR    NO-UNDO.
DEFINE VARIABLE c_file-id    AS CHAR    NO-UNDO.
DEFINE VARIABLE l_nextLoc    AS LOGICAL NO-UNDO.

/* ************************  Main Code Block  *********************** */

/* Find the current _P record (or create one if the file is new). */
{ workshop/find_p.i 
    &file-id   = "c_file-id"
    &filename  = "c_filename"
    &directory = "c_directory"
}
    
/* Make sure file is specified. */
IF NOT AVAILABLE (_P) THEN DO:
  RUN output-message-page (c_filename, "Deleted":U).
  RETURN.
END.

/* Handle the special case of a closed file that does not exist.
   (You should never get this case, but it is worth catching here) */
IF NOT _P._open AND _P._fullpath eq ? THEN DO:
  /* Delete the _P record. */     
  RUN workshop/_delet_p.p (INTEGER(RECID(_P))).
  /* Show a blank screen. */
  RUN output-blank-page IN THIS-PROCEDURE.  
  RETURN.
END.
         
/* Determine a default. */
IF p_screen eq "" THEN p_screen = "MainMenu":U.
CASE p_screen:
  WHEN "Frameset":U THEN
      IF _P._open 
      THEN RUN workshop/_fileset.w ('file-id=':U + STRING(RECID(_P)), "":U).
      ELSE DO:   
        /* Use the full path as the identifier. */
        RUN UrlEncode IN web-utilities-hdl (_P._fullpath, OUTPUT u_fullpath, "QUERY":U).       
        RUN workshop/_fileset.w ('filename=':U + u_fullpath, "":U).
      END.
  WHEN "MainMenu":U THEN 
      RUN output-MainMenu IN THIS-PROCEDURE.
  OTHERWISE
      RUN htmlError IN web-utilities-hdl ('Invalid HTML page requested:' + p_screen).
END CASE.
&ANALYZE-RESUME
/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _CODE-BLOCK _PROCEDURE check-html-type
PROCEDURE check-html-type :
/*------------------------------------------------------------------------------
  Purpose:     Sees if the stored type-list for the current HTML file needs
               to be updated.  Mostly, we are checking for .off files, or proof
               that the file is mapped.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE c_list AS CHAR NO-UNDO.
  DEFINE VARIABLE c_type AS CHAR NO-UNDO.
  DEFINE VARIABLE ipos   AS INTEGER NO-UNDO.

  /* Get the type list from the file (if it really exists). */
  IF _P._fullpath ne ? THEN DO:
    RUN webtools/util/_filetyp.p (INPUT _P._fullpath, OUTPUT c_type, OUTPUT c_list).
    /* Do we think the file is a "Mapped" html file? */
    ipos = LOOKUP("Mapped":U, _P._type-list).
    /* Is the disk file a "Mapped" html file? */
    IF LOOKUP("Mapped":U, c_list) > 0 THEN DO:
      /* Add the "Mapped" keyword to the saved list, if necessary. */
      IF ipos eq 0 THEN _P._type-list = _P._type-list + ",Mapped":U. 
    END.
    ELSE DO: 
      /* Remove the "Mapped" keyword, if necessary. */
      IF ipos > 0 THEN ENTRY(ipos,_P._type-list) = "":U.
    END.
    /* Clean up the type list. */
    _P._type-list = TRIM(REPLACE(_P._type-list, ",,":U, ",":U), ",":U).
  END.
END PROCEDURE.
&ANALYZE-RESUME
&ANALYZE-SUSPEND _CODE-BLOCK _PROCEDURE output-blank-page 
PROCEDURE output-blank-page :
/*------------------------------------------------------------------------------
  Purpose:     Output a blank page because we have tried to display a
               deleted file.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  /* Output the MIME header and start of page. */
  RUN outputContentType IN web-utilities-hdl ("text/html":U).

  /* Output the web object file information. */
  {&OUT}
    { workshop/html.i &SEGMENTS = "head,open-body"
                      &FRAME    = "WSFI_header" 
                      &AUTHOR   = "Wm.T.Wood"
                      &TITLE    = "Workshop" } 
    '</BODY>~n'
    '</HTML>~n'
    .

END PROCEDURE.
&ANALYZE-RESUME
&ANALYZE-SUSPEND _CODE-BLOCK _PROCEDURE output-mainmenu 
PROCEDURE output-mainmenu :
/*------------------------------------------------------------------------------
  Purpose:     Output the "mainmenu" html page.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE context      AS CHAR    NO-UNDO.
  DEFINE VARIABLE h_fullpath   AS CHAR    NO-UNDO.
 
  /* If a file is TEXT, compute this once because so many things 
     are based on it. */
  IF LOOKUP('TEXT':U, _P._type-list) > 0 THEN l_editable = yes.  

  /* Check the "sub-type" of HTML files in case the user has created (or deleted)
     offset files. */
  IF LOOKUP('HTML':U, _P._type-list) > 0 THEN RUN check-html-type.
       
  /* Output the MIME header and start of page. */
  RUN outputContentType IN web-utilities-hdl ("text/html":U).

  /* Output the web object file information. */
  {&OUT}
    { workshop/html.i &SEGMENTS = "head,open-body"
                      &FRAME    = "WSFI_header" 
                      &AUTHOR   = "Wm.T.Wood"
                      &TITLE    = "File Menu"   
                      &TARGET   = "WSFI_main" } 
                      .
    
  /* This block is used to show more file information (mostly this is for 
     internal debugging purposes.) */ 
  {&OUT}
    '<!-- File Menu Information:~n'
    '  -- ~n'
    '  -- File type: ' _P._type-list SKIP
    '  -- Full path: ' _P._fullpath  SKIP    
    '  -->~n'
    .

  /* Pass context information for the current _P record. */ 
  context = SUBSTITUTE("file-id=&1", RECID(_P)).

  /* Output the contents of the page. */
  {&OUT}
    '<TABLE BORDER="0" WIDTH="100%" CELLPADDING="1" CELLSPACING="0">~n'
    '<TR>~n'
    '    <TD VALIGN="TOP">' format-label-text ('File', _P._filename) '</TD>~n' 
    .
  /* Output the HTML mapping file, if necessary. [NOTE: .w files are "html-mapping",
     the associated .htm is "Mapped". */
  IF LOOKUP ("html-mapping":U, _P._type-list) > 0 
  THEN {&OUT}
     '    <TD VALIGN="TOP" ALIGN="CENTER">' 
     format-label-text ('Maps', IF _P._html-file ne "":U THEN _P._html-file ELSE 'HTML file') 
     '</TD>~n' 
     .
  /* Output the file type. */
  {&OUT}
    '    <TD VALIGN="TOP" ALIGN="RIGHT">'
    format-label-text (
       'Type',   
       ( IF _P._type eq "" THEN 'Unknown' ELSE _P._type) + 
         (IF _P._template THEN ' Template'                       
          ELSE (IF LOOKUP("MAPPED":U, _P._type-list) > 0 THEN ' (Mapped)' ELSE '')))   
    '</TD>~n'
    '</TR></TABLE>~n'
    '<CENTER>~n'
    .

  /* List options -- if a file is not openned, they check that it still exists on disk
     (a new file will be open, but it won't have a _P._fullpath until it is saved). */
  IF (_P._open eq no AND _P._fullpath eq ?) THEN 
    RUN output-message-page (_P._filename, "DELETED":U).
  ELSE IF (_P._type eq "Unsupported":U) THEN
    RUN output-message-page (_P._filename, _P._type).
  ELSE DO:
    /* Available options are based on type. */ 
    IF l_editable THEN DO:      
      /* Place the WebSpeed Editor applet. */
      {&OUT} { workshop/startse.i &P_BUFFER  = "_P" &FUNCTION = "{&SEFunction}" } .
      /* Define a flag that can be set when it is OK to so a Editor Submit. This is not needed
         on previously open files. */
      IF NOT _P._open THEN {&OUT} '<SCRIPT LANGUAGE="JavaScript"> var submitOk=false~; </SCRIPT>~n'. 
      RUN put-link ("Edit":U, context). 
    END.
    IF LOOKUP ("Structured":U, _P._type-list) > 0 
    THEN RUN put-link ("Contents":U, context).

    /* Although we only allow you to EDIT things we are sure are text,
       We will try to let you VIEW anything that is not a binary file. */
    IF LOOKUP ("Binary":U, _P._type-list) eq 0
    THEN RUN put-link ("View":U, context).

    /* Check syntax on 4gl or e4gl files. Allow user to try to check syntax of
       Mapped html files. */
    IF LOOKUP('4GL':U, _P._type-list) > 0 OR LOOKUP('HTML':U, _P._type-list) > 0
    THEN RUN put-link ("CheckSyntax":U, context).

    /* Allow user to map HTML fields on web-objects. */
    IF LOOKUP ("Html-Mapping":U, _P._type-list) > 0
    THEN RUN put-link ("HtmlMap":U, context).  

    /* We don't always know an HTML file is NOT an E4GL file, so allow
       TagMapping. [NOTE: this creates the .off AND a new, untitled Web Object.
       This is NOT the command to TagExtract, which is not available from this menu. */
    IF LOOKUP('HTML':U, _P._type-list) > 0 AND _P._fullpath ne ?
    THEN RUN put-link ("TagMap":U, context). 
    
    /* Allow saving if there are any changes. */          
    IF l_editable THEN DO:
      RUN put-link ("Save":U, context).
      RUN put-link ("SaveAs":U, context).
    END.
    
    /* Allow user to compile any HTML file. */
    IF LOOKUP('HTML':U, _P._type-list) > 0  
    THEN  RUN put-link ("E4GL-Compile":U, context).
    
    IF LOOKUP('4GL':U, _P._type-list) > 0 AND
       LOOKUP('INCLUDE':U, _P._type-list) eq 0 AND
       NOT _P._template 
    THEN RUN put-link ("Compile":U, context).
    
    /* Run 4GL/HTML source, or compiled r-code. */
    IF (LOOKUP ('R-code':U, _P._type-list) > 0)
       OR ((LOOKUP('HTML':U, _P._type-list) > 0 OR LOOKUP('4GL':U, _P._type-list) > 0)
           AND LOOKUP('INCLUDE':U, _P._type-list) eq 0
           AND NOT _P._template)
    THEN RUN put-link ("Run":U, context). 

    /* Delete files that really exist. */
    IF _P._fullpath ne ? THEN
    RUN put-link ("Delete":U, context).   
    
    /* Only files that can be edited can be closed. */
    IF l_editable THEN RUN put-link ("Close":U, context).   
    
    /* Now output the help. */
    {&OUT}  {workshop/html.i &SEGMENTS = "HELP"
                             &FRAME    = "WSFI_header"
                             &CONTEXT  = "{&File_Menu_Bar_Help}" } .

  END. /* IF...full-path [ne] ? ... */  
  
  /* Finish the form. */
  {&OUT}
   '</CENTER>~n'
   '</BODY>~n'
   '</HTML>~n'
   .
  
END PROCEDURE.
&ANALYZE-RESUME
&ANALYZE-SUSPEND _CODE-BLOCK _PROCEDURE output-message-page 
PROCEDURE output-message-page :
/*------------------------------------------------------------------------------
  Purpose:     Output a simple page that says the file is probably deleted.
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p_filename AS CHAR NO-UNDO.
  DEFINE INPUT PARAMETER p_type     AS CHAR NO-UNDO.

  DEFINE VARIABLE msg AS CHAR NO-UNDO.
  
  /* Determine the message. */
  IF p_type eq "Unsupported":U THEN DO:
    msg = 'Workshop cannot work with this file.'.
    IF LOOKUP('Spaces-in-Name':U, _P._type-list) > 0
    THEN msg = msg + ' (The file name contains spaces.)'.
  END.
  ELSE DO:
    /* Deleted file. */
    IF p_filename eq ? OR p_filename eq "":U
    THEN msg = 'This file no longer exists.'.
    ELSE msg = 'The file, &1, no longer exists.'.
    msg = msg + ' It has probably been deleted.'.
  END.

  /* Output the MIME header and start of page. */
  RUN outputContentType IN web-utilities-hdl ("text/html":U).

  /* Output the web object file information. */
  {&OUT}
    { workshop/html.i &SEGMENTS = "head,open-body"
                      &FRAME    = "WS_main" 
                      &AUTHOR   = "Wm.T.Wood"
                      &TITLE    = "File Menu" } 
       
    '<IMG SRC="/webspeed/images/warning.gif" ALIGN="LEFT">~n'    
    /* Now output the help. */
    {workshop/html.i &SEGMENTS = "HELP"
                     &FRAME    = "WS_main"
                     &CONTEXT  = "{&File_Menu_Bar_Help}" } 
    format-filename (p_filename, msg, '':U)
    '</BODY>~n'
    '</HTML>~n'
    .

END PROCEDURE.
&ANALYZE-RESUME
&ANALYZE-SUSPEND _CODE-BLOCK _PROCEDURE put-link 
PROCEDURE put-link :
/*------------------------------------------------------------------------------
  Purpose:     Place a button (or icon) on the page.
  Parameters:  p_button: Name of the action.   
               p_context: the context query string 
                   (eg "filename=temp.p" or "file-id=123"
  Notes:       
------------------------------------------------------------------------------*/   
  DEFINE INPUT PARAMETER p_button  AS CHAR NO-UNDO.  
  DEFINE INPUT PARAMETER p_context AS CHAR NO-UNDO.  
  
  DEFINE VARIABLE action     AS CHAR NO-UNDO.
  DEFINE VARIABLE linkText   AS CHAR NO-UNDO.
  DEFINE VARIABLE linkIcon   AS CHAR NO-UNDO.
  DEFINE VARIABLE linkTarget AS CHAR NO-UNDO.
  DEFINE VARIABLE linkHelp   AS CHAR NO-UNDO.
  DEFINE VARIABLE linkHref   AS CHAR NO-UNDO.
  DEFINE VARIABLE SeCommand  AS CHAR NO-UNDO.
  
  /* Generally speaking, the file action is the same as the button name. */
  action = p_button.
  
  CASE p_button:
    WHEN "CheckSyntax":U THEN 
      ASSIGN linkText  = "Check Syntax"
             linkIcon  = "u-check.gif"
             linkHelp  = "Check the syntax of the WebSpeed 4GL used in this file."
             seCommand = "Submit":U.
    WHEN "Close":U THEN 
      ASSIGN linkText  = "Close"
             linkIcon  = "u-close.gif"
             linkHelp  = "Close the file, after asking to save changes."
             seCommand = "Submit":U. 
    WHEN "Compile":U THEN 
      ASSIGN linkText  = "Compile"
             linkIcon  = "u-compil.gif"
             linkHelp  = "Compile the file and save the r-code in the same directory."
             seCommand = "Submit":U. 
    WHEN "Delete":U THEN 
      ASSIGN linkText = "Delete"
             linkIcon = "u-delete.gif"
             linkHelp = "Delete the file from the project directory.".
    WHEN "Edit":U THEN 
      ASSIGN linkText  = "Edit"
             linkIcon  = "u-edit.gif"
             linkHelp  = "Edit the code for this file in the WebSpeed Editor.".
    WHEN "E4GL-Compile":U THEN 
      ASSIGN action    = "Compile"
             linkText  = "Compile"
             linkIcon  = "u-compil.gif"
             linkHelp  = "Compile the embedded WebSpeed 4GL in this HTML file into r-code."
             seCommand = "Submit":U.
    WHEN "Contents":U THEN 
      ASSIGN action    = "ContentFrameset"
             linkText  = "Contents"  
             linkIcon  = "u-list.gif"
             linkHelp  = "List the code sections and HTML fields in this file.".
    WHEN "HtmlMap":U THEN 
      ASSIGN linkText  = "Map HTML Fields"
             linkIcon  = "u-maphtm.gif":U
             linkHelp  = "Associate all HTML fields with WebSpeed 4GL variables or database fields.".
    WHEN "Run":U THEN 
      ASSIGN linkText  = "Run"
             linkIcon  = "u-run.gif":U
             linkHelp  = "Run the latest saved copy of the file or its compiled r-code."
             seCommand = "Submit":U .
    WHEN "Save":U THEN 
      ASSIGN linkText  = "Save"  
             linkIcon  = "u-save.gif"
             linkHelp  = "Save the file to disk."
             seCommand = "Submit":U.
    WHEN "SaveAs":U THEN 
      ASSIGN linkText  = "Save As"
             linkIcon  = "u-saveas.gif"
             linkHelp  = "Specify a new file name before saving this file."
             seCommand = "Submit":U.
    WHEN "TagMap":U THEN 
      ASSIGN linkText   = "Create Web Object"  
             linkIcon   = "u-html2w.gif":U
             linkTarget = "_parent"
             linkHelp   = "Create a new HTML-mapping web object from this HTML file."
             seCommand  = "Submit":U.
    WHEN "View":U THEN 
      ASSIGN linkText = "View"
             linkIcon = "u-view.gif":U
             linkHelp = "View the contents of the file."
             seCommand = "Submit":U.
  END.
  
  /* Now write out the link. Note the triggers to set the help message and to turn off the
     timer that automatically displays the next location, if one is set. */
  IF linkIcon eq "":U THEN {&OUT} '&nbsp~;['. 
  /* Determine the link's href.  In most cases (except the RUN) this is
     a "fileaction". */
  IF linkHref eq "":U
  THEN linkHref = AppURL + '/workshop/_main.w?html=fileAction~&action=' + action + '&amp~;' + p_context.
  {&OUT}
     '<A HREF="' linkHref '"~n' 
     IF linkTarget ne "":U THEN ('    TARGET="' + linkTarget + '"~n') ELSE ''.  
  /* We want to send a command to the section editor to "submit" changes on most File Menu command.
     However, we only want to do this if the Section Editor is active. We will assume it is active if
     the file is OPEN, or if the edit button is clicked.  For non-open files, add a "submitOk" flag
     that is false until the user clicks "Edit". */
  IF l_editable AND seCommand ne "":U THEN {&OUT}
     '   onClick="' IF _P._open THEN '' ELSE 'if (submitOk) ' '{&SEFunction}(~'' + seCommand + '~')~;"~n'.
  ELSE IF p_button eq "Edit":U AND NOT _P._open THEN  {&OUT}
     '   onClick="submitOk=true~;"~n'.
  /* Always add the MouseOver/MouseOut status help. */
  {&OUT}
     '   onMouseOver="window.status=~'' linkHelp '~'~; return true~;"~n' 
     '   onMouseOut="window.status=~'~'~;">~n'.
  IF linkIcon ne "":U 
  THEN {&OUT}
     '<IMG SRC="/webspeed/images/' linkIcon '" ALT="' linkText '" BORDER="0" ALIGN="CENTER"></A>&nbsp~;~n'.
  ELSE {&OUT} linkText '</A>]~n'.
            
END PROCEDURE.
&ANALYZE-RESUME
 

