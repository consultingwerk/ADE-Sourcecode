/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*----------------------------------------------------------------------------

File: _sqlwptr.p

Description: 
   In order to run the Adjust SQL Width browser from the Refresh_Props internal
   procedure in _objsel.p, this had to be created.  It automatically assumes 
   adedict directory, but since the browser code is shared between the gui and 
   tty dictionaries, it is located in prodict/gui.  So, this points to it.
   
Author: Mario Brunetti

Date Created: 05/11/99

-------------------------------------------------------------------------------*/

RUN prodict/gui/_guisqlw.p. 
