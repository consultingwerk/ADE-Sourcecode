/************************************************
  Copyright (c) 2016 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : IPasswordPolicyProvider
    Purpose     : Provides an extension point for _User (or other ABL table) -based
                  implementations of an IAuthProvider
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Mon Feb 29 10:22:18 EST 2016
    Notes       : 
  ----------------------------------------------------------------------*/
interface OpenEdge.Security.Provider.IPasswordPolicyProvider:  
    
    /* Hashes a password for storage in the _User table.
       The default implementation uses ENCODE() and so 
       no salt is used.
       
       @param character A mandatory clear-text password
       @param raw An optional salt value
       @return character A string representation of the hashed password */
    method public character HashPassword(input pcPassword as character,
                                         input prSalt as raw).
    
    /* Returns a per-user salt used for hashing (typically) passwords
                  
       @param handle (optional)The ABL table buffer used to calculate/determine 
                     the salt
       @return raw A salt to use for hashing. The caller will determine whether nulls 
                   are allowed */
    method public raw GetUserSalt(input phUserTableBuffer as handle).
    
end interface.