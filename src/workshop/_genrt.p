/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*----------------------------------------------------------------------------

File: _genrt.p

Description:
    This generates the RUN-TIME ATTRIBUTES section of a .w file.  

Input Parameters:
   p_proc-id    Current procedure id.
   p_status     "SAVE"    .
                "PREVIEW" . [same as a save.]
                "RUN"     .   
                "CHECK-SYNTAX" 

Author: Wm.T.Wood [from the original adeshar/_genrt.i by D. Ross Hunter]

Date Created: February 25, 1997

---------------------------------------------------------------------------- */

DEFINE INPUT  PARAMETER p_proc-id  AS INTEGER NO-UNDO.
DEFINE INPUT  PARAMETER p_status   AS CHAR NO-UNDO.    

/* Include files */
{ workshop/uniwidg.i }     /* Universal Widget TEMP-TABLE definition         */
{ workshop/sharvars.i }    /* Shared variables                               */

{ workshop/genshar.i}      /* Shared variables for _gendefs.p                */

/* Local Variables */
DEFINE VARIABLE in_frame_clause  AS CHAR       NO-UNDO.
DEFINE VARIABLE tmp_name         AS CHAR       NO-UNDO.
DEFINE VARIABLE tmp_string       AS CHAR       NO-UNDO.
DEFINE VARIABLE widget_sect      AS LOGICAL    NO-UNDO.

/* Buffers. */
DEFINE BUFFER frm_U FOR _U.
DEFINE BUFFER   x_U FOR _U.
    
/* This line checks the compile time preprocessor variables to ensure
   that all the user defined lists are writen out. If the preprocessor value is
   "wrong", this line will catch it and someone who compiles this file will 
   see the bug.*/
&IF {&MaxUserLists} ne 6 &THEN
&MESSAGE [_genrt.p] *** FIX NOW *** User-List not being generated correctly (wood)
&ENDIF


/* Include 4GL utility functions to 4gl-encode a string. Use this 
   around any string we are planning on saving. */
{ workshop/util4gl.i }


/* First check to see if this section is necessary                           */

Frame-Search:
FOR EACH frm_U WHERE frm_U._P-recid eq p_proc-id
                 AND frm_U._TYPE eq "FRAME":U
                 AND frm_U._STATUS BEGINS u_status USE-INDEX _OUTPUT:
  WIDGET-SEARCH:
  FOR EACH x_U WHERE x_U._P-recid      eq p_Proc-id
                 AND x_U._parent-recid eq RECID(frm_U)
                 AND x_U._STATUS       eq u_status,
      EACH _F WHERE RECID(_F) eq x_U._x-recid:
   
    /* Is this widget special or unusual */
    IF x_U._defined-by eq "User":U   OR   x_U._PRIVATE-DATA NE "":U OR 
       x_U._User-List[1]   OR x_U._User-List[2]  OR x_U._User-List[3]       OR
       x_U._User-List[4]   OR x_U._User-List[5]  OR x_U._User-List[6]       OR
       (NOT x_U._DISPLAY)  OR (NOT x_U._ENABLE)  OR
       (x_U._TYPE eq "EDITOR":U AND _F._READ-ONLY) 
    THEN DO:
      widget_sect = TRUE.
      LEAVE Frame-Search.
    END.
  END.  /* WIDGET-SEARCH */
END.  /* Frame-Search: FOR EACH... */

/* We need a runtime settings section if we need to  set anything on any widget.  */

IF widget_sect THEN DO:    
  PUT STREAM P_4GL UNFORMATTED SKIP (2)
    "/* *****************  Runtime Attributes and Settings  **************** */"
    SKIP (1)
    "&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES" SKIP.

  FOR EACH frm_U WHERE frm_U._P-recid eq p_proc-id
                   AND frm_U._TYPE eq "FRAME":U
                   AND frm_U._STATUS BEGINS u_status USE-INDEX _OUTPUT:
    /* All the widgets will have a widget:attribute "IN FRAME name" clause. */
    /* Compute this once. */
    in_frame_clause = " IN FRAME ":U + frm_U._NAME.          
                   
    FOR EACH x_U WHERE x_U._P-recid      eq p_Proc-id
                   AND x_U._parent-recid eq RECID(frm_U)
                   AND x_U._STATUS       eq u_status 
          BY x_U._NAME BY x_U._TYPE:
      /* Get the _F record for tis widget. */
      FIND _F WHERE RECID( _F)   = x_U._x-recid.
          
      /* Is this widget special or unusual */
      IF x_U._defined-by eq "User":U   OR   x_U._PRIVATE-DATA NE "":U OR 
         x_U._User-List[1]   OR x_U._User-List[2]  OR x_U._User-List[3]       OR
         x_U._User-List[4]   OR x_U._User-List[5]  OR x_U._User-List[6]       OR
         (NOT x_U._DISPLAY)  OR (NOT x_U._ENABLE)  OR
         (x_U._TYPE eq "EDITOR":U AND _F._READ-ONLY)
      THEN DO:   
        tmp_name = { workshop/name_u.i &U_BUFFER = "x_U" } .
        
        tmp_string = "   "   
                         + (IF x_U._defined-by eq "User":U THEN "User " ELSE "")
                         + (IF x_U._DISPLAY eq NO THEN "NO-DISPLAY " ELSE "")
                         + (IF NOT x_U._ENABLE THEN  "NO-ENABLE " ELSE "")
                         + (IF x_U._User-List[1] THEN "1 " ELSE "")
                         + (IF x_U._User-List[2] THEN "2 " ELSE "")
                         + (IF x_U._User-List[3] THEN "3 " ELSE "") 
                         + (IF x_U._User-List[4] THEN "4 " ELSE "")
                         + (IF x_U._User-List[5] THEN "5 " ELSE "")
                         + (IF x_U._User-List[6] THEN "6 " ELSE "").
        IF LENGTH(tmp_string,"CHARACTER":U) < 72
        THEN tmp_string = tmp_string + FILL(" ", 72 - LENGTH(tmp_string,"CHARACTER":U)). 
        PUT STREAM P_4GL UNFORMATTED
               "/* SETTINGS FOR " x_U._TYPE " " tmp_name in_frame_clause 
               SKIP tmp_string "*/" SKIP.

        IF x_U._PRIVATE-DATA NE ""  OR
          (x_U._TYPE eq "EDITOR":U AND _F._READ-ONLY)
        THEN DO:
          IF _F._READ-ONLY THEN PUT STREAM P_4GL UNFORMATTED SKIP
              "       " tmp_name ":READ-ONLY" in_frame_clause 
                                                          "        = TRUE".
          IF x_U._PRIVATE-DATA NE "" THEN DO:
            tmp_string = "~"" + 4GL-encode(x_U._PRIVATE-DATA) + "~"".
            PUT STREAM P_4GL UNFORMATTED SKIP
                "       " tmp_name ":PRIVATE-DATA" in_frame_clause  "     = " SKIP
                "                " tmp_string.
          END.        
          PUT STREAM P_4GL UNFORMATTED "." SKIP (1).
        END. /* Run-Time Settings. */
      END. /* Some settings for this widget... */    
    END. /* FOR EACH. [widget in frame]... : End of widget loop */
  END. /* FOR EACH...FRAME... : End of frame loop */  
  
  /* Put the section footer. */
  PUT STREAM P_4GL UNFORMATTED SKIP (1) "&ANALYZE-RESUME" SKIP (2).

END. /* If there is a widget section */

RETURN.

/*
 * ------ End of file -------
 */
 
