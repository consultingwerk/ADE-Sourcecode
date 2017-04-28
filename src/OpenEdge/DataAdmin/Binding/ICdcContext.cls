
/*------------------------------------------------------------------------
    File        : ICdcContext
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : mkondra
    Created     : Tue Dec 01 12:43:07 IST 2015
    Notes       : 
  ----------------------------------------------------------------------*/

using Progress.Lang.*.
using OpenEdge.DataAdmin.IDataAdminElement.

interface OpenEdge.DataAdmin.Binding.ICdcContext: 
    
    method public logical CanFindTenant(pcTenant as char,pctable as char,pcField as char, pcIndex as char,pccollection as char).
    method public logical CanFindGroup(pcGroup as char,pctable as char,pcField as char, pcIndex as char,pccollection as char).
    method public logical CanFindFieldPolicy(pcFPolicy as char,pctable as char,pcField as char, pcIndex as char,pccollection as char).
  
    method public logical FindTenant(pcTenant as char,pctable as char,pcField as char, pcIndex as char,pccollection as char).
    method public logical FindGroup(pcGroup as char,pctable as char,pcField as char, pcIndex as char,pccollection as char).
    method public logical FindFieldPolicy(pcFPolicy as char,pctable as char,pcField as char, pcIndex as char,pccollection as char).
   
    method public IDataAdminElement FindTenantEntity(pcTenant as char,pctable as char,pcField as char, pcIndex as char,pccollation as char):
    method public IDataAdminElement FindGroupEntity(pcGroup as char,pctable as char,pcField as char, pcIndex as char,pccollation as char):
    method public IDataAdminElement FindFieldPolicyEntity(pcFPolicy as char,pctable as char,pcField as char, pcIndex as char,pccollation as char): 
  
end interface.