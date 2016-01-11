/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*----------------------------------------------------------------------------

File: _ok_name.p

Description:
    Checks if a name of a wiget is OK.

Input Parameters:
   p_test  : The name to test.
   p_recid : The recid of the _U that we are going to use if the name
             is ok.  This lets us check for common siblings (in the
             same frame, for example) with the same name.

Output Parameters:
   p_ok        : YES if the name is valid.

Author: Wm.T.Wood

Date Created: October 1, 1992 

----------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER p_test   AS CHAR                NO-UNDO.
DEFINE INPUT  PARAMETER p_recid  AS RECID               NO-UNDO.

DEFINE OUTPUT PARAMETER p_ok     AS LOGICAL             NO-UNDO.

{adeuib/uniwidg.i}              /* Universal widget definition              */
DEFINE BUFFER another_U FOR _U.
DEFINE BUFFER another_F FOR _F.

/* Define a SKIP for alert-boxes that only exists under Motif */
&Global-define SKP &IF "{&WINDOW-SYSTEM}" = "OSF/Motif" &THEN SKIP &ELSE &ENDIF

/* Find this widget (and Procedure) whose name we are testing */
FIND _U WHERE RECID(_U) eq p_recid.
FIND _P WHERE _P._WINDOW-HANDLE eq _U._WINDOW-HANDLE.

/* Case 1: The test name is the same as the current name. 
   Assume it is OK. */
IF p_test eq _U._NAME THEN p_ok = YES.
ELSE DO:
  /* Is there another widget in this window of any type that has this name? */
  /* This still leaves the possibility of a person "undeleting" a widget    */
  /* with the same name, but we will catch that in _gen4gl.p.               */
  FIND FIRST another_U WHERE another_U._NAME eq p_test 
                         AND RECID(another_U) ne p_recid 
                         AND another_U._WINDOW-HANDLE eq _P._WINDOW-HANDLE 
                         AND another_U._STATUS ne "DELETED" 
                       USE-INDEX _NAME NO-ERROR.
  IF AVAILABLE another_U THEN DO:
    /* Assume everything will work */
    p_ok = TRUE.
    /* It is ok to have another widget with the same name as long as they are
       have the same datatype and are in different frames. */
    FIND _F WHERE RECID(_F) eq _U._x-recid NO-ERROR.
    /* Case 2: _U is not a variable. */
    IF NOT AVAILABLE _F OR _F._DATA-TYPE eq ? THEN p_ok = FALSE.
    ELSE DO:
      FIND another_F WHERE RECID(another_F) eq another_U._x-recid NO-ERROR.
      /* Case 3: _U is a variable, but another_U is not     */
      IF NOT AVAILABLE another_F OR another_F._DATA-TYPE eq ? THEN p_ok = FALSE.
      /* Case 4: _U and another_U are variables, but with different types  */
      ELSE IF _F._DATA-TYPE ne another_F._DATA-TYPE THEN p_ok = FALSE.
      ELSE DO:
        FIND FIRST another_U WHERE another_U._NAME eq p_test 
                               AND RECID(another_U) ne p_recid
                               AND another_U._parent-recid EQ _U._parent-recid 
                               AND another_U._STATUS ne "DELETED"  
                             USE-INDEX _NAME NO-ERROR.
        /* Case 5: there is another_U in the same frame as _U.  
                   This is always an error.  */
        IF AVAILABLE another_U THEN p_ok = FALSE.
      END.
    END.
    /* There was another widget. Report an error if it occured. */
    IF p_ok eq NO THEN
    DO:
      /* If this procedure has an associated data object and the other object
         found has a local name that matches the name being tested then 
         a CLOB local field error should be given below.  This is the case where
         the local field name is the same as the field name. */
      IF _P._data-object NE "":U AND another_U._LOCAL-NAME = p_test THEN
        p_ok = YES.  /* do nothing for now - will be caught below in local-name check */  
      ELSE 
        MESSAGE "Another object already uses this name." {&SKP}
                "Please enter another name."
                  VIEW-AS ALERT-BOX ERROR BUTTONS OK.
    END.
  END.  
  ELSE IF p_test ne "" AND CAN-DO (_P._reserved-names, p_test) THEN
    MESSAGE "This name is has been reserved in this procedure." {&SKP}
            "Please enter another name."
            VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  /* There was no other widget.  We still need to validate that the name is
     a valid PROGRESS identifier. */
  ELSE RUN adecomm/_valname.p (p_test, FALSE, OUTPUT p_ok).
  
  /* If it is OK, still give a warning if the name starts with "adm-" */
  IF p_ok AND p_test BEGINS "adm-" THEN
    MESSAGE "This name begins with 'adm-'. This prefix is normally used" {&SKP}
            "by the PROGRESS Application Development Model." {&SKP}
            "You may wish to enter another name."
            VIEW-AS ALERT-BOX ERROR BUTTONS OK.

  /* If this procedure has an associated data object then try to find another 
     object where the local name matches the name being tested.  This catches
     the case where the local name is not the same as the field name in addition 
     to the case where they are the same (would have been found above). */
  IF p_ok AND _P._data-object NE "":U THEN
  DO:
    FIND FIRST another_U WHERE another_U._LOCAL-NAME eq p_test 
                           AND RECID(another_U) ne p_recid 
                           AND another_U._WINDOW-HANDLE eq _P._WINDOW-HANDLE 
                           AND another_U._STATUS ne "DELETED" NO-ERROR.
    IF AVAILABLE another_U THEN DO:
      p_ok = FALSE.
      MESSAGE "CLOB " another_U._NAME " already uses this name as its internal local field name. " {&SKP}
              "Please enter anther name."
                VIEW-AS ALERT-BOX ERROR BUTTONS OK.
    END.
  END.  /* if has data source */
END. /* New name. */


