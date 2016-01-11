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

File: dbcnnct.p

Description:
   Calls _dbconnx.p to display and handle the connect dialog box, doing the
   connection if the user presses OK.  This call takes only three parameters.

Input Parameters:
   pi_msg    - A message to display in an ALERT-BOX which asks the user
               if they wish to connect.  If this is ? then we always
               try to connect.  If an alert-box is requested, the message
               is pi_msg {&SKP} "Do you want to connect to a database?"
Input Parameters:
   po_OK     - TRUE if the user asked to connect and if a connection
               was made.

Author: William T. Wood

Date Created: 06/3/93

----------------------------------------------------------------------------*/

Define INPUT  parameter pi_msg as char    NO-UNDO.
Define OUTPUT parameter po_OK  as logical NO-UNDO.

/* Database Parameters */
Define var PName         as char    NO-UNDO. /* Physical DB Name */
Define var LName         as char    NO-UNDO. /* Logical DB Name  */
Define var DB_Type       as char    NO-UNDO. /* DB Name Type - eg. "PROGRESS" */
Define var Db_Multi_User as logical NO-UNDO.

/* Dummy Parameters */
Define var dummy_1       as char    NO-UNDO.
Define var dummy_2       as char    NO-UNDO.
Define var dummy_3       as char    NO-UNDO.
Define var dummy_4       as char    NO-UNDO.
Define var dummy_5       as char    NO-UNDO.
Define var dummy_6       as char    NO-UNDO.
Define var dummy_7       as char    NO-UNDO.
Define var dummy_8       as char    NO-UNDO.
Define var dummy_9       as char    NO-UNDO.

/* Define a SKIP for alert-boxes that only exists under Motif */
&Global-define SKP ""

/*----------------------------Mainline code----------------------------------*/

/* Should we ask if user wants to connect ? */
IF pi_msg eq ? THEN po_OK = YES.
ELSE MESSAGE pi_msg {&SKP} "Do you want to connect to a database?"
             VIEW-AS ALERT-BOX QUESTION BUTTONS OK-CANCEL UPDATE po_OK.

IF po_OK THEN DO:
  /* Set defaults for the db connect dialog. */
  ASSIGN DB_Multi_User = no
         DB_Type       = "PROGRESS":U.

  RUN adecomm/_dbconnx.p ( YES,   /* whether to connect the database spec'd */
                        INPUT-OUTPUT PName,
                        INPUT-OUTPUT LName,
                        INPUT-OUTPUT DB_Type,
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
   
   /* Was a database connected */
   IF PName eq ? THEN po_OK = no.
END.
