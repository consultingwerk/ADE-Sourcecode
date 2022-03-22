/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*----------------------------------------------------------------------------

File: uibpref.i

Description:
    Temp-Table definitions for UIB preference settings.

Input Parameters:
   <None>

Output Parameters:
   <None>

Author: Gerry Seidl

Date Created: 1995

----------------------------------------------------------------------------*/

DEFINE {1} SHARED TEMP-TABLE _uib_prefs                             NO-UNDO
    FIELD _user_dfltwindow      AS LOGICAL      INITIAL TRUE
                                VIEW-AS TOGGLE-BOX
                                LABEL "Create a Default &Window at Startup"
    FIELD _user_advisor         AS LOGICAL      INITIAL TRUE
                                VIEW-AS TOGGLE-BOX
                                LABEL "Display &Advisor Messages"
    FIELD _user_hints           AS LOGICAL      INITIAL TRUE
                                VIEW-AS TOGGLE-BOX
                                LABEL "Display &Cue Cards"
    .  /* _uib-prefs    is the record that says what the user prefs are  */
