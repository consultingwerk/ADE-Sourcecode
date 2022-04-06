/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*----------------------------------------------------------------------------

File: _closqlw.p

Description:
   Clean up after the closing of the _guisqlw.p program.  This is necessary
   so that the temp-table is deleted and certain tracking variables used in
   the program (GUI version only) are re-set.  
   
Author: Mario Brunetti

Date Created: 05/28/99 
-----------------------------------------------------------------------------*/

/* We're just sharing what we need, because sharing the frames and all was  *
 * causing a problem of certain variables not being available, etc.   */
 
DEF SHARED TEMP-TABLE t_Field LIKE _Field. 

DEF SHARED BUFFER w_Field FOR t_Field.

DEF SHARED VAR qry-width-hdl    AS WIDGET-HANDLE NO-UNDO.
DEF SHARED VAR s_PreviousTbl    AS CHAR          NO-UNDO.

DO ON ERROR UNDO, LEAVE
   ON STOP UNDO, LEAVE:

      qry-width-hdl:QUERY-CLOSE.

      DELETE WIDGET qry-width-hdl.

      FOR EACH w_Field:
         DELETE w_Field.
      END.

      s_PreviousTbl = ?.
END.      
