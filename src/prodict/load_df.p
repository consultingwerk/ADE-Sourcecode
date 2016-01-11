/*********************************************************************
* Copyright (C) 2007-2010 by Progress Software Corporation. All rights *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*----------------------------------------------------------------------------

File: prodict/load_df.p

    End-user entry point for Admin Tool's "Load .df file" utility
      
Input Parameters:
    df-file-name    The name of the .df file to be loaded into DICTDB
    
Output Parameters:
    none
    
Used/Modified Shared Objects:
 
    
History:
    moved to prodict/dump/_load_df.p See 
----------------------------------------------------------------------------*/
 
/*==========================  DEFINITIONS ===========================*/

DEFINE INPUT PARAMETER df-file-name AS CHARACTER NO-UNDO.
define variable dictOptions as OpenEdge.DataAdmin.Binding.IDataDefinitionOptions no-undo.
 
/* If user wants to commit even if there are errors in the df, they can
   pass in a string composed of "df-file-name,yes"  If user_env[15] is
   set to yes, the _lodsddl.p will handle for committing with errors.
   
   If user wants to load new tables and sequences on-line than df-file-name
   must have three entries, "df-file-name,<commit>,<session parameter>".  
   example:  Commit with errors and loading on-line = "sports,df,yes,NEW OBJECTS" 
             Do not commit with errors and loading on line = "sports.df,,NEW OBJECTS"
             Just passing in file name "sports.df".
*/   

 
dictOptions = new prodict.dump._load_options().

IF NUM-ENTRIES(df-file-name) = 3 THEN
    ASSIGN dictOptions:FileName = ENTRY(1,df-file-name)
           dictOptions:ForceCommit = ENTRY(2,df-file-name) =  "yes"
           dictOptions:SchemaChange = ENTRY(3,df-file-name).
ELSE 
IF NUM-ENTRIES(df-file-name) = 2 THEN
    ASSIGN dictOptions:FileName = ENTRY(1,df-file-name)
           dictOptions:ForceCommit = ENTRY(2,df-file-name) =  "yes".
ELSE
   ASSIGN dictOptions:FileName = df-file-name.

run prodict/dump/_load_df.p(dictOptions). 
finally:
    delete object dictOptions.
end. 