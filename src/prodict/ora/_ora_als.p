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

/*--------------------------------------------------------------------

File: prodict/ora/_ora_als.p

Description:
    + disconnects from DICTDBG if already connectd
    + assignes the link-name to _db-misc2[8]
    + connects to the link-db 
    + sets the alias
    
Input-Parameters:  
    p_ldbname      logical name of the link-db (= physical name)
    p_link-name    link-name for _db-misc2[8]
    
Output-Parameters: 
    none
    
Used/Modified Shared Objects:
    none

    
History:
    hutegger    94/09/11    creation
    
--------------------------------------------------------------------*/
/*h-*/

/*----------------------------  DEFINES  ---------------------------*/

define input parameter p_ldbname   as character.

{ prodict/dictvar.i }

/*---------------------------  TRIGGERS  ---------------------------*/

/*------------------------  INT.-PROCEDURES  -----------------------*/

/*---------------------------  MAIN-CODE  --------------------------*/

if connected(p_ldbname)
 then create alias DICTDBG for database value(p_ldbname).

 
/*------------------------------------------------------------------*/
