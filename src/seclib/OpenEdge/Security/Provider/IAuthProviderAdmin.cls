/************************************************
  Copyright (c) 2016 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : IAuthProviderAdmin
    Purpose     : Defines an interface for interacting with an OE Authentication
                  Provider from an STS. 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Thu Feb 11 09:53:15 EST 2016
    Notes       : * Based on the Progress.Security.Realm.IHybridRealm interface
  ----------------------------------------------------------------------*/
using OpenEdge.Security.Provider.IAuthProvider.

interface OpenEdge.Security.Provider.IAuthProviderAdmin inherits IAuthProvider:  
    
/** ATTRIBUTE OPERATIONS **/

    /* Removes an attribute value for a user.
       
       @param character A unique userid
       @param character The name of the attribute to remove
       @return logical TRUE if the attribute value was successfully removed; FALSE otherwise */
    method public logical RemoveAttribute(input pcUserId as character, 
                                          input pcAttributeName as character ).
    
/** QUERIES **/
    /* Returns an array of all user names in this realm
       
       @return character[] An array of user names. */
    method public character extent GetUserNames().
    
    /* Returns a filtered array of user names in this realm
       
       @param character A query filter string to select the user names to return. The format depends on
                        the realm implementation 
       @return character[] An array of user names. */
    method public character extent GetUserNamesByQuery(input pcQueryString as character ).

end interface.