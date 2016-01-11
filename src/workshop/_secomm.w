&ANALYZE-SUSPEND _VERSION-NUMBER WDT_v2r1 WebSpeed-Object
&ANALYZE-RESUME
&ANALYZE-SUSPEND _CODE-BLOCK _CUSTOM Definitions 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*------------------------------------------------------------------------
  File: _secomm.w
  
  Description: Main Command file for the for the backend of WebSpeed Workshop
               Section Editor.
  Parameters:  <none>
  
  Note: Remember, in order to be read by the section editor, the last
        line should end in a line-feed.

  Author:  Wm. T. Wood
  Created: Sept. 21, 1996
------------------------------------------------------------------------*/
/*           This .W file was created with WebSpeed Workshop            */
/*----------------------------------------------------------------------*/


/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/* Included Definitions ---                                             */
{ workshop/pre_proc.i }  /* Shared code temp-tables.            */
{ workshop/code.i }      /* Shared code temp-tables.            */
{ workshop/htmwidg.i }   /* Shared HTM fields temp-tables.      */
{ workshop/objects.i }   /* Shared objects temp-tables.         */
{ workshop/sharvars.i }  /* Shared variables                    */
{ workshop/uniwidg.i }   /* Shared control temp-tables.         */
{ workshop/wserrors.i }  /* List of internal Workshop errors   */

/* Preprocessor Definitions ---                                         */
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

{src/web/method/wrap-cgi.i}
&ANALYZE-RESUME _END-INCLUDED-LIBRARIES

&ANALYZE-SUSPEND _CODE-BLOCK _CUSTOM "Main Code Block" 


/* ************************  Local Definitions *********************** */
DEF VAR command  AS CHAR NO-UNDO.
DEF VAR c_field  AS CHAR NO-UNDO.
DEF VAR proc-id  AS INTEGER NO-UNDO.

/* ************************  Main Code Block  *********************** */

/* Output our own type of response. */
RUN outputContentType IN web-utilities-hdl ("{&WS-MIME}":U).  

/* Get the command and context. Based on this command, decide what to do. */
RUN GetField IN web-utilities-hdl (INPUT "command", OUTPUT command).
RUN GetField IN web-utilities-hdl (INPUT "file-id", OUTPUT c_field).
FIND _P WHERE RECID(_P) eq INTEGER(c_field) NO-ERROR.
IF NOT AVAILABLE (_P) THEN DO:   
  /* Unrecoverable error. */
  {&OUT} "-30~nFile not found.~n".  
  RETURN.    
END.     
ELSE IF NOT _P._open THEN DO:
  /* It is an internal error if the section editor tries to access a
     file that has been closed. */
  {&OUT} {&File_Closed_Error} .  
  RETURN.    
END.
ELSE DO:   
  /* Store the procedure id. */
  proc-id = INTEGER(RECID(_P)).
  
  /* Base things on the command. */
  CASE command: 
    WHEN "checkSection" OR
    WHEN "deleteSection" OR
    WHEN "getSection":U OR 
    WHEN "putSection":U THEN DO:
      RUN GetField IN web-utilities-hdl (INPUT "section-id", OUTPUT c_field).
      IF c_field ne "":U THEN DO:
        FIND _code WHERE RECID(_code) eq INTEGER(c_field) 
                     AND _code._P-recid eq proc-id NO-ERROR. 
        IF NOT AVAILABLE (_code) THEN DO:
          /* Unrecoverable error. */
          {&OUT} "-30~nSection does not exist.~n".      
          RETURN.
        END.
      END.   
      /* Now that the section-id has been found, process the command. */
      CASE command:        
        WHEN "checkSection":U  THEN RUN check-section.
        WHEN "deleteSection":U THEN RUN delete-section.
        WHEN "getSection":U    THEN RUN get-section.
        WHEN "putSection":U    THEN RUN put-section.
      END CASE.
    END.
  
    WHEN "getEventOptions":U THEN RUN get-event-list.
    
    WHEN "getSectionList":U  THEN RUN get-section-list.

    WHEN "newSection":U THEN RUN new-section.

    OTHERWISE  
      /* Bad command given to this file. */
      {&OUT} '-30~nUnrecognized command.~n'.
 
  END CASE.
END. /* File found. */
&ANALYZE-RESUME
/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _CODE-BLOCK _PROCEDURE check-section 
PROCEDURE check-section :
/*------------------------------------------------------------------------------
  Purpose:     Checks the syntax of the file up to the current section
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE c-scrap AS CHAR NO-UNDO.
  
  /* Check syntax for this file. See if the error. */
  ASSIGN _err_recid = ?.
  RUN workshop/_gen4gl.p (INPUT proc-id, "CHECK-SECTION":U, RECID(_code), ?,
                          OUTPUT c-scrap).
  /* Check the error case. Either no error, error in another section,
     of an error to report. */
  IF _err_recid eq ? THEN  
    {&OUT} '~nSyntax is correct.~n':U.  
  ELSE IF _err_recid ne RECID(_code) THEN
    {&OUT} '-30~nThis section could not be checked due to an error in another section.~n'.
  ELSE 
    {&OUT} _err_num '~n' _err_msg '~n'.
  
END PROCEDURE.
&ANALYZE-RESUME
&ANALYZE-SUSPEND _CODE-BLOCK _PROCEDURE delete-section 
PROCEDURE delete-section :
/*------------------------------------------------------------------------------
  Purpose:     Delete the code section and return the result.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
                       
  /* Delete the section. */
  RUN workshop/_del_cd.p (RECID(_code)).

  /* Record that the file is now "modified". */
  _P._modified = yes.
  
  /* Return the result. Remember last line feed. */
  {&OUT} '~nSection deleted.~n':U.
  
END PROCEDURE.
&ANALYZE-RESUME
&ANALYZE-SUSPEND _CODE-BLOCK _PROCEDURE get-event-list 
PROCEDURE get-event-list :
/*------------------------------------------------------------------------------
  Purpose: Return the list of events that are possible for a given file 
           Each line is of the form: 
                  control-id,control-name,event1,event2,[...]
           For example:
           1245,Web-Query,OPEN_QUERY
           2134,cust-prompt,web.input,web.output

------------------------------------------------------------------------------*/
  DEFINE VARIABLE c_name AS CHAR NO-UNDO.
  
  /* It is ok to go ahead. Lead with a blank line. */
  {&OUT} '~n':U.

  /* Were there any code sections? */    
  FOR EACH _U WHERE _U._P-recid eq proc-id  AND _U._status ne 'DELETED':U: 
    IF _U._TYPE eq "QUERY":U THEN
      {&OUT} SUBSTITUTE ("&1,&2,OPEN_QUERY~n":U, RECID(_U), _U._NAME).
    ELSE IF _U._TYPE ne "FRAME":U THEN DO:   
      FIND _HTM WHERE _HTM._U-recid eq RECID(_U) NO-ERROR.
      IF AVAILABLE _HTM THEN DO:
        /* Get the name of the widget. */
        c_name = { workshop/name_u.i &U_BUFFER = "_U" } .      
        {&OUT} SUBSTITUTE ("&1,&2,web.input,web.output~n":U,
                           RECID(_U), 
                           c_name).        
      END.
    END.
  END.
END PROCEDURE.
&ANALYZE-RESUME
&ANALYZE-SUSPEND _CODE-BLOCK _PROCEDURE get-section 
PROCEDURE get-section :
/*------------------------------------------------------------------------------
  Purpose:     Return all the code segments of the current section.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE next-id LIKE _code-text._next-id NO-UNDO.
  DEFINE VARIABLE txt AS CHAR NO-UNDO.

  /* Code section found. Lead with a blank line. */
  {&OUT} '~n':U.
  
  /* Is this a Workshop maintained section? If so, return the generated
     code? */
  IF _code._special ne "":U THEN DO:    
    RUN workshop/_coddflt.p (_code._special, _code._l-recid, OUTPUT txt). 
    {&OUT} RIGHT-TRIM(txt).
  END.
  ELSE DO:
    /* Get all the code segments. */
    FIND _code-text WHERE RECID(_code-text) eq _code._text-id NO-ERROR.
    DO WHILE AVAILABLE _code-text:    
      /* Output this block, and find the next one. */
      {&OUT} _code-text._text.
      next-id = _code-text._next-id.
      FIND _code-text WHERE RECID(_code-text) eq next-id NO-ERROR.   
    END.  
  END. /* IF _code._special [eq] "" ... */
   
  /* Close with a blank line. */
  {&OUT} '~n':U.
  
END PROCEDURE.
&ANALYZE-RESUME
&ANALYZE-SUSPEND _CODE-BLOCK _PROCEDURE get-section-list 
PROCEDURE get-section-list :
/*------------------------------------------------------------------------------
  Purpose: Return the list of sections to the WEBSTREAM. 
           Each line is of the form: 
                  section-id,status,type,,name 
            Valid statuses are: 
                  blank -- a normal, edittable file 
                  READ-ONLY -- no editing of section
                  REFRESH -- don't cache the contents of the section. 
            Valid types are: 
                  _CONTROL -- an event trigger 
                  _PROCEDURE -- a procedure 
                  _FUNCTION -- a function 
                  _CUSTOM -- a user defined code block 
                  _SCRIPT -- E4GL Script section     
                  
            The result would look something like: 
                  [first line blank]
                  122,,_CUSTOM,Definitions
                  145,,_CONTROL,web.output OF name,232
                  165,,_CUSTOM,Main Block
                  173,READ-ONLY,_PROCEDURE,htm-offsets
                  187,,_PROCEDURE,process-web-request  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE c_name  AS CHAR NO-UNDO.     
  DEFINE VARIABLE next-id LIKE _code._next-id NO-UNDO.     
  
  /* Code section found. Lead with a blank line. */
  {&OUT} '~n':U.

  /* Were there any code sections? */    
  RUN workshop/_find_cd.p (proc-id, "FIRST":U, "":U, OUTPUT next-id).
  DO WHILE next-id ne ?: 
    /* Is this a section that is edittable in the section editor? */ 
    FIND _code WHERE RECID(_code) eq next-id. 
    CASE _code._section:
      WHEN "_CUSTOM":U OR 
      WHEN "_FUNCTION":U OR 
      WHEN "_PROCEDURE":U THEN
        {&OUT} SUBSTITUTE ("&1,&2,&3,&4~n":U,
                           RECID(_code),
                           IF _code._special ne "":U THEN "READ-ONLY" ELSE "",
                           _code._section,
                           _code._name).
    END CASE. 
    /* Get the next code section. */
    next-id = _code._next-id.
  END. /* DO WHILE AVAIL... _code... */
  
  /* Output the Code Triggers. */
  FOR EACH _U WHERE _U._P-recid eq proc-id AND _U._STATUS ne ? BY _U._NAME:
    FOR EACH _code WHERE _code._l-recid eq RECID(_U) 
                     AND _code._section eq "_CONTROL":U:
      c_name = { workshop/name_u.i &U_BUFFER = "_U" } .
      {&OUT} SUBSTITUTE ("&1,&2,&3,&4,5~n":U,
                         RECID(_code),
                         "":U,
                         _code._section,
                         _code._name + " OF " + c_name,
                         _code._l-recid).    
    END. /* FOR EACH _code ... */
  END. /* FOR EACH _U... */
END PROCEDURE.
&ANALYZE-RESUME
&ANALYZE-SUSPEND _CODE-BLOCK _PROCEDURE new-section 
PROCEDURE new-section :
/*------------------------------------------------------------------------------
  Purpose:     Create a new section with the appropriate name.
  Parameters:  <none>  
  Fields:      This looks for fields of the form:
                 section - the section of the code to create   
                 name - name of section to create
                 prev-section-id - the ID of the previous section to create
                                   this after
                 control-id -- for new _CONTROL triggers, this is the
                               associated widget id.
                 
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE c_field    AS CHARACTER NO-UNDO.  
  DEFINE VARIABLE c_name     AS CHARACTER NO-UNDO.
  DEFINE VARIABLE c_section  AS CHARACTER NO-UNDO.
  DEFINE VARIABLE check-list AS CHARACTER NO-UNDO.
  DEFINE VARIABLE l_error    AS LOGICAL   NO-UNDO INITIAL no.
  
  DEFINE VARIABLE code-id AS RECID NO-UNDO.
  DEFINE VARIABLE l-recid AS RECID NO-UNDO INITIAL ?. 
  DEFINE VARIABLE prev-id AS RECID NO-UNDO INITIAL ?.

  /* There are three errors:
       1. The previous section (if given) does not exist [However, in
          this case we add it at the end.
       2. There is already a section with this name. 
       3. The control id does not exist in this file. */      
       
  /* Process the section from the command. Get related fields. */
  RUN GetField IN web-utilities-hdl ("section":U, OUTPUT c_section).
  CASE c_section:
    WHEN "_CUSTOM":U THEN DO:
      /* Need a previous section. */
      RUN GetField IN web-utilities-hdl ("prev-section-id":U, OUTPUT c_field). 
      IF c_field ne "" THEN ASSIGN prev-id = INTEGER(c_field) NO-ERROR.
    END.
    WHEN "_CONTROL":U THEN DO: 
      RUN GetField IN web-utilities-hdl ("control-id":U, OUTPUT c_field). 
      IF c_field ne "" THEN ASSIGN l-recid = INTEGER(c_field) NO-ERROR.   
      FIND _U WHERE RECID(_U) eq l-recid
                AND _U._status ne "DELETED":U
                AND _U._P-recid eq proc-id NO-ERROR.
      /* Does it exist? */
      IF NOT AVAILABLE (_U) THEN DO:
        {&OUT} '-30~nThe control for this event could not be found.~n'.
        l_error = yes.
      END.
    END.      
  END CASE.
  
  /* Associate this with the current procedure, if not given. */
  IF l-recid eq ? THEN l-recid = proc-id.
            
  /* Does a code block already exist with this name? Note for
     procedures and functions, we need to check the other section
     as well.  */
  check-list = IF LOOKUP(c_section, "_FUNCTION,_PROCEDURE":U) > 0
               THEN "_FUNCTION,_PROCEDURE" ELSE c_section.
  RUN GetField IN web-utilities-hdl ("name":U, OUTPUT c_name).
  FIND _code WHERE _code._P-recid eq proc-id
               AND _code._l-recid eq l-recid
               AND _code._name eq c_name
               AND LOOKUP(_code._section, check-list) > 0 NO-ERROR.
  IF AVAILABLE _code THEN DO:
    l_error = yes.
    {&OUT} '-30~nA code section with this name already exists.'
           'The new section was not added.~n.'
           .
  END.
  
  /* Continue if there was no error. */
  IF NOT l_error THEN DO:
    /* Create a new section (insert at the end if no previous id). */
    IF prev-id eq ? THEN 
      RUN workshop/_find_cd.p (proc-id, "LAST":U, "":U, OUTPUT prev-id).
    RUN workshop/_ins_cd.p
          (INPUT prev-id,     /* Previous ID */
           INPUT RECID(_P),   /* Procedure ID */
           INPUT l-recid,     /* Associated Object */
           INPUT c_section,   /* Workshop Section */
           INPUT "":U,        /* Special -- none of these have handlers */
           INPUT c_name,      /* Name of section */
           OUTPUT code-id).   /* New section. */
    
    /* Find the section (to set the _code record) and put the code in it. */
    FIND _code WHERE RECID(_code) eq code-id.
    RUN put-section.  
  END. /* IF NOT l_error... */
  
END PROCEDURE.
&ANALYZE-RESUME
&ANALYZE-SUSPEND _CODE-BLOCK _PROCEDURE put-section 
PROCEDURE put-section :
/*------------------------------------------------------------------------------
  Purpose:     Saves the contents of the code, code:1, code:2 etc fields
               in the current code section. We keep looking for code:n
               sections until an empty one is found.
  Parameters:  <none>         
  Fields:      The two fields checked are the code field and the name field
               The name field is optional. If given, then the section is
               renamed to the new section.
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE code    AS CHAR NO-UNDO.     
  DEFINE VARIABLE c_name  AS CHAR NO-UNDO.     
  DEFINE VARIABLE i       AS INTEGER NO-UNDO.
  DEFINE VARIABLE next-id LIKE _code._next-id NO-UNDO.       
  DEFINE VARIABLE prev-id LIKE next-id NO-UNDO.
  
  DEFINE BUFFER prev_text FOR _code-text.
  
  /* There is no way that the code won't be saved. 
     Return the success response -- this is the section-id (so that we
     can pass back the section-id if the section is new!),
      with a final Line-feed. */
  {&OUT} '~n' RECID(_code) '~nSection successfully submitted.~n'.

  /* Record that the file is now "modified". */
  _P._modified = yes.
                        
  /* See if there is a new name for the code section. */    
  RUN GetField IN web-utilities-hdl ("name":U, OUTPUT c_name).
  IF c_name ne "":U THEN _code._name = c_name.
                        
  /* Store the first text section of the code.  Create the text
     section if necessary. */    
  RUN GetField IN web-utilities-hdl ("code":U, OUTPUT code).
  IF _code._text-id ne ? THEN 
    FIND _code-text WHERE RECID(_code-text) eq _code._text-id.
  IF NOT AVAILABLE _code-text THEN DO:
    CREATE _code-text.
    ASSIGN _code._text-id = RECID(_code-text)
           _code-text._code-id = RECID(_code)
           .    
  END. /* IF NOT AVAILABLE _code-text... */
  /* Store the first code section. */
  _code-text._text = code.
  
  /* See if there are any additional code sections. */
  ASSIGN i = 0
         next-id = _code-text._next-id
         prev-id = RECID(_code-text).    
  DO WHILE code ne "":U:
    /* Look for the next "code:n" section. */
    i = i + 1.     
    RUN GetField IN web-utilities-hdl 
           ("code:":U + LEFT-TRIM(STRING(i,">>>>9":U)), OUTPUT code).
    IF code ne "":U THEN DO:
      /* Store the code in the existing next section, if it exists.
         Create a new section if none exists. */
      IF next-id ne ?
      THEN FIND _code-text WHERE RECID(_code-text) eq next-id.
      ELSE DO: 
        /* We need to link the new section to the old one, so
           find the previous one. */
        FIND prev_text WHERE RECID(prev_text) eq prev-id.
        CREATE _code-text.
        ASSIGN _code-text._code-id = prev_text._code-id
               prev_text._next-id  = RECID(_code-text).
      END.
      /* Store the code. */
      ASSIGN _code-text._text = code   
             next-id = _code-text._next-id
             prev-id = RECID(_code-text)
             .
    END. /* IF code ne "":U... */
  END. /* DO... */  
  
  /* Set the next-id of the last section to be unknown. */
  IF AVAILABLE _code-text THEN _code-text._next-id = ?.
  
  /* If we have stored all the code-text segments, we still need to
     check for additional segments that used to exist, but are no
     longer needed. For example, if the user deleted some code, then
     fewer sections will be needed. */
  DO WHILE next-id ne ?:
    FIND _code-text WHERE RECID(_code-text) eq next-id.  
    next-id = _code-text._next-id.
    DELETE _code-text.
  END. /* DO WHILE next-id ne ?:... */
END PROCEDURE.
&ANALYZE-RESUME
 

