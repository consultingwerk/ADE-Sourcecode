&ANALYZE-SUSPEND _VERSION-NUMBER WDT_v2r1 Workshop-Object
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
**********************************************************************
  File: webutil/_wstyle.w

  Description: Define a standard set of styles for use in Workshop.

  Parameters: <none>

  Fields: <none>

  Note:
    This file defines a series of functions that can be called from
    various tools in the WebSpeed Workshop

    There is a companion file (webutil/style.i) that defines a
    GLOBAL handle for this procedure, and defines the prototypes for 
    the functions in this file.

  Author:  Wm. T. Wood
  Created: April 1, 1997
------------------------------------------------------------------------*/
/*           This .W file was created with WebSpeed Workshop.           */
/*----------------------------------------------------------------------*/

/* Local Definitions --                                                 */

/* Preprocessor Definitions --                                          */

/* Colors --- for the standard screen*/
&SCOPED-DEFINE bgColor            #FFFFCC
&SCOPED-DEFINE indexBgColor       #CCFFFF
&SCOPED-DEFINE ALinkColor         #990000
&SCOPED-DEFINE LinkColor          #660066
&SCOPED-DEFINE VLinkColor         {&ALinkColor} 
&SCOPED-DEFINE TextColor          #000000

/* Colors --- by purpose*/
&SCOPED-DEFINE HilightColor       #993333
&SCOPED-DEFINE ErrorColor         {&TextColor} 
&SCOPED-DEFINE ErrorHiColor       RED 
&SCOPED-DEFINE FileNameColor      {&HilightColor} 
&SCOPED-DEFINE H1Color            #660066
&SCOPED-DEFINE H2Color            #990000
&SCOPED-DEFINE H3Color            {&H2Color}
&SCOPED-DEFINE LabelColor         {&TextColor} 
&SCOPED-DEFINE TextWithLabelColor {&HilightColor} 
&SCOPED-DEFINE TitleColor         {&H1Color}
&ANALYZE-RESUME
&ANALYZE-SUSPEND _PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&SCOPED-DEFINE PROCEDURE-TYPE Workshop-Object


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

/* ************************  Main Code Block  *********************** */

/* This procedure is expected to be run persistent, (as opposed to being
   run as a Web-Object. */
RUN set-attribute-list IN THIS-PROCEDURE ('Web-State=persistent':U).

/* The CLOSE event can be used from inside or outside the procedure to  */
/* terminate it.                                                        */
ON CLOSE OF THIS-PROCEDURE 
   RUN dispatch ('destroy':U).

/* Run the local/adm-destroy procedures, if the procedure is ending.    */
IF NOT THIS-PROCEDURE:PERSISTENT THEN 
  RUN dispatch ('destroy':U).

/* ********************** Function Definitions ************************ */

/*------------------------------------------------------------------------------
  Purpose:     return the string needed to format an error, with a highlight,
               in Workshop.
  Parameters:  p_text:     The text to use around the hilit text. Within this
                           text, &1 is where p_highlite will go.
               p_highlite: The text to highlight 
               p_options:  Comma delimited list of formatting options
                           [currently unused]
  For Example:
    format-error ('&1 must be an integer.', 'Var', ,'')
  Returns:
    <FONT COLOR="blue"><FONT COLOR="olive">Var</FONT> must be an integer</FONT>
------------------------------------------------------------------------------*/
FUNCTION format-error RETURNS CHARACTER
   (INPUT p_text        AS CHARACTER,
    INPUT p_highlite    AS CHARACTER,
    INPUT p_options     AS CHARACTER):

  RETURN SUBSTITUTE
               ('<FONT COLOR="{&ErrorColor}">' + p_text + '</FONT>',
                '<FONT COLOR="{&ErrorHiColor}"><I>' + html-encode(p_highlite) +
                '</I></FONT>').
END FUNCTION.


/*------------------------------------------------------------------------------
  Purpose:     return the string needed to format a filename in Workshop.
  Parameters:  p_filename: The name of the file
               p_text:     The text to use around the filename. Within this
                           text, &1 is where p_filename will go.
               p_options:  Comma delimited list of formatting options
                           [currently unused]
  For Example:
    format-filename ('a.p', 'Saving &1...','')
  Returns:
    <FONT COLOR="blue"><B>Saving <FONT COLOR="olive"><I>a.p</I></FONT>...</B></FONT>   
------------------------------------------------------------------------------*/
FUNCTION format-filename RETURNS CHARACTER
   (INPUT p_filename    AS CHARACTER,
    INPUT p_text        AS CHARACTER,
    INPUT p_options     AS CHARACTER):

  RETURN SUBSTITUTE 
               ('<FONT COLOR="{&H2Color}"><B>' + p_text + '</B></FONT>',
                '<FONT COLOR="{&FileNameColor}"><I>' + html-encode(p_filename) +
                '</I></FONT>').
END FUNCTION.

/*------------------------------------------------------------------------------
  Purpose:     return the string needed to format a label
  Parameters:  p_label: The label for the text
               p_type:  The type of label (side, column, row, top)
                        "Input" labels are SIDE labels beside an input field.
               p_options:  Comma delimited list of formatting options
                           [currently unused]
  For Example:
    format-label ('File', 'side','')
  Returns:
    <FONT COLOR="blue">File: </FONT>   
------------------------------------------------------------------------------*/
FUNCTION format-label RETURNS CHARACTER
   (INPUT p_label       AS CHARACTER,
    INPUT p_type        AS CHARACTER,
    INPUT p_options     AS CHARACTER):
  
  CASE p_type:

    WHEN "COLUMN":U THEN RETURN
       SUBSTITUTE  ('<FONT COLOR="{&LabelColor}"><B>&1</B></FONT>', p_label).
 
    WHEN "ROW":U THEN RETURN
      SUBSTITUTE ('<FONT COLOR="{&LabelColor}">&1:</FONT>', p_label).

    WHEN "INPUT":U THEN RETURN
      SUBSTITUTE ('<FONT COLOR="{&LabelColor}"><B>&1: </B></FONT>', p_label).

    WHEN "TOP":U THEN RETURN
      SUBSTITUTE ('<FONT COLOR="{&LabelColor}"><B>&1:</B></FONT>', p_label).

    OTHERWISE RETURN
      SUBSTITUTE ('<FONT COLOR="{&LabelColor}">&1: </FONT>', p_label).

  END CASE.
END FUNCTION.


/*------------------------------------------------------------------------------
  Purpose:     return the string needed to format a text value, with a label.
  Parameters:  p_label: The label for the text
               p_text:  The text

  For Example:
    format-text-label ('File', 'a.p','')
  Returns:
    <FONT COLOR="blue">File: </FONT><FONT COLOR="olive"><B>a.p</B></FONT>   
------------------------------------------------------------------------------*/
FUNCTION format-label-text RETURNS CHARACTER
   (INPUT p_label       AS CHARACTER,
    INPUT p_text        AS CHARACTER):

  RETURN SUBSTITUTE
           ('<NOBR>&1<FONT COLOR="{&TextWithLabelColor}"><B>&2</B></FONT></NOBR>',
            format-label(p_label, "SIDE":U, "":U),
            p_text).
END FUNCTION.


/*------------------------------------------------------------------------------
  Purpose:     return the string needed to format a text value, with a label.
  Parameters:  p_text:  The text
               p_options: The options to apply.  NOTE that all options are
                          applied, left-to-right
                 Options:
                   H1, H2, H3, H4 -- Headings
                   Submit -- Response to a SUBMIT (eg. "4 fields changes")
                   B - bold
                   I - italics
                   any html tag will do here.
                   
  For Example:
    format-text ('Results', 'B,I','')
  Returns:
    <B><I>Results</I><B>   
------------------------------------------------------------------------------*/
FUNCTION format-text RETURNS CHARACTER
   (INPUT p_text       AS CHARACTER,
    INPUT p_options    AS CHARACTER):

  DEFINE VARIABLE cnt AS INTEGER NO-UNDO.
  DEFINE VARIABLE i   AS INTEGER NO-UNDO.
  DEFINE VARIABLE opt AS CHAR    NO-UNDO.

  ASSIGN cnt = NUM-ENTRIES(p_options).
  DO i = cnt TO 1 BY -1:
    opt = ENTRY(i, p_options).
    CASE opt:
      WHEN "H1":U THEN
        p_text = '<FONT SIZE="+3" COLOR="{&H1COLOR}">':U + p_text + '</FONT>':U.
      WHEN "H2":U THEN
        p_text = '<FONT SIZE="+2" COLOR="{&H2COLOR}"><B>':U + p_text + '</B></FONT>':U.
      WHEN "H3":U THEN
        p_text = '<FONT SIZE="+1" COLOR="{&H3COLOR}"><B>':U + p_text + '</B></FONT>':U.
      WHEN "H3":U THEN
        p_text = '<FONT COLOR="{&H2COLOR}"><B>':U + p_text + '</B></FONT>':U.
      WHEN "HighLight" THEN
        p_text = '<FONT COLOR="{&HilightColor}">':U + p_text + '</FONT>':U.          
      WHEN "Submit" THEN
        p_text = '<FONT COLOR="{&H3Color}"><B><I>':U + p_text + '</I></B></FONT>':U.
      OTHERWISE 
        /* Assume the option is a valid HTML tag */
        p_text = SUBSTITUTE('<&2>&1<~/&2>':U, p_text, opt).
    END CASE.
  END.

  /* Return the formatted text. */
  RETURN p_text.

END FUNCTION.

/*------------------------------------------------------------------------------
  Purpose:     return the string needed to format a titlebar in Workshop.
  Parameters:  p_title:    The name of the title
               p_image:    The name of the image file [blank if no image]
               p_options:  Comma delimited list of formatting options [currently unused]
                           
  For Example:
    format-titlebar ('WebSpeed WebTools', RootURL + '/images/l-tools.gif', '')
  Returns:
    <IMG SRC="[RootURL]/images/l-tools.gif" BORDER=0 ALIGN="CENTER">
    <FONT SIZE="+2" COLOR="PURPLE"><B><I>WebSpeed WebTools</I></B></FONT>
------------------------------------------------------------------------------*/
FUNCTION format-titlebar RETURNS CHARACTER
   (INPUT p_title       AS CHARACTER,
    INPUT p_image       AS CHARACTER,
    INPUT p_options     AS CHARACTER):
 
   RETURN 
    (IF p_image ne '' 
     THEN '<IMG SRC="' + p_image + '" BORDER=0 ALIGN="CENTER"> ' 
     ELSE '':U) +
    (IF p_title ne '' 
     THEN '<FONT SIZE="+2" COLOR="{&H1Color}"><B>' + p_title + '</I></FONT>'
     ELSE '':U).
               
END FUNCTION.


/*------------------------------------------------------------------------------
  Purpose:     return the string needed to fill in the <BODY phrase> for a
               WebSpeed Workshop frame or function.
  Usage:   
               {&OUT} '<BODY' get-body-phrase("WS_header") '>~n'

  Parameters:  p_BodyName: Name of body phrase.  Usually this is the same as the
                           the WebSpeed Frame
  Notes:       ' BCOLOR="{&BgColor}"' is returned for an invalid name.
------------------------------------------------------------------------------*/
FUNCTION get-body-phrase RETURNS CHARACTER (INPUT p_BodyName AS CHARACTER):
  CASE p_BodyName:
    /* Three Main Workshop Frames */
    WHEN 'WS_header':U THEN  RETURN 
            ' BGCOLOR="{&indexBgColor}"' +
            ' TEXT="{&TextColor}" LINK="{&LinkColor}" VLINK="{&VLinkColor}" ALINK="{&ALinkColor}"':U.
    WHEN 'WS_index':U THEN RETURN
            ' BGCOLOR="{&indexBgColor}"' +           
            ' TEXT="{&H2Color}" LINK="{&LinkColor}" VLINK="{&VLinkColor}" ALINK="{&ALinkColor}"':U.
    WHEN 'WS_main':U THEN RETURN
            ' BACKGROUND="' + RootURL + '/images/bgr/wsbgr.gif" BGCOLOR="{&BgColor}"':U +
            ' TEXT="{&H2Color}" LINK="{&LinkColor}" VLINK="{&VLinkColor}" ALINK="{&ALinkColor}"':U.


    /* Files View Frames (Project) */
    WHEN 'WSFL_directory':U THEN RETURN
            ' BGCOLOR="{&indexBgColor}"' +
            ' TEXT="{&H2Color}" LINK="{&LinkColor}" VLINK="{&VLinkColor}" ALINK="{&ALinkColor}"':U.


    /* File Information (Workshop)Frames */
    WHEN 'WSFI_header':U THEN RETURN
            ' BACKGROUND="' + RootURL + '/images/bgr/wstitlbr.gif"~n':U +
            ' TEXT="{&TextColor}" LINK="{&LinkColor}" VLINK="{&VLinkColor}" ALINK="{&ALinkColor}"':U.

    
    /* File Contents (Workshop/File Info.) Frames */
    WHEN 'WSFC_main':U THEN RETURN
            ' BACKGROUND="' + RootURL + '/images/bgr/wsblank.gif" BGCOLOR="{&BgColor}"':U + 
            ' TEXT="{&TextColor}" LINK="{&LinkColor}" VLINK="{&VLinkColor} ALINK="{&ALinkColor}"':U.

    /* Database view (Webtools/Databases) Frames */
    WHEN 'WSDB_header':U THEN RETURN
            ' BACKGROUND="' + RootURL + '/images/bgr/wstitlbr.gif"~n':U +
            ' TEXT="{&TextColor}" LINK="{&LinkColor}" VLINK="{&VLinkColor}" ALINK="{&ALinkColor}"':U.

    /* Wizard Frames */
    WHEN 'WSWZ_body':U THEN RETURN
            ' BACKGROUND= "' + RootURL + '/images/bgr/wsbgr.gif" BGCOLOR="{&BgColor}"':U +
            ' TEXT="{&H2Color}" LINK="{&LinkColor}" VLINK="{&VLinkColor}" ALINK="{&ALinkColor}"':U.
    WHEN 'WSWZ_tabs':U THEN RETURN
            ' BACKGROUND="' + RootURL + '/images/bgr/wsblank.gif" BGCOLOR="{&BgColor}"':U +
            ' TEXT="{&H2Color}" LINK="{&LinkColor}" VLINK="{&VLinkColor}" ALINK="{&ALinkColor}"':U.

    /* Miscellanous */
    WHEN '_top':U THEN  RETURN 
            ' BACKGROUND="' + RootURL + '/images/bgr/wsbgr.gif" BGCOLOR="{&BgColor}"':U +
            ' TEXT="{&TextColor}" LINK="{&LinkColor}" VLINK="{&VLinkColor}" ALINK="{&ALinkColor}"':U.
    /* File Listings */
    WHEN "Listing" THEN RETURN
            ' BGCOLOR="WHITE" TEXT="BLACK"':U +
            ' LINK="{&LinkColor}" VLINK="{&VLinkColor}" ALINK="{&ALinkColor}"':U.

    OTHERWISE DO:
      /* Handle HELP screens. */
      IF p_BodyName BEGINS "WSHELP" 
      THEN RETURN
            ' BACKGROUND="' + RootURL + '/doc/library/images/paper.gif" BGCOLOR="WHITE"':U + 
            ' TEXT="#000000" LINK="#000000" VLINK="#FF0000" ALINK="#FF0000"':U.
      ELSE RETURN
            ' BACKGROUND="' + RootURL + '/images/bgr/wsblank.gif" BGCOLOR="{&BgColor}"':U + 
            ' TEXT="{&TextColor}" LINK="{&LinkColor}" VLINK="{&VLinkColor}" ALINK="{&ALinkColor}"':U.
    END. /* OTHERWISE... */

  END CASE.

END FUNCTION.

/*------------------------------------------------------------------------------
  Purpose:     return the string needed to fill in the <TABLE phrase> for a
               WebSpeed Workshop table.
  Usage:   
               {&OUT} '<TABLE' get-table-phrase("":U) '>~n'

  Parameters:  p_options: Comma delimited list of options [currently unused]
------------------------------------------------------------------------------*/
FUNCTION get-table-phrase RETURNS CHARACTER (INPUT p_options AS CHARACTER):
 
  /* Standard TABLE attributes used in Workshop. */
  RETURN ' BORDER=1':U.

END FUNCTION.

/*------------------------------------------------------------------------------
  Purpose:     return the string needed to define a named color.
  Parameters:  p_nameOfColor: Name of the Color
  Notes:       'BLACK' is returned for an invalid name.
------------------------------------------------------------------------------*/
FUNCTION get-color RETURNS CHARACTER (INPUT p_nameOfColor AS CHAR):

  CASE p_nameOfColor:
    WHEN 'alink':U        THEN RETURN '{&ALinkColor}':U.
    WHEN 'bgcolor':U      THEN RETURN '{&BgColor}':U.
    WHEN 'error':U        THEN RETURN '{&ErrorColor}':U.
    WHEN 'fileName':U     THEN RETURN '{&FileNameColor}':U.
    WHEN 'h1':U           THEN RETURN '{&H1Color}':U.
    WHEN 'h2':U           THEN RETURN '{&H2Color}':U.
    WHEN 'h3':U           THEN RETURN '{&H3Color}':U.
    WHEN 'highlight':U    THEN RETURN '{&HilightColor}':U.
    WHEN 'IndexBg':U      THEN RETURN '{&IndexBgColor}':U.
    WHEN 'label':U        THEN RETURN '{&LabelColor}':U.
    WHEN 'link':U         THEN RETURN '{&LinkColor}':U.
    WHEN 'text':U         THEN RETURN '{&TextColor}':U.
    WHEN 'labelledText':U THEN RETURN '{&TextWithLabelColor}':U.
    WHEN 'title':U        THEN RETURN '{&titleColor}':U.
    WHEN 'vlink':U        THEN RETURN '{&VLinkColor}':U.
    OTHERWISE                  RETURN 'BLACK':U.
  END CASE.
  
END FUNCTION.

/*------------------------------------------------------------------------------
  Purpose:     return the location of files (Relative to HostURL).
               This lets us change the name of static files (eg. blank.html,
               or welcome.html) on the fly.
  Parameters:  p_name: Name of html page
  Notes:     
------------------------------------------------------------------------------*/
FUNCTION get-location RETURNS CHARACTER (INPUT p_name AS CHAR):

  CASE p_name:
    /* Key Image Files */
    WHEN 'Help-Logo':U    THEN RETURN RootURL + '/images/l-help.gif':U.
    WHEN 'Tools-Logo':U   THEN RETURN RootURL + '/images/l-tools.gif':U.
    WHEN 'Files-Logo':U   THEN RETURN RootURL + '/images/l-files.gif':U.
    /* Static Pages */
    WHEN 'Blank':U        THEN RETURN RootURL + '/assist/blank.html':U.
    WHEN 'Welcome':U      THEN RETURN RootURL + '/workshop/welcome.html':U.
  END CASE.
  
END FUNCTION.

/*------------------------------------------------------------------------------
  Purpose:     return a standard hard rule tag image.
  Parameters:  p_width:   The relative width of the <HR> as a percentage.
           p_options: Comma delimited list of formatting options 
                          [currently unused].    
  For Example:
    get-rule-tag ('100%', '').
  Returns:
    <IMG SRC="[RootURL]/images/wsrule.gif" WIDTH="100%">.
------------------------------------------------------------------------------*/
FUNCTION get-rule-tag RETURNS CHARACTER (INPUT p_width   AS CHARACTER,
                       INPUT p_options AS CHARACTER):

   RETURN 
     '<CENTER><IMG SRC="' + RootURL + '/images/wsrule.gif"' +
     (IF p_width ne '':U THEN ' HEIGHT=3 WIDTH="' + p_width + '"' ELSE "":U) + 
     '></CENTER>'.

END FUNCTION.

/*------------------------------------------------------------------------------
  Purpose:     return a standard window settings phrase that can be used in
               the JavaScript for window.open(URL, name, settings) 
  Parameters:  p_name:    name of window (eg. helpWindow, dbListWindow etc)
           p_options: Comma delimited list of formatting options 
                          [currently unused].    
  For Example:
    {&OUT} ' onClick="window.open(~'~',~'test~',~'' get-window-settings('test') '~')";'
  Returns:
    "menubar=yes,scrollbar=yes,... "
------------------------------------------------------------------------------*/
FUNCTION get-window-settings RETURNS CHARACTER (INPUT p_name   AS CHARACTER,
                              INPUT p_options AS CHARACTER):
  /* Base window settings on the name. */
  CASE p_name:

    /* Help window used to show help documents: 
       Library Window is the main help window for the help library (available only from
       the WebSpeed main menu. */
    WHEN 'helpWindow':U OR WHEN 'libraryWindow':U THEN
      RETURN 'width=630,height=400,' +
             'menubar=1,toolbar=1,location=1,scrollbars=1,resizable=1,status=1'.

    /* Show DB info in a seperate window from the html mapping screen. */
    WHEN 'dbListWindow':U THEN
      RETURN 'width=400,height=370,toolbar=0,resizable=1'.
    
    /* Standard secondary window (used mostly for Results). */
    OTHERWISE 
      RETURN 'width=600,height=400,' +
             'menubar=1,toolbar=0,location=0,directories=0,scrollbars=1,resizable=1,status=1'.

  END CASE.

END FUNCTION.
&ANALYZE-RESUME
 

