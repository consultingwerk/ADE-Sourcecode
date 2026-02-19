/************************************************
  Copyright (c) 2016,2025 by Progress Software Corporation. All rights reserved.
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

       @param handle (optional) The ABL [user] table buffer used to calculate/determine the salt
       @return raw A salt to use for hashing. The caller will determine whether nulls are allowed */
    {&_proparse_ prolint-nowarn(varusage)}
    method public raw GetUserSalt(input phUserTableBuffer as handle):
        {&_proparse_ prolint-nowarn(varusage)}
        define variable rSalt as raw no-undo.

        /**
            Example:      
              assign rSalt = generate-salt([16-512]).
         */

        // Default: No salt value is created nor needed for the _User table
        // which pre-salts for the default "_oeuser-uphA1" hash algorithm.
        return rSalt.
    end method.

    /* Hashes a password for storage with (typically) a user account.

       By default this demonstrates use with the standard _User table.

       The default implementation uses GENERATE-PASSWORD-HASH() with "_oeuser-uphA1"
       and ignores any salt value passed.

       Additionally, an override of this method might use a different hashing algorithm.

       @param character A mandatory clear-text password
       @param raw An optional salt value
       @return character A string representation of the hashed password */
    method public character HashPassword(input pcPassword as character,
                                         input prSalt as raw):
        Assert:NotNull(pcPassword, 'Password':u).

        // As of OpenEdge 13 the _User table by default expects passwords with the "uphA1::" prefix,
        // as created by the generate-password-hash function with a hash algorithm of "_oeuser-uphA1".
        // Note: The optional prSalt parameter is ignored for "_oeuser-uphA1" as that algorithm forces
        // the use of a random salt value on each and every function call, so no salt is needed here.

        return generate-password-hash(pcPassword, ?, '_oeuser-uphA1':u).
    end method.
    
end class.