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
