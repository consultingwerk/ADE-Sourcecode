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
