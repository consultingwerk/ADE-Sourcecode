/************************************************
  Copyright (c) 2016 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : UserTablePasswordProvider
    Purpose     : Default password policy provider for _USER tables.
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Mon Feb 29 15:52:19 EST 2016
    Notes       : * Uses the ENCODE hash algorithm 
                  * provides no salt value
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Assert.
using OpenEdge.Security.Provider.IPasswordPolicyProvider.

class OpenEdge.Security.Provider.UserTablePasswordProvider implements IPasswordPolicyProvider: 
    /* Returns a per-user salt used for hashing (typically) passwords
       
       @param handle The _User buffer to use
       @return raw A salt to use for hashing */
    {&_proparse_ prolint-nowarn(varusage)}
    method public raw GetUserSalt(input phUserTableBuffer as handle):
        {&_proparse_ prolint-nowarn(varusage)}
        define variable rSalt as raw no-undo.
        
        /**
            Example:      
              assign cHashed = base64-encode(generate-pbe-key(pcPassword, prSalt)).
              // use a per-user salt
              message-digest('sha-512', 
                             substitute('&1@&2', lc(ApplicationUser.LoginName), lc(ApplicationUser.LoginDomain))))). 
         */
        return rSalt.
    end method.
    
    /* Hashes a password for storage in the _User table.
       The default implementation uses ENCODE() and so 
       no salt is used.
       
       @param character A mandatory clear-text password
       @param raw An optional salt value
       @return character A string representation of the hashed password */
    method public character HashPassword(input pcPassword as character,
                                            input prSalt as raw):
        Assert:NotNull(pcPassword, 'Password').
        
        /* an override might use the ENCRYPT() function instead */
        return encode(pcPassword).
    end method.
    
end class.