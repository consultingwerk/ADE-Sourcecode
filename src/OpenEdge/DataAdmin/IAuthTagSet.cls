/************************************************
  Copyright (c) 2023 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    Purpose     : A set of security roles and auth tags
    Syntax      : 
    Description : 
    Author(s)   : dugrau
    Created     : 2023-07-24
    Notes       : 
  ----------------------------------------------------------------------*/

using OpenEdge.DataAdmin.IDataAdminCollection.
using OpenEdge.DataAdmin.IAuthTag.

interface OpenEdge.DataAdmin.IAuthTagSet inherits IDataAdminCollection: 
    
    /* Remove an auth tag from the collection
       
       @param IAuthTag The role/tag to remove
       @return logical TRUE if the item was removed from the set */
    method public logical Remove(input poAuthTag as IAuthTag).
   
    /* Add an auth tag to the collection
       
       @param IAuthTag The role/tag to add
       @return logical TRUE if the item was added from the set */
    method public logical Add(input poAuthTag as IAuthTag).
    
    /* Return true if the specified auth tag is in the collection 
        
       @param character The auth tag name to find
       @return logical TRUE if an auth tag with the given name exists in the collection */
    method public logical CanFind(input pcAuthTag as character).
    
    /* Return true if the Role/AuthTag is in the collection
       
       @param IAuthTag The role/tag to find
       @return logical TRUE if a role/tag with the given name exists in the collection */
    method public logical Contains(input poAuthTag  as IAuthTag).
    
    /** Return the AuthTag with the specified auth tag from the collection.

        @param character The auth tag name to find
       @return IAuthTag Returns an AuthTag if found, otherwise unknown */
    method public IAuthTag Find(input pcAuthTag as character).
    
end interface.