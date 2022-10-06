/************************************************
  Copyright (c) 2016, 2022 by Progress Software Corporation. All rights reserved.
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
using OpenEdge.Core.Json.JsonPropertyHelper.
using OpenEdge.Core.System.UnsupportedOperationError.
using OpenEdge.Core.TimeStamp.
using OpenEdge.Logging.ILogWriter.
using OpenEdge.Logging.ISupportLogging.
using OpenEdge.Logging.LoggerBuilder.
using OpenEdge.Security.Provider.IAuthProvider.
using OpenEdge.Security.Provider.IPasswordPolicyProvider.
using OpenEdge.Security.Provider.ProviderConfig.
using OpenEdge.Security.Provider.UserTablePasswordProvider.
using Progress.Json.ObjectModel.JsonDataType.
using Progress.Json.ObjectModel.JsonObject.
using Progress.Lang.AppError.
using Progress.Reflect.Flags.
using OpenEdge.Security.Provider.UserTableAuthProvider.

class OpenEdge.Security.Provider.UserTableAuthProvider implements IAuthProvider, ISupportLogging:
    
    // A reference to the Logger in use by an implementer
    define public property Logger as ILogWriter no-undo
        get():
            // if someone has specifically set this logger, use that, otherwise ask for a new/cached instance
            // each time
            if valid-object(this-object:Logger) then
                return this-object:Logger.
            else
                // The LoggerBuilder deals handles caching of logwriter instances
                return LoggerBuilder:GetLogger(get-class(UserTableAuthProvider)).
        end get.
        set.
    
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
        
        Initialize().
    end constructor.
    
    /* Constructor.
       
       This constructor largely used for testing IPasswordPolicyProvider implementations; in the
       OEAG instance, the PasswordProvider will either be the default, or a value provided by config.
       
       @param IPasswordPolicyProvider The provider used to provide password hashing etc */
    constructor public UserTableAuthProvider(input poPasswordProvider as IPasswordPolicyProvider):
        this-object().
        
        Assert:NotNull(poPasswordProvider, 'Password provider').
        
        assign this-object:PasswordProvider = poPasswordProvider.
    end constructor.
    
    /* Loads configuration for this provider */
    method private void Initialize():
        var Progress.Lang.Class providerType.
        var JsonObject cfg = ProviderConfig:GetConfig(get-class(UserTableAuthProvider):TypeName).
        var character providerName.
        
        // deals with unknown values too
        if JsonPropertyHelper:HasTypedProperty(cfg, 'passwordProvider', JsonDataType:STRING) then
        do on error undo, throw:
            assign providerName = cfg:GetCharacter('passwordProvider')
                   providerType = Progress.Lang.Class:GetClass(providerName)
                   .
            Assert:IsType(providerType, get-class(IPasswordPolicyProvider)).
            
            assign this-object:PasswordProvider = cast(providerType:New(), IPasswordPolicyProvider).
            catch uncaught as Progress.Lang.Error:
                Logger:Error(substitute('Unable to create password provider &1', providerName), uncaught).
            end catch.
        end.
        
        /* default values */
        if not valid-object(this-object:PasswordProvider) then
            assign this-object:PasswordProvider = new UserTablePasswordProvider().
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
        {&_proparse_ prolint-nowarn(overflow)}
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
        define buffer lbRoles for STSDB._Sec-granted-role.
        
        Logger:Debug(substitute('Attempting to get attribute &1 for user: &2',
                                pcAttributeName,
                                pcUserId)).
        
        FindUserRecordForRead(pcUserId, buffer lbUser).
        /* not available will throw an error */
        
        case pcAttributeName:
            when UserTableAuthProvider:REALM_ATTR_ROLES    then
            do:
                assign cDelimiter = '':u.
                
                for each lbRoles where
                         lbRoles._Grantee eq pcUserId
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
                Logger:Debug(substitute('Unsupported attribute &1', pcAttributeName)).
                assign cAttrVal = ?.
            end.    //UNSUPPORTED
            
            otherwise
            do:
                Logger:Debug(substitute('Unknown attribute &1', pcAttributeName)).
                assign cAttrVal = ?.
            end.    //OTHERWISE
        end case.
        
        Logger:Debug(substitute('Attribute &1 value: &2', pcAttributeName, cAttrVal)).
        
        return cAttrVal.
    end method.

    /* Returns an array of attributes for a given user.
       In the _USER case all users are equal.
    
       @param character A unique userid
       @return character[] An array of attribute names. */
    method public character extent GetAttributeNames( input pcUserId as character ):
        define variable cNames as character extent no-undo.
        define variable oProps as class Progress.Reflect.Property extent no-undo.
        define variable iLoop as integer no-undo.
        
        Logger:Debug(substitute('Attempting to get attribute names for user: &1',
                                pcUserId)).
        
        assign oProps = get-class(OpenEdge.Security.Provider.UserTableAuthProvider)
                            :GetProperties(Flags:Static or Flags:Public)
               extent(cNames) = extent(oProps)
               no-error.
        
        do iLoop = extent(oProps) to 1 by -1:
            assign cNames[iLoop] = oProps[iLoop]:Get().
            Logger:Debug(substitute('Supported attribute name &1', cNames[iLoop])).
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
        
        Logger:Debug(substitute('Attempting to validate clear-text password for user: &1', pcUserId)).
        
        FindUserRecordForRead(pcUserId, buffer lbUser).
        /* not available will throw an error */
        
        assign lValid = lbUser._Password eq PasswordProvider:HashPassword(
                                                    pcPassword,
                                                    PasswordProvider:GetUserSalt(buffer lbUser:handle)).
        Logger:Debug(substitute('Password for user &2 is &1',
                                    // spaces after 'valid' for prettier formatting
                                    string(lValid, 'valid  /invalid'),
                                    pcUserId)).
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
        Logger:Debug(substitute('Attempting to validate digest password for user: &1', pcUserId)).
        
        return error new UnsupportedOperationError('Operation':u, get-class(IAuthProvider):TypeName).
    end method.
    
    /* Validates that the username is in the realm, and returns a unique identifier for
       the user (which may be the username@domain).
       
       @param character The client-supplied username
       @return character A unique identifier for the user */
    method public character ValidateUser( input pcUserName as character ):
        define buffer lbUser for STSDB._User.
        
        Logger:Debug(substitute('Validating user: &1', pcUserName)).
        
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
        
        Logger:Debug(substitute('Attempting to set attribute &1 for user: &2',
                                pcAttributeName,
                                pcUserId)).
        
        Assert:NotNullOrEmpty(pcAttributeName, 'Attribute name').
        
        do for lbUser transaction:
            FindUserRecordForUpdate(pcUserId, buffer lbUser).
            /* not available or locked will throw an error */
            
            case pcAttributeName:
                when UserTableAuthProvider:REALM_ATTR_LAST_LOGIN then
                    assign lbUser._Last_login = TimeStamp:ToABLDateTimeTzFromISO(pcAttributeValue)
                           lUpdated = true.
                when UserTableAuthProvider:REALM_ATTR_LOGIN_FAILURES then
                    assign lbUser._Login_failures = lbUser._Login_failures + integer(pcAttributeValue)
                           lUpdated = true.
                when UserTableAuthProvider:REALM_ATTR_ENABLED then
                    /* flip around 'cos the value stored is disabled */
                    assign lbUser._Disabled = not logical(pcAttributeValue)
                           lUpdated         = true
                           .
                otherwise
                do:
                    Logger:Warn(substitute('Cannot set attribute &1 for user: &2',
                                            pcAttributeName,
                                            pcUserId)).
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
            Logger:Debug(substitute('Unknown user: &1', pcUserName)).
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
            Logger:Debug(substitute('Unknown user: &1', pcUserName)).
            return error new AppError('User not found', 0).
        end.
        if locked pbUser then
        do:
            Logger:Warn(substitute('Unable to lock user: &1 for update', pcUserName)).
            return error new AppError('Cannot update user', 0).
        end.
    end method.
    
    /* Splits a user@domain string into its component parts.
       A user name may be one of the following forms
         i) user                (blank domain)
        ii) user@oedomaim       (oe domain)
       iii) user@email@oedomain (email address + domain)
       
       @param character A user@domain string to split
       @return character[2]  1=userid (not empty/null). May contain the @email portion;
                             2=domain (not null)    */
    method private character extent 2 SplitUserId(input pcUserName as character ):
        define variable cSplitUser as character extent 2 no-undo.
        var integer pos = r-index(pcUserName, '@':u),
                    cnt = num-entries(pcUserName, '@':u)
                    .
        if cnt gt 3 then
        do:
            Logger:Error(substitute('Userid "&1" has too many @s', pcUserName)).
            return error new AppError('Userid incorrectly formatted', 0).
        end.
        
        if pos eq 0 then
            assign cSplitUser[1] = pcUserName.
        else
            assign cSplitUser[1] = substring(pcUserName, 1, pos - 1)
                   cSplitUser[2] = substring(pcUserName, pos + 1)
                   .
        Assert:NotNullOrEmpty(cSplitUser[1], 'User id').
        Assert:NotNull(cSplitUser[2], 'User domain').
        
        return cSplitUser.
    end method.
    
end class.