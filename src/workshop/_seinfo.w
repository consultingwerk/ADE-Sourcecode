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
  File: _seinfo.w
  
  Description: Returns some information to the Section Editor.
  Parameters:  <none>                
  
  Note: Remember, in order to be read by the section editor, the last
        line should end in a line-feed.
        
  Author:  Wm. T. Wood
  Created: February 12, 1997
------------------------------------------------------------------------*/
/*           This .W file was created with WebSpeed WorkBench.          */
/*----------------------------------------------------------------------*/


/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/* Included Definitions ---                                             */
{ workshop/pre_proc.i }  /* Shared code temp-tables.    */

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

/* ************************  Main Code Block  *********************** */

/* Output our own type of response. */
RUN outputContentType IN web-utilities-hdl ("{&WS-MIME}":U).  

/* Get the command and context. Based on this command, decide what to do. */
RUN GetField IN web-utilities-hdl (INPUT "command", OUTPUT command).
CASE command: 
  WHEN "getUtilityCallList":U THEN RUN list-web-utilities.     
  WHEN "sectionTemplate":U    THEN RUN get-code-default.
  OTHERWISE  
    /* Bad command given to this file. */
    {&OUT} '-30~nUnrecognized command.~n'.
END CASE.
&ANALYZE-RESUME
/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _CODE-BLOCK _PROCEDURE get-code-default 
PROCEDURE get-code-default :
/*------------------------------------------------------------------------------
  Purpose:     Create a new section with the appropriate name.
  Parameters:  <none>
  Fields:      This looks for fields of the form:
                 section - the section of the code to create   
                 name - name of section to create
                 control-id -- recid of _U for _CONTROLS.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE adm-name   AS CHARACTER NO-UNDO.
  DEFINE VARIABLE c_datatype AS CHARACTER NO-UNDO.
  DEFINE VARIABLE c_field    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE c_name     AS CHARACTER NO-UNDO.
  DEFINE VARIABLE c_return   AS CHARACTER NO-UNDO.
  DEFINE VARIABLE c_section  AS CHARACTER NO-UNDO.
  DEFINE VARIABLE code       AS CHARACTER NO-UNDO.
  DEFINE VARIABLE template   AS CHARACTER NO-UNDO.

  DEFINE VARIABLE p-recid    AS RECID NO-UNDO.
  DEFINE VARIABLE u-recid    AS RECID NO-UNDO.
 
  /* Get the section and name and procedure. */
  RUN GetField IN web-utilities-hdl ("section":U, OUTPUT c_section).
  RUN GetField IN web-utilities-hdl ("name":U,    OUTPUT c_name).
  RUN GetField IN web-utilities-hdl ("file-id":U, OUTPUT c_field).
  ASSIGN p-recid = INTEGER(c_field) NO-ERROR.
  
  CASE c_section:
    WHEN "_CUSTOM":U THEN DO:
      /* Return an empty block. */
      code = "~n":U.
    END.
    WHEN "_CONTROL":U THEN DO:  
      /* Get the widget id. */
      RUN GetField IN web-utilities-hdl ("control-id":U, OUTPUT c_field).
      ASSIGN u-recid = INTEGER(c_field) NO-ERROR.
      /* Adjust the name. */
      template = IF c_name eq "web.input" THEN "_WEB.INPUT":U
                 ELSE IF c_name eq "web.output" THEN "_WEB.OUTPUT":U   
                 ELSE IF c_name eq "OPEN_QUERY" THEN "_OPEN-QUERY":U
                 ELSE '':U.
      IF template eq '':U 
      THEN code = "DO:~n  ~nEND.~n":U.
      ELSE RUN workshop/_coddflt.p (template, u-recid, OUTPUT code).
    END. /* WHEN _CONTROL... */
    
    WHEN "_FUNCTION" THEN DO: 
      /* Get the default datatype and set a return value */
      c_datatype = CAPS(get-value ('returns':U)).
      IF c_datatype eq "":U THEN c_datatype = "CHARACTER":U.
      CASE c_datatype:
        WHEN "CHARACTER":U THEN c_return = '""':U.        
        WHEN "INTEGER":U   THEN c_return = '0':U.
        WHEN "DECIMAL":U   THEN c_return = '0.0':U.
        OTHERWISE               c_return = '?':U.
      END CASE.
      RUN workshop/_coddflt.p ("_FUNCTION":U, p-recid, OUTPUT code). 
      /* SUBSTITUTE the result with &1=name, &2=Datatype, &3=Return-Value */
      code = SUBSTITUTE ( RIGHT-TRIM(code), c_name, c_datatype, c_return).         
    END. /* WHEN _PROCEDURE... */
    
    WHEN "_PROCEDURE" THEN DO:        
      IF c_name BEGINS "local-":U THEN DO:
        /* This is an adm- name.  Remove the local- part. */
        adm-name = SUBSTRING(c_name, 7, -1, "CHARACTER":U).         
        RUN workshop/_coddflt.p ("_LOCAL-METHOD":U, p-recid, OUTPUT code).
        /* This code needs to have the adm smart-method replaced. */
        code = REPLACE(code, "_SMART-METHOD", adm-name).
      END.                                              
      ELSE RUN workshop/_coddflt.p ("_PROCEDURE":U, p-recid, OUTPUT code). 
      /* SUBSTITUTE the result with &1=name */
      code = SUBSTITUTE ( RIGHT-TRIM(code), c_name ).         
    END. /* WHEN _PROCEDURE... */
  END CASE.
  /* Return the code (after a blank line). All Section Editor commands
     must end in a line feed. */
  {&OUT} '~n' code '~n'.
  
END PROCEDURE.
&ANALYZE-RESUME
&ANALYZE-SUSPEND _CODE-BLOCK _PROCEDURE list-web-utilities 
PROCEDURE list-web-utilities :
/*------------------------------------------------------------------------------
  Purpose: Returns a list of the internal procedures, functions, and
           adm-events found in web-utilities-hdl
                  section-id,status,type,,name 
           The response is of the form:
                  [first line blank]
                  ADM-event,name (minus the adm)
                  PROCEDURE,name,,param param-type
                  FUNCTION,name,return-type,param param-type
------------------------------------------------------------------------------*/
  DEF VAR c_adm       AS CHAR    NO-UNDO.
  DEF VAR c_list      AS CHAR    NO-UNDO.
  DEF VAR c_name      AS CHAR    NO-UNDO.   
  DEF VAR c_signature AS CHAR    NO-UNDO.
  DEF VAR cnt         AS INTEGER NO-UNDO.                                
  DEF VAR h           AS HANDLE  NO-UNDO.
  DEF VAR i           AS INTEGER NO-UNDO.
  
  
  /* Lead with a blank line. */
  {&OUT} '~n':U.
  
  /* Go through the internal entries of the web-utilities-hdl. */
  ASSIGN h      = web-utilities-hdl
         c_list = h:INTERNAL-ENTRIES
         cnt    = NUM-ENTRIES (c_list)
         .
  DO i = 1 TO cnt:                  
    /* Get the ith entry. If it is an adm entry (i.e. it begins
       with LOCAL- or ADM- and its signature has no parameters)
       then check that we have already returned it. */
    ASSIGN c_name = ENTRY(i,c_list).
           c_signature = h:GET-SIGNATURE (c_name).                         
    /* Is it an ADM- event? */
    IF (c_name BEGINS "adm-":U or c_name BEGINS "local-":U) AND
       (c_signature eq "PROCEDURE,,":U)
    THEN DO:   
      /* Remove the ADM- or LOCAL- prefix */
      IF c_name BEGINS "local-" 
      THEN c_name = SUBSTRING(c_name,7,-1,"CHARACTER":U).
      ELSE c_name = SUBSTRING(c_name,5,-1,"CHARACTER":U).
      /* Have we output this one already? */
      IF LOOKUP(c_name, c_adm) eq 0 THEN DO:   
        {&OUT} 'ADM-event,' c_name '~n'.
        c_adm = c_adm + "," + c_name.
      END.
    END. 
    ELSE DO:
      /* Return the signature of a non-adm procedure or function. 
         Add the name in after the type. (eg. PROCEDURE,name,,param)*/
      ENTRY(1,c_signature) = ENTRY(1,c_signature) + ",":U + c_name.
      {&OUT} c_signature '~n'.
    END.  
    
  END.
  
END PROCEDURE.
&ANALYZE-RESUME
 

