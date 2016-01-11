/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*----------------------------------------------------------------------------

File: _coddflt.p

Description:
    Generate the default code sections for the Workshop  These are the 
    default code templates:
        _INCLUDED-LIB        - Included Method Libraries Code Block 
        _OPEN-QUERY          - OPEN QUERY statement of a query
        _PROCEDURE           - Default Procedure code (name=&1)
        _FUNCTION            - Default Function (name=&1, type=&2, return=&3)
        _LOCAL-METHOD        - Template for Local ADM Method.
        _WEB.INPUT           - WEB control INPUT procedure.
        _WEB.OUTPUT          - WEB control OUTPUT procedure.
        _WEB-HTM-OFFSETS     - WEB HTM offsets procedure.

    We can also take the name of a procedure to run in this space.
    The call is made to this procedure:
        RUN VALUE(p_template) (INPUT INTEGER(RECID(_P), OUTPUT p_code).
    This will populate the code section with exactly what would appear
    in the Code Section Editor.  That is, for a procedure, it would include
    the "END PROCEDURE." at the bottom ,but not the "PROCEDURE name :" 
    at the top.                                             
       
Input Parameters:
    p_template - the type of code to generate (see list above).
    p_recid    - the RECID(_U) for the object (if we are creating a
                 control trigger, or the recid of the procedure itself.
 
Output Parameters:
    p_code     - the text created for this widget.

Author: Wm.T.Wood

Date Created: Feb 10, 1997 [based on my old UIB version adeshar/_coddflt.p]
                             
Modified:	
----------------------------------------------------------------------------*/

DEFINE INPUT  PARAMETER     p_template  AS CHAR       NO-UNDO.
DEFINE INPUT  PARAMETER     p_recid     AS RECID      NO-UNDO.
DEFINE OUTPUT PARAMETER     p_code      AS CHAR       NO-UNDO.

/* Include files */
{ workshop/objects.i }     /* Universal Widget TEMP-TABLE definition         */
{ workshop/uniwidg.i }     /* Universal Widget TEMP-TABLE definition         */
{ workshop/code.i }        /* Code Section TEMP-TABLE definition             */
{ workshop/sharvars.i }    /* Shared variables                               */
{ workshop/pre_proc.i }    /* Preprocessor Variables                         */  

/* Standard End-of-line character - adjusted in 7.3A to be just chr(10) */
&Scoped-define EOL CHR(10)


DEFINE VAR  comment-ln  AS CHAR       NO-UNDO INITIAL
  "------------------------------------------------------------------------------".

DEFINE VAR  db-list     AS CHAR       NO-UNDO.
DEFINE VAR  file_name   AS CHAR       NO-UNDO.
DEFINE VAR  i           AS INTEGER    NO-UNDO.
DEFINE VAR  j           AS INTEGER    NO-UNDO.
DEFINE VAR  per-pos     AS INTEGER    NO-UNDO.
DEFINE VAR  token       AS CHAR       NO-UNDO.


/* Find the Current Record and Procedure , and get some information about it. */
IF p_recid <> ? THEN DO:   
  IF LOOKUP (p_template, "_OPEN-QUERY,_WEB.INPUT,_WEB.OUTPUT":U) > 0 THEN DO:
    FIND _U WHERE RECID(_U) eq p_recid NO-ERROR.
    FIND _P WHERE RECID(_P) eq _U._P-recid. 
  END.
  ELSE DO:
    FIND _P WHERE RECID(_P) eq p_recid.
  END.
END.

/* Now create the code segment. */
ASSIGN p_code = "".

CASE p_template:

 /**************************************************************************/
 /*                          _INCLUDED-LIB                                 */  
 /**************************************************************************/
  WHEN "_INCLUDED-LIB" THEN DO:
    ASSIGN p_code =
"/* Included Libraries --- */"
    + {&EOL} .
  END.

 /**************************************************************************/
 /*                          _OPEN-QUERY                                   */  
 /**************************************************************************/
  WHEN "_OPEN-QUERY" THEN DO:
    FIND _Q WHERE RECID(_Q) = _U._x-recid.

    IF _Q._TblList ne "" THEN DO:
      /* Get all CR/LF into tilde-LINE FEED */
      p_code = REPLACE (
		    REPLACE (TRIM(_Q._4GLQury),
			     CHR(13), ""),
		    CHR(10), " ~~" + CHR(10) )  .
      IF _suppress_dbname THEN DO:
      /* Need to adjust dbname and/or table name                               */
        db-list = "".
        DO i = 1 TO NUM-DBS:                      /* Build list of DB names    */
          db-list = db-list + (IF LENGTH(db-list,"RAW":U) = 0
                               THEN ldbname(i) ELSE ("," + ldbname(i))) +
                              ",":U + pdbname(i).
        END.
      
        IF _suppress_dbname AND (_U._TYPE = "FRAME":U) THEN DO:
          /* sports.customer --> customer AND 
             sports.customer.name --> customer.name    */
          DO i = 1 TO NUM-DBS:
            p_code = REPLACE(p_code," " + ldbname(i) + ".", " ").
            IF ldbname(i) NE pdbname(i) THEN
              ASSIGN p_code = REPLACE(p_code," " + pdbname(i) + ".", " ").
          END.  /* FOR EACH CONNECTED DATABASE */
        END.  /* If only suppressed */

        ELSE IF NOT _suppress_dbname AND
                _U._TYPE = "BROWSE":U THEN DO:
          /* sports.customer --> sports_customer AND                          */
          /* sports.customer.name --> sports_customer.name                    */
          DO i = 2 TO NUM-ENTRIES(p_code," ") - 1: /* Not the EACH or NO-LOCK */
	     token = ENTRY(i,p_code," ").
	     IF CAN-DO(db-list,ENTRY(1,token,".")) THEN DO:  /* Token starts with 
	                                                        dbname         */
              ASSIGN per-pos  = INDEX(token,".")
		   OVERLAY(token,per-pos,1,"CHARACTER":U) = "_"                   
		   ENTRY(i,p_code," ") = token.
            END.  /* If token begins with a DB-NAME */
            ELSE DO:   /* See if token starts with a table name               */
              DO j = 1 TO NUM-ENTRIES(_Q._TblList," "):
                IF ENTRY(j,_Q._TblList," ") NE "OF" AND
                   ENTRY(2,ENTRY(j,_Q._TblList," "),".") = ENTRY(1,token,".")
                 THEN ASSIGN ENTRY(1,token,".") =
                                   ENTRY(1,ENTRY(j,_Q._TblList," "),".") + "_" +
                                   ENTRY(1,token,".")
		               ENTRY(i,p_code," ") = token.
              END.
            END.  /* See if token starts with a table name */
          END.  /* For each token */
        END. /* IF shared but not suppressed */

        ELSE IF _suppress_dbname THEN DO:
	   /* sports.customer --> customer_ AND                               */
	   /* sports.customer.name --> customer_.name                         */
          DO i = 2 TO NUM-ENTRIES(p_code," ") - 1:  /* Not the EACH or
                                                                     NO-LOCK */
            token = ENTRY(i,p_code," ").
            IF CAN-DO(db-list,ENTRY(1,token,".")) THEN DO:
              /* Token starts with dbname */
              ASSIGN token = ENTRY(2,token,".") + "_" + 
                                  (IF NUM-ENTRIES(token,".") = 3
                                                 THEN "." + ENTRY(3,token,".")
                                                 ELSE "")
                     ENTRY(i,p_code," ") = token.
            END.  /* If token begins with a DB-NAME */
            ELSE DO:   /* See if token starts with a table name             */
              DO j = 1 TO NUM-ENTRIES(_Q._TblList," "):
                IF ENTRY(j,_Q._TblList," ") NE "OF" AND
                ENTRY(2,ENTRY(j,_Q._TblList," "),".") = ENTRY(1,token,".") THEN 
                ASSIGN ENTRY(1,token,".")  = ENTRY(1,token,".") + "_"
                       ENTRY(i,p_code," ") = token.
              END.
            END.  /* See if token starts with a table name */
          END.  /* For each token */
        END.  /* IF both suppress_db and SHARED */
      END. /* IF either suppressed_db OR SHARED */
    END.  /* If _Q._TblList is non empty */
  END. /* WHEN _OPEN-QUERY... */

 /**************************************************************************/
 /*                          standard PROCEDURE                            */  
 /**************************************************************************/
  WHEN "_PROCEDURE" THEN DO:
   /* SUBSTITUTE the result with &1=name */
    p_code =   
    "PROCEDURE &1 :"  + {&EOL} +
    "/*" + comment-ln + {&EOL} +
    "  Purpose:     " + {&EOL} + 
    "  Parameters:  <none>" + {&EOL} + 
    "  Notes:       " + {&EOL} + 
    comment-ln + "*/" + {&EOL} + 
      {&EOL} + 
    "END PROCEDURE.".
  END. /* WHEN _PROCEDURE... */

 /**************************************************************************/
 /*                   standard FUNCTION IMPLEMENTATION                     */
 /**************************************************************************/
  WHEN "_FUNCTION" THEN DO:
    /* SUBSTITUTE the result with &1=name, &2=Datatype, &3=Return-Value */
    p_code =
    "FUNCTION &1 RETURNS &2 () :"  + {&EOL} +
    "/*" + comment-ln + {&EOL} +
    "  Returns:     " + {&EOL} +
    "  Parameters:  <none>" + {&EOL} + 
    "  Notes:       " + {&EOL} + 
    comment-ln + "*/" + {&EOL} + 
    {&EOL} +
    "  /* Return a value for the function. */" + {&EOL} +
    "  RETURN &3." + {&EOL} + 
    "END FUNCTION.".
  END. /* WHEN _FUNCTION... */

 /**************************************************************************/
 /*                          WEB.INPUT PROCEDURE                           */  
 /**************************************************************************/
  WHEN "_WEB.INPUT" /* jep / wtw */ THEN DO:
    p_code =   
    "/*" + comment-ln + {&EOL} +
    "  Purpose:     Assigns form field data value to frame screen value." + {&EOL} + 
    "  Parameters:  p-field-value" + {&EOL} + 
    "  Notes:       " + {&EOL} + 
    comment-ln + "*/" + {&EOL} + 
    "  DEFINE INPUT PARAMETER p-field-value AS CHARACTER NO-UNDO." + {&EOL} +
    "  " + {&EOL} +
    "  DO WITH FRAME ~{&FRAME-NAME~}:" + {&EOL} +
    "  " + {&EOL} +
    "  END." + {&EOL} +
    "  " + {&EOL} +
    "END PROCEDURE.".
  END. /* WHEN _WEB.INPUT... */

 /**************************************************************************/
 /*                          WEB.OUTPUT PROCEDURE                            */  
 /**************************************************************************/
  WHEN "_WEB.OUTPUT" /* jep / wtw */ THEN DO:
    p_code =   
    "/*" + comment-ln + {&EOL} +
    "  Purpose:     Output the value of the field to the WEB stream" + {&EOL} + 
    "               in place of the HTML field definition." + {&EOL} + 
    "  Parameters:  p-field-defn" + {&EOL} + 
    "  Notes:       " + {&EOL} + 
    comment-ln + "*/" + {&EOL} + 
    "  DEFINE INPUT PARAMETER p-field-defn AS CHARACTER NO-UNDO." + {&EOL} +
    (IF _U._TYPE ne "radio-set":U THEN '' ELSE
      "  DEFINE INPUT PARAMETER p-radio-item AS INTEGER   NO-UNDO." + {&EOL}) +
    "  " + {&EOL} +
    "  DO WITH FRAME ~{&FRAME-NAME~}:" + {&EOL} +
    "  " + {&EOL} +
    "  END." + {&EOL} +
    "  " + {&EOL} +
    "END PROCEDURE.".
  END. /* WHEN _WEB.OUTPUT... */
  
  
 /**************************************************************************/
 /*                           _WEB-HTM-OFFSETS                             */  
 /**************************************************************************/  
  WHEN "_WEB-HTM-OFFSETS" THEN DO:
    /* The actual code is generated by another procedure */
    RUN workshop/_offproc.p (INTEGER(RECID(_P)), OUTPUT p_code).
  END. /* WHEN "_WEB-HTM-OFFSETS" ... */


 /**************************************************************************/
 /*                          standard LOCAL-METHOD                       */  
 /**************************************************************************/
  WHEN "_LOCAL-METHOD" THEN DO:
    /* SUBSTITUTE the result with &1=name */
    p_code =  
    "PROCEDURE &1 :"  + {&EOL} +
    "/*" + comment-ln + {&EOL} +
    "  Purpose:     Override standard ADM method" + {&EOL} + 
    "  Notes:       " + {&EOL} + 
    comment-ln + "*/" + {&EOL} 
    + {&EOL} +
    "  /* Code placed here will execute PRIOR to standard behavior. */" + {&EOL}
    + {&EOL} +    
    "  /* Dispatch standard ADM method.                             */" + {&EOL} +
    "  RUN dispatch IN THIS-PROCEDURE ( INPUT '_SMART-METHOD':U ) ." + {&EOL}
    + {&EOL} +
    "  /* Code placed here will execute AFTER standard behavior.    */" + {&EOL}
    + {&EOL} +
    "END PROCEDURE.".
  END. /* WHEN _LOCAL-METHOD... */

 /**************************************************************************/
 /*                            OTHERWISE CASE                              */  
 /**************************************************************************/

  OTHERWISE DO: /* Is the template a file that we can run? */   
    p_code = "".
    RUN adecomm/_rsearch.p (INPUT p_template, OUTPUT file_name).   
    IF file_name eq ? 
    THEN MESSAGE "_coddflt.p received unexpected p_template: " p_template 
                 VIEW-AS ALERT-BOX ERROR BUTTONS OK.
    ELSE DO ON ERROR UNDO, LEAVE:
      RUN VALUE(file_name) (INPUT INTEGER(RECID(_P)), OUTPUT p_code). 
    END.
  END.

END CASE.
