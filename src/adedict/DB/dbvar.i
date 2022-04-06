/*********************************************************************
* Copyright (C) 2006,2013 by Progress Software Corporation. All      *
* rights reserved.  Prior versions of this work may contain portions *
* contributed by participants of Possenet.                           *
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
    tomn     01/10/96    Added codepage to DB Properties form (s_Db_Cp)
    fernando 06/06/06    Added large sequence and keys to DB Properties form
    
----------------------------------------------------------------------------*/

Define {1} frame dbprops.  /* database properties */

define {1} var s_Db_Pname  as char NO-UNDO.
define {1} var s_Db_Holder as char NO-UNDO.
define {1} var s_Db_Type   as char NO-UNDO.
define {1} var s_Db_Cp     as char NO-UNDO.
define {1} var s_Db_Description    as char NO-UNDO.
define {1} var s_Db_Add_Details    as char NO-UNDO.
define {1} var s_Db_Large_Sequence as char NO-UNDO.
define {1} var s_Db_Large_Keys     as char NO-UNDO.
define {1} var s_Db_Multi_Tenancy  as char NO-UNDO.
define {1} var s_Db_Partition_Enabled  as char NO-UNDO.
define {1} var s_Db_CDC_Enabled    as char NO-UNDO.

/* This is the form for the database properties window. */
{adedict/DB/dbprop.f} 



