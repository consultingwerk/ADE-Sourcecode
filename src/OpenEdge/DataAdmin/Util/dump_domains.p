/************************************************
  Copyright (c) 2016 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : dump_domains.p
    Purpose     : Dumps domain info for all connected databases 
    Syntax      : -p OpenEdge/DataAdmin/Util/dump_domains.p -param LOG:<level>,FOLDER:<folder>,MAKESSO:<true|false>
    Description : 
    Author(s)   : pjudge
    Created     : 2016-04-14
    Notes       : * Defaults to session:temp-dir if a folder is not provided
                    or cannot be found.
                  * Defaults to LogLevelEnum:WARN if a value is not provided or
                    is invalid.
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Logging.LogLevelEnum.
using OpenEdge.DataAdmin.Util.DomainSystemExport.

define variable oDSE as DomainSystemExport no-undo.
define variable lExportFolder as character no-undo.
define variable lMakeDomainSSO as logical no-undo.
define variable cConfigFile as character no-undo.
define variable cKeyStoreFile as character no-undo.
define variable oLogLevel as LogLevelEnum no-undo.
define variable iLoop as integer no-undo.
define variable iMax as integer no-undo.
define variable cEntry as character no-undo.
define variable cRunLog as character no-undo.
define variable cDumpLog as character no-undo.

function PutMessage returns logical (input pcMessage as character, input poLevel as LogLevelEnum):
    put unformatted 
        substitute('[&1] &2 &3 &4':u,
            iso-date(now),
            'STSEXPORT':u,    /* group */
            string(poLevel),  
            pcMessage) 
        skip.
end function.    

/* extract params */
assign iMax = num-entries (session:parameter).
do iLoop = 1 to iMax:
    assign cEntry = entry(iLoop, session:parameter).
    
    case entry(1, cEntry, ':':u):
        when 'FOLDER':u then
            /* the folder may have a : in it so don't use ENTRY() */
            assign lExportFolder = substring(cEntry, 8)
                   no-error.
        when 'LOG':u then
            assign oLogLevel = LogLevelEnum:GetEnum(entry(2, cEntry, ':':u)) 
                   no-error.
        when 'MAKESSO':u then
            assign lMakeDomainSSO = logical(entry(2, cEntry, ':':u))
                   no-error.
        when 'CONFIG-FILE':u then
            assign cConfigFile = entry(2, cEntry, ':':u)
                   no-error.
        when 'KEYSTORE-FILE':u then
            assign cKeyStoreFile = entry(2, cEntry, ':':u)
                   no-error.
    end case.
end.

/* set sensible defaults */
assign file-info:file-name = lExportFolder.
if file-info:full-pathname eq ? then
    assign file-info:file-name = os-getenv('WRKDIR':u).
if file-info:full-pathname eq ? then
    assign file-info:file-name = '.':u.
if file-info:full-pathname eq ? then
    assign file-info:file-name = session:temp-dir.

if not valid-object(oLogLevel) then
    assign oLogLevel = LogLevelEnum:WARN.

if lMakeDomainSSO eq ? then
    assign lMakeDomainSSO = false.

assign cRunLog  = file-info:full-pathname + '/domain_dump_runner.log':u
       cDumpLog = file-info:full-pathname + '/domain_dump.log':u.  

output to value(cRunLog).
    PutMessage(substitute('SESSION:PARAM: &1':u, session:parameter),            LogLevelEnum:INFO).
    PutMessage(substitute('Export folder: &1', lExportFolder),                  LogLevelEnum:INFO).
    PutMessage(substitute('Log level: &1 / &2', oLogLevel, string(oLogLevel)),  LogLevelEnum:INFO).
    PutMessage(substitute('Make domains SSO: &1', lMakeDomainSSO),              LogLevelEnum:INFO).
    PutMessage(substitute('Export folder: &1', lExportFolder),                  LogLevelEnum:INFO).
    PutMessage(substitute('Dump log: &1', cDumpLog),                            LogLevelEnum:INFO).
    PutMessage(substitute('Config file: &1', cConfigFile),                      LogLevelEnum:INFO).
    PutMessage(substitute('Keystore file: &1', cKeyStoreFile),                  LogLevelEnum:INFO).
output close.

/* ready to go */
assign oDSE               = new DomainSystemExport('*':u)
       oDSE:ExportFolder  = file-info:full-pathname
       oDSE:MakeDomainSSO = lMakeDomainSSO 
       .
if cConfigFile ne '':u then
    assign oDSE:DomainConfigFile = cConfigFile.
if cKeyStoreFile ne '':u then
    assign oDSE:DomainKeysFile = cKeyStoreFile.

oDSE:InitializeLogging(cDumpLog, oLogLevel).

/* dump! */
oDSE:Export().

catch poError as Progress.Lang.Error :
    if valid-object(oDSE) then
        oDSE:DestroyLogger().
    
    output to value(cRunLog) append.
        PutMessage(substitute('Caught Progress.Lang.Error: &1', poError:GetClass():TypeName),   LogLevelEnum:ERROR).
        PutMessage(substitute('Caught Progress.Lang.Error: &1', poError:GetMessage(1)),         LogLevelEnum:ERROR).
        PutMessage(substitute('Caught Progress.Lang.Error: &1', poError:CallStack),             LogLevelEnum:ERROR).
    output close.
end catch.
finally:
    output to value(cRunLog) append.
    PutMessage('EXPORT COMPLETE', LogLevelEnum:INFO).  
    output close.
end finally.
/* eof */
