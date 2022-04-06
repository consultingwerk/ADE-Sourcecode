/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
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
