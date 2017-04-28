
/*------------------------------------------------------------------------
    File        : ICdcCollection
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : mkondra
    Created     : Fri Nov 20 14:56:08 IST 2015
    Notes       : 
  ----------------------------------------------------------------------*/

using Progress.Lang.*.
using OpenEdge.DataAdmin.IDataAdminCollection.
using OpenEdge.DataAdmin.ICdc from propath. 

interface OpenEdge.DataAdmin.ICdcCollection inherits IDataAdminCollection: 
    
     method public logical Contains(Cdc as ICdc).  
    
    method public logical CanFindTenant(pcTenant as char,pctable as char,pcField as char, pcIndex as char,pccollection as char).
    method public logical CanFindGroup(pcGroup as char,pctable as char,pcField as char, pcIndex as char,pccollection as char).
    
    method public ICdc FindTenant(pcTenant as char,pctable as char,pcField as char, pcIndex as char,pccollection as char).
    method public ICdc FindGroup(pcgroup as char,pctable as char,pcField as char, pcIndex as char,pccollection as char).
      
  
end interface.