/***************************************************************************
* Copyright (C) 2023 by Progress Software Corporation.                     *
* All rights reserved. Prior versions of this work may contain portions    *
* contributed by participants of Possenet.                                 *
*                                                                          *
****************************************************************************/
/*------------------------------------------------------------------------
    File            : batch_dump_df.p
    Purpose         : 

    Syntax          :

    Description     : Batch program to dump DDM schema and/or DDM settings.

    Author(s)       : Kunal Berlia
    Created         : Thu Jun 06 02:04:59 EDT 2023
    Notes           :    
    Usage           : start the session with -param with the respective values:
                     -param file-name="ALL" or "<file-name>";df-file-name=<Name of file to dump to>;codepage=<?, "", "<code-page>">
        
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

USING Progress.Database.*.

BLOCK-LEVEL ON ERROR UNDO, THROW.

DEFINE VARIABLE DDMVal        AS CHARACTER NO-UNDO.
DEFINE VARIABLE intParamCnt   AS INTEGER   NO-UNDO.
DEFINE VARIABLE strParam      AS CHARACTER NO-UNDO.
DEFINE VARIABLE strFileName   AS CHARACTER NO-UNDO.
DEFINE VARIABLE strDfFileName AS CHARACTER NO-UNDO.
DEFINE VARIABLE strCodePage   AS CHARACTER NO-UNDO.
DEFINE VARIABLE strDumpDDM    AS CHARACTER NO-UNDO.
DEFINE VARIABLE rConfig       AS DBConfig.

/* ********************  Preprocessor Definitions  ******************** */

/* ***************************  Main Block  *************************** */
{prodict/misc/misc-funcs.i}

/* Go through the Session Startup Parameter List */
DO intParamCnt = 1 TO NUM-ENTRIES(SESSION:PARAMETER,';'):       
    strParam = ENTRY(intParamCnt,SESSION:PARAMETER,';').
    IF NUM-ENTRIES(strParam,"=") EQ 2 THEN DO:
        CASE ENTRY(1,strParam,"="):
            WHEN "FILE-NAME" THEN
               ASSIGN strFileName = ENTRY(2,strparam,"=").

            WHEN "DF-FILE-NAME" THEN
               ASSIGN strDfFileName = ENTRY(2,strparam,"=").
            
            WHEN "CODEPAGE" THEN
               ASSIGN strCodePage = ENTRY(2,strparam,"="). 
                                      
        END CASE.
    END. /* IF NUM-ENTRIES(...) EQ ... */    
END. /* DO intParamCnt = ... */

ASSIGN strDumpDDM = OS-GETENV("DUMP_DDM":U).

/* we are not checking for valid secadmin to support the existing behavior */  
/* Check for valid DDM Admin */ 
IF strDumpDDM = "Yes" OR strDumpDDM = "Both" THEN 
DO:
   IF rConfig = ? THEN 
      ASSIGN rConfig = NEW DBConfig(LDBNAME("DICTDB")).
      
   IF NOT rConfig:IsDDMAdmin THEN 
   DO:
      MESSAGE "You must be a DDM Administrator to access this dump option!"
         VIEW-AS ALERT-BOX ERROR BUTTONS OK.
      RETURN NO-APPLY.
   END.
END.
   
RUN prodict/dump_df.p(INPUT strFileName, 
                      INPUT strDfFileName, 
                      INPUT strCodePage).              
