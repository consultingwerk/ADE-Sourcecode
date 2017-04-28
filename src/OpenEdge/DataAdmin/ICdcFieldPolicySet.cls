
/*------------------------------------------------------------------------
    File        : ICdcFieldPolicySet
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : mkondra
    Created     : Fri Nov 20 12:51:35 IST 2015
    Notes       : 
  ----------------------------------------------------------------------*/

using OpenEdge.DataAdmin.IDataAdminCollection from propath.
using OpenEdge.DataAdmin.ICdcFieldPolicy  from propath.   

interface OpenEdge.DataAdmin.ICdcFieldPolicySet inherits IDataAdminCollection:  
    
    method public logical Add(newfpolicy as ICdcFieldPolicy).
    method public logical Remove(fpolicy as ICdcFieldPolicy).
    method public logical CanFind(fpolicyName as char).
    method public logical Contains(fpolicy as ICdcFieldPolicy).
   
    /**
     * 
     * @param  Name
     */
    method public ICdcFieldPolicy Find(fpolicy as char).
  
end interface.