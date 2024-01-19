/************************************************
  Copyright (c) 2016 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    Purpose     : A set of security roles 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : 2016-04-26
    Notes       : 
  ----------------------------------------------------------------------*/

using OpenEdge.DataAdmin.IDataAdminCollection.
using OpenEdge.DataAdmin.IRole.

interface OpenEdge.DataAdmin.IRoleSet inherits IDataAdminCollection: 
    
    /* Remove a role from the collection
       
       @param IRole The role to remove
       @return logical TRUE if the role was removed from the set */
    method public logical Remove(input poRole as IRole).
   
    /* Add a role to the collection
       
       @param IRole The role to remove
       @return logical TRUE if the role was added from the set */
    method public logical Add(input poRole as IRole).
    
    /* Return true if a Role with the specified Name is in the collection 
        
       @param character The name of the role to find
       @return logical TRUE if a role with the given name exists in the collection */
    method public logical CanFind(input pcName as character).
    
    /* Return true if the Role is in the collection
       
       @param IRole The role to find
       @return logical TRUE if a role with the given name exists in the collection */
    method public logical Contains(input poRole as IRole).
    
    /** Return the Role with the specified Name from the collection.

        @param character The name of the role to find
        @return IRole The role object found, otherwise returns unknown */
    method public IRole Find(input pcName as character).
    
end interface.