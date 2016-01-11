/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
  &IF FALSE &THEN
  /* ------------------------------------------------------------------------
   *  startse.i -- Include file for the StartSE Applet 
   *
   * This include file holds all the common code needed to include the
   * StartSE applet in an HTML frame. 
   *
   * NOTE: These comments are in an IF FALSE block to prevent them from
   * showing up in any preprocessor listing.
   *
   * Author: Wm. T. Wood    Created: 4/16/97
   *
   *   Modifications:  neh 6/13/97   Added HTTP_Authorization if not ""
   * ------------------------------------------------------------------------ 
   */
     
  /* ------------------------------------------------------------------------
     Include the applet --
        This passes the two cookies: one for WSEU, and one for workshop/_main.w
        so it must be included in a file that defines _h_tool (via sharvars.i)

     Arguments:
         BUTTON      -- if YES (non-'') then make the applet big enough to hold
                        a "Pop SE to top" button.
         P_BUFFER    -- the name of the _P buffer. Optional only for DoCommand=CloseAll
         CODE_BUFFER -- [optional] the _code buffer to use in the Section-ID
         DoCommand   -- [optional] Any initial DoCommand action (as a variable)
   ------------------------------------------------------------------------ */ 
  &ENDIF 
    '<APPLET CODEBASE="/webspeed/workshop/" CODE="StartSE.class" NAME="SeApplet" ~n' &IF "{&BUTTON}" eq "" &THEN
    '        WIDTH=2 HEIGHT=2>~n' &ELSE
    '        WIDTH=200 HEIGHT=32>~n' &ENDIF &IF "{&P_BUFFER}" ne "" &THEN
    '<PARAM name="Filename"   value="' {&P_BUFFER}._FILENAME '">~n' 
    '<PARAM name="Filetype"   value="' {&P_BUFFER}._type-list '">~n'
    '<PARAM name="File-id"    value="' RECID({&P_BUFFER}) '">~n' &ENDIF &IF "{&CODE_BUFFER}" ne "" &THEN
    '<PARAM name="Section-id" value="' RECID({&CODE_BUFFER}) '">~n' &ENDIF &IF "{&DoCommand}" ne "" &THEN
    '<PARAM name="DoCommand"  value="' {&DoCommand} '">~n' &ENDIF
    '<PARAM name="BgColor"    value="' get-color("BgColor") '">~n'
    '<PARAM name="TextColor"  value="' get-color("Text") '">~n'
    /* Add the Cookies only if we are not in evaluation mode. */
    IF NOT check-agent-mode("EVALUATION":U) 
    THEN SUBSTITUTE ('<PARAM name="Cookie"     value="&1; &2=&3">~n',
                     WEB-CONTEXT:EXCLUSIVE-ID,
                     _h_tool:FILE-NAME,
                     LEFT-TRIM(STRING(_h_tool:UNIQUE-ID,'>>>>>>>>9':U)))
    ELSE ''.
    IF WEB-CONTEXT:GET-CGI-VALUE("ENV","HTTP_AUTHORIZATION") ne "" 
    THEN DO:  
      {&OUT} '<PARAM name="HttpAuth"   value="' WEB-CONTEXT:GET-CGI-VALUE("ENV","HTTP_AUTHORIZATION") ' ">~n'.
    END. 
    {&OUT} '</APPLET>~n'  &IF FALSE &THEN
  
  /* ------------------------------------------------------------------------
     Include the JavaScript for a function that will make sure the applet
     exists prior to executing a WebSpeed Editor command.
                              *******
                      Internet Explorer WARNING: 

     IE3 views the applet as part of the form (and not the document) if
     the applet is inserted in a form.  Navigator does not do this. This
     include file should not be included inside a form without using the
     &FormName parameter [NOTE: I have not tested that part. ]
    ------------------------------------------------------------------------*/  
  &ENDIF  &IF "{&FUNCTION}" ne "" &THEN
    '<SCRIPT LANGUAGE="JavaScript">~n'
    '  <!-- // Create a function to access the WebSpeed Editor applet ~n'
    '  function {&FUNCTION} (Command) ~{ ~n'
    '    var SA = document.SeApplet~;~n' &IF "{&FormName}" ne "" &THEN
    '    // Explorer 3.0 counts the applet as part of the FORM~n'
    '    if (SA == null) SA = document.{&FormName}.SeApplet~;~n' &ENDIF
    '    if (SA != null) SA.DoCommand (Command)~; ~n'
    '  }~n'
    '  //-->~n'
    '</SCRIPT>~n'
     
  &ENDIF  
  /* -- End of startse.i -- */
