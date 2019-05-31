/************************************************
  Copyright (c) 2016 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : DomainSystemExport
    Purpose     : Creates export files for configuring an STS/AG 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Tue Apr 12 07:38:22 EDT 2016
    Notes       : * Outputs are
                    - domains.json  : domain config
                    - domainsks.csv : the domain name and DAC. 
                        Only dumped if the user is a security admin 
                  * Logging can be enabled by calling the InitialiseLogging() method.                    
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Assert.
using OpenEdge.Core.Assertion.AssertFile.
using OpenEdge.DataAdmin.Core.PasswordPolicy.
using OpenEdge.DataAdmin.DataAdminService.
using OpenEdge.DataAdmin.IAuthenticationSystem.
using OpenEdge.DataAdmin.IDataAdminService.
using OpenEdge.DataAdmin.IDomain.
using OpenEdge.DataAdmin.IDomainSet.
using OpenEdge.DataAdmin.Lang.Collections.IIterator.
using OpenEdge.DataAdmin.Util.DomainSystemExportEventArgs.
using OpenEdge.DataAdmin.Util.StsDomain.
using OpenEdge.DataAdmin.Util.StsDomainActionEnum.
using OpenEdge.DataAdmin.Util.StsDomainConfig.
using OpenEdge.DataAdmin.Util.StsProvider.
using OpenEdge.Logging.LogLevelEnum.
using Progress.IO.FileOutputStream.
using Progress.IO.OutputStream.
using Progress.Json.ObjectModel.JsonObject.

class OpenEdge.DataAdmin.Util.DomainSystemExport:
    /* Published to allow customisation of whether a domain is exported, and with what data */
    define public event ValidateExportRecord signature void (input poSender as Progress.Lang.Object,
                                                             input poArgs as DomainSystemExportEventArgs). 
    
    /* (mandatory) The database name from which we are dumping data. */
    define public property DbName as character extent no-undo get. private set.
    
    /* (mandatory) The folder location into which to dump the STS config.
       Defaults to SESSION:TEMP-DIR */
    define public property ExportFolder as character no-undo get. set.

    /* The name of the file used to dump the domain config. Defaults 
       to domains.json */
    define public property DomainConfigFile as character no-undo 
        get.
        set(input pcFile as character):
            Assert:NotNullOrEmpty(pcFile, 'Domain config file').
            assign this-object:DomainConfigFile = pcFile. 
        end set.

    /* The name of the file used to dump the domain keystore. Defaults 
       to domainsks.csv */
    define public property DomainKeysFile as character no-undo
        get.
        set(input pcFile as character):
            Assert:NotNullOrEmpty(pcFile, 'Domain keys file').
            assign this-object:DomainKeysFile = pcFile.
        end set.
    
    /* Flags whether the domain should switch its AuthSystem to _EXTSSO after dump.
       Does not remove the auth systems; that's for the admin to do */
    define public property MakeDomainSSO as logical no-undo get. set.
    
    define private variable mLogFileWriter as OutputStream no-undo.
    define private variable mLogLevel as LogLevelEnum no-undo.
    
    define private stream strKeys.
    
    /* Constructor.
       
       @param character[] An array of database names from which to dump. */
    constructor public DomainSystemExport(input pcName as character extent):
        this-object().
        
        Assert:NotNullOrEmpty(pcName, 'db name').
        assign this-object:DbName = pcName.
    end constructor.
    
    /* Default constructor. */
    constructor public DomainSystemExport():
        assign this-object:ExportFolder     = session:temp-dir
               this-object:MakeDomainSSO    = false
               this-object:DomainConfigFile = 'domains.json':u
               this-object:DomainKeysFile   = 'domainsks.csv':u
               .
    end constructor.
    
    /* Constructor.
       
       @param character The database name from which to dump. * means all connected */
    constructor public DomainSystemExport(input pcName as character):
        define variable iLoop as integer no-undo.
        
        this-object().
        
        Assert:NotNullOrEmpty(pcName, 'db name').
        if pcName eq '*':u then
        do:
            assign extent(this-object:DbName) = num-dbs.
            do iLoop = 1 to extent(this-object:DbName):
                assign this-object:DbName[iLoop] = ldbname(iLoop).
            end. 
        end.
        else
            assign extent(this-object:DbName) = 1
                   this-object:DbName[1]      = pcName
                   .
    end constructor.
    
    destructor DomainSystemExport():
        DestroyLogger().
    end destructor.
    
    /* Exports domains from all known databases */
    method public void Export():
        define variable iLoop as integer no-undo.
        define variable iMax as integer no-undo.
        define variable oConfig as StsDomainConfig no-undo.
        define variable oDomains as JsonObject no-undo.

        output stream strKeys to value(substitute('&1/&2':u, this-object:ExportFolder, this-object:DomainKeysFile)).
        
        Assert:NotNullOrEmpty(this-object:DbName, 'Database list').
        assign iMax = extent(this-object:DbName).

        assign oConfig = new StsDomainConfig().
        LogMessage('Export start', LogLevelEnum:INFO).
        ValidateExportFolder().
        
        do iLoop = 1 to iMax:
            this-object:ExportSingle(this-object:DbName[iLoop], oConfig).
        end.
        
        assign oDomains = oConfig:ExportConfig().
        Assert:NotNull(oDomains, 'JSON config').
        oDomains:WriteFile(substitute('&1/&2':u, this-object:ExportFolder, this-object:DomainConfigFile), true).
        
        LogMessage('Export complete', LogLevelEnum:INFO).
        finally:
            output stream strKeys close.
        end finally.
    end method.
    
    /* Check whether the ExportFolder is the -T folder and report if so */    
    method private void ValidateExportFolder():
        define variable cTempDir as character no-undo.        

        assign file-info:file-name = session:temp-dir
               cTempDir            = file-info:full-pathname
               file-info:file-name = this-object:ExportFolder 
               .
        if cTempDir eq file-info:full-pathname then
            LogMessage('Export location is the SESSION:TEMP-DIR. This location may not be secure. Please DELETE exported files after transport to the server',
                       LogLevelEnum:WARN).
    end method.
    
    /* Exports domain & system info for import into an STS
    
       @param character A single connected database */
    method public void Export(input pcDbName as character):
        define variable oDomains as JsonObject no-undo.
        define variable oConfig as StsDomainConfig no-undo.
        
        Assert:NotNullOrEmpty(pcDbName, 'Db name').
        
        output stream strKeys to value(substitute('&1/&2':u, this-object:ExportFolder, this-object:DomainKeysFile)).
        ValidateExportFolder().
        
        assign oConfig = new StsDomainConfig().
        this-object:ExportSingle(pcDbName, oConfig).
        
        assign oDomains = oConfig:ExportConfig().
        Assert:NotNull(oDomains, 'JSON config').
        oDomains:WriteFile(substitute('&1/&2':u, this-object:ExportFolder, this-object:DomainConfigFile), true).
        finally:
            output stream strKeys close.
        end finally.
    end method.                                   
    
    /* Performs the export for a single given db 
       
       @param character A database name to dump
       @param StsDomainConfig The domain dump set */
    method protected void ExportSingle(input pcDbName as character,
                                       input poConfig as StsDomainConfig):
        define variable cDomainName as character no-undo.
        define variable oDAS as IDataAdminService.
        define variable oDomains as IDomainSet no-undo.
        define variable oIter as IIterator no-undo.
        define variable oDomain as IDomain no-undo.
        define variable lIsAdmin as logical no-undo.
        define variable oExtSSO as IAuthenticationSystem no-undo.
        define variable oArgs as DomainSystemExportEventArgs no-undo.
        define variable oPolicyProvider as StsProvider no-undo.
        define variable oStsDomain as StsDomain no-undo.                                     
        define variable cEnumNames as character no-undo.
        define variable cDAC as character no-undo.
        
        Assert:NotNullOrEmpty(pcDbName, 'Db name').
        Assert:NotNull(poConfig, 'Domain config object').
        
        LogMessage(substitute('Export start for db &1', quoter(pcDbName)), LogLevelEnum:INFO).
        
        if not connected(pcDbName) then
        do:
            LogMessage(substitute('Database &1 not connected', quoter(pcDbName)), LogLevelEnum:INFO).
            return.
        end.
        
        run prodict/_dctadmn.p ( input userid(pcDbName), output lIsAdmin ).
        if not lIsAdmin then
            LogMessage(substitute('Current user does not have security admin privileges for &1; keys will not be dumped',
                            pcDbName),
                       LogLevelEnum:WARN).
        
        AssertFile:DirectoryExists(this-object:ExportFolder).
        
        assign oDAS = new DataAdminService(pcDbName)
               
               /* if we're an admin, then make sure that the service knows 
                  we're sending it pre-encoded DACs */
               oDAS:PasswordPolicy = new PasswordPolicy()
               oDAS:PasswordPolicy:PreEncodeDomainAccessCode = lIsAdmin
               
               oDomains = oDAS:GetDomains()
               oIter    = oDomains:Iterator()
               cEnumNames = get-class(StsDomainActionEnum):GetEnumNames()
               .
            
        do while oIter:HasNext() 
           on error undo, throw:
               
            assign oDomain         = cast(oIter:Next(), IDomain)
                   cDomainName     = oDomain:Name
                   oStsDomain      = ?
                   oPolicyProvider = ?
                   .
            /* Rename and skip the default domain */
            if cDomainName eq '':u then
                assign cDomainName = substitute('_OE_DEFAULT_DOMAIN.&1':u, pcDbName).
            
            if poConfig:Domains:ContainsKey(cDomainName) then
            do:
                LogMessage(substitute('Duplicate domain &1 found in db &2',
                                quoter(cDomainName),
                                quoter(pcDbName)),
                           LogLevelEnum:WARN).
                next.    
            end.
            
            assign oStsDomain                 = new StsDomain(cDomainName)
                   oStsDomain:Enabled         = oDomain:IsEnabled
                   oStsDomain:Description     = oDomain:Description
                   oStsDomain:AuthProviderRef = oDomain:AuthenticationSystem:Name
                   
                   oArgs = new DomainSystemExportEventArgs(pcDbName, oStsDomain).
                   .
                   
            if oDomain:IsBuiltin then
                oArgs:CancelExport(substitute('Skipping built-in domain &1 in db &2', 
                                        quoter(cDomainName), quoter(pcDbName))).
            
            if lookup('-localAuth':u, oDomain:RuntimeOptions) gt 0 then
                oArgs:CancelExport(substitute('Skipping local-only domain &1 in db &2',
                                        quoter(cDomainName), quoter(pcDbName))).
            
            /* PAM ACTIONS */
            /* if we have any values set, use those */
            if oDomain:AuthenticationActions eq '':u then
            do:
                if oStsDomain:AuthProviderRef eq '_EXTSSO':u then
                    assign oStsDomain:EnabledDomainActions = oStsDomain:EnabledDomainActions 
                                                             or StsDomainActionEnum:SSO
                          oStsDomain:ActionOptions[lookup('SSO':u, cEnumNames) - 1] = oDomain:SystemOptions
                          .
                else
                if oDomain:AuthenticationSystem:IsEnabled then
                    assign oStsDomain:EnabledDomainActions = oStsDomain:EnabledDomainActions 
                                                             or StsDomainActionEnum:Authenticate
                                                             or StsDomainActionEnum:Exchange
                                                             or StsDomainActionEnum:SSO
                           oStsDomain:ActionOptions[lookup('Authenticate':u, cEnumNames) - 1] = oDomain:SystemOptions
                           oStsDomain:ActionOptions[lookup('Exchange':u, cEnumNames) - 1]     = oDomain:SystemOptions
                           oStsDomain:ActionOptions[lookup('SSO':u, cEnumNames) - 1]     = oDomain:SystemOptions
                           .                                                             
                else
                    assign oStsDomain:EnabledDomainActions = oStsDomain:EnabledDomainActions 
                                                             or StsDomainActionEnum:SSO
                           oStsDomain:ActionOptions[lookup('SSO':u, cEnumNames) - 1] = oDomain:SystemOptions.
            end.
            
            /* DEFAULT POLICY PROVIDERS */
            case oDomain:AuthenticationSystem:Name:
                when '_OEUSERTABLE':u then
                    assign oPolicyProvider              = new StsProvider('UserTablePolicyProvider':u)
                           oPolicyProvider:ProviderType = 'OpenEdge.Security.Provider.UserTablePolicyProvider':u
                           oStsDomain:PolicyProviderRef = oPolicyProvider:ProviderReference.
            end case.

            /* DOMAIN OPTIONS */
            assign oStsDomain:DomainOptions = substitute('&1,&2':u,
                                                oStsDomain:DomainOptions,
                                                trim(oDomain:RuntimeOptions)).
            
            /* Provide a dummy/stub for PAM callbacks. This throws errors at runtime if not converted */
            if oDomain:AuthenticationSystem:Callback ne '':u and
               oDomain:AuthenticationSystem:Callback ne ? then
            do:
                /* Add the exsting PAM callback to the domain options. */
                assign oStsDomain:DomainOptions = oStsDomain:DomainOptions + ',':u
                                                + 'PAMCallback=':u + oDomain:AuthenticationSystem:Callback
                       
                       oPolicyProvider = new StsProvider('UnimplementedPolicyProvider':u)
                       oPolicyProvider:ProviderType = 'OpenEdge.Security.Provider.UnimplementedPolicyProvider':u
                       oStsDomain:PolicyProviderRef = oPolicyProvider:ProviderReference.
                
                LogMessage(substitute('Using policy provider &3 for domain &1. Please convert &2 to a working auth and/or policy provider' ,
                                quoter(cDomainName),
                                oDomain:AuthenticationSystem:Callback,
                                'OpenEdge.Security.Provider.UnimplementedPolicyProvider':u),
                           LogLevelEnum:WARN).
                
                /* Notify that a MD5 is currently in use that needs migration */            
                if oDomain:AuthenticationSystem:ModuleChecksum then
                    LogMessage(substitute('Auth system checksum used for &1; please update in target system',
                                    oDomain:AuthenticationSystem:Name),
                               LogLevelEnum:WARN).
            end.    /* PAM callback in use */
            
            /* Add logging options */
            if lookup('-debug':u, oDomain:RuntimeOptions) gt 0 then
                assign oStsDomain:DomainOptions = oStsDomain:DomainOptions + ',LOG:DEBUG':u.
            if lookup('-verbose':u, oDomain:RuntimeOptions) gt 0 then
                assign oStsDomain:DomainOptions = oStsDomain:DomainOptions + ',LOG:TRACE':u.
            
            /* A processid value implies an exchange operation */
            if lookup('-processid':u, oDomain:SystemOptions) gt 0 then
                assign oStsDomain:EnabledDomainActions = oStsDomain:EnabledDomainActions 
                                                         or StsDomainActionEnum:Exchange
                       oStsDomain:ActionOptions[lookup('Exchange':u, cEnumNames) - 1] = oDomain:SystemOptions  
                       .
            
            assign oStsDomain:DomainOptions = trim(oStsDomain:DomainOptions, ',':u).
            
            /* Let a listener change what's dumped */            
            OnValidateExportRecord(oArgs).
            if oArgs:Cancel then
            do:
                LogMessage(substitute('Dump of domain &1 in db &2 cancelled: &3',
                                quoter(oArgs:DomainName),
                                quoter(oArgs:DbName),
                                oArgs:CancelReason),
                           LogLevelEnum:INFO).
                next.
            end.
            
            /* should be no dups here. Add to the complete config now */            
            poConfig:Domains:Put(oStsDomain:Name, oStsDomain).
            if valid-object(oPolicyProvider) then
                poConfig:PolicyProviders:Put(oPolicyProvider:ProviderReference, oPolicyProvider).
             
            LogMessage(substitute('Domain &1 details dumped', quoter(cDomainName)), LogLevelEnum:DEBUG).
            
            if lIsAdmin then
            do:
                if oDomain:AccessCode eq '':u then
                    LogMessage(substitute('Domain &1 key is blank. Please fix in target system.', 
                               quoter(cDomainName)),
                               LogLevelEnum:ERROR).
                
                /* If the domain access code already contains a prefix, don't add one. If no prefix is
                   specified,it defaults to oech1:: */                
                IF INDEX(oDomain:AccessCode, "::") > 0 THEN
                DO:                    
                    cDAC = oDomain:AccessCode.
                END.
                ELSE IF oDomain:AccessCode EQ "" THEN
                DO:
                    cDAC = "". /* leave blank alone */               
                END.
                ELSE DO:
                    cDAC = substitute('oech1::&1':u, oDomain:AccessCode).
                END.
                
                export stream strKeys delimiter ',':u
                           cDomainName
                           cDAC.
                           
                LogMessage(substitute('Domain &1 keys dumped', quoter(cDomainName)), LogLevelEnum:DEBUG).
            end.
            
            if MakeDomainSSO then
            do:
                if not valid-object(oExtSSO) then
                    assign oExtSSO = oDAS:GetAuthenticationSystem('_EXTSSO':u).
                
                assign oDomain:AuthenticationSystem = oExtSSO
                       oDomain:AuthenticationActions = 'SSO':u.
                
                oDAS:UpdateDomain(oDomain).
                LogMessage(substitute('DOMAIN UPDATED: &1', cDomainName), LogLevelEnum:INFO).
            end.
                        
            catch poError as Progress.Lang.Error :
                LogMessage(substitute('Caught Progress.Lang.Error: &1', poError:GetClass():TypeName), LogLevelEnum:ERROR).
                LogMessage(substitute('Caught Progress.Lang.Error: &1', poError:GetMessage(1)), LogLevelEnum:ERROR).
                
                undo, throw poError.
            end catch.
        end.
        
        LogMessage(substitute('Export complete for db &1', quoter(pcDbName)), LogLevelEnum:INFO).
    end method.
    
/** LOGGING STUFF **/
    /* Closes the logger and cleans up */    
    method public void DestroyLogger():
        if valid-object (mLogFileWriter) then
        do:
            mLogFileWriter:Flush().
            mLogFileWriter:Close().
            assign mLogFileWriter = ?
                   mLogLevel = ?.
        end.
    end method.

    /* Initialises logging at a particular level.
    
       This is a public, previously-published API and we need to 
       support a map back to the OE.Core enums 
       
       @param character The log file into which to log
       @param OpenEdge.Core.LogLevelEnum The level of the events to log - for backwards compat */
    method public void InitializeLogging(input pcLogFile as character,
                                         input poLogLevel as OpenEdge.Core.LogLevelEnum):
        
        InitializeLogging(pcLogFile, LogLevelEnum:GetEnum(integer(poLogLevel))).                                             
    end method.
    
    /* Initialises logging at a particular level.
    
       @param character The log file into which to log
       @param LogLevelEnum The levle of the events to log */
    method public void InitializeLogging(input pcLogFile as character,
                                         input poLogLevel as LogLevelEnum):
        Assert:NotNullOrEmpty(pcLogFile, 'Log file').
        Assert:NotNull(poLogLevel, 'Log level').
        
        assign mLogFileWriter = new FileOutputStream(pcLogFile)
               mLogLevel      = poLogLevel.
    end method.
    
    /* Logs a message
       
       @param character The message to log
       @param LogLevelEnum The level of this message */
    method protected void LogMessage(input pcMessage as character, 
                                     input poLevel as LogLevelEnum):
        define variable cMessage as longchar no-undo.
        define variable mMessage as memptr no-undo.
        define variable CRLF as character initial '~r~n':u no-undo.
        
        if not valid-object(mLogFileWriter) then
            return.
        
        if not valid-object(poLevel) then
            assign poLevel = LogLevelEnum:OFF.
        
        if poLevel eq LogLevelEnum:OFF then
            return.
        
        assign cMessage = substitute('[&1] &2 &3 &4':u,
                                   iso-date(now),
                                   'STSEXPORT':u,    /* group */
                                   string(poLevel),
                                   pcMessage) + CRLF.
        
        if mLogLevel ge poLevel then
        do:
            copy-lob from cMessage to mMessage.
            mLogFileWriter:Write(mMessage).
            mLogFileWriter:Flush().
            set-size(mMessage) = 0.
        end.            
    end method.
    
    /* Publishes the ValidateExportRecord event to allow listeners to tweak the dump
       
       @param DomainSystemExportEventArgs The event args for this domain */
    method protected void OnValidateExportRecord(input poArgs as DomainSystemExportEventArgs):
        Assert:NotNull(poArgs, 'Event args').
        
        this-object:ValidateExportRecord:Publish(this-object, poArgs).
    end method.
    
end class.
