&ANALYZE-SUSPEND _VERSION-NUMBER WDT_v2r1 WebSpeed-Object
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
  File: _list.w
  
  Description: List the contents of a file in the WebSpeed Workshop
  Parameters:  p_proc-id -- context id of the file
               p_options -- comma delimeted list of additional options
                     "NO-HEAD" don't output the <HTML><HEAD../HEAD> ,
                               <BODY> or </BODY></HTML>.

  Author:  Wm. T. Wood
  Created: Jan. 12, 1996
------------------------------------------------------------------------*/
/*           This .W file was created with WebSpeed WorkBench.          */
/*----------------------------------------------------------------------*/


/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER p_proc-id  AS INTEGER  NO-UNDO.
DEFINE INPUT PARAMETER p_options  AS CHAR     NO-UNDO.

/* Included Definitions ---                                             */
{ webutil/wstyle.i }        /* Standard style definitions & functions.  */
{ workshop/code.i }         /* Shared code block temp-tables.           */
{ workshop/htmwidg.i }      /* Design time Web _HTM TEMP-TABLE.         */
{ workshop/objects.i }      /* Web Objects TEMP-TABLE definition        */
{ workshop/sharvars.i }     /* Common Shared variables.                 */
{ workshop/uniwidg.i }      /* Universal Widget TEMP-TABLE definition   */

/* Local Variable Definitions ---                                       */
&ANALYZE-RESUME
&ANALYZE-SUSPEND _PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE WebSpeed-Object


&ANALYZE-RESUME


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

&ANALYZE-SUSPEND _INCLUDED-LIBRARIES
/* ************************* Included-Libraries *********************** */

{ src/web/method/wrap-cgi.i }
&ANALYZE-RESUME _END-INCLUDED-LIBRARIES

&ANALYZE-SUSPEND _CODE-BLOCK _CUSTOM "Main Code Block" 


/* ************************  Main Code Block  *********************** */

RUN output-list-doc.
&ANALYZE-RESUME
/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _CODE-BLOCK _PROCEDURE list-field 
PROCEDURE list-fields :
/*------------------------------------------------------------------------------
  Purpose:    Lists all the HTML fields in this web object
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE h_name    AS CHAR NO-UNDO.
  DEFINE VARIABLE icon-name AS CHAR NO-UNDO.     
  
  DEFINE BUFFER ip_code FOR _code.
  
  /* Loop though all the objects. */
  FOR EACH _U WHERE _U._P-recid eq p_proc-id
                AND _U._STATUS ne "DELETED":U
                AND _U._type ne "FRAME":U:
                
    /* Convert the name to HTML with non-breaking spaces. */ 
    h_name = { workshop/name_u.i &U_BUFFER = "_U" } . 
    
    /* Is it an HTM field or a query? */
    IF _U._TYPE eq "QUERY":U THEN icon-name = "i-query":U.
    ELSE DO:   
      /* The associated _HTM record. */
      FIND _HTM WHERE _HTM._U-recid eq RECID(_U) NO-ERROR.
      /* This should never happen, but check for it anyway. */
      IF NOT AVAILABLE _HTM THEN RETURN.
      
      /* Base the icon on the HTML tag/type. */
      CASE _HTM._HTM-TAG:
        WHEN "TEXTAREA":U   THEN icon-name = "i-area":U.
        WHEN "SELECT":U     THEN icon-name = "i-select":U.
        OTHERWISE DO: 
          /* This is usually <INPUT> tags */
          CASE _HTM._HTM-TYPE:
            WHEN "CHECKBOX":U   THEN icon-name = "i-check":U.
            WHEN "RADIO":U      THEN icon-name = "i-radio":U.
            WHEN "TEXT":U       THEN icon-name = "i-text":U.
            OTHERWISE                icon-name = "i-html":U.   
          END CASE. /* _HTM._HTM-TYPE... */
        END. /* OTHERWISE DO:... */
      END CASE. /* _HTM._HTM-TAG ... */  
       
    END. /* IF [not] QUERY... */     
    
    /* Output the name of the field and its icon. 
       NOTE: we output the name and file-id in the HREF to avoid the browser thinking
       that the link has been visited already.  The link will only show
       as visitted if the name, file-id and field-id match.  */
    {&OUT} 
      '&nbsp~;&nbsp~;&nbsp~;' /* Indent a few spaces. */
      '<A HREF="_main.w?html=propertySheet'
                '&amp~;name=' url-encode(h_name,"QUERY":U)
                '&amp~;file-id=' RECID(_P)
                '&amp~;field-id=' RECID(_U) '">' /* NO ~n */
      '<IMG SRC="/webspeed/workshop/' icon-name '.gif" WIDTH=16 HEIGHT=16 BORDER=0>&nbsp~;' html-encode(h_name) '</A><BR>~n'
      .  
    /* Now output the event procedures for this object. */
    FOR EACH ip_code WHERE ip_code._l-recid eq RECID(_U) 
                       AND ip_code._section eq "_CONTROL":U  
                        BY ip_code._name:
      RUN output-code-link (RECID(ip_code), ip_code._name, "i-code":U, 
                            '&nbsp~;&nbsp~;&nbsp~;&nbsp~;&nbsp~;&nbsp~;&nbsp~;&nbsp~;&nbsp~;&nbsp~;':U).
    END.

  END. /* FOR EACH _U:... */

END PROCEDURE.
&ANALYZE-RESUME
&ANALYZE-SUSPEND _CODE-BLOCK _PROCEDURE output-code-link 
PROCEDURE output-code-link :
/*------------------------------------------------------------------------------
  Purpose:     Show the contents (objects and code sections) for the open file.
  Parameters:  p_codeID  : recid of the code block
               p_linkText: Text of the link.
               p_icon    : Icon to use on the link
               p_indent  : Indent at start of line
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p_codeId   AS RECID NO-UNDO.
  DEFINE INPUT PARAMETER p_linkText AS CHAR NO-UNDO.
  DEFINE INPUT PARAMETER p_icon     AS CHAR  NO-UNDO.
  DEFINE INPUT PARAMETER p_indent   AS CHAR  NO-UNDO.   
  
  /* Output the link.
     NOTE: we output the file-id and link text in the HREF to avoid the browser
     thinking that the link has been visited already.  The link will only show
     as vistted if the section-id and link text match.  */  
  {&OUT} 
     p_indent
     '<A HREF="_main.w?html=editSection'
               '&amp~;name=' url-encode(p_linkText,"QUERY":U)
               '&amp~;file-id=' RECID(_P) 
               '&amp~;section-id=' p_codeID '">' /* NO ~n */
     '<IMG SRC="/webspeed/workshop/' p_icon '.gif" WIDTH=16 HEIGHT=16 BORDER=0>&nbsp~;'
     /*  Convert the link text to HTML with non-breaking spaces. */
     REPLACE (html-encode(p_linkText), " ":U, "&nbsp~;":U)
     '</A><BR>~n'
     .

END PROCEDURE.
&ANALYZE-RESUME
&ANALYZE-SUSPEND _CODE-BLOCK _PROCEDURE output-list-doc 
PROCEDURE output-list-doc :
/*------------------------------------------------------------------------------
  Purpose:     Show the contents (objects and code sections) for the open file.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE l_header  AS LOGICAL NO-UNDO.
  DEFINE VARIABLE next-id   LIKE _code._next-id NO-UNDO.
  DEFINE VARIABLE icon-name AS CHAR NO-UNDO.
  
  /* Parse options. */
  l_header = LOOKUP ("NO-HEAD", p_options) eq 0.
  
  /* Generate the header if necessary. */
  IF l_header THEN DO:
    RUN outputContentType IN web-utilities-hdl ("text/html":U).
    {&OUT} 
      { workshop/html.i &SEGMENTS = "head,open-body"
                        &FRAME    = "WSFI_index" 
                        &AUTHOR   = "Wm.T.Wood"
                        &TITLE    = "File Contents" 
                        &TARGET   = "WSFC_main" }
      .
  END.
  
  /* Get the relevent _P record. */
  FIND _P WHERE RECID(_P) eq p_proc-id NO-ERROR.
  IF ( NOT AVAILABLE _P ) 
  THEN RUN HtmlError IN web-utilities-hdl
           (SUBSTITUTE ('File id &1 not found.', p_proc-id)).
  ELSE DO:
    {&OUT}
      '<CENTER>'
      format-filename (_P._filename, "Contents of &1", "":U) 
      '</CENTER>~n'.
    
    /* Were there any code sections? */
    RUN workshop/_find_cd.p (p_proc-id, "FIRST":U, "":U, OUTPUT next-id).
    IF next-id eq ? THEN {&OUT} 'File is empty.'.
    ELSE DO:  
      DO WHILE next-id ne ?:                     
        /* Get this record, and set up for the next one. */
        FIND _code WHERE RECID(_code) eq next-id.          
        next-id = _code._next-id.
        
        /* Loop though all non-hidden sections. Also, skip procedures and functions
           because we will do those last. Control triggers will be output with the
           form buffer. Print the form buffer section when we get to it. */ 
        IF _code._special eq "_FORM-BUFFER":U 
        THEN RUN list-fields.
        ELSE DO:
          IF _code._section NE "_HIDDEN":U AND
             LOOKUP(_code._section, "_FUNCTION,_PROCEDURE,_CONTROL":U) eq 0
          THEN DO:
            CASE _code._section:
              WHEN "_CUSTOM":U    THEN icon-name = "i-code":U.
              OTHERWISE                icon-name = "i-info":U.
            END CASE. 
            RUN output-code-link (RECID(_code), _code._name, icon-name, "":U).
          END. /* IF [not hidden] */
        END. /* IF [not] _Form-Buffer... */
          
      END. /* DO WHILE AVAIL... _code... */    
      
      /* Now output the procedures. */
      FOR EACH _code WHERE _code._p-recid eq p_proc-id 
                       AND (_code._section eq "_PROCEDURE":U OR _code._section eq "_FUNCTION":U)
                        BY _code._name:
          icon-name = IF _code._section eq "_PROCEDURE" THEN "i-proc":U ELSE "i-fun":U.
          RUN output-code-link (RECID(_code), _code._name, icon-name, "":U).
      END.   
      
    END. /* IF...AVAIL _code... */
  END. /* IF...AVAIL _P... */
  
  /* Close the file after a few blank lines, if necessary. */
  IF l_header THEN {&OUT} '<BR>&nbsp~;<BR>~n</BODY>~n</HTML>~n'.
  
END PROCEDURE.
&ANALYZE-RESUME
 

