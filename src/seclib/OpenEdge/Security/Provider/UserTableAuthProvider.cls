/************************************************
  Copyright (c) 2016 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : UserTableAuthProvider
    Purpose     : STS authentication provider for built-in _User table 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Tue Feb 23 11:11:25 EST 2016
    Notes       : * Requires an STSDB alias for the db whose _User records we
                    are using for authentication
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Assert.
using OpenEdge.Core.LogLevelEnum.
using OpenEdge.Core.System.UnsupportedOperationError.
using OpenEdge.Security.Provider.IAuthProvider.
using OpenEdge.Security.Provider.IPasswordPolicyProvider.
using OpenEdge.Security.Provider.UserTableAuthProvider.
using Progress.Lang.AppError.
using Progress.Reflect.Flags.
using Progress.Json.ObjectModel.ObjectModelParser.
using Progress.Json.ObjectModel.JsonObject.
using OpenEdge.Security.STS.ClientValidator.
using OpenEdge.Security.Provider.UserTablePasswordProvider.

class OpenEdge.Security.Provider.UserTableAuthProvider implements IAuthProvider:
    /* use to handle the validation of a STS's credentials */
    define private variable moValidator as ClientValidator no-undo.
    
    /* Provides an extension point for overriding the password hashing for _User */
    define protected property PasswordProvider as IPasswordPolicyProvider no-undo
            get.
            private set.
    
    /* 'system' attributes */
    define public static property REALM_ATTR_ROLES      as character initial 'ATTR_ROLES':u no-undo get.
    define public static property REALM_ATTR_ENABLED    as character initial 'ATTR_ENABLED':u no-undo get.
    define public static property REALM_ATTR_EXPIRED    as character initial 'ATTR_EXPIRED':u no-undo get.
    define public static property REALM_ATTR_LOCKED     as character initial 'ATTR_LOCKED':u no-undo get.
    define public static property REALM_ATTR_PASSWD     as character initial 'ATTR_PASSWORD':u no-undo get.
    define public static property REALM_ATTR_DOMAIN     as character initial 'ATTR_DOMAIN':u no-undo get. 
    define public static property REALM_ATTR_SQL_ONLY   as character initial 'ATTR_SQL_ONLY':u no-undo get.
    define public static property REALM_ATTR_PROPERTIES     as character initial "ATTR_PROPERTIES" no-undo get.
    define public static property REALM_ATTR_LAST_LOGIN     as character initial "ATTR_LAST_LOGIN" no-undo get.
    define public static property REALM_ATTR_LOGIN_FAILURES as character initial "ATTR_LOGIN_FAILURES" no-undo get.
    
    /* Default attribute names for BPM */
    define public static property REALM_ATTR_USERID        as character initial 'userid':u no-undo get.
    define public static property REALM_ATTR_GIVENNAME     as character initial 'firstname':u no-undo get.
    define public static property REALM_ATTR_MIDDLEINITIAL as character initial 'middlename':u no-undo get.
    define public static property REALM_ATTR_SURNAME       as character initial 'lastname':u no-undo get.
    define public static property REALM_ATTR_TELEPHONE     as character initial 'phone':u no-undo get.
    define public static property REALM_ATTR_EMAIL         as character initial 'email':u no-undo get.
    define public static property REALM_ATTR_DESCRIPTION   as character initial 'description':u no-undo get.
    
	/* Default constructor */
	constructor public UserTableAuthProvider():
		super().
		
		assign moValidator = new ClientValidator().
		LoadConfig().
		
		/* default values */
		if not valid-object(this-object:PasswordProvider) then
            assign this-object:PasswordProvider = new UserTablePasswordProvider().
    end constructor.
    
    /* Constructor
       
       @param IPasswordPolicyProvider The provider used to provide password hashing etc */
    constructor public UserTableAuthProvider(input poPasswordProvider as IPasswordPolicyProvider):
        super().
        
        Assert:NotNull(poPasswordProvider, 'Password provider').
        
		assign PasswordProvider = poPasswordProvider
		       moValidator      = new ClientValidator().
    end constructor.
    
    /* Loads configuration for this provider */
    method private void LoadConfig():
        define variable oConfig as JsonObject no-undo.
        define variable oProviderType as class Progress.Lang.Class no-undo.
        
        file-info:file-name = 'providers.cfg'.
        if file-info:full-pathname eq ? then
            file-info:file-name = os-getenv('PROVIDER_CONFIG':u).
            
        if file-info:full-pathname ne ? then
            assign oConfig = cast(new ObjectModelParser():ParseFile(file-info:full-pathname), JsonObject).        
        
        if not valid-object(oConfig) or 
           not oConfig:Has(get-class(UserTableAuthProvider):TypeName) then   
            return.
        
        assign oConfig = oConfig:GetJsonObject(get-class(UserTableAuthProvider):TypeName).
        if oConfig:Has('passwordProvider':u) and 
           not oConfig:IsNull('passwordProvider':u) then
        do:
            assign oProviderType = Progress.Lang.Class:GetClass(oConfig:GetCharacter('passwordProvider':u)).
            Assert:IsType(oProviderType, get-class(IPasswordPolicyProvider)).
            
            this-object:PasswordProvider = cast(oProviderType:New(), IPasswordPolicyProvider).            
        end.
    end method.
    
    /* Stringifies an attribute value for return to the caller.
       No validation typically done on the input.
       
       @param character The value to format
       @return character An appropriately-formatted character value */
    method private character Stringify(input pcValue as character):
        return pcValue.
    end method.

    /* Stringifies an attribute value for return to the caller.
       No validation typically done on the input.
       
       @param longchar The value to format
       @return character An appropriately-formatted character value */
    method private character Stringify(input pcValue as longchar):
        return string(pcValue).
    end method.
    
    /* Stringifies an attribute value for return to the caller.
       No validation typically done on the input.
       
       @param logical The value to format
       @return character An appropriately-formatted character value */
    method private character Stringify(input plValue as logical):
        case plValue:
            when false then
                return string(0).
            /* Covers TRUE and ? values */
            otherwise
                return string(1).
        end case.
    end method.

    /* Stringifies an attribute value for return to the caller.
       No validation typically done on the input.
       
       @param datetime-tz The value to format
       @return character An appropriately-formatted character value */
    method private character Stringify(input ptValue as datetime-tz):
        return iso-date(ptValue).
    end method.

    /* Stringifies an attribute value for return to the caller.
       No validation typically done on the input.
       
       @param integer The value to format
       @return character An appropriately-formatted character value */
    method private character Stringify(input piValue as integer):
        return string(piValue).
    end method.

    /* Stringifies an attribute value for return to the caller.
       No validation typically done on the input.
       
       @param decimal The value to format
       @return character An appropriately-formatted character value */
    method private character Stringify(input pdValue as decimal):
        return string(pdValue).
    end method.        
    /* Retrieves a value for the a requested attribute, per user
       
       @param character A unique userid
       @param character The name of the attribute for which to return a value
       return character An attribute value for the given user. May be empty or unknown. */
	method public character GetAttribute(input pcUserId as character, input pcAttributeName as character):
        define variable cAttrVal as character no-undo.
        define variable cDelimiter as character no-undo.
        
        define buffer lbUser  for STSDB._User.
        define buffer lbRoles for STSDB._sec-granted-role.
        
        LogMessage(substitute('Attempting to get attribute &1 for user &2',
                                pcAttributeName,
                                pcUserId),
                   LogLevelEnum:DEBUG).
        
        /* validate the client */
        if not moValidator:Validate(get-class(UserTableAuthProvider):TypeName, 'GetAttribute':u) then
            return error new AppError('Unable to validate client', 0). 
                   
        FindUserRecordForRead(pcUserId, buffer lbUser).
        /* not available will throw an error */
        
        case pcAttributeName:
            when UserTableAuthProvider:REALM_ATTR_ROLES    then            
            do:
                assign cDelimiter = '':u.
                
                for each lbRoles where 
                         lbRoles._grantee eq pcUserId
                         no-lock:
                    assign cAttrVal = cAttrVal + cDelimiter 
                                    + lbRoles._Role-name
                           cDelimiter = ',':u. 
                end.
            end.    //REALM_ATTR_ROLES
                
            when UserTableAuthProvider:REALM_ATTR_LAST_LOGIN then
                assign cAttrVal = Stringify(lbUser._Last_login).
            when UserTableAuthProvider:REALM_ATTR_LOGIN_FAILURES then
                assign cAttrVal = Stringify(lbUser._Login_Failures).
            when UserTableAuthProvider:REALM_ATTR_ENABLED  then
                assign cAttrVal = Stringify(lbUser._Disabled).            
            when UserTableAuthProvider:REALM_ATTR_EXPIRED  then
                assign cAttrVal = Stringify(not(lbUser._Account_expires eq ? or lbUser._Account_expires gt now)).
            when UserTableAuthProvider:REALM_ATTR_DOMAIN   then
                assign cAttrVal = Stringify(lbUser._Domain-Name).
            when UserTableAuthProvider:REALM_ATTR_SQL_ONLY then 
                assign cAttrVal = Stringify(lbUser._sql-only-user).
            when UserTableAuthProvider:REALM_ATTR_USERID then
                assign cAttrVal = Stringify(pcUserId).
            when UserTableAuthProvider:REALM_ATTR_GIVENNAME then
                assign cAttrVal = Stringify(lbUser._Given_name).
            when UserTableAuthProvider:REALM_ATTR_MIDDLEINITIAL then 
                assign cAttrVal = Stringify(lbUser._Middle_initial).
            when UserTableAuthProvider:REALM_ATTR_SURNAME then
                assign cAttrVal = Stringify(lbUser._Surname).
            when UserTableAuthProvider:REALM_ATTR_TELEPHONE then
                assign cAttrVal = Stringify(lbUser._Telephone).
            when UserTableAuthProvider:REALM_ATTR_EMAIL then
                assign cAttrVal = Stringify(lbUser._Email).
            when UserTableAuthProvider:REALM_ATTR_DESCRIPTION then
                assign cAttrVal = Stringify(lbUser._Description).
            
            /* UNSUPPORTED PROPERTIES */
            when UserTableAuthProvider:REALM_ATTR_LOCKED   or
            when UserTableAuthProvider:REALM_ATTR_PROPERTIES or
            when UserTableAuthProvider:REALM_ATTR_PASSWD   then
            do:
                LogMessage(substitute('Unsupported attribute &1', pcAttributeName), 
                           LogLevelEnum:DEBUG).
                assign cAttrVal = ?.
            end.    //UNSUPPORTED
            
            otherwise
            do:
                LogMessage(substitute('Unknown attribute &1', pcAttributeName), 
                           LogLevelEnum:DEBUG).
                assign cAttrVal = ?.
            end.    //OTHERWISE
        end case.
        
        LogMessage(substitute('Returning &2 for attribute value', cAttrVal), 
                   LogLevelEnum:DEBUG).
        
        return cAttrVal.	
    end method.

    /* Returns an array of attributes for a given user.
       In the _USER case all users are equal.
    
       @param character A unique userid
       @return character[] An array of attribute names. */
	method public character extent GetAttributeNames( input pcUserId as character ):
	    define variable cNames as character extent no-undo.
        define variable oType as class Progress.Lang.Class no-undo.
        define variable oProps as class Progress.Reflect.Property extent no-undo.
        define variable iLoop as integer no-undo.
        
        LogMessage(substitute('Attempting to get attribute names for user &1',
                                pcUserId),
                   LogLevelEnum:DEBUG).
        
        /* validate the client */
        if not moValidator:Validate(get-class(UserTableAuthProvider):TypeName, 'GetAttributeNames':u) then
            return error new AppError('Unable to validate client', 0). 
                   
        assign oProps = get-class(OpenEdge.Security.Provider.UserTableAuthProvider)
                            :GetProperties(Flags:Static)
               extent(cNames) = extent(oProps)
               no-error.
        
        do iLoop = extent(oProps) to 1 by -1:
            assign cNames[iLoop] = oProps[iLoop]:Get().
            
            LogMessage(substitute('Supported attribute name &1',
                                    cNames[iLoop]),
                       LogLevelEnum:DEBUG).
        end.
        
        return cNames.        
    end method.

    /* Simple, clear-text password validation for a user
              
       @param character A unique userid
       @param character The user's (cleartext) password to verify 
       @return logical TRUE if the provide credentials match the realm's values */
	method public logical ValidatePassword(input pcUserId as character,
	                                       input pcPassword as character ):
		define variable lValid as logical no-undo.

        define buffer lbUser for STSDB._User.
        
        LogMessage(substitute('Attempting to validate clear-text password for user &1',
                                pcUserId),
                   LogLevelEnum:DEBUG).
        
        /* validate the client */
        if not moValidator:Validate(get-class(UserTableAuthProvider):TypeName, 'ValidatePassword':u) then
            return error new AppError('Unable to validate client', 0). 
        
        FindUserRecordForRead(pcUserId, buffer lbUser).
        /* not available will throw an error */
        
        assign lValid = lbUser._Password eq PasswordProvider:HashPassword(
                                                    pcPassword, 
                                                    PasswordProvider:GetUserSalt(buffer lbUser:handle)).
        LogMessage(substitute('Is valid password: &1', lValid),
                   LogLevelEnum:DEBUG).
        
        return lValid.
	end method.

    /* Digest-encoded password validation for a user
       
       @param character A unique userid 
       @param character The hashed digest of the password to verify
       @param character The nonce value used to create the digest hash 
       @param character The timestamp value used to create the digest hash 
       @return logical TRUE if the provide credentials match the realm's values */
    method public logical ValidatePassword(input pcUserId as character, 
                                           input pcDigest as character,
                                           input pcNonce as character,
                                           input pcTimestamp as character ):
        LogMessage(substitute('Attempting to validate digest password for user &1',
                                pcUserId),
                   LogLevelEnum:DEBUG).
        
        /* validate the client */
        if not moValidator:Validate(get-class(UserTableAuthProvider):TypeName, 'ValidatePassword':u) then
            return error new AppError('Unable to validate client', 0). 
        
        return error new UnsupportedOperationError('Operation':u, get-class(IAuthProvider):TypeName).                    
	end method.
	
    /* Validates that the username is in the realm, and returns a unique identifier for 
       the user (which may be the username@domain).
       
       @param character The client-supplied username
       @return character A unique identifier for the user */
	method public character ValidateUser( input pcUserName as character ):
	    define buffer lbUser for STSDB._User.
	    
        LogMessage(substitute('Validating user &1', pcUserName), LogLevelEnum:DEBUG).

        /* validate the client */
        if not moValidator:Validate(get-class(UserTableAuthProvider):TypeName, 'ValidateUser':u) then
            return error new AppError('Unable to validate client', 0). 
        
        FindUserRecordForRead(pcUserName, buffer lbUser).
        
        return pcUserName.
	end method.
	
    /* Sets an attribute's value for a user. May optionally create an attribute value.
       
       @param character A unique userid
       @param character The name of the attribute to remove
       @param character The value to apply 
       @return logical TRUE if the attribute value was successfully set; FALSE otherwise */
    method public logical SetAttribute(input pcUserId as character,
                                       input pcAttributeName as character,
                                       input pcAttributeValue as character ):
        define variable lUpdated as logical no-undo.
        define buffer lbUser for STSDB._User.
        
        LogMessage(substitute('Attempting to set attribute &1 for user &2',
                                pcAttributeName,
                                pcUserId),
                   LogLevelEnum:DEBUG).
        
        /* validate the client */
        if not moValidator:Validate(get-class(UserTableAuthProvider):TypeName, 'SetAttribute':u) then
            return error new AppError('Unable to validate client', 0). 
                   
        Assert:NotNullOrEmpty(pcAttributeName, 'Attribute name').
        
        do for lbUser transaction:
            FindUserRecordForUpdate(pcUserId, buffer lbUser).
            /* not available or locked will throw an error */
            
            case pcAttributeName:
                when UserTableAuthProvider:REALM_ATTR_LAST_LOGIN then
                    assign lbUser._Last_login = datetime-tz(pcAttributeValue)
                           lUpdated = true.
                when UserTableAuthProvider:REALM_ATTR_LOGIN_FAILURES then
                    assign lbUser._Login_failures = lbUser._Login_failures + integer(pcAttributeValue)
                           lUpdated = true.
                when UserTableAuthProvider:REALM_ATTR_ENABLED then
                    /* flip around 'cos the value stored is disabled */
                    assign lbUser._Disabled = not logical(pcAttributeName)
                           lUpdated = true.
                otherwise 
                do:
                    LogMessage(substitute('Cannot set attribute &1 for user &2',
                                            pcAttributeName,
                                            pcUserId), 
                               LogLevelEnum:WARN).
                    assign lUpdated = false.
                end.
            end case.
            
            /* force (write) triggers to fire */
            validate lbUser.
        end.    /* TRANSACTION BLOCK */
        
        return lUpdated.
    end method.	
    /* Helper method for finding a _User record for READ 
       
       @param character The User@Domain user name/id
       @param buffer The _User buffer to use */
	method private void FindUserRecordForRead(input  pcUserName as character,
	                                          buffer pbUser for STSDB._User):
        define variable cSplitUser as character extent 2 no-undo.
        assign cSplitUser = SplitUserId(pcUserName).
        
        find pbUser where
             pbUser._Userid      eq cSplitUser[1] and
             pbUser._Domain-Name eq cSplitUser[2]
             no-lock no-error.
        if not available pbUser then
        do:
            LogMessage(substitute('Unknown user &1', pcUserName),
                       LogLevelEnum:DEBUG).
            return error new AppError('User not found', 0).
        end.
	end method. 

    /* Helper method for finding a _User record for UPDATE 
       
       @param character The User@Domain user name/id
       @param buffer The _User buffer to use */
    method private void FindUserRecordForUpdate(input  pcUserName as character,
                                                buffer pbUser for STSDB._User):
        define variable cSplitUser as character extent 2 no-undo.
        assign cSplitUser = SplitUserId(pcUserName).
        
        find pbUser where
             pbUser._Userid      eq cSplitUser[1] and
             pbUser._Domain-Name eq cSplitUser[2]
             exclusive-lock no-wait no-error.
        if not available pbUser then
        do:
            LogMessage(substitute('Unknown user &1', pcUserName),
                       LogLevelEnum:DEBUG).
            return error new AppError('User not found', 0).
        end.
        if locked pbUser then
        do:
            LogMessage(substitute('Unable to lock user &1 for update', pcUserName), 
                       LogLevelEnum:WARN).
            return error new AppError('Cannot update user', 0).
        end.
    end method. 
    
    /* Splits a user@domain string into its component parts.
    
       @param character A user@domain string to split
       @return character[2]  1=userid (not empty/null); 2=domain (not null) */
    method private character extent 2 SplitUserId(input pcUserName as character ):
        define variable cSplitUser as character extent 2 no-undo.
        
        assign cSplitUser[1] = entry(1, pcUserName, '@':u)
               cSplitUser[2] = entry(2, pcUserName, '@':u)
               no-error.
               
        Assert:NotNullOrEmpty(cSplitUser[1], 'User id').
        Assert:NotNull(cSplitUser[2], 'User domain').
        
        return cSplitUser.
    end method.
    
    /** Logs a message 
        
        @param character The message to log
        @param integer  The level this message should be logged at */
    method private void LogMessage(input pcMessage as character,
                                   input poLogLevel as LogLevelEnum):
        if log-manager:logfile-name eq ? then
            return.
        
        if log-manager:logging-level ge integer(poLogLevel) then
            log-manager:write-message(pcMessage, 'USRTBLAP':u).
    end method.
    
end class.