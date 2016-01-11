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

File: qurywidg.i

Description:

Input Parameters:
   <None>

Output Parameters:
   <None>

Author: Greg O'Connor

Date Created: 1992 

----------------------------------------------------------------------------*/

/* Max tables in query definition */

&Glob MaxTbl 20 
/* &Global-Define MaxTbl       20 */
/* Make sure the seperator char is not a '!' which will conflict for lable stuff*/
&Global-Define Sep1          CHR (3)
&Global-Define Sep2          CHR (4)


/* Browser Props */

DEFINE {1} SHARED VARIABLE _4GLQury      AS CHAR                       NO-UNDO.
           /* 4GL code defining query              */
           
DEFINE {1} SHARED VARIABLE _UIB_4GLQury  AS CHAR                       NO-UNDO.
           /* 4GL code defining query              */
DEFINE {1} SHARED VARIABLE _TblList      AS CHAR                       NO-UNDO.
           /* List of tables in query              */
           
DEFINE {1} SHARED VARIABLE _FldList      AS CHAR                       NO-UNDO.
           /* List of fields selected for browse   */
           
DEFINE {1} SHARED VARIABLE _OrdList      AS CHAR                       NO-UNDO.
          /* List of fields in BREAK BY phrase     */
          
DEFINE {1} SHARED VARIABLE _JoinTo       AS INTEGER  EXTENT {&MaxTbl}  NO-UNDO.
          /* Parent Table                          */
         
DEFINE {1} SHARED VARIABLE _JoinCode     AS CHAR     EXTENT {&MaxTbl}  NO-UNDO.
         /* 4GL Join Code                          */
         
DEFINE {1} SHARED VARIABLE _Where        AS CHAR     EXTENT {&MaxTbl}  NO-UNDO.
         /* 4GL Where Code                         */
