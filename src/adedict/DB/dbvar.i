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

File: dbvar.i

Description:   
   Include file which defines the user interface components for database
   properties.
 
Arguments:
   {1} - this is either "new shared" or "shared".

Author: Laura Stern

Date Created: 03/03/92

History:
    tomn    01/10/96    Added codepage to DB Properties form (s_Db_Cp)
    
----------------------------------------------------------------------------*/

Define {1} frame dbprops.  /* database properties */

Define {1} var s_Db_Pname  as char NO-UNDO.
Define {1} var s_Db_Holder as char NO-UNDO.
Define {1} var s_Db_Type   as char NO-UNDO.
Define {1} var s_Db_Cp     as char NO-UNDO.


/* This is the form for the database properties window. */
{adedict/DB/dbprop.f} 



