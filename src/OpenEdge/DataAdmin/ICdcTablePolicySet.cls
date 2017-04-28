
/*------------------------------------------------------------------------
    File        : ICdcPolicySet
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : mkondra
    Created     : Thu Nov 19 18:48:49 IST 2015
    Notes       : 
  ----------------------------------------------------------------------*/

using Progress.Lang.*.
using OpenEdge.DataAdmin.IDataAdminCollection.
using OpenEdge.DataAdmin.ICdcTablePolicy.

interface OpenEdge.DataAdmin.ICdcTablePolicySet inherits IDataAdminCollection:  
    
    method public logical Add(newpolicy as ICdcTablePolicy). 
    method public logical Remove(policy as ICdcTablePolicy).
    method public logical CanFind(policy as char).
    method public logical Contains(policy as ICdcTablePolicy).
     
    /**
     * 
     * @param groupName
     */
    method public ICdcTablePolicy Find(policy as char).
  
end interface.