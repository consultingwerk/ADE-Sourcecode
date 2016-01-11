/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
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

{adecomm/oeideservice.i}

/* Define a SKIP for alert-boxes that only exists under Motif */
&Global-define SKP ""

/*----------------------------Mainline code----------------------------------*/

/* Should we ask if user wants to connect ? */
IF pi_msg eq ? THEN po_OK = YES.
ELSE
do: 
    if OEIDEIsRunning then
       po_OK = ShowMessageInIDE(pi_msg + " ~n Do you want to connect to a database?",
                         "Question","?","OK-CANCEL",YES).
    else                     
       MESSAGE pi_msg {&SKP} "Do you want to connect to a database?"
             VIEW-AS ALERT-BOX QUESTION BUTTONS OK-CANCEL UPDATE po_OK.
end.
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
