/************************************************
  Copyright (c) 2016 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : IAuthProvider
    Purpose     : Defines an interface for interacting with an OE Authentication
                  Provider from an STS. 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Thu Feb 11 09:53:15 EST 2016
    Notes       : * Based on the Progress.Security.Realm.IHybridRealm interface
  ----------------------------------------------------------------------*/
interface OpenEdge.Security.Provider.IAuthProvider:  
/** CREDENTIAL CHECKS **/
    
    /* Validates that the username is in the realm, and returns a unique identifier for 
       the user (which may be the username@domain).
       
       @param character The client-supplied username
       @return character A unique identifier for the user */
    method public character ValidateUser(input pcUserName as character ).
    
    /* Simple, clear-text password validation for a user
              
       @param character A unique userid
       @param character The user's (cleartext) password to verify 
       @return logical TRUE if the provide credentials match the realm's values */
    method public logical ValidatePassword(input pcUserId as character, 
                                           input pcPassword as character ).

    /* Digest-encoded password validation for a user
       
       @param character A unique userid 
       @param character The hashed digest of the password to verify
       @param character The nonce value used to create the digest hash 
       @param character The timestamp value used to create the digest hash 
       @return logical TRUE if the provide credentials match the realm's values */
    method public logical ValidatePassword(input pcUserId as character, 
                                           input pcDigest as character,
                                           input pcNonce as character,
                                           input pcTimestamp as character ).

    
/** ATTRIBUTE OPERATIONS **/
    
    /* Retrieves a value for the a requested attribute, per user
       
       @param character A unique userid
       @param character The name of the attribute for which to return a value
       return character An attribute value for the given user. May be empty or unknown. */
    method public character GetAttribute(input pcUserId as character, 
                                         input pcAttributeName as character ).

    /* Returns an array of attributes for a given user
    
       @param character A unique userid
       @return character[] An array of attribute names. */
    method public character extent GetAttributeNames(input pcUserId as character ).
    
    /* Sets an attribute's value for a user. May optionally create an attribute value.
       
       @param character A unique userid
       @param character The name of the attribute to remove
       @param character The value to apply 
       @return logical TRUE if the attribute value was successfully set; FALSE otherwise */
    method public logical SetAttribute(input pcUserId as character, 
                                       input pcAttributeName as character, 
                                       input pcAttributeValue as character ).

    
end interface.