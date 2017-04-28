/************************************************
  Copyright (c) 2016 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    Purpose     : A set of security roles 
    Syntax      : 
    Description : 
    Author(s)   : 
    Created     :  
    Notes       : 
  ----------------------------------------------------------------------*/
using OpenEdge.DataAdmin.IDataAdminCollection.
using OpenEdge.DataAdmin.IDatabaseOption.

interface OpenEdge.DataAdmin.IDatabaseOptionSet inherits IDataAdminCollection: 
    
    /* Remove a role from the collection
       
       @param IDatabaseOption The option to remove
       @return logical TRUE if the option was removed from the set */
    method public logical Remove(input poDbOption as IDatabaseOption).
   
    /* Add a dboption to the collection
       
       @param IDatabaseOption The dboption to add
       @return logical TRUE if the option was added to the set */
    method public logical Add(input poDbOption as IDatabaseOption).
    
    /* Return true if a dboption with the specified code is in the collection 
        
       @param character The code of the DBoption
       @return logical TRUE if a role with the given name exists in the collection */
    method public logical CanFind(input pcCode as character).
    
    /* Return true if the DbOption is in the collection
       
       @param IDatabaseOption The DBOtion 
       @return logical TRUE if a role with the given name exists in the collection */
    method public logical Contains(input poRole  as IDatabaseOption).
    
    /** Return the Role with the specified Name from the collection.
        Returns unknown if not found. */
    method public IDatabaseOption Find(input pcCode as character).
    
end interface.