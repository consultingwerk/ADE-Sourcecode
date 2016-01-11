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

File: _dbconn.p

Description:
   Calls dbconnx.p to display and handle the connect dialog box, doing the 
   connection if the user presses OK.  This call takes only three parameters.

Input/Output Parameters:
   
   | On input:  a value is supplied if known, otherwise, the value is ?
   | On output: if connect succeeded, all values are set.  If connect failed
      	        or if the user cancelled, Pname and LName are set to ?.

   p_PName  - the physical name of the database
   p_LName  - the logical name of the database
   p_Type   - The database type (e.g., PROGRESS, ORACLE)
   
 
Author: Laura Stern

Date Created: 03/24/92

----------------------------------------------------------------------------*/


Define INPUT-OUTPUT parameter p_PName  as char NO-UNDO.
Define INPUT-OUTPUT parameter p_LName  as char NO-UNDO.
Define INPUT-OUTPUT parameter p_Type   as char NO-UNDO.

Define var dummy_1   	 as char    NO-UNDO.
Define var dummy_2   	 as char    NO-UNDO.
Define var dummy_3   	 as char    NO-UNDO.
Define var dummy_4   	 as char    NO-UNDO.
Define var dummy_5   	 as char    NO-UNDO.
Define var dummy_6   	 as char    NO-UNDO.
Define var dummy_7       as char    NO-UNDO.
Define var dummy_8       as char    NO-UNDO.
Define var dummy_9       as char    NO-UNDO.
Define var Db_Multi_User as logical NO-UNDO.


/*----------------------------Mainline code----------------------------------*/

DB_Multi_User = no.
 
RUN adecomm/_dbconnx.p ( YES,   /* whether to connect the database spec'd */
                        INPUT-OUTPUT p_PName,
                        INPUT-OUTPUT p_LName,
                        INPUT-OUTPUT p_Type,
                        INPUT-OUTPUT Db_Multi_User,
                        INPUT-OUTPUT dummy_1,
                        INPUT-OUTPUT dummy_2,
                        INPUT-OUTPUT dummy_3,
                        INPUT-OUTPUT dummy_4,
                        INPUT-OUTPUT dummy_5,
                        INPUT-OUTPUT dummy_6,
                        INPUT-OUTPUT dummy_7,
                        INPUT-OUTPUT dummy_8,
                        OUTPUT       dummy_9  ).

RETURN.



