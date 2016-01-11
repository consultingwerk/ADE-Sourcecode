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
/*----------------------------------------------------------------------------

PROCEDURE:
    _adehelp.p

PURPOSE:
    Procedure to access the PROGRESS Online Help System. ADE tools run this
    this procedure to provide users with online help.

SYNTAX
    RUN adecomm/_adehelp.p
        (INPUT  p_HelpID,
         INPUT  p_HelpCommand,
         INPUT  p_ContextNumber,
         INPUT  p_SearchString).

DESCRIPTION:
    
    1. Help File ID's and ADE Tool Names
  
        For the purpose of accessing help, PROGRESS uses unique help id
        strings to identify help files. The PROGRESS ADE tool help files
        are identified this way - where the help id string is a tool name.
        For example, some tool names from the PROGRESS ADE toolset are:

            User Interface Builder  :   uib
            Procedure Editor        :   edit
            Data Dictionary         :   dict
            
        In addition to the ADE tools, PROGRESS can identify other types of
        help files using a unique help id string. Some PROGRESS examples:
        
            ADM Reference Help      :   adm
            Language Reference Help :   lgrf
            Common Directory Help   :   comm
            
        The help id string is used as part of the help file name,
        which is described in "Naming of PROGRESS Help Files" below.

    2. Location of PROGRESS Help Files
    
        PROGRESS help files are located in the DLC/prohelp directory.
        
    3. Naming of PROGRESS Help Files
        
        To support help files for different tools and multiple languages,
        PROGRESS help file names are composed of the help id (p_HelpID)
        and the first three letters of a language. _adehelp.p determines
        the language name using the 4GL CURRENT-LANGUAGE function.
        
        For example, the PROGRESS UIB English help file is uibeng.hlp and
        is located in the DLC/prohelp directory.
        
        For portability across operating system, help file names are
        lowercase.
    
INPUT PARAMETERS:
    
    p_HelpID
        A character string identifying the PROGRESS ADE tool whose help
        file you want to access.
        
    p_HelpCommand
        A character string identifying the SYSTEM-HELP command you want
        to execute.
        
        This procedure processes the following help commands:
        
            HELP    Displays the contents of the system How to Use Help
                    file.
            
            CONTEXT Displays the help topic that the context number parameter
                    p_ContextNumber identifies.
                    
            CONTENTS
                    Displays the help contents help screen for the specified
                    ADE tool.

            TOPICS  Displays the Help Topics dialog box for the specified
                    ADE tool.

            KEY     Displays the help topic matching the p_SearchString
                    string found in the help file's keyword list. If there
                    is more than one match, it displays the first topic
                    containing the keyword. If there is no match or the
                    string is omitted, a message is displayed indicating
                    that the keyword is invalid.

            PARTIAL-KEY
                    Displays the help topic matching the p_SearchString
                    string found in the help file's keyword list. If there
                    is more than one match, no match, or if the string is
                    omitted, it displays the Search dialog box.

            QUIT    Informs the help application that help is no longer
                    required.
                    
            GET-HELPFILE
                    Instructs procedure to determine the full pathname to the
                    help file based on the help id. Value is returned using
                    the RETURN statement.
        

    p_ContextNumber
        An integer identifying the SYSTEM-HELP context number. It identifies
        a unique help topic within a help file.

        If called with a p_ContextNumber = ? using p_HelpCommand = CONTEXT,
        an alert-box message is displayed indicating an invalid value.

    p_SearchString
        A character string identifying a keyword or partial keyword in a
        desired help file.
        
        If called with p_SearchString = ? using p_HelpCommand = KEY or
        PARTIAL-KEY, an alert-box message is displayed indicating an
        invalid value.

    
OUTPUT PARAMETERS:
    None
   
SEE ALSO
    See the PROGRESS SYSTEM-HELP Statement in the Language Reference
    manual or online help for more information.
    
    The _kwhelp.p procedure invokes PROGRESS Online Language Reference Help
    to search for keyword help on code selected in an editor widget. You
    can view this file in DLC/src/adecomm.

   
AUTHORS     : Ravi Ramalingam
DATE CREATED: April, 1993
LAST UPDATED: September, 1999 - J. Palazzo
              Added command support for GET-HELPFILE.
----------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER p_HelpID        AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER p_HelpCommand   AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER p_ContextNumber AS INTEGER   NO-UNDO.
DEFINE INPUT PARAMETER p_SearchString  AS CHARACTER NO-UNDO.

DEFINE VARIABLE HelpFileDir           AS CHARACTER INITIAL "prohelp/":u NO-UNDO.
DEFINE VARIABLE HelpFileName          AS CHARACTER NO-UNDO.
DEFINE VARIABLE HelpFileFullName      AS CHARACTER NO-UNDO.
DEFINE VARIABLE LanguageExtension     AS CHARACTER INITIAL "eng":u NO-UNDO.

DO ON STOP UNDO, LEAVE ON ERROR UNDO, LEAVE ON ENDKEY UNDO, LEAVE:

  IF SESSION:DISPLAY-TYPE = "TTY":U THEN
  DO ON STOP UNDO, RETURN ON ERROR UNDO, RETURN ON ENDKEY UNDO, RETURN:
    IF p_HelpCommand <> "QUIT":u THEN BELL.
/*
    MESSAGE "PROGRESS Online Help is not available on " + OPSYS + 
            " Character platforms." SKIP(1)
            "You can use the Help menu to access keyboard and message help."
            VIEW-AS ALERT-BOX INFORMATION.
*/
    RETURN.
  END.

  /* Help on Help is a special case. */
  IF p_HelpCommand = "HELP":u THEN
  DO:
    SYSTEM-HELP "" HELP.
    RETURN.
  END.
  
  /* Determine Language Extension */
  IF CURRENT-LANGUAGE <> "?" THEN
      ASSIGN LanguageExtension = 
             LC(SUBSTRING(CURRENT-LANGUAGE,1,3,"CHARACTER":u)).
  
  /* Be sure case of help id is lower. Its used as part of OS file name. */
  ASSIGN p_HelpID = LC( p_HelpID ).
  
  ASSIGN HelpFileName     = HelpFileDir +  
                            p_HelpID + LanguageExtension + ".hlp":u
         HelpFileFullName = SEARCH(HelpFileName).
  
  IF HelpFileFullName = ? THEN
  DO: /* Assign default help file name. */
    ASSIGN HelpFileName     = HelpFileDir + p_HelpID + "eng":u + ".hlp":u
           HelpFileFullName = SEARCH(HelpFileName).
  END.

  /* If just requesting the help file name, return now. */
  IF p_HelpCommand = "GET-HELPFILE":u THEN
  DO:
    RETURN HelpFileFullName.
  END.
    
  /* Still unable to locate the help file, inform the user. */
  IF HelpFileFullName = ? THEN
  DO ON STOP UNDO, RETURN:
    /* If QUIT/Closing Help Window, no need to inform user. Its annoying. */
    IF p_HelpCommand <> "QUIT":u THEN
        MESSAGE "Unable to locate help file """ + HelpFileName + """."
                VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
    RETURN.
  END.
  
  CASE p_HelpCommand:
    WHEN "CONTENTS":u THEN
    DO:
      SYSTEM-HELP HelpFileFullName CONTENTS.
    END.
  
    WHEN "TOPICS":u THEN
    DO:
      SYSTEM-HELP HelpFileFullName FINDER.
    END.

    WHEN "CONTEXT":u THEN
    DO ON STOP UNDO, LEAVE:
      IF p_ContextNumber = ? THEN
        MESSAGE "Unknown context number ""?""."
           VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
      ELSE
        SYSTEM-HELP HelpFileFullName CONTEXT p_ContextNumber.
    END.
  
    WHEN "KEY":u THEN
    DO ON STOP UNDO, LEAVE:
      IF p_SearchString = ? THEN
        MESSAGE "Unknown key ""?""."
           VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
      ELSE
        SYSTEM-HELP HelpFileFullName KEY p_SearchString.
    END.
  
    WHEN "PARTIAL-KEY":u THEN
    DO ON STOP UNDO, LEAVE:
      IF p_SearchString = ? THEN
        MESSAGE "Unknown partial key ""?""."
           VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
      ELSE
        SYSTEM-HELP HelpFileFullName PARTIAL-KEY p_SearchString.
    END.
  
    WHEN "QUIT":u THEN
    DO:
      SYSTEM-HELP HelpFileFullName QUIT.
    END.
  
    OTHERWISE
      MESSAGE "Unsupported help command """ + CAPS(p_HelpCommand) + """."
        VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
  END CASE.
  
END. /* DO */
