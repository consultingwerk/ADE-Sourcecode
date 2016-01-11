/*************************************************************/
/* Copyright (c) 2011,2013 by progress Software Corporation. */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from progress Software Corporation. */
 /*************************************************************/ 
/*------------------------------------------------------------------------
    Purpose     : Interface needed by all Partioncontext classes including query
    Syntax      : 
    Description : 
    Author(s)   : hdaniels
    Created     : Mon Nov 01 2010
    Notes       : There are realize methods in IPartitionCollection implementations that
                  use this interface to find the TT. (collection Find returns the class) 
                  The iterator:next relies on these to realize the class. 
                   (could be better ways to sync iterator?)   
                - Collections should ideally call the query context with simpler 
                  interfaces. (except area:partitions)                       
----------------------------------------------------------------------*/
using OpenEdge.DataAdmin.IDataAdminElement.
using Progress.Lang.*.

interface OpenEdge.DataAdmin.Binding.IPartitionContext:  
   
    method public logical Allocate().
    
    method public logical CanFindTenant(pcTenant as char,pctable as char,pcField as char, pcIndex as char,pccollection as char).
    method public logical CanFindGroup(pcGroup as char,pctable as char,pcField as char, pcIndex as char,pccollection as char).
    method public logical CanFindPolicyDetail(pcDetail as char,pctable as char,pcField as char, pcIndex as char,pccollection as char).
  
    method public logical FindTenant(pcTenant as char,pctable as char,pcField as char, pcIndex as char,pccollection as char).
    method public logical FindGroup(pcGroup as char,pctable as char,pcField as char, pcIndex as char,pccollection as char).
    method public logical FindPolicyDetail(pcDetail as char,pctable as char,pcField as char, pcIndex as char,pccollection as char).
   
    method public IDataAdminElement FindTenantEntity(pcTenant as char,pctable as char,pcField as char, pcIndex as char,pccollation as char):
    method public IDataAdminElement FindGroupEntity(pcGroup as char,pctable as char,pcField as char, pcIndex as char,pccollation as char):
    method public IDataAdminElement FindPolicyDetailEntity(pcDetail as char,pctable as char,pcField as char, pcIndex as char,pccollation as char):
     
end interface.