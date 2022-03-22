/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/* _snd_sql.p - SEND.SQL to Sybase to create Sybase objects. */

/*++
 
Author:     Rob Adams

Component:  Protoxxx   (progress to foreign datamanager)

Purpose:    Read in SQL from a file created by _wrktgen.p
            and use SEND-SQL-STATEMENT stored procedure
            to perform each command inside foreign data manager. 

            NOTE: The output of this file can be adjusted 
                 by using the local environment variables 
                 and the dataserver dependent section at 
                 begining of the code.  

History:    
    21 Sep 1995 Hutegger replaced &DEBUG preprocessor variable with
                        parameter p_debug
     6 Jan 1995 DHM     This becomes a wrapper to include gate/_snd_sql.i
                        to allow for datatype specific r-code
     6 Sep 1994  RLA    Add Oracle drop logic. 
                        Add batch mode output functions
                        Add switching from chained to unchained mode.
                        Add object failure notification. 
     6 Jul 1994  RLA    add some output to let user know we're working
     7 Jun 1994  davidn Added informix specific dependencies.

                         Added comit1_per_stmt  to the local
                        environment.  With the idea that some
                        dataserver do not like to have a comit
                        after every statement.(like informix) 
                        
                        NOTE: The clear_buffers flage is part 
                        of a work around for a bug in running 
                        stored procs.  If there is no output to 
                        retrieve from the dataserver after the 
                        sql statement has been sent, some data
                        servers send back an error message that 
                        progress does not yet no how to handle.
                        Udi is currently working on this, and it
                        should be fixed soon. When the fix goes in,
                        we should be able to get rid of the clear_
                        buffers flag
                        -----davidn 7 Jun 1994 
     2 Jun 1994  RLA    Make generic for all datamanagers. 
    19 May 1994  RLA    Creation.

--*/


{ prodict/gate/_snd_sql.i }
