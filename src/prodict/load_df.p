/*********************************************************************
* Copyright (C) 2007-2010,2021 by Progress Software Corporation. All rights *
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
    added new parameters for online schema change 
----------------------------------------------------------------------------*/
 
/*==========================  DEFINITIONS ===========================*/

DEFINE INPUT PARAMETER df-file-name AS CHARACTER NO-UNDO.
define variable dictOptions as OpenEdge.DataAdmin.Binding.IDataDefinitionOptions no-undo.
 
/* If user wants to commit even if there are errors in the df, they can
   pass in a string composed of "df-file-name,yes"  If user_env[15] is
   set to yes, the _lodsddl.p will handle for committing with errors.
   
   If user wants to load new tables and sequences on-line than df-file-name
   must have three entries, "df-file-name,<commit>,<session parameter>".
   If user wants to load new database objects according to online schema change sections
   than df-file-name must have four or more entries, "df-file-name,<commit>,<session parameter><online schema parameters>".  
   example:  Commit with errors and loading on-line = "sports,df,yes,NEW OBJECTS" 
             Do not commit with errors and loading on line = "sports.df,,NEW OBJECTS"
             Just passing in file name "sports.df".
             Commit with errors and loading on-line = "sports,df,yes,NEW OBJECTS,yes,yes,yes,yes" 
             Do not commit with errors and loading on line = "sports.df,,NEW OBJECTS,yes,yes,yes,yes"
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
IF NUM-ENTRIES(df-file-name) > 3 THEN DO:
    ASSIGN dictOptions:FileName = ENTRY(1,df-file-name)
           dictOptions:ForceCommit = ENTRY(2,df-file-name) =  "yes"
           dictOptions:SchemaChange = ENTRY(3,df-file-name).
    CASE NUM-ENTRIES(df-file-name):
        WHEN 4 THEN
          ASSIGN dictOptions:PreDeployLoad   = IF ENTRY(4,df-file-name) = "" THEN "no" ELSE ENTRY(4,df-file-name).
        WHEN 5 THEN
          ASSIGN dictOptions:PreDeployLoad   = IF ENTRY(4,df-file-name) = "" THEN "no" ELSE ENTRY(4,df-file-name)
                 dictOptions:TriggerLoad     = IF ENTRY(5,df-file-name) = "" THEN "no" ELSE ENTRY(5,df-file-name).
        WHEN 6 THEN
          ASSIGN dictOptions:PreDeployLoad   = IF ENTRY(4,df-file-name) = "" THEN "no" ELSE ENTRY(4,df-file-name)
                 dictOptions:TriggerLoad     = IF ENTRY(5,df-file-name) = "" THEN "no" ELSE ENTRY(5,df-file-name)
                 dictOptions:PostDeployLoad  = IF ENTRY(6,df-file-name) = "" THEN "no" ELSE ENTRY(6,df-file-name).
        WHEN 7 THEN
          ASSIGN dictOptions:PreDeployLoad   = IF ENTRY(4,df-file-name) = "" THEN "no" ELSE ENTRY(4,df-file-name)
                 dictOptions:TriggerLoad     = IF ENTRY(5,df-file-name) = "" THEN "no" ELSE ENTRY(5,df-file-name)
                 dictOptions:PostDeployLoad  = IF ENTRY(6,df-file-name) = "" THEN "no" ELSE ENTRY(6,df-file-name) 
                 dictOptions:OfflineLoad     = IF ENTRY(7,df-file-name) = "" THEN "no" ELSE ENTRY(7,df-file-name).
    END CASE.
END.
ELSE
   ASSIGN dictOptions:FileName = df-file-name.

run prodict/dump/_load_df.p(dictOptions). 
finally:
    delete object dictOptions.
end. 
