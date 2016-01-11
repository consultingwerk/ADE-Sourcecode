/*********************************************************************
* Copyright (C) 2011 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*----------------------------------------------------------------------------

File: viewmnt.i

Description:   
   This file contains variables for View Maintain Foreign Constraints.

HISTORY
Author: Kumar Mayur

Date Created:08/05/2011
----------------------------------------------------------------------------*/

{prodict/admnhlp.i }

Define {1} shared variable c_table_name   as character NO-UNDO.
Define {1} shared variable constr_name  as character NO-UNDO.
Define {1} shared variable DbRecId      as recid    NO-UNDO.       
Define {1} shared variable cDbType          as char NO-UNDO.