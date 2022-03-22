/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/* _snd_sql.p - SEND.SQL toMSS to create MSS objects. */

/*++


Component:  Protoxxx   (progress to foreign datamanager)

Purpose:    Read in SQL from a file created by _wrktgen.p
            and use SEND-SQL-STATEMENT stored procedure
            to perform each command inside foreign data manager. 

            NOTE: The output of this file can be adjusted 
                 by using the local environment variables 
                 and the dataserver dependent section at 
                 begining of the code.  

History:    
   D. McMann 03/31/00 Created from odb/_snd_sql.p

--*/


{ prodict/gate/_snd_sql.i }
