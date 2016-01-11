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
/*-----------------------------------------------------------------------------
File: _namespc.p
     Allow XFTR to register names of variables or procedures that cannot be used 
     by UIB users.  For example, if an XFTR creates a procedure, then we would not
     want the developer to create their own internal procedure with the same name.  
     Similarly, if the XFTR defines some variables, UIB users should be restricted
     from using those variables.

  Input Parameters:
      pi_context - The context ID (usually the same as the RECID)
                   of the procedure object to access.  If this is
                   the context for a widget in the procedure, then 
                   the procedure is found anyway.
                   If this is unknown then get the current procedure.
                   [If a Procedure Object cannot be found then we
                   return "ERROR".]
      pc_mode - RESERVE|UNRESERVE [VARIABLE|PROCEDURE [NAME|NAMES]]
      pc_list - comma-delimeted list of names to add or remove

  Output Parameters:
    <none>

  Comments: Warnings are given if you try to reserve a name that is already
            in use (but the reservation is made, so that if you delete the
            widget that uses the name, you will not be able to use it again).
            
            You can UNRESERVE any name, even one that it not RESERVED, and 
            there will be no warning.

  Author: Wm. T. Wood

  Created: Feb. 1995
-----------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER  pi_context AS INTEGER  NO-UNDO.
DEFINE INPUT PARAMETER  pc_mode    AS CHAR     NO-UNDO.
DEFINE INPUT PARAMETER  pc_list    AS CHAR     NO-UNDO.

/* Include Files. */
{adeuib/uniwidg.i}   /* Definition of Universal Widget  */
{adeuib/triggers.i}  /* Definition of Universal Widget  */
{adeuib/sharvars.i}  /* Shared UIB variables            */

DEFINE VARIABLE action AS CHAR NO-UNDO.
DEFINE VARIABLE act_on AS CHAR NO-UNDO.

DEFINE VARIABLE new-list AS CHAR NO-UNDO.
DEFINE VARIABLE old-list AS CHAR NO-UNDO.
DEFINE VARIABLE test     AS CHAR NO-UNDO.

DEFINE VARIABLE cnt AS INTEGER NO-UNDO.
DEFINE VARIABLE i   AS INTEGER NO-UNDO.

/* Get the current procedure. */
IF pi_context eq ? 
THEN FIND _P WHERE _P._WINDOW-HANDLE eq _h_win NO-ERROR.
ELSE DO:
  FIND _P WHERE RECID(_P) eq pi_context NO-ERROR.
  IF NOT AVAILABLE _P THEN DO:    
    /* Is this the context ID of a widget.  If so, find the procedure
       associated with the widget */
    FIND _U WHERE RECID(_U) eq pi_context NO-ERROR.
    IF AVAILABLE _U 
    THEN FIND _P WHERE _P._WINDOW-HANDLE eq _U._WINDOW-HANDLE.
  END.
END.

IF NOT AVAILABLE _P THEN DO:
  MESSAGE "The UIB cannot find the current procedure." 
          VIEW-AS ALERT-BOX ERROR.
  RETURN "Error".
END.
ELSE DO:
  /* Parse the mode */
  cnt = NUM-ENTRIES(pc_mode, " ").  
  IF cnt > 0 THEN action = ENTRY(1, pc_mode, " ").
  IF cnt = 1 THEN act_on = "VARIABLE".
  ELSE IF cnt > 1 THEN act_on = ENTRY(2, pc_mode, " ").
  
  /* Is the parameter valid */
  IF NOT CAN-DO("RESERVE,UNRESERVE", action) OR
     NOT CAN-DO("VARIABLE,PROCEDURE", act_on) THEN DO:
    MESSAGE "[{&FILE-NAME}]" SKIP
            "Invalid mode:"  pc_mode SKIP
            "Valid mode syntax is" SKIP
            "  RESERVE|UNRESERVE [VARIABLE|PROCEDURE [NAME|NAMES]]"
            VIEW-AS ALERT-BOX ERROR.
    RETURN "Error".
  END.
  /* Don't worry about this if the list to process is empty .*/
  ELSE IF pc_list NE "" THEN DO:
    /* Do the action? */
    IF action eq "RESERVE" THEN DO:
    
      IF act_on eq "VARIABLE" THEN DO:
        ASSIGN cnt = NUM-ENTRIES(pc_list).  
        DO i = 1 TO cnt:
          test = ENTRY (i, pc_list).
          /* Is this name in reserved, yet? */
          IF NOT CAN-DO(_P._reserved-names, test) THEN DO:
            /* Give warning if the name is taken. */
            IF CAN-FIND (_U WHERE _U._WINDOW-HANDLE eq _P._WINDOW-HANDLE
                              AND _U._NAME eq test
                              AND _U._DBNAME eq ?    /* don't worry about DB field */
                              AND _U._STATUS ne "DELETED")
            THEN MESSAGE "The variable name '" + test + "' is in use."
                         VIEW-AS ALERT-BOX WARNING BUTTONS OK.
            /* Reserve the new name. */
            IF _P._reserved-names = "" THEN _P._reserved-names = test.
            ELSE _P._reserved-names = _P._reserved-names + "," + test.
          END. /* IN NOT...reserved... */
        END. /* DO i = 1... */
      END. /* Reserve Variable Name */
      
      ELSE DO:
        ASSIGN cnt = NUM-ENTRIES(pc_list).  
        DO i = 1 TO cnt:
          test = ENTRY (i, pc_list).
          /* Is this name in reserved, yet? */
          IF NOT CAN-DO( _P._reserved-procs, test) THEN DO:
            /* Give warning if the name is taken. */
            IF CAN-FIND (_TRG WHERE _TRG._wRECID eq _P._u-recid
                                AND _TRG._tEVENT eq test
                                AND _TRG._tSECTION eq "_PROCEDURE")
            THEN MESSAGE "The procedure name '" + test + "' is in use."
                         VIEW-AS ALERT-BOX WARNING BUTTONS OK.
            /* Reserve the new name. */
            IF _P._reserved-procs = "" THEN _P._reserved-procs = test.
            ELSE _P._reserved-procs = _P._reserved-procs + "," + test.
          END. /* IN NOT...reserved... */
        END. /* DO i = 1... */
       END. /* Reserve Procedure Name */
      
    END.  /* Reserve a name */
    
    ELSE DO:
      /* Release Reservations on Names.  Is anything reserved that we want to
         free.*/    
      IF act_on eq "VARIABLE" 
      THEN old-list = _P._reserved-names.
      ELSE old-list = _P._reserved-procs.
      
      ASSIGN cnt = NUM-ENTRIES(old-list).  
      DO i = 1 TO cnt:
        test = ENTRY(i,old-list).
        /* We don't copy test to the new-list if it is unreserved */
        IF NOT CAN-DO(pc_list, test) THEN DO:
          IF new-list = "" THEN new-list = test.
          ELSE new-list = new-list + "," + test.
        END.
      END.
      /* Save the changed list */
      IF act_on eq "VARIABLE" 
      THEN _P._reserved-names = new-list.
      ELSE _P._reserved-procs = new-list.
 
    END. /* UnReserve a name */
  END.
END.
