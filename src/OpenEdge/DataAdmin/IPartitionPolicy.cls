/*************************************************************/
/* Copyright (c) 2011,2019 by Progress Software Corporation       */
/*                                                           */
/* all rights reserved.  no part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from progress Software Corporation. */
/*************************************************************/
/*------------------------------------------------------------------------
    Purpose     : interface for partition owner (tenant, group or partition policy)
    Syntax      : 
    Description : 
    Author(s)   : hdaniels
    Created     : Thu Jun 10 00:01:21 EDT 2010
    Notes       : Not mapped directly to any data source  
  ----------------------------------------------------------------------*/
using OpenEdge.DataAdmin.IArea.
using OpenEdge.DataAdmin.IDataAdminElement.
using OpenEdge.DataAdmin.IFieldList.
using OpenEdge.DataAdmin.IIndex.
using OpenEdge.DataAdmin.IIndexSet.
using OpenEdge.DataAdmin.IPartitionMap.
using OpenEdge.DataAdmin.IPartitionParent.
using OpenEdge.DataAdmin.IPartitionPolicyDetailSet.
using OpenEdge.DataAdmin.ITable.
interface OpenEdge.DataAdmin.IPartitionPolicy inherits IPartitionParent :  
      
    /** HasRange 
          return true if the policy last field is  a range component (le value)  -  */    
    define public property HasRange    as logical no-undo         get.  set.
   
   /** Type  read only 
         List, List-range or Range -  */    
    define public property Type    as logical no-undo         get.  
    
    /** IsReadOnly 
          <b>true</b> if the partition is read-only    */    
    define public property IsReadOnly  as logical no-undo      get. set.
    
    /** HasComposite 
          <b>true</b> if the partition has a composite partition   */    
    define public property HasComposite  as logical no-undo    get. 
    
    /** IsCompositeReadOnly 
          <b>true</b> if the partition policy composite partition is read-only    */    
    define public property IsCompositeReadOnly  as logical no-undo    get. set.
    
       /** Num Fields          */    
    define public property NumFields   as integer no-undo      get.
   
    /** The Table of the policy */
    define public property Table       as ITable no-undo   get. set.
       
    /** The local indexes of the policy 
        shorthand for table:Indexes where islocal
        editable in new policy (to make indexes local in same trans) 
        must match table and Fields  */
    define public property Indexes  as IIndexSet no-undo get.  
 
      /** Fields          */  
    define public property Fields      as IFieldList no-undo get. 
    
      /** policy details         */  
    define public property Details     as IPartitionPolicyDetailSet no-undo get. 
    
    /* populate Details from data */
    method logical AddDetailsFromData().
    
    /* populate Details from data using token string to assign name 
       @param TokenString format XX&{<property>}X}  where X is any fixed mask char 
        (except "&~{" or "~}" ) 
       example  "&~{TableName~}-&~{PartitionPolicyName~}-&~{Values[3]}-&~{Values[2]}".
       valid properties are TableName PartitionPolicyName Values[i] (i = field number)
       
     */
    method logical AddDetailsFromData(pcTokenString as char):
        
   /* populate Details from data using substitute string and comma separated list
      of properties to assign name 
       @param TokenString tokens in &n format as ABL substitute statement (max 9) 
       @param Propertiesg comma separated list of props 
       valid properties are TableName PartitionPolicyName Values[i] (i = field number)
     */
    method logical AddDetailsFromData(pcSubstString as char,pcProperties as char):
end interface.