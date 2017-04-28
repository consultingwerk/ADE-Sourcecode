/*------------------------------------------------------------------------
    Purpose     : A set of granted security roles 
    Syntax      : 
    Description : 
    Author(s)   : 
    Created     :  
    Notes       : 
  ----------------------------------------------------------------------*/

using OpenEdge.DataAdmin.IDataAdminCollection.
using OpenEdge.DataAdmin.IGrantedRole.

interface OpenEdge.DataAdmin.IGrantedRoleSet inherits IDataAdminCollection: 
    
    /* Remove a role from the collection
       
       @param IGrantedRole The grant to remove
       @return logical TRUE if the role was removed from the set */
    method public logical Remove(input poRole as IGrantedRole).
   
    /* Add a role to the collection
       
       @param IGrantedRole The grant to add
       @return logical TRUE if the role was added from the set */
    method public logical Add(input poRole as IGrantedRole).
    
    /* Return true if a Role  with the specified id is in the collection 
       
       @param character The id of the grant
       @return logical TRUE if a role with the given name exists in the collection */
    method public logical CanFind(input pcId as character).
    
    /* Return true if the grant is in the collection
       
       @param IGrantedRole The name of the role
       @return logical TRUE if a role with the given name exists in the collection */
    method public logical Contains(input poRole  as IGrantedRole).
    
    /** Return the grant with the specified id in the collection.
        Returns unknown if not found. */
    method public IGrantedRole Find(input pcId as character).
    
end interface.