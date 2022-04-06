&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r2 GUI
/* Procedure Description
"Method-Library for object-help Procedure

Contains object-help procedure to access help from the UIB's Insert Procedure Call dialog box for developer-defined ADM Event and Method procedures."
*/
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Method-Library 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*--------------------------------------------------------------------------
    Library     : objhelp.i
    Purpose     : Contains object-help procedure to access help from the
                  UIB's Insert Procedure Call dialog box for developer-defined
                  ADM Event and Method procedures.

    Syntax      : Since this is a Method Library file, use the UIB's Method
                  Library dialog to add it to a UIB procedure file.

    Description :

    Author(s)   : 
    Created     :
    Notes       :
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Method-Library
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: INCLUDE-ONLY
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Method-Library ASSIGN
         HEIGHT             = 2
         WIDTH              = 40.
                                                                        */
&ANALYZE-RESUME
 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB Method-Library 
/* ************************* Included-Libraries *********************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Method-Library 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-object-help) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE object-help Method-Library 
PROCEDURE object-help :
/*----------------------------------------------------------------------------

PROCEDURE:
    object-help

PURPOSE:
    Procedure to access help from the UIB Code Section Editor's Insert Procedure
    Call dialog box for developer-defined ADM Event and Method procedures .

SYNTAX
    RUN object-help
        (INPUT  p_HelpID,
         INPUT  p_HelpCommand,
         INPUT  p_ContextNumber,
         INPUT  p_SearchString,
         OUTPUT p_HelpFound).
  
DESCRIPTION:

    1. Accessing Developer-Defined Object Help from the UIB

       You can access your own online help for additional ADM Event or
       Method procedures from the UIB Code Section Editor's Insert
       Procedure Call dialog box.

       While you are designing a SmartContainer, you can open the Insert
       Procedure Call dialog box (from the Code Section Editor) and
       view the internal procedures for the SmartObjects in the SmartContainer.
       When you select an ADM Event or Method name for a SmartObject and
       choose the About Event/Method button, the Insert Call dialog box
       examines the SmartObject's Internal-Entries, looking for the procedure
       object-help. If present, Insert Call runs it, passing the selected
       procedure-name using the p_SearchString parameter. You can code the
       object-help procedure to provide help for that procedure.
       
       If no help can be found, object-help sets output parameter p_HelpFound
       to FALSE. When p_HelpFound is FALSE, the Insert Call dialog box accesses
       the PROGRESS ADM help file to search for the event or method name there.

    2. Including object-help in Your Objects
       
       For the Insert Procedure Call dialog to be aware of procedure
       object-help, you must include its method libary objhelp.i in
       your objects.

       You can do this by adding the objhelp.i method library to an ADM
       method library using the techniques described in the Advanced ADM
       Topics chapter of the PROGRESS UIB Developer's Guide.

       You could also add the objhelp.i method library directly to each
       of your development template files using the UIB Method Library
       dialog box, which is accessed from the Procedure Settings dialog.

       The next sections describe ways you can modify the object-help
       procedure to provide procedure help.


    3. Method 1: Using Help (.hlp) Files
    
       You can use help files (.hlp files) to provide developer-defined
       SmartObject ADM Event and Method procedures help.
       
       You'll need to store your development help files in a help files
       directory. The variable HelpFileDir is used to define the help files
       directory. Its original shipped default is "./", which signifies
       your PROGRESS session's startup directory. You should change this
       initial default to match your system's PROPATH relative help file
       directory.

       You also need to specify what help file to access. For illustrative
       purposes, we'll say that you have an ADM Extensions help file that
       you provide for your developers to access help on ADM Event and
       Method procedures you've established in addition to the PROGRESS
       ADM. Change the variable HelpFileName in this procedure to be the
       name of this file. Its shipped initial value is "myadm.hlp".
        
    4. Method 2: Call your own help access procedure.
    
       You call your own help access procedure to provide additional
       ADM help to your developers. You'll need to change object-help
       as needed.

    5. Parameters

       Object-help has several input parameters and one output parameter.
       The two most important parameters are the input parameter p_SearchString
       and the output parameter p_HelpFound. They are described in the
       sections below.

       The object-help procedure is based in-part on the PROGRESS ADE help 
       procedure _adehelp.p. You can view that code in DLC/src/adecomm.

INPUT PARAMETERS:

    p_HelpID
        A character string identifying the help file you want to access.
        The UIB's Insert Procedure Call dialog passes Null for this
        parameter.
        
    p_HelpCommand
        A character string identifying the SYSTEM-HELP command you want
        to execute. The UIB's Insert Procedure Call dialog always passes
        "PARTIAL-KEY" for this parameter.
        
    p_ContextNumber
        An integer identifying the SYSTEM-HELP context number. It identifies
        a unique help topic within a help file. The UIB's Insert
        Procedure Call dialog passes Unknown (?) for this parameter.

    p_SearchString
        A character string identifying a keyword or partial keyword in a
        desired help file. The UIB's Insert Procedure Call dialog passes
        the ADM Event or Method name you have selected when you choose
        the About button.
        
OUTPUT PARAMETERS:

    p_HelpFound
        A logical value of TRUE if object-help was able to successfully
        find the help you wanted. If returned as FALSE, this tells the
        UIB's Insert Procedure Call dialog box to search the PROGRESS ADM
        help file for p_SearchString.
   
SEE ALSO
    See the PROGRESS SYSTEM-HELP Statement in the Language Reference
    manual or online help for more information
    
    The _adehelp.p procedure invokes PROGRESS Online Help for ADE tools,
    Language Reference, and ADM Help. You can look at this file in
    DLC/src/adecomm.

    The _kwhelp.p procedure invokes PROGRESS Online Language Reference Help
    to search for keyword help on code selected in an editor widget. You
    can view this file in DLC/src/adecomm.

   
AUTHORS     : 
DATE CREATED: 
LAST UPDATED: 
----------------------------------------------------------------------------*/

DEFINE INPUT  PARAMETER p_HelpID        AS CHARACTER NO-UNDO.
DEFINE INPUT  PARAMETER p_HelpCommand   AS CHARACTER NO-UNDO.
DEFINE INPUT  PARAMETER p_ContextNumber AS INTEGER   NO-UNDO.
DEFINE INPUT  PARAMETER p_SearchString  AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER p_HelpFound     AS LOGICAL   NO-UNDO INITIAL FALSE.

DEFINE VARIABLE HelpFileDir             AS CHARACTER INITIAL "./":u NO-UNDO.
DEFINE VARIABLE HelpFileName            AS CHARACTER INITIAL "myadm.hlp":u NO-UNDO.
DEFINE VARIABLE HelpFileFullName        AS CHARACTER NO-UNDO.
DEFINE VARIABLE DevHelpEntries          AS CHARACTER NO-UNDO.

DO ON STOP UNDO, LEAVE ON ERROR UNDO, LEAVE ON ENDKEY UNDO, LEAVE:

  /* Establish comma-delimited list of searchable help entries for your
     ADM Events and Methods by replacing the sample entries with your own. */

  ASSIGN DevHelpEntries = "adm-name1,adm-name2,proc-name1,proc-name2":u.

  /* If we can't find the help entry, return now. */
  IF NOT CAN-DO(DevHelpEntries , p_SearchString) THEN
    RETURN.

  /* We can find it. Tell the calling routine. */
  ASSIGN p_HelpFound  = TRUE.
    
  /* Access the developer-defined help system. Two methods are demonstrated
     below. */
     
  /* Method 1: Using Help (.hlp) Files. */
  
  /* Establish the full Help File Name. Return now if we can't find it. */
  ASSIGN HelpFileName      = HelpFileDir + HelpFileName
         HelpFileFullName  = SEARCH(HelpFileName).

  IF HelpFileFullName = ? THEN
  DO ON STOP UNDO, RETURN:
    /* If QUIT/Closing Help Window, no need to inform user. Its annoying. */
    IF p_HelpCommand <> "QUIT":u THEN
        MESSAGE "Unable to locate help file """ + HelpFileName + """."
                VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
    RETURN.
  END.

  /* Access the help file using a partial-key string search. */
  DO ON STOP UNDO, LEAVE:
    IF p_SearchString <> ? THEN
      SYSTEM-HELP HelpFileFullName PARTIAL-KEY p_SearchString.
    ELSE
      MESSAGE "Unknown partial key ""?""."
        VIEW-AS ALERT-BOX INFORMATION BUTTONS OK IN WINDOW ACTIVE-WINDOW.
  END.


  /* Method 2: Define Your Own Help procedure.
     
     You write your own help access system. You insert the call here,
     inplace of the sample RUN myhelp.p call. */

  /* RUN myhelp.p (INPUT p_HelpCommand, INPUT p_SearchString). */
       
  
END. /* DO */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

