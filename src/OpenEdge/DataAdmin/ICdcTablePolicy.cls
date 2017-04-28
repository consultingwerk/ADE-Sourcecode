/* ***********************************************************/
/* Copyright (c) 2015-2016 by Progress Software Corporation  */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from Progress Software Corporation. */
/*************************************************************/

/*------------------------------------------------------------------------
    File        : ICdcTablePolicy
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : mkondra
    Created     : Thu Nov 19 17:49:17 IST 2015
    Notes       : 
  ----------------------------------------------------------------------*/

using OpenEdge.DataAdmin.IArea.
using OpenEdge.DataAdmin.IDataAdminElement.
using OpenEdge.DataAdmin.IFieldList.
using OpenEdge.DataAdmin.IIndex.
using OpenEdge.DataAdmin.IIndexSet.
//using OpenEdge.DataAdmin.ICdcMap.
using OpenEdge.DataAdmin.IPartitionParent.
using OpenEdge.DataAdmin.ICdcFieldPolicySet.
using OpenEdge.DataAdmin.ITable.
using OpenEdge.DataAdmin.CdcTablePolicyStateEnum.
using OpenEdge.DataAdmin.CdcTablePolicyLevelEnum.
using OpenEdge.DataAdmin.Internal.Util.CdcTablePolicyInstanceEnum.
//using OpenEdge.DataAdmin.ICdcTablePolicyField. 

interface OpenEdge.DataAdmin.ICdcTablePolicy inherits IPartitionParent:  
    
      
    define public property State    as CdcTablePolicyStateEnum no-undo         get.  set.
    
    //define public property CdcTablePolicyName    as char no-undo         get.  set.
    
    define public property CdcPolicyId as char no-undo         get.   
  
    define public property Instance    as CdcTablePolicyInstanceEnum no-undo         get.     
    
    define public property IdentifyingField  as logical no-undo      get. set.
    
    define public property Level  as CdcTablePolicyLevelEnum no-undo      get. set.    
     
    define public property EncryptPolicy  as logical no-undo    get.  set.     
    
    //define public property IdentifyingFieldsUnique  as logical no-undo    get. set.
    
       /** Num Fields          */    
    define public property NumFields   as integer no-undo      get.
   
    /** The Table of the policy */
    define public property Table       as ITable no-undo   get. set.
    
    define public property DataArea       as IArea no-undo   get. set.
    
    define public property IndexArea       as IArea no-undo   get. set.
    
    define public property ChangeTable       as char no-undo   get. set.
    
    define public property ChangeTableOwner       as char no-undo   get. set. 
    
    //define public property SourceTableOwner       as char no-undo   get. 
    
    define public property LastModified       as datetime-tz no-undo   get.  
    
    define public property Misc       as character extent 16 no-undo   get.  
       
    /** The local indexes of the policy 
        shorthand for table:Indexes where islocal
        editable in new policy (to make indexes local in same trans) 
        must match table and Fields  */
    define public property Indexes  as IIndexSet no-undo get.  
 
      /** Fields          */  
    define public property Fields      as IFieldList no-undo get. 
    
      /** field policies         */  
    define public property FieldPolicies     as ICdcFieldPolicySet no-undo get. 
    
    /* populate fields from data */
    method logical AddFieldsFromData().
    
    
    method logical AddFieldsFromData(pcTokenString as char):
        
   
    method logical AddFieldsFromData(pcSubstString as char,pcProperties as char):
  
end interface.