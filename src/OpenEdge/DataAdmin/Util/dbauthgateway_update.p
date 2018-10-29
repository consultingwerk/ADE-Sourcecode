 /************************************************
  Copyright (c) 2016 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : dbauthgateway_update.p
    Purpose     : Enables the Db connection role feature 
    Author(s)   : pjudge
    Created     : 2016-05-11
    Notes       : * This utility operates against all currently-connected DBs
                  * Behaviour can be tweaked using the -param switch, with
                    values formatted in comma- and colon-delimited pairs
                    <name-1>:<value-1>,<name-2>:<value-2> ...
                  * Supported options
                    FOLDER      : (optional) an extant folder name for writing logs. 
                                  If not provided, we use the first
                                  extant folder:
                                    - WRKDIR env var
                                    - '.' (current dir)
                                    - session temp-dir (-T) 
                    URL         : (mandatory) a URL to the STS service 
                    TEST-URL    : (optional) Indicates whether we should try
                                  to verify that the server is available
                    SSL-OPTIONS: (optional) Options relating to SSL that the test
                                 connection may need
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Logging.LogLevelEnum.
using OpenEdge.Core.Session.
using OpenEdge.DataAdmin.DataAdminService.
using OpenEdge.DataAdmin.DatabaseOptionTypeEnum.
using OpenEdge.DataAdmin.IDataAdminService.
using OpenEdge.DataAdmin.IDatabaseOption.
using OpenEdge.DataAdmin.IRole.
using OpenEdge.DataAdmin.IGrantedRole.
using OpenEdge.DataAdmin.IGrantedRoleSet.
using OpenEdge.DataAdmin.Lang.Collections.IIterator.
using Progress.Json.ObjectModel.JsonArray.
using Progress.Json.ObjectModel.JsonObject.
using OpenEdge.Core.Assert.
using Progress.Lang.AppError.

/* ********************  Definitions  ******************** */
define variable oDAS as IDataAdminService no-undo.
define variable cDB as character no-undo.
define variable cUrl as character no-undo.
define variable oDbOpt as IDatabaseOption no-undo.
define variable iMax as integer no-undo.
define variable iLoop as integer no-undo.
define variable hCurrentUser as handle no-undo.
define variable cFolder as character no-undo.
define variable cRunLog as character no-undo.
define variable cEntry as character no-undo.
define variable lHasUrl as logical no-undo.
define variable lHasServername as logical no-undo.
define variable cSslOptions as character no-undo.
define variable cServerName as character no-undo.
define variable lTestUrl as logical no-undo.

/* ************************** UDFs & procedures  *************************** */
&scoped-define DB-OPTION-CODE _db.sts.url
&scoped-define DB-OPTION-CODE1 _db.sts.sniHostName

{OpenEdge/DataAdmin/Util/dboptionutils_fn.i
    &EXPORT-LOG-GROUP='DBSTSURL'
    &EXPORT-LOG=cRunLog}

function CanConnect returns logical (input pcURI as character,
                                     input pcSSLOptions as character,
									 input pcServerName as character):
    define variable hSocket as handle no-undo.
    define variable cHost as character no-undo.
    define variable iPort as integer no-undo.
    define variable cScheme as character no-undo.
    define variable iMax as integer no-undo.
    
    assign iMax = num-entries(pcURI, '/':u).
    /* we need at least 3 entries for this to be a decent URL:
         1  - scheme (eg http:)
         2  - the space between the 2 /'s
         3  - the host, port and optionally user/password 
         4+ - the path and other slugs */
    if iMax ge 3 then
        assign cScheme = right-trim(entry(1, pcURI, '/':u), ':':u).
    Assert:NotNullOrEmpty(cScheme, 'URI scheme').

    if cScheme ne 'https':u then
        undo, throw new AppError(substitute('STS URL scheme is &1; expecting &2',
                                    quoter(cScheme), quoter('https':u)),
                                0).
        
    /* entry 2 is the 'space' between the double slashes */
    assign cHost = entry(3, pcURI, '/':u)
           /* get rid of any user/password info */
           cHost = entry(2, cHost, '@':u) 
           no-error.

    if index(cHost, ':':u) eq 0 then
        assign iPort = ?.
    else
        /* port first, else we lose it */
        assign iPort = integer(entry(2, cHost, ':':u))
               cHost = entry(1, cHost, ':':u).

    if iPort eq ? then
        assign iPort = 443.

    Assert:NotNullOrZero(iPort, 'Port').
    if iPort gt 65535 then
        undo, throw new AppError(
                            substitute('Port is too large: &1', iPort),
                            0).
    
    if pcSSLOptions eq ? then
        assign pcSSLOptions = '':u.
	
	if pcServerName eq "" then
       lHasServername = false.
        
    create socket hSocket.
	if lHasServername then
	do:
		return hSocket:connect(substitute('-H &1 -S &2 -ssl &3 -servername &4':u, 
                               cHost, 
                               iPort,
                               pcSSLOptions,
							   pcServerName)).
		
							   
	end.
	else
	do:
		return hSocket:connect(substitute('-H &1 -S &2 -ssl &3':u, 
                               cHost, 
                               iPort,
                               pcSSLOptions)).
		
	end.
    finally:
        if valid-handle(hSocket) then
            hSocket:disconnect() no-error.
        delete object hSocket no-error.
    end finally.
end function.   

/* ***************************  Main Block  *************************** */
/* extract params */
assign iMax     = num-entries(session:parameter)
       lHasUrl  = false
       lTestUrl = true.
do iLoop = 1 to iMax:
    assign cEntry = entry(iLoop, session:parameter).
    
    case entry(1, cEntry, ':':u):
        when 'FOLDER':u then
            /* the folder may have a : in it so don't use ENTRY() */
            assign cFolder = substring(cEntry, 8)
                   no-error.
        when 'URL':u then                   
            assign cUrl    = substring(cEntry, 5)
                   lHasUrl = true
                   no-error.
        when 'SSL-OPTIONS':u then
            assign cSslOptions =  substring(cEntry, 13)
                   no-error.
		when 'SERVERNAME':u then
            assign cServerName =  substring(cEntry, 12)
                   no-error.
        when 'TEST-URL':u then
            assign lTestUrl = logical(entry(2, cEntry, ':':u)) 
                   no-error.
    end case.
end.

/* dump info */
assign cRunLog  = GetOutputFolder(cFolder) + '/dbauthgateway_update.log':u.
InitLog().

PutMessage('OPERATION: UPDATE':u,                                LogLevelEnum:INFO).
PutMessage(substitute('SESSION:PARAM: &1':u, session:parameter), LogLevelEnum:INFO).

if lHasUrl then
do:
    PutMessage(substitute('URL: &1', cUrl), LogLevelEnum:INFO).
    PutMessage(substitute('TEST-URL? &1', lTestUrl), LogLevelEnum:INFO).
    PutMessage(substitute('SSL-OPTIONS: &1', cSslOptions), LogLevelEnum:INFO).
	PutMessage(substitute('SERVERNAME: &1', cServerName), LogLevelEnum:INFO).
    
    Assert:NotNullOrEmpty(cUrl, 'STS URL').
	assign lHasServername = true.
    if lTestUrl and 
       not CanConnect(cUrl, cSslOptions,cServerName) then
        undo, throw new AppError(substitute('Unable to connect to STS URL &1 with options &2',
                                    cUrl,
                                    cSslOptions), 
                                 0).       
end.
else
    undo, throw new AppError('No URL value specified in -param options', 0).
    
/* main run */
do iLoop = 1 to num-dbs:
    assign cDB   = ldbname(iLoop)
           hCurrentUser = get-db-client(cDB).
    if hCurrentUser:qualified-user-id eq '':u then
    do:
        PutMessage(substitute('Blank userids cannot update the STS URL for db &1', 
                        quoter(cDB)),
                   LogLevelEnum:ERROR).
        next.
    end.
    
    if not IsAdmin(hCurrentUser:qualified-user-id) then
    do: 
        PutMessage(substitute('Current user is not a security admin for db &1', 
                        quoter(cDB)),   
                   LogLevelEnum:ERROR).
        next.
    end.
    
    assign oDAS   = new DataAdminService(cDB)
           oDbOpt = oDAS:GetDatabaseOption('{&DB-OPTION-CODE}':u).
           
    if not valid-object(oDbOpt) then
    do:
        assign oDbOpt             = oDAS:NewDatabaseOption('{&DB-OPTION-CODE}':u)
               oDbOpt:Description = 'Specifies the URL for the OE authentication gateway'
               oDbOpt:OptionType  = integer(DatabaseOptionTypeEnum:AuthenticationGateway)
               oDbOpt:OptionValue = cUrl.
        oDAS:CreateDatabaseOption(oDbOpt).
    
        PutMessage(substitute('STS Url created for &1', 
                        quoter(cDB)),
                   LogLevelEnum:INFO).
    end.
    else
    do:
        assign oDbOpt:OptionValue = cUrl.
        oDAS:UpdateDatabaseOption(oDbOpt).
    
        PutMessage(substitute('STS Url updated for &1', 
                        quoter(cDB)),
                   LogLevelEnum:INFO).
    end.
	if lHasServername then
	do:
		oDbOpt = oDAS:GetDatabaseOption('{&DB-OPTION-CODE1}':u).
		if not valid-object(oDbOpt) then
		do:
			assign oDbOpt             = oDAS:NewDatabaseOption('{&DB-OPTION-CODE1}':u)
				oDbOpt:Description = 'Specifies the SNIHostName for the OE authentication gateway'
				oDbOpt:OptionType  = integer(DatabaseOptionTypeEnum:AuthenticationGateway)
				oDbOpt:OptionValue = cServerName.
			oDAS:CreateDatabaseOption(oDbOpt).
		
			PutMessage(substitute('STS sniHostName created for &1', 
							quoter(cDB)),
					LogLevelEnum:INFO).
		end.
		else
		do:
			assign oDbOpt:OptionValue = cServerName.
			oDAS:UpdateDatabaseOption(oDbOpt).
		
			PutMessage(substitute('STS sniHostName updated for &1', 
							quoter(cDB)),
					LogLevelEnum:INFO).
		end.
	end.
end.

{OpenEdge/DataAdmin/Util/dboptionutils_eof.i
        &EXPORT-LOG=cRunLog}

/* eof */
